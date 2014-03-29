/obj/structure/stool/bed/chair/couch
	name = "couch"
	desc = "You sit in this. Either by will or force."
	icon = 'icons/urist/structures&machinery/Nienplants&Couch.dmi'
	icon_state = "chair"

// Chair types
/obj/structure/stool/bed/chair/couch/black
	icon_state = "couchblack_left"
	name = "black couch"
	desc = "A black couch."

/obj/structure/stool/bed/chair/couch/black/middle
	icon_state = "couchblack_middle"
	name = "black couch"
	desc = "A black couch."

/obj/structure/stool/bed/chair/couch/black/right
	icon_state = "couchblack_right"
	name = "black couch"
	desc = "A black couch."

/obj/structure/stool/bed/chair/couch/beige
	icon_state = "couchbeige_left"
	name = "beige couch"
	desc = "A beige couch."

/obj/structure/stool/bed/chair/couch/beige/middle
	icon_state = "couchbeige_middle"
	name = "beige couch"
	desc = "A beige couch."

/obj/structure/stool/bed/chair/couch/beige/right
	icon_state = "couchbeige_right"
	name = "beige couch"
	desc = "A beige couch."

/obj/structure/stool/bed/chair/couch/brown
	icon_state = "couchbrown_left"
	name = "brown couch"
	desc = "A brown couch."

/obj/structure/stool/bed/chair/couch/brown/middle
	icon_state = "couchbrown_middle"
	name = "brown couch"
	desc = "A brown couch."

/obj/structure/stool/bed/chair/couch/brown/right
	icon_state = "couchbrown_right"
	name = "brown couch"
	desc = "A brown couch."

/obj/structure/stool/bed/chair/couch/teal
	icon_state = "couchteal_left"
	name = "teal couch"
	desc = "A teal couch."

/obj/structure/stool/bed/chair/couch/teal/middle
	icon_state = "couchteal_middle"
	name = "teal couch"
	desc = "A teal couch."

/obj/structure/stool/bed/chair/couch/teal/right
	icon_state = "couchteal_right"
	name = "teal couch"
	desc = "A teal couch."

/obj/structure/stool/bed/chair/couch/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		new /obj/item/stack/sheet/metal(src.loc)
		del(src)
	else
		..()


//UMcS Flora, because /tg/.dm's.
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
/obj/structure/flora/pottedplant/Nienplants/Glloydtree
	name = "tree"
	icon = 'icons/urist/structures&machinery/Glloydtrees.dmi'
	icon_state = "tree"
	anchored = 1
	layer = 9

//Putting this here because of stupid flora code -Glloyd
/obj/structure/flora/pottedplant/Nienplants/plant
	name = "bush"
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "firstbush_1"
	anchored = 1

