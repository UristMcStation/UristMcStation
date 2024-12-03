
CTXFETCHER_CALL_SIGNATURE(/proc/__ctxfetcher_get_memory_value_helper)
	// Returns a stored Memory

	if(isnull(requester))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requester for __ctxfetcher_get_memory_value_helper is null @ L[__LINE__] in [__FILE__]!")
		return null

	var/datum/utility_ai/requester_ai = requester

	if(!istype(requester_ai))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requester for __ctxfetcher_get_memory_value_helper is not an AI @ L[__LINE__] in [__FILE__]!")
		return null

	// this seems like a redundant var wrt requester_ai; don't want to mess with it now, TODO
	var/datum/utility_ai/controller = requester

	var/input_key = context_args[CONSIDERATION_INPUTKEY_KEY]

	if(isnull(input_key))
		UTILITYBRAIN_DEBUG_LOG("WARNING: key for __ctxfetcher_get_memory_value_helper is null @ L[__LINE__] in [__FILE__]!")
		return null

	var/datum/brain/requesting_brain = controller.brain

	if(!istype(requesting_brain))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requesting_brain for __ctxfetcher_get_memory_value_helper is null @ L[__LINE__] in [__FILE__]!")
		return null

	var/memory_val = null

	var/source_key = "memory"

	if(!isnull(context_args))
		source_key = context_args["memory_source"] || source_key

	if(!isnull(source_key))
		source_key = lowertext(source_key)

	switch(source_key)
		if("perception", "perceptions")
			DEBUGLOG_UTILITY_MEMORY_FETCH("Fetching [input_key] from Peceptions")
			memory_val = requesting_brain.perceptions.Get(input_key)

		if("need", "needs")
			DEBUGLOG_UTILITY_MEMORY_FETCH("Fetching [input_key] from Needs")
			memory_val = requesting_brain?.needs[input_key]

		else
			DEBUGLOG_UTILITY_MEMORY_FETCH("Fetching [input_key] from Memories")
			memory_val = requesting_brain.GetMemoryValue(input_key)

	return memory_val


CTXFETCHER_CALL_SIGNATURE(/proc/ctxfetcher_get_memory_value)
	// Returns a stored Memory

	var/memory_val = __ctxfetcher_get_memory_value_helper(CTXFETCHER_FORWARD_ARGS)
	CONTEXT_GET_OUTPUT_KEY(var/context_key)

	var/list/contexts = list()
	CONTEXT_ADD_SINGLE_KEYED_CONTEXT(memory_val, context_key, contexts)
	return contexts


CTXFETCHER_CALL_SIGNATURE(/proc/ctxfetcher_get_memory_value_assoc)
	// Returns a stored Memory, expecting it to be an assoc list.
	// If that is the case, unpacks all items as keys in a single a new context.

	var/list/memory_val = __ctxfetcher_get_memory_value_helper(CTXFETCHER_FORWARD_ARGS)

	if(!istype(memory_val))
		return list()

	var/list/contexts = list()
	ARRAY_APPEND(contexts, memory_val)
	return contexts


CTXFETCHER_CALL_SIGNATURE(/proc/ctxfetcher_get_memory_value_array)
	/* Retrieves a stored Memory, expecting it to be an array list.
	// If that is the case, unpacks each list item to a new context.
	//
	// This is handy if you want to build Contexts from a single Memory,
	// for example if you want to write interactables/enemies from a Sense tick
	// but evaluate each item *INDIVIDUALLY*.
	//
	// In contrast, the 'plain' ctxfetcher_get_memory_value would treat the whole
	// Memory'd list as one big Context - which is also okay for other uses (for
	// example, discouraging moving into a tile with multiple enemies having LOS to it).
	//
	// In addition to normal memory-related params, this proc takes two extra args:
	// - filter_proc: optional; a proc that takes the input item and an assoc list of args and returns a boolean
	// - filter_args: optional; aforementioned args to feed to the filter
	//
	// Null filter_args are *generally* valid and left to the filter proc to handle.
	// Null filter_proc is valid and interpreted as 'no filtering'; in that case, filter_args are ignored entirely and the memory is return directly (no-copy)
	*/

	var/list/raw_memory_val = __ctxfetcher_get_memory_value_helper(CTXFETCHER_FORWARD_ARGS)

	if(isnull(raw_memory_val))
		return list()

	if(!istype(raw_memory_val))
		GOAI_LOG_ERROR("ERROR: raw_memory_val is invalid: [raw_memory_val]")
		ASSERT(istype(raw_memory_val))

	var/list/memory_val = null

	var/filter_proc = context_args["filter_proc"]
	if(istext(filter_proc))
		filter_proc = STR_TO_PROC(filter_proc)

	if(isnull(filter_proc))
		// no filtering would happen, saves us an allocation
		memory_val = raw_memory_val

	else
		var/list/filter_args = context_args["filter_args"]  // null-safe

		memory_val = list()

		for(var/listitem in raw_memory_val)
			// apply filter
			var/predicate_result = call(filter_proc)(listitem, filter_args)
			if(predicate_result)
				ARRAY_APPEND(memory_val, listitem)

	CONTEXT_GET_OUTPUT_KEY(var/context_key)

	var/list/contexts = list()
	for(var/mem_item in memory_val)
		CONTEXT_ADD_SINGLE_KEYED_CONTEXT(mem_item, context_key, contexts)

	return contexts


// TODO move this out!
/proc/typecheck_filter(var/datum/item, var/list/filterargs)
	// Basic filter for typechecking items are subtypes of the specified type

	if(isnull(item))
		GOAI_LOG_ERROR("WARNING: typecheck_filter input item is null, returning FALSE! @ L[__LINE__] in [__FILE__]")
		return FALSE

	if(isnull(filterargs))
		GOAI_LOG_ERROR("WARNING: typecheck_filter filterargs are null, returning FALSE! @ L[__LINE__] in [__FILE__]")
		return FALSE

	var/target_type = filterargs["target_type"]
	if(istext(target_type))
		target_type = text2path(target_type)

	if(isnull(target_type))
		GOAI_LOG_ERROR("WARNING: typecheck_filter target_type is null, returning FALSE! @ L[__LINE__] in [__FILE__]")
		return FALSE

	if(!istype(item))
		GOAI_LOG_ERROR("WARNING: typecheck_filter input item is not a datum subclass and therefore not a valid target, returning FALSE! @ L[__LINE__] in [__FILE__]")
		return FALSE

	var/strict = filterargs["strict"] || FALSE

	if(strict)
		return item.type == target_type

	return istype(item, target_type)
