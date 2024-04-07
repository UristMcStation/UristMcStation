
/datum/utility_ai/mob_commander/proc/FleeFrom(var/datum/ActionTracker/tracker, var/atom/threat, var/timeout = null)
	GOAI_LOG_DEVEL_WORLD("[src] fleeing from [islist(threat) ? json_encode(threat) : threat]")

	if(isnull(tracker))
		RUN_ACTION_DEBUG_LOG("Tracker position is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(tracker.IsStopped())
		return

	if(isnull(threat))
		RUN_ACTION_DEBUG_LOG("Target threat is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	var/atom/pawn = src.GetPawn()

	if(isnull(pawn))
		RUN_ACTION_DEBUG_LOG("Pawn is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	var/turf/curr_loc = get_turf(pawn)

	if(isnull(curr_loc))
		RUN_ACTION_DEBUG_LOG("curr_loc is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	var/turf/bestcand = curr_loc
	var/bestdist = MANHATTAN_DISTANCE(curr_loc, threat)

	for(var/i = 0, i < 3, i++)
		var/new_bestcand = null
		var/list/cardinals = fCardinalTurfsNoblocksObjpermissive(curr_loc)

		for(var/turf/cand in cardinals)
			var/canddist = MANHATTAN_DISTANCE(cand, threat)
			canddist += rand() * 1.5

			if(canddist >= bestdist)
				bestdist = canddist
				new_bestcand = cand

		if(isnull(new_bestcand))
			break

		curr_loc = new_bestcand
		bestcand = new_bestcand

	var/min_dist = 0

	if((!src.active_path || src.active_path.target != threat))
		src.brain?.SetMemory("ai_target", bestcand)
		src.brain?.SetMemory("ai_target_mindist", 0, PLUS_INF)

		var/datum/ActivePathTracker/stored_path = StartNavigateTo(bestcand, min_dist, null)

		if(isnull(stored_path))
			stored_path = StartNavigateTo(bestcand, ++min_dist, null)

		if(isnull(stored_path))
			stored_path = StartNavigateTo(bestcand, ++min_dist, null)

		if(isnull(stored_path))
			tracker.SetFailed()
			src.brain?.SetMemory("UnreachableRunMovePath", threat, 500)
			return
		else
			src.brain?.SetMemory(MEM_PATH_ACTIVE, stored_path.path, 100)
			tracker.SetDone()

			var/datum/brain/utility/needybrain = src.brain
			if(istype(needybrain))
				needybrain.AddMotive(NEED_COMPOSURE, MAGICNUM_COMPOSURE_GAIN_FLEED)

			return

	var/pathing_timeout = DEFAULT_IF_NULL(timeout, 30)
	var/timedelta = (world.time - tracker.creation_time)

	if(timedelta > pathing_timeout)
		tracker.SetFailed()
		return

	return
