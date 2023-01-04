// lazily initialized by the first AI to register itself
GLOBAL_LIST_EMPTY(global_faction_registry)

# define IS_REGISTERED_FACTION(id) (id && GLOB?.global_faction_registry && (id <= GLOB.global_faction_registry.len))


/proc/deregister_faction(var/id)
	// Deletes the Faction and deregisters it from the global.

	if(!(GLOB.global_faction_registry))
		return

	if(!(IS_REGISTERED_FACTION(id)))
		return

	var/datum/goai/ai = GLOB.global_faction_registry[id]

	/* We want only valid AIs here; if somehow we get a non-AI here,
	// we want to null it out; regular nulls stay nulls.
	*/

	// Leave a 'hole' in the global list - the indices should NOT be mutable!
	// (the registry is a babby's first SparseSet)
	GLOB.global_faction_registry[id] = null

	if(ai)
		qdel(ai)

	return


/datum/goai/proc/RegisterFaction()
	// Registry pattern, to facilitate querying all GOAI Brains in verbs
	if(src.registry_index)
		// already done, fix up the registry to be sure and return
		GLOB?.global_faction_registry?[src.registry_index] = src
		return GLOB?.global_faction_registry

	GLOB?.global_faction_registry += src
	src.registry_index = GLOB?.global_faction_registry.len

	if(!(src.name))
		src.name = src.registry_index

	return GLOB?.global_faction_registry
