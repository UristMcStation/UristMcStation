/proc/merge_lists(var/list/first, var/list/second)
	var/list/output = first + second
	return output


/datum/memory
	var/val

	var/created_time = 0
	var/updated_time = 0
	var/ttl = PLUS_INF


/datum/memory/New(var/new_val, var/new_ttl = null)
	val = new_val
	ttl = (isnull(new_ttl) ? ttl : new_ttl)

	var/right_now = world.time
	created_time = right_now
	updated_time = right_now


/datum/memory/proc/GetAge()
	/* Retrieves the age of the memory in ds since creation-time */
	var/right_now = world.time
	var/deltaT = right_now - created_time
	return deltaT


/datum/memory/proc/GetFreshness()
	/* Like GetAge(), except considers Last Update-time, not Creation-time. */
	var/right_now = world.time
	var/deltaT = right_now - updated_time
	return deltaT


/datum/memory/proc/Update(var/new_val)
	var/right_now = world.time
	val = new_val
	updated_time = right_now
	return src


/datum/memory/proc/UpdateWith(var/callable, var/new_val = null)
	// Updates the current value, using a callable func(curr_val, new_val)
	// provided as the first arg, where new_val is the optional second arg.
	var/updated_val = null
	updated_val = (callable ? call(callable)(val, new_val) : new_val)

	Update(updated_val)
	return src


/datum/memory/proc/ConvertToArraymem()
	// Converts a simple memory Mem<val=Val> to a Mem<val=list[Mem<val=Val>]> memory
	var/datum/memory/submemory = new(src.val, src.ttl)
	submemory.created_time = src.created_time

	var/list/memory_block = list()
	memory_block.Add(submemory)

	src.val = memory_block

	return src



/datum/memory/proc/MergeAsLists(var/list/new_submems, var/autoconvert = FALSE)
	/* Merges the current memory and a target list of new memories.
	// If the current memory is an array-mem, extends the underlying list.
	// If not,
	//
	// src.val and new_submems are assumed to be positional lists of memories
	// second argument controls whether we are allowed to mutate the current memory
	// into an array-memory as a side-effect (default: FALSE).
	*/
	var/list/curr_submems = val

	if(isnull(curr_submems))
		if(autoconvert)
			curr_submems = src.ConvertToArraymem()?.val
		else
			CRASH("MergeAsLists: Memory [src] is not an arraymem and autoconvert is not enabled to fix it.")

	if(istype(curr_submems) && istype(new_submems))
		. = UpdateWith(new_submems, /proc/merge_lists)

	return src
