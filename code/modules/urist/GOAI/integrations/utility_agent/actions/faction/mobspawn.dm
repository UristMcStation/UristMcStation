/datum/utility_ai/proc/SpawnMob(var/datum/ActionTracker/tracker, var/atom/spawnpoint, var/mobtype)
	/*
	// Spawns a mob.
	*/
	if(isnull(tracker))
		RUN_ACTION_DEBUG_LOG("Tracker is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(tracker.IsStopped())
		return

	if(isnull(spawnpoint))
		RUN_ACTION_DEBUG_LOG("spawnpoint is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	// spawn an agent
	var/mob/M = new mobtype(spawnpoint)

	// give it a commander probably
	M.PosessWithGoaiUtilityCommander()

	// set it to our faction

	var/succeeded = TRUE

	if(succeeded)
		tracker.SetDone()
	else
		var/bb_failures = tracker.BBSetDefault("failed_steps", 0)
		tracker.BBSet("failed_steps", ++bb_failures)

		if(bb_failures > 3)
			tracker.SetFailed()

	return
