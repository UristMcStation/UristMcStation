/datum/utility_ai/mob_commander/proc/ChargeInPunch(var/datum/ActionTracker/tracker, var/atom/threat, var/pathing_fails_to_abort = 5, var/melee_fails_to_abort = 2, var/timeout = null)
	/*
	// Closes into melee range, then melees an enemy.
	*/

	if(isnull(tracker))
		RUN_ACTION_DEBUG_LOG("Tracker is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(tracker.IsStopped())
		return

	if(isnull(threat))
		RUN_ACTION_DEBUG_LOG("Threat is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	var/atom/movable/pawn = src.GetPawn()

	if(!istype(pawn))
		RUN_ACTION_DEBUG_LOG("Pawn is invalid or null | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	var/_timeout = DEFAULT_IF_NULL(timeout, 100)
	var/timedelta = (world.time - tracker.creation_time)

	if(timedelta > _timeout)
		tracker.SetFailed()
		return

	var/walk_initiated = tracker.BBGet("walk_initiated", FALSE)

	if(get_dist(pawn, threat) > 1 && !walk_initiated)
		// move in
		//src.WalkPawnTowards(threat, FALSE)

		if(tracker.failed_ticks >= pathing_fails_to_abort)
			RUN_ACTION_DEBUG_LOG("Failed to find a path from [pawn] ([LOCATION_WITH_COORDS(pawn)] to target [threat] ([LOCATION_WITH_COORDS(threat)] | <@[src]> | [__FILE__] -> L[__LINE__]")
			tracker.SetFailed()
			return

		if(!src.active_path || src.active_path.target != threat)
			ADD_GOAI_TEMP_GIZMO_SAFEINIT(get_turf(threat), "redO")

			src.brain.SetMemory(MEM_AI_TARGET, threat)
			src.brain.SetMemory(MEM_AI_TARGET_MINDIST, 1)
			src.brain.SetMemory(MEM_WAYPOINT_IDENTITY, threat)
			tracker.BBSet("walk_initiated", TRUE)

			/*
			var/new_path = StartNavigateTo(threat, 1, adjproc = GLOBAL_PROC_REF(fCardinalTurfsNoblocksObjpermissive))

			if(isnull(new_path))
				tracker.failed_ticks++
			else
				tracker.failed_ticks = 0
				tracker.BBSet("walk_initiated", TRUE)
			*/

		return

	if(get_dist(pawn, threat) <= 1)
		// hit 'em
		if(tracker.failed_ticks)
			if(tracker.failed_ticks >= melee_fails_to_abort)
				tracker.SetFailed()
				return

			#ifdef GOAI_SS13_SUPPORT
			/*
			// commented out due to weird runtimes
			var/mob/living/L = pawn
			if(istype(L))
				L.swap_hand()
			*/
			#endif

		var/result = src.Melee(threat)

		if(result)
			tracker.failed_ticks = 0
			tracker.SetDone()
		else
			tracker.failed_ticks++

	return
