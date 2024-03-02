/*
// REMINDER: GOAI Brains != organ brains.
// GOAI Brains are abstract datums and are effectively a data structure.
// Since they have their own subloop, we want to be able to clean them up
// so we don't have orphan Brains running empty loops.
*/

// lazily initialized by the first brain to register itself

# ifdef GOAI_LIBRARY_FEATURES
var/global/list/global_aibrain_registry
# endif
# ifdef GOAI_SS13_SUPPORT
GLOBAL_LIST_EMPTY(global_aibrain_registry)
# endif

# define IS_REGISTERED_AIBRAIN(id) (id && GOAI_LIBBED_GLOB_ATTR(global_aibrain_registry) && (id <= GOAI_LIBBED_GLOB_ATTR(global_aibrain_registry.len)))

/proc/deregister_ai_brain(var/id)
	// Deletes the AI Brain and deregisters it from the global.

	if(!(GOAI_LIBBED_GLOB_ATTR(global_aibrain_registry)))
		return

	if(!(IS_REGISTERED_AI(id)))
		return

	var/datum/brain/aibrain = GOAI_LIBBED_GLOB_ATTR(global_aibrain_registry[id])

	/* We want only valid AIs here; if somehow we get a non-AI here,
	// we want to null it out; regular nulls stay nulls.
	*/

	// Leave a 'hole' in the global list - the indices should NOT be mutable!
	// (the registry is a babby's first SparseSet)
	GOAI_LIBBED_GLOB_ATTR(global_aibrain_registry[id]) = null

	if(aibrain)
		qdel(aibrain)

	return


/datum/brain/proc/RegisterBrain()
	// Registry pattern, to facilitate querying all GOAI Brains in verbs

	if(!(GOAI_LIBBED_GLOB_ATTR(global_aibrain_registry)))
		GOAI_LIBBED_GLOB_ATTR(global_aibrain_registry) = list()

	if(src.registry_index)
		// already done, fix up the registry to be sure and return
		GOAI_LIBBED_GLOB_ATTR(global_aibrain_registry[src.registry_index]) = src
		return GOAI_LIBBED_GLOB_ATTR(global_aibrain_registry)

	GOAI_LIBBED_GLOB_ATTR(global_aibrain_registry) += src
	src.registry_index = GOAI_LIBBED_GLOB_ATTR(global_aibrain_registry.len)

	if(!(src.name))
		src.name = src.registry_index

	return GOAI_LIBBED_GLOB_ATTR(global_aibrain_registry)
