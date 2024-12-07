/* Senses for fetching ActionSets from Smart Objects.
//
// We want AIs to be able to pick up Actions from contextual affordances rather than hardcoding them.
//
// While we can have a Consideration to stop AI from opening a door that is not adjacent, this still
// eats a bunch of RAM and CPU for no reason even if there are no doors within miles.
//
// Preferably, being next to a door would advertise a door-opening Action,
// which we would score according to the Agent's preferences.
//
// Unfortunately, SS13 is extremely interactable-dense and dynamic, so there's no realistic way of precomputing
// all available objects, even if we did some sort of clever chunking/LODing - it would still be a monstrously large list.
//
// But hey, we have Memories - a nice TTL cache - and Senses, which are already doing spatial queries periodically for relatively cheap.
// The obvious solution is - have our 'eyes' spot objects of interest and log 'em into our Memories, then use our Memories to fetch SmartObjects!
//
//
*/

/sense/utility_smartobject_fetcher
	var/sense_idx_key = null
	var/in_memory_key = SENSE_SIGHT_CURR
	var/out_memory_key = "SmartObjects"
	var/retention_time_dseconds = null


/sense/utility_smartobject_fetcher/New(var/sense_idx_key, var/enabled = TRUE, var/in_memory_key = null, var/out_memory_key = null, var/retention_time_dseconds = null)
	// As of writing, Senses have no shared New(); this one is intended for SerDe and dynamic creation convenience.
	// If Senses ever get a high-level New(), this will need to be rewritten somehow.
	SET_IF_NOT_NULL(sense_idx_key, src.sense_idx_key)
	SET_IF_NOT_NULL(enabled, src.enabled)
	SET_IF_NOT_NULL(in_memory_key, src.in_memory_key)
	SET_IF_NOT_NULL(out_memory_key, src.out_memory_key)
	SET_IF_NOT_NULL(retention_time_dseconds, src.retention_time_dseconds)

	ASSERT(!isnull(src.sense_idx_key))


/sense/utility_smartobject_fetcher/proc/FetchSmartObjects(var/datum/utility_ai/mob_commander/owner, var/input_memory_key = null, var/output_memory_key = null)
	ASSERT(!isnull(owner))

	var/in_mem_key = DEFAULT_IF_NULL(input_memory_key, src.in_memory_key)
	ASSERT(!isnull(in_mem_key))

	var/out_mem_key = DEFAULT_IF_NULL(output_memory_key, src.out_memory_key)
	ASSERT(!isnull(out_mem_key))

	var/datum/brain/owner_brain = owner.brain

	if(isnull(owner_brain))
		// No point processing this if there's no memories to set
		return

	var/list/candidates = owner_brain?.perceptions[in_mem_key]
	var/list/smartobjects = list()

	for(var/datum/cand in candidates)
		var/has_actions = cand.HasUtilityActions(owner.GetPawn())

		if(!has_actions)
			//GOAI_LOG_DEBUG("[cand] has no actions ([has_actions])")
			continue

		smartobjects.Add(cand)

	if(smartobjects?.len)
		var/retention_time = (src.retention_time_dseconds || owner.ai_tick_delay)
		owner_brain.SetMemory(out_mem_key, smartobjects, retention_time)

	return smartobjects


/sense/utility_smartobject_fetcher/ProcessTick(var/owner)
	..(owner)

	if(processing)
		return

	processing = TRUE

	src.FetchSmartObjects(owner)

	spawn(src.GetOwnerAiTickrate(owner) * 3)
		// Sense-side delay
		processing = FALSE

	return
