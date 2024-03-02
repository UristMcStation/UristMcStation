/datum/utility_ai/mob_commander/proc/Idle(var/datum/ActionTracker/tracker)
	if(isnull(tracker))
		RUN_ACTION_DEBUG_LOG("Tracker position is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(tracker.IsStopped())
		return

	tracker.SetDone()
	return
