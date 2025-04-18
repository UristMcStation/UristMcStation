# define PLANNER_CACHE_SIZE 5

var/global/list/planner_cache = null
var/global/list/planner_owners = null


/proc/GetGoapResource(var/requester_ref)
	if(isnull(GOAI_GLOBAL_LIST_PREFIX(planner_cache)))
		// Lazy-init of cache lists
		var/new_cache_list[PLANNER_CACHE_SIZE]
		var/new_owner_list[PLANNER_CACHE_SIZE]
		GOAI_GLOBAL_LIST_PREFIX(planner_cache) = new_cache_list
		GOAI_GLOBAL_LIST_PREFIX(planner_owners) = new_owner_list

	var/datum/GOAP/demoGoap/planner = null
	var/free_idx = null
	var/curr_idx = 1

	for(var/owner_ref in GOAI_GLOBAL_LIST_PREFIX(planner_owners))
		// find the first currently unowned item
		if(isnull(owner_ref))
			free_idx = curr_idx
			break

		curr_idx++

	if(free_idx)
		GOAI_GLOBAL_LIST_PREFIX(planner_owners)[free_idx] = requester_ref  // take ownership

		// fetch the planner from the other list...
		planner = GOAI_GLOBAL_LIST_PREFIX(planner_cache)[free_idx]
		if(isnull(planner))
			// ...or create if uninitialized
			planner = new(null)

		// this should already match, but let's set it to be safe
		planner.cache_id = free_idx

	return planner


/proc/FreeGoapResource(var/datum/GOAP/freed_goap, var/owner_ref)
	ASSERT(!isnull(freed_goap))
	ASSERT(!isnull(GOAI_GLOBAL_LIST_PREFIX(planner_cache)))

	var/cache_id = freed_goap.cache_id

	ASSERT(cache_id <= GOAI_GLOBAL_LIST_PREFIX(planner_cache.len))
	ASSERT(cache_id <= GOAI_GLOBAL_LIST_PREFIX(planner_owners.len))
	ASSERT(owner_ref == GOAI_GLOBAL_LIST_PREFIX(planner_owners)[cache_id])

	GOAI_GLOBAL_LIST_PREFIX(planner_owners)[cache_id] = null // remove ownership
	GOAI_GLOBAL_LIST_PREFIX(planner_cache)[cache_id] = freed_goap // again, to be safe
	return
