/datum/utility_ai/mob_commander/proc/StepTo(var/datum/ActionTracker/tracker, var/atom/position)
	/*
	// Simple movement Action; just does a single step to a target position.
	*/
	if(isnull(tracker))
		RUN_ACTION_DEBUG_LOG("Tracker position is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(tracker.IsStopped())
		return

	if(isnull(position))
		RUN_ACTION_DEBUG_LOG("Target position is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	var/atom/pawn = src.GetPawn()

	if(!istype(pawn))
		RUN_ACTION_DEBUG_LOG("No owned mob found for [src.name] AI @ L[__LINE__] in [__FILE__]")
		return

	var/succeeded = MovePawn(position)

	if(pawn.x == position.x && pawn.y == position.y && pawn.z == position.z)
		tracker.SetDone()

	if(tracker.IsStopped())
		return

	if(!succeeded)
		var/bb_failures = tracker.BBSetDefault("failed_steps", 0)
		tracker.BBSet("failed_steps", ++bb_failures)

		if(bb_failures > 3)
			src.brain?.SetMemory("UnreachableTile", position)
			tracker.SetFailed()

	return


/datum/utility_ai/mob_commander/proc/RunTo(var/datum/ActionTracker/tracker, var/atom/position, var/timeout = null)
	/*
	// Fancier movement; will *keep* walking to the target. Also a fair bit faster, for Reasons (TM).
	//
	// Note that this will NOT terminate until the pawn has reached the target pos (or we time out),
	// so the Action slot will be locked down for the duration of the move
	// and the AI won't replan until we stop.
	//
	// For single-action Brains, this means this is effectively a blind charge, good for e.g. diving to cover,
	// but not suitable if we potentially want to switch to doing *literally anything else*.
	*/
	if(isnull(tracker))
		RUN_ACTION_DEBUG_LOG("Tracker position is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(tracker.IsStopped())
		return

	if(isnull(position))
		RUN_ACTION_DEBUG_LOG("Target position is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	var/atom/pawn = src.GetPawn()

	if(!istype(pawn))
		RUN_ACTION_DEBUG_LOG("No owned mob found for [src.name] AI @ L[__LINE__] in [__FILE__]")
		return

	if(pawn.x == position.x && pawn.y == position.y && pawn.z == position.z)
		tracker.SetDone()
		return

	src.allow_wandering = TRUE
	var/min_dist = 0

	if((!src.active_path || src.active_path.target != position))
		var/stored_path = StartNavigateTo(position, min_dist, null)
		if(isnull(stored_path))
			tracker.SetFailed()
			src.brain?.SetMemory("UnreachableRunMovePath", position, 500)
			return

	var/pathing_timeout = DEFAULT_IF_NULL(timeout, 100)
	var/timedelta = (world.time - tracker.creation_time)

	if(timedelta > pathing_timeout)
		tracker.SetFailed()
		return

	return


/datum/utility_ai/mob_commander/proc/SteerTo(var/datum/ActionTracker/tracker, var/atom/position, var/timeout = null, var/min_dist = 0, var/fuzz_x = 0, var/fuzz_y = 0, var/permissive_adjacents = null)
	/*
	// Fancier movement; will *keep* walking to the target. Also a fair bit faster, for Reasons (TM).
	//
	// Unlike RunTo, this uses a separate Movement subsystem, so it's NOT blocking.
	*/
	if(isnull(tracker))
		RUN_ACTION_DEBUG_LOG("Tracker position is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(tracker.IsStopped())
		return

	if(isnull(position))
		RUN_ACTION_DEBUG_LOG("Raw target position is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	var/pathing_timeout = DEFAULT_IF_NULL(timeout, 100)
	var/timeout_timedelta = (world.time - tracker.creation_time)

	if(timeout_timedelta > pathing_timeout)
		tracker.SetFailed()
		return

	var/atom/pawn = src.GetPawn()

	if(!istype(pawn))
		RUN_ACTION_DEBUG_LOG("No owned mob found for [src.name] AI @ L[__LINE__] in [__FILE__]")
		return

	var/turf/true_position = get_turf(position)

	if(fuzz_x && fuzz_y)
		/*
		// If we can see the target pos, fuzzing would make the AI look dumb.
		// Fuzzing is used to simulate the AI 'guessing' where the target is
		// (mainly for pursuit/search-type actions).
		var/list/ai_view = src.brain?.perceptions?[SENSE_SIGHT_CURR]
		if(!(position in ai_view))
			var/fuzzed_x = clamp(position.x + rand(-fuzz_x, fuzz_x), 1, world.maxx)
			var/fuzzed_y = clamp(position.y + rand(-fuzz_y, fuzz_y), 1, world.maxy)
			true_position = locate(fuzzed_x, fuzzed_y, position.z)
		*/
		var/fuzzed_x = clamp(position.x + rand(-fuzz_x, fuzz_x), 1, world.maxx)
		var/fuzzed_y = clamp(position.y + rand(-fuzz_y, fuzz_y), 1, world.maxy)
		true_position = locate(fuzzed_x, fuzzed_y, position.z)

	if(!istype(true_position))
		RUN_ACTION_DEBUG_LOG("Fuzzed target position is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	GOAI_LOG_DEBUG("[pawn] is running to [true_position] [COORDS_TUPLE(true_position)]")

	src.allow_wandering = TRUE

	var/_min_dist = isnull(min_dist) ? 0 : min_dist

	if(MANHATTAN_DISTANCE(pawn, position) == min_dist)
		tracker.SetDone()
		return

	var/use_permissive_adjacencies = DEFAULT_IF_NULL(permissive_adjacents, FALSE)
	var/used_adjproc = use_permissive_adjacencies ? /proc/fCardinalTurfsNoblocksObjpermissive : null

	if((isnull(src.active_path) || src.active_path.target != true_position))
		RUN_ACTION_DEBUG_LOG("SteerTo: Searching for a new path to [true_position] for [src.name] AI, current is [json_encode(src.active_path?.path)] with target [src.active_path?.target] @ L[__LINE__] in [__FILE__]")

		var/stored_path = StartNavigateTo(
			true_position,
			_min_dist,
			null,
			adjproc = used_adjproc
		)

		if(isnull(stored_path))
			tracker.SetFailed()
			RUN_ACTION_DEBUG_LOG("FAILED: No path to [true_position] found for [src.name] AI @ L[__LINE__] in [__FILE__]")
			src.brain?.SetMemory("UnreachableRunMovePath", position, 500)
			return

		src.active_path = stored_path

	tracker.SetDone()

	return

