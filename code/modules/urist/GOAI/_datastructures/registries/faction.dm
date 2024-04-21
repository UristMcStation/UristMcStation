// lazily initialized by the first AI to register itself

// first registry is faction_data datums, second is AIs driving these

# ifdef GOAI_LIBRARY_FEATURES
var/global/list/global_faction_registry
var/global/list/global_faction_ai_registry
# endif
# ifdef GOAI_SS13_SUPPORT
GLOBAL_LIST_EMPTY(global_faction_registry)
GLOBAL_LIST_EMPTY(global_faction_ai_registry)
# endif

# define IS_REGISTERED_FACTION(id) (id && GOAI_LIBBED_GLOB_ATTR(global_faction_registry) && (id <= GOAI_LIBBED_GLOB_ATTR(global_faction_registry.len)))
# define IS_REGISTERED_FACTION_AI(id) (id && GOAI_LIBBED_GLOB_ATTR(global_faction_ai_registry) && (id <= GOAI_LIBBED_GLOB_ATTR(global_faction_ai_registry.len)))


/proc/deregister_faction(var/id)
	// Deletes the Faction and deregisters it from the global.

	if(!(GOAI_LIBBED_GLOB_ATTR(global_faction_ai_registry)))
		return

	if(!(IS_REGISTERED_FACTION_AI(id)))
		return

	var/datum/utility_ai/ai = GOAI_LIBBED_GLOB_ATTR(global_faction_ai_registry[id])

	/* We want only valid AIs here; if somehow we get a non-AI here,
	// we want to null it out; regular nulls stay nulls.
	*/

	// Leave a 'hole' in the global list - the indices should NOT be mutable!
	// (the registry is a babby's first SparseSet)
	GOAI_LIBBED_GLOB_ATTR(global_faction_ai_registry[id]) = null

	if(ai)
		qdel(ai)

	return


/datum/utility_ai/proc/RegisterFaction()
	// Registry pattern, to facilitate querying all GOAI Brains in verbs
	if(isnull( GOAI_LIBBED_GLOB_ATTR(global_faction_ai_registry) ))
		GOAI_LIBBED_GLOB_ATTR(global_faction_ai_registry) = list()

	if(src.registry_index)
		// already done, fix up the registry to be sure and return
		var/list/registry = GOAI_LIBBED_GLOB_ATTR(global_faction_ai_registry)

		while(registry.len < src.registry_index)
			registry.len++

		registry[src.registry_index] = src
		GOAI_LIBBED_GLOB_ATTR(global_faction_ai_registry) = registry

		return GOAI_LIBBED_GLOB_ATTR(global_faction_ai_registry)

	GOAI_LIBBED_GLOB_ATTR(global_faction_ai_registry) += src
	src.registry_index = GOAI_LIBBED_GLOB_ATTR(global_faction_ai_registry.len)

	if(!(src.name))
		src.name = src.registry_index

	return GOAI_LIBBED_GLOB_ATTR(global_faction_ai_registry)
