
/datum/utility_ai/mob_commander/proc/PickUp(var/datum/ActionTracker/tracker, var/atom/movable/target)

	if(isnull(tracker))
		RUN_ACTION_DEBUG_LOG("ActionTracker is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(tracker.IsStopped())
		return

	if(isnull(target))
		RUN_ACTION_DEBUG_LOG("Target is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	var/atom/pawn = src.GetPawn()

	if(!istype(pawn))
		RUN_ACTION_DEBUG_LOG("No owned mob found for [src.name] AI @ L[__LINE__] in [__FILE__]")
		return

	if(target in pawn.contents)
		tracker.SetDone()
		return

	var/turf/pawnloc = get_turf(pawn)
	var/turf/targloc = get_turf(target)

	if(isnull(pawnloc) || isnull(targloc))
		tracker.SetFailed()
		return

	var/start_time = tracker.BBSetDefault("StartTime", world.time)

	if(get_dist(pawnloc, targloc) <= 1)
		target.Move(pawn)

		if(target in pawn.contents)
			tracker.SetDone()
			return

	var/min_dist = 1
	src.allow_wandering = FALSE

	if((!src.active_path || src.active_path.target != targloc))
		var/datum/ActivePathTracker/stored_path = StartNavigateTo(target, min_dist, null, max_mindist = 3)

		if(isnull(stored_path))
			tracker.SetFailed()
			src.brain?.SetMemory("UnreachableRunMovePath", targloc, 500)
			return

		src.brain?.SetMemory(MEM_PATH_ACTIVE, stored_path.path, 500)

	var/curr_time = world.time

	if((curr_time - start_time) > 600)
		tracker.SetFailed()
		return

	return

