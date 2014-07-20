//
//Put SupplyPacks and crates here
//Made by TGameCo
//Reference files are in crate.dm, largecrate.dm, supplypacks.dm
//

//Turtle Crates - TGC
/obj/structure/largecrate/turtle //Lisacrates are perfect for images
	icon_state = "lisacrate"

/datum/supply_packs/turtle
	name = "Turtle Crate"
	contains = list()
	cost = 50
	containertype = /mob/living/simple_animal/turtle
	containername = "Turtle Crate"
	group = "Hydroponics"