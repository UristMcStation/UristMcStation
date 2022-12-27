/mob/goai/combatant/proc/HandleOpenDoor(var/datum/ActionTracker/tracker)
	if(!tracker)
		return

	if(tracker.IsOlderThan(src.ai_tick_delay * 10))
		tracker.SetFailed()
		return

	var/obj/cover/door/obstruction = brain.GetMemoryValue(MEM_OBSTRUCTION, null)

	if(isnull(obstruction))
		to_world_log("[src] HandleOpenDoor - no Obstruction!")
		tracker.SetFailed()
		return

	var/turf/obs_turf = get_turf(obstruction)
	var/dist_to_obs = ChebyshevDistance(get_turf(src), obs_turf)
	var/opened = FALSE

	while(dist_to_obs < 2 && !(obstruction.open))
		// Within 1-tile range diagonally? Open it.
		opened = obstruction.Open()
		if(opened)
			break

	if(obstruction.open || opened)
		if(dist_to_obs < 1)
			// Literally in the doorway - we're done.
			if(tracker.IsRunning())
				tracker.SetDone()

		else
			// Body-block the door so it doesn't close.
			var/entering_door = tracker.BBGet("entering_door", FALSE)

			//if(active_path && active_path.target)
				//var/turf/active_path_target = get_turf(active_path.target)

				//if(active_path_target && active_path_target == obs_turf && active_path.min_dist <= 0)
				//	entering_door = TRUE

			if(!entering_door)
				StartNavigateTo(obstruction, 0)
				tracker.BBSet("entering_door", TRUE)

	else
		// Closed and too far to open? Move to adjacent tile.
		var/list/path_to_door = tracker.BBGet("PathToDoor", null)

		if(isnull(path_to_door) || !active_path)
			path_to_door = StartNavigateTo(obstruction, 1)
			tracker.BBSet("PathToDoor", path_to_door)

	return


/mob/goai/combatant/proc/HandleOpenAutodoor(var/datum/ActionTracker/tracker)
	if(!tracker)
		return

	if(tracker.IsOlderThan(src.ai_tick_delay * 10))
		tracker.SetFailed()
		return

	var/obj/cover/autodoor/obstruction = brain.GetMemoryValue(MEM_OBSTRUCTION, null)

	if(isnull(obstruction))
		tracker.SetFailed()
		return

	var/turf/obs_turf = get_turf(obstruction)
	var/dist_to_obs = ChebyshevDistance(get_turf(src), obs_turf)
	var/opened = FALSE

	if(dist_to_obs < 2 && !(obstruction.open))
		// Within 1-tile range diagonally? Open it.
		opened = obstruction.Open()

	if(obstruction.open || opened)
		if(dist_to_obs < 1)
			// Literally in the doorway - we're done.
			if(tracker.IsRunning())
				tracker.SetDone()

		else
			// Body-block the door so it doesn't close.
			var/entering_door = tracker.BBGet("entering_door", FALSE)

			//if(active_path && active_path.target)
			//	var/turf/active_path_target = get_turf(active_path.target)

				//if(active_path_target && active_path_target == obs_turf)
				//	entering_door = TRUE

			if(!entering_door)
				StartNavigateTo(obstruction, 0)
				tracker.BBSet("entering_door", TRUE)


	else
		// Closed and too far to open? Move to adjacent tile.
		var/list/path_to_door = tracker.BBGet("PathToDoor", null)

		if(isnull(path_to_door) || !active_path)
			path_to_door = StartNavigateTo(obstruction, 1)
			tracker.BBSet("PathToDoor", path_to_door)

	return
