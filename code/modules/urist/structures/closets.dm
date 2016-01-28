//captain's lockers. got sick of the lag when rightclicking.

/obj/structure/closet/secure_closet/captainsclothes
	name = "Captain's Clothing Locker"
	req_access = list(access_captain)
	icon_state = "capsecure1"
	icon_closed = "capsecure"
	icon_locked = "capsecure1"
	icon_opened = "capsecureopen"
	icon_broken = "capsecurebroken"
	icon_off = "capsecureoff"

	New()
		..()
		sleep(2)
		new /obj/item/weapon/storage/backpack/duffel/duffel_cap(src)
		new /obj/item/weapon/storage/backpack/captain(src)
		new /obj/item/weapon/storage/backpack/satchel_cap(src)
		new /obj/item/clothing/suit/captunic(src)
		new /obj/item/clothing/suit/captunic/capjacket(src)
		new /obj/item/clothing/under/rank/captain(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/clothing/gloves/captain(src)
		new /obj/item/clothing/under/dress/dress_cap(src)
		new /obj/item/clothing/suit/coat/captain(src)
		new /obj/item/clothing/head/helmet/cap(src)
		new /obj/item/clothing/under/urist/rank/capdressalt(src)
		return

/obj/structure/closet/secure_closet/captainsequipment
	name = "Captain's Equipment Locker"
	req_access = list(access_captain)
	icon_state = "capsecure1"
	icon_closed = "capsecure"
	icon_locked = "capsecure1"
	icon_opened = "capsecureopen"
	icon_broken = "capsecurebroken"
	icon_off = "capsecureoff"

	New()
		..()
		sleep(2)
		new /obj/item/clothing/suit/armor/vest(src)
		new /obj/item/weapon/cartridge/captain(src)
		new /obj/item/clothing/head/helmet/swat(src)
		new /obj/item/device/radio/headset/heads/captain(src)
		new /obj/item/weapon/gun/energy/gun(src)
		new /obj/item/clothing/suit/armor/captain(src)
		new /obj/item/weapon/melee/telebaton(src)
		new /obj/item/clothing/suit/armor/vest/capcarapace(src)
		new /obj/item/clothing/head/helmet/cap(src)
		new /obj/item/clothing/head/helmet/space/capspace(src)
		new /obj/item/weapon/tank/jetpack/oxygen(src)
		new /obj/item/clothing/mask/gas(src)
		return

//blooshield locker

/obj/structure/closet/secure_closet/blueshield
	name = "Blueshield Locker"
	icon = 'icons/urist/structures&machinery/structures.dmi'
	req_access = list(access_blueshield)
	icon_state = "bssecure1"
	icon_closed = "bssecure"
	icon_locked = "bssecure1"
	icon_opened = "bssecureopen"
	icon_broken = "bssecurebroken"
	icon_off = "bssecureoff"

	New()
		..()
		sleep(2)
		new	/obj/item/weapon/storage/firstaid/adv(src)
		new /obj/item/weapon/gun/projectile/detective/fluff/callum_leamas(src)
		new /obj/item/weapon/storage/belt/security(src)
		new /obj/item/weapon/grenade/flashbang(src)
		new /obj/item/weapon/melee/baton(src)
		new /obj/item/weapon/gun/energy/taser(src)
		new /obj/item/clothing/tie/storage/black_vest(src)
		new /obj/item/clothing/glasses/sunglasses(src)
		new /obj/item/clothing/under/rank/centcom_officer(src)
		new /obj/item/device/flash(src)
		new /obj/item/weapon/handcuffs(src)
		new /obj/item/clothing/suit/storage/urist/coat/blueshield(src)
		return

//Emergency suits locker

/obj/structure/closet/emsuits
	name = "emergency suit closet"
	desc = "It's a closet for storing emergency equipment and suits. A small  sign on the bottom reads 'use only in extreme emergencies'"
	icon = 'icons/urist/structures&machinery/structures.dmi'
	icon_state = "ecloset"
	icon_closed = "ecloset"
	icon_opened = "eclosetopen"

/obj/structure/closet/emsuits/New()
	..()

	new /obj/item/clothing/head/emergencyhood(src)
	new /obj/item/clothing/suit/emergencysuit(src)
	new /obj/item/weapon/tank/emergency_oxygen(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/weapon/storage/toolbox/emergency(src)
	new /obj/item/weapon/tank/emergency_oxygen(src)

//Armored sec biosuit locker

/obj/structure/closet/secure_closet/armoredbiosuit
	name = "armoured bio suit locker"
	req_access = list(access_armory)
	icon_state = "wardensecure1"
	icon_closed = "wardensecure"
	icon_locked = "wardensecure1"
	icon_opened = "wardensecureopen"
	icon_broken = "wardensecurebroken"
	icon_off = "wardensecureoff"

/obj/structure/closet/secure_closet/armoredbiosuit/New()
	..()

	new /obj/item/clothing/head/bio_hood/asec(src)
	new /obj/item/clothing/suit/bio_suit/asec(src)

//Psychologists locker

/obj/structure/closet/secure_closet/psychologist
	name = "Psychologist's Locker"
	req_access = list(access_psychiatrist)
	icon_state = "cabinetdetective_locked"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"

//scom
/obj/structure/closet/scom/sniper
	name = "S-COM Sniper"

/obj/structure/closet/scom/sniper/New()
	..()
	new /obj/item/clothing/tie/storage/black_vest(src)
	new /obj/item/clothing/head/beret/sec/alt(src)
	new /obj/item/clothing/suit/armor/vest/jacket(src)
	new /obj/item/weapon/gun/energy/sniperrifle(src)
	new /obj/item/weapon/gun/projectile/deagle(src)
	new /obj/item/ammo_magazine/a50(src)
	new /obj/item/ammo_magazine/a50(src)
	new /obj/item/ammo_magazine/a50(src)

/obj/structure/closet/scom/assault
	name = "S-COM Assault"

/obj/structure/closet/scom/assault/New()
	..()
	new /obj/item/clothing/tie/storage/black_vest(src)
	new /obj/item/clothing/head/beret/sec/alt(src)
	new /obj/item/clothing/suit/armor/vest/jacket(src)
	new /obj/item/weapon/gun/energy/sniperrifle(src)
	new /obj/item/weapon/gun/projectile/deagle(src)
	new /obj/item/ammo_magazine/a50(src)
	new /obj/item/ammo_magazine/a50(src)
	new /obj/item/ammo_magazine/a50(src)

/obj/structure/closet/scom/heavy
	name = "S-COM Heavy"

/obj/structure/closet/scom/heavy/New()
	..()
	new /obj/item/clothing/tie/storage/black_vest(src)

/obj/structure/closet/scom/medic
	name = "S-COM Medic"

/obj/structure/closet/scom/medic/New()
	..()
	new /obj/item/clothing/tie/storage/black_vest(src)

/obj/structure/closet/scom/sidearms
	name = "S-COM Sidearms"

/obj/structure/closet/scom/sidearms/New()
	..()

/obj/structure/closet/scom/command
	name = "S-COM Commander's closet"

/obj/structure/closet/scom/command/New()
	..()

/obj/structure/closet/scom/generic
	name = "S-COM Closet"

/obj/structure/closet/scom/generic/New()
	..()
	new /obj/item/device/radio/headset/syndicate(src)
	new /obj/item/clothing/under/rank/centcom(src)
	new /obj/item/clothing/shoes/swat(src)
	new /obj/item/clothing/gloves/swat(src)
	new /obj/item/weapon/storage/belt/urist/military/scom(src)