/*
// Everything to do with the initial setup in the constructor (i.e. New())
*/

/datum/goai/proc/PreSetupHook()
	return TRUE


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
	src.senses = list()
	return senses


/datum/goai/proc/InitNeeds()
	src.needs = list()
	return needs


/datum/goai/proc/InitStates()
	src.states = list()
	return states


/datum/goai/proc/InitRelations()
	if(!(src.brain))
		return

	var/datum/relationships/relations = src.brain.relations
	if(isnull(relations) || !istype(relations))
		relations = new()

	src.brain.relations = relations
	return relations


/datum/goai/proc/PostSetupHook()
	return TRUE
