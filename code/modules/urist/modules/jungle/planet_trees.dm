// Planetary Trees

/obj/structure/flora/tree/planet
	name = "tree"
	desc = "I shouldn't exist, report me as a bug or tell an admin!"

// Jungle Planet

/obj/structure/flora/tree/planet/jungle/large
	name = "jungle tree"
	desc = "An incredibly large tree that is commonly found growing in jungles."
	icon = 'icons/urist/obj/flora/jungletrees_tall.dmi'
	icon_state = "jungle"
	shake_animation_degrees = 3
	product = MATERIAL_WOOD // replace this with logs if we wanna do that again.
	health_max = 250

/obj/structure/flora/tree/planet/jungle/large/Initialize()
	. = ..()
	var/state = rand(3)
	if (state)
		icon_state = "[initial(icon_state)]_[state]"

/obj/structure/flora/tree/planet/jungle/small
	name = "jungle tree"
	desc = "A large tree commonly found growing in jungles."
	icon = 'icons/urist/obj/flora/jungletrees_small.dmi'
	icon_state = "jungle"
	shake_animation_degrees = 4

/obj/structure/flora/tree/planet/jungle/small/Initialize()
	. = ..()
	var/state = rand(9)
	if (state)
		icon_state = "[initial(icon_state)]_[state]"

/obj/structure/flora/tree/planet/jungle/oldtree
	name = "old tree"
	desc = "A old sparse tree, hundreds of years old."
	icon = 'icons/urist/obj/flora/jungletrees_small.dmi'
	product = MATERIAL_WOOD
	health_max = 250

/obj/structure/flora/tree/planet/jungle/oldtree/Initialize()
	. = ..()
	icon_state = "oldtree"



// Snowy Planet

/obj/structure/flora/tree/planet/temperate
	name = "pine tree"
	desc = "A pine tree. Commonly used for combustion and construction."
	icon = 'icons/urist/obj/flora/snowytrees_tall.dmi'
	icon_state = "pine"
	shake_animation_degrees = 4
	product = MATERIAL_WOOD // replace this with logs if we wanna do that again.

/obj/structure/flora/tree/planet/temperate/Initialize()
	. = ..()
	var/state = rand(2)
	if (state)
		icon_state = "[initial(icon_state)]_[state]"



// Arid Planet

/obj/structure/flora/tree/planet/arid/small
	name = "dead tree"
	desc = "It's a dead tree. Useful for combustion and/or construction."
	icon = 'icons/urist/obj/flora/aridtrees_small.dmi'
	icon_state = "arid"
	shake_animation_degrees = 5
	product = MATERIAL_WOOD // replace this with logs if we wanna do that again.
	health_max = 150

/obj/structure/flora/tree/planet/arid/small/Initialize()
	. = ..()
	var/state = rand(5)
	if (state)
		icon_state = "[initial(icon_state)]_[state]"

/obj/structure/flora/tree/planet/arid/large
	name = "large dead tree"
	desc = "It's a large dead tree. Useful for combustion and/or construction."
	icon = 'icons/urist/obj/flora/aridtrees_tall.dmi'
	icon_state = "arid"
	shake_animation_degrees = 3
	product = MATERIAL_WOOD // replace this with logs if we wanna do that again.

/obj/structure/flora/tree/planet/arid/large/Initialize()
	. = ..()
	var/state = rand(2)
	if (state)
		icon_state = "[initial(icon_state)]_[state]"

/obj/structure/flora/tree/planet/arid/cacti
	name = "cacti"
	desc = "A common species of cactus, known for being a bit of a prick."
	icon = 'icons/urist/obj/flora/aridtrees_small.dmi'
	icon_state = "cactus"
	shake_animation_degrees = 3
	health_max = 125

/obj/structure/flora/tree/planet/arid/cacti/Initialize()
	. = ..()
	var/state = rand(1)
	if (state)
		icon_state = "[initial(icon_state)]_[state]"


// Logs

/obj/structure/log
	icon = 'icons/urist/items/wood.dmi'
	icon_state = "log"
	density = TRUE
	anchored = FALSE

/obj/structure/log/use_tool(obj/item/I, mob/living/user, list/click_params)
	if(istype(I, /obj/item/carpentry/saw))
		to_chat(user, "<span class='notice'>You saw the [src] with [I].</span>")

		if(do_after(user, 20))
			var/obj/item/stack/material/r_wood/W = new /obj/item/stack/material/r_wood(src.loc)
			W.pixel_y = src.pixel_y
			W.amount = rand(3,6) //going to mess with this value for a while, we'll see
			qdel_self()
			return TRUE

	return ..()



/*
old legacy jungle code starts here
//treeeeeeeeees

/obj/structure/flora/tree/planet
	name = "tree"
	desc = "It's a generic tree, fuck off."
	var/chops = 0 //how many times it's been chopped. Gotta make them work for it!
	var/size = 0

/obj/structure/flora/tree/planet/use_tool(obj/item/I, mob/living/user, list/click_params)
	if(istype(I, /obj/item/carpentry/axe) || istype(I, /obj/item/material/twohanded/fireaxe))
		to_chat(user, "<span class='notice'>You chop [src] with [I].</span>")

		playsound(src.loc, 'sound/urist/chopchop.ogg', 100, 1)

		sleep(5)


		chops += 1

		if(chops == 4 && size == 1)
			to_chat(user, "<span class='notice'>[src] comes crashing down!</span>")
			playsound(src.loc, 'sound/urist/treefalling.ogg', 100, 1)
			new /obj/structure/log(src.loc)

			qdel(src)

		else if(chops == 8)
			to_chat(user, "<span class='notice'>[src] comes crashing down!</span>")

			sleep(5)

			playsound(src.loc, 'sound/urist/treefalling.ogg', 100, 1)

			if(size == 2)

				new /obj/structure/log(get_step(src, NORTH))
				new /obj/structure/log(src.loc)

			if(size == 3)

				new /obj/structure/log(get_step(src, NORTH))
				new /obj/structure/log(src.loc)
				var/obj/structure/log/L = new /obj/structure/log(get_step(src, NORTH))

				L.y += 1

			qdel(src)

	return


//jungle

//dead arid tree

/obj/structure/flora/tree/planet/arid/small
	name = "dead tree"
	desc = "It's a tree. Useful for combustion and/or construction."
	icon = 'icons/urist/jungle/trees64x64.dmi'
	icon_state = "deadtree_1"
	size = 1

/obj/structure/flora/tree/planet/arid/small/New()
	icon_state = "deadtree_[rand(1,6)]"
	..()

/obj/structure/flora/tree/planet/arid/large
	name = "large dead tree"
	desc = "It's a large tree. Useful for combustion and/or construction."
	icon = 'icons/urist/jungle/trees64x128.dmi'
	icon_state = "tree_1"
	size = 2

/obj/structure/flora/tree/planet/arid/large/New()
	icon_state = "tree_[rand(1,3)]"
	..()
*/
