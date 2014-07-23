//
//Put SupplyPacks and crates here
//Made by TGameCo
//Reference files are in crate.dm, largecrate.dm, supplypacks.dm
//

//Turtle Crates - TGC
/obj/structure/largecrate/turtle //Lisacrates are perfect for images
	icon_state = "lisacrate"

/obj/structure/largecrate/turtle/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/crowbar))
		new /mob/living/simple_animal/turtle(loc)
	..()

/datum/supply_packs/turtle
	name = "Turtle Crate"
	contains = list()
	cost = 50
	containertype = /mob/living/simple_animal/turtle
	containername = "Turtle Crate"
	group = "Hydroponics"

//A crate.

/obj/structure/closet/crate/secure/large/reinforced/singulo
	name = "Particle Accelerator Storage"
	desc = "A hefty, reinforced metal crate with an electronic locking system."
	req_access = list(access_ce)
	icon_state = "largermetal"
	icon_opened = "largermetalopen"
	icon_closed = "largermetal"

/obj/structure/closet/crate/secure/large/reinforced/singulo/New()
	..()
	new /obj/structure/particle_accelerator/end_cap(src)
	new /obj/structure/particle_accelerator/fuel_chamber(src)
	new /obj/structure/particle_accelerator/power_box(src)
	new /obj/structure/particle_accelerator/particle_emitter/center(src)
	new /obj/structure/particle_accelerator/particle_emitter/left(src)
	new /obj/structure/particle_accelerator/particle_emitter/right(src)

//Ripley Paint Crate - TGC

/datum/supply_packs/paintkits/ripley
	name = "Customization Crate (APLU \"Ripley\")"
	contains = list(/obj/item/weapon/paintkit/fluff/clownply)//Put Ripley Customization stuff here
	cost = 100
	access = access_robotics
	containertype = /obj/structure/closet/crate/secure
	containername = "APLU \"Ripley\" Customization Crate"
	group = "Engineering"