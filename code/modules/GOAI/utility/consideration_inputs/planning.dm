
# define PLANNING_CONSIDERATIONS_LOG(x)
//# define PLANNING_CONSIDERATIONS_LOG(x) to_world(x); to_world_log(x)

CONSIDERATION_CALL_SIGNATURE(/proc/consideration_actiontemplate_preconditions_met)
	// Retrieves Preconditions from the candidate ActionTemplate object.
	// If any is not satisfied, return False.
	var/datum/utility_action_template/candidate = action_template

	if(isnull(candidate))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_actiontemplate_preconditions_met Candidate is not an ActionTemplate! @ L[__LINE__] in [__FILE__]")
		return null

	if(isnull(requester))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_actiontemplate_preconditions_met - Requester must be provided for this Consideration! @ L[__LINE__] in [__FILE__]")
		return null

	var/datum/utility_ai/ai = requester

	if(isnull(ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_actiontemplate_preconditions_met - Requester must be a Utility controller for this Consideration! @ L[__LINE__] in [__FILE__]")
		return null

	var/list/preconds = candidate.preconditions

	if(isnull(preconds) || !preconds.len)
		// No preconds - automatically satisfied
		return TRUE

	// Build a worldstate query. This makes me want to cry.
	var/list/ws_query = list()

	for(var/target_qry_key in preconds)
		var/actual_target = target_qry_key

		// resolve to a queriable entity
		if(target_qry_key == "target")
			var/target_key = consideration_args["target_key"]
			actual_target = context[target_key]

		if(target_qry_key == "pawn")
			var/datum/utility_ai/mob_commander/commander = ai

			if(!istype(commander))
				// Needs to be an AI with a mob, but isn't
				return FALSE

			var/atom/pawn = commander.GetPawn()

			if(isnull(pawn))
				// Needs to be an AI with a mob, but isn't
				return FALSE

			actual_target = pawn

		if(isnull(actual_target))
			// if we couldn't resolve it, pass
			// this is because it's most likely a special-case key like 'global'
			DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_actiontemplate_preconditions_met - Skipping query for [target_qry_key] - failed to resolve! @ L[__LINE__] in [__FILE__]")
			continue

		var/list/query_keys = preconds[target_qry_key]
		ws_query[actual_target] = query_keys

	// Run the damn thing.
	var/list/world_state = ai.QueryWorldState(ws_query)

	// Check results.
	for(var/raw_target_key in preconds)
		var/target_key = raw_target_key

		if(raw_target_key == "target")
			var/action_target_key = consideration_args["target_key"]
			target_key = context[action_target_key]

		else if(raw_target_key == "pawn")
			var/datum/utility_ai/mob_commander/commander = ai

			if(!istype(commander))
				// Needs to be an AI with a mob, but isn't
				return FALSE

			var/atom/pawn = commander.GetPawn()

			if(isnull(pawn))
				// Needs to be an AI with a mob, but isn't
				return FALSE

			target_key = pawn

		PLANNING_CONSIDERATIONS_LOG("AT [action_template.name] preconds check for [target_key]!!!")

		if(!(target_key in world_state))
			PLANNING_CONSIDERATIONS_LOG("- AT [action_template.name] [target_key] not in worldstate!")
			return FALSE

		var/list/target_preconds = preconds[raw_target_key]
		var/list/target_worldstate = world_state[target_key]

		for(var/precond_key in target_preconds)
			PLANNING_CONSIDERATIONS_LOG("- AT [action_template.name] preconds check for [target_key]/[precond_key]!")

			if(precond_key[1] == "_")
				// leading underscore indicates GOAP-only stuff
				continue

			var/precond_val = target_preconds[precond_key]
			var/worldval = null

			if(precond_val > 0)
				// Intuitively normal case; state value is a minimum satisfactory value
				if(!(precond_key in target_worldstate))
					// missing interpreted as false
					PLANNING_CONSIDERATIONS_LOG("--- AT [action_template.name] failed preconds check for [target_key]/[precond_key] - V0")
					PLANNING_CONSIDERATIONS_LOG("--- AT [action_template.name] V0 - TOTAL WS: [json_encode(world_state)]")
					PLANNING_CONSIDERATIONS_LOG("--- AT [action_template.name] V0 - WS: [json_encode(target_worldstate)]")
					return FALSE

				worldval = target_worldstate[precond_key]
				PLANNING_CONSIDERATIONS_LOG("-- AT [action_template.name] preconds worldval for [target_key]/[precond_key] is: [worldval] @ thresh [precond_val]")

				if(worldval < precond_val)
					// not satisfied
					PLANNING_CONSIDERATIONS_LOG("--- AT [action_template.name] failed preconds check for [target_key]/[precond_key] - V1")
					return FALSE

				PLANNING_CONSIDERATIONS_LOG("--- AT [action_template.name] preconds check for [target_key]/[precond_key] - PASS [worldval] @ thresh [precond_val]")

			if(precond_val <= 0)
				// We use -val as a logical inverse of the normal check as done for the abs(val)
				// In other words:
				// val = +2 -> must be 2 or more
				// val = -2 -> must be 2 or less (2 == abs(-2))
				// val=0 is interpreted as 'boolean predicate is FALSE'.

				if(!(precond_key in target_worldstate))
					PLANNING_CONSIDERATIONS_LOG("--- AT [action_template.name] preconds check for [target_key]/[precond_key] - PASS, special case, missing key passthru...")
					continue

				worldval = target_worldstate[precond_key]
				PLANNING_CONSIDERATIONS_LOG("-- AT [action_template.name] preconds worldval for [target_key]/[precond_key] is: [worldval] @ thresh [precond_val]")

				if(worldval >= -precond_val)
					PLANNING_CONSIDERATIONS_LOG("--- AT [action_template.name] failed preconds check for [target_key]/[precond_key] - V2")
					return FALSE

				PLANNING_CONSIDERATIONS_LOG("--- AT [action_template.name] preconds check for [target_key]/[precond_key] - PASS [worldval] @ thresh [precond_val]")

	PLANNING_CONSIDERATIONS_LOG("AT [action_template.name] passed all preconds checks...")
	return TRUE


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_actiontemplate_effects_not_all_met)
	// Retrieves Effects from the candidate ActionTemplate object.
	// If any is not satisfied, return True.
	var/datum/utility_action_template/candidate = action_template

	if(isnull(candidate))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_actiontemplate_effects_not_all_met Candidate is not an ActionTemplate! @ L[__LINE__] in [__FILE__]")
		return null

	if(isnull(requester))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_actiontemplate_effects_not_all_met - Requester must be provided for this Consideration! @ L[__LINE__] in [__FILE__]")
		return null

	var/datum/utility_ai/ai = requester

	if(isnull(ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_actiontemplate_effects_not_all_met - Requester must be a Utility controller for this Consideration! @ L[__LINE__] in [__FILE__]")
		return null

	var/list/effects = candidate.effects

	if(isnull(effects) || !effects.len)
		// No effects - no point running
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_actiontemplate_effects_not_all_met - No effects! @ L[__LINE__] in [__FILE__]")
		return FALSE

	// Build a worldstate query. This makes me want to cry.
	var/list/ws_query = list()

	for(var/target_qry_key in effects)
		var/actual_target = target_qry_key

		// resolve to a queriable entity
		if(target_qry_key == "target")
			var/target_key = consideration_args["target_key"]
			actual_target = context[target_key]

		if(target_qry_key == "pawn")
			var/datum/utility_ai/mob_commander/commander = ai

			if(!istype(commander))
				// Needs to be an AI with a mob, but isn't
				return FALSE

			var/atom/pawn = commander.GetPawn()

			if(isnull(pawn))
				// Needs to be an AI with a mob, but isn't
				return FALSE

			actual_target = pawn

		if(isnull(actual_target))
			// if we couldn't resolve it, pass
			// this is because it's most likely a special-case key like 'global'
			DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_actiontemplate_effects_not_all_met - Skipping query for [target_qry_key] - failed to resolve! @ L[__LINE__] in [__FILE__]")
			continue

		var/list/query_keys = effects[target_qry_key]
		ws_query[actual_target] = query_keys

	// Run the damn thing.
	var/list/world_state = ai.QueryWorldState(ws_query)

	for(var/raw_target_key in effects)
		var/target_key = raw_target_key

		if(raw_target_key == "target")
			var/action_target_key = consideration_args["target_key"]
			target_key = context[action_target_key]

		else if(raw_target_key == "pawn")
			var/datum/utility_ai/mob_commander/commander = ai

			if(!istype(commander))
				// Needs to be an AI with a mob, but isn't
				continue

			var/atom/pawn = commander.GetPawn()

			if(isnull(pawn))
				// Needs to be an AI with a mob, but isn't
				continue

			target_key = pawn

		PLANNING_CONSIDERATIONS_LOG("AT [action_template.name] effects check for [target_key]!!!")

		if(!(target_key in world_state))
			PLANNING_CONSIDERATIONS_LOG("- AT [action_template.name] - [target_key] not in worldstate!")
			return TRUE

		var/list/target_worldstate = world_state[target_key]
		var/list/effect_worldstate = effects[raw_target_key]

		PLANNING_CONSIDERATIONS_LOG("AT [action_template.name] effects worldstate is [json_encode(effect_worldstate)]")

		for(var/effect_key in effect_worldstate)
			PLANNING_CONSIDERATIONS_LOG("- AT [action_template.name] effects check for [target_key]/[effect_key]!")

			if(effect_key[1] == "_")
				// leading underscore indicates GOAP-only stuff
				continue

			var/effect_val = effect_worldstate[effect_key]

			if(!(effect_key in target_worldstate))
				PLANNING_CONSIDERATIONS_LOG("-- AT [action_template.name] - [target_key]/[effect_key] not in worldstate [json_encode(worldstate)]!")
				return TRUE

			var/worldval = null

			if(effect_val > 0)
				// Intuitively normal case; state value is a minimum satisfactory value
				if(!(effect_key in target_worldstate))
					// missing interpreted as false
					return TRUE

				worldval = target_worldstate[effect_key]
				PLANNING_CONSIDERATIONS_LOG("-- AT [action_template.name] effects worldval for [target_key]/[effect_key] is: [worldval] @ thresh [effect_val] in [json_encode(worldstate)]")

				if(worldval < effect_val)
					// not satisfied
					PLANNING_CONSIDERATIONS_LOG("--- AT [action_template.name] stopped at effect check for [target_key]/[effect_key] - V1")
					return TRUE

				PLANNING_CONSIDERATIONS_LOG("--- AT [action_template.name] effect check for [target_key]/[effect_key] - ALREADY DONE A == [worldval] @ thresh [effect_val]")

			if(effect_val <= 0)
				// We use -val as a logical inverse of the normal check as done for the abs(val)
				// In other words:
				// val = +2 -> must be 2 or more
				// val = -2 -> must be 2 or less (2 == abs(-2))
				// val=0 is interpreted as 'boolean predicate is FALSE'.

				if(!(effect_key in target_worldstate))
					if(effect_val == 0)
						PLANNING_CONSIDERATIONS_LOG("--- AT [action_template.name] effects check for [target_key]/[effect_key] - PASS, special case, missing key passthru...")
						continue

					PLANNING_CONSIDERATIONS_LOG("--- AT [action_template.name] stopped at effect check for [target_key]/[effect_key] - V3")
					return TRUE

				worldval = target_worldstate[effect_key]
				PLANNING_CONSIDERATIONS_LOG("-- AT [action_template.name] effects worldval for [target_key]/[effect_key] is: [worldval] @ thresh [effect_val]")

				if(worldval != -effect_val)
					PLANNING_CONSIDERATIONS_LOG("--- AT [action_template.name] missed effect check for [target_key]/[effect_key] - V2")
					return TRUE

				PLANNING_CONSIDERATIONS_LOG("--- AT [action_template.name] effect check for [target_key]/[effect_key] - ALREADY DONE B == [worldval] @ thresh [effect_val]")

	PLANNING_CONSIDERATIONS_LOG("AT [action_template.name] missed all effect checks...")
	return FALSE

