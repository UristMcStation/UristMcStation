/*
// The consideration_decorator_* procs here are not proper Considerations; rather, these modify normal considerations to act as aggregate functions over lists.
//
// This is somewhat similar to ContextFetchers like ctxfetcher_get_memory_value_array(), which unpack a list into contexts.
// The difference here is that these CFs route the result to ALL underlying Considerations (good for e.g. picking targets).
// The aggregation decorators lets you apply take in one big context and selectively get statistics for it (good for e.g. overall threat level assessment).
//
// The general interface of these will be that the args of the decorator will contain a nested field of subargs to the wrapped proc.
*/

CONSIDERATION_CALL_SIGNATURE(/proc/consideration_decorator_mean)
	/* Calculates the average of the wrapped proc's values */
	var/default = consideration_args?["default"] || 0
	var/input_key = consideration_args?["input_key"] || "input"
	var/from_ctx = consideration_args?["from_context"]

	if(isnull(from_ctx))
		from_ctx = TRUE

	var/list/aggregation_window

	if(from_ctx)
		if(isnull(context))
			return default

		aggregation_window = context[input_key]

	else
		if(isnull(consideration_args))
			return default

		aggregation_window = consideration_args[input_key]

	if(!istype(aggregation_window) || !length(aggregation_window))
		// aggregates only work if we have something to operate on
		return default

	var/aggregated_proc_raw = consideration_args?["aggregated_proc"]
	var/aggregated_proc = STR_TO_PROC(aggregated_proc_raw)

	if(isnull(aggregated_proc))
		to_world_log("ERROR: Invalid proc: [aggregated_proc_raw]! @ [__LINE__] in [__FILE__]")
		return

	if(isnull(aggregated_proc))
		return

	var/list/subargs = consideration_args?["aggregated_proc_args"]

	var/value = 0
	var/count = 0

	// We pretty much only need a list for context as a formality, and inits are expensive
	// So, we'll instead recycle this one list over and over
	var/recycleable_subctx_list[1]

	for(var/ctxitem in aggregation_window)
		recycleable_subctx_list[input_key] = ctxitem

		var/subresult = call(aggregated_proc)(action_template, recycleable_subctx_list, requester, subargs)
		if(isnull(subresult))
			continue

		value += subresult
		count++

	if(count < 1)
		// no naughty division by zero
		return default

	var/result = (value / count)
	return result


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_decorator_mean_kalman)
	/* Calculates the average of the wrapped proc's values
	// This is a slightly different formulation that maintains a running average.
	// This is handy for cutoffs, but a bit more expensive if you don't need a cutoff.
	// This might also be worthwhile for YUUUGE inputs (in value or count), for numerical stability reasons.
	*/
	var/default = consideration_args?["default"] || 0
	var/input_key = consideration_args?["input_key"] || "input"
	var/from_ctx = consideration_args?["from_context"]

	if(isnull(from_ctx))
		from_ctx = TRUE

	var/list/aggregation_window

	if(from_ctx)
		if(isnull(context))
			return default

		aggregation_window = context[input_key]

	else
		if(isnull(consideration_args))
			return default

		aggregation_window = consideration_args[input_key]

	if(!istype(aggregation_window) || !length(aggregation_window))
		// aggregates only work if we have something to operate on
		return default

	var/aggregated_proc_raw = consideration_args?["aggregated_proc"]
	var/aggregated_proc = STR_TO_PROC(aggregated_proc_raw)

	var/cutoff = consideration_args?["cutoff"]
	var/cutoff_mincount = consideration_args?["cutoff_mincount"] || 0

	if(isnull(aggregated_proc))
		to_world_log("ERROR: Invalid proc: [aggregated_proc_raw]! @ [__LINE__] in [__FILE__]")
		return

	if(isnull(aggregated_proc))
		return

	var/list/subargs = consideration_args?["aggregated_proc_args"]

	var/value = 0
	var/count = 0
	var/estimate = null

	// We pretty much only need a list for context as a formality, and inits are expensive
	// So, we'll instead recycle this one list over and over
	var/recycleable_subctx_list[1]

	for(var/ctxitem in aggregation_window)
		recycleable_subctx_list[input_key] = ctxitem

		var/subresult = call(aggregated_proc)(action_template, recycleable_subctx_list, requester, subargs)
		if(isnull(subresult))
			continue

		value += subresult
		count++

		if(isnull(estimate))
			// gotta start somewhere...
			estimate = subresult
		else
			// linear Kalman update with count as Kalman gain
			estimate = estimate + ((subresult - estimate) / count)

		if(!isnull(cutoff) && count >= cutoff_mincount)
			if(estimate > cutoff)
				return estimate

	if(count < 1)
		// no naughty division by zero
		return default

	var/result = (value / count)
	return result


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_decorator_min)
	/* Calculates the min of the wrapped proc's values */
	var/default = consideration_args?["default"] || 0
	var/input_key = consideration_args?["input_key"] || "input"
	var/from_ctx = consideration_args?["from_context"]

	if(isnull(from_ctx))
		from_ctx = TRUE

	var/list/aggregation_window

	if(from_ctx)
		if(isnull(context))
			return default

		aggregation_window = context[input_key]

	else
		if(isnull(consideration_args))
			return default

		aggregation_window = consideration_args[input_key]

	if(!istype(aggregation_window) || !length(aggregation_window))
		// aggregates only work if we have something to operate on
		return default

	var/aggregated_proc_raw = consideration_args?["aggregated_proc"]
	var/aggregated_proc = STR_TO_PROC(aggregated_proc_raw)

	if(isnull(aggregated_proc))
		to_world_log("ERROR: Invalid proc: [aggregated_proc_raw]! @ [__LINE__] in [__FILE__]")
		return

	if(isnull(aggregated_proc))
		return

	var/list/subargs = consideration_args?["aggregated_proc_args"]
	var/cutoff = consideration_args?["cutoff"]

	var/value = 0
	var/count = 0

	// We pretty much only need a list for context as a formality, and inits are expensive
	// So, we'll instead recycle this one list over and over
	var/recycleable_subctx_list[1]

	for(var/ctxitem in aggregation_window)
		recycleable_subctx_list[input_key] = ctxitem

		var/subresult = call(aggregated_proc)(action_template, recycleable_subctx_list, requester, subargs)
		if(isnull(subresult))
			continue

		if(!isnull(cutoff) && subresult <= cutoff)
			// early out
			return subresult

		if(subresult < value)
			value = subresult

		count++

	if(count < 1)
		// if we didn't process anything, return default
		return default

	return value


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_decorator_max)
	/* Calculates the max of the wrapped proc's values */
	var/default = consideration_args?["default"] || 0
	var/input_key = consideration_args?["input_key"] || "input"
	var/from_ctx = consideration_args?["from_context"]

	if(isnull(from_ctx))
		from_ctx = TRUE

	var/list/aggregation_window

	if(from_ctx)
		if(isnull(context))
			return default

		aggregation_window = context[input_key]

	else
		if(isnull(consideration_args))
			return default

		aggregation_window = consideration_args[input_key]

	if(!istype(aggregation_window) || !length(aggregation_window))
		// aggregates only work if we have something to operate on
		return default

	var/aggregated_proc_raw = consideration_args?["aggregated_proc"]
	var/aggregated_proc = STR_TO_PROC(aggregated_proc_raw)

	if(isnull(aggregated_proc))
		to_world_log("ERROR: Invalid proc: [aggregated_proc_raw]! @ [__LINE__] in [__FILE__]")
		return

	if(isnull(aggregated_proc))
		return

	var/list/subargs = consideration_args?["aggregated_proc_args"]
	var/cutoff = consideration_args?["cutoff"]

	var/value = 0
	var/count = 0

	// We pretty much only need a list for context as a formality, and inits are expensive
	// So, we'll instead recycle this one list over and over
	var/recycleable_subctx_list[1]

	for(var/ctxitem in aggregation_window)
		recycleable_subctx_list[input_key] = ctxitem

		var/subresult = call(aggregated_proc)(action_template, recycleable_subctx_list, requester, subargs)
		if(isnull(subresult))
			continue

		if(!isnull(cutoff) && subresult >= cutoff)
			// early out
			return subresult

		count++

		if(subresult > value)
			value = subresult

	if(count < 1)
		// if we didn't process anything, return default
		return default

	return value


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_decorator_mode)
	/* Calculates the mode (most common value) of the wrapped proc's values
	// NOTE: do not use this for large contexts - this may require a fair bit of extra RAM!
	*/
	var/default = consideration_args?["default"] || 0
	var/input_key = consideration_args?["input_key"] || "input"
	var/from_ctx = consideration_args?["from_context"]

	if(isnull(from_ctx))
		from_ctx = TRUE

	var/list/aggregation_window

	if(from_ctx)
		if(isnull(context))
			return default

		aggregation_window = context[input_key]

	else
		if(isnull(consideration_args))
			return default

		aggregation_window = consideration_args[input_key]

	if(!istype(aggregation_window) || !length(aggregation_window))
		// aggregates only work if we have something to operate on
		return default

	var/aggregated_proc_raw = consideration_args?["aggregated_proc"]
	var/aggregated_proc = STR_TO_PROC(aggregated_proc_raw)

	if(isnull(aggregated_proc))
		to_world_log("ERROR: Invalid proc: [aggregated_proc_raw]! @ [__LINE__] in [__FILE__]")
		return

	if(isnull(aggregated_proc))
		return

	var/list/subargs = consideration_args?["aggregated_proc_args"]

	var/list/values = list()
	var/list/str_to_num = list()
	var/count = 0

	var/bestcount = null
	var/bestkey = null

	// We pretty much only need a list for context as a formality, and inits are expensive
	// So, we'll instead recycle this one list over and over
	var/recycleable_subctx_list[1]

	for(var/ctxitem in aggregation_window)
		recycleable_subctx_list[input_key] = ctxitem

		var/subresult = call(aggregated_proc)(action_template, recycleable_subctx_list, requester, subargs)
		if(isnull(subresult))
			continue

		var/str_val = "[subresult]"
		str_to_num[str_val] = subresult

		var/curr_valcount = (values[str_val] || 0) + 1

		values[str_val] = curr_valcount

		if(isnull(bestcount) || curr_valcount > bestcount)
			bestcount = curr_valcount
			bestkey = str_val

		count++

	if(count < 1)
		// if we didn't process anything, return default
		return default

	return str_to_num[bestkey]


/proc/medianhelper_gt(var/left, var/right)
	// returns -1 if Right > Left
	// returns 1 if Right < Left
	// return 0 if Right == Left

	if(right > left)
		return -1

	else if(right < left)
		return 1

	return 0


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_decorator_median)
	/* Calculates the median (middle value) of the wrapped proc's values
	// NOTE: do not use this for large contexts - this may require a fair bit of extra RAM!
	*/
	var/default = consideration_args?["default"] || 0
	var/input_key = consideration_args?["input_key"] || "input"
	var/from_ctx = consideration_args?["from_context"]

	if(isnull(from_ctx))
		from_ctx = TRUE

	var/list/aggregation_window

	if(from_ctx)
		if(isnull(context))
			return default

		aggregation_window = context[input_key]

	else
		if(isnull(consideration_args))
			return default

		aggregation_window = consideration_args[input_key]

	if(!istype(aggregation_window) || !length(aggregation_window))
		// aggregates only work if we have something to operate on
		return default

	var/aggregated_proc_raw = consideration_args?["aggregated_proc"]
	var/aggregated_proc = STR_TO_PROC(aggregated_proc_raw)

	if(isnull(aggregated_proc))
		to_world_log("ERROR: Invalid proc: [aggregated_proc_raw]! @ [__LINE__] in [__FILE__]")
		return

	var/list/subargs = consideration_args?["aggregated_proc_args"]

	// We'll use a Priority Queue to sort values for us
	var/PriorityQueue/values = new /PriorityQueue(/proc/medianhelper_gt)
	var/count = 0

	// We pretty much only need a list for context as a formality, and inits are expensive
	// So, we'll instead recycle this one list over and over
	var/recycleable_subctx_list[1]

	for(var/ctxitem in aggregation_window)
		recycleable_subctx_list[input_key] = ctxitem

		var/subresult = call(aggregated_proc)(action_template, recycleable_subctx_list, requester, subargs)
		if(isnull(subresult))
			continue

		values.Enqueue(subresult)
		count++

	if(count < 1)
		// if we didn't process anything, return default
		return default

	var/queuelen = length(values.L)
	if(queuelen == 1)
		return values.L[1]

	var/result

	var/midpt = queuelen / 2

	var/lowmid = FLOOR(midpt)
	var/himid = lowmid + 1

	if(midpt == lowmid)
		// even-length, we need to average two middle points
		result = ((values.L[lowmid] + values.L[himid]) / 2)

	else
		// odd-length, just take a value
		result = values.L[himid]

	return result

/*
// And now for some good old-fashioned CIs that just happen to only make sense for lists:
*/

CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_list_length)
	// Simply returns the length of a list.
	// This can be used to consider how many enemies are in view, for example.
	var/default = consideration_args?["default"] || 0
	var/from_ctx = consideration_args?["from_context"]
	var/input_key = consideration_args?["input_key"] || "input"

	if(isnull(from_ctx))
		from_ctx = TRUE

	var/list/input

	if(from_ctx)
		if(isnull(context))
			return default

		input = context[input_key]

	else
		if(isnull(consideration_args))
			return default

		input = consideration_args[input_key]

	if(isnull(input))
		return default

	return length(input)


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_relative_list_lengths)
	// Compares lengths of two lists.
	// This can be used to judge if we're at an advantage (friends > enemies) or outnumbered
	// Returns a float representing what fraction of (A+B) is represented by A
	// this can be interpreted as 'advantage' of A over B for combat AI purposes.

	var/default = consideration_args?["default"] || 0.5
	var/from_ctx = consideration_args?["from_context"]
	var/from_memory = consideration_args?["from_memory"] || FALSE

	var/input_key_one = consideration_args?["input_a"] || "input_a"
	var/input_key_two = consideration_args?["input_b"] || "input_b"

	if(isnull(from_ctx) && !from_memory)
		from_ctx = TRUE

	var/list/input_a
	var/list/input_b

	if(from_memory)
		var/datum/brain/requesting_brain = _cihelper_get_requester_brain(requester, "_cihelper_get_brain_data")

		if(!istype(requesting_brain))
			DEBUGLOG_MEMORY_FETCH("consideration_input_relative_list_lengths Brain is null ([requesting_brain || "null"]) @ L[__LINE__] in [__FILE__]")
			return default

		input_a = requesting_brain.GetMemoryValue(input_key_one)
		input_b = requesting_brain.GetMemoryValue(input_key_two)

	else if(from_ctx)
		if(isnull(context))
			return default

		input_a = context[input_key_one]
		input_b = context[input_key_two]

	else
		if(isnull(consideration_args))
			return default

		input_a = consideration_args[input_key_one]
		input_b = consideration_args[input_key_two]

	if(isnull(input_a) || isnull(input_b))
		return default

	var/len_a = length(input_a)
	var/len_b = length(input_b)

	return (len_a / (len_a + len_b))
