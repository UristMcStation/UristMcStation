/datum/goai/mob_commander/proc/ChooseChargeLandmark(var/atom/startpos, var/atom/primary_threat = null, var/turf/prev_loc_memdata = null, var/list/threats = null, var/min_safe_dist = null, var/trust_first = null)
	var/atom/pawn = src.GetPawn()
	if(!pawn)
		ACTION_RUNTIME_DEBUG_LOG("[src] does not have an owned mob!")
		return

	// Pathfinding/search
	var/atom/_startpos = (startpos || get_turf(pawn))
	var/list/_threats = (threats || list())

	var/turf/best_local_pos = null
	var/list/processed = list()

	var/PriorityQueue/cover_queue = new /PriorityQueue(/datum/Quadruple/proc/TriCompare)

	//var/datum/chunkserver/chunkserver = GetOrSetChunkserver()
	//var/datum/chunk/startchunk = chunkserver.ChunkForAtom(_startpos)

	var/list/curr_view = brain?.perceptions?.Get(SENSE_SIGHT_CURR)
	curr_view.Add(_startpos)

	var/effective_waypoint_x = null
	var/effective_waypoint_y = null

	var/mob/pawn_mob = pawn

	var/atom/waypoint_ident = brain?.GetMemoryValue(MEM_WAYPOINT_IDENTITY, null, FALSE, TRUE)
	//var/datum/chunk/waypointchunk = null

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

		//waypointchunk = chunkserver.ChunkForTile(effective_waypoint_x, effective_waypoint_y, pawn.z)


	for(var/turf/cand in curr_view)
		if(!(pawn_mob && istype(pawn_mob)))
			if(!(pawn_mob.MayEnterTurf(cand)))
				continue

		if(cand in processed)
			continue

		if(!(cand in curr_view) && (cand != prev_loc_memdata))
			continue

		var/same_chunk_penalty = 0

		//var/datum/chunk/candchunk = chunkserver.ChunkForAtom(cand)

		var/penalty = 0
		penalty += same_chunk_penalty

		var/invalid_tile = FALSE

		if(invalid_tile)
			continue

		var/cand_dist = ManhattanDistance(cand, pawn)
		if(cand_dist < 3)
			// we want substantial moves only
			penalty += MAGICNUM_DISCOURAGE_SOFT
			//continue

		var/targ_dist = 0

		if(!isnull(effective_waypoint_x) && !isnull(effective_waypoint_y))
			targ_dist = ManhattanDistanceNumeric(cand.x, cand.y, effective_waypoint_x, effective_waypoint_y)

		else if(_threats && istype(_threats) && _threats.len)
			for(var/atom/threat_cand in _threats)
				// No chasing deleted targets!
				if(!(threat_cand && istype(threat_cand)))
					continue

				// Make a run for the closest threat.
				var/raw_threat_cand_dist = ManhattanDistance(cand, threat_cand)
				var/threat_cand_dist = (raw_threat_cand_dist ** 2)

				// If we have no distance, take the first candidate, otherwise the closest.
				targ_dist = (isnull(targ_dist) ? threat_cand_dist : min(targ_dist, threat_cand_dist))


		if(isnull(targ_dist))
			targ_dist = 0

		if(targ_dist == 0)
			// we do NOT want to get in the same spot as target or we'll wind up in Bump() hell
			continue

		var/noisy_dist = targ_dist * rand_gauss(1, 0.01)

		penalty += -noisy_dist  // the closer to target, the better

		// Reminder to self: higher values are higher priority
		// Smaller penalty => also higher priority
		var/datum/Quadruple/cover_quad = new(-noisy_dist, -penalty, -cand_dist, cand)
		cover_queue.Enqueue(cover_quad)
		processed.Add(cand)

	best_local_pos = ValidateWaypoint(cover_queue, trust_first)
	return best_local_pos


/datum/goai/mob_commander/proc/HandleChargeLandmark(var/datum/ActionTracker/tracker)
	var/atom/pawn = src.GetPawn()
	if(!pawn)
		ACTION_RUNTIME_DEBUG_LOG("[src] does not have an owned mob!")
		return

	var/turf/best_local_pos = tracker?.BBGet("bestpos", null)
	if(best_local_pos)
		return

	var/turf/startpos = tracker.BBSetDefault("startpos", get_turf(pawn))
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

	// Run pathfind
	best_local_pos = ChooseChargeLandmark(startpos, primary_threat, null, threats, null)

	if(best_local_pos)
		tracker.BBSet("bestpos", best_local_pos)
		tracker.SetDone()

		if(brain)
			brain.SetMemory(MEM_CHARGE_BESTPOS, best_local_pos)

	else
		tracker.SetFailed()

	return


/datum/goai/mob_commander/proc/HandleCharge(var/datum/ActionTracker/tracker)
	var/atom/pawn = src.GetPawn()
	if(!pawn)
		ACTION_RUNTIME_DEBUG_LOG("[src] does not have an owned mob!")
		return

	//var/tracker_frustration = tracker.BBSetDefault("frustration", 0)
	var/turf/startpos = tracker.BBSetDefault("startpos", get_turf(pawn))

	var/turf/best_local_pos = null
	best_local_pos = best_local_pos || tracker?.BBGet("bestpos", null)

	//var/frustration_repath_maxthresh = (brain?.GetPersonalityTrait(KEY_PERS_FRUSTRATION_THRESH, null) || 3)

	var/list/threats = new()

	// Main threat:
	var/dict/primary_threat_ghost = GetActiveThreatDict()
	var/datum/Tuple/primary_threat_pos_tuple = GetThreatPosTuple(primary_threat_ghost)
	var/atom/primary_threat = null
	if(!(isnull(primary_threat_pos_tuple?.left) || isnull(primary_threat_pos_tuple?.right)))
		primary_threat = locate(primary_threat_pos_tuple.left, primary_threat_pos_tuple.right, pawn.z)

	if(primary_threat_ghost)
		threats[primary_threat_ghost] = primary_threat

	// Reuse cached solution if it's good enough
	if(isnull(best_local_pos) && src.active_path && (!(src.active_path.IsDone())) && src.active_path.target && src.active_path.frustration < 2)
		best_local_pos = src.active_path.target

	// Pathfinding/search
	if(isnull(best_local_pos))
		best_local_pos = ChooseChargeLandmark(startpos, primary_threat, null, threats, null)
		best_local_pos?.pDrawVectorbeam(pawn, best_local_pos, "n_beam")

		tracker?.BBSet("bestpos", best_local_pos)
		tracker?.BBSet("StartDist", (ManhattanDistance(get_turf(pawn), best_local_pos) || 0))
		ACTION_RUNTIME_DEBUG_LOG((isnull(best_local_pos) ? "[src]: Best local pos: null" : "[src]: Best local pos ([best_local_pos?.x], [best_local_pos?.y])"))

	if(best_local_pos && (!src.active_path || src.active_path.target != best_local_pos))
		StartNavigateTo(best_local_pos, 0, null)

	if(best_local_pos)
		var/dist_to_pos = ManhattanDistance(get_turf(pawn), best_local_pos)

		if(dist_to_pos <= 1)
			tracker.SetTriggered()
	else
		tracker.SetFailed()

	var/walk_dist = (tracker?.BBGet("StartDist") || 0)
	var/datum/brain/concrete/needybrain = brain

	if(tracker.IsTriggered() && !tracker.is_done)
		if(tracker.TriggeredMoreThan(1))
			tracker.SetDone()
			brain?.SetMemory(MEM_PREVLOC, startpos, MEM_TIME_LONGTERM)

	else if(src.active_path && tracker.IsOlderThan(COMBATAI_MOVE_TICK_DELAY * (20 + walk_dist)))
		if(needybrain)
			needybrain.AddMotive(NEED_COMPOSURE, -MAGICNUM_COMPOSURE_LOSS_FAILMOVE)

		CancelNavigate()
		tracker.SetFailed()

	else if(tracker.IsOlderThan(COMBATAI_MOVE_TICK_DELAY * (10 + walk_dist)))
		if(needybrain)
			needybrain.AddMotive(NEED_COMPOSURE, -MAGICNUM_COMPOSURE_LOSS_FAILMOVE)

		CancelNavigate()
		tracker.SetFailed()

	SetState(STATE_DISORIENTED, TRUE)
	return
