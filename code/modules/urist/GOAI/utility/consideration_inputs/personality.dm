
CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_get_personality_trait)
	/* Fetching Personality traits.
	//
	// Can be used e.g. to fetch Bravery to account for it in fleeing checks,
	// or Bloodthirsty to favor melee over ranged attacks.
	*/
	var/datum/brain/requesting_brain = _cihelper_get_requester_brain(requester, "consideration_input_get_personality_trait")

	if(!istype(requesting_brain))
		DEBUGLOG_MEMORY_FETCH("consideration_input_get_personality_trait Brain is null ([requesting_brain || "null"]) @ L[__LINE__] in [__FILE__]")
		return FALSE

	var/input_key = CONSIDERATION_INPUTKEY_DEFAULT

	if(!isnull(consideration_args))
		input_key = consideration_args[CONSIDERATION_INPUTKEY_KEY] || input_key

	if(isnull(input_key))
		DEBUGLOG_MEMORY_FETCH("consideration_input_get_personality_trait Input Key is null ([input_key || "null"]) @ L[__LINE__] in [__FILE__]")
		return null

	var/default = null

	if(!isnull(consideration_args))
		default = consideration_args["default"]

	if(isnull(default))
		default = 0

	var/value = requesting_brain.personality?[input_key]
	if(isnull(value))
		return default

	return value


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_get_personality_trait_as_probability_mass)
	/* Slight variant on consideration_input_get_personality_trait().
	// Instead of returning the raw value, uses the value (with possible rescaling)
	// as an input to prob() and returns the resulting boolean.
	*/

	var/probmass = consideration_input_get_personality_trait(action_template, context, requester, consideration_args)

	var/default = consideration_args?["default"]

	if(isnull(default))
		default = 0

	if(isnull(probmass))
		return default

	var/rescale_factor = consideration_args?["rescale_factor"]

	if(isnull(rescale_factor))
		// Assume personality is normalized to <0, 1> by default
		rescale_factor = 100

	var/scaled_probmass = probmass * rescale_factor

	var/safe_probmass = clamp(scaled_probmass, 0, 100)
	var/value = prob(safe_probmass)

	return value
