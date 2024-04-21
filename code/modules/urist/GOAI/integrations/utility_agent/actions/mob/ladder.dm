
/datum/utility_ai/mob_commander/proc/ClimbLadder(var/datum/ActionTracker/tracker, var/turf/location, var/obj/structure/ladder/target)
	/*
	//
	*/

	GOAI_LOG_DEVEL("Calling ClimbLadder([tracker], [location], [target])!")

	if(isnull(tracker))
		RUN_ACTION_DEBUG_LOG("Tracker position is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(tracker.IsStopped())
		return

	if(isnull(location))
		RUN_ACTION_DEBUG_LOG("location is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	if(!istype(target))
		RUN_ACTION_DEBUG_LOG("target is invalid | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	var/atom/movable/pawn = src.GetPawn()

	if(!istype(pawn))
		RUN_ACTION_DEBUG_LOG("No owned mob found for [src.name] AI @ [__LINE__] in [__FILE__]")
		return FALSE

	var/turf/pawnturf = get_turf(pawn)

	if(isnull(pawnturf))
		RUN_ACTION_DEBUG_LOG("Pawnturf is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	var/is_climbing = tracker.BBGet("climbing")
	var/succeeded = TRUE

	if(!is_climbing)
		if(MANHATTAN_DISTANCE(pawnturf, location) > 1)
			src.allow_wandering = TRUE

		else
			src.allow_wandering = FALSE
			pawn.managed_movement = TRUE

			# ifdef GOAI_LIBRARY_FEATURES
			succeeded = (target.ClimbNow(pawn) || FALSE)
			# endif

			# ifdef GOAI_SS13_SUPPORT
			var/target_ladder = null

			if(target.target_down && target.target_up)
				var/list/curr_path = src.brain?.GetMemoryValue(MEM_PATH_ACTIVE)

				if(isnull(curr_path))
					target_ladder = pick(target.target_down, target.target_up)

				else
					var/atom/endpos = curr_path[curr_path.len]

					if(!istype(endpos))
						// something went wrong, pick at random
						target_ladder = pick(target.target_down, target.target_up)

					if(endpos.z > pawn.z)
						target_ladder = target.target_up

					else if (endpos.z < pawn.z)
						target_ladder = target.target_down

					else
						// should be a rare case but can happen; mostly, if we do weird back and forth z-moves
						// just pick randomly for now; later on, might be worth scanning the path to find out where to move
						target_ladder = pick(target.target_down, target.target_up)

			else if(target.target_down)
				target_ladder = target.target_down

			else if(target.target_up)
				target_ladder = target.target_up

			//var/wake_time = world.time + target.climb_time + 1
			succeeded = target.climbLadder(pawn, target_ladder)
			/*while(world.time < wake_time)
				sleep(1)*/

			# endif

			tracker.BBSet("climbing", 1)

	if(tracker.IsStopped())
		pawn.managed_movement = FALSE
		return

	if(succeeded)
		tracker.SetDone()
		pawn.managed_movement = FALSE
	else
		var/bb_failures = tracker.BBSetDefault("failed_steps", 0)
		tracker.BBSet("failed_steps", ++bb_failures)

		if(bb_failures > 1)
			tracker.SetFailed()
			pawn.managed_movement = FALSE

	return
