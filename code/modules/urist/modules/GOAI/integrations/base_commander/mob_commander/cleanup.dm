// cleanup procs; handle 'orphan' AIs
/datum/goai/mob_commander
	/* NOTE: this is an 'extension' of the mob_commander class from core.dm! */

	// If positive, number of AI ticks before we deregister & delete ourselves.
	var/cleanup_detached_threshold = DEFAULT_ORPHAN_CLEANUP_THRESHOLD

	// Tracker for the cleanup
	var/_ticks_since_detached = 0


/datum/goai/mob_commander/ShouldCleanup()
	. = ..()

	if(.)
		return .

	if(src.cleanup_detached_threshold < 0)
		return FALSE

	if(src._ticks_since_detached > src.cleanup_detached_threshold)
		return TRUE

	return .


/datum/goai/mob_commander/CheckForCleanup()
	var/atom/movable/mypawn = src.GetPawn()

	. = ..()

	if(.)
		return .

	var/should_clean = src.ShouldCleanup()
	if(should_clean)
		src.CleanDelete()
		qdel(src)
		return TRUE

	if(mypawn && istype(mypawn))
		var/mob/living/L = mypawn

		if(L && istype(L))
			// Check for death/deletion
			if(isnull(L.stat) || L.stat == DEAD)
				src._ticks_since_detached++

			else
				src._ticks_since_detached = 0

		else
			src._ticks_since_detached = 0

	else
		src._ticks_since_detached++

	return
