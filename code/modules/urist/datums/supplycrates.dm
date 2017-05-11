/*										*****New space to put all UristMcStation /datum/supply_packs and their relevant crates.*****

Crates that can't be ordered go to urist/structures/crates.dm

Please keep it tidy, by which I mean put comments describing the item before the entry. -Glloyd*/


//Reference files are in crate.dm, largecrate.dm, supplypacks.dm


//Turtle Crates - TGC
/obj/structure/largecrate/turtle //Lisacrates are perfect for images
	icon_state = "lisacrate"

/obj/structure/largecrate/turtle/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/crowbar))
		new /mob/living/simple_animal/turtle(loc)
	..()

/decl/hierarchy/supply_pack/hydroponics/turtle
	name = "Turtle Crate"
	contains = list()
	cost = 50
	containertype = /obj/structure/largecrate/turtle
	containername = "Turtle Crate"

//Ripley Paint Crate - TGC

/decl/hierarchy/supply_pack/engineering/ripleypaintkits
	name = "Customization Crate (APLU \"Ripley\")"
	num_contained = 1 //only one paintkit for you //needs a port to the paintkit refactor, TGCode
	contains = list(/obj/item/device/kit/paint/clownply,
					/obj/item/device/kit/paint/titan,
					/obj/item/device/kit/paint/mercenary,
					/obj/item/device/kit/paint/dreadnought)//Put Ripley Customization stuff here
	cost = 100
	access = access_robotics
	containertype = /obj/structure/closet/crate/secure
	containername = "APLU \"Ripley\" Customization Crate"
	supply_method = /decl/supply_method/randomized

//Mail supply crate - 2 rolls of packing wrap and a destination tagger - Octobomb

/decl/hierarchy/supply_pack/operations/mail_supplies
	name = "Mail Supplies"
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "Mail supplies crate"
	contains = list(/obj/item/device/destTagger,
					/obj/item/weapon/packageWrap,
					/obj/item/weapon/packageWrap)

//Xenobio supplies crate - for when the slimes all die. One extinguisher, one monkeycube box, two grey extracts - Octobomb
/decl/hierarchy/supply_pack/science/xenobio_supplies
	name = "Xenobiology Supplies"
	contains = list(/obj/item/weapon/extinguisher,
					/obj/item/weapon/storage/box/monkeycubes,
					/obj/item/slime_extract/grey,
					/obj/item/slime_extract/grey)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "Xenobiology supplies crate"
	access = access_rd

/decl/hierarchy/supply_pack/engineering/tintedlighttubes
	name = "Replacement tinted lights"
	contains = list(/obj/item/weapon/storage/box/lights/mixedtint,
					/obj/item/weapon/storage/box/lights/mixedtint,
					/obj/item/weapon/storage/box/lights/mixedtint)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Replacement tinted lights"

/decl/hierarchy/supply_pack/engineering/redlightbulbs
	name = "Replacement maintenance lights"
	contains = list(/obj/item/weapon/storage/box/lights/redbulbs,
					/obj/item/weapon/storage/box/lights/redbulbs,
					/obj/item/weapon/storage/box/lights/redbulbs)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Replacement maintenance lights"

/decl/hierarchy/supply_pack/operations/hunting_supplies
	name = "Hunting Supplies"
	contains = list(/obj/item/weapon/gun/projectile/manualcycle/hunterrifle,
					/obj/item/ammo_magazine/a762mm/stripper,
					/obj/item/ammo_magazine/a762mm/stripper,
					/obj/item/device/flashlight/lantern,
					/obj/item/weapon/material/hatchet,
					/obj/item/weapon/material/knife/hunting,
					/obj/item/weapon/fishingrod,
					/obj/item/clothing/suit/storage/urist/overalls/leather)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Hunting supplies crate"
	access = access_hop