/datum/utility_ai/mob_commander/proc/ShootAt(var/datum/ActionTracker/tracker, var/atom/threat)
	/*
	// Attacks an enemy
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

	var/atom/pawn = src.GetPawn()

	if(!istype(pawn))
		RUN_ACTION_DEBUG_LOG("No owned mob found for [src.name] AI @ L[__LINE__] in [__FILE__]")
		return

	src.Shoot(cached_target=threat)

	var/succeeded = TRUE

	if(succeeded)
		tracker.SetDone()
	else
		var/bb_failures = tracker.BBSetDefault("failed_steps", 0)
		tracker.BBSet("failed_steps", ++bb_failures)

		if(bb_failures > 3)
			tracker.SetFailed()

	return
