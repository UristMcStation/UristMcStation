/datum/utility_ai/mob_commander/proc/ChooseCoverleapLandmark(var/atom/startpos, var/atom/primary_threat = null, var/turf/prev_loc_memdata = null, var/list/threats = null, var/min_safe_dist = null, var/trust_first = null)
	var/atom/pawn = src.GetPawn()

	if(!istype(pawn))
		ACTION_RUNTIME_DEBUG_LOG("No owned mob found for [src.name] AI @ L[__LINE__] in [__FILE__]")
		return FALSE

	// Pathfinding/search
	var/atom/_startpos = (startpos || get_turf(pawn))
	var/list/_threats = (threats || src.brain?.GetMemoryValue(MEM_ENEMIES) || list())
	var/_min_safe_dist = (isnull(min_safe_dist) ? 3 : min_safe_dist)

	var/turf/best_local_pos = null
	//var/list/processed = list(_startpos)
	var/list/processed = list()

	var/PriorityQueue/cover_queue = new DEFAULT_PRIORITY_QUEUE_IMPL(/datum/Quadruple/proc/TriCompare)

	var/datum/chunkserver/chunkserver = GetOrSetChunkserver()
	var/datum/chunk/startchunk = chunkserver.ChunkForAtom(_startpos)

	var/list/curr_view = brain?.perceptions?.Get(SENSE_SIGHT_CURR) || oview(pawn) // remove oview!
	curr_view?.Add(_startpos)

	var/turf/safespace_loc = brain?.GetMemoryValue(MEM_SAFESPACE, null)
	if(safespace_loc)
		curr_view.Add(safespace_loc)

	var/effective_waypoint_x = null
	var/effective_waypoint_y = null

	var/mob/pawn_mob = pawn

	var/atom/waypoint_ident = brain?.GetMemoryValue(MEM_WAYPOINT_IDENTITY, null, FALSE, TRUE)
	var/datum/chunk/waypointchunk = null


	if(waypoint_ident)
		// This only applies to the case where the brain has a Waypoint stored, i.e. when we're
		//   deliberately moving towards a specific location as opposed to patrolling randomly.
		// This lets us reuse one handler for both random and directed cover leapfrogs.
		var/list/waypoint_memdata = brain?.GetMemoryValue(MEM_WAYPOINT_LKP, null, FALSE, TRUE)
		var/mem_waypoint_x = waypoint_memdata?[KEY_GHOST_X]
		var/mem_waypoint_y = waypoint_memdata?[KEY_GHOST_Y]

		if(!isnull(mem_waypoint_x) && !isnull(mem_waypoint_y))
			effective_waypoint_x = mem_waypoint_x
			effective_waypoint_y = mem_waypoint_y

		else
			var/datum/Tuple/waypoint_position = waypoint_ident.CurrentPositionAsTuple()
			var/waypoint_fuzz_shared = max(1, min(WAYPOINT_FUZZ_X, WAYPOINT_FUZZ_Y))

			var/waypoint_dist = max(waypoint_fuzz_shared, ChebyshevDistanceNumeric(
				pawn.x,
				pawn.y,
				waypoint_position.left,
				waypoint_position.right
			))

			/* The further we are, the more noisy our estimate is.
			// Practically speaking, this means that our search radius
			// gets wider and we wander around more.
			//
			*/
			var/fuzz_factor = min(10, max(1, log(waypoint_fuzz_shared, waypoint_dist)))
			var/fuzz_x = round(rand(WAYPOINT_FUZZ_X, WAYPOINT_FUZZ_X * fuzz_factor) * pick(1, -1))
			var/fuzz_y = round(rand(WAYPOINT_FUZZ_Y, WAYPOINT_FUZZ_Y * fuzz_factor) * pick(1, -1))

			effective_waypoint_x = (waypoint_position.left + fuzz_x)
			effective_waypoint_y = (waypoint_position.right + fuzz_y)

			if((waypoint_dist <= GOAI_CHEAT_SEE_WAYPOINT_TURF_MAXDIST_CUTOFF) && prob(GOAI_CHEAT_SEE_WAYPOINT_TURF_ODDS))
				var/turf/waypoint_turf = locate(effective_waypoint_x, effective_waypoint_y, pawn.z)

				if(waypoint_turf)
					curr_view.Add(waypoint_turf)
					var/list/waypoint_adjacents = fCardinalTurfsNoblocks(waypoint_turf)
					if(waypoint_adjacents)
						curr_view.Add(waypoint_adjacents)

		waypointchunk = chunkserver.ChunkForTile(effective_waypoint_x, effective_waypoint_y, pawn.z)

	var/turf/unreachable = brain?.GetMemoryValue("UnreachableTile", null)

	for(var/atom/candidate_cover in curr_view)
		// Need to aggressively trim down processed types here or this will take forever in object-dense areas
		var/mob/M = candidate_cover

		if(istype(M))
			// avoid pathing through mobs
			processed.Add(get_turf(candidate_cover))
			continue

		//if(!(istype(candidate_cover, /mob) || istype(candidate_cover, /obj/machinery) || istype(candidate_cover, /obj/mecha) || istype(candidate_cover, /obj/structure) || istype(candidate_cover, /obj/vehicle) || istype(candidate_cover, /turf)))
		// removed mob
		if(!(istype(candidate_cover, /obj/machinery) || istype(candidate_cover, /obj/mecha) || istype(candidate_cover, /obj/structure) || istype(candidate_cover, /obj/vehicle) || istype(candidate_cover, /turf)))
			continue

		if(candidate_cover.directional_blocker?.block_all)
			processed.Add(get_turf(candidate_cover))
			continue

		var/cand_is_turf = istype(candidate_cover, /turf)
		var/turf/cand = (cand_is_turf ? candidate_cover : get_turf(candidate_cover))

		if(cand in processed)
			continue
		else
			processed.Add(cand)

		if(!isnull(unreachable) && candidate_cover == unreachable)
			ACTION_RUNTIME_DEBUG_LOG("Cover [candidate_cover] is unreachable!")
			continue

		if(!(cand in curr_view) && (cand != prev_loc_memdata))
			continue

		if(!(pawn_mob && istype(pawn_mob)))
			if(!(pawn_mob.MayEnterTurf(cand)))
				continue

		if(!isnull(waypointchunk))
			var/datum/chunk/candchunk = chunkserver.ChunkForAtom(candidate_cover)

			// We want substantial progress and not just oscillations around the same bad position...
			if(candchunk == startchunk)
				// ... unless we're close to the target - then we can make small adjustments.
				if(candchunk != waypointchunk)
					continue

		var/penalty = 0
		penalty += cand.unreachable_penalty

		/*
		if(prev_loc_memdata && prev_loc_memdata == cand)
			penalty += MAGICNUM_DISCOURAGE_SOFT
		*/

		var/invalid_tile = FALSE
		var/obstacle_penalty = 0
		var/enemy_heat = 0

		for(var/atom/enemy in _threats)
			var/threat_dist = get_dist(cand, enemy)

			if(threat_dist < _min_safe_dist)
				invalid_tile = TRUE
				break

			if(threat_dist <= 1)
				enemy_heat++

			if(enemy_heat > 3)
				invalid_tile = TRUE
				break

			var/threat_dir = get_dir(cand, enemy)
			var/threat_antidir = get_dir(enemy, cand)

			var/tile_is_cover = (cand.IsCover(TRUE, threat_dir, FALSE))
			if(tile_is_cover)
				obstacle_penalty -= 150
			else
				obstacle_penalty += 400

			var/tile_is_pillbox = (cand.IsCover(TRUE, threat_antidir, FALSE))
			if(tile_is_pillbox)
				// We are protected... but the enemy is not!
				obstacle_penalty -= 50

			penalty -= threat_dist * 50  // the further from a threat, the better

		if(obstacle_penalty > 1000)
			continue

		penalty += obstacle_penalty

		if(invalid_tile)
			continue

		if(cand.density)
			continue

		var/cand_dist = ManhattanDistance(cand, pawn)

		if(waypoint_ident && cand_dist < 3)
			// we want substantial moves only
			penalty += MAGICNUM_DISCOURAGE_SOFT
			//continue

		/*if (cand.CurrentPositionAsTuple() ~= shot_at_where)
			penalty += MAGICNUM_DISCOURAGE_SOFT*/
			//continue

		//var/open_lines = cand.GetOpenness()

		var/targ_dist = 0

		if(!isnull(effective_waypoint_x) && !isnull(effective_waypoint_y))
			targ_dist = ManhattanDistanceNumeric(cand.x, cand.y, effective_waypoint_x, effective_waypoint_y)

		/*penalty += abs(open_lines-pick(
			/*
			This is a bit un-obvious:

			What we're doing here is biasing the pathing towards
			cover positions *around* the picked value.

			For example, if we roll a 3, the ideal cover position
			would be one with Openness score of 3.

			However, this is not a hard requirement; if we don't
			have a 3, we'll accept a 2 or a 4 (equally, preferentially)
			and if we don't have *those* - a 1 or a 5, etc.

			This makes it harder for the AI to wind up giving up due to
			no valid positions; sub-optimal is still good enough in that case.

			The randomness is here to make the leapfrogging more dynamic;
			if we just rank by best cover, we'll just wind bouncing between
			the same positions, and this action is supposed to be more like

			a 'smart' tacticool wandering behaviour.
			 */
			120; 3,
			50; 4,
			5; 7
		))*/

		/* Inject some noise to stop AIs getting stuck in corners.
		// max +/- 10% discount factor.
		*/
		var/noisy_targ_dist = targ_dist * RAND_PERCENT_MULT(30)

		penalty += noisy_targ_dist * 8  // the closer to target, the better
		penalty += (cand_dist ** 2)

		// Reminder to self: higher values are higher priority
		// Smaller penalty => also higher priority
		var/datum/Quadruple/cover_quad = new(-penalty, -noisy_targ_dist, -cand_dist, cand)
		cover_queue.Enqueue(cover_quad)

	if(cover_queue.L?.len)
		best_local_pos = ValidateWaypoint(cover_queue, trust_first, /proc/fCardinalTurfsNoblocksObjpermissive)
	return best_local_pos


/datum/utility_ai/mob_commander/proc/HandleDirectionalChooseCoverleapLandmark(var/datum/ActionTracker/tracker)
	var/atom/pawn = src.GetPawn()

	if(!istype(pawn))
		ACTION_RUNTIME_DEBUG_LOG("No owned mob found for [src.name] AI @ L[__LINE__] in [__FILE__]")
		return FALSE

	var/turf/best_local_pos = tracker?.BBGet("bestpos", null)
	if(best_local_pos)
		return

	var/turf/startpos = tracker.BBSetDefault("startpos", get_turf(pawn))
	var/list/threats = (src.brain?.GetMemoryValue(MEM_ENEMIES_POSITIONS) || list())
	var/min_safe_dist = brain.GetPersonalityTrait(KEY_PERS_MINSAFEDIST, 2)
	var/turf/prev_loc_memdata = brain?.GetMemoryValue(MEM_PREVLOC, null, FALSE)

	// Run pathfind
	var/main_threat = length(threats) ? threats[1] : null
	best_local_pos = ChooseCoverleapLandmark(startpos, main_threat, prev_loc_memdata, threats, min_safe_dist)

	if(best_local_pos)
		tracker.BBSet("bestpos", best_local_pos)
		tracker.SetDone()

		if(brain)
			brain.SetMemory(MEM_DIRLEAP_BESTPOS, best_local_pos)

	else
		tracker.SetFailed()

	return


/datum/utility_ai/mob_commander/proc/HandleDirectionalCoverLeapfrog(var/datum/ActionTracker/tracker, var/atom/threat = null)
	var/atom/pawn = src.GetPawn()

	if(!istype(pawn))
		ACTION_RUNTIME_DEBUG_LOG("No owned mob found for [src.name] AI @ L[__LINE__] in [__FILE__]")
		return FALSE

	var/tracker_frustration = tracker.BBSetDefault("frustration", 0)
	var/turf/startpos = tracker.BBSetDefault("startpos", get_turf(pawn))

	var/turf/best_local_pos = null
	best_local_pos = best_local_pos || tracker?.BBGet("bestpos", null)
	if(brain && isnull(best_local_pos))
		best_local_pos = src.brain.GetMemoryValue(MEM_DIRLEAP_BESTPOS, best_local_pos)

	var/min_safe_dist = (src.brain?.GetPersonalityTrait(KEY_PERS_MINSAFEDIST, null) || 2)
	var/frustration_repath_maxthresh = (brain?.GetPersonalityTrait(KEY_PERS_FRUSTRATION_THRESH, null) || 3)

	var/list/threats = src.brain.GetMemoryValue(MEM_ENEMIES_POSITIONS) || list()

	// Previous position
	var/turf/prev_loc_memdata = src.brain?.GetMemoryValue(MEM_PREVLOC, null, FALSE)

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
	for(var/atom/curr_threat in threats)
		var/next_step_threat_distance = (next_step ? GetThreatDistance(next_step, curr_threat, PLUS_INF) : PLUS_INF)
		var/curr_threat_distance = GetThreatDistance(pawn, curr_threat, PLUS_INF)
		var/bestpos_threat_distance = GetThreatDistance(best_local_pos, curr_threat, PLUS_INF)

		var/atom/bestpos_threat_neighbor = (curr_threat ? get_step_towards(best_local_pos, curr_threat) : null)

		// Reevaluating plans as new threats pop up
		var/bestpos_is_unsafe = (bestpos_threat_distance < min_safe_dist && !(bestpos_threat_neighbor?.IsCover(TRUE, get_dir(bestpos_threat_neighbor, curr_threat), FALSE)))
		var/currpos_is_unsafe = (
			(tracker_frustration < frustration_repath_maxthresh) && (curr_threat_distance <= min_safe_dist) && (next_step_threat_distance < curr_threat_distance)
		)

		if(bestpos_is_unsafe || currpos_is_unsafe)
			tracker.BBSet("frustration", tracker_frustration+1)

			CancelNavigate()
			best_local_pos = null
			tracker.BBSet("bestpos", null)
			src.brain?.DropMemory(MEM_DIRLEAP_BESTPOS)
			break

	// Pathfinding/search
	if(isnull(best_local_pos))
		var/main_threat = length(threats) ? threats[1] : null
		best_local_pos = ChooseCoverleapLandmark(startpos, main_threat, prev_loc_memdata, threats, min_safe_dist)
		#ifdef ENABLE_GOAI_DEBUG_BEAM_GIZMOS
		best_local_pos?.pDrawVectorbeam(pawn, best_local_pos, "n_beam")
		#endif

		tracker?.BBSet("bestpos", best_local_pos)
		tracker?.BBSet("StartDist", (ManhattanDistance(get_turf(pawn), best_local_pos) || 0))
		ACTION_RUNTIME_DEBUG_LOG((isnull(best_local_pos) ? "[src]: Best local pos: null" : "[src]: Best local pos ([best_local_pos?.x], [best_local_pos?.y])"))

	if(best_local_pos && (!src.active_path || src.active_path.target != best_local_pos))
		var/list/path = src.AiAStar(
			start = get_turf(pawn),
			end = get_turf(best_local_pos),
			adjacent = /proc/fCardinalTurfsNoblocks,
			dist = DEFAULT_GOAI_DISTANCE_PROC,
			max_nodes = 0,
			max_node_depth = null,
			min_target_dist = 0,
			min_node_dist = null,
			adj_args = null,
			exclude = null
		)

		if(isnull(path))
			src.brain?.SetMemory("UnreachableTile", best_local_pos)
			best_local_pos.unreachable_penalty += 10
		else
			src.brain?.SetMemory(MEM_PATH_ACTIVE, path)

	if(best_local_pos)
		var/dist_to_pos = ManhattanDistance(get_turf(pawn), best_local_pos)
		if(dist_to_pos < 1)
			tracker.SetTriggered()
	else
		tracker.SetFailed()

	var/walk_dist = (tracker?.BBGet("StartDist") || 0)
	var/datum/brain/utility/needybrain = brain

	if(tracker.IsTriggered() && !tracker.is_done)
		if(tracker.TriggeredMoreThan(1))
			tracker.SetDone()
			src.brain?.SetMemory(MEM_PREVLOC, startpos, MEM_TIME_LONGTERM)

	else if(src.active_path && tracker.IsOlderThan(COMBATAI_MOVE_TICK_DELAY * (20 + walk_dist)))
		if(istype(needybrain))
			needybrain.AddNeed(NEED_COMPOSURE, -MAGICNUM_COMPOSURE_LOSS_FAILMOVE)

		CancelNavigate()
		tracker.SetFailed()

	else if(tracker.IsOlderThan(COMBATAI_MOVE_TICK_DELAY * (10 + walk_dist)))
		if(istype(needybrain))
			needybrain.AddNeed(NEED_COMPOSURE, -MAGICNUM_COMPOSURE_LOSS_FAILMOVE)

		CancelNavigate()
		tracker.SetFailed()

	return
