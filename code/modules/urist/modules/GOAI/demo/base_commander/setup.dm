
/datum/goai/proc/InitActionLookup()
	/* Largely redundant; initializes handlers, but
	// InitActions should generally use AddAction
	// with a handler arg to register them.
	// Mostly a relic of past design iterations.
	*/
	var/list/new_actionlookup = list()
	return new_actionlookup


/datum/goai/proc/InitActionsList()
	var/list/new_actionslist = list()
	return new_actionslist


/datum/goai/proc/InitSenses()
	senses = list()
	return senses


/datum/goai/proc/InitNeeds()
	needs = list()
	return needs


/datum/goai/proc/InitStates()
	states = list()
	return states


/datum/goai/proc/PreSetupHook()
	return TRUE


/datum/goai/proc/PostSetupHook()
	return TRUE
