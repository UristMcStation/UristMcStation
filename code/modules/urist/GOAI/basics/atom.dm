/atom
	// attachments for cover & collision stuff
	var/datum/cover/cover_data = null
	var/datum/directional_blocker/directional_blocker = null
	// toggle for lazy autogeneration of cover & collision
	var/cover_gen_enabled = FALSE
	var/blocker_gen_enabled = FALSE

	// A lot of things will either block everything or nothing at all.
	// We don't want to waste proc-calls, so here's a wacky trinary var.
	// 0/null means do a proc call, 1 means block everything, -1 means block nothing.
	var/raycast_block_all = RAYCAST_BLOCK_ALL

	// If block_all is zero, run this dynamic proc instead.
	var/raycast_cover_proc = null

	// a free-form key-value map; intended for associated interfaces/scripts/whatevs
	// eventually might be redone as a big array/SparseSet with implicit IDs, ECS-style
	var/dict/attachments

	// a set of metadata flags that helps GOAI filter out irrelevant stuff
	var/goai_processing_visibility = GOAI_VISTYPE_STANDARD


// todo move this to some area thing
/area
	goai_processing_visibility = GOAI_VISTYPE_ABSTRACT


/atom/movable
	var/managed_movement = FALSE


/atom/proc/GetRaycastCoverage(var/hit_angle = null, var/raytype = null) // -> bool (blocks TRUE/FALSE)
	// For dense atoms, whether they block a raycast, for shooty purposes.
	// Should be roughly equal to how big the object is in the hit direction, e.g:
	//
	// - a solid whole-tile door will block all hits going through its tile
	// - a directional, windoor-style door will block all hits in its facing direction and its opposite,
	//     but block nothing for rays perpendicular to its facing
	// - an upright table will block, say, 33% of hits in any direction (bottom third of range)
	// - a flipped table will block, say, 67% of hits but only in the facing directions
	//
	// ARGUMENTS/INTERFACE:
	// - hit_angle: incoming ray angle; can be converted to direction
	// - raytype: laser/projectile/abstract/whatever; if you want to make the distinction
	//            (e.g. windows let lasers pass through; abstract rays pass through anything non-dense)

	// This proc is mostly just an interface to the underlying dynamic proc call.
	var/safe_block_all = isnull(src.raycast_block_all) ? 0 : src.raycast_block_all

	if(safe_block_all >= RAYCAST_BLOCK_ALL)
		return TRUE

	else if(safe_block_all <= RAYCAST_BLOCK_NONE)
		return FALSE

	return isnull(src.raycast_cover_proc) ? TRUE : call(src, src.raycast_cover_proc)(hit_angle, raytype)



/atom/proc/MeleeHitBy(var/atom/hitby = null)
	/* hit angle - clockwise from positive Y axis if positive,
	counterclockwise if negative.

	Can use the IMPACT_ANGLE(x) macro to calculate.

	shotby - a reference to who shot us (atom - to incl. turret objects etc.)
	*/
	to_world("[src] hit by [hitby]")
	FetchAiControllerForObjIntoVar(src, var/datum/utility_ai/commander)
	if(istype(commander))
		commander.HitMelee(src, hitby)

	return



/atom/proc/RangedHitBy(var/hit_angle, var/atom/shotby = null)
	/* hit angle - clockwise from positive Y axis if positive,
	counterclockwise if negative.

	Can use the IMPACT_ANGLE(x) macro to calculate.

	shotby - a reference to who shot us (atom - to incl. turret objects etc.)
	*/
	to_world("[src] shot by [shotby]")
	FetchAiControllerForObjIntoVar(src, var/datum/utility_ai/commander)
	if(istype(commander))
		commander.HitRanged(src, hit_angle, shotby)

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
