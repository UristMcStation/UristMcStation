// Urist Specific Crates for Cargo Department

/singleton/hierarchy/supply_pack/operations/hunting_supplies
	name = "Equipment - Hunting Supplies"
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

/singleton/hierarchy/supply_pack/operations/mail_supplies
	name = "Equipment - Mail Supplies"
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "Mail supplies crate"
	contains = list(/obj/item/device/destTagger,
					/obj/item/stack/package_wrap,
					/obj/item/stack/package_wrap)
