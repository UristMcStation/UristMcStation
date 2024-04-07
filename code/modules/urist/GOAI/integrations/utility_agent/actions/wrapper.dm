
/datum/utility_ai/proc/WrapFunction(var/datum/ActionTracker/tracker, var/func_proc, var/list/func_args)

	if(isnull(tracker))
		RUN_ACTION_DEBUG_LOG("ActionTracker is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(isnull(func_proc))
		RUN_ACTION_DEBUG_LOG("func_proc is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	if(tracker.IsStopped())
		return

	var/true_func_proc = func_proc
	if(!ispath(func_proc))
		true_func_proc = STR_TO_PROC(func_proc)

	if(isnull(true_func_proc))
		RUN_ACTION_DEBUG_LOG("true_func_proc is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	call(true_func_proc)(arglist(func_args))
	tracker.SetDone()

	return


/datum/utility_ai/proc/WrapMethod(var/datum/ActionTracker/tracker, var/target, var/func_proc, var/list/func_args)
	if(isnull(tracker))
		RUN_ACTION_DEBUG_LOG("ActionTracker is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(isnull(target))
		RUN_ACTION_DEBUG_LOG("target is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	if(isnull(func_proc))
		RUN_ACTION_DEBUG_LOG("func_proc is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	if(tracker.IsStopped())
		return

	var/true_func_proc = func_proc
	if(!ispath(func_proc))
		true_func_proc = STR_TO_PROC(func_proc)

	if(isnull(true_func_proc))
		RUN_ACTION_DEBUG_LOG("true_func_proc is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	call(target, true_func_proc)(arglist(func_args))
	tracker.SetDone()

	return


/datum/utility_ai/mob_commander/proc/MoveToAndExecuteWrapper(var/datum/ActionTracker/tracker, var/atom/location, var/list/func_args, var/ai_proc, var/location_key = null, var/min_dist = 1, var/is_func = FALSE, var/timeout = 100)
	// Wraps another Action with extra logic to go to the target first.

	if(isnull(tracker))
		RUN_ACTION_DEBUG_LOG("ActionTracker is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(tracker.IsStopped())
		return

	if(!isnull(timeout))
		var/start_time = tracker.BBSetDefault("start_time", world.time)
		var/curr_time = world.time
		if((curr_time - start_time) > timeout)
			RUN_ACTION_DEBUG_LOG("Timed out! ([curr_time] - [start_time]) > [timeout]! | <@[src]> | [__FILE__] -> L[__LINE__]")
			tracker.SetFailed()
			return

	if(isnull(ai_proc))
		RUN_ACTION_DEBUG_LOG("ai_proc is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	var/true_ai_proc = ai_proc
	if(!ispath(ai_proc) && istext(ai_proc))
		true_ai_proc = STR_TO_PROC(ai_proc)

	if(isnull(true_ai_proc))
		RUN_ACTION_DEBUG_LOG("true_ai_proc is null ([ai_proc] => [true_ai_proc]) | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	var/atom/movable/mypawn = src.GetPawn()

	if(isnull(mypawn))
		tracker.SetFailed()
		return

	src.allow_wandering = FALSE

	// placeholders!
	var/max_node_depth = null
	var/path_ttl = null

	var/_max_node_depth = DEFAULT_IF_NULL(max_node_depth, 60)
	var/_min_target_dist = DEFAULT_IF_NULL(min_dist, DEFAULT_MIN_ASTAR_DIST)
	var/_path_ttl = DEFAULT_IF_NULL(path_ttl, 100)

	var/turf/pawnloc = get_turf(mypawn)
	var/turf/targloc = get_turf(location)

	var/dist_to_target = MANHATTAN_DISTANCE(pawnloc, targloc)

	if(dist_to_target > _min_target_dist)
		// Too far; check if we need a path.
		var/list/path = tracker.BBGet("wrapper_path")

		if(!isnull(path))
			// We're too far to actually execute the wrapped call, so wait until the next tick.
			// Mostly here to unnest the code.
			return

		if(isnull(pawnloc))
			tracker.SetFailed()
			return

		if(isnull(targloc))
			tracker.SetFailed()
			return

		path = src.AiAStar(
			start = pawnloc,
			end = targloc,
			adjacent = /proc/fCardinalTurfsNoblocks,
			dist = DEFAULT_GOAI_DISTANCE_PROC,
			max_nodes = 0,
			max_node_depth = _max_node_depth,
			min_target_dist = _min_target_dist,
			min_node_dist = null,
			adj_args = null,
			exclude = null
		)

		if(isnull(path) && MANHATTAN_DISTANCE(mypawn, location) > _min_target_dist)
			tracker.SetFailed()
			return

		tracker.BBSet("wrapper_path", path)
		src.brain.SetMemory(MEM_PATH_TO_POS("aitarget"), path, _path_ttl)
		src.brain.SetMemory(MEM_PATH_ACTIVE, path, _path_ttl)
		src.brain.SetMemory("last_pathing_target", location)

		// We're too far to actually execute the wrapped call, so wait until the next tick.
		return

	// Movement all done, time to unwrap.

	var/list/_func_args = isnull(func_args) ? list() : func_args

	if(!isnull(location_key))
		_func_args[location_key] = location

	if(is_func)
		call(true_ai_proc)(arglist(_func_args))
		tracker.SetDone()
		return

	_func_args["tracker"] = tracker

	GOAI_LOG_DEVEL_WORLD("====>Calling wrapped .[ai_proc]([json_encode(_func_args)])!")
	call(src, true_ai_proc)(arglist(_func_args))

	return
