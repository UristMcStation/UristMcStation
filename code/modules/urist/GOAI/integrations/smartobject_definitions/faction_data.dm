
GOAI_HAS_UTILITY_ACTIONS_BOILERPLATE_VARLIST(/datum/faction_data, actionset_files)

/datum/faction_data/GetUtilityActions(var/requester, var/list/args = null, var/no_cache = FALSE)
	var/list/my_action_sets = list()

	if(!src.actionset_files)
		return my_action_sets

	for(var/action_bundle_json_fp in src.actionset_files)
		if(!fexists(action_bundle_json_fp))
			GOAI_LOG_ERROR("[src.name] - Filepath [action_bundle_json_fp] does not exist - skipping!")
			continue

		try
			var/datum/action_set/myset = ActionSetFromJsonFile(action_bundle_json_fp, no_cache)
			myset.origin = src
			my_action_sets.Add(myset)

		catch(var/exception/e)
			world.Error(e)

	return my_action_sets
