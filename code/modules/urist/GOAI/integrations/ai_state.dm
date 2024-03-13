

/datum
	var/list/worldstate = null


/datum/proc/InitWorldstate()
	if(isnull(src.worldstate))
		src.worldstate = list()

	return src


/datum/proc/SetWorldstate(var/key, var/val)
	if(isnull(src.worldstate))
		src.InitWorldstate()

	src.worldstate[key] = val
	return src


/datum/proc/GetWorldstate()
	// Returns the whole Worldstate, initializing it if necessary

	if(isnull(src.worldstate))
		src.InitWorldstate()

	return src.worldstate


/datum/proc/GetWorldstateValue(var/key, var/default = null)
	// Returns a value for a specific Worldstate key, initializing the Worldstate if necessary

	if(isnull(src.worldstate))
		src.InitWorldstate()

	var/val = null

	if(key in src.worldstate)
		val = src.worldstate[key]

	else if(key in src.vars)
		val = src.vars[key]

	else
		val = default

	return val

