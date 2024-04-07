
/sense/combatant_commander_utility_wayfinder


/sense/combatant_commander_utility_wayfinder/proc/DraftMoveToPrecise(var/datum/utility_ai/mob_commander/owner, var/atom/position, var/max_node_depth = null, var/min_target_dist = null, var/path_ttl = null)
	if(!(owner && istype(owner)))
		RUN_ACTION_DEBUG_LOG("[src] does not have an owner! <[owner]>")
		return

	var/datum/brain/owner_brain = owner.brain
	if(!(owner_brain && istype(owner_brain)))
		RUN_ACTION_DEBUG_LOG("[owner] does not have a brain! <[owner_brain]>")
		return

	var/atom/target_pos = position

	if(isnull(target_pos))
		target_pos = owner_brain.GetMemoryValue("ai_target", null, FALSE, TRUE, TRUE)

	if(isnull(target_pos))
		RUN_ACTION_DEBUG_LOG("Target position is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	var/atom/pawn = owner.GetPawn()

	if(isnull(pawn))
		RUN_ACTION_DEBUG_LOG("Pawn is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	var/_max_node_depth = DEFAULT_IF_NULL(max_node_depth, 60)
	var/_path_ttl = DEFAULT_IF_NULL(path_ttl, 200)

	var/_min_target_dist = min_target_dist

	if(isnull(_min_target_dist))
		_min_target_dist = owner_brain.GetMemoryValue("ai_target_mindist", null, FALSE, TRUE, TRUE)

	if(isnull(_min_target_dist))
		_min_target_dist = DEFAULT_MIN_ASTAR_DIST

	var/list/path = owner.AiAStar(
		start = get_turf(pawn),
		end = get_turf(target_pos),
		adjacent = /proc/fCardinalTurfsNoblocks,
		dist = DEFAULT_GOAI_DISTANCE_PROC,
		max_nodes = 0,
		max_node_depth = _max_node_depth,
		min_target_dist = _min_target_dist,
		min_node_dist = null,
		adj_args = null,
		exclude = null
	)

	if(isnull(path))
		RUN_ACTION_DEBUG_LOG("Path is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	owner_brain.SetMemory(MEM_PATH_TO_POS("aitarget"), path, _path_ttl)
	owner_brain.SetMemory(MEM_PATH_ACTIVE, path, _path_ttl)

	return path


/sense/combatant_commander_utility_wayfinder/ProcessTick(var/owner)
	..(owner)

	if(processing)
		return

	processing = TRUE
	var/delay_rate = 10

	var/path = src.DraftMoveToPrecise(owner)
	if(path)
		delay_rate = 30

	spawn(src.GetOwnerAiTickrate(owner) * delay_rate)
		// Sense-side delay to avoid spamming view() scans too much
		processing = FALSE
	return


/*
// ---------------------------------------------------
//           SmartObject-based implementation
//
//  To be used mainly as a proof-of-concept for later
//  strategic-GOAP implementation of AI in general.
//
//  Pathfinding is essentially a special case of GOAP,
//  so it is a good testbed for the core principles.
//
// ---------------------------------------------------
*/


/datum/path_smartobject
	// optional-ish, identifier for debugging:
	var/name

	// the actual path
	var/list/path

	// where did we try to go
	var/turf/target

	// number of failed steps; if this is too high, invalidate the path
	var/frustration = 0

	// similar to frustration, but measures *freshness* rather than *severity* of pathing issues
	// can be used as a consideration input
	// null means never failed
	var/last_failed_step_time = null


/datum/path_smartobject/New(var/list/new_path, var/new_name = null)
	if(!isnull(new_name))
		src.name = new_name

	src.path = new_path

	if(!isnull(src.name))
		// Potentially, cache by destination later.
		src.smartobject_cache_key = src.name


/datum/path_smartobject/GetUtilityActions(var/requester, var/list/args = null) // (Any, assoc) -> [ActionSet]
	ASSERT(fexists(MOVEPATH_ACTIONSET_PATH))
	var/datum/action_set/myset = ActionSetFromJsonFile(MOVEPATH_ACTIONSET_PATH)
	ASSERT(!isnull(myset))

	var/list/my_action_sets = list()

	myset.origin = src
	my_action_sets.Add(myset)

	return my_action_sets


// This is a copypasta of the non-SO one above as I CBA dealing with OOP bullshit before I nail this down

/sense/combatant_commander_utility_wayfinder_smartobjectey


/sense/combatant_commander_utility_wayfinder_smartobjectey/proc/DraftMoveToPrecise(var/datum/utility_ai/mob_commander/owner, var/atom/position, var/max_node_depth = null, var/min_target_dist = null, var/path_ttl = null)
	if(!(owner && istype(owner)))
		RUN_ACTION_DEBUG_LOG("[src] does not have an owner! <[owner]>")
		return

	var/datum/brain/owner_brain = owner.brain
	if(!(owner_brain && istype(owner_brain)))
		RUN_ACTION_DEBUG_LOG("[owner] does not have a brain! <[owner_brain]>")
		return

	var/atom/target_pos = position

	if(isnull(target_pos))
		target_pos = owner_brain.GetMemoryValue("ai_target", null, FALSE, TRUE, TRUE)
		RUN_ACTION_DEBUG_LOG("Target position is [target_pos] | <@[src]> | [__FILE__] -> L[__LINE__]")

	if(isnull(target_pos))
		RUN_ACTION_DEBUG_LOG("Target position is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	var/turf/target = get_turf(target_pos)

	if(!istype(target))
		RUN_ACTION_DEBUG_LOG("Target position did not resolve to a turf! | <@[src]> | [__FILE__] -> L[__LINE__]")
		return null

	var/atom/pawn = owner.GetPawn()

	if(isnull(pawn))
		RUN_ACTION_DEBUG_LOG("Pawn is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	var/_max_node_depth = DEFAULT_IF_NULL(max_node_depth, 60)
	var/_min_target_dist = DEFAULT_IF_NULL(min_target_dist, 0)
	var/_path_ttl = DEFAULT_IF_NULL(path_ttl, 100)
	var/_path_name = MEM_PATH_TO_POS("aitarget")

	owner_brain.SetMemory("last_pathing_target", target, _path_ttl)

	var/list/stored_paths = owner_brain.GetMemoryValue("AbstractSmartPaths")
	var/datum/path_smartobject/stored_path_so = null

	if(!isnull(stored_paths) && istype(stored_paths) && stored_paths.len)
		stored_path_so = stored_paths[_path_name]

	var/turf/stored_target = stored_path_so?.target
	var/list/path = stored_path_so?.path
	var/frustration = (stored_path_so?.frustration || 0)

	if(!isnull(stored_path_so) && !isnull(path) && frustration < 3 && istype(stored_target) && stored_target.x == target.x && stored_target.y == target.y && stored_target.z == target.z)
		RUN_ACTION_DEBUG_LOG("Reusing stored path | <@[src]> | [__FILE__] -> L[__LINE__]")
		return path

	path = owner.AiAStar(
		start = get_turf(pawn),
		end = target,
		adjacent = /proc/fCardinalTurfsNoblocksObjpermissive,
		dist = DEFAULT_GOAI_DISTANCE_PROC,
		max_nodes = 0,
		max_node_depth = _max_node_depth,
		min_target_dist = _min_target_dist,
		min_node_dist = null,
		adj_args = null,
		exclude = null
	)

	if(isnull(path))
		RUN_ACTION_DEBUG_LOG("Path is null | <@[src]> | [__FILE__] -> L[__LINE__]")

		path = owner.AiAStar(
			start = get_turf(pawn),
			end = target,
			adjacent = /proc/fCardinalTurfsNoblocksObjpermissive,
			dist = DEFAULT_GOAI_DISTANCE_PROC,
			max_nodes = 0,
			max_node_depth = _max_node_depth,
			min_target_dist = _min_target_dist + 1,
			min_node_dist = null,
			adj_args = null,
			exclude = null
		)

		if(isnull(path))
			return
	/*
	owner_brain.SetMemory(MEM_PATH_TO_POS("aitarget"), path, _path_ttl)
	owner_brain.SetMemory(MEM_PATH_ACTIVE, path, _path_ttl)
	*/

	/* New steering approach makes this not nice to reverse
	// we reverse the list to make it poppable...
	path = reverse_list_clone(path)

	// ...and trim the starting point from it
	if(path.len)
		path.len--
	*/
	// create a new abstract Path SmartObject
	var/datum/path_smartobject/path_so = new(path, _path_name)
	var/paths[1]; paths[_path_name] = path_so

	owner_brain.SetMemory("AbstractSmartPaths", paths, _path_ttl)
	owner_brain.SetMemory(MEM_PATH_ACTIVE, path, _path_ttl)

	if(path)
		var/turf/prev_draw_pos = null

		for(var/turf/drawpos in path)
			// debug path drawing
			if(!isnull(prev_draw_pos))
				drawpos.pDrawVectorbeam(prev_draw_pos, drawpos, "b_beam")

			prev_draw_pos = drawpos

	return path


/sense/combatant_commander_utility_wayfinder_smartobjectey/ProcessTick(var/owner)
	..(owner)

	if(processing)
		return

	processing = TRUE

	src.DraftMoveToPrecise(owner)

	spawn(src.GetOwnerAiTickrate(owner) * 20)
		// Sense-side delay to avoid spamming view() scans too much
		processing = FALSE
	return
