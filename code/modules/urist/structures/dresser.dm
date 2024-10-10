
//Added by TGameCo
//My first thing in ss13, based on the dresser we used in tg
//Note: The basics took me ~1 hour. The attack_hand proc took me the rest of the day...

/obj/structure/dresser
	name = "Dresser"
	desc = "A wooden closet full of undergarments."
	icon = 'icons/urist/structures&machinery/structures.dmi'
	icon_state = "dresser"
	density = TRUE
	anchored = TRUE

//Do the thing!

/obj/structure/dresser/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		var/obj/item/stack/material/wood/S = new /obj/item/stack/material/wood(src.loc)
		S.amount = 5
		qdel(src)
	else
		..()
