// lazily initialized by the first AI to register itself
GLOBAL_LIST_EMPTY(global_goai_registry)

# define IS_REGISTERED_AI(id) (id && GLOB.global_goai_registry && (id <= GLOB.global_goai_registry.len))

/proc/deregister_ai(var/id, var/delete_ai=TRUE, var/delete_ai_brain=TRUE)
	// Deletes the AI and deregisters it from the global.

	if(!(GLOB.global_goai_registry))
		return

	if(!(IS_REGISTERED_AI(id)))
		return

	var/datum/goai/ai = GLOB.global_goai_registry[id]

	/* We want only valid AIs here; if somehow we get a non-AI here,
	// we want to null it out; regular nulls stay nulls.
	*/

	// Leave a 'hole' in the global list - the indices should NOT be mutable!
	// (the registry is a babby's first SparseSet)
	GLOB.global_goai_registry[id] = null

	if(ai)
		if(delete_ai_brain && ai.brain)
			qdel(ai.brain)
			ai.brain = null

		if(delete_ai)
			qdel(ai)

	return



/datum/goai/proc/RegisterAI()
	// Registry pattern, to facilitate querying all GOAI AIs in verbs

	GLOB?.global_goai_registry += src
	src.registry_index = GLOB?.global_goai_registry.len

	if(!(src.name))
		src.name = src.registry_index

	return GLOB?.global_goai_registry

