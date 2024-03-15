/datum/utility_ai/mob_commander/proc/FakeGrenadeThrow(var/datum/ActionTracker/tracker, var/atom/target)
	/*
	// Spans and throws a new fake grenade
	*/
	if(isnull(tracker))
		RUN_ACTION_DEBUG_LOG("Tracker is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(tracker.IsStopped())
		return

	if(isnull(target))
		RUN_ACTION_DEBUG_LOG("Target is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	var/atom/pawn = src.GetPawn()

	if(isnull(pawn))
		RUN_ACTION_DEBUG_LOG("Pawn is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	grenade_spawnyeet(target, pawn)

	var/succeeded = TRUE

	if(succeeded)
		tracker.SetDone()
	else
		var/bb_failures = tracker.BBSetDefault("failed_steps", 0)
		tracker.BBSet("failed_steps", ++bb_failures)

		if(bb_failures > 3)
			tracker.SetFailed()

	return
