/*
// Consideration procs that deal with assessing the health of our AI controller.
*/


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_mobhealth_abs)
	// Returns the mob's absolute health. Duh.
	// Note that because we yeeted normalization to the Scoring logic, this will Just Work
	// for any mob, regardless of their default Health pool, as long as we set the Consideration params right.
	// This is more suitable for queries like 'this enemy deals 50 dmg, should I run?' than 'is my health low?'.
	// If you want a variant that will do the latter and not break on varedits, use `health/maxHealth` input instead.

	var/default = consideration_args?["default"]

	var/datum/utility_ai/mob_commander/requester_ai = requester

	if(isnull(requester_ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_mobhealth_abs Requester is not an AI (from [requester || "null"] raw val) @ L[__LINE__] in [__FILE__]")
		return null

	var/mob/living/target = null

	var/from_pawn = consideration_args?["from_pawn"]
	if(isnull(from_pawn))
		from_pawn = FALSE

	if(from_pawn)
		var/mob/living/pawn = requester_ai?.GetPawn()

		if(!istype(pawn))
			DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_mobhealth_abs - reading from pawn, but pawn is not a /mob/living ([pawn])! @ L[__LINE__] in [__FILE__]")
			return default

		target = pawn

	else
		var/input_key = consideration_args?["input_key"] || "input"
		var/from_context = consideration_args?["from_context"]
		var/from_memory = consideration_args?["from_memory"]

		if(from_context)
			target = context[input_key]

			if(!istype(target))
				DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_mobhealth_abs - target from context key [input_key] is not a /mob/living ([target])! @ L[__LINE__] in [__FILE__]")
				return default

		else if(from_memory)
			target = _cihelper_get_brain_data(action_template, context, requester, consideration_args)

			if(!istype(target))
				DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_mobhealth_abs - target from context key [input_key] is not a /mob/living ([target])! @ L[__LINE__] in [__FILE__]")
				return default

		else
			target = consideration_args[input_key]

			if(!istype(target))
				DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_mobhealth_abs - target from consideration_args key [input_key] is not a /mob/living ([target])! @ L[__LINE__] in [__FILE__]")
				return default

	if(isnull(target))
		return default

	return target.health_current


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_mobhealth_rel)
	// Returns the mob's health as a fraction of their maxHealth.
	// This is suitable for queries like 'is my health low?'.

	var/default = consideration_args?["default"]

	var/datum/utility_ai/mob_commander/requester_ai = requester

	if(isnull(requester_ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_mobhealth_rel Requester is not an AI (from [requester || "null"] raw val) @ L[__LINE__] in [__FILE__]")
		return null

	var/mob/living/target = null

	var/from_pawn = consideration_args?["from_pawn"]
	if(isnull(from_pawn))
		from_pawn = FALSE

	if(from_pawn)
		var/mob/living/pawn = requester_ai?.GetPawn()

		if(!istype(pawn))
			DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_mobhealth_rel - reading from pawn, but pawn is not a /mob/living ([pawn])! @ L[__LINE__] in [__FILE__]")
			return default

		target = pawn

	else
		var/input_key = consideration_args?["input_key"] || "input"
		var/from_context = consideration_args?["from_context"]
		var/from_memory = consideration_args?["from_memory"]

		if(from_context)
			target = context[input_key]

			if(!istype(target))
				DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_mobhealth_rel - target from context key [input_key] is not a /mob/living ([target])! @ L[__LINE__] in [__FILE__]")
				return default

		else if(from_memory)
			target = _cihelper_get_brain_data(action_template, context, requester, consideration_args)

			if(!istype(target))
				DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_mobhealth_rel - target from context key [input_key] is not a /mob/living ([target])! @ L[__LINE__] in [__FILE__]")
				return default

		else
			target = consideration_args[input_key]

			if(!istype(target))
				DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_mobhealth_rel - target from consideration_args key [input_key] is not a /mob/living ([target])! @ L[__LINE__] in [__FILE__]")
				return default

	if(isnull(target))
		return default

	// TODO: this is a kind of lazy port to new SS13 health; need to macro this to switch lib/ss13 impls
	return (target.health_current / target.health_max)
