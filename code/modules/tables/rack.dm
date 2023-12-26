/obj/structure/table/rack
	name = "rack"
	desc = "Different from the Middle Ages version."
	icon = 'icons/obj/objects.dmi'
	icon_state = "rack"
	can_plate = 0
	can_reinforce = 0
	flipped = -1

/obj/structure/table/rack/New()
	..()
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put

/obj/structure/table/rack/Initialize()
	auto_align()
	. = ..()
	if(painted_color)
		color = painted_color

/obj/structure/table/rack/update_connections()
	return

/obj/structure/table/rack/update_desc()
	return

/obj/structure/table/rack/on_update_icon()
	return

/obj/structure/table/rack/can_connect()
	return FALSE

/obj/structure/table/rack/holorack/dismantle(obj/item/wrench/W, mob/user)
	to_chat(user, SPAN_WARNING("You cannot dismantle \the [src]."))
	return

/obj/structure/table/rack/dark
	color = COLOR_GRAY40
	painted_color = COLOR_GRAY40

/obj/structure/table/rack/steel
	color = COLOR_STEEL
	painted_color = COLOR_STEEL
	material = MATERIAL_STEEL
