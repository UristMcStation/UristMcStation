/* Movement system (in the ECS sense) and movement helpers.
//
// Is this ripped shamelessly from GOAP code? You bet! Autoplagiarism goes brr!
*/

/datum/utility_ai/mob_commander
	var/pathing_dist_cutoff = 60

	// Whether we allow the movement system to make small wandering steps
	// This helps in path-following with tricky cases, but makes more deliberate moves
	// such as homing in on an object to pick up or otherwise affect look ugly and jank.
	//
	// Rule of thumb: default to on when idle or going somewhere, off when doing stuff.
	var/allow_wandering = TRUE


/datum/utility_ai/mob_commander/proc/CurrentPositionAsTuple()
	var/atom/pawn = src.GetPawn()

	if(!istype(pawn))
		MOVEMENT_DEBUG_LOG("No owned mob found for [src.name] AI @ L[__LINE__] in [__FILE__]")
		return

	return pawn.CurrentPositionAsTuple()


/datum/utility_ai/mob_commander/proc/FindPathTo(var/trg, var/min_dist = 0, var/list/avoid = null, var/adjproc = null, var/distanceproc = null, var/list/adjargs = null)
	var/atom/pawn = src.GetPawn()

	if(!istype(pawn))
		MOVEMENT_DEBUG_LOG("No owned mob found for [src.name] AI @ L[__LINE__] in [__FILE__]")
		return

	var/atom/start_loc = null

	if(pawn)
		start_loc = pawn.loc

	if(!start_loc)
		MOVEMENT_DEBUG_LOG("No start loc found for [src.name] AI")
		return

	var/list/true_avoid = DEFAULT_IF_NULL(avoid, list())

	var/datum/brain/aibrain = src.brain
	if(istype(aibrain))
		var/list/enemy_positions = aibrain.GetMemoryValue(MEM_ENEMIES_POSITIONS)
		if(enemy_positions)
			true_avoid.Add(enemy_positions)

		var/list/friends_positions = aibrain.GetMemoryValue(MEM_FRIENDS_POSITIONS)
		if(friends_positions)
			true_avoid.Add(friends_positions)

		var/datum/squad/mysquad = aibrain.GetSquad()
		if(istype(mysquad))
			for(var/atom/squaddie in mysquad)
				var/turf/squaddie_loc = get_turf(squaddie)
				if(istype(squaddie_loc))
					true_avoid.Add(squaddie_loc)

	var/true_adjproc = (isnull(adjproc) ? /proc/fCardinalTurfs : adjproc)
	var/true_distproc = (isnull(distanceproc) ? DEFAULT_GOAI_DISTANCE_PROC : distanceproc)

	var/list/path = src.AiAStar(
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



/datum/utility_ai/mob_commander/proc/ValidateWaypoint(var/PriorityQueue/queue, var/trust_first = null, var/adjproc = null, var/distanceproc = null)
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
			MAYBE_LOG("[src.name]: No Quad found, breaking the ValidateWaypoint loop!")
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
			if(obstacle_idx > 1)
				best_local_pos = found_path[obstacle_idx - 1]

	return best_local_pos


/datum/utility_ai/mob_commander/proc/CheckForObstacles(var/list/dirty_path)
	var/atom/pawn = src.GetPawn()
	if(!istype(pawn))
		MOVEMENT_DEBUG_LOG("No owned mob found for [src.name] AI @ L[__LINE__] in [__FILE__]")
		return

	/*
	// DUPLICATED CODE FROM WAYPOINT.DM!!!
	*/
	var/path_pos = 0
	var/obstruction = null

	var/turf/previous = null

	for(var/turf/pathitem in dirty_path)
		path_pos++

		if(isnull(pathitem))
			continue

		if(isnull(previous) || path_pos <= 1)
			previous = pathitem
			continue

		if((pathitem.z != previous.z))
			// on delta-Z, check adjacency - stairs and holes are pass-though, things like ladders are obstacles
			// (in that we need to path *to* them and not *through* them)
			var/list/prev_adjacents = fAdjacentTurfs(previous, FALSE, FALSE, FALSE, TRUE, TRUE)
			if(!(pathitem in prev_adjacents))
				// not covered by adjacency, so the movement is not 'smooth' (like stairs/open space/portal)
				// but 'action-like' (like a ladder)
				return path_pos

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
					var/blocks = blocker.BlocksEntry(dirDelta, src)

					if(blocks)
						obstruction = potential_obstruction_curr
						return path_pos

			if(!obstruction && path_pos > 2) // check earlier steps
				for(var/atom/movable/potential_obstruction_prev in previous.contents)
					if(potential_obstruction_prev == pawn)
						continue

					var/datum/directional_blocker/blocker = potential_obstruction_prev?.directional_blocker
					if(!blocker)
						continue

					var/dirDeltaPrev = get_dir(dirty_path[path_pos-2], potential_obstruction_prev)
					var/blocksPrev = blocker.BlocksEntry(dirDeltaPrev, src)

					if(blocksPrev)
						obstruction = potential_obstruction_prev
						return path_pos - 1

			break

		else
			previous = pathitem

	return null


/datum/utility_ai/mob_commander/proc/GetCurrentChunk()
	var/datum/chunkserver/chunkserver = GetOrSetChunkserver()
	var/datum/chunk/startchunk = chunkserver.ChunkForAtom(src)
	return startchunk


/datum/utility_ai/mob_commander/proc/BuildPathTrackerTo(var/trg, var/min_dist = 0, var/avoid = null, var/inh_frustration = 0, var/costproc = null)
	var/datum/ActivePathTracker/pathtracker = null
	var/cost_function = (isnull(costproc) ? DEFAULT_GOAI_DISTANCE_PROC : costproc)
	//var/list/adjacency_args = list(owner = src))

	var/list/path = FindPathTo(
		trg,
		min_dist,
		avoid,
		distanceproc = cost_function
	)

	if(path)
		pathtracker = new /datum/ActivePathTracker(trg, path, min_dist, inh_frustration)

	return pathtracker


/datum/utility_ai/mob_commander/proc/StartNavigateTo(var/trg, var/min_dist = 0, var/avoid = null, var/inh_frustration = 0, var/costproc = null, var/max_mindist = 2)
	src.is_repathing = 1

	var/atom/pawn = src.GetPawn()
	if(!istype(pawn))
		MOVEMENT_DEBUG_LOG("[src]: Could not build a pathtracker to [trg] - no pawn!")
		src.is_repathing = 0
		return

	var/used_min_dist = min_dist - 1
	var/datum/ActivePathTracker/pathtracker = null

	while(isnull(pathtracker))
		if(++used_min_dist > max_mindist)
			break

		pathtracker = BuildPathTrackerTo(trg, used_min_dist, avoid, inh_frustration, costproc)

	if(pathtracker)
		src.active_path = pathtracker
		src.brain.SetMemory(MEM_PATH_ACTIVE, pathtracker.path)
		MOVEMENT_DEBUG_LOG("[src]: Created a pathtracker to [trg] @ [pawn.loc] [COORDS_TUPLE(pawn.loc)]")

	else
		#ifdef MOVEMENT_DEBUG_LOGGING
		var/turf/pawnloc = get_turf(pawn)
		MOVEMENT_DEBUG_LOG("[src]: Could not build a pathtracker to [trg] @ [pawnloc] [COORDS_TUPLE(pawnloc)]")
		#endif
		src.brain.SetMemory("PendingMovementTarget", trg, 100)
		src.is_repathing = 0
		return

	#ifdef ENABLE_GOAI_DEBUG_BEAM_GIZMOS
	var/turf/trg_turf = trg

	if(istype(trg_turf) && pawn)
		trg_turf.pDrawVectorbeam(pawn, trg_turf)
	#endif

	src.is_repathing = 0

	return src.active_path


/datum/utility_ai/mob_commander/proc/CancelNavigate()
	src.active_path = null
	src.is_repathing = 0
	return TRUE


/datum/utility_ai/mob_commander/proc/MovePawn(var/atom/trg, var/flee = FALSE, var/atom/override_pawn = null)
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

	if(!istype(true_pawn))
		MOVEMENT_DEBUG_LOG("No owned mob found for [src.name] AI @ L[__LINE__] in [__FILE__]")
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

	var/atom/curr_pos = get_turf(true_pawn)

	var/movedir = get_dir(curr_pos, get_turf(trg))

	if(flee)
		movedir = dir2opposite(movedir)

	step_result = true_pawn.DoMove(movedir, true_pawn, FALSE)

	# ifdef GOAI_LIBRARY_FEATURES
	if(step_result)
		src.brain?.SetMemory("MyPrevLocation", curr_pos)
		step_result = TRUE
	# endif

	# ifdef GOAI_SS13_SUPPORT
	// DoMove returns zero on success in ss13
	if(step_result == MOVEMENT_HANDLED)
		src.brain?.SetMemory("MyPrevLocation", curr_pos)
		step_result = TRUE
	# endif

	return step_result


/datum/utility_ai/mob_commander/proc/WalkPawn(var/atom/trg, var/flee = FALSE, var/stop_on_path = TRUE, var/stop_on_moving = TRUE, var/atom/override_pawn = null)
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

	if(!istype(true_pawn))
		MOVEMENT_DEBUG_LOG("No owned mob found for [src.name] AI @ L[__LINE__] in [__FILE__]")
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
				MOVEMENT_DEBUG_LOG("ABORTING WALK CYCLE DUE TO FAILED STEP")
				break

			sleep(COMBATAI_MOVE_TICK_DELAY)

	return TRUE


/datum/utility_ai/mob_commander/proc/WalkPawnTowards(var/atom/trg, var/stop_on_path = TRUE, var/stop_on_moving = TRUE, var/atom/override_pawn = null)
	/* This is a covenience partial function for WalkPawn(flee=FALSE),
	// so broadly equivalent to the stock walk_towards() proc
	*/
	return src.WalkPawn(trg, FALSE, stop_on_path, stop_on_moving, override_pawn)


/datum/utility_ai/mob_commander/proc/WalkPawnAwayFrom(var/atom/trg, var/stop_on_path = TRUE, var/stop_on_moving = TRUE, var/atom/override_pawn = null)
	/* This is a covenience partial function for WalkPawn(flee=TRUE),
	// so broadly equivalent to the stock walk_away() proc
	*/
	return src.WalkPawn(trg, TRUE, stop_on_path, stop_on_moving, override_pawn)


/datum/utility_ai/mob_commander/proc/randMove()
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
