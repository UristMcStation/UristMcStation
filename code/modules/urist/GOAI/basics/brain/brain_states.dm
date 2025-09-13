#define BRAIN_MODULE_INCLUDED_STATES 1

/datum/brain
	var/list/states


/datum/brain/proc/InitStates()
	src.states = list()
	return states


/datum/brain/proc/GetState(var/key, var/default = null)
	if(isnull(src.states))
		return default

	var/found = (key in src.states)
	var/result = (found ? src.states[key] : default)
	return result


/datum/brain/proc/SetState(var/key, var/val)
	if(isnull(src.states))
		src.states = new()

	src.states[key] = val
	return TRUE

