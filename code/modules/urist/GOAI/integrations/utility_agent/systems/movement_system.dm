// This is a System, i.e. a proc called by an endless loop spawned by the Commander class on init.

/datum/utility_ai/mob_commander/proc/MovementSystem()
	var/atom/movable/pawn = src.GetPawn()

	if(!istype(pawn))
		MOVEMENT_DEBUG_LOG("Pawn is not a movable atom | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(src.is_moving)
		MOVEMENT_DEBUG_LOG("MovementSystem cannot run; already moving | [__FILE__] -> L[__LINE__]")
		return

	if(src.is_moving || isnull(pawn))
		MOVEMENT_DEBUG_LOG("MovementSystem idle; pawn is null for [src] | [__FILE__] -> L[__LINE__]")
		return

	if(!(pawn.MayMove()))
		MOVEMENT_DEBUG_LOG("MovementSystem idle; pawn [pawn] cannot move. | [__FILE__] -> L[__LINE__]")
		return

	var/turf/curr_loc = get_turf(pawn)
	if(isnull(curr_loc))
		MOVEMENT_DEBUG_LOG("MovementSystem idle; curr_loc is null! | [__FILE__] -> L[__LINE__]")
		return

	var/list/curr_path = src.brain.GetMemoryValue(MEM_PATH_ACTIVE)
	//var/trg = src?.brain?.GetMemoryValue("PendingMovementTarget")
	var/trg = (isnull(curr_path) || !(curr_path?.len)) ? null : curr_path[curr_path.len]

	var/turf/trgturf = get_turf(trg)

	var/safe_trg = trg || src.brain.GetMemoryValue("last_pathing_target") || src.brain.GetMemoryValue("PendingMovementTarget")
	var/turf/safe_trgturf = !isnull(safe_trg) ? get_turf(safe_trg) : null

	if(isnull(safe_trgturf))
		// spammy message
		//MOVEMENT_DEBUG_LOG("MovementSystem idle; safe_trgturf is null! | [__FILE__] -> L[__LINE__]")
		return

	var/localdist = MANHATTAN_DISTANCE_TWOD(trgturf, curr_loc, 1000)
	if(localdist < 1)
		MOVEMENT_DEBUG_LOG("MovementSystem idle; already at target! | [__FILE__] -> L[__LINE__]")
		return

	var/success = FALSE
	var/turf/bestcand = null
	var/new_path_offset = null

	// Prevent wandering into special case turfs like forced step-aways
	var/turf/banturf = src.brain?.GetMemoryValue("DontWanderToTurf")

	// bookkeeping var to allow rerunning the modes
	// (sometimes the output of one mode signifies we should retry an earlier one)
	var/pending_checks = 1

	var/allow_path_following = TRUE
	var/allow_steering = TRUE
	var/allow_nudging = TRUE

	while(pending_checks --> 0)
		var/do_path_following = (allow_path_following && src.active_path && !src.active_path.IsDone() && (localdist < 12))

		if(do_path_following)
			// Path-following mode:
			MOVEMENT_DEBUG_LOG("-> [pawn] MOVEMENT SYSTEM: IN PATH-FOLLOWING MODE <-")

			var/atom/destination = null
			var/active_path_len = src.active_path.path.len

			if(active_path_len)
				destination = src.active_path.path[active_path_len]
			else
				do_path_following = FALSE
				continue

			var/atom/next_step = null

			if(src.active_path.curr_offset <= active_path_len)
				// make sure the index is valid; this runtimed at least once before otherwise
				next_step = src.active_path.path[src.active_path.curr_offset]
			else
				do_path_following = FALSE
				continue

			var/turf/prev_draw_pos = null

			#ifdef ENABLE_GOAI_DEBUG_BEAM_GIZMOS
			for(var/turf/drawpos in src.active_path.path)
				// debug path drawing
				if(!isnull(prev_draw_pos))
					drawpos.pDrawVectorbeam(prev_draw_pos, drawpos, "g_beam")

				prev_draw_pos = drawpos
			#endif

			if(isnull(curr_loc))
				allow_path_following = FALSE
				pending_checks++
				continue

			if(next_step.z != curr_loc.z)
				allow_path_following = FALSE
				pending_checks++
				continue

			// Score potential steps for steering purposes
			var/list/cardinals = fCardinalTurfs(curr_loc)

			cardinals.Add(curr_loc)

			if(isnull(cardinals))
				allow_path_following = FALSE
				pending_checks++
				continue

			var/bestscore = null

			for(var/turf/raw_cardturf in cardinals)
				// score should be a float between 0 and 1, ultimately
				// it's effectively a less-flexible, mini-Utility-AI
				var/turf/cardturf = raw_cardturf

				if(cardturf.density)
					continue

				if(cardturf == banturf)
					continue

				var/dirscore = PLUS_INF

				var/next_score = MANHATTAN_DISTANCE(cardturf, next_step)
				var/dest_score = MANHATTAN_DISTANCE(cardturf, destination)
				var/stillness_penalty = 0

				if(get_dist(cardturf, curr_loc) < 1)
					stillness_penalty = prob(20)

				dirscore = min(next_score, dest_score)
				//dirscore = next_score
				dirscore += stillness_penalty
				dirscore += rand() * 0.01
				//dirscore += src.active_path.frustration * (0.5 + rand())

				//MOVEMENT_DEBUG_LOG("Score for [cardturf] is [dirscore], best: [bestscore] for [bestcand] | <@[src]> | [__FILE__] -> L[__LINE__]")

				if(isnull(bestscore) || dirscore < bestscore)
					bestscore = dirscore
					bestcand = cardturf

				if(next_score == 0)
					new_path_offset = (src.active_path.curr_offset + 1)

		else
			// the conditions here are immutable between loops, so we'll set allow to false to save on checks
			// because of short-circuiting, this will only need to check a single boolean on a re-do
			allow_path_following = FALSE

		var/do_steering = (allow_steering && isnull(bestcand) && curr_path)

		if(do_steering)
			// Path-guided steering:
			MOVEMENT_DEBUG_LOG("-> [pawn] MOVEMENT SYSTEM: IN STEERING MODE <-")
			var/last_is_delta_z = FALSE
			var/path_len = curr_path.len
			var/path_idx = path_len
			var/curr_z_path_len = path_len // this will be reassigned if we find z-crossings
			var/half_len = CEIL((curr_z_path_len / 2)) // as will this, binary search-style
			// usage of curr_z_path_len indicates in half_len that'll be our reference point
			// even though right now the curr_z_path_len and path_len are equal
			// this means if we change curr_z_path_len, we should modify half_len too!

			var/obj/structure/stairs/currloc_staircase = (locate() in curr_loc)

			while(path_idx > 0)
				// this could be optimized to search only the part of the path close to curr_loc
				// (check distance to both ends and search that half only)

				// like last_is_delta_z, but only for this iteration step
				// we need two vars - one for loop scope and one for iteration scope

				var/turf/pathstep = curr_path[path_idx--]
				MOVEMENT_DEBUG_LOG("-> [pawn] MOVEMENT SYSTEM: processing [pathstep] @ [COORDS_TUPLE(pathstep)] with idx [path_idx] (--'d) <-")

				if(pathstep.z != curr_loc.z)
					last_is_delta_z = TRUE
					curr_z_path_len = path_idx
					half_len = CEIL((curr_z_path_len / 2))

					// not sure if get_dir() handles cross-z cases well, so just in case:
					// find a turf corresponding to the pathstep, but on our current Z and get_dir() it
					//var/turf/flattened_pathstep_loc = locate(pathstep.x, pathstep.y, curr_loc.z)
					//if(isnull(staircase) || (staircase.dir != get_dir(curr_loc, flattened_pathstep_loc)))
					if(isnull(currloc_staircase))
						MOVEMENT_DEBUG_LOG("-> [pawn] MOVEMENT SYSTEM: skipping [pathstep] @ [COORDS_TUPLE(pathstep)] - no staircase found at [curr_loc] @ [COORDS_TUPLE(curr_loc)] <-")
						continue

				var/near_zcross = FALSE

				if(last_is_delta_z)
					near_zcross = TRUE
					last_is_delta_z = FALSE

				if(pathstep == banturf)
					MOVEMENT_DEBUG_LOG("-> [pawn] MOVEMENT SYSTEM: skipping [pathstep] @ [COORDS_TUPLE(pathstep)] - banturf <-")
					continue

				var/cand_dist = MANHATTAN_DISTANCE_THREED(curr_loc, pathstep, null, 1)
				var/flat_dist = cand_dist - abs(curr_loc.z - pathstep.z) // just how many 2d moves
				// we could have done this by another MANHATTAN_DISTANCE macro, but this is cheaper ^

				if(isnull(cand_dist))
					// somehow invalid
					MOVEMENT_DEBUG_LOG("-> [pawn] MOVEMENT SYSTEM: skipping [pathstep] @ [COORDS_TUPLE(pathstep)] - null cand_dist <-")
					continue

				// by this point, we know we're on the same z-level

				if(half_len > 6 && cand_dist > half_len)
					// for long paths, try to cut down the linear search to a pseudo-binary one
					#ifdef MOVEMENT_DEBUG_LOGGING
					var/og_path_idx = path_idx
					#endif
					path_idx = min(path_idx, half_len)
					half_len = max(6, CEIL((path_idx / 2)))
					MOVEMENT_DEBUG_LOG("-> [pawn] MOVEMENT SYSTEM: far point [pathstep] @ [COORDS_TUPLE(pathstep)] - cutting down path_idx from [og_path_idx] => [path_idx] <-")

				// whether we cross z-levels by an action, e.g. climbing, or (on FALSE) just a step (e.g. stairs)
				var/object_zcross = FALSE
				object_zcross ||= (!isnull(locate(/obj/structure/ladder) in pathstep))

				var/zcross_action_step = (flat_dist <= 1 && object_zcross && (near_zcross || path_idx == curr_z_path_len))

				if(zcross_action_step || (flat_dist > 0 && flat_dist <= 1))
					// (1) if we're near a ladder or such, stop and wait for the action
					// (2) if we're next to the next path step, go there

					if(!( (pathstep == curr_loc) || (pathstep in fAdjacentTurfs(curr_loc)) ))
						MOVEMENT_DEBUG_LOG("-> [pawn] MOVEMENT SYSTEM: skipping [pathstep] @ [COORDS_TUPLE(pathstep)] - not *actually* adjacent <-")
						continue

					MOVEMENT_DEBUG_LOG("-> [pawn] MOVEMENT SYSTEM: found candidate [pathstep] @ [COORDS_TUPLE(pathstep)] - zcross: [zcross_action_step], at dist: [flat_dist]/[cand_dist] <-")
					bestcand = pathstep
					break

				MOVEMENT_DEBUG_LOG("-> [pawn] MOVEMENT SYSTEM: rejected candidate [pathstep] @ [COORDS_TUPLE(pathstep)] at dist: [flat_dist]/[cand_dist]... <-")

		else
			// the conditions here are immutable between loops, so we'll set allow to false to save on checks
			// because of short-circuiting, this will only need to check a single boolean on a re-do
			allow_steering = FALSE

		var/do_nudging = (src.allow_wandering ? (allow_nudging && isnull(bestcand) && prob(20)) : FALSE)

		if(do_nudging && trgturf?.z == curr_loc.z)
			// Goal-guided steering, lowest quality fallback
			MOVEMENT_DEBUG_LOG("-> [pawn] MOVEMENT SYSTEM: IN NUDGING MODE <-")
			var/list/cardinals = fCardinalTurfs(curr_loc)

			if(isnull(cardinals))
				return

			var/bestscore = null

			for(var/turf/cardturf in cardinals)
				// score should be a float between 0 and 1, ultimately
				// it's effectively a less-flexible, mini-Utility-AI
				if(cardturf.density)
					continue

				if(cardturf == banturf)
					continue

				var/dirscore = PLUS_INF

				var/next_score = MANHATTAN_DISTANCE(cardturf, curr_loc)
				var/dest_score = MANHATTAN_DISTANCE(cardturf, safe_trgturf)

				dirscore = next_score + (dest_score / 10)

				if(isnull(bestscore) || dirscore < bestscore)
					bestscore = dirscore
					bestcand = cardturf

	// Wrap-up: actually move
	if(isnull(bestcand))
		if(src.active_path)
			src.active_path.frustration++
		return

	# ifdef MOVEMENT_DEBUG_LOGGING
	var/og_xpos = pawn.x
	var/og_ypos = pawn.y
	var/og_zpos = pawn.z
	# endif

	//bestcand.pDrawVectorbeam(pawn, bestcand, "n_beam")
	if(bestcand.z != curr_loc.z && MANHATTAN_DISTANCE_THREED(curr_loc, bestcand, PLUS_INF, 0) == 0)
		// (1) don't cross z-levels, unless (2) it's adjacent (as opposed to being in the same tile)
		return

	if(bestcand.z != curr_loc.z)
		// For cross-z steps, we need to do some special handling to avoid magically levitating up
		if(!((bestcand.x != curr_loc.x) || (bestcand.y != curr_loc.y)))
			// Case 1: Moving directly up/down
			// For now, just disallow; no-grav/climbing can be special-cased later
			MOVEMENT_DEBUG_LOG("-> [pawn] MOVEMENT SYSTEM: rejected bestcand [bestcand] @ [COORDS_TUPLE(bestcand)] - not a stairlike move <-")
			return
		/*else
			// Case 2: stair-like move diagonally up
			// We need to trick the AI into moving in the implied 2d direction
			var/bestpos_deltadir = get_dir(curr_loc, bestcand)
			var/turf/fakestep = get_step(curr_loc, bestpos_deltadir)
			if(isnull(fakestep))
				return

			bestcand = fakestep*/


	var/step_result = MovePawn(bestcand)
	MOVEMENT_DEBUG_LOG("[pawn] MOVEMENT SYSTEM: MovePawn [pawn] step_result to [bestcand] @ [COORDS_TUPLE(bestcand)] is: [step_result] | <@[src]> | [__FILE__] -> L[__LINE__]")

	success = step_result

	if(success)
		MOVEMENT_DEBUG_LOG("[pawn] MOVEMENT SYSTEM: Completed a step from ([og_xpos], [og_ypos], [og_zpos]) to [COORDS_TUPLE(bestcand)]")
		src.brain?.SetMemory("LastTile", curr_loc)

		if(src.active_path)
			if(new_path_offset)
				src.active_path.curr_offset = new_path_offset

			if(src.active_path.curr_offset > src.active_path.path.len)
				src.active_path.SetDone()
				//src.active_path.path.Cut()

	else
		MOVEMENT_DEBUG_LOG("[pawn] MOVEMENT SYSTEM: !FAILED! a step from ([og_xpos], [og_ypos], [og_zpos]) to [COORDS_TUPLE(bestcand)]")

		if(src.active_path)
			src.active_path.frustration++

			if(src.active_path.frustration > 5)
				src.brain?.SetMemory(MEM_PATH_ACTIVE, null, 1)

		var/datum/path_smartobject/stored_path_so = src.brain?.GetMemoryValue("AbstractSmartPaths")

		if(istype(stored_path_so))
			stored_path_so.frustration++

	return

