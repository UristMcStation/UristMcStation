
/datum/ActionTracker
	var/datum/tracked_action
	var/timeout_ds = null
	var/list/tracker_blackboard
	var/sleep_time = ACTION_TICK_DELAY

	var/is_rebuilding = FALSE
	var/is_done = FALSE
	var/is_failed = FALSE
	var/is_aborted = FALSE

	var/process = TRUE

	// this doesn't do anything, just prevents multiple things trying to request pause/unpause
	var/_pausetracker = FALSE

	// Special flag; when TRUE, plan is invalid but not failed (typically, a dependency popped up)
	// The value might be a key - this indicates the reason for replan (i.e. OBSTACLE might have an obstacle-specific replanner)
	var/replan = FALSE
	var/list/replan_data

	var/creation_time = null
	var/trigger_time = null
	var/last_check_time = null

	// NOTE: This is a newer API element, some old code may use BB for this instead!
	var/failed_ticks = 0


/datum/ActionTracker/proc/Initialize(var/datum/action, var/timeout = null, var/tick_delay = null, var/run = TRUE)
	if(src.is_rebuilding)
		return

	src.is_rebuilding = TRUE

	src.is_done = FALSE
	src.is_failed = FALSE
	src.is_aborted = FALSE

	src.failed_ticks = 0

	src.process = TRUE

	tracked_action = action || tracked_action
	timeout_ds = timeout

	src.tracker_blackboard = list()

	sleep_time = (isnull(tick_delay) ? (sleep_time || ACTION_TICK_DELAY) : tick_delay)

	var/curr_time = world.time
	creation_time = curr_time
	last_check_time = curr_time

	if(run)
		Run()

	src.is_rebuilding = FALSE


/datum/ActionTracker/New(var/datum/action, var/timeout = null, var/tick_delay = null)
	src.Initialize(action, timeout, tick_delay, TRUE)


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
	if(isnull(src.trigger_time))
		return FALSE

	var/curr_time = isnull(relativeTo) ? world.time : relativeTo
	var/timeDelta = curr_time - trigger_time

	var/result = (timeDelta >= max_lag_ds) ? TRUE : FALSE

	// Need to update last visit time
	src.last_check_time = world.time

	return result


/datum/ActionTracker/proc/IsCheckStale(var/max_lag_ds, var/relativeTo = null)
	var/curr_time = isnull(relativeTo) ? world.time : relativeTo
	var/timeDelta = curr_time - src.last_check_time

	var/result = (timeDelta >= max_lag_ds) ? TRUE : FALSE

	return result


/datum/ActionTracker/proc/IsStopped()
	var/result = (src.is_done || src.is_failed)
	last_check_time = world.time
	return result


/datum/ActionTracker/proc/IsRunning()
	var/result = !(src.IsStopped())
	return result


/datum/ActionTracker/proc/IsTriggered()
	var/result = !isnull(src.trigger_time)
	return result


/datum/ActionTracker/proc/IsAbandoned()
	if (isnull(src.timeout_ds))
		// tasks w/o a timeout are never abandonable
		return FALSE

	var/result = src.IsCheckStale(timeout_ds, world.time)
	return result


/datum/ActionTracker/proc/ShouldAbort()
	return src.is_aborted


/datum/ActionTracker/proc/CheckAbandoned()
	var/abandoned = src.IsAbandoned()
	if(abandoned)
		src.SetFailed()
	return abandoned


/datum/ActionTracker/proc/SetTriggered()
	if(!IsTriggered())
		ACTIONTRACKER_DEBUG_LOG("Setting tracker for [src.tracked_action:name] to triggered!")
		src.trigger_time = world.time
	return


/datum/ActionTracker/proc/ResetTriggered()
	ACTIONTRACKER_DEBUG_LOG("Setting tracker for [src.tracked_action:name] to non-triggered!")
	src.trigger_time = null
	return


/datum/ActionTracker/proc/SetDone()
	if(!is_done)
		ACTIONTRACKER_DEBUG_LOG("Setting tracker for [src.tracked_action:name] to done!")
		//src.tracked_action.ReduceCharges(1)
		src.is_done = TRUE

	return


/datum/ActionTracker/proc/SetFailed()
	if(!is_failed)
		ACTIONTRACKER_DEBUG_LOG("Setting tracker for [src.tracked_action:name] to failed!")
		//src.tracked_action.ReduceCharges(1)
		src.is_failed = TRUE

	return


/datum/ActionTracker/proc/RaiseAbort()
	/* While the code is similar, the purpose of ABORTs is different than
	// normal DONE/FAILED states, hence the different name (Raise vs Set).
	//
	// The latter two are for 'internal' signalling; ABORTs are meant for
	// signalling to the Plan that, for whatever reason, the Plan is no
	// longer valid *as a whole* and needs to be cancelled.
	*/
	ACTIONTRACKER_DEBUG_LOG("Setting tracker for [src.tracked_action:name] to ABORT!!!")
	src.is_aborted = TRUE
	return


/datum/ActionTracker/proc/RaiseReplan(var/reason = null, var/list/replanning_data = null)
	ACTIONTRACKER_DEBUG_LOG("REPLAN raised for tracker [src] with reason: [reason || "null"]")
	src.replan = (reason || TRUE)
	PUT_EMPTY_LIST_IN(src.replan_data)

	if(replanning_data)
		src.replan_data.Add(replanning_data)

	return


/datum/ActionTracker/proc/ResetReplan()
	/* While the code is similar, the purpose of ABORTs is different than
	// normal DONE/FAILED states, hence the different name (Raise vs Set).
	//
	// The latter two are for 'internal' signalling; ABORTs are meant for
	// signalling to the Plan that, for whatever reason, the Plan is no
	// longer valid *as a whole* and needs to be cancelled.
	*/
	ACTIONTRACKER_DEBUG_LOG("REPLAN reset for tracker [src]")
	src.replan = FALSE
	PUT_EMPTY_LIST_IN(src.replan_data)
	return


/datum/ActionTracker/proc/PauseFor(var/time)
	set waitfor = FALSE

	. = TRUE

	if(src._pausetracker)
		return FALSE

	if(!time || time < 0)
		return FALSE

	src._pausetracker = TRUE
	src.process = FALSE

	sleep(time)

	src._pausetracker = TRUE
	src.process = FALSE

	return TRUE


/* Core loop */
/datum/ActionTracker/proc/Run()
	set waitfor = FALSE

	src.is_rebuilding = FALSE

	while (IsRunning())
		CheckAbandoned()

		if(isnull(tracked_action))
			SetFailed()

		sleep(sleep_time)

