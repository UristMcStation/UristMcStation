// Urist-specific Janitorial Crates:

/singleton/hierarchy/supply_pack/custodial/replacement_janicart
	name = "Gear - Janitorial Cart"
	contains = list(/obj/structure/janitorialcart)
	cost = 10
	newcargocost = 20 //900th on Nerva
	containertype = /obj/structure/largecrate
	containername = "replacement janitorial cart"

// Lightbulb and Lighttube Packs

/singleton/hierarchy/supply_pack/custodial/tintedlighttubes
	name = "Spares - Replacement tinted lights"
	contains = list(/obj/item/storage/box/lights/mixedtint,
					/obj/item/storage/box/lights/mixedtint,
					/obj/item/storage/box/lights/mixedtint)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Replacement tinted lights"

/singleton/hierarchy/supply_pack/custodial/redlightbulbs
	name = "Spares - Replacement maintenance lights"
	contains = list(/obj/item/storage/box/lights/redbulbs,
					/obj/item/storage/box/lights/redbulbs,
					/obj/item/storage/box/lights/redbulbs)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Replacement maintenance lights"
