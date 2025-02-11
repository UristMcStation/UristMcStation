/*										*****New space to put all UristMcStation /datum/supply_packs and their relevant crates.*****

Crates that can't be ordered go to urist/structures/crates.dm

Please keep it tidy, by which I mean put comments describing the item before the entry. -Glloyd*/


//Reference files are in crate.dm, largecrate.dm, supplypacks.dm


//Turtle Crates - TGC
/obj/structure/largecrate/turtle //Lisacrates are perfect for images
	icon_state = "lisacrate"

/obj/structure/largecrate/turtle/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/crowbar))
		new /mob/living/simple_animal/turtle(loc)
	..()

/singleton/hierarchy/supply_pack/hydroponics/turtle
	name = "Turtle Crate"
	contains = list()
	cost = 50
	containertype = /obj/structure/largecrate/turtle
	containername = "Turtle Crate"

//Ripley Paint Crate - TGC
/*
/singleton/hierarchy/supply_pack/engineering/ripleypaintkits
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
	supply_method = /singleton/supply_method/randomized
*/
//Mail supply crate - 2 rolls of packing wrap and a destination tagger - Octobomb

/singleton/hierarchy/supply_pack/operations/mail_supplies
	name = "Mail Supplies"
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "Mail supplies crate"
	contains = list(/obj/item/device/destTagger,
					/obj/item/stack/package_wrap/twenty_five,
					/obj/item/stack/package_wrap/twenty_five)

//Xenobio supplies crate - for when the slimes all die. One extinguisher, one monkeycube box, two grey extracts - Octobomb
/singleton/hierarchy/supply_pack/science/xenobio_supplies
	name = "Xenobiology Supplies"
	contains = list(/obj/item/extinguisher,
					/obj/item/storage/box/monkeycubes,
					/obj/item/slime_extract/grey,
					/obj/item/slime_extract/grey)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "Xenobiology supplies crate"
	access = access_rd

/singleton/hierarchy/supply_pack/engineering/tintedlighttubes
	name = "Replacement tinted lights"
	contains = list(/obj/item/storage/box/lights/mixedtint,
					/obj/item/storage/box/lights/mixedtint,
					/obj/item/storage/box/lights/mixedtint)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Replacement tinted lights"

/singleton/hierarchy/supply_pack/engineering/redlightbulbs
	name = "Replacement maintenance lights"
	contains = list(/obj/item/storage/box/lights/redbulbs,
					/obj/item/storage/box/lights/redbulbs,
					/obj/item/storage/box/lights/redbulbs)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Replacement maintenance lights"

/singleton/hierarchy/supply_pack/operations/hunting_supplies
	name = "Hunting Supplies"
	contains = list(/obj/item/gun/projectile/manualcycle/hunterrifle,
					/obj/item/ammo_magazine/rifle/military/stripper,
					/obj/item/ammo_magazine/rifle/military/stripper,
					/obj/item/device/flashlight/lantern,
					/obj/item/material/hatchet,
					/obj/item/material/knife/hunting,
					/obj/item/fishingrod,
					/obj/item/clothing/suit/storage/urist/overalls/leather)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Hunting supplies crate"
	access = access_hop

/singleton/hierarchy/supply_pack/medical/cloning_charge_1
	name = "Cloning Verification Disk (1 charge)"
	contains = list(/obj/item/disk/cloning_charge)
	cost = 100
	newcargocost = 200 // 9000th on Nerva
	containertype = /obj/structure/closet/crate/secure
	containername = "cloning verification disk crate"
	access = access_medical_equip

/singleton/hierarchy/supply_pack/medical/cloning_charge_2
	name = "Cloning Verification Disk (2 charges)"
	contains = list(/obj/item/disk/cloning_charge/two)
	cost = 200
	newcargocost = 380 //17100th, 5% discount
	containertype = /obj/structure/closet/crate/secure
	containername = "cloning verification disk crate"
	access = access_medical_equip

/singleton/hierarchy/supply_pack/medical/cloning_charge_5
	name = "Cloning Verification Disk (5 charges)"
	contains = list(/obj/item/disk/cloning_charge/five)
	cost = 500
	newcargocost = 900 //40500th, 10% discount. not just cloning DRM but cloning microtransactions.
	containertype = /obj/structure/closet/crate/secure
	containername = "cloning verification disk crate"
	access = access_medical_equip

/singleton/hierarchy/supply_pack/livecargo/opossom
	name = "Opossum Crate"
	contains = list(/mob/living/simple_animal/passive/opossum)
	cost = 30
	newcargocost = 55 // 2500th on Nerva
	containertype = /obj/structure/largecrate
	containername = "Opossum Crate"

/singleton/hierarchy/supply_pack/custodial/replacement_janicart
	name = "Replacement Janitorial Cart"
	contains = list(/obj/structure/janitorialcart)
	cost = 10
	newcargocost = 20 //900th on Nerva
	containertype = /obj/structure/largecrate
	containername = "replacement janitorial cart"

/singleton/hierarchy/supply_pack/flooring/magenta
	name = "Magenta carpet"
	contains = list(/obj/item/stack/tile/carpetmagenta)
	cost = 10
	newcargocost = 15 //675th on Nerva
	containertype = /obj/structure/closet/crate/secure
	containername = "magenta carpet crate"

/singleton/hierarchy/supply_pack/flooring/poolturf
	name = "Pool flooring"
	contains = list(/obj/item/stack/tile/pool)
	cost = 10
	newcargocost = 30 // 1350th on Nerva
	containertype = /obj/structure/closet/crate/secure
	containername = "pool flooring crate"

/singleton/hierarchy/supply_pack/flooring/walnut
	name = "Walnut wooden flooring"
	contains = list(/obj/item/stack/tile/walnut)
	cost = 10
	newcargocost = 15 //675th on Nerva
	containertype = /obj/structure/closet/crate/secure
	containername = "walnut wooden flooring crate"

/singleton/hierarchy/supply_pack/flooring/mahogany
	name = "Mahogany wooden flooring"
	contains = list(/obj/item/stack/tile/mahogany)
	cost = 10
	newcargocost = 15 //675th on Nerva
	containertype = /obj/structure/closet/crate/secure
	containername = "mahogany wooden flooring crate"

/singleton/hierarchy/supply_pack/flooring/maple
	name = "Maple wooden flooring"
	contains = list(/obj/item/stack/tile/maple)
	cost = 10
	newcargocost = 15 //675th on Nerva
	containertype = /obj/structure/closet/crate/secure
	containername = "maple wooden flooring crate"

/singleton/hierarchy/supply_pack/flooring/ebony
	name = "Ebony wooden flooring"
	contains = list(/obj/item/stack/tile/ebony)
	cost = 10
	newcargocost = 15 //675th on Nerva
	containertype = /obj/structure/closet/crate/secure
	containername = "ebony wooden flooring crate"

/singleton/hierarchy/supply_pack/flooring/bamboo
	name = "Bamboo wooden flooring"
	contains = list(/obj/item/stack/tile/bamboo)
	cost = 10
	newcargocost = 15 //675th on Nerva
	containertype = /obj/structure/closet/crate/secure
	containername = "bamboo wooden flooring crate"

/singleton/hierarchy/supply_pack/flooring/yew
	name = "Yew wooden flooring"
	contains = list(/obj/item/stack/tile/yew)
	cost = 10
	newcargocost = 15 //675th on Nerva
	containertype = /obj/structure/closet/crate/secure
	containername = "yew wooden flooring crate"
