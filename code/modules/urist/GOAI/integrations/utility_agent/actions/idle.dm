/datum/utility_ai/mob_commander/proc/Idle(var/datum/ActionTracker/tracker)
	if(isnull(tracker))
		RUN_ACTION_DEBUG_LOG("Tracker position is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(tracker.IsStopped())
		return

	src.allow_wandering = TRUE

	var/datum/brain/utility/needybrain = src.brain
	if(istype(needybrain))
		needybrain.AddMotive(NEED_COMPOSURE, MAGICNUM_COMPOSURE_GAIN_IDLE)

	tracker.SetDone()
	return
