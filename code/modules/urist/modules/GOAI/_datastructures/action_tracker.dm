/datum/ActionTracker
	var/datum/goai_action/tracked_action
	var/timeout_ds = null
	var/list/tracker_blackboard
	var/sleep_time = AI_TICK_DELAY

	var/is_done = FALSE
	var/is_failed = FALSE
	var/is_aborted = FALSE

	var/creation_time = null
	var/trigger_time = null
	var/last_check_time = null


/datum/ActionTracker/New(var/datum/goai_action/action, var/timeout = null, var/tick_delay = null)
	tracked_action = action || tracked_action
	timeout_ds = timeout
	tracker_blackboard = list()
	sleep_time = (isnull(tick_delay) ? (sleep_time || AI_TICK_DELAY) : tick_delay)

	var/curr_time = world.time
	creation_time = curr_time
	last_check_time = curr_time

	spawn(0)
		Run()


/* == Blackboard (hence 'BB') management == */
/datum/ActionTracker/proc/BBGet(var/key, var/default = null)
	var/rval = default

	if (key in tracker_blackboard)
		rval = tracker_blackboard[key]

	return rval


/datum/ActionTracker/proc/BBSet(var/key, var/val)
	tracker_blackboard[key] = val
	return 1


/datum/ActionTracker/proc/BBSetDefault(var/key, var/default = null)
	var/rval = default
	if (key in tracker_blackboard)
		rval = tracker_blackboard[key]
	else
		tracker_blackboard[key] = rval
	return rval


/* == State management == */
/datum/ActionTracker/proc/IsOlderThan(var/max_lag_ds, var/relativeTo = null)
	var/curr_time = isnull(relativeTo) ? world.time : relativeTo
	var/timeDelta = curr_time - creation_time

	var/result = (timeDelta >= max_lag_ds) ? TRUE : FALSE

	// Need to update last visit time
	last_check_time = world.time

	return result


/datum/ActionTracker/proc/TriggeredMoreThan(var/max_lag_ds, var/relativeTo = null)
	if(isnull(trigger_time))
		return FALSE

	var/curr_time = isnull(relativeTo) ? world.time : relativeTo
	var/timeDelta = curr_time - trigger_time

	var/result = (timeDelta >= max_lag_ds) ? TRUE : FALSE

	// Need to update last visit time
	last_check_time = world.time

	return result


/datum/ActionTracker/proc/IsCheckStale(var/max_lag_ds, var/relativeTo = null)
	var/curr_time = isnull(relativeTo) ? world.time : relativeTo
	var/timeDelta = curr_time - last_check_time

	var/result = (timeDelta >= max_lag_ds) ? TRUE : FALSE

	return result


/datum/ActionTracker/proc/IsStopped()
	var/result = (is_done || is_failed)
	last_check_time = world.time
	return result


/datum/ActionTracker/proc/IsRunning()
	var/result = !IsStopped()
	return result


/datum/ActionTracker/proc/IsTriggered()
	var/result = !isnull(trigger_time)
	return result


/datum/ActionTracker/proc/IsAbandoned()
	if (isnull(timeout_ds))
		// tasks w/o a timeout are never abandonable
		return FALSE

	var/result = IsCheckStale(timeout_ds, world.time)
	return result


/datum/ActionTracker/proc/ShouldAbort()
	return is_aborted


/datum/ActionTracker/proc/CheckAbandoned()
	var/abandoned = IsAbandoned()
	if(abandoned)
		SetFailed()
	return abandoned


/datum/ActionTracker/proc/SetTriggered()
	if(!IsTriggered())
		world.log << "Setting tracker to triggered!"
		trigger_time = world.time
	return


/datum/ActionTracker/proc/ResetTriggered()
	world.log << "Setting tracker to non-triggered!"
	trigger_time = null
	return


/datum/ActionTracker/proc/SetDone()
	if(!is_done)
		world.log << "Setting tracker to done!"
		tracked_action.ReduceCharges(1)
		is_done = TRUE

	return


/datum/ActionTracker/proc/SetFailed()
	if(!is_failed)
		world.log << "Setting tracker to failed!"
		tracked_action.ReduceCharges(1)
		is_failed = TRUE

	return


/datum/ActionTracker/proc/RaiseAbort()
	/* While the code is similar, the purpose of ABORTs is different than
	// normal DONE/FAILED states, hence the different name (Raise vs Set).
	//
	// The latter two are for 'internal' signalling; ABORTs are meant for
	// signalling to the Plan that, for whatever reason, the Plan is no
	// longer valid *as a whole* and needs to be cancelled.
	*/
	world.log << "Setting tracker to ABORT!!!"
	is_aborted = TRUE
	return


/* Core loop */
/datum/ActionTracker/proc/Run()
	while (IsRunning())
		CheckAbandoned()

		if(isnull(tracked_action))
			SetFailed()

		sleep(sleep_time)

