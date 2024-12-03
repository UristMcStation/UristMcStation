
/datum/faction_data/InitializeGlobalId(var/list/args = null)
	if(src.global_id)
		// Do not rewrite the ID if initialized
		return src.global_id

	// By default, generate an ID from the registry index stringified
	var/default_id = "[src.registry_index]"
	src.global_id = default_id
	return default_id
