/atom
	// attachments for cover & collision stuff
	var/datum/cover/cover_data = null
	var/datum/directional_blocker/directional_blocker = null
	// toggle for lazy autogeneration of cover & collision
	var/cover_gen_enabled = FALSE
	var/blocker_gen_enabled = FALSE

	// a free-form key-value map; intended for associated interfaces/scripts/whatevs
	// eventually might be redone as a big array/SparseSet with implicit IDs, ECS-style
	var/dict/attachments


/atom/proc/Hit(var/hit_angle, var/atom/shotby = null)
	/* hit angle - clockwise from positive Y axis if positive,
	counterclockwise if negative.

	Can use the IMPACT_ANGLE(x) macro to calculate.

	shotby - a reference to who shot us (atom - to incl. turret objects etc.)
	*/

	// TODO: PORT TO UTILITY
	FetchAiControllerForObjIntoVar(src, var/datum/utility_ai/mob_commander/commander)
	if(commander)
		commander.Hit(hit_angle, shotby)


	return


/atom/proc/CurrentPositionAsTuple()
	var/datum/Tuple/pos_tuple = new(src.x, src.y)
	return pos_tuple


/atom/proc/CurrentPositionAsTriple()
	var/datum/Triple/pos_triple = new(src.x, src.y, src.z)
	return pos_triple


# ifdef GOAI_LIBRARY_FEATURES
/atom/Enter(var/atom/movable/O, var/atom/oldloc)
	. = ..()

	var/turf/oldloc_turf = oldloc
	var/turf/newloc_turf = src

	if(istype(oldloc_turf) && istype(newloc_turf))
		var/link_is_blocked = GoaiLinkBlocked(oldloc_turf, newloc_turf)

		if(link_is_blocked)
			return FALSE

	return .
# endif
