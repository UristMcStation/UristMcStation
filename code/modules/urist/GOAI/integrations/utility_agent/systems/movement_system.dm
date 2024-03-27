// This is a System, i.e. a proc called by an endless loop spawned by the Commander class on init.

/datum/utility_ai/mob_commander/proc/MovementSystem()
	var/atom/movable/pawn = src.GetPawn()

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
		MOVEMENT_DEBUG_LOG("MovementSystem idle; safe_trgturf is null! | [__FILE__] -> L[__LINE__]")
		return

	var/localdist = MANHATTAN_DISTANCE(trgturf, curr_loc)
	if(!localdist)
		MOVEMENT_DEBUG_LOG("MovementSystem idle; already at target! | [__FILE__] -> L[__LINE__]")
		return

	var/success = FALSE
	var/turf/bestcand = null

	// Prevent wandering into special case turfs like forced step-aways
	var/turf/banturf = src.brain?.GetMemoryValue("DontWanderToTurf")

	if(!isnull(src.active_path) && (src.active_path.path.len >= src.active_path.curr_offset) && !src.active_path.IsDone())
		// Path-following mode:
		MOVEMENT_DEBUG_LOG("-> MOVEMENT SYSTEM: IN PATH-FOLLOWING MODE <-")

		var/atom/next_step = src.active_path.path[src.active_path.curr_offset]
		var/atom/destination = src.active_path.path[src.active_path.path.len]

		var/turf/prev_draw_pos = null

		for(var/turf/drawpos in src.active_path.path)
			// debug path drawing
			if(!isnull(prev_draw_pos))
				drawpos.pDrawVectorbeam(prev_draw_pos, drawpos, "y_beam")

			prev_draw_pos = drawpos

		if(isnull(curr_loc))
			return

		// Score potential steps for steering purposes
		var/list/cardinals = curr_loc.CardinalTurfs()

		if(isnull(cardinals))
			return

		var/bestscore = null

		for(var/turf/cardturf in cardinals)
			// score should be a float between 0 and 1, ultimately
			// it's effectively a less-flexible, mini-Utility-AI
			if(cardturf.density)
				continue

			if(cardturf == banturf)
				return

			var/dirscore = PLUS_INF

			var/next_score = MANHATTAN_DISTANCE(cardturf, next_step)
			var/dest_score = MANHATTAN_DISTANCE(cardturf, destination)

			dirscore = min(next_score, dest_score * 20)
			dirscore += rand() * 0.1
			dirscore += src.active_path.frustration * (0.5 + rand())

			//MOVEMENT_DEBUG_LOG("Score for [cardturf] is [dirscore], best: [bestscore] for [bestcand] | <@[src]> | [__FILE__] -> L[__LINE__]")

			if(isnull(bestscore) || dirscore < bestscore)
				bestscore = dirscore
				bestcand = cardturf

	if(isnull(bestcand) && curr_path)
		// Path-guided steering:
		MOVEMENT_DEBUG_LOG("-> MOVEMENT SYSTEM: IN STEERING MODE <-")
		var/turf/path_pos = null
		var/path_idx = 1
		var/path_len = curr_path.len

		while(path_idx < path_len)
			// this could be optimized to search only the part of the path close to curr_loc
			// (check distance to both ends and search that half only)
			var/turf/pathstep = curr_path[path_idx++]

			var/cand_dist = MANHATTAN_DISTANCE(curr_loc, pathstep)

			if(!cand_dist)
				if(pathstep == banturf)
					// if next step is a banturf, just do nothing
					// and let the special case sort itself out externally
					return

				// found it
				path_pos = pathstep
				break

		if(isnull(path_pos))
			return

		bestcand = curr_path[path_idx]

	var/do_nudging = src.allow_wandering ? FALSE : (isnull(bestcand) && prob(20))

	if(do_nudging && trgturf.z == curr_loc.z)
		// Goal-guided steering, lowest quality fallback
		MOVEMENT_DEBUG_LOG("-> MOVEMENT SYSTEM: IN NUDGING MODE <-")
		var/list/cardinals = curr_loc.CardinalTurfs()

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

			dirscore = next_score + rand(dest_score / 2, dest_score * 2) * 0.1

			//MOVEMENT_DEBUG_LOG("Score for [cardturf] is [dirscore], best: [bestscore] for [bestcand] | <@[src]> | [__FILE__] -> L[__LINE__]")

			if(isnull(bestscore) || dirscore < bestscore)
				bestscore = dirscore
				bestcand = cardturf

	// Wrap-up: actually move
	if(isnull(bestcand))
		return

	# ifdef MOVEMENT_DEBUG_LOGGING
	var/og_xpos = pawn.x
	var/og_ypos = pawn.y
	# endif

	//bestcand.pDrawVectorbeam(pawn, bestcand, "n_beam")
	var/step_result = MovePawn(bestcand)
	MOVEMENT_DEBUG_LOG("MovePawn step_result is [step_result] | <@[src]> | [__FILE__] -> L[__LINE__]")

	success = (
		step_result || (
			(pawn.x == bestcand.x) && (pawn.y == bestcand.y)
		)
	)

	if(success)
		MOVEMENT_DEBUG_LOG("MOVEMENT SYSTEM: Completed a step from ([og_xpos], [og_ypos]) to ([bestcand.x], [bestcand.y])")
		src.brain?.SetMemory("LastTile", curr_loc)

		if(src.active_path)
			src.active_path.curr_offset++

			if(src.active_path.curr_offset > src.active_path.path.len)
				src.active_path.SetDone()
				//src.active_path.path.Cut()
	else
		MOVEMENT_DEBUG_LOG("MOVEMENT SYSTEM: !FAILED! a step from ([og_xpos], [og_ypos]) to ([bestcand.x], [bestcand.y])")

		if(src.active_path)
			src.active_path.frustration++

			if(src.active_path.frustration > 5)
				src.brain?.SetMemory(MEM_PATH_ACTIVE, null, 1)

		var/datum/path_smartobject/stored_path_so = src.brain?.GetMemoryValue("AbstractSmartPaths")

		if(istype(stored_path_so))
			stored_path_so.frustration++

	return

