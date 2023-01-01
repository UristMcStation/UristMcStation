/* In this module:
===================

 - Misc. actions (not worth their own module yet)

*/


/datum/goai/combatant/proc/HandleShoot(var/datum/ActionTracker/tracker)
	if (tracker.IsStopped())
		return

	if(tracker.IsOlderThan(src.ai_tick_delay * 2))
		tracker.SetFailed()
		return

	states[STATE_CANFIRE] = TRUE
	tracker.SetDone()

	return
