/obj/machinery/door/airlock/multi_tile/marine/infestation
	var/specialact = 0

/obj/machinery/door/airlock/multi_tile/marine/infestation/proc/lockup()
	if(locked == 0)
		locked = 1
		icon_state = "door_locked"

	else if(locked == 1)
		locked = 0
		icon_state = "door_closed"

/obj/machinery/suit_storage_unit/anfor
	name = "ANFOR Voidsuit Storage Unit"
	suit = /obj/item/clothing/suit/space/void/anfor
	helmet = /obj/item/clothing/head/helmet/space/void/anfor
	mask = /obj/item/clothing/mask/breath
	req_access = list(access_cent_general)
	islocked = 1

//Assault mode ammo vender

/obj/machinery/vending/urist/assaultammodispenser
	name = "ANFOR Weapon Cache"
	desc = "An automated ANFOR supply cache for efficent storage and distribution of weapons, ammunition and material."
	icon_state = "clothing2"
	vend_reply = "Git some!"
	product_ads = "Food for your rifle.;Out of rounds? We're here for you.;Resupply here!"
	product_slogans = "Bullets for every occasion!;Tactical reloads!;RAMIREZ!"
	products = list(
		//ammo,
		/obj/item/ammo_magazine/rifle/a22 = 60,
		/obj/item/ammo_magazine/rifle/military/a18 = 60,
		/obj/item/ammo_magazine/a9mm = 60,
		/obj/item/storage/box/ammo/shotgunammo = 60,
		/obj/item/storage/box/ammo/shotgunshells = 60,
		/obj/item/ammo_magazine/pistol/a7 = 60,
		//guns,
		/obj/item/gun/projectile/automatic/a22 = 10,
		/obj/item/gun/projectile/a18 = 10,
		/obj/item/gun/projectile/automatic/asmg = 10,
		/obj/item/gun/projectile/shotgun/pump/A41 = 10,
		/obj/item/gun/projectile/pistol/colt/a7 = 20,
		/obj/item/gun/projectile/manualcycle/a50 = 2,
		//attachments,
//		/obj/item/gunattachment/grenadelauncher = 10,
//		/obj/item/gunattachment/scope/a18 = 10,
		//grenades and mines,
		/obj/item/storage/box/anforgrenade = 10,
		/obj/item/storage/box/large/mines = 3
		)
	contraband = list(
		/obj/item/storage/box/ammo/flashshells = 5,
		/obj/item/storage/box/ammo/beanbags = 5,
		/obj/item/ammo_magazine/speedloader = 10,
		/obj/item/ammo_magazine/pistol = 10,
		/obj/item/ammo_magazine/rifle/military = 10,
		/obj/item/ammo_magazine/rifle = 10
		)

//Assault mode clothing and armor vender

/obj/machinery/vending/urist/assaultclothingdispenser
	name = "ANFOR Equipment Cache"
	desc = "An automated ANFOR supply cache for efficent storage and distribution of armor and equipment."
	product_slogans = "Look like a real soldier."
	product_ads = "Keep yourself covered.;Protection for our fighting forces."
	vend_reply = "Suit up!"
	icon_state = "clothing2"
	products = list(
		/obj/item/clothing/suit/storage/urist/armor/anfor/marine = 20,
		/obj/item/clothing/under/urist/anfor = 20,
		/obj/item/clothing/head/helmet/urist/anfor = 20,
		/obj/item/clothing/shoes/urist/anforjackboots = 20,
		/obj/item/storage/belt/holster/security/tactical = 20
		)
	contraband = list(
		/obj/item/storage/fancy/smokable/cigar = 1
		)
