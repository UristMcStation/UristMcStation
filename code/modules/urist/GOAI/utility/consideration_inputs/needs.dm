
CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_get_need_perc)
	var/datum/brain/requesting_brain = _cihelper_get_requester_brain(requester, "consideration_input_get_need_perc")

	if(!istype(requesting_brain))
		DEBUGLOG_MEMORY_FETCH("consideration_input_get_need_perc Brain is null ([requesting_brain || "null"]) @ L[__LINE__] in [__FILE__]")
		return FALSE

	var/input_key = "input"

	if(!isnull(consideration_args))
		input_key = consideration_args["input_key"] || input_key

	if(isnull(input_key))
		DEBUGLOG_MEMORY_FETCH("consideration_input_get_need_perc Input Key is null ([input_key || "null"]) @ L[__LINE__] in [__FILE__]")
		return null

	var/default = null

	if(!isnull(consideration_args))
		default = consideration_args["default"]

	if(isnull(default))
		default = NEED_MAXIMUM

	var/value = requesting_brain.needs[input_key]
	if(isnull(value))
		return default

	// normalise to 0-1
	// technically we should do x/(MAX-MIN), but we can assume MIN is always 0
	// and MAX is just scaling the increments
	var/result = (value / NEED_MAXIMUM)

	return result
