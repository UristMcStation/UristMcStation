/singleton/hierarchy/outfit/ANTAG
	name = "ANTAG Operative"
	uniform = /obj/item/clothing/under/urist/suit_jacket/black{ accessories=list(/obj/item/clothing/accessory/wcoat, /obj/item/clothing/accessory/red) }
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/thick
	l_ear = /obj/item/device/radio/headset
	glasses = /obj/item/clothing/glasses/sunglasses
	l_pocket = /obj/item/melee/energy/sword
	mask = /obj/item/clothing/mask/urist/bandana/bedsheet/red

	id_slot = slot_wear_id
	id_types = list(/obj/item/card/id/syndicate/station_access)
	pda_slot = slot_belt
	pda_type = /obj/item/modular_computer/pda/heads
	id_pda_assignment = "ANTAG Operative"

/singleton/hierarchy/outfit/ANTAG/post_equip(mob/living/carbon/human/H)
	var/obj/item/storage/secure/briefcase/sec_briefcase = new(H)
	for(var/obj/item/briefcase_item in sec_briefcase)
		qdel(briefcase_item)
	sec_briefcase.contents += new /obj/item/clothing/accessory/storage/webbing
	sec_briefcase.contents += new /obj/item/gun/projectile/pistol
	sec_briefcase.contents += new /obj/item/ammo_magazine/pistol
	sec_briefcase.contents += new /obj/item/ammo_magazine/pistol
	sec_briefcase.contents += new /obj/item/grenade/empgrenade(src)
	H.equip_to_slot_or_del(sec_briefcase, slot_l_hand)

	//M.mutations.Add(COLD_RESISTANCE)
	//for(var/i=3, i>0, i--)
	//	randmutg(M) //3 random good mutations on top (hopefully) of cold resistance
	//M.update_mutations() //otherwise weirdness occurs

/singleton/hierarchy/outfit/ANFOR
	name = "ANFOR Marine"
	uniform = /obj/item/clothing/under/urist/anfor
	shoes = /obj/item/clothing/shoes/urist/anforjackboots
	gloves = /obj/item/clothing/gloves/thick/swat
	l_ear = /obj/item/device/radio/headset
	//glasses = /obj/item/clothing/glasses/thermal
	suit = /obj/item/clothing/suit/storage/urist/armor/anfor/marine
	head = /obj/item/clothing/head/helmet/urist/anfor
	//mask = /obj/item/clothing/mask/gas/swat
	back = /obj/item/storage/backpack/security
	backpack_contents = list(/obj/item/ammo_magazine/pistol/a7 = 1, /obj/item/storage/firstaid/combat = 1,
		/obj/item/device/flashlight = 1, /obj/item/ammo_magazine/rifle/a22 = 2, /obj/item/device/radio = 1, /obj/item/storage/box/survival = 1)
	r_hand = /obj/item/gun/projectile/automatic/a22
	r_pocket = /obj/item/tank/oxygen_emergency
	l_pocket = /obj/item/ammo_magazine/rifle/a22
	suit_store = /obj/item/gun/projectile/pistol/colt/a7

	id_slot = slot_wear_id
	id_types = list(/obj/item/card/id/syndicate/station_access)

/singleton/hierarchy/outfit/SCOM
	name = "SCOM Operative"
	uniform = /obj/item/clothing/under/urist/scom
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/thick/swat
	l_ear = /obj/item/device/radio/headset
	head = /obj/item/clothing/head/beret/sec/navy/officer
	belt = /obj/item/storage/belt/urist/military/scom
	r_pocket = /obj/item/gun/projectile/silenced/knight
	l_pocket = /obj/item/device/radio

	id_slot = slot_wear_id
	id_types = list(/obj/item/card/id/centcom)
	id_pda_assignment = "SCOM Operative"

/singleton/hierarchy/outfit/RDF
	name = "RDF Soldier"
	uniform = /obj/item/clothing/under/urist/ryclies/uniform
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/thick/swat
	l_ear = /obj/item/device/radio/headset
	suit = /obj/item/clothing/suit/urist/armor/ryclies
	head = /obj/item/clothing/head/urist/ryclies/helmet
	back = /obj/item/storage/backpack/security
	backpack_contents = list(/obj/item/storage/firstaid/regular = 1, /obj/item/device/flashlight = 1,
		/obj/item/storage/box/kh50ammo = 1, /obj/item/plastique = 1)
	r_hand = /obj/item/gun/projectile/automatic/kh50
	r_pocket = /obj/item/ammo_magazine/a127x54mm
	l_pocket = /obj/item/device/radio

	id_slot = slot_wear_id
	id_types = list(/obj/item/card/id/centcom)

/singleton/hierarchy/outfit/conductor
	name = "Conductor"
	uniform = /obj/item/clothing/under/color/grey
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/white
	l_ear = /obj/item/device/radio/headset
	suit = /obj/item/clothing/suit/urist/conductor
	head = /obj/item/clothing/head/urist/conductor
	back = /obj/item/storage/backpack/satchel

	id_slot = slot_wear_id
	id_types = list(/obj/item/card/id/centcom/station)

/singleton/hierarchy/outfit/wizard/dresden
	name = "Wizard - PI"
	uniform = /obj/item/clothing/under/urist/dresden
	head = /obj/item/clothing/head/wizard/urist/dresdendora
	suit = /obj/item/clothing/suit/wizrobe/urist/dresden
	shoes = /obj/item/clothing/shoes/sandal/marisa

/singleton/hierarchy/outfit/wizard/necro
	name = "Wizard - Necromancer"
	uniform = /obj/item/clothing/under/color/black
	head = /obj/item/clothing/head/wizard/urist/necro
	suit = /obj/item/clothing/suit/wizrobe/urist/necro
	shoes = /obj/item/clothing/shoes/sandal/marisa

//electrician

/singleton/hierarchy/outfit/job/engineering/electrician
	name = OUTFIT_JOB_NAME("Electrician")
	suit = /obj/item/clothing/suit/storage/urist/overalls/electricians
	id_types = list(/obj/item/card/id/engineering)

/* World War 13 */
/singleton/hierarchy/outfit/wwii
	name = "Naked, 1941-style" //just to shut Travis up

/singleton/hierarchy/outfit/wwii/germanrifleman
	name = "German Rifleman"
	head = /obj/item/clothing/head/helmet/urist/wwii/germanhelm
	uniform = /obj/item/clothing/under/urist/wwii/germanrifleman
	shoes = /obj/item/clothing/shoes/urist/wwii/germanboots
	back = /obj/item/gun/projectile/manualcycle/kar98
	r_pocket = /obj/item/grenade/stielhandgranate
	l_pocket = /obj/item/ammo_magazine/a792x57mm/stripper
	r_hand = /obj/item/ammo_magazine/a792x57mm/stripper
	l_hand = /obj/item/ammo_magazine/a792x57mm/stripper
	belt = 	/obj/item/ammo_magazine/a792x57mm/stripper

/singleton/hierarchy/outfit/wwii/germanrifleman/pre_equip(mob/living/carbon/human/H)
	if(prob(10))
		back = /obj/item/gun/projectile/automatic/stg44
		l_pocket = /obj/item/ammo_magazine/a792x33mm
		r_hand = /obj/item/ammo_magazine/a792x33mm
		l_hand = /obj/item/ammo_magazine/a792x33mm
		belt = 	/obj/item/ammo_magazine/a792x33mm

	else if(prob(10))
		back = /obj/item/gun/projectile/g43
		l_pocket = /obj/item/ammo_magazine/a792x57mm/g43mag
		r_hand = /obj/item/ammo_magazine/a792x57mm/g43mag
		l_hand = /obj/item/ammo_magazine/a792x57mm/g43mag
		belt = 	/obj/item/ammo_magazine/a792x57mm/g43mag

	else if(prob(5))
		back = /obj/item/gun/projectile/automatic/l6_saw/mg42
		l_pocket = /obj/item/grenade/stielhandgranate
		r_hand = /obj/item/ammo_magazine/a792x57mm/mg42
		l_hand = /obj/item/ammo_magazine/a792x57mm/mg42
		belt = 	/obj/item/ammo_magazine/a792x57mm/g43mag

	else
		return

/singleton/hierarchy/outfit/wwii/germanrifleman/post_equip(mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/storage/webbing_german/gear = new()
		if(uniform.can_attach_accessory(gear))
			uniform.attach_accessory(null, gear)
		else
			qdel(gear)

/singleton/hierarchy/outfit/wwii/germanofficer
	name = "German Officer"
	head = /obj/item/clothing/head/urist/wwii/germanofficer
	uniform = /obj/item/clothing/under/urist/wwii/germanofficer
	shoes = /obj/item/clothing/shoes/urist/wwii/germanboots
	back = /obj/item/gun/projectile/automatic/mp40
	r_pocket = /obj/item/grenade/stielhandgranate
	l_pocket = /obj/item/ammo_magazine/pistol/mp40
	r_hand = /obj/item/ammo_magazine/pistol/mp40
	l_hand = /obj/item/ammo_magazine/pistol/p38
	belt = /obj/item/gun/projectile/p38

/singleton/hierarchy/outfit/wwii/germanofficer/post_equip(mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/storage/webbing_german/gear = new()
		if(uniform.can_attach_accessory(gear))
			uniform.attach_accessory(null, gear)
		else
			qdel(gear)

/singleton/hierarchy/outfit/wwii/sovietrifleman
	name = "Soviet Rifleman"
	head = /obj/item/clothing/head/helmet/urist/wwii/soviethelm
	uniform = /obj/item/clothing/under/urist/wwii/sovietrifleman
	shoes = /obj/item/clothing/shoes/urist/wwii/sovietboots
	back = /obj/item/gun/projectile/manualcycle/mosinnagant
	r_pocket = /obj/item/grenade/frag/sovietgrenade
	l_pocket = /obj/item/ammo_magazine/speedloader/clip
	r_hand = /obj/item/ammo_magazine/speedloader/clip
	l_hand = /obj/item/ammo_magazine/speedloader/clip
	belt = /obj/item/ammo_magazine/speedloader/clip

/singleton/hierarchy/outfit/wwii/sovietrifleman/pre_equip(mob/living/carbon/human/H)
	if(prob(5))
		back = /obj/item/gun/projectile/automatic/ppsh
		l_pocket = /obj/item/ammo_magazine/pistol/ppsh
		r_hand = /obj/item/ammo_magazine/pistol/ppsh
		l_hand = /obj/item/ammo_magazine/pistol/ppsh
		belt = /obj/item/ammo_magazine/pistol/ppsh

	else if(prob(10))
		back = /obj/item/gun/projectile/svt40
		l_pocket = /obj/item/ammo_magazine/rifle/military/svt40mag
		r_hand = /obj/item/ammo_magazine/rifle/military/svt40mag
		l_hand = /obj/item/ammo_magazine/rifle/military/svt40mag
		belt = /obj/item/ammo_magazine/rifle/military/svt40mag

	else if(prob(5))
		back = /obj/item/gun/projectile/automatic/degtyaryov
		l_pocket = /obj/item/ammo_magazine/rifle/military/degtyaryov
		r_hand = /obj/item/ammo_magazine/rifle/military/degtyaryov
		l_hand = /obj/item/ammo_magazine/rifle/military/degtyaryov
		belt = 	/obj/item/ammo_magazine/rifle/military/degtyaryov

	else if(prob(1)) //why not a BAR
		back = /obj/item/gun/projectile/automatic/bar
		l_pocket = /obj/item/ammo_magazine/rifle/military/barmag
		r_hand = /obj/item/ammo_magazine/rifle/military/barmag
		l_hand = /obj/item/ammo_magazine/rifle/military/barmag
		belt = 	/obj/item/ammo_magazine/rifle/military/barmag

	else
		return

/singleton/hierarchy/outfit/wwii/sovietrifleman/post_equip(mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/storage/webbing_soviet/gear = new()
		if(uniform.can_attach_accessory(gear))
			uniform.attach_accessory(null, gear)
		else
			qdel(gear)

/singleton/hierarchy/outfit/wwii/sovietofficer
	name = "Soviet Officer"
	head = /obj/item/clothing/head/urist/wwii/sovietofficer
	uniform = /obj/item/clothing/under/urist/wwii/sovietofficer
	shoes = /obj/item/clothing/shoes/urist/wwii/sovietboots
	back = /obj/item/gun/projectile/automatic/ppsh
	r_pocket = /obj/item/grenade/frag/sovietgrenade
	l_pocket = /obj/item/ammo_magazine/pistol/ppsh
	r_hand = /obj/item/ammo_magazine/pistol/ppsh
	l_hand = /obj/item/ammo_magazine/pistol/tt33
	belt = /obj/item/gun/projectile/pistol/tt33

/singleton/hierarchy/outfit/wwii/sovietofficer/pre_equip(mob/living/carbon/human/H)
	if(prob(50))
		l_hand = /obj/item/ammo_magazine/r762
		belt = /obj/item/gun/projectile/revolver/nagantm1895
		suit = /obj/item/clothing/suit/urist/wwii/soviet //full commissar
		suit_store = /obj/item/ammo_magazine/r762
	else
		return

/singleton/hierarchy/outfit/wwii/sovietofficer/post_equip(mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/storage/webbing_soviet/gear = new()
		if(uniform.can_attach_accessory(gear))
			uniform.attach_accessory(null, gear)
		else
			qdel(gear)

//lactera outfits

/singleton/hierarchy/outfit/lactera
	name = "Lactera Soldier"
	uniform = /obj/item/clothing/under/lactera
	shoes = /obj/item/clothing/shoes/magboots/lactera
	glasses = /obj/item/clothing/glasses/night
	suit = /obj/item/clothing/suit/lactera/regular
	belt = /obj/item/gun/energy/lactera/a1
	r_hand = /obj/item/gun/energy/lactera/a3
	r_pocket = /obj/item/grenade/aliengrenade
	l_pocket = /obj/item/plastique/alienexplosive
	head = /obj/item/clothing/head/lactera/regular

/singleton/hierarchy/outfit/lactera/heavy
	name = "Lactera Heavy"
	uniform = /obj/item/clothing/under/lactera
	shoes = /obj/item/clothing/shoes/magboots/lactera
	glasses = /obj/item/clothing/glasses/night
	suit = /obj/item/clothing/suit/lactera/max
	belt = /obj/item/gun/energy/lactera/a1
	r_hand = /obj/item/gun/energy/lactera/a4
	r_pocket = /obj/item/grenade/aliengrenade
	l_pocket = /obj/item/plastique/alienexplosive
	head = /obj/item/clothing/head/lactera/max

/singleton/hierarchy/outfit/lactera/officer
	name = "Lactera Officer"
	uniform = /obj/item/clothing/under/lactera
	shoes = /obj/item/clothing/shoes/magboots/lactera
	glasses = /obj/item/clothing/glasses/night
	suit = /obj/item/clothing/suit/lactera/officer
	belt = /obj/item/gun/energy/lactera/a1
	r_hand = /obj/item/gun/energy/lactera/a2
	r_pocket = /obj/item/grenade/aliengrenade
	l_pocket = /obj/item/plastique/alienexplosive
	head = /obj/item/clothing/head/lactera/cmd

//terran outfits

/singleton/hierarchy/outfit/terranmarine
	name = "Terran Marine - Naval Service"
	uniform = /obj/item/clothing/under/urist/terran/marine
	mask = /obj/item/clothing/mask/gas/terranhalf
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/thick/swat
	l_ear = /obj/item/device/radio/headset
	suit = /obj/item/clothing/suit/storage/urist/terran_marine
	head = /obj/item/clothing/head/helmet/urist/terran_marine
	back = /obj/item/storage/backpack/rucksack/tan
	backpack_contents = list(/obj/item/ammo_magazine/pistol/a7 = 1, /obj/item/storage/firstaid/regular = 1,
		/obj/item/device/flashlight = 1, /obj/item/ammo_magazine/rifle/a22 = 2, /obj/item/device/radio = 1)
	r_hand = /obj/item/gun/projectile/automatic/a22
	r_pocket = /obj/item/device/radio
	l_pocket = /obj/item/ammo_magazine/rifle/a22
	suit_store = /obj/item/gun/projectile/pistol/colt/a7
	id_slot = slot_wear_id
	id_types = list(/obj/item/card/id/terran/marine)

/singleton/hierarchy/outfit/terranmarine/space
	name = "Terran Marine - Naval Service EVA"
	uniform = /obj/item/clothing/under/urist/terran/marine
	mask = /obj/item/clothing/mask/gas/terranhalf
	suit = /obj/item/clothing/suit/space/void/terran_marine
	head = /obj/item/clothing/head/helmet/space/void/terran_marine
	back = /obj/item/storage/backpack/security
	backpack_contents = list(/obj/item/ammo_magazine/pistol/a7 = 1, /obj/item/storage/firstaid/combat = 1,
		/obj/item/device/flashlight = 1, /obj/item/ammo_magazine/rifle/a22 = 2, /obj/item/plastique = 1, /obj/item/gun/projectile/pistol/colt/a7 = 1)
	r_hand = /obj/item/gun/projectile/automatic/a22
	r_pocket = /obj/item/device/radio
	l_pocket = /obj/item/ammo_magazine/rifle/a22
	suit_store = /obj/item/tank/oxygen

/singleton/hierarchy/outfit/terranmarine/officer
	name = "Terran Officer - Naval Service"
	uniform = /obj/item/clothing/under/urist/terran/marine
	suit = /obj/item/clothing/suit/storage/urist/terran_officer
	head = /obj/item/clothing/head/urist/terran/officercap
	back = /obj/item/storage/backpack/urist/explorersatchel
	backpack_contents = list(/obj/item/ammo_magazine/pistol/a7 = 1, /obj/item/storage/firstaid/combat = 1,
		/obj/item/device/flashlight = 1, /obj/item/ammo_magazine/a9mm = 2, /obj/item/tank/oxygen_emergency = 1, /obj/item/clothing/mask/gas/terranhalf = 1)
	r_hand = /obj/item/gun/projectile/automatic/asmg
	r_pocket = /obj/item/device/radio
	l_pocket = /obj/item/ammo_magazine/a9mm
	suit_store = /obj/item/gun/projectile/pistol/colt/a7

/singleton/hierarchy/outfit/terranmarine/ground
	name = "Terran Marine - Ground Assault"
	uniform = /obj/item/clothing/under/urist/anfor/terran
	suit = /obj/item/clothing/suit/storage/urist/armor/anfor/terran
	head = /obj/item/clothing/head/helmet/urist/anfor/terran
	back = /obj/item/storage/backpack/rucksack/green
	backpack_contents = list(/obj/item/ammo_magazine/pistol/a7 = 1, /obj/item/storage/firstaid/regular = 1,
		/obj/item/device/flashlight = 1, /obj/item/ammo_magazine/rifle/a22 = 2, /obj/item/device/radio = 1)
	r_hand = /obj/item/gun/projectile/automatic/a22
	r_pocket = /obj/item/device/radio
	l_pocket = /obj/item/ammo_magazine/rifle/a22
	suit_store = /obj/item/gun/projectile/pistol/colt/a7

/singleton/hierarchy/outfit/terranmarine/groundspace
	name = "Terran Marine - Ground Assault EVA"
	uniform = /obj/item/clothing/under/urist/anfor/terran
	mask = /obj/item/clothing/mask/gas/terranhalf
	suit = /obj/item/clothing/head/helmet/space/void/terran_marine
	head = /obj/item/clothing/head/helmet/space/void/anfor/terran
	back = /obj/item/storage/backpack/security
	backpack_contents = list(/obj/item/ammo_magazine/pistol/a7 = 1, /obj/item/storage/firstaid/combat = 1,
		/obj/item/device/flashlight = 1, /obj/item/ammo_magazine/rifle/military/a18 = 2, /obj/item/plastique = 1, /obj/item/gun/projectile/pistol/colt/a7 = 1)
	r_hand = /obj/item/gun/projectile/a18
	r_pocket = /obj/item/device/radio
	l_pocket = /obj/item/ammo_magazine/rifle/military/a18
	suit_store = /obj/item/tank/oxygen

/singleton/hierarchy/outfit/terranmarine/groundofficer
	name = "Terran Officer - Ground Assault"
	uniform = /obj/item/clothing/under/urist/anfor/terran
	suit = /obj/item/clothing/suit/storage/urist/armor/anfor/terran/nco
	head = /obj/item/clothing/head/urist/anfor/terran
	back = /obj/item/storage/backpack/urist/explorersatchel
	backpack_contents = list(/obj/item/ammo_magazine/pistol/a7 = 1, /obj/item/storage/firstaid/combat = 1,
		/obj/item/device/flashlight = 1, /obj/item/ammo_magazine/a9mm = 2, /obj/item/tank/oxygen_emergency = 1, /obj/item/clothing/mask/gas/terranhalf = 1)
	r_hand = /obj/item/gun/projectile/automatic/asmg
	r_pocket = /obj/item/device/radio
	l_pocket = /obj/item/ammo_magazine/a9mm
	suit_store = /obj/item/gun/projectile/pistol/colt/a7

//new pirates

/singleton/hierarchy/outfit/newpirate
	name = "New Pirate - Laser"
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/armor/pcarrier/light/hijacker
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/mask/bandana/red
	l_hand = /obj/item/gun/energy/laser
	flags = OUTFIT_HAS_BACKPACK

/singleton/hierarchy/outfit/newpirate/elite
	name = "New Pirate - Laser: Elite"
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/space/void/syndistealth/pirate
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/helmet/space/void/syndistealth/pirate
	l_hand = /obj/item/gun/energy/laser
	flags = OUTFIT_HAS_BACKPACK
	suit_store = /obj/item/tank/oxygen

/singleton/hierarchy/outfit/newpirate/melee
	name = "New Pirate - Melee"
	glasses = /obj/item/clothing/glasses/eyepatch
	head = /obj/item/clothing/head/helmet/tactical
	suit = /obj/item/clothing/suit/pirate
	l_hand = /obj/item/melee/energy/sword/pirate
	gloves = /obj/item/clothing/gloves/guards

/singleton/hierarchy/outfit/newpirate/melee/post_equip(mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/kneepads/gear = new()
		if(uniform.can_attach_accessory(gear))
			uniform.attach_accessory(null, gear)
		else
			qdel(gear)

/singleton/hierarchy/outfit/newpirate/ballistic
	name = "New Pirate - Ballistic"
	gloves = /obj/item/clothing/gloves/thick
	glasses = /obj/item/clothing/glasses/tacgoggles
	l_hand = /obj/item/gun/projectile/automatic/spaceak
	r_pocket = /obj/item/ammo_magazine/rifle/military/spaceak
	l_pocket = /obj/item/ammo_magazine/rifle/military/spaceak
	uniform = /obj/item/clothing/under/syndicate/pirate
	suit = null

/singleton/hierarchy/outfit/newpirate/ballistic/space
	name = "New Pirate - Ballistic: Space"
	gloves = /obj/item/clothing/gloves/thick
	glasses = /obj/item/clothing/glasses/tacgoggles
	l_hand = /obj/item/gun/projectile/automatic/spaceak
	r_pocket = /obj/item/ammo_magazine/rifle/military/spaceak
	l_pocket = /obj/item/ammo_magazine/rifle/military/spaceak
	uniform = /obj/item/clothing/under/syndicate/pirate
	suit = /obj/item/clothing/suit/space/syndicate/black/pirate
	head = /obj/item/clothing/head/helmet/space/syndicate/black/pirate
	suit_store = /obj/item/tank/oxygen
