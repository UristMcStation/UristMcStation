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
	SUIT_TYPE = /obj/item/clothing/suit/space/void/anfor
	HELMET_TYPE = /obj/item/clothing/head/helmet/space/void/anfor
	MASK_TYPE = /obj/item/clothing/mask/breath
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
	vend_delay = 5
	products = list(
		//ammo,
		/obj/item/ammo_magazine/a556/a22 = 60,
		/obj/item/ammo_magazine/a762mm/a18 = 60,
		/obj/item/ammo_magazine/a9mm = 60,
		/obj/item/weapon/storage/box/shotgunammo = 60,
		/obj/item/weapon/storage/box/shotgunshells = 60,
		/obj/item/ammo_magazine/c45m/a7 = 60,
		/obj/item/ammo_magazine/a132x108mm/stripper = 30,
		//guns,
		/obj/item/weapon/gun/projectile/automatic/a22 = 10,
		/obj/item/weapon/gun/projectile/a18 = 10,
		/obj/item/weapon/gun/projectile/automatic/asmg = 10,
		/obj/item/weapon/gun/projectile/shotgun/pump/combat/A41 = 10,
		/obj/item/weapon/gun/projectile/colt/a7 = 20,
		/obj/item/weapon/gun/projectile/manualcycle/a50 = 5,
		//attachments,
		/obj/item/weapon/gunattachment/grenadelauncher = 10,
		/obj/item/weapon/gunattachment/scope/a18 = 10,
		//grenades and mines,
		/obj/item/weapon/storage/box/anforgrenade = 10,
		/obj/item/weapon/storage/box/mines = 3
		)
	contraband = list(
		/obj/item/weapon/storage/box/flashshells = 5,
		/obj/item/weapon/storage/box/beanbags = 5,
		/obj/item/ammo_magazine/c38 = 10,
		/obj/item/ammo_magazine/c45m = 10,
		/obj/item/ammo_magazine/a556 = 10,
		/obj/item/ammo_magazine/c762 = 10
		)

//Assault mode clothing and armor vender

/obj/machinery/vending/urist/assaultclothingdispenser
	name = "ANFOR Equipment Cache"
	desc = "An automated ANFOR supply cache for efficent storage and distribution of armor and equipment."
	product_slogans = "Look like a real soldier."
	product_ads = "Keep yourself covered.;Protection for our fighting forces."
	vend_delay = 15
	vend_reply = "Suit up!"
	icon_state = "clothing2"
	products = list(
		/obj/item/clothing/suit/urist/armor/anfor/marine = 20,
		/obj/item/clothing/under/urist/anfor = 20,
		/obj/item/clothing/head/helmet/urist/anfor = 20,
		/obj/item/clothing/shoes/urist/anforjackboots = 20,
		/obj/item/weapon/storage/belt/security/tactical = 20
		)
	contraband = list(
		/obj/item/weapon/storage/fancy/cigar = 1
		)


