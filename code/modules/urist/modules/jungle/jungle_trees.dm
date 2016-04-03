//treeeeeeeeees

/obj/structure/flora/tree/jungle
	name = "jungle tree"
	desc = "A large tree commonly found in jungle areas."
	var/chops = 0 //how many times it's been chopped. Gotta make them work for it!
	var/small = 0

/obj/structure/flora/tree/jungle/large
	desc = "An extremely large tree commonly found in jungle areas."
	name = "large jungle tree"
	icon = 'icons/urist/jungle/trees-large.dmi'
	icon_state = "tree1"
	pixel_x = -32

/obj/structure/flora/tree/jungle/large/New()
	icon_state = "tree[rand(1,4)]"

/obj/structure/flora/tree/jungle/small
	icon = 'icons/urist/jungle/trees-small.dmi'
	icon_state = "tree1"
	small = 1

/obj/structure/flora/tree/jungle/small/New()
	icon_state = "tree[rand(1,10)]"

/obj/structure/flora/tree/jungle/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/weapon/carpentry/axe))
		user << "<span class='notice'>You chop [src] with [I].</span>"

		playsound(src.loc, 'sound/urist/chopchop.ogg', 100, 1)

		sleep(5)


		chops += 1

		if(chops == 4 && small)
			user << "<span class='notice'>[src] comes crashing down!</span>"
			playsound(src.loc, 'sound/urist/treefalling.ogg', 100, 1)
			new /obj/structure/log(src.loc)

			qdel(src)

		else if(chops == 8)
			user << "<span class='notice'>[src] comes crashing down!</span>"

			sleep(5)

			playsound(src.loc, 'sound/urist/treefalling.ogg', 100, 1)

			new /obj/structure/log(get_step(src, NORTH))
			new /obj/structure/log(src.loc)
			var/obj/structure/log/L = new /obj/structure/log(get_step(src, NORTH))

			L.y += 1

			qdel(src)

	return

/obj/structure/log
	icon = 'icons/urist/items/wood.dmi'
	icon_state = "log"
	density = 1
	anchored = 0

/obj/structure/log/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/weapon/carpentry/saw))
		user << "<span class='notice'>You saw the [src] with [I].</span>"

		if(do_after(user, 20))

			var/obj/item/stack/material/wood/r_wood/W = new /obj/item/stack/material/wood/r_wood(src.loc)

			W.pixel_y = src.pixel_y
			W.amount = rand(2,5) //going to mess with this value for a while, we'll see

			qdel(src)

	return