//stuff that doesn't go anywhere else.

/obj/effect/stop/Uncross(atom/movable/O)
	if(victim == O)
		return 0
	return 1

/var/global/respawntime = 6000 //default 10 mins, adding the var so we can change it for different roundtypes. gotta keep the action rollin'

/obj/effect/landmark/costume/monkeysuit/Initialize()
	. = ..()
	new /obj/item/clothing/suit/monkeysuit(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/shuttle_landmark
	var/special = FALSE
	var/spawn_id = null

/obj/effect/shuttle_landmark/proc/on_landing()
	return
