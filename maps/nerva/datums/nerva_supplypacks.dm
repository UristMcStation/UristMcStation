//supplypacks

//shipweapons

/singleton/hierarchy/supply_pack/security/shiplightlaser
	name = "Ship-to-Ship - Light Laser Cannon"
	contains = list(/obj/structure/shipweapons/incomplete_weapon/lightlaser)
	cost = 240
	containertype = /obj/structure/largecrate
	containername = "Light Laser Cannon - Ship-to-Ship"
	access = access_bridge

/singleton/hierarchy/supply_pack/security/shipion
	name = "Ship-to-Ship - Ion Cannon"
	contains = list(/obj/structure/shipweapons/incomplete_weapon/ion)
	cost = 290
	containertype = /obj/structure/largecrate
	containername = "Ion Cannon - Ship-to-Ship"
	access = access_bridge

/singleton/hierarchy/supply_pack/security/shiplightpulse
	name = "Ship-to-Ship - Light Pulse Cannon"
	contains = list(/obj/structure/shipweapons/incomplete_weapon/lightpulse)
	cost = 265
	containertype = /obj/structure/largecrate
	containername = "Light Pulse Cannon - Ship-to-Ship"
	access = access_bridge

/singleton/hierarchy/supply_pack/security/shipheavy_autocannon
	name = "Ship-to-Ship - Heavy Autocannon"
	contains = list(/obj/structure/shipweapons/incomplete_weapon/external/heavy_autocannon)
	cost = 333
	containertype = /obj/structure/largecrate
	containername = "Heavy Autocannon - Ship-to-Ship"
	access = access_bridge

/singleton/hierarchy/supply_pack/security/uniform_crate   // Nerva Specific Uniform Crate
	name = "Security uniform crate"
	contains = list(/obj/item/clothing/accessory/armband,
					/obj/item/storage/backpack/messenger/sec,
					/obj/item/storage/backpack/security,
					/obj/item/clothing/glasses/hud/security/prot/sunglasses,
					/obj/item/clothing/gloves/thick,
					/obj/item/clothing/glasses/hud/security/prot,
					/obj/item/clothing/accessory/storage/black_vest,
					/obj/item/storage/belt/security,
					/obj/item/storage/belt/holster/security,
					/obj/item/clothing/under/urist/nerva/secfield,
					/obj/item/clothing/under/urist/nerva/secregular,
					/obj/item/device/radio/headset/nerva_sec/alt,
					/obj/item/device/radio/headset/nerva_sec,
					/obj/item/clothing/suit/urist/armor/nerva/sec // Only the older vest, no plate carriers.
					)
	cost = 20
	newcargocost = 32 //1440th on Nerva
	containertype = /obj/structure/closet/crate/secure
	access = access_security
	containername = "security uniform crate"
