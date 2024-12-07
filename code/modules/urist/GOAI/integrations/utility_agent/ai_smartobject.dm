/*
// This module defines how Faction AIs function as SmartObjects (for their own consumption)
*/

GOAI_HAS_UTILITY_ACTIONS_BOILERPLATE_VARLIST(/datum/utility_ai, src.innate_actions_filepaths)

/datum/utility_ai/GetUtilityActions(var/requester, var/list/args = null, var/no_cache = null)
	var/list/my_action_sets = list()
	var/_no_cache = DEFAULT_IF_NULL(no_cache, src.disable_so_cache)

	if(!src.innate_actions_filepaths)
		return my_action_sets

	for(var/action_bundle_json_fp in src.innate_actions_filepaths)
		if(!fexists(action_bundle_json_fp))
			GOAI_LOG_ERROR("[src.name] - Filepath [action_bundle_json_fp] does not exist - skipping!")
			continue

		try
			var/datum/action_set/myset = ActionSetFromJsonFile(action_bundle_json_fp, _no_cache)
			myset.origin = src
			my_action_sets.Add(myset)

		catch(var/exception/e)
			world.Error(e)

	return my_action_sets
