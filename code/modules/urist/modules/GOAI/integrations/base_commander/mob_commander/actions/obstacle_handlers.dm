/datum/goai/mob_commander/proc/HandleOpenDoor(var/datum/ActionTracker/tracker, var/obj/cover/door/obstruction)
	var/atom/pawn = src.GetPawn()
	if(!pawn)
		ACTION_RUNTIME_DEBUG_LOG("[src] does not have an owned mob!")
		return

	if(!tracker)
		return

	var/walk_dist = (tracker?.BBSetDefault("StartDist", (ManhattanDistance(get_turf(pawn), obstruction) || 0)) || 0)

	if(tracker.IsOlderThan(src.ai_tick_delay * (10 + walk_dist)))
		tracker.SetFailed()
		return

	var/obj/cover/door/obsdoor = obstruction

	if(isnull(obsdoor))
		ACTION_RUNTIME_DEBUG_LOG("[src] HandleOpenDoor - no Obstruction!")
		tracker.SetFailed()
		return

	/*if(!istype(obsdoor))
		ACTION_RUNTIME_DEBUG_LOG("[src] HandleOpenDoor - wrong type!")
		tracker.SetFailed()
		return*/

	var/turf/obs_turf = get_turf(obsdoor)
	var/dist_to_obs = ChebyshevDistance(get_turf(pawn), obs_turf)
	var/opened = FALSE

	while(dist_to_obs < 2 && !(obstruction.open))
		// Within 1-tile range diagonally? Open it.
		opened = obsdoor.Open()
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

			//if(src.active_path && src.active_path.target)
				//var/turf/active_path_target = get_turf(src.active_path.target)

				//if(active_path_target && active_path_target == obs_turf && src.active_path.min_dist <= 0)
				//	entering_door = TRUE

			if(!entering_door)
				StartNavigateTo(obs_turf, 0)
				tracker.BBSet("entering_door", TRUE)

	else
		// Closed and too far to open? Move to adjacent tile.
		var/list/path_to_door = tracker.BBGet("PathToDoor", null)

		if(isnull(path_to_door) || !src.active_path)
			path_to_door = StartNavigateTo(obs_turf, 1)
			tracker.BBSet("PathToDoor", path_to_door)

	return


/datum/goai/mob_commander/proc/HandleOpenAutodoor(var/datum/ActionTracker/tracker, var/obstruction)

	var/atom/pawn = src.GetPawn()
	if(!pawn)
		ACTION_RUNTIME_DEBUG_LOG("[src] does not have an owned mob!")
		return

	if(!tracker)
		return

	var/walk_dist = (tracker?.BBSetDefault("StartDist", (ManhattanDistance(get_turf(pawn), obstruction) || 0)) || 0)

	if(tracker.IsOlderThan(src.ai_tick_delay * (10 + walk_dist)))
		tracker.SetFailed()
		return

	var/obj/cover/autodoor/obsdoor = obstruction

	if(isnull(obsdoor))
		tracker.SetFailed()
		return

	var/turf/obs_turf = get_turf(obsdoor)
	var/dist_to_obs = ChebyshevDistance(get_turf(pawn), obs_turf)
	var/opened = FALSE

	if(dist_to_obs < 2 && !(obsdoor.open))
		// Within 1-tile range diagonally? Open it.
		opened = obsdoor.Open()

	if(obsdoor.open || opened)
		if(dist_to_obs < 1)
			// Literally in the doorway - we're done.
			if(tracker.IsRunning())
				tracker.SetDone()

		else
			// Body-block the door so it doesn't close.
			var/entering_door = tracker.BBGet("entering_door", FALSE)

			//if(src.active_path && src.active_path.target)
			//	var/turf/active_path_target = get_turf(src.active_path.target)

				//if(active_path_target && active_path_target == obs_turf)
				//	entering_door = TRUE

			if(!entering_door)
				StartNavigateTo(obs_turf, 0)
				tracker.BBSet("entering_door", TRUE)


	else
		// Closed and too far to open? Move to adjacent tile.
		var/list/path_to_door = tracker.BBGet("PathToDoor", null)

		if(isnull(path_to_door) || !src.active_path)
			path_to_door = StartNavigateTo(obsdoor, 1)
			tracker.BBSet("PathToDoor", path_to_door)

	return
