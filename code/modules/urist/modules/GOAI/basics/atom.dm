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
	var/commander_backref = src.attachments?.Get(ATTACHMENT_CONTROLLER_BACKREF)

	if(IS_REGISTERED_AI(commander_backref))
		var/datum/goai/mob_commander/commander = GLOB?.global_goai_registry[commander_backref]
		if(commander)
			commander.Hit(hit_angle, shotby)

	return


/atom/proc/CurrentPositionAsTuple()
	var/datum/Tuple/pos_tuple = new(src.x, src.y)
	return pos_tuple


/atom/proc/CurrentPositionAsTriple()
	var/datum/Triple/pos_triple = new(src.x, src.y, src.z)
	return pos_triple
