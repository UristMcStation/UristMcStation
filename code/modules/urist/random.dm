//stuff that doesn't go anywhere else.

/obj/effect/stop/Uncross(atom/movable/O)
	if(victim == O)
		return 0
	return 1

var/global/respawntime = 6000 //default 10 mins, adding the var so we can change it for different roundtypes. gotta keep the action rollin'

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
	var/empulse = FALSE
	var/severity = EX_ACT_DEVASTATING
	var/ex_range = 9

/obj/effect/urist/spawn_bomb/Initialize()
	.=..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/urist/spawn_bomb/LateInitialize()
	if(empulse)
		empulse(src.loc, 5, 0, 0)

	else
		explosion(src.loc, ex_range, severity, 0)

	qdel(src)

/obj/effect/urist/spawn_bomb/abandoned //we're only doing light damage here, mostly just to break windows and make things look weathered.
	severity = EX_ACT_LIGHT
	ex_range = 8

/obj/effect/urist/spawn_bomb/bluespace_artillery
	ex_range = 14
	severity = EX_ACT_DEVASTATING
