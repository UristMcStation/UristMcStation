//maze shit

/obj/structure/maze/maze_falsewall
	name = "wall"
	anchored = TRUE
	icon = 'icons/urist/structures&machinery/structures.dmi'
	icon_state = "riveted"
	opacity = 1
	density = TRUE
	var/opening = 0

/obj/structure/maze/maze_falsewall/attack_hand(mob/user as mob)
	if(opening)
		return

	if(density)
		opening = 1
		to_chat(user, "<span class='notice'>You slide the heavy wall open.</span>")
		flick("riveted_opening", src)
		sleep(5)
		density = FALSE
		opacity = 0
		icon_state = "riveted_open"

/obj/structure/maze/diamond
	name = "diamond"
	icon_state = "sheet-diamond"
	icon = 'icons/obj/items.dmi'
	anchored = TRUE
	density = TRUE

	var/teleport_x = 0	// teleportation coordinates (if one is null, then no teleport!)
	var/teleport_y = 0
//	var/teleport_z = 0

/obj/structure/maze/diamond/attack_hand(mob/user as mob)

	to_chat(user, "<span class='notice'>[src] disappears and you feel yourself getting sucked away!</span>")

	if(teleport_x && teleport_y) // && teleport_z)

		user.x = teleport_x
		user.y = teleport_y
//		user.z = teleport_z

	var/obj/effect/gateway/G1 = new /obj/effect/gateway(get_step(src, EAST))
	var/obj/effect/gateway/G2 = new /obj/effect/gateway(get_step(src, WEST))
	var/obj/effect/gateway/G3 = new /obj/effect/gateway(src.loc)

	G1.density = FALSE
	G2.density = FALSE
	G3.density = FALSE

	var/obj/effect/step_trigger/teleporter/urist/T1 = new /obj/effect/step_trigger/teleporter/urist(get_step(src, EAST))
	var/obj/effect/step_trigger/teleporter/urist/T2 = new /obj/effect/step_trigger/teleporter/urist(get_step(src, WEST))
	var/obj/effect/step_trigger/teleporter/urist/T3 = new /obj/effect/step_trigger/teleporter/urist(src.loc)

	T1.teleport_x = teleport_x
	T1.teleport_y = teleport_y
//	T1.teleport_z = teleport_z

	T2.teleport_x = teleport_x
	T2.teleport_y = teleport_y
//	T2.teleport_z = teleport_z

	T3.teleport_x = teleport_x
	T3.teleport_y = teleport_y
//	T3.teleport_z = teleport_z

	qdel(src)
	return

/obj/item/clothing/head/urist/director
	name = "Director's Helmet"
	desc = "The helmet of the legendary Director."
	icon_state = "director"
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 100) //same as ert helm

/obj/item/clothing/suit/space/director
	name = "Director's Hardsuit"
	desc = "The hardsuit of the legendary Director."
	item_icons = DEF_URIST_INHANDS
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_override = 'icons/uristmob/clothes.dmi'
	icon_state = "director"
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 100) //same as an ert rig
	can_breach = 0

/obj/structure/maze/director
	name = "The Director"
	desc = "It's the madman who runs this deathtrap!"
	icon_state = "director"
	icon = 'icons/urist/structures&machinery/structures.dmi'
	anchored = TRUE
	density = TRUE

/obj/structure/maze/director/attack_hand(mob/user as mob)

	to_chat(user, "<span class='notice'>The Director collapses to the ground, armour tumbling on the floor. As the dust settles, you think you hear a faint voice whisper 'thank you...'</span>")
	new /obj/item/clothing/suit/space/director(src.loc)
	new /obj/item/clothing/head/urist/director(src.loc)
	qdel(src)
	return

/obj/structure/maze/fakegateway
	name = "gateway"
	desc = "A mysterious gateway built by unknown hands, it allows for faster than light travel to far-flung locations."
	icon = 'icons/obj/machines/gateway.dmi'
	icon_state = "off"
	density = TRUE
	anchored = TRUE

/obj/effect/step_trigger/teleporter/urist/New()
	if(!teleport_z)
		teleport_z = src.z
	if(!teleport_y)
		teleport_y = src.y
	if(!teleport_x)
		teleport_x = src.x

	..()
