//Returns action_key if handled and adds the appropriate action
/datum/goai/mob_commander/proc/HandleWindoorObstruction(var/obj/machinery/door/window/WD, var/list/common_preconds = list(), var/waypoint, var/atom/pawn)
	if(!WD || !waypoint || !pawn || !istype(WD))
		return null

	var/action_key = null

	var/list/open_windoor_preconds = common_preconds.Copy()

	if(src.brain.GetMemoryValue(MEM_OBJ_NOACCESS(WD), null))
		action_key = "[NEED_OBJ_BROKEN(WD)] for [waypoint]"
		open_windoor_preconds[action_key] = -TRUE
		src.SetState(action_key, FALSE)	//Workaround

		var/list/effects = list()
		effects[action_key] = TRUE

		var/list/action_args = list()
		action_args["target"] = WD
		action_args["method"] = "brute"

		AddAction(
			action_key,
			open_windoor_preconds,
			effects,
			/datum/goai/mob_commander/proc/HandleGenericBreak,
			300 + rand() - (pawn ? get_dist(WD, pawn) : 0),
			1,
			FALSE,
			action_args
		)

	else
		action_key = "[NEED_OBSTACLE_OPEN(WD)] for [waypoint]"
		open_windoor_preconds[action_key] = -TRUE
		src.SetState(action_key, FALSE)	//Workaround

		var/list/effects = list()
		effects[action_key] = TRUE

		var/list/action_args = list()
		action_args["obstruction"] = WD

		AddAction(
			action_key,
			open_windoor_preconds,
			effects,
			/datum/goai/mob_commander/proc/HandleWindoorOpen,
			10 + rand() - (pawn ? get_dist(WD, pawn) : 0),
			1,
			FALSE,
			action_args
		)
	return action_key


/datum/goai/mob_commander/proc/HandleWindoorOpen(var/datum/ActionTracker/tracker, var/obj/machinery/door/window/obstruction)
	var/mob/pawn = src.GetPawn()
	if (!pawn || !istype(pawn))
		return

	if (!tracker)
		return

	if(tracker.IsOlderThan(src.ai_tick_delay * 10))
		tracker.SetFailed()
		if(src.brain.GetMemoryValue(MEM_OBSTRUCTION("WAYPOINT"), null) == obstruction)
			src.brain.DropMemory(MEM_OBSTRUCTION("WAYPOINT"))
		return

	var/turf/obs_turf = get_turf(obstruction)
	var/dist_to_obs = ChebyshevDistance(get_turf(pawn), obs_turf)

	if(dist_to_obs < 2 && obstruction.density)
		obstruction.attack_hand(pawn)
		if(!obstruction.allowed(pawn))
			tracker.SetFailed()
			src.brain.SetMemory(MEM_OBJ_NOACCESS(obstruction), TRUE)
			if(src.brain.GetMemoryValue(MEM_OBSTRUCTION("WAYPOINT"), null) == obstruction)
				src.brain.DropMemory(MEM_OBSTRUCTION("WAYPOINT"))
			return

	if(!obstruction.density)
		//Todo: Check dir and step + 1 towards waypoint where applicable
		if(dist_to_obs < 1)
			if(tracker.IsRunning())
				if(src.brain.GetMemoryValue(MEM_OBSTRUCTION("WAYPOINT"), null) == obstruction)
					src.brain.DropMemory(MEM_OBSTRUCTION("WAYPOINT"))
				tracker.SetDone()
				obstruction.attack_hand(pawn)	//Windoors don't auto-close. Let's be polite and close it after us
		else
			if(!tracker.BBGet("entering_door", FALSE))
				StartNavigateTo(obs_turf, 0)
				tracker.BBSet("entering_door", TRUE)
	else
		var/list/path_to_door = tracker.BBGet("PathToDoor", null)
		if(isnull(path_to_door) || !src.active_path)
			path_to_door = StartNavigateTo(obs_turf, 1)
			tracker.BBSet("PathToDoor", path_to_door)