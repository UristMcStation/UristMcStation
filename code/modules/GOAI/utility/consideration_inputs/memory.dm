/*
// Consideration procs that deal with AI Brain data: Memories, Perceptions, Needs, etc.
*/

# define DEBUG_MEMORY_QUERIES 1

# ifdef DEBUG_MEMORY_QUERIES
# define DEBUGLOG_MEMORY_FETCH(X) to_world_log(X)
# define DEBUGLOG_MEMORY_ERRCATCH(X) catch(X)
# else
# define DEBUGLOG_MEMORY_FETCH(X)
# define DEBUGLOG_MEMORY_ERRCATCH(X) catch(X)
# endif

CONSIDERATION_CALL_SIGNATURE(/proc/_cihelper_get_brain_data)
	// This is not a 'proper' Consideration, but it has the same interface as one; it's a way of DRYing
	// the code to fetch a Memory-ized path for various ACTUAL Considerations (e.g. 'Path Exists' or 'Path Length Is...')
	// These proper Considerations should just forward their callsig to this Helper.

	var/datum/brain/requesting_brain = _cihelper_get_requester_brain(requester, "_cihelper_get_brain_data")

	if(isnull(requesting_brain))
		DEBUGLOG_MEMORY_FETCH("_cihelper_get_brain_data Brain is null ([requesting_brain || "null"]) @ L[__LINE__] in [__FILE__]")
		return FALSE

	var/input_key = "input"

	if(!isnull(consideration_args))
		input_key = consideration_args["memory_key"] || input_key

	if(isnull(input_key))
		DEBUGLOG_MEMORY_FETCH("_cihelper_get_brain_data Input Key is null ([input_key || "null"]) @ L[__LINE__] in [__FILE__]")
		return null

	var/source_key = "memory"

	if(!isnull(consideration_args))
		source_key = consideration_args["memory_source"] || source_key

	if(!isnull(source_key))
		source_key = lowertext(source_key)

	var/memory = null

	switch(source_key)
		if("perception", "perceptions")
			DEBUGLOG_MEMORY_FETCH("Fetching [input_key] from Peceptions")
			memory = requesting_brain.perceptions.Get(input_key)

		if("need", "needs")
			DEBUGLOG_MEMORY_FETCH("Fetching [input_key] from Needs")
			memory = requesting_brain?.needs[input_key]

		else
			DEBUGLOG_MEMORY_FETCH("Fetching [input_key] from Memories")
			memory = requesting_brain.GetMemoryValue(input_key)

	return memory


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_has_memory)
	var/memory = _cihelper_get_brain_data(action_template, context, requester, consideration_args)
	return !isnull(memory)


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_get_memory_value)
	var/memory = _cihelper_get_brain_data(action_template, context, requester, consideration_args)
	return memory


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_get_memory_ghost_turf)
	/*
	// Like consideration_input_get_memory_value(), but specialized to 'ghosts' in memory
	// (i.e. stuff like last known position of something as opposed to its actual location).
	*/
	var/memory = _cihelper_get_brain_data(action_template, context, requester, consideration_args)
	var/dict/position_ghost = memory

	if(isnull(position_ghost))
		return null

	var/pos_x = position_ghost[KEY_GHOST_X]
	var/pos_y = position_ghost[KEY_GHOST_Y]
	var/pos_z = position_ghost[KEY_GHOST_Z]

	var/turf/ghost_turf = locate(pos_x, pos_y, pos_z)

	var/raw_loc_type = consideration_args["type_to_fetch"]

	if(isnull(raw_loc_type))
		return ghost_turf

	var/loc_type = text2path(raw_loc_type)
	if(isnull(loc_type))
		return null

	var/found_type = locate(loc_type) in ghost_turf.contents
	return found_type


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_requester_distance_to_memory_value)
	var/atom/memory = _cihelper_get_brain_data(action_template, context, requester, consideration_args)

	if(isnull(memory))
		return PLUS_INF

	return ManhattanDistance(memory, requester)


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_candidate_in_brain)
	var/from_ctx = consideration_args["from_context"]
	if(isnull(from_ctx))
		from_ctx = TRUE

	var/pos_key = consideration_args["input_key"] || "position"

	var/candidate = (from_ctx ? context[pos_key] : consideration_args[pos_key])
	if(isnull(candidate))
		DEBUGLOG_MEMORY_FETCH("consideration_input_candidate_in_brain Candidate is null ([candidate || "null"]) @ L[__LINE__] in [__FILE__]")
		return null

	var/memory = _cihelper_get_brain_data(action_template, context, requester, consideration_args)
	var/result = memory == candidate

	return result


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_candidate_in_brain_list)
	var/from_ctx = DEFAULT_IF_NULL(consideration_args["from_context"], TRUE)

	var/pos_key = consideration_args["input_key"] || "position"
	var/candidate = null

	try
		candidate = (from_ctx ? context[pos_key] : consideration_args[pos_key])
	DEBUGLOG_MEMORY_ERRCATCH(var/exception/e)
		DEBUGLOG_MEMORY_FETCH("ERROR: [e] on [e.file]:[e.line]. <pos_key='[pos_key]'>")

	if(isnull(candidate))
		DEBUGLOG_MEMORY_FETCH("consideration_input_candidate_in_brain_list Candidate is null ([candidate || "null"]) <from_ctx=[from_ctx] | pos_key=[pos_key]> @ L[__LINE__] in [__FILE__]")
		return null

	var/raw_memory = _cihelper_get_brain_data(action_template, context, requester, consideration_args)
	if(isnull(raw_memory))
		return FALSE

	var/list/memory = raw_memory

	if(!istype(memory))
		// Throw an error if the memory is not a list
		to_world_log("ERROR: Wrong memory type: [json_encode(memory)] ([memory])!")
		ASSERT(istype(memory))

	for(var/item in memory)
		if (item == candidate)
			return TRUE

	return FALSE


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_action_in_brain)
	var/pos_key = consideration_args["input_key"] || "action_name"

	var/candidate = consideration_args[pos_key]
	if(isnull(candidate))
		DEBUGLOG_MEMORY_FETCH("consideration_input_action_in_brain Candidate is null ([isnull(candidate) ? "null" : candidate]) @ L[__LINE__] in [__FILE__]")
		return null

	var/memory = _cihelper_get_brain_data(action_template, context, requester, consideration_args)
	var/result = memory == candidate

	return result
