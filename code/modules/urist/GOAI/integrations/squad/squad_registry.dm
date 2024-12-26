/*
// Registry pattern, to facilitate querying all Squads in verbs and AIs
*/

// lazily initialized by the first brain to register itself

# ifdef GOAI_LIBRARY_FEATURES
var/global/list/global_squad_registry
# endif
# ifdef GOAI_SS13_SUPPORT
GLOBAL_LIST_EMPTY(global_squad_registry)
# endif

# define IS_REGISTERED_SQUAD(id) GLOBAL_ARRAY_LOOKUP_BOUNDS_CHECK(id, global_squad_registry)

/proc/deregister_squad(var/id)
	// Deletes the Squad and deregisters it from the global.

	if(!(GOAI_LIBBED_GLOB_ATTR(global_squad_registry)))
		return

	if(!(IS_REGISTERED_AI(id)))
		return

	var/datum/squad/deadsquad = GOAI_LIBBED_GLOB_ATTR(global_squad_registry[id])

	/* We want only valid AIs here; if somehow we get a non-AI here,
	// we want to null it out; regular nulls stay nulls.
	*/

	// Leave a 'hole' in the global list - the indices should NOT be mutable!
	// (the registry is a babby's first SparseSet)
	GOAI_LIBBED_GLOB_ATTR(global_squad_registry[id]) = null

	if(deadsquad)
		qdel(deadsquad)

	return


/datum/squad/proc/RegisterSquad()
	// Adds a new Squad to the registry
	if(isnull(GOAI_LIBBED_GLOB_ATTR(global_squad_registry)))
		GOAI_LIBBED_GLOB_ATTR(global_squad_registry) = list()

	if(src.registry_index)
		// already done, fix up the registry to be sure and return
		GOAI_LIBBED_GLOB_ATTR(global_squad_registry[src.registry_index]) = src
		return GOAI_LIBBED_GLOB_ATTR(global_squad_registry)

	GOAI_LIBBED_GLOB_ATTR(global_squad_registry) += src
	src.registry_index = GOAI_LIBBED_GLOB_ATTR(global_squad_registry.len)

	return src.registry_index
