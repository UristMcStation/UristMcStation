
/* The most fundamental pathfinding proc here;
// the rest are higher-level abstractions and
// integrations w/ other subsystems (e.g. memory)
*/
/datum/goai/mob_commander/proc/ChoosePanicRunLandmark(var/atom/primary_threat = null, var/list/threats = null, min_safe_dist = null, var/atom/explicit_obstruction = null)
	var/atom/pawn = src.GetPawn()
	if(!pawn)
		ACTION_RUNTIME_DEBUG_LOG("[src] does not have an owned mob!")
		return

	// Pathfinding/search
	var/turf/best_local_pos = brain?.GetMemoryValue(MEM_BESTPOS_PANIC, null)
	if(best_local_pos)
		return best_local_pos

	var/list/_threats = (threats || list())
	var/_min_safe_dist = (isnull(min_safe_dist) ? 0 : min_safe_dist)

	var/list/processed = list()
	var/PriorityQueue/cover_queue = new /PriorityQueue(/datum/Quadruple/proc/TriCompare)

	var/list/curr_view = brain?.perceptions?.Get(SENSE_SIGHT_CURR) || list()

	var/turf/last_loc = brain?.GetMemoryValue("Location-1", null)
	if(last_loc)
		curr_view.Add(last_loc)

	var/turf/prev_to_last_loc = brain?.GetMemoryValue("Location-2", null)
	if(prev_to_last_loc)
		curr_view.Add(prev_to_last_loc)

	var/turf/safespace_loc = brain?.GetMemoryValue(MEM_SAFESPACE, null)
	if(safespace_loc)
		curr_view.Add(safespace_loc)

	var/turf/unreachable = brain?.GetMemoryValue("UnreachableTile", null)
	var/datum/chunkserver/chunkserver = GetOrSetChunkserver()

	var/my_loc = get_turf(pawn)
	var/mob/pawn_mob = pawn

	for(var/turf/cand in curr_view)
		sleep(-1)
		// NOTE: This is DIFFERENT to cover moves! We're not doing a double-loop here!

		if(cand in processed)
			continue

		if(unreachable && cand == unreachable)
			continue

		if(!(pawn_mob && istype(pawn_mob)))
			if(!(pawn_mob.MayEnterTurf(cand)))
				continue

		/*if(!(cand in curr_view))
			continue*/

		var/penalty = 0
		var/threat_dist = 0
		var/heat = 0

		var/datum/chunk/candchunk = chunkserver.ChunkForAtom(cand)

		for(var/dict/threat_ghost in _threats)

			if(threat_ghost)

				threat_dist = GetThreatDistance(cand, threat_ghost)
				var/datum/chunk/threatchunk = GetThreatChunk(threat_ghost)

				if(threat_dist < _min_safe_dist)
					heat++

				else if(threatchunk == candchunk)
					heat++

		if(heat == 1)
			penalty += MAGICNUM_DISCOURAGE_SOFT

		if(heat >= 2)
			continue

		var/cand_dist = ManhattanDistance(cand, my_loc)
		//var/targ_dist = (waypoint ? ManhattanDistance(cand, waypoint) : 0) // ignore waypoint, just leg it!

		penalty += -threat_dist  // the further from a threat, the better

		var/datum/Quadruple/cover_quad = new(threat_dist*2 - cand_dist, -penalty, -cand_dist, cand)
		cover_queue.Enqueue(cover_quad)
		processed.Add(cand)

	best_local_pos = ValidateWaypoint(cover_queue, FALSE)

	if(best_local_pos)
		src.SpotObstacles(owner = src, target = best_local_pos, default_to_waypoint = FALSE, obstruction_tag = "PANIC")

		// Obstacles:
		var/atom/obstruction = explicit_obstruction

		if(isnull(obstruction) || !(istype(obstruction)))
			obstruction = brain.GetMemoryValue(MEM_OBSTRUCTION("PANIC"))

		var/handled = isnull(obstruction) // if obs is null, counts as handled

		if(obstruction)
			var/list/shared_preconds = list(

			)

			var/list/movement_preconds = list(
				STATE_PANIC = TRUE,
			)

			handled = HandleWaypointObstruction(
				obstruction = obstruction,
				waypoint = best_local_pos,
				shared_preconds = shared_preconds,
				target_preconds = movement_preconds,
				move_action_name = "PanicRun",
				move_handler = /datum/goai/mob_commander/proc/HandlePanickedRun,
				unique = FALSE,
				allow_failed = TRUE
			)

		if(!handled)
			handled = handled // tricking the compiler :^)
			ACTION_RUNTIME_DEBUG_LOG("Couldn't handle obstruction [obstruction]")

	if(best_local_pos)
		brain?.SetMemory(MEM_BESTPOS_PANIC, best_local_pos, PANIC_SENSE_THROTTLE*30)

	return best_local_pos


/* Wrapper over ChoosePanicRunLandmark();
//
// Adds integrations w/ Threat system and ActionTracker data, but is otherwise
// generally stateless (not *fully*, b/c we call some potentially impure methods)
*/
/datum/goai/mob_commander/proc/pureHandleChoosePanicRunLandmark(var/datum/goai/mob_commander/owner = null, var/atom/bestpos = null, var/min_safe_dist = 2, var/list/cached_threats = null)
	// Abstracted ownership, but defaults to src for convenience.
	var/datum/goai/mob_commander/true_owner = (owner || src)

	var/atom/pawn = true_owner.GetPawn()
	if(!pawn)
		ACTION_RUNTIME_DEBUG_LOG("[src] does not have an owned mob!")
		return

	var/turf/best_local_pos = null
	best_local_pos = (best_local_pos || bestpos)

	if(best_local_pos)
		return

	var/list/threats = (cached_threats ? cached_threats.Copy() : list())
	var/primary_threat = threats?[1]

	// Run pathfind
	best_local_pos = true_owner.ChoosePanicRunLandmark(primary_threat, threats, min_safe_dist)

	return best_local_pos


/* Wrapper over pureHandleChoosePanicRunLandmark();
//
// Adds a full integration w/ ActionTracker and thus can run
// as a GOAI Action. Also provides defaults, caching, etc.
*/
/datum/goai/mob_commander/proc/HandleChoosePanicRunLandmark(var/datum/ActionTracker/tracker)
	var/atom/pawn = src.GetPawn()
	if(!pawn)
		ACTION_RUNTIME_DEBUG_LOG("[src] does not have an owned mob!")
		return

	var/turf/best_local_pos = brain?.GetMemoryValue(MEM_BESTPOS_PANIC, null)
	best_local_pos = best_local_pos || tracker?.BBGet(MEM_BESTPOS_PANIC, null)

	if(best_local_pos)
		return

	var/list/threats = list()
	var/min_safe_dist = (brain?.GetPersonalityTrait(KEY_PERS_MINSAFEDIST, null) || 2)

	// Main threat:
	var/dict/primary_threat_ghost = GetActiveThreatDict()
	var/datum/Tuple/primary_threat_pos_tuple = GetThreatPosTuple(primary_threat_ghost)
	var/atom/primary_threat = null
	if(!(isnull(primary_threat_pos_tuple?.left) || isnull(primary_threat_pos_tuple?.right)))
		primary_threat = locate(primary_threat_pos_tuple.left, primary_threat_pos_tuple.right, pawn.z)

	if(primary_threat_ghost)
		threats[primary_threat_ghost] = primary_threat

	// Secondary threat:
	var/dict/secondary_threat_ghost = GetActiveSecondaryThreatDict()
	var/datum/Tuple/secondary_threat_pos_tuple = GetThreatPosTuple(secondary_threat_ghost)
	var/atom/secondary_threat = null
	if(!(isnull(secondary_threat_pos_tuple?.left) || isnull(secondary_threat_pos_tuple?.right)))
		secondary_threat = locate(secondary_threat_pos_tuple.left, secondary_threat_pos_tuple.right, pawn.z)

	if(secondary_threat_ghost)
		threats[secondary_threat_ghost] = secondary_threat

	// Run pathfind
	best_local_pos = pureHandleChoosePanicRunLandmark(
		src,
		best_local_pos,
		primary_threat,
		min_safe_dist,
		threats
	)

	if(best_local_pos)
		tracker?.BBSet(MEM_BESTPOS_PANIC, best_local_pos)
		tracker?.SetDone()

		brain?.SetMemory(MEM_BESTPOS_PANIC, best_local_pos)

	else if(src.active_path && tracker?.IsOlderThan(COMBATAI_MOVE_TICK_DELAY * 5))
		tracker?.SetFailed()

	return best_local_pos


/* And now for something completely different...
//
// This is the *actual* logic for Running The Hell Away.
//
*/

/datum/goai/mob_commander/proc/fPanicRunDistance(var/S, var/T)
	if(!S || !T)
		return

	var/turf/s = get_turf(S)
	var/turf/t = get_turf(T)

	if(!s || !t)
		return

	var/base_dist = fObstaclePenaltyDistance(S, T)
	var/threat_penalty = 0

	var/dict/primary_threat_ghost = GetActiveThreatDict()
	var/datum/Tuple/primary_threat_pos_tuple = GetThreatPosTuple(primary_threat_ghost)
	var/atom/primary_threat = null

	var/atom/pawn = src.GetPawn()

	if(!(isnull(primary_threat_pos_tuple?.left) || isnull(primary_threat_pos_tuple?.right)))
		primary_threat = locate(primary_threat_pos_tuple.left, primary_threat_pos_tuple.right, pawn?.z)

	var/turf/threat_turf = null
	if(primary_threat)
		threat_turf = get_turf(primary_threat)

		// IDEA: Gradient of cost. We want to move from more threatened turf to a <= threatened one.
		// e.g. in Start is 2 tiles from threat and T is 3, we good. T=2 & S=3, avoid T if possible.
		var/s_dist = ManhattanDistance(s, threat_turf)
		var/t_dist = ManhattanDistance(t, threat_turf)

		var/delta_threat = max(0, (s_dist - t_dist))
		// Multipliers etc. Might change the formula later.
		threat_penalty += delta_threat * 5

	var/total_dist = base_dist + threat_penalty
	return total_dist



/datum/goai/mob_commander/proc/HandlePanickedRun(var/datum/ActionTracker/tracker, var/atom/obstruction = null)
	var/atom/pawn = src.GetPawn()
	if(!pawn)
		ACTION_RUNTIME_DEBUG_LOG("[src] does not have an owned mob!")
		return

	var/tracker_frustration = tracker?.BBSetDefault("frustration", 0)

	var/turf/best_local_pos = null
	best_local_pos = best_local_pos || tracker?.BBGet(MEM_BESTPOS_PANIC, null)

	if(isnull(best_local_pos))
		best_local_pos = brain?.GetMemoryValue(MEM_BESTPOS_PANIC, null)

	var/min_safe_dist = (brain?.GetPersonalityTrait(KEY_PERS_MINSAFEDIST) || 2)
	var/frustration_repath_maxthresh = brain.GetPersonalityTrait(KEY_PERS_FRUSTRATION_THRESH, null) || 3

	var/list/threats = new()

	// Main threat:
	var/dict/primary_threat_ghost = GetActiveThreatDict()
	var/datum/Tuple/primary_threat_pos_tuple = GetThreatPosTuple(primary_threat_ghost)
	var/atom/primary_threat = null
	if(!(isnull(primary_threat_pos_tuple?.left) || isnull(primary_threat_pos_tuple?.right)))
		primary_threat = locate(primary_threat_pos_tuple.left, primary_threat_pos_tuple.right, pawn.z)

	if(primary_threat_ghost)
		threats[primary_threat_ghost] = primary_threat

	// Secondary threat:
	var/dict/secondary_threat_ghost = GetActiveSecondaryThreatDict()
	var/datum/Tuple/secondary_threat_pos_tuple = GetThreatPosTuple(secondary_threat_ghost)
	var/atom/secondary_threat = null
	if(!(isnull(secondary_threat_pos_tuple?.left) || isnull(secondary_threat_pos_tuple?.right)))
		secondary_threat = locate(secondary_threat_pos_tuple.left, secondary_threat_pos_tuple.right, pawn.z)

	if(secondary_threat_ghost)
		threats[secondary_threat_ghost] = secondary_threat

	// Shot-at logic (avoid known currently unsafe positions):
	/*
	var/datum/memory/shot_at_mem = brain?.GetMemory(MEM_SHOTAT, null, FALSE)
	var/dict/shot_at_memdata = shot_at_mem?.val
	var/datum/Tuple/shot_at_where = shot_at_memdata?.Get(KEY_GHOST_POS_TUPLE, null)
	*/

	// Reuse cached solution if it's good enough
	if(isnull(best_local_pos) && src.active_path && (!(src.active_path.IsDone())) && src.active_path.target && src.active_path.frustration < 2)
		best_local_pos = src.active_path.target

	// Required for the following logic: next location on the path
	var/atom/next_step = ((src.active_path && src.active_path.path && src.active_path.path.len) ? src.active_path.path[1] : null)

	// Bookkeeping around threats
	for(var/dict/threat_ghost in threats)
		if(isnull(threat_ghost))
			continue

		var/atom/curr_threat = threats[threat_ghost]
		var/next_step_threat_distance = (next_step ? GetThreatDistance(next_step, threat_ghost, PLUS_INF) : PLUS_INF)
		var/curr_threat_distance = GetThreatDistance(pawn, threat_ghost, PLUS_INF)
		var/bestpos_threat_distance = GetThreatDistance(best_local_pos, threat_ghost, PLUS_INF)

		var/atom/bestpos_threat_neighbor = (curr_threat ? get_step_towards(best_local_pos, curr_threat) : null)

		// Reevaluating plans as new threats pop up
		var/bestpos_is_unsafe = (bestpos_threat_distance < min_safe_dist && !(bestpos_threat_neighbor?.IsCover(TRUE, get_dir(bestpos_threat_neighbor, curr_threat), FALSE)))
		var/currpos_is_unsafe = (
			(tracker_frustration < frustration_repath_maxthresh) && (curr_threat_distance <= min_safe_dist) && (next_step_threat_distance < curr_threat_distance)
		)

		if(bestpos_is_unsafe || currpos_is_unsafe)
			if(tracker_frustration <= 3)
				tracker.BBSet("frustration", tracker_frustration+1)

				CancelNavigate()
				best_local_pos = null
				tracker.BBSet(MEM_BESTPOS_PANIC, null)
				brain?.DropMemory(MEM_BESTPOS_PANIC)
				break



	if(isnull(best_local_pos))
		best_local_pos = ChoosePanicRunLandmark(primary_threat, threats, min_safe_dist, obstruction)
		tracker.BBSet(MEM_BESTPOS_PANIC, best_local_pos)
		brain?.SetMemory(MEM_BESTPOS_PANIC, best_local_pos, PANIC_SENSE_THROTTLE*3)
		ACTION_RUNTIME_DEBUG_LOG((isnull(best_local_pos) ? "[src]: Best local pos: null" : "[src]: Best local pos ([best_local_pos?.x], [best_local_pos?.y])"))

	if(best_local_pos && (!src.active_path || src.active_path.target != best_local_pos))
		// CORE MOVEMENT TRIGGER - FOUND POSITION, START PATHING TO IT
		ACTION_RUNTIME_DEBUG_LOG("[src]: Navigating to [best_local_pos]")
		var/turf/threat_turf = get_turf(primary_threat)
		var/new_path = StartNavigateTo(best_local_pos, 0, threat_turf, 0, /datum/goai/mob_commander/proc/fPanicRunDistance)

		if(!new_path)
			src.WalkPawnAwayFrom(threat_turf)

	if(best_local_pos)
		var/dist_to_pos = ManhattanDistance(get_turf(pawn), best_local_pos)
		if(dist_to_pos < 1)
			tracker.SetTriggered()

	var/is_triggered = tracker.IsTriggered()
	var/datum/brain/concrete/needybrain = brain

	if(is_triggered)
		if(tracker.TriggeredMoreThan(src.ai_tick_delay))
			tracker.SetDone()

			if(needybrain)
				needybrain.ChangeMotive(NEED_COMPOSURE, NEED_SAFELEVEL)


	else if(src.active_path && tracker.IsOlderThan(COMBATAI_MOVE_TICK_DELAY * 20))
		brain?.SetMemory("UnreachableTile", src.active_path.target, MEM_TIME_LONGTERM)
		walk_away(src, primary_threat || secondary_threat || get_turf(pawn))
		tracker.SetFailed()


	else if(tracker.IsOlderThan(COMBATAI_MOVE_TICK_DELAY * 10))
		walk_away(src, primary_threat || secondary_threat || get_turf(pawn))
		tracker.SetFailed()

	return
