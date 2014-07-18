//File created by TGameCo. Please put code for custom crates in here.

//This is so Turtles can be ordered - By TGameCo
/obj/structure/largecrate/turtle
	icon_state = "lisacrate"

/obj/structure/largecrate/turtle/attackby(obj/item/weapon/W as obj, mob/user as mob)	//Code shamelessley copy-pasta'd from largecrate.dm
	if(istype(W, /obj/item/weapon/crowbar))
		new /mob/living/simple_animal/turtle(loc)
	..()

/datum/supply_packs/turtle // Adds the crate to the machine - found in supplypacks.dm
	name = "Turtle Crate"
	contains = list()
	cost = 20
	containertype = /obj/structure/largecrate/turtle
	containername = "Turtle Crate"
	group = "Hydroponics"