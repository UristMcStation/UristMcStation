/* ==  ACTION SETS  == */


// Reading and parsing files is expensive, cache it.
// This will be a lazily instantiated assoc list.
// Remember to clear the cache item if you want to do a refresh!
var/list/global/actionset_file_cache = null


/datum/action_set
	/* Represents a logical grouping of ActionTemplates.
	//
	// This is handy because we can slot in whole bundles of possible Actions that are
	//   provided by some source (e.g. a Combat state providing the Combat suite of ActionTemplates).
	//
	// This also means we can manage them together, e.g. disable the whole Combat bundle when not in a
	//   Combat state and reenable it when aggressive, rather than having to spent an eternity del()ing
	//   and new()ing Actions.
	*/
	var/list/actions = null
	var/active = TRUE

	/*
	// Time-To-Live tracking
	//
	// These are primarily used for Smart Object-sourced ActionSets
	// to verify whether the Actions included are still usable
	// (for game objects, we don't want to consider stuff half the world away;
	// for stuff like GOAP Plans, we don't want to consider dead Plans).
	*/
	var/ttl_remove = PLUS_INF  // timeout for deleting this from our Actionspace
	var/ttl_deactivate = PLUS_INF  // timeout for deactivating this in our Actionspace WITHOUT DELETING
	// Needless to say, ttl_deactivate >= ttl_remove is pointless and impotent.
	var/time_retrieved = null  // most recent time this ActionSet was provided and active

	var/origin = null  // who gave us this ActionSet

	var/freshness_proc = null  // optional proc to check if this is still valid (for reasons other than TTL)
	var/list/freshness_proc_args = null  // args to pass to freshness_proc, duh

	var/name = null


/datum/action_set/New(var/name, var/list/included_actions, var/active = null, var/ttl_remove = null, var/ttl_deactivate = null, var/time_retrieved = null, var/origin = null, var/freshness_proc = null, var/list/freshness_proc_args = null)
	SET_IF_NOT_NULL(name, src.name)
	SET_IF_NOT_NULL(included_actions, src.actions)
	SET_IF_NOT_NULL(active, src.active)
	SET_IF_NOT_NULL(ttl_remove, src.ttl_remove)
	SET_IF_NOT_NULL(ttl_deactivate, src.ttl_deactivate)
	SET_IF_NOT_NULL(origin, src.origin)

	src.time_retrieved = DEFAULT_IF_NULL(time_retrieved, world.time)

	SET_IF_NOT_NULL(freshness_proc, src.freshness_proc)
	SET_IF_NOT_NULL(freshness_proc_args, src.freshness_proc_args)

	ASSERT(src.name)
	//disabling that since we need to defer adding actions sometimes -_-
	//ASSERT(src.actions)


/datum/action_set/proc/Deactivate()
	src.active = FALSE
	return src.active


/datum/action_set/proc/Activate()
	src.active = TRUE
	return src.active


/datum/action_set/proc/Refresh(var/at_time)
	var/refresh_time = DEFAULT_IF_NULL(at_time, world.time)
	src.time_retrieved = refresh_time
	return src.time_retrieved


/datum/action_set/proc/ShouldRemove(var/at_time = null)
	if(!isnull(src.freshness_proc))
		var/proc_result = call(src.freshness_proc)(src, src.freshness_proc_args)

		if(proc_result)
			return TRUE

	var/trg_time = DEFAULT_IF_NULL(at_time, src.time_retrieved)
	if(isnull(trg_time))
		// We'll assume null time_retrieved are 'intrinsic', always available actions
		return FALSE

	if(isnull(src.ttl_remove))
		return FALSE

	if(world.time < (trg_time + src.ttl_remove))
		return FALSE

	return TRUE


/datum/action_set/proc/ShouldDeactivate(var/at_time = null)
	if(!isnull(src.freshness_proc))
		var/proc_result = call(src.freshness_proc)(src, src.freshness_proc_args)

		if(proc_result)
			return TRUE

	var/trg_time = DEFAULT_IF_NULL(at_time, src.time_retrieved)
	if(isnull(trg_time))
		// We'll assume null time_retrieved are 'intrinsic', always available actions
		return FALSE

	if(isnull(src.ttl_deactivate))
		return FALSE

	if(world.time < (trg_time + src.ttl_deactivate))
		return FALSE

	return TRUE


