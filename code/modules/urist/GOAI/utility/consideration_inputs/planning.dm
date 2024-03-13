
# define PLANNING_CONSIDERATIONS_LOG(x)
//# define PLANNING_CONSIDERATIONS_LOG(x) to_world(x); to_world_log(x)

CONSIDERATION_CALL_SIGNATURE(/proc/consideration_actiontemplate_preconditions_met)
	// Retrieves Preconditions from the candidate ActionTemplate object.
	// If any is not satisfied, return False.
	var/datum/utility_action_template/candidate = action_template

	if(!istype(candidate))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_actiontemplate_preconditions_met Candidate is not an ActionTemplate! @ L[__LINE__] in [__FILE__]")
		return null

	if(isnull(requester))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_actiontemplate_preconditions_met - Requester must be provided for this Consideration! @ L[__LINE__] in [__FILE__]")
		return null

	var/datum/utility_ai/ai = requester

	if(!istype(ai))
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

			if(!istype(pawn))
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

			if(!istype(pawn))
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

	if(!istype(candidate))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_actiontemplate_effects_not_all_met Candidate is not an ActionTemplate! @ L[__LINE__] in [__FILE__]")
		return null

	if(isnull(requester))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_actiontemplate_effects_not_all_met - Requester must be provided for this Consideration! @ L[__LINE__] in [__FILE__]")
		return null

	var/datum/utility_ai/ai = requester

	if(!istype(ai))
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

			if(!istype(pawn))
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


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_actiontemplate_effects_cycling)
	// Retrieves Effects from the candidate ActionTemplate object
	// AND from the last selected ActionTemplate.
	// Compares the abs() of their values.
	// If the absolute values are equal AND all keys are present in both lists, returns TRUE.
	// Otherwise, returns FALSE.
	//
	// In this case, TRUE indicates that the current action is either redundant (duplicates effects already set)
	// or there's a cycle in which two actions keep running and cancelling each other's effects out, which looks dumb.
	//
	// An example case of this behavior can be seen with screwdriving doors for hacking.
	// We want screw/unscrew actions to flank the Hack action, but we do NOT want the AI to just cycle
	// screw->unscrew->screw forever in a loop.
	//
	var/datum/utility_action_template/candidate = action_template

	if(!istype(candidate))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_actiontemplate_effects_cycling Candidate is not an ActionTemplate! @ L[__LINE__] in [__FILE__]")
		return null

	if(isnull(requester))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_actiontemplate_effects_cycling - Requester must be provided for this Consideration! @ L[__LINE__] in [__FILE__]")
		return null

	var/datum/brain/requesting_brain = _cihelper_get_requester_brain(requester, "consideration_actiontemplate_effects_cycling")

	if(!istype(requesting_brain))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_actiontemplate_effects_cycling Brain is null ([requesting_brain || "null"]) @ L[__LINE__] in [__FILE__]")
		// TRUE is 'invalid'-ish here, we should stop this from executing if the input is messed up so we use TRUE
		return TRUE

	var/list/cand_effects = candidate.effects

	if(isnull(cand_effects) || !cand_effects.len)
		// No effects - can't be cyclic
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_actiontemplate_effects_cycling - No candidate effects... @ L[__LINE__] in [__FILE__]")
		return FALSE

	var/memkey = consideration_args?["memory_key"] || "SelectedActionTemplate"
	var/datum/utility_action_template/stored_template = requesting_brain.GetMemoryValue(memkey)

	if(!istype(stored_template))
		// No effects - can't be cyclic
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_actiontemplate_effects_cycling - No stored effects... @ L[__LINE__] in [__FILE__]")
		return FALSE

	var/list/lastchoice_effects = stored_template.effects

	if(isnull(lastchoice_effects) || !lastchoice_effects.len)
		// No effects - can't be cyclic
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_actiontemplate_effects_cycling - No stored effects... @ L[__LINE__] in [__FILE__]")
		return FALSE

	for(var/cand_eff_key in cand_effects)
		var/cand_val_raw = cand_effects[cand_eff_key]
		var/lastchoice_val_raw = lastchoice_effects[cand_eff_key]

		if(isnull(lastchoice_val_raw))
			if(isnull(cand_val_raw))
				// unlikely, but possible; cannot do abs, so just skip
				continue

			// cannot possibly match, early return
			return FALSE

		var/cand_val_abs =  abs(cand_val_raw)
		var/lastchoice_val_abs = abs(lastchoice_val_raw)

		if(cand_val_abs != lastchoice_val_abs)
			// just one delta is sufficient to prove a mismatch
			return FALSE

	// We PROBABLY should iterate over lastchoice and check all the same stuff
	// but for now we'll assume we don't care if the previous effects are a superset.
	// If we got to here, no mismatches were found, hence TRUE.
	return TRUE
