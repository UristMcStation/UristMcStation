
CTXFETCHER_CALL_SIGNATURE(/proc/ctxfetcher_null)
	// A simple, demo/placeholder Fetcher, always returns null
	return null


CTXFETCHER_CALL_SIGNATURE(/proc/ctxfetcher_get_origin)
	// Retrieves the origin object.

	if(isnull(requester))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requester for ctxfetcher_read_origin_var is null @ L[__LINE__] in [__FILE__]!")
		return null

	var/datum/utility_ai/requester_ai = requester

	if(!istype(requester_ai))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requester for ctxfetcher_read_origin_var is not an AI @ L[__LINE__] in [__FILE__]!")
		return null

	var/datum/candidate = parent.origin
	var/datum/action_set/parent_actionset = candidate

	if(istype(parent_actionset))
		candidate = parent_actionset.origin

	if(isnull(candidate))
		UTILITYBRAIN_DEBUG_LOG("ActionTemplate [parent?.name] has no parent (direct or ActionSet). Cannot infer origin! @ L[__LINE__] in [__FILE__]")
		return null

	var/list/contexts = list()
	CONTEXT_GET_OUTPUT_KEY(var/context_key)
	CONTEXT_ADD_SINGLE_KEYED_CONTEXT(candidate, context_key, contexts)

	return contexts


CTXFETCHER_CALL_SIGNATURE(/proc/ctxfetcher_read_origin_var)
	// Retrieves an arbitrary variable from the origin object.

	if(isnull(requester))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requester for ctxfetcher_read_origin_var is null @ L[__LINE__] in [__FILE__]!")
		return null

	var/datum/utility_ai/requester_ai = requester

	if(!istype(requester_ai))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requester for ctxfetcher_read_origin_var is not an AI @ L[__LINE__] in [__FILE__]!")
		return null

	var/default_val = context_args["default"]
	var/var_key = context_args["variable"]

	if(isnull(var_key))
		UTILITYBRAIN_DEBUG_LOG("ctxfetcher_read_origin_var VarKey is null @ L[__LINE__] in [__FILE__]")
		return null

	var/datum/candidate = parent.origin

	var/datum/action_set/parent_actionset = candidate

	if(istype(parent_actionset))
		candidate = parent_actionset.origin

	if(isnull(candidate))
		UTILITYBRAIN_DEBUG_LOG("ActionTemplate [parent?.name] has no parent (direct or ActionSet). Cannot infer origin! @ L[__LINE__] in [__FILE__]")
		return null

	var/raw_result = candidate.vars[var_key]

	if(isnull(raw_result))
		return null

	var/result = raw_result

	var/optional_list_idx = context_args["list_idx"]

	if(!isnull(optional_list_idx))
		// if someone passed list_idx, assume raw_result is meant to be a list
		// (assoc or array) and the value is behind an index in it
		var/list/listey_raw_result = raw_result
		ASSERT(islist(listey_raw_result))

		if(!length(listey_raw_result))
			UTILITYBRAIN_DEBUG_LOG("WARNING: candidate list for [var_key] is empty, returning default [NULL_TO_TEXT(default_val)] @ L[__LINE__] in [__FILE__]")
			return default_val

		// Check if index is numeric, casting from string if needed
		var/numidx = (isnum(optional_list_idx) ? optional_list_idx : text2num(optional_list_idx))

		if(isnull(numidx))
			// Assoc list (string couldn't be converted to num -> it's an alphanumeric string)
			if(optional_list_idx in listey_raw_result)
				result = listey_raw_result[optional_list_idx]
			else
				UTILITYBRAIN_DEBUG_LOG("WARNING: key [optional_list_idx] not in candidate alist [json_encode(listey_raw_result)], returning default [NULL_TO_TEXT(default_val)] @ L[__LINE__] in [__FILE__]")
				return default_val

		else
			// Array list
			var/nonnegative_numidx = ((numidx <= 0) ? (length(listey_raw_result) - numidx) : numidx)

			if(listey_raw_result.len && listey_raw_result.len >= nonnegative_numidx)
				result = listey_raw_result[nonnegative_numidx]
			else
				UTILITYBRAIN_DEBUG_LOG("WARNING: index [nonnegative_numidx] not in candidate list [json_encode(listey_raw_result)], returning default [NULL_TO_TEXT(default_val)] @ L[__LINE__] in [__FILE__]")
				return default_val

	UTILITYBRAIN_DEBUG_LOG("Value for var [var_key] in [candidate] is [result] @ L[__LINE__] in [__FILE__]")

	var/list/contexts = list()
	var/context_key = context_args["output_context_key"] || "origin_val"
	var/origin_key = context_args["origin_context_key"]

	var/list/ctx = list()
	ctx[context_key] = result

	if(!isnull(origin_key))
		ctx[origin_key] = candidate

	contexts[++(contexts.len)] = ctx

	return contexts


CTXFETCHER_CALL_SIGNATURE(/proc/ctxfetcher_read_another_contextarg)
	// Retrieves an arbitrary key from the context args.
	//
	// This is a very wonky way to allow direct passing of values into a Consideration generically:
	// Whoever designs the consideration injects a hashmap with an appropriate value to use and
	// puts its name in the value of another, constant-valued key of 'contextarg_variable'.
	//
	// Why? Because that makes it much easier to mass-produce ActionTemplate data programmatically.
	// This is important for things like GOAP plans getting turned into Utility action templates.

	var/var_key = context_args["contextarg_variable"]
	var/var_val = context_args[var_key]

	UTILITYBRAIN_DEBUG_LOG("Value for var [var_key] in context_args is [var_val] @ L[__LINE__] in [__FILE__]")

	var/list/contexts = list()

	var/context_key = context_args["output_context_key"]

	if(isnull(context_key))
		return list() // instead of defaulting, skip?
		//context_key = "contextarg_val"

	var/list/ctx = list()
	ctx[context_key] = var_val

	contexts[++(contexts.len)] = ctx

	return contexts
