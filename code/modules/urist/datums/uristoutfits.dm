/decl/hierarchy/outfit/ANTAG
	name = "ANTAG Operative"
	uniform = /obj/item/clothing/under/urist/suit_jacket/black{ starting_accessories=list(/obj/item/clothing/accessory/wcoat, /obj/item/clothing/accessory/red) }
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/thick
	l_ear = /obj/item/device/radio/headset
	glasses = /obj/item/clothing/glasses/sunglasses
	l_pocket = /obj/item/weapon/melee/energy/sword
	mask = /obj/item/clothing/mask/urist/bandana/bedsheet/red

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/syndicate/station_access
	pda_slot = slot_belt
	pda_type = /obj/item/modular_computer/pda/heads
	id_pda_assignment = "ANTAG Operative"

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
	shoes = /obj/item/clothing/shoes/urist/anforjackboots
	gloves = /obj/item/clothing/gloves/thick/swat
	l_ear = /obj/item/device/radio/headset
	//glasses = /obj/item/clothing/glasses/thermal
	suit = /obj/item/clothing/suit/urist/armor/anfor/marine
	head = /obj/item/clothing/head/helmet/urist/anfor
	//mask = /obj/item/clothing/mask/gas/swat
	back = /obj/item/weapon/storage/backpack/security
	backpack_contents = list(/obj/item/ammo_magazine/c45m/a7 = 1, /obj/item/weapon/storage/firstaid/combat = 1,
		/obj/item/device/flashlight = 1, /obj/item/ammo_magazine/a556/a22 = 2, /obj/item/device/radio = 1, /obj/item/weapon/storage/box/survival = 1)
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
	gloves = /obj/item/clothing/gloves/thick/swat
	l_ear = /obj/item/device/radio/headset
	head = /obj/item/clothing/head/beret/sec/navy/officer
	belt = /obj/item/weapon/storage/belt/urist/military/scom
	r_pocket = /obj/item/weapon/gun/projectile/silenced/knight
	l_pocket = /obj/item/device/radio

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/centcom
	id_pda_assignment = "SCOM Operative"

/decl/hierarchy/outfit/RDF
	name = "RDF Soldier"
	uniform = /obj/item/clothing/under/urist/ryclies/uniform
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/thick/swat
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
	id_type = /obj/item/weapon/card/id/centcom

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
	shoes = /obj/item/clothing/shoes/sandal/marisa

/decl/hierarchy/outfit/wizard/necro
	name = "Wizard - Necromancer"
	uniform = /obj/item/clothing/under/color/black
	head = /obj/item/clothing/head/wizard/urist/necro
	suit = /obj/item/clothing/suit/wizrobe/urist/necro
	shoes = /obj/item/clothing/shoes/sandal/marisa

//electrician

/decl/hierarchy/outfit/job/engineering/electrician
	name = OUTFIT_JOB_NAME("Electrician")
	suit = /obj/item/clothing/suit/storage/urist/overalls/electricians
	id_type = /obj/item/weapon/card/id/engineering

/* World War 13 */
/decl/hierarchy/outfit/wwii
	name = "Naked, 1941-style" //just to shut Travis up

/decl/hierarchy/outfit/wwii/germanrifleman
	name = "German Rifleman"
	head = /obj/item/clothing/head/helmet/urist/wwii/germanhelm
	uniform = /obj/item/clothing/under/urist/wwii/germanrifleman
	shoes = /obj/item/clothing/shoes/urist/wwii/germanboots
	back = /obj/item/weapon/gun/projectile/manualcycle/kar98
	r_pocket = /obj/item/weapon/grenade/stielhandgranate
	l_pocket = /obj/item/ammo_magazine/a792x57mm/stripper
	r_hand = /obj/item/ammo_magazine/a792x57mm/stripper
	l_hand = /obj/item/ammo_magazine/a792x57mm/stripper
	belt = 	/obj/item/ammo_magazine/a792x57mm/stripper

/decl/hierarchy/outfit/wwii/germanrifleman/pre_equip(mob/living/carbon/human/H)
	if(prob(10))
		back = /obj/item/weapon/gun/projectile/automatic/stg44
		l_pocket = /obj/item/ammo_magazine/a792x33mm
		r_hand = /obj/item/ammo_magazine/a792x33mm
		l_hand = /obj/item/ammo_magazine/a792x33mm
		belt = 	/obj/item/ammo_magazine/a792x33mm

	else if(prob(10))
		back = /obj/item/weapon/gun/projectile/g43
		l_pocket = /obj/item/ammo_magazine/a792x57mm/g43mag
		r_hand = /obj/item/ammo_magazine/a792x57mm/g43mag
		l_hand = /obj/item/ammo_magazine/a792x57mm/g43mag
		belt = 	/obj/item/ammo_magazine/a792x57mm/g43mag

	else if(prob(5))
		back = /obj/item/weapon/gun/projectile/automatic/l6_saw/mg42
		l_pocket = /obj/item/weapon/grenade/stielhandgranate
		r_hand = /obj/item/ammo_magazine/a792x57mm/mg42
		l_hand = /obj/item/ammo_magazine/a792x57mm/mg42
		belt = 	/obj/item/ammo_magazine/a792x57mm/g43mag

	else
		return

/decl/hierarchy/outfit/wwii/germanrifleman/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/storage/webbing_german/gear = new()
		if(uniform.can_attach_accessory(gear))
			uniform.attach_accessory(null, gear)
		else
			qdel(gear)

/decl/hierarchy/outfit/wwii/germanofficer
	name = "German Officer"
	head = /obj/item/clothing/head/urist/wwii/germanofficer
	uniform = /obj/item/clothing/under/urist/wwii/germanofficer
	shoes = /obj/item/clothing/shoes/urist/wwii/germanboots
	back = /obj/item/weapon/gun/projectile/automatic/mp40
	r_pocket = /obj/item/weapon/grenade/stielhandgranate
	l_pocket = /obj/item/ammo_magazine/mc9mm/mp40
	r_hand = /obj/item/ammo_magazine/mc9mm/mp40
	l_hand = /obj/item/ammo_magazine/mc9mm/p38
	belt = /obj/item/weapon/gun/projectile/p38

/decl/hierarchy/outfit/wwii/germanofficer/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/storage/webbing_german/gear = new()
		if(uniform.can_attach_accessory(gear))
			uniform.attach_accessory(null, gear)
		else
			qdel(gear)

/decl/hierarchy/outfit/wwii/sovietrifleman
	name = "Soviet Rifleman"
	head = /obj/item/clothing/head/helmet/urist/wwii/soviethelm
	uniform = /obj/item/clothing/under/urist/wwii/sovietrifleman
	shoes = /obj/item/clothing/shoes/urist/wwii/sovietboots
	back = /obj/item/weapon/gun/projectile/manualcycle/mosinnagant
	r_pocket = /obj/item/weapon/grenade/frag/sovietgrenade
	l_pocket = /obj/item/ammo_magazine/a762mm/stripper
	r_hand = /obj/item/ammo_magazine/a762mm/stripper
	l_hand = /obj/item/ammo_magazine/a762mm/stripper
	belt = /obj/item/ammo_magazine/a762mm/stripper

/decl/hierarchy/outfit/wwii/sovietrifleman/pre_equip(mob/living/carbon/human/H)
	if(prob(5))
		back = /obj/item/weapon/gun/projectile/automatic/ppsh
		l_pocket = /obj/item/ammo_magazine/mc9mm/ppsh
		r_hand = /obj/item/ammo_magazine/mc9mm/ppsh
		l_hand = /obj/item/ammo_magazine/mc9mm/ppsh
		belt = /obj/item/ammo_magazine/mc9mm/ppsh

	else if(prob(10))
		back = /obj/item/weapon/gun/projectile/svt40
		l_pocket = /obj/item/ammo_magazine/a762mm/svt40mag
		r_hand = /obj/item/ammo_magazine/a762mm/svt40mag
		l_hand = /obj/item/ammo_magazine/a762mm/svt40mag
		belt = /obj/item/ammo_magazine/a762mm/svt40mag

	else if(prob(5))
		back = /obj/item/weapon/gun/projectile/automatic/degtyaryov
		l_pocket = /obj/item/ammo_magazine/a762mm/degtyaryov
		r_hand = /obj/item/ammo_magazine/a762mm/degtyaryov
		l_hand = /obj/item/ammo_magazine/a762mm/degtyaryov
		belt = 	/obj/item/ammo_magazine/a762mm/degtyaryov

	else if(prob(1)) //why not a BAR
		back = /obj/item/weapon/gun/projectile/automatic/bar
		l_pocket = /obj/item/ammo_magazine/a762mm/barmag
		r_hand = /obj/item/ammo_magazine/a762mm/barmag
		l_hand = /obj/item/ammo_magazine/a762mm/barmag
		belt = 	/obj/item/ammo_magazine/a762mm/barmag

	else
		return

/decl/hierarchy/outfit/wwii/sovietrifleman/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/storage/webbing_soviet/gear = new()
		if(uniform.can_attach_accessory(gear))
			uniform.attach_accessory(null, gear)
		else
			qdel(gear)

/decl/hierarchy/outfit/wwii/sovietofficer
	name = "Soviet Officer"
	head = /obj/item/clothing/head/urist/wwii/sovietofficer
	uniform = /obj/item/clothing/under/urist/wwii/sovietofficer
	shoes = /obj/item/clothing/shoes/urist/wwii/sovietboots
	back = /obj/item/weapon/gun/projectile/automatic/ppsh
	r_pocket = /obj/item/weapon/grenade/frag/sovietgrenade
	l_pocket = /obj/item/ammo_magazine/mc9mm/ppsh
	r_hand = /obj/item/ammo_magazine/mc9mm/ppsh
	l_hand = /obj/item/ammo_magazine/mc9mm/tt33
	belt = /obj/item/weapon/gun/projectile/tt33

/decl/hierarchy/outfit/wwii/sovietofficer/pre_equip(mob/living/carbon/human/H)
	if(prob(50))
		l_hand = /obj/item/ammo_magazine/r762
		belt = /obj/item/weapon/gun/projectile/revolver/nagantm1895
		suit = /obj/item/clothing/suit/urist/wwii/soviet //full commissar
		suit_store = /obj/item/ammo_magazine/r762
	else
		return

/decl/hierarchy/outfit/wwii/sovietofficer/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/storage/webbing_soviet/gear = new()
		if(uniform.can_attach_accessory(gear))
			uniform.attach_accessory(null, gear)
		else
			qdel(gear)

/decl/hierarchy/outfit/lactera
	name = "Lactera Soldier"
	uniform = /obj/item/clothing/under/lactera
	shoes = /obj/item/clothing/shoes/magboots/lactera
	glasses = /obj/item/clothing/glasses/night
	suit = /obj/item/clothing/suit/lactera/regular
	belt = /obj/item/weapon/gun/energy/lactera/a1
	r_hand = /obj/item/weapon/gun/energy/lactera/a3
	r_pocket = /obj/item/weapon/grenade/aliengrenade
	l_pocket = /obj/item/weapon/plastique/alienexplosive
	head = /obj/item/clothing/head/lactera/regular

/decl/hierarchy/outfit/lactera/heavy
	name = "Lactera Heavy"
	uniform = /obj/item/clothing/under/lactera
	shoes = /obj/item/clothing/shoes/magboots/lactera
	glasses = /obj/item/clothing/glasses/night
	suit = /obj/item/clothing/suit/lactera/max
	belt = /obj/item/weapon/gun/energy/lactera/a1
	r_hand = /obj/item/weapon/gun/energy/lactera/a4
	r_pocket = /obj/item/weapon/grenade/aliengrenade
	l_pocket = /obj/item/weapon/plastique/alienexplosive
	head = /obj/item/clothing/head/lactera/max

/decl/hierarchy/outfit/lactera/officer
	name = "Lactera Officer"
	uniform = /obj/item/clothing/under/lactera
	shoes = /obj/item/clothing/shoes/magboots/lactera
	glasses = /obj/item/clothing/glasses/night
	suit = /obj/item/clothing/suit/lactera/officer
	belt = /obj/item/weapon/gun/energy/lactera/a1
	r_hand = /obj/item/weapon/gun/energy/lactera/a2
	r_pocket = /obj/item/weapon/grenade/aliengrenade
	l_pocket = /obj/item/weapon/plastique/alienexplosive
	head = /obj/item/clothing/head/lactera/cmd

/decl/hierarchy/outfit/terranmarine
	name = "Terran Marine"
	uniform = /obj/item/clothing/under/urist/terran/marine
	mask = /obj/item/clothing/mask/gas/terranhalf
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/thick/swat
	l_ear = /obj/item/device/radio/headset
	suit = /obj/item/clothing/suit/storage/urist/terran_marine
	head = /obj/item/clothing/head/helmet/urist/terran_marine
	back = /obj/item/weapon/storage/backpack/rucksack/tan
	backpack_contents = list(/obj/item/ammo_magazine/c45m/a7 = 1, /obj/item/weapon/storage/firstaid/regular = 1,
		/obj/item/device/flashlight = 1, /obj/item/ammo_magazine/a556/a22 = 2, /obj/item/device/radio = 1)
	r_hand = /obj/item/weapon/gun/projectile/automatic/a22
	r_pocket = /obj/item/device/radio
	l_pocket = /obj/item/ammo_magazine/a556/a22
	suit_store = /obj/item/weapon/gun/projectile/colt/a7
	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/centcom

/decl/hierarchy/outfit/terranmarinespace
	name = "Terran Marine - Space"
	uniform = /obj/item/clothing/under/urist/terran/marine
	mask = /obj/item/clothing/mask/gas/terranhalf
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/thick/swat
	l_ear = /obj/item/device/radio/headset
	suit = /obj/item/clothing/suit/space/void/terran_marine
	head = /obj/item/clothing/head/helmet/space/void/terran_marine
	back = /obj/item/weapon/storage/backpack/security
	backpack_contents = list(/obj/item/ammo_magazine/c45m/a7 = 1, /obj/item/weapon/storage/firstaid/combat = 1,
		/obj/item/device/flashlight = 1, /obj/item/ammo_magazine/a556/a22 = 2, /obj/item/weapon/plastique = 1, /obj/item/weapon/gun/projectile/colt/a7 = 1)
	r_hand = /obj/item/weapon/gun/projectile/automatic/a22
	r_pocket = /obj/item/device/radio
	l_pocket = /obj/item/ammo_magazine/a556/a22
	suit_store = /obj/item/weapon/tank/oxygen
	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/centcom

/decl/hierarchy/outfit/terranofficer
	name = "Terran Officer"
	uniform = /obj/item/clothing/under/urist/terran/marine
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/thick/swat
	l_ear = /obj/item/device/radio/headset
	suit = /obj/item/clothing/suit/storage/urist/terran_officer
	head = /obj/item/clothing/head/urist/terran/officercap
	back = /obj/item/weapon/storage/backpack/urist/explorersatchel
	backpack_contents = list(/obj/item/ammo_magazine/c45m/a7 = 1, /obj/item/weapon/storage/firstaid/combat = 1,
		/obj/item/device/flashlight = 1, /obj/item/ammo_magazine/a9mm = 2, /obj/item/weapon/tank/emergency/oxygen = 1, /obj/item/clothing/mask/gas/terranhalf = 1)
	r_hand = /obj/item/weapon/gun/projectile/automatic/asmg
	r_pocket = /obj/item/device/radio
	l_pocket = /obj/item/ammo_magazine/a9mm
	suit_store = /obj/item/weapon/gun/projectile/colt/a7
	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/centcom

//new pirates

/decl/hierarchy/outfit/newpirate
	name = "New Pirate - Laser"
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/armor/pcarrier/light/hijacker
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/mask/bandana/red
	l_hand = /obj/item/weapon/gun/energy/laser
	flags = OUTFIT_HAS_BACKPACK

/decl/hierarchy/outfit/newpirate/melee
	name = "New Pirate - Melee"
	glasses = /obj/item/clothing/glasses/eyepatch
	head = /obj/item/clothing/head/helmet/tactical
	suit = /obj/item/clothing/suit/pirate
	l_hand = /obj/item/weapon/melee/energy/sword/pirate
	gloves = /obj/item/clothing/gloves/guards

/decl/hierarchy/outfit/newpirate/melee/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/kneepads/gear = new()
		if(uniform.can_attach_accessory(gear))
			uniform.attach_accessory(null, gear)
		else
			qdel(gear)

/decl/hierarchy/outfit/newpirate/ballistic
	name = "New Pirate - Ballistic"
	gloves = /obj/item/clothing/gloves/thick
	glasses = /obj/item/clothing/glasses/tacgoggles
	l_hand = /obj/item/weapon/gun/projectile/automatic/spaceak
	r_pocket = /obj/item/ammo_magazine/a762mm/spaceak
	l_pocket = /obj/item/ammo_magazine/a762mm/spaceak
	uniform = /obj/item/clothing/under/syndicate/pirate
	suit = null