/datum/goai/goai_commander/HandleIdling(var/datum/ActionTracker/tracker)
	world.log << "[src.name] idling..."
	src.Idle()

	if(tracker.IsOlderThan(20))
		tracker.SetDone()

	return
