/* Movement system (in the ECS sense) and movement helpers. */


/datum/goai/mob_commander/proc/CurrentPositionAsTuple()
	var/atom/pawn = src.GetPawn()
	if(!pawn)
		to_world_log("No owned mob found for [src.name] AI")
		return

	return pawn.CurrentPositionAsTuple()


/datum/goai/mob_commander/proc/FindPathTo(var/trg, var/min_dist = 0, var/avoid = null, var/proc/adjproc = null, var/proc/distanceproc = null, var/list/adjargs = null)
	var/atom/pawn = src.GetPawn()
	if(!pawn)
		to_world_log("No owned mob found for [src.name] AI")
		return

	var/atom/start_loc = null

	if(pawn)
		start_loc = pawn.loc

	if(!start_loc)
		to_world_log("No start loc found for [src.name] AI")
		return

	var/true_avoid = (avoid || src.brain?.GetMemoryValue("BadStartTile", null))

	var/proc/true_adjproc = (isnull(adjproc) ? /proc/fCardinalTurfs : adjproc)
	var/proc/true_distproc = (isnull(distanceproc) ? DEFAULT_GOAI_DISTANCE_PROC : distanceproc)

	var/list/path = GoaiAStar(
		start = get_turf(pawn.loc),
		end = get_turf(trg),
		adjacent = true_adjproc,
		dist = true_distproc,
		max_nodes = 0,
		max_node_depth = pathing_dist_cutoff,
		min_target_dist = min_dist,
		min_node_dist = null,
		adj_args = adjargs,
		exclude = true_avoid
	)
	return path



/datum/goai/mob_commander/proc/ValidateWaypoint(var/PriorityQueue/queue, var/trust_first = null, var/adjproc = null, var/distanceproc = null)
	var/atom/best_local_pos = null

	var/_trust_first = trust_first
	if(isnull(trust_first))
		_trust_first = brain?.GetMemoryValue(MEM_TRUST_BESTPOS, FALSE)

	var/list/found_path = null

	while(queue && queue.L)
		// Iterate over found positions, AStar-ing into them and
		//   throwing out candidates that are unreachable.
		//
		// Most of the time, this should succeed on the first try;
		//   the point is to avoid the AI getting stuck in a spot forever.
		var/datum/Quadruple/best_cand_quad = queue.Dequeue()

		if(!best_cand_quad)
			to_world_log("[src.name]: No Quad found, breaking the ValidateWaypoint loop!")
			break

		best_local_pos = best_cand_quad.fourth
		if(!best_local_pos)
			continue

		if(_trust_first)
			break

		// NOTE TO SELF: Optimization: taint turfs in a radius around the first failed
		found_path = FindPathTo(best_local_pos,  0, null, adjproc, distanceproc)
		if(found_path)
			break

		// This might take a while, better yield to higher-priority tasks
		sleep(-1)

	if(found_path)
		var/obstacle_idx = src.CheckForObstacles(found_path)
		if(obstacle_idx)
			world.log << "OBSTACLE = [obstacle_idx]"
			if(obstacle_idx > 1)
				best_local_pos = found_path[obstacle_idx - 1]

	return best_local_pos


/datum/goai/mob_commander/proc/CheckForObstacles(var/list/dirty_path)
	var/atom/pawn = src.GetPawn()

	/*
	// DUPLICATED CODE FROM WAYPOINT.DM!!!
	*/
	var/path_pos = 0
	var/obstruction_pos = 0
	var/obstruction = null

	for(var/turf/pathitem in dirty_path)
		path_pos++

		if(isnull(pathitem))
			continue

		if(path_pos <= 1)
			continue

		var/turf/previous = dirty_path[path_pos-1]

		if(isnull(previous))
			continue

		var/last_link_blocked = GoaiLinkBlocked(previous, pathitem)

		if(last_link_blocked)
			// find the obstacle

			if(!obstruction)
				for(var/atom/movable/potential_obstruction_curr in pathitem.contents)
					if(potential_obstruction_curr == pawn)
						continue

					var/datum/directional_blocker/blocker = potential_obstruction_curr?.directional_blocker
					if(!blocker)
						continue

					var/dirDelta = get_dir(previous, potential_obstruction_curr)
					var/blocks = blocker.Blocks(dirDelta, src)

					if(blocks)
						obstruction = potential_obstruction_curr
						break

			if(!obstruction && path_pos > 2) // check earlier steps
				for(var/atom/movable/potential_obstruction_prev in previous.contents)
					if(potential_obstruction_prev == pawn)
						continue

					var/datum/directional_blocker/blocker = potential_obstruction_prev?.directional_blocker
					if(!blocker)
						continue

					var/dirDeltaPrev = get_dir(dirty_path[path_pos-2], potential_obstruction_prev)
					var/blocksPrev = blocker.Blocks(dirDeltaPrev, src)

					if(blocksPrev)
						obstruction = potential_obstruction_prev
						break

			break

	world.log << "OBSTRUCTION [obstruction] @ IDX [path_pos] ([dirty_path[path_pos]])"
	obstruction_pos = path_pos

	return obstruction_pos


/datum/goai/mob_commander/proc/GetCurrentChunk()
	var/datum/chunkserver/chunkserver = GetOrSetChunkserver()
	var/datum/chunk/startchunk = chunkserver.ChunkForAtom(src)
	return startchunk


/datum/goai/mob_commander/proc/BuildPathTrackerTo(var/trg, var/min_dist = 0, var/avoid = null, var/inh_frustration = 0, var/proc/costproc = null)
	var/datum/ActivePathTracker/pathtracker = null
	var/cost_function = (isnull(costproc) ? DEFAULT_GOAI_DISTANCE_PROC : costproc)
	//var/list/adjacency_args = list(owner = src))

	var/list/path = FindPathTo(
		trg,
		min_dist,
		avoid,
		//adjproc = /proc/mCombatantAdjacents,
		//adjargs = adjacency_args,
		distanceproc = cost_function
	)

	if(!path)
		path = FindPathTo(
			trg,
			min_dist + 1,
			avoid,
			//adjproc = /proc/mCombatantAdjacents,
			//adjargs = adjacency_args,
			distanceproc = cost_function,
		)

	if(path)
		pathtracker = new /datum/ActivePathTracker(trg, path, min_dist, inh_frustration)

	return pathtracker


/datum/goai/mob_commander/proc/StartNavigateTo(var/trg, var/min_dist = 0, var/avoid = null, var/inh_frustration = 0, var/refresh_loc_memories = TRUE, var/proc/costproc = null)
	src.is_repathing = 1

	var/atom/pawn = src.GetPawn()

	if(brain && refresh_loc_memories)
		var/atom/previous_oldloc = brain.GetMemoryValue("Location-1")

		if(previous_oldloc && prob(10))
			brain.SetMemory("Location-2", previous_oldloc)

		brain.SetMemory("Location-1", pawn?.loc)

	var/datum/ActivePathTracker/pathtracker = BuildPathTrackerTo(trg, min_dist, avoid, inh_frustration, costproc)

	if(pathtracker)
		src.active_path = pathtracker

	else
		var/atom/curr_loc = get_turf(pawn)
		to_world_log("[src]: Could not build a pathtracker to [trg] @ [COORDS_TUPLE(curr_loc)]")
		var/atom/potential_step = get_step_towards(pawn, trg)
		if(potential_step)
			src.MovePawn(potential_step)
		//brain?.SetMemory("BadStartTile", curr_loc, 1000)

	var/turf/trg_turf = trg

	if(trg_turf && pawn)
		trg_turf.pDrawVectorbeam(pawn, trg_turf)

	src.is_repathing = 0

	return src.active_path


/datum/goai/mob_commander/proc/CancelNavigate()
	src.active_path = null
	src.is_repathing = 0
	return TRUE


/datum/goai/mob_commander/proc/MovePawn(var/atom/trg, var/flee = FALSE, var/atom/override_pawn = null)
	/* Core API to let our Commanders move our pawns (i.e. any atoms).
	// Needs to account for different subtypes of atom having specialized
	// movement APIs (because SS13 code is an eldritch spaghetti from hell)
	//
	// ARGUMENTS:
	// - trg => target atom to move to/from
	// - flee => boolean; if TRUE, reverses the directions (so we run AWAY from trg rather than TOWARDS it)
	// - override_pawn => optional, can be used to *explicitly* set a pawn to be moved.
	*/
	var/atom/movable/true_pawn = override_pawn

	if(!istype(true_pawn))
		// Because the null-on-bad-cast is unreliable...
		true_pawn = null

	if(isnull(true_pawn))
		true_pawn = src.GetPawn()

	if(isnull(true_pawn))
		return FALSE

	var/mob/pawn_mob = true_pawn

	if(!(pawn_mob.MayMove()))
		return FALSE

	var/step_result = FALSE

	if(pawn_mob && istype(pawn_mob))
		// Mobs have a specialized API for movement
		var/mob/living/L = pawn_mob

		if(L && istype(L))
			if(!(L?.stat == CONSCIOUS))
				return FALSE

	var/movedir = get_dir(get_turf(true_pawn), get_turf(trg))

	if(flee)
		movedir = dir2opposite(movedir)

	step_result = true_pawn.DoMove(movedir, true_pawn, FALSE)
	return step_result


/datum/goai/mob_commander/proc/WalkPawn(var/atom/trg, var/flee = FALSE, var/stop_on_path = TRUE, var/stop_on_moving = TRUE, var/atom/override_pawn = null)
	/* This is a fallback movement logic for cases where we don't have a good Astar path.
	// It's effectively the engine's walk() proc but with an SS13/GOAI layer on top.
	// Movement will stop once we acquire an actual path.
	//
	// ARGUMENTS: see MovePawn
	*/
	var/atom/true_pawn = override_pawn

	if(!istype(true_pawn))
		// Because the null-on-bad-cast is unreliable...
		true_pawn = null

	if(isnull(true_pawn))
		true_pawn = src.GetPawn()

	if(isnull(true_pawn))
		return FALSE

	var/turf/targ_turf = get_turf(trg)

	spawn(0)
		// kill the loop if we have an actual path
		while(get_turf(true_pawn) != targ_turf)
			if(stop_on_path && src.active_path)
				break

			if(stop_on_moving && src.is_moving)
				break

			var/step_result = src.MovePawn(trg, flee, true_pawn)

			if(!step_result)
				break

			sleep(COMBATAI_MOVE_TICK_DELAY)

	return TRUE


/datum/goai/mob_commander/proc/WalkPawnTowards(var/atom/trg, var/stop_on_path = TRUE, var/stop_on_moving = TRUE, var/atom/override_pawn = null)
	/* This is a covenience partial function for WalkPawn(flee=FALSE),
	// so broadly equivalent to the stock walk_towards() proc
	*/
	return src.WalkPawn(trg, FALSE, stop_on_path, stop_on_moving, override_pawn)


/datum/goai/mob_commander/proc/WalkPawnAwayFrom(var/atom/trg, var/stop_on_path = TRUE, var/stop_on_moving = TRUE, var/atom/override_pawn = null)
	/* This is a covenience partial function for WalkPawn(flee=TRUE),
	// so broadly equivalent to the stock walk_away() proc
	*/
	return src.WalkPawn(trg, TRUE, stop_on_path, stop_on_moving, override_pawn)


/datum/goai/mob_commander/proc/MovementSystem()
	var/atom/movable/pawn = src.GetPawn()

	if(!(src?.active_path) || src.active_path.IsDone() || src.is_moving || isnull(pawn))
		return

	if(!(pawn.MayMove()))
		return

	var/success = FALSE
	var/atom/next_step = ((src.active_path.path && src.active_path.path.len) ? src.active_path.path[1] : null)

	var/atom/followup_step = ((src.active_path.path && src.active_path.path.len >= 2) ? src.active_path.path[2] : null)

	if(next_step)

		if(src.active_path.frustration > 2)
			//brain?.SetMemory("UnreachableTile", active_path.target)
			randMove()
			return

		if(src.active_path.frustration > 4 && (src.is_repathing <= 0) && followup_step && followup_step != src.active_path.target)
			// repath
			var/frustr_x = followup_step.x
			var/frustr_y = followup_step.y
			to_world_log("[src]: FRUSTRATION, repath avoiding [next_step] @ ([frustr_x], [frustr_y])!")
			StartNavigateTo(src.active_path.target, src.active_path.min_dist, next_step, src.active_path.frustration)
			return

		if(get_dist(pawn, next_step) > 1)
			// If we somehow wind up away from the core path, move back towards it first
			WalkPawnTowards(next_step, FALSE, TRUE)
			return

		var/step_result = MovePawn(next_step)

		success = (
			step_result || (
				(pawn.x == next_step.x) && (pawn.y == next_step.y)
			)
		)

		if(success)
			src.active_path.frustration = 0

		else
			src.active_path.frustration++
	else
		src.active_path.SetDone()

	if(success)
		lpop(src.active_path.path)

	return


/datum/goai/mob_commander/proc/randMove()
	if(src.is_moving)
		return FALSE

	var/atom/movable/pawn = src.GetPawn()

	if(!(pawn?.MayMove()))
		return FALSE

	src.is_moving = 1

	var/turf/curr_loc = get_turf(pawn)
	var/list/neighbors = fCombatantAdjacents(curr_loc, pawn)

	if(neighbors)
		var/movedir = pick(neighbors)
		MovePawn(movedir)

	src.is_moving = 0
	return TRUE
