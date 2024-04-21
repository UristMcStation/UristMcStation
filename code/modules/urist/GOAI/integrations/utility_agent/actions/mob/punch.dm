/datum/utility_ai/mob_commander/proc/PunchSimple(var/datum/ActionTracker/tracker, var/atom/threat)
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

	var/atom/movable/pawn = src.GetPawn()

	if(!istype(pawn))
		RUN_ACTION_DEBUG_LOG("Pawn is invalid or null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(get_dist(pawn, threat) > 1)
		tracker.SetFailed()
		return

	if(isnull(pawn))
		tracker.SetFailed()
		return

	src.Melee(threat)

	tracker.SetDone()
	return
