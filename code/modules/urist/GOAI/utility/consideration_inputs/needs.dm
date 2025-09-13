CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_get_need_perc)
	var/datum/brain/requesting_brain = _cihelper_get_requester_brain(requester, "consideration_input_get_need_perc")

	if(!istype(requesting_brain))
		DEBUGLOG_MEMORY_FETCH("consideration_input_get_need_perc Brain is null ([requesting_brain || "null"]) @ L[__LINE__] in [__FILE__]")
		return FALSE

	var/input_key = CONSIDERATION_INPUTKEY_DEFAULT
	input_key = consideration_args?[CONSIDERATION_INPUTKEY_KEY] || input_key

	if(isnull(input_key))
		DEBUGLOG_MEMORY_FETCH("consideration_input_get_need_perc for [requesting_brain] - Input Key is null ([input_key || "null"]) @ L[__LINE__] in [__FILE__]")
		return null

	var/from_ctx = consideration_args?["from_context"]
	if(isnull(from_ctx))
		from_ctx = TRUE

	var/need_key = (from_ctx ? context[input_key] : consideration_args[input_key])

	var/default = null

	if(!isnull(consideration_args))
		default = consideration_args?["default"]

	if(isnull(default))
		default = NEED_MAXIMUM

	var/value = requesting_brain.GetNeed(need_key, null)

	#ifdef ENABLE_GOAI_DEVEL_LOGGING
	var/log_need_value = consideration_args?["log_need_value"]

	if(log_need_value)
		GOAI_LOG_DEBUG("INFO: consideration_input_get_need_perc for [requesting_brain] - raw need value for Need [need_key] is [NULL_TO_TEXT(value)] @ L[__LINE__] in [__FILE__]!")
	#endif

	if(isnull(value))
		return default

	// What the percentage is relative TO.
	// By default, to need maximum (so it's a true percentage).
	// An advanced, riskier application is to apply other constants - e.g. '1' for raw denormalized value.
	var/normalization_value = consideration_args?["normalization_value"]
	normalization_value = DEFAULT_IF_NULL(normalization_value, NEED_MAXIMUM)

	// normalise to 0-1
	// technically we should do x/(MAX-MIN), but we can assume MIN is always 0
	// and MAX is just scaling the increments
	var/result = (value / normalization_value)

	return result


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_get_lowest_need_perc)
	var/datum/brain/requesting_brain = _cihelper_get_requester_brain(requester, "consideration_input_get_lowest_need_perc")

	if(!istype(requesting_brain))
		DEBUGLOG_MEMORY_FETCH("consideration_input_get_lowest_need_perc Brain is null ([requesting_brain || "null"]) @ L[__LINE__] in [__FILE__]")
		return FALSE

	var/input_key = CONSIDERATION_INPUTKEY_DEFAULT

	if(!isnull(consideration_args))
		input_key = consideration_args?[CONSIDERATION_INPUTKEY_KEY] || input_key

	if(isnull(input_key))
		DEBUGLOG_MEMORY_FETCH("consideration_input_get_lowest_need_perc for [requesting_brain] - Input Key is null ([input_key || "null"]) @ L[__LINE__] in [__FILE__]")
		return null

	var/default = null

	if(!isnull(consideration_args))
		default = consideration_args?["default"]

	var/list/needs_by_weight = requesting_brain.GetNeedWeights() || list()

	var/lowest_need = null
	var/lowest_value = null

	for(var/need_key in needs_by_weight)
		var/need_weight = needs_by_weight[need_key]

		if(!need_weight)
			// ignore unimportant needs
			continue

		var/need_value = requesting_brain.GetNeed(input_key, null)

		if(isnull(need_value))
			continue

		if(isnull(lowest_value) || (need_value < lowest_value))
			lowest_value = need_value
			lowest_need = need_key

	#ifdef ENABLE_GOAI_DEVEL_LOGGING
	var/log_need_value = consideration_args?["log_need_value"]

	if(log_need_value)
		GOAI_LOG_DEBUG("INFO: consideration_input_get_lowest_need_perc for [requesting_brain] - raw need value for Need [lowest_need] is [NULL_TO_TEXT(lowest_value)] @ L[__LINE__] in [__FILE__]!")
	#endif

	if(isnull(lowest_need))
		return default

	// What the percentage is relative TO.
	// By default, to need maximum (so it's a true percentage).
	// An advanced, riskier application is to apply other constants - e.g. '1' for raw denormalized value.
	var/normalization_value = consideration_args?["normalization_value"]
	normalization_value = DEFAULT_IF_NULL(normalization_value, NEED_MAXIMUM)

	// normalise to 0-1
	// technically we should do x/(MAX-MIN), but we can assume MIN is always 0
	// and MAX is just scaling the increments
	var/result = (lowest_value / normalization_value)

	return result


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_get_need_weight)
	/* Returns the weight of a given need.
	// This can be used to scale down the priority of individual needs without scaling down
	// the priority of the whole action.
	*/
	var/datum/brain/requesting_brain = _cihelper_get_requester_brain(requester, "consideration_input_get_need_weight")

	if(!istype(requesting_brain))
		DEBUGLOG_MEMORY_FETCH("consideration_input_get_need_weight Brain is null ([requesting_brain || "null"]) @ L[__LINE__] in [__FILE__]")
		return FALSE

	var/input_key = CONSIDERATION_INPUTKEY_DEFAULT
	input_key = consideration_args?[CONSIDERATION_INPUTKEY_KEY] || input_key

	if(isnull(input_key))
		DEBUGLOG_MEMORY_FETCH("consideration_input_get_need_weight for [requesting_brain] -  Input Key is null ([input_key || "null"]) @ L[__LINE__] in [__FILE__]")
		return null

	var/from_ctx = consideration_args?["from_context"]
	if(isnull(from_ctx))
		from_ctx = TRUE

	var/need_key = (from_ctx ? context[input_key] : consideration_args[input_key])

	var/default = null

	if(!isnull(consideration_args))
		default = consideration_args["default"]

	if(isnull(default))
		default = 0

	var/value = requesting_brain.GetNeedWeight(need_key, null)
	if(isnull(value))
		return default

	return value
