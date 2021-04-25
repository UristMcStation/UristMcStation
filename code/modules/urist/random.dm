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

/obj/effect/urist/spawn_bomb
	icon = 'icons/mob/screen1.dmi'
	icon_state = "grabbed1"
	invisibility = 101
	var/dmg_dev = 1
	var/dmg_hvy = 2
	var/dmg_lgt = 5

/obj/effect/urist/spawn_bomb/Initialize()
	.=..()
	explosion(src.loc, dmg_dev, dmg_hvy, dmg_lgt, 1)
	qdel(src)

/obj/effect/urist/spawn_bomb/abandoned //we're only doing light damage here, most just to break windows and make things look weathered.
	dmg_dev = 0
	dmg_hvy = 0
	dmg_lgt = 8