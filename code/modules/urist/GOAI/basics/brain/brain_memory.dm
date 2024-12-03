#define BRAIN_MODULE_INCLUDED_MEMORY 1

/datum/brain
	/* Memory container; key-value map.
	//
	// Memories are effectively GOAI's Blackboard System:
	// the forum for different AI subsystems (e.g. actions,
	// senses, etc.) to query and post relevant information to.
	//
	// Memories can be _volatile_ - i.e. expire after a set Time-To-Live (TTL).
	//
	// Memories' keys are strings and the values are Memory instances.
	// A Memory is a TTL wrapper around an arbitrary-typed value.
	// The stored value can be accessed using the `.val` attribute.
	*/
	var/dict/memories


/datum/brain/proc/HasMemory(var/mem_key)
	var/found = (mem_key in memories.data)
	return found


/datum/brain/proc/GetMemory(var/mem_key, var/default = null, var/by_age = FALSE, var/check_hivemind = FALSE, var/recursive = FALSE, var/prefer_hivemind = FALSE)
	var/datum/memory/retrieved_mem = null
	var/datum/memory/hivemind_mem = null

	if(check_hivemind && hivemind && hivemind.memories && hivemind.HasMemory(mem_key))
		// The last two args are (..., recursive, recursive) ON PURPOSE!
		// IFF recursive is TRUE, the parent mind should check for grandparents and so on.
		// Root can have check_hivemind = TRUE and recursive = FALSE to only recurse 1-lvl deep.
		hivemind_mem = hivemind.GetMemory(mem_key, null, by_age, recursive, recursive)

		if(istype(hivemind_mem) && prefer_hivemind)
			// If prefer_hivemind is TRUE, we don't need to bother with mob memories
			// once we have found a hivemind memory.
			return hivemind_mem

	if(HasMemory(mem_key))
		retrieved_mem = memories.Get(mem_key, null)

		if(isnull(retrieved_mem))

			if(isnull(hivemind_mem))
				return default

			// if root has no memory, but the *parent* does - return parent's
			return hivemind_mem

		var/relevant_age = by_age ? retrieved_mem.GetAge() : retrieved_mem.GetFreshness()

		if(relevant_age < retrieved_mem.ttl)
			// We already checked for parent preference - no need to redo that.
			return retrieved_mem

		memories[mem_key] = null

	return (isnull(hivemind_mem) ? default : hivemind_mem)


/datum/brain/proc/GetMemoryValue(var/mem_key, var/default = null, var/by_age = FALSE, var/check_hivemind = FALSE, var/recursive = FALSE, var/prefer_hivemind = FALSE)
	// Like GetMemory, but resolves the Memory object to the stored value.
	// This is a bit lossy, but 99% of the time that's all you care about.
	var/datum/memory/retrieved_mem = src.GetMemory(mem_key, null, by_age, check_hivemind, recursive, prefer_hivemind)
	var/memory_value = retrieved_mem?.val
	return (isnull(memory_value) ? default : memory_value)


/datum/brain/proc/SetMemory(var/mem_key, var/mem_val, var/mem_ttl)
	var/datum/memory/retrieved_mem = memories.Get(mem_key)

	if(isnull(retrieved_mem))
		retrieved_mem = new(mem_val, mem_ttl)
		memories.Set(mem_key, retrieved_mem)

	else
		retrieved_mem.Update(mem_val, mem_ttl)

	return retrieved_mem


/datum/brain/proc/DropMemory(var/mem_key)
	memories.Set(mem_key, null)
	return
