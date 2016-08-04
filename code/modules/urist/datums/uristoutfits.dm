/decl/hierarchy/outfit/ANTAG
	name = "ANTAG Operative"
	uniform = /obj/item/clothing/under/suit_jacket //change this
	shoes = /obj/item/clothing/shoes/black
	gloves = /obj/item/clothing/gloves/black
	l_ear = /obj/item/device/radio/headset
	glasses = /obj/item/clothing/glasses/sunglasses
	suit = /obj/item/clothing/suit/wcoat
	l_pocket = /obj/item/weapon/melee/energy/sword
	mask = /obj/item/clothing/mask/bandana/bedsheet/red

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/syndicate/station_access
	pda_slot = slot_belt
	pda_type = /obj/item/device/pda/heads

/decl/hierarchy/outfit/ANTAG/post_equip(var/mob/living/carbon/human/H)
	var/obj/item/weapon/storage/secure/briefcase/sec_briefcase = new(H)
	for(var/obj/item/briefcase_item in sec_briefcase)
		qdel(briefcase_item)
	sec_briefcase.contents += new /obj/item/clothing/accessory/storage/webbing
	sec_briefcase.contents += new /obj/item/weapon/gun/projectile/pistol
	sec_briefcase.contents += new /obj/item/ammo_magazine/mc9mm
	sec_briefcase.contents += new /obj/item/ammo_magazine/mc9mm
	sec_briefcase.contents += new /obj/item/weapon/grenade/empgrenade(src)
	H.equip_to_slot_or_del(sec_briefcase, slot_l_hand)

	//M.mutations.Add(COLD_RESISTANCE)
	//for(var/i=3, i>0, i--)
	//	randmutg(M) //3 random good mutations on top (hopefully) of cold resistance
	//M.update_mutations() //otherwise weirdness occurs

/decl/hierarchy/outfit/ANFOR
	name = "ANFOR Marine"
	uniform = /obj/item/clothing/under/urist/anfor
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/swat
	l_ear = /obj/item/device/radio/headset
	//glasses = /obj/item/clothing/glasses/thermal
	suit = /obj/item/clothing/suit/urist/armor/anfor/marine
	head = /obj/item/clothing/head/helmet/urist/anfor
	//mask = /obj/item/clothing/mask/gas/swat
	back = /obj/item/weapon/storage/backpack/security
	backpack_contents = list(/obj/item/ammo_magazine/c45m/a7 = 1, /obj/item/weapon/storage/firstaid/regular = 1,
		/obj/item/device/flashlight = 1, /obj/item/ammo_magazine/a556/a22 = 2, /obj/item/device/radio = 1)
	r_hand = /obj/item/weapon/gun/projectile/automatic/a22
	r_pocket = /obj/item/weapon/tank/emergency/oxygen
	l_pocket = /obj/item/ammo_magazine/a556/a22
	suit_store = /obj/item/weapon/gun/projectile/colt/a7

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/syndicate/station_access

/decl/hierarchy/outfit/SCOM
	name = "SCOM Operative"
	uniform = /obj/item/clothing/under/urist/scom
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/swat
	l_ear = /obj/item/device/radio/headset
	head = /obj/item/clothing/head/beret/sec/navy/officer
	belt = /obj/item/weapon/storage/belt/urist/military/scom
	r_pocket = /obj/item/weapon/gun/projectile/silenced/knight
	l_pocket = /obj/item/device/radio

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/syndicate/station_access

/decl/hierarchy/outfit/RDF
	name = "RDF Soldier"
	uniform = /obj/item/clothing/under/urist/ryclies/uniform
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/swat
	l_ear = /obj/item/device/radio/headset
	suit = /obj/item/clothing/suit/urist/armor/ryclies
	head = /obj/item/clothing/head/urist/ryclies/helmet
	back = /obj/item/weapon/storage/backpack/security
	backpack_contents = list(/obj/item/weapon/storage/firstaid/regular = 1, /obj/item/device/flashlight = 1,
		/obj/item/weapon/storage/box/kh50ammo = 1, /obj/item/weapon/plastique = 1)
	r_hand = /obj/item/weapon/gun/projectile/automatic/kh50
	r_pocket = /obj/item/ammo_magazine/a127x54mm
	l_pocket = /obj/item/device/radio

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/syndicate/station_access

/decl/hierarchy/outfit/conductor
	name = "Conductor"
	uniform = /obj/item/clothing/under/color/grey
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/white
	l_ear = /obj/item/device/radio/headset
	suit = /obj/item/clothing/suit/urist/conductor
	head = /obj/item/clothing/head/urist/conductor
	back = /obj/item/weapon/storage/backpack/satchel

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/centcom/station

/decl/hierarchy/outfit/wizard/dresden
	name = "Wizard - PI"
	uniform = /obj/item/clothing/under/urist/dresden
	head = /obj/item/clothing/head/wizard/urist/dresdendora
	suit = /obj/item/clothing/suit/wizrobe/urist/dresden
	shoes = /obj/item/clothing/shoes/black

/decl/hierarchy/outfit/wizard/necro
	name = "Wizard - Necromancer"
	uniform = /obj/item/clothing/under/color/black
	head = /obj/item/clothing/head/wizard/urist/necro
	suit = /obj/item/clothing/suit/wizrobe/urist/necro
	shoes = /obj/item/clothing/shoes/jackboots