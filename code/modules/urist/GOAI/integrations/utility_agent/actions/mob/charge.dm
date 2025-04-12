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

	var/_timeout = DEFAULT_IF_NULL(timeout, 50)
	var/timedelta = (world.time - tracker.creation_time)

	if(timedelta > _timeout)
		tracker.SetFailed()
		return

	var/walk_initiated = tracker.BBGet("walk_initiated", FALSE)

	if(get_dist(pawn, threat) > 1 && !walk_initiated)
		// move in
		//src.WalkPawnTowards(threat, FALSE)

		if(tracker.failed_ticks >= pathing_fails_to_abort)
			RUN_ACTION_DEBUG_LOG("Failed to find a path from [pawn] to target [threat] | <@[src]> | [__FILE__] -> L[__LINE__]")
			tracker.SetFailed()
			return

		if(!src.active_path || src.active_path.target != threat)
			var/new_path = StartNavigateTo(threat, 1, adjproc = /proc/fCardinalTurfsNoblocksObjpermissive)
			if(isnull(new_path))
				tracker.failed_ticks++
			else
				tracker.failed_ticks = 0
				tracker.BBSet("walk_initiated", TRUE)

		return

	if(get_dist(pawn, threat) <= 1)
		// hit 'em
		if(tracker.failed_ticks)
			if(tracker.failed_ticks >= melee_fails_to_abort)
				tracker.SetFailed()
				return

			var/mob/living/L = pawn
			if(istype(L))
				L.swap_hand()

		var/result = src.Melee(threat)

		if(result)
			tracker.failed_ticks = 0
		else
			tracker.failed_ticks++

	tracker.SetDone()

	return
