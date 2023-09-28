/datum/goai/goai_commander/HandleIdling(var/datum/ActionTracker/tracker)
	src.Idle()

	if(tracker.IsOlderThan(20))
		tracker.SetDone()

	return
