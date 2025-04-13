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

/obj/structure/flora/tree/planet/jungle/large
	desc = "An extremely large tree commonly found in jungle areas."
	name = "large jungle tree"
	icon = 'icons/urist/jungle/trees-large.dmi'
	icon_state = "tree1"
	pixel_x = -32
	size = 3

/obj/structure/flora/tree/planet/jungle/large/New()
	icon_state = "tree[rand(1,4)]"
	..()

/obj/structure/flora/tree/planet/jungle/small
	name = "jungle tree"
	desc = "A large tree commonly found in jungle areas."
	icon = 'icons/urist/jungle/trees-small.dmi'
	icon_state = "tree1"
	size = 1

/obj/structure/flora/tree/planet/jungle/small/New()
	icon_state = "tree[rand(1,10)]"
	..()

//logs

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

			qdel(src)

	return

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


//pinetrees

/obj/structure/flora/tree/planet/temperate
	name = "pine tree"
	desc = "It's a tree. Useful for combustion and/or construction."
	icon = 'icons/urist/obj/pinetrees.dmi'
	icon_state = "pine_4"
	size = 1

/obj/structure/flora/tree/planet/temperate/New()
	icon_state = "pine_[rand(4,6)]"
	..()

/obj/structure/flora/tree/planet/snowy
	name = "pine tree"
	desc = "It's a tree. Useful for combustion and/or construction."
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"
	size = 1

/obj/structure/flora/tree/planet/snowy/New()
	icon_state = "pine_[rand(1,3)]"
	..()
