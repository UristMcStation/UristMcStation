/*************
* Ammunition *
*************/
/datum/uplink_item/item/ammo
	item_cost = 4
	category = /datum/uplink_category/ammunition

/datum/uplink_item/item/ammo/c45m
	name = ".45 pistol magazine"
	path = /obj/item/ammo_magazine/c45m

/datum/uplink_item/item/ammo/mc9mm
	name = "9mm pistol magazine"
	item_cost = 3
	path = /obj/item/ammo_magazine/mc9mm

/datum/uplink_item/item/ammo/darts
	name = "Darts"
	path = /obj/item/ammo_magazine/chemdart

/datum/uplink_item/item/ammo/mc9mmds
	name = "9mm double-stack magazine"
	item_cost = 6
	path = /obj/item/ammo_magazine/mc9mmds

/datum/uplink_item/item/ammo/a44
	name = ".44 speed loader"
	item_cost = 8
	path = /obj/item/ammo_magazine/a44

/datum/uplink_item/item/ammo/a357
	name = ".357 speed loader"
	item_cost = 8
	path = /obj/item/ammo_magazine/c357

/datum/uplink_item/item/ammo/a556
	name = "5.56mm magazine"
	item_cost = 8
	path = /obj/item/ammo_magazine/c556

/datum/uplink_item/item/ammo/sniperammo
	name = "14.5mm"
	item_cost = 8
	path = /obj/item/weapon/storage/box/ammo/sniperammo
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/ammo/sniperammo/apds
	name = "14.5mm APDS"
	item_cost = 12
	path = /obj/item/weapon/storage/box/ammo/sniperammo/apds
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/ammo/shotgun_shells
	name = "Shotgun Shells box"
	item_cost = 8
	path = /obj/item/weapon/storage/box/ammo/shotgunshells

/datum/uplink_item/item/ammo/shotgun_slugs
	name = "Shotgun Slugs box"
	item_cost = 8
	path = /obj/item/weapon/storage/box/ammo/shotgunammo

/datum/uplink_item/item/ammo/c45uzi
	name = ".45 SMG Magazine"
	item_cost = 8
	path = /obj/item/ammo_magazine/c45uzi

/datum/uplink_item/item/ammo/a10mm
	name = "10mm SMG Magazine"
	item_cost = 8
	path = /obj/item/ammo_magazine/a10mm

/datum/uplink_item/item/ammo/p10mm
	name = "10mm Pistol Magazine"
	item_cost = 6
	path = /obj/item/ammo_magazine/p10mm

/datum/uplink_item/item/ammo/a50
	name = ".50 AE magazine"
	item_cost = 8
	path = /obj/item/ammo_magazine/a50

/datum/uplink_item/item/ammo/c50
	name = ".50 AE speedloader"
	item_cost = 8
	path = /obj/item/ammo_magazine/c50

/datum/uplink_item/item/ammo/c38
	name = ".38 speedloader"
	path = /obj/item/ammo_magazine/c38

/datum/uplink_item/item/ammo/flechette
	name = "Flechette Magazine"
	item_cost = 8
	path = /obj/item/weapon/magnetic_ammo

/datum/uplink_item/item/ammo/c45m_emp
	name = ".45 EMP Ammo Box (10 rounds)"
	item_cost = 6
	path = /obj/item/ammo_magazine/box/emp/c45

/datum/uplink_item/item/ammo/p10mm_emp
	name = "10mm EMP Ammo Box (10 rounds)"
	item_cost = 8
	path = /obj/item/ammo_magazine/box/emp/a10mm

/datum/uplink_item/item/ammo/c38_emp
	name = ".38 EMP Ammo Box (10 rounds)"
	item_cost = 6
	path = /obj/item/ammo_magazine/box/emp

/datum/uplink_item/item/ammo/empslug
	name = "Haywire Slug"
	desc = "Single 12-Gauge shotgun slug designed to combat rampant synthetics threats."
	item_cost = 1
	path = /obj/item/ammo_casing/shotgun/emp

/datum/uplink_item/item/ammo/p10mm_emp
	name = ".22 pistol magazine (Hollow Point)"
	item_cost = 6
	path = /obj/item/ammo_magazine/r22lr/pistol/hollowpoint