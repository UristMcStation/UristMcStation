//treeeeeeeeees
//jungle

/obj/structure/flora/tree/jungle
	name = "jungle tree"
	desc = "A large tree commonly found in jungle areas."
	icon = 'icons/urist/obj/flora/jungletrees_small.dmi'
	icon_state = "tree"

/obj/structure/flora/tree/jungle/Initialize()
	. = ..()
	var/state = rand(9)
	if (state)
		icon_state = "[initial(icon_state)]_[rand(9)]"

/obj/structure/flora/tree/jungle/large
	desc = "An extremely large tree commonly found in jungle areas."
	name = "large jungle tree"
	icon = 'icons/urist/obj/flora/jungletrees_tall.dmi'
	icon_state = "tree"
	pixel_x = -32

/obj/structure/flora/tree/jungle/large/Initialize()
	. = ..()
	var/state = rand(3)
	if (state)
		icon_state = "[initial(icon_state)]_[state]"

/obj/structure/flora/tree/jungle/oldtree
	name = "old tree"
	desc = "A old sparse tree, hundreds of years old."
	icon = 'icons/urist/obj/flora/jungletrees_small.dmi'
	health_max = 250

/obj/structure/flora/tree/jungle/oldtree/Initialize()
	. = ..()
	icon_state = "oldtree"

//logs

/obj/structure/log
	icon = 'icons/urist/items/wood.dmi'
	icon_state = "log"
	density = TRUE
	anchored = FALSE
	var/material/product = MATERIAL_WOOD

/obj/structure/log/use_tool(obj/item/I, mob/living/user, list/click_params)
	if(isHatchet(I))
		to_chat(user, SPAN_NOTICE("You begin carefully dividing the [src] into planks with [I]."))

		if(do_after(user, 20))

			product.place_sheet(get_turf(src), rand(3,6))

			qdel_self()
			return TRUE

	return ..()

//dead arid tree

/obj/structure/flora/tree/arid
	name = "dead tree"
	desc = "It's a tree. Useful for combustion and/or construction."
	icon = 'icons/urist/obj/flora/aridtrees_small.dmi'
	icon_state = "deadtree"

/obj/structure/flora/tree/arid/Initialize()
	. = ..()
	var/state = rand(5)
	if (state)
		icon_state = "[initial(icon_state)]_[state]"

/obj/structure/flora/tree/arid/large
	name = "large dead tree"
	desc = "It's a large tree. Useful for combustion and/or construction."
	icon = 'icons/urist/obj/flora/aridtrees_tall.dmi'
	icon_state = "tree"

/obj/structure/flora/tree/arid/large/Initialize()
	. = ..()
	var/state = rand(2)
	if (state)
		icon_state = "[initial(icon_state)]_[state]"

/obj/structure/flora/tree/arid/cactus
	name = "cactus"
	desc = "A common species of cacti, known for being a bit of a prick."
	icon = 'icons/urist/obj/flora/aridtrees_small.dmi'
	icon_state = "cactus"
	shake_animation_degrees = 3
	health_max = 125

/obj/structure/flora/tree/arid/cactus/Initialize()
	. = ..()
	var/state = rand(1)
	if (state)
		icon_state = "[initial(icon_state)]_[state]"

//pinetrees

/obj/structure/flora/tree/temperate
	name = "pine tree"
	desc = "It's a tree. Useful for combustion and/or construction."
	icon = 'icons/urist/obj/flora/pinetrees.dmi'
	icon_state = "temperate_pine"

/obj/structure/flora/tree/temperate/Initialize()
	. = ..()
	var/state = rand(2)
	if (state)
		icon_state = "[initial(icon_state)]_[state]"
