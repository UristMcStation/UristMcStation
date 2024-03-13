
CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_get_personality_trait)
	/* Fetching Personality traits.
	//
	// Can be used e.g. to fetch Bravery to account for it in fleeing checks,
	// or Bloodthirsty to favor melee over ranged attacks.
	*/
	var/datum/brain/requesting_brain = _cihelper_get_requester_brain(requester, "_cihelper_get_brain_data")

	if(!istype(requesting_brain))
		DEBUGLOG_MEMORY_FETCH("consideration_input_get_personality_trait Brain is null ([requesting_brain || "null"]) @ L[__LINE__] in [__FILE__]")
		return FALSE

	var/input_key = "input"

	if(!isnull(consideration_args))
		input_key = consideration_args["input_key"] || input_key

	if(isnull(input_key))
		DEBUGLOG_MEMORY_FETCH("consideration_input_get_personality_trait Input Key is null ([input_key || "null"]) @ L[__LINE__] in [__FILE__]")
		return null

	var/default = null

	if(!isnull(consideration_args))
		default = consideration_args["default"]

	if(isnull(default))
		default = 0

	var/value = requesting_brain.personality.Get(input_key)
	if(isnull(value))
		return default

	return value
