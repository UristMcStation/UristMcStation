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

//Ripley Paintkits - TGC - PUT ALL PAINT KITS FOR RIPLEY IN HERE!!!
/datum/supply_packs/mecha_ripley_paintkits
	name = "APLU \"Ripley\" Customization Kits"
	contains = list(/obj/item/weapon/paintkit/fluff/clownply)//Add them here!
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "APLU \"Ripley\" Customization Crate"
	access = access_robotics
	group = "Engineering"