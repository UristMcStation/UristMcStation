
/mob/goai/sim/proc/HandleSleeping(var/datum/ActionTracker/tracker)
	var/obj/bed/sleeploc = locate()
	if(!sleeploc)
		tracker.SetFailed()

	var/dist = ManhattanDistance(src, sleeploc)

	if(dist <= 1)
		if(!("TimeAt" in tracker.tracker_blackboard))
			tracker.tracker_blackboard["TimeAt"] = 0
		else
			tracker.tracker_blackboard["TimeAt"] = tracker.tracker_blackboard["TimeAt"] + 1

		AddMotive(MOTIVE_SLEEP, 5)

		if(prob(20))
			Say("Zzzzzzz...")


	if(dist > 0)
		if(!active_path || (active_path.target != sleeploc))
			StartNavigateTo(sleeploc, 0)

		else if(active_path)
			active_path.frustration++


	if(brain && brain.needs)
		var/sleepiness = GetMotive(MOTIVE_SLEEP)
		if(sleepiness && sleepiness > NEED_SATISFIED)
			tracker.SetDone()


	else if(tracker.tracker_blackboard["TimeAt"] > 10)
		tracker.SetDone()


	else if(tracker.IsOlderThan(600))
		tracker.SetFailed()


/mob/goai/sim/proc/HandleIdling(var/datum/ActionTracker/tracker)
	Idle()
	AddMotive(MOTIVE_FOOD, -1)
	AddMotive(MOTIVE_SLEEP, 1)

	if(tracker.IsOlderThan(20))
		tracker.SetDone()

	return


/mob/goai/sim/proc/HandleEating(var/datum/ActionTracker/tracker)
	var/obj/food/noms = locate()
	if(!noms)
		tracker.SetFailed()

	var/dist = ManhattanDistance(src, noms)

	var/time_at = ("TimeAt" in tracker.tracker_blackboard ? tracker.tracker_blackboard["TimeAt"] : null)
	world.log << "NOMS DIST: [dist]"
	world.log << "TIME AT NOMS: [time_at]"

	if(dist <= 1)
		if(!("TimeAt" in tracker.tracker_blackboard))
			tracker.tracker_blackboard["TimeAt"] = 0
		else
			tracker.tracker_blackboard["TimeAt"] = tracker.tracker_blackboard["TimeAt"] + 1

		Say("OM NOM NOM!")
		AddMotive(MOTIVE_FOOD, 6)

	if(dist > 0)
		if(!active_path || (active_path.target != noms))
			StartNavigateTo(noms, 0)

	else if(tracker.tracker_blackboard["TimeAt"] > 10)
		tracker.SetDone()
		AddMotive(MOTIVE_FOOD, 5)

	else if(tracker.IsOlderThan(600))
		tracker.SetFailed()


/mob/goai/sim/proc/HandleWorking(var/datum/ActionTracker/tracker)
	var/obj/desk/workdesk = locate()
	if(!workdesk)
		tracker.SetFailed()

	tracker.tracker_blackboard["Desk"] = workdesk

	var/dist = ManhattanDistance(src, workdesk)

	world.log << "DESK DIST: [dist]"

	if(dist <= 0)
		if(!("TimeAt" in tracker.tracker_blackboard))
			tracker.tracker_blackboard["TimeAt"] = 0
		else
			tracker.tracker_blackboard["TimeAt"] = tracker.tracker_blackboard["TimeAt"] + 1

		var/curr_time_at = tracker.tracker_blackboard["TimeAt"]
		world.log << "TIME AT DESK: [curr_time_at]"
		AddMotive(MOTIVE_FUN, -0.25)

	if(dist > 0)
		if(!active_path || (active_path.target != workdesk))
			StartNavigateTo(workdesk, 0)

	if(tracker.tracker_blackboard["TimeAt"] > 10)
		tracker.SetDone()

	if(tracker.IsOlderThan(600))
		tracker.SetFailed()


/mob/goai/sim/proc/HandlePartying(var/datum/ActionTracker/tracker)
	AddMotive(MOTIVE_SLEEP, rand(-1, 2))
	AddMotive(MOTIVE_FUN, 5)

	randMove()

	if(tracker.IsOlderThan(40))
		tracker.SetDone()


/mob/goai/sim/proc/HandleShopping(var/datum/ActionTracker/tracker)
	var/obj/vending/vendor = locate()
	if(!vendor)
		tracker.SetFailed()

	tracker.tracker_blackboard["Vendor"] = vendor

	var/dist = ChebyshevDistance(src, vendor)

	world.log << "VENDOR DIST: [dist]"

	if(dist <= 1)
		if(!("TimeAt" in tracker.tracker_blackboard))
			tracker.tracker_blackboard["TimeAt"] = 0
		else
			tracker.tracker_blackboard["TimeAt"] = tracker.tracker_blackboard["TimeAt"] + 1

	if(dist > 1)
		if(!active_path || (active_path.target != vendor))
			StartNavigateTo(vendor, 1)

	if(tracker.tracker_blackboard["TimeAt"] > 5)
		tracker.SetDone()

	if(tracker.IsOlderThan(600))
		tracker.SetFailed()
