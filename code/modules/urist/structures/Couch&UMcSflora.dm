/obj/structure/bed/chair/couch
	name = "couch"
	desc = "A couch. Looks pretty comfortable."
	icon = 'icons/urist/structures&machinery/Nienplants&Couch.dmi'
	icon_state = "chair"
	color = rgb(255,255,255)
	var/image/armrest = null
	var/couchpart = 0 //0 = middle, 1 = left, 2 = right

/obj/structure/bed/chair/couch/update_icon()
	return

/obj/structure/bed/chair/couch/New(var/newloc,var/newmaterial)
//	..(newloc,"steel","black")

	if(couchpart == 1)
		armrest = image("icons/urist/structures&machinery/Nienplants&Couch.dmi", "armrest_left")
		armrest.layer = MOB_LAYER + 0.1
	else if(couchpart == 2)
		armrest = image("icons/urist/structures&machinery/Nienplants&Couch.dmi", "armrest_right")
		armrest.layer = MOB_LAYER + 0.1

	..()

	src.color = initial(color)


/obj/structure/bed/chair/couch/post_buckle_mob()
	if(buckled_mob)
		overlays += armrest
	else
		overlays -= armrest

/obj/structure/bed/chair/couch/left
	couchpart = 1
	icon_state = "couch_left"
	base_icon = "couch_left"

/obj/structure/bed/chair/couch/right
	couchpart = 2
	icon_state = "couch_right"
	base_icon = "couch_right"

/obj/structure/bed/chair/couch/middle
	icon_state = "couch_middle"
	base_icon = "couch_middle"

/obj/structure/bed/chair/couch/left/black
	color = rgb(167,164,153)

/obj/structure/bed/chair/couch/right/black
	color = rgb(167,164,153)

/obj/structure/bed/chair/couch/middle/black
	color = rgb(167,164,153)

/obj/structure/bed/chair/couch/left/teal
	color = rgb(0,255,255)

/obj/structure/bed/chair/couch/right/teal
	color = rgb(0,255,255)

/obj/structure/bed/chair/couch/middle/teal
	color = rgb(0,255,255)

/obj/structure/bed/chair/couch/left/beige
	color = rgb(255,253,195)

/obj/structure/bed/chair/couch/right/beige
	color = rgb(255,253,195)

/obj/structure/bed/chair/couch/middle/beige
	color = rgb(255,253,195)

/obj/structure/bed/chair/couch/left/brown
	color = rgb(255,113,0)

/obj/structure/bed/chair/couch/right/brown
	color = rgb(255,113,0)

/obj/structure/bed/chair/couch/middle/brown
	color = rgb(255,113,0)


/obj/structure/bed/chair/couch/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		new /obj/item/stack/material/steel(src.loc)
		qdel(src)
	if(istype(W, /obj/item/weapon/chair_painter))
		var/obj/item/weapon/chair_painter/C = W
		color = rgb(C.red,C.green,C.blue)
	else
		..()


//UMcS Flora, because /tg/.dm's. //holy fuck this shit is oooooooooooooold
//Nienhaus plants/UMcS Shit

/obj/structure/flora/pottedplant/Nienplants
	name = "Pot"
	icon = 'icons/urist/structures&machinery/Nienplants&Couch.dmi'
	icon_state = "pot"
	anchored = 1

/obj/structure/flora/pottedplant/Nienplants/daisies
	name = "Daisies"
	icon_state = "daisies"

/obj/structure/flora/pottedplant/Nienplants/roses
	name = "Roses"
	icon_state = "roses"

/obj/structure/flora/pottedplant/Nienplants/fern1
	name = "Brush Fern"
	icon_state = "fern1"

/obj/structure/flora/pottedplant/Nienplants/fern2
	name = "Smapy Fern"
	icon_state = "fern2"

/obj/structure/flora/pottedplant/Nienplants/fern3
	name = "Tall Fern"
	icon_state = "fern3"

/obj/structure/flora/pottedplant/Nienplants/violets
	name = "Violets"
	icon_state = "violets"

/obj/structure/flora/pottedplant/Nienplants/lilies
	name = "Lilies"
	icon_state = "lilies"

/obj/structure/flora/pottedplant/Nienplants/violets2
	name = "Violets2"
	icon_state = "violets2"

//tree
/obj/structure/flora/pottedplant/Nienplants/Glloydtree //what is this path
	name = "tree"
	icon = 'icons/urist/structures&machinery/Glloydtrees.dmi'
	icon_state = "tree"
	anchored = 1
	layer = 9

/obj/structure/flora/pottedplant/Nienplants/Glloydtree/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/weapon/carpentry/axe))
		user << "<span class='notice'>Your axe bounces off the tree! Holy shit, is it metal? Cheapass Nanotrasen corporate bastards.</span>"
		return

//Putting this here because of stupid flora code -Glloyd //back when i signed things. why did i do this? why am i writing comments now? probably cause i'm a little drunk. but this file hasn't been touched in ages, so fuck it.
/obj/structure/flora/pottedplant/Nienplants/plant
	name = "bush"
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "firstbush_1"
	anchored = 1

