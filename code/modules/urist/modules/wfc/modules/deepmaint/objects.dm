
/obj/deepmaint_light
	icon = 'icons/obj/structures/lighting.dmi'
	icon_state = "floor1"
	layer = BELOW_OBJ_LAYER
	anchored = TRUE


/obj/deepmaint_light/New(atom/loc)
	. = ..(loc)
	set_light(0.2, 1, 3, l_color = LIGHT_COLOUR_E_RED)
