//captain's lockers. got sick of the lag when rightclicking.

//CDN
/obj/structure/closet/secure_closet/captainsclothes
	name = "Captain's Clothing Locker"
	req_access = list(access_captain)

/obj/structure/closet/secure_closet/captainsclothes/New()
	..()
	sleep(2)
	new /obj/item/storage/backpack/dufflebag/com(src)
	new /obj/item/storage/backpack/command(src)
	new /obj/item/storage/backpack/satchel/com(src)
	new /obj/item/clothing/suit/captunic(src)
	new /obj/item/clothing/suit/storage/capjacket(src)
	new /obj/item/clothing/under/rank/captain(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/gloves/captain(src)
	new /obj/item/clothing/under/dress/dress_cap(src)
	new /obj/item/clothing/suit/storage/hooded/wintercoat/captain(src)
	new /obj/item/clothing/head/caphat/cap(src)
	new /obj/item/clothing/under/urist/rank/capdressalt(src)
	return

//CDN
/obj/structure/closet/secure_closet/captainsequipment
	name = "Captain's Equipment Locker"
	req_access = list(access_captain)

/obj/structure/closet/secure_closet/captainsequipment/New()
	..()
	sleep(2)
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/clothing/head/helmet/swat(src)
	new /obj/item/device/radio/headset/heads/captain(src)
	new /obj/item/gun/projectile/revolver/webley(src)
	new /obj/item/ammo_magazine/speedloader(src)
	new /obj/item/clothing/suit/armor/captain(src)
	new /obj/item/melee/telebaton(src)
	new /obj/item/clothing/suit/armor/vest/capcarapace(src)
	new /obj/item/clothing/head/caphat/cap(src)
	new /obj/item/clothing/head/helmet/space/capspace(src)
	new /obj/item/tank/jetpack/oxygen(src)
	new /obj/item/clothing/mask/gas(src)
	return

//blooshield locker
//CDN
/obj/structure/closet/secure_closet/blueshield
	name = "Blueshield Locker"
	req_access = list(access_blueshield)

/obj/structure/closet/secure_closet/blueshield/New()
	..()
	sleep(2)
	new	/obj/item/storage/firstaid/adv(src)
	//new /obj/item/gun/projectile/revolver/detective/deckard(src)
	new /obj/item/storage/belt/holster/security(src)
	new /obj/item/storage/belt/security(src)
	new /obj/item/grenade/flashbang(src)
	new /obj/item/melee/baton/loaded(src)
	new /obj/item/gun/energy/taser(src)
	new /obj/item/clothing/accessory/storage/black_vest(src)
	new /obj/item/clothing/accessory/storage/holster/waist(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/under/rank/centcom(src)
	new /obj/item/device/flash(src)
	new /obj/item/handcuffs(src)
	new /obj/item/clothing/suit/storage/urist/coat/blueshield(src)
	new /obj/item/clothing/suit/armor/pcarrier(src)
	new /obj/item/clothing/accessory/armor_plate/medium(src)
	return

//Emergency suits locker

/obj/structure/closet/emsuits
	name = "emergency suit closet"
	desc = "It's a closet for storing emergency equipment and suits. A small  sign on the bottom reads 'use only in extreme emergencies'"

/obj/structure/closet/emsuits/New()
	..()

	new /obj/item/clothing/head/helmet/space/emergency(src)
	new /obj/item/clothing/suit/space/emergency(src)
	new /obj/item/tank/oxygen_emergency(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/storage/toolbox/emergency(src)
	new /obj/item/tank/oxygen_emergency(src)

//Armored sec biosuit locker
//CDN
/obj/structure/closet/secure_closet/armoredbiosuit
	name = "armoured bio suit locker"
	req_access = list(access_armory)

/obj/structure/closet/secure_closet/armoredbiosuit/New()
	..()

	new /obj/item/clothing/head/bio_hood/asec(src)
	new /obj/item/clothing/suit/bio_suit/asec(src)

//Psychologists locker

//CDN
/obj/structure/closet/secure_closet/psychologist
	name = "Psychologist's Locker"
	req_access = list(access_psychiatrist)

//scom
/obj/structure/closet/scom/sniper
	name = "S-COM Sniper"

/obj/structure/closet/scom/sniper/New()
	..()
	new /obj/item/clothing/accessory/storage/black_vest(src)
	new /obj/item/clothing/head/beret/sec/navy/officer(src)
	new /obj/item/clothing/suit/armor/vest/jacket(src)
	new /obj/item/gun/energy/sniperrifle(src)
	new /obj/item/gun/projectile/pistol/magnum_pistol(src)
	new /obj/item/ammo_magazine/a50(src)
	new /obj/item/ammo_magazine/a50(src)
	new /obj/item/ammo_magazine/a50(src)

/obj/structure/closet/scom/assault
	name = "S-COM Assault"

/obj/structure/closet/scom/assault/New()
	..()
	new /obj/item/clothing/accessory/storage/black_vest(src)
	new /obj/item/clothing/head/beret/sec/navy/officer(src)
	new /obj/item/clothing/suit/armor/vest/jacket(src)
	new /obj/item/gun/energy/sniperrifle(src)
	new /obj/item/gun/projectile/pistol/magnum_pistol(src)
	new /obj/item/ammo_magazine/a50(src)
	new /obj/item/ammo_magazine/a50(src)
	new /obj/item/ammo_magazine/a50(src)

/obj/structure/closet/scom/heavy
	name = "S-COM Heavy"

/obj/structure/closet/scom/heavy/New()
	..()
	new /obj/item/clothing/accessory/storage/black_vest(src)

/obj/structure/closet/scom/medic
	name = "S-COM Medic"

/obj/structure/closet/scom/medic/New()
	..()
	new /obj/item/clothing/accessory/storage/black_vest(src)

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

/obj/structure/closet/scom/generic/WillContain()
	return list(
		/obj/item/device/radio/headset/syndicate,
		/obj/item/clothing/under/rank/centcom,
		/obj/item/clothing/shoes/swat,
		/obj/item/clothing/gloves/thick/swat,
		/obj/item/storage/belt/urist/military/scom
	)

//for the map
//CDN
/obj/structure/closet/wardrobe/tactical/double
	name = "tactical equipment"
	icon_state = "syndicate1"

/obj/structure/closet/wardrobe/tactical/double/WillContain()
	return list(
		/obj/item/clothing/suit/armor/pcarrier/green = 2,
		/obj/item/clothing/accessory/armor_plate/medium = 2,
		/obj/item/clothing/under/tactical = 2,
		/obj/item/clothing/head/helmet/nt/tactical = 2,
		/obj/item/clothing/accessory/arm_guards/green = 2,
		/obj/item/clothing/accessory/leg_guards/green = 2,
		/obj/item/clothing/mask/balaclava/tactical = 2,
		/obj/item/clothing/glasses/hud/security/prot = 2,
		/obj/item/storage/belt/holster/security/tactical = 2,
		/obj/item/clothing/shoes/jackboots = 2,
		/obj/item/clothing/gloves/thick = 2,
	)

/obj/structure/closet/secure_closet/hunter
	name = "hunting gear"
	req_access = list(access_mining)

/obj/structure/closet/secure_closet/hunter/WillContain()
	return list(
		/obj/item/gunattachment/scope/huntrifle,
		/obj/item/gun/projectile/manualcycle/hunterrifle,
		/obj/item/ammo_magazine/rifle/military/stripper = 3,
		/obj/item/device/flashlight/lantern,
		/obj/item/shovel,
		/obj/item/material/hatchet,
		/obj/item/material/knife/hunting
	)

/obj/structure/closet/secure_closet/guncabinet/sidearm
	name = "sidearm cabinet"
	req_access = list()
//	req_one_access = list(access_armory,access_hos,access_hop,access_ce,access_cmo,access_rd)

/obj/structure/closet/secure_closet/guncabinet/sidearm/WillContain()
	return list(
			/obj/item/clothing/accessory/storage/holster/thigh = 2,
			/obj/item/gun/energy/gun/secure = 3,
	)

/obj/structure/closet/secure_closet/guncabinet/sidearm/small
	name = "personal sidearm cabinet"

/obj/structure/closet/secure_closet/guncabinet/sidearm/small/WillContain()
	return list(/obj/item/gun/energy/gun/small/secure = 4)

/obj/structure/closet/secure_closet/guncabinet/sidearm/combined
	name = "combined sidearm cabinet"

/obj/structure/closet/secure_closet/guncabinet/sidearm/combined/WillContain()
	return list(
		/obj/item/gun/energy/gun/small/secure = 2,
		/obj/item/clothing/accessory/storage/holster/thigh = 2,
		/obj/item/gun/energy/gun/secure = 2,
		new /datum/atom_creator/weighted(list(/obj/item/gun/energy/gun/secure, /obj/item/gun/energy/gun/small/secure))
	)

/obj/structure/closet/medical_wall/engineering
	name = "radiation treatment closet"

/obj/structure/closet/medical_wall/engineering/WillContain() //for radiation shit
	return list(
		/obj/item/storage/firstaid/rad,
		/obj/item/storage/firstaid/toxin,
		/obj/item/storage/med_pouch/radiation = 2)

/singleton/closet_appearance/urist/sarcophagus
	decals = null
	extra_decals = null
	base_icon = 'icons/urist/obj/sarcophagus.dmi' //uses the icon_states base, open, interior, lock / light / sparks (if possible), welded
	color = "#ffffff"

/obj/structure/closet/coffin/urist/sarcophagus
	name = "sarcophagus"
	desc = "It's a burial receptacle for the dearly departed."
	closet_appearance = /singleton/closet_appearance/urist/sarcophagus
	storage_types = CLOSET_STORAGE_MOBS

/singleton/closet_appearance/urist/stonecoffin
	decals = null
	extra_decals = null
	base_icon = 'icons/urist/obj/stonecoffin.dmi'
	color = "#ffffff"

/obj/structure/closet/coffin/urist/stonecoffin
	name = "stone coffin"
	desc = "It's a burial receptacle for the dearly departed."
	closet_appearance = /singleton/closet_appearance/urist/stonecoffin
	storage_types = CLOSET_STORAGE_MOBS

//this got yeeted by bay

/obj/structure/closet/secure_closet/money
	name = "secure locker"
	icon = 'icons/obj/closets/fridge.dmi'
	closet_appearance = null
	req_access = list(access_heads_vault)

/obj/structure/closet/secure_closet/money/Initialize()
	. = ..()
	//let's make hold a substantial amount.
	var/created_size = 0
	for(var/i = 1 to 200) //sanity loop limit
		var/obj/item/cash_type = pick(3; /obj/item/spacecash/bundle/c1000, 4; /obj/item/spacecash/bundle/c500, 5; /obj/item/spacecash/bundle/c200)
		var/bundle_size = initial(cash_type.w_class) / 2
		if(created_size + bundle_size <= storage_capacity)
			created_size += bundle_size
			new cash_type(src)
		else
			break
