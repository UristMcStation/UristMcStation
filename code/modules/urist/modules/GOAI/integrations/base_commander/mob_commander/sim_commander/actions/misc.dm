/* In this module:
===================

 - Misc. actions (not worth their own module yet)

*/


/datum/goai/mob_commander/sim_commander/proc/HandleSleeping(var/datum/ActionTracker/tracker)
	if(!(src.pawn))
		to_world_log("[src] has no pawns!")
		tracker.SetFailed()
		return

	var/obj/bed/sleeploc = locate()
	if(!sleeploc)
		tracker.SetFailed()

	var/dist = ManhattanDistance(src.pawn, sleeploc)

	if(dist <= 1)
		if(!("TimeAt" in tracker.tracker_blackboard))
			tracker.tracker_blackboard["TimeAt"] = 0
		else
			tracker.tracker_blackboard["TimeAt"] = tracker.tracker_blackboard["TimeAt"] + 1

		src.AddMotive(MOTIVE_SLEEP, 5)

		if(prob(20))
			var/mob/goai/sim/sim_pawn = src.pawn
			if(!isnull(sim_pawn))
				sim_pawn.Say("Zzzzzzz...")


	if(dist > 0)
		if(!src.active_path || (src.active_path.target != sleeploc))
			src.StartNavigateTo(sleeploc, 0)

		else if(src.active_path)
			src.active_path.frustration++


	if(brain && brain.needs)
		var/sleepiness = src.GetMotive(MOTIVE_SLEEP)
		if(sleepiness && sleepiness > NEED_SATISFIED)
			tracker.SetDone()


	else if(tracker.tracker_blackboard["TimeAt"] > 10)
		tracker.SetDone()


	else if(tracker.IsOlderThan(600))
		tracker.SetFailed()


/datum/goai/mob_commander/sim_commander/proc/HandleIdle(var/datum/ActionTracker/tracker)
	if(!(src.pawn))
		to_world_log("[src] has no pawns!")
		return

	Idle()
	src.AddMotive(MOTIVE_FOOD, -1)
	src.AddMotive(MOTIVE_SLEEP, 1)

	if(tracker.IsOlderThan(20))
		tracker.SetDone()

	return



/datum/goai/mob_commander/sim_commander/proc/HandleEating(var/datum/ActionTracker/tracker)
	if(!(src.pawn))
		to_world_log("[src] has no pawns!")
		tracker.SetFailed()
		return

	var/obj/food/noms = locate()
	if(!noms)
		tracker.SetFailed()

	var/dist = ManhattanDistance(src.pawn, noms)

	var/time_at = ("TimeAt" in tracker.tracker_blackboard ? tracker.tracker_blackboard["TimeAt"] : null)
	to_world_log("NOMS DIST: [dist]")
	to_world_log("TIME AT NOMS: [time_at]")

	if(dist <= 1)
		if(!("TimeAt" in tracker.tracker_blackboard))
			tracker.tracker_blackboard["TimeAt"] = 0
		else
			tracker.tracker_blackboard["TimeAt"] = tracker.tracker_blackboard["TimeAt"] + 1

		var/mob/goai/sim/sim_pawn = src.pawn
		if(!isnull(sim_pawn))
			sim_pawn.Say("Zzzzzzz...")

		src.AddMotive(MOTIVE_FOOD, 6)

	if(dist > 0)
		if(!src.active_path || (src.active_path.target != noms))
			StartNavigateTo(noms, 0)

	else if(tracker.tracker_blackboard["TimeAt"] > 10)
		tracker.SetDone()
		src.AddMotive(MOTIVE_FOOD, 5)

	else if(tracker.IsOlderThan(600))
		tracker.SetFailed()


/datum/goai/mob_commander/sim_commander/proc/HandleWorking(var/datum/ActionTracker/tracker)
	if(!(src.pawn))
		to_world_log("[src] has no pawns!")
		tracker.SetFailed()
		return

	var/obj/desk/workdesk = locate()
	if(!workdesk)
		tracker.SetFailed()

	tracker.tracker_blackboard["Desk"] = workdesk

	var/dist = ManhattanDistance(src.pawn, workdesk)

	to_world_log("DESK DIST: [dist]")

	if(dist <= 0)
		if(!("TimeAt" in tracker.tracker_blackboard))
			tracker.tracker_blackboard["TimeAt"] = 0
		else
			tracker.tracker_blackboard["TimeAt"] = tracker.tracker_blackboard["TimeAt"] + 1

		var/curr_time_at = tracker.tracker_blackboard["TimeAt"]
		to_world_log("TIME AT DESK: [curr_time_at]")
		src.AddMotive(MOTIVE_FUN, -0.25)

	if(dist > 0)
		if(!src.active_path || (src.active_path.target != workdesk))
			StartNavigateTo(workdesk, 0)

	if(tracker.tracker_blackboard["TimeAt"] > 10)
		tracker.SetDone()

	if(tracker.IsOlderThan(600))
		tracker.SetFailed()


/datum/goai/mob_commander/sim_commander/proc/HandlePartying(var/datum/ActionTracker/tracker)
	if(!(src.pawn))
		to_world_log("[src] has no pawns!")
		tracker.SetFailed()
		return

	src.AddMotive(MOTIVE_SLEEP, rand(-1, 2))
	src.AddMotive(MOTIVE_FUN, 5)

	var/mob/goai/sim/sim_pawn = pawn
	if(!(isnull(sim_pawn)))
		sim_pawn.randMove()

	if(tracker.IsOlderThan(40))
		tracker.SetDone()


/datum/goai/mob_commander/sim_commander/proc/HandleShopping(var/datum/ActionTracker/tracker)
	if(!(src.pawn))
		to_world_log("[src] has no pawns!")
		tracker.SetFailed()
		return

	var/obj/vending/vendor = locate()
	if(!vendor)
		tracker.SetFailed()

	tracker.tracker_blackboard["Vendor"] = vendor

	var/dist = ChebyshevDistance(src.pawn, vendor)

	to_world_log("VENDOR DIST: [dist]")

	if(dist <= 1)
		if(!("TimeAt" in tracker.tracker_blackboard))
			tracker.tracker_blackboard["TimeAt"] = 0
		else
			tracker.tracker_blackboard["TimeAt"] = tracker.tracker_blackboard["TimeAt"] + 1

	if(dist > 1)
		if(!src.active_path || (src.active_path.target != vendor))
			StartNavigateTo(vendor, 1)

	if(tracker.tracker_blackboard["TimeAt"] > 5)
		tracker.SetDone()

	if(tracker.IsOlderThan(600))
		tracker.SetFailed()
