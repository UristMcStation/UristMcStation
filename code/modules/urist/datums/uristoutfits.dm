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
/singleton/hierarchy/outfit/ww2
	name = "WW2 - Naked, 1941-style" //just to shut Travis up

/singleton/hierarchy/outfit/ww2/german // copypasta-ing nam shit and changing it, doubt this'll ever get used anyways.
	name = "WW2 - German Rifleman"
	head = /obj/item/clothing/head/helmet/urist/ww2/germanhelm
	uniform = /obj/item/clothing/under/urist/ww2/germanrifleman
	shoes = /obj/item/clothing/shoes/urist/ww2/germanboots
	back = /obj/item/storage/backpack/urist/ww2/german
	backpack_contents = list(
		/obj/item/ammo_magazine/ww2/stripper_mauser = 4, /obj/item/grenade/frag/stielhandgranate = 1, /obj/item/device/flashlight/seclite = 1)
	r_hand = /obj/item/gun/projectile/manualcycle/kar98
	r_pocket = /obj/item/grenade/smokebomb
	l_pocket = /obj/item/ammo_magazine/ww2/stripper_mauser

/singleton/hierarchy/outfit/ww2/german/medic
	name = "WW2 - German Medic"
	back = /obj/item/storage/backpack/urist/ww2/german
	gloves = /obj/item/clothing/gloves/latex/nitrile
	backpack_contents = list(
		/obj/item/device/flashlight/seclite = 1, /obj/item/roller_bed = 1,
		/obj/item/storage/firstaid/surgery = 1, /obj/item/storage/firstaid/combat = 1, /obj/item/storage/firstaid/adv = 1, /obj/item/ammo_magazine/pistol/ww2/p38 = 2)
	r_hand = /obj/item/gun/projectile/p38
	r_pocket = /obj/item/ammo_magazine/pistol/ww2/p38
	l_pocket = /obj/item/ammo_magazine/pistol/ww2/p38
	holster = /obj/item/clothing/accessory/storage/holster/armpit

/singleton/hierarchy/outfit/ww2/german/stormtrooper
	name = "WW2 - German Stormtrooper"
	back = /obj/item/storage/backpack/urist/ww2/german
	backpack_contents = list(
		/obj/item/device/flashlight/seclite = 1, /obj/item/ammo_magazine/pistol/ww2/mp40 = 3,
		/obj/item/grenade/smokebomb = 2, /obj/item/grenade/frag/stielhandgranate = 2)
	r_hand = /obj/item/gun/projectile/automatic/mp40
	r_pocket = /obj/item/ammo_magazine/pistol/ww2/mp40
	l_pocket = /obj/item/ammo_magazine/pistol/ww2/mp40

/singleton/hierarchy/outfit/ww2/german/automatic_rifleman
	name = "WW2 - German Automatic Rifleman"
	back = /obj/item/storage/backpack/urist/ww2/german
	backpack_contents = list(
		/obj/item/device/flashlight/seclite = 1, /obj/item/ammo_magazine/ww2/stg44 = 3,
		/obj/item/grenade/smokebomb = 1, /obj/item/grenade/frag/stielhandgranate = 1)
	r_hand = /obj/item/gun/projectile/automatic/stg44
	r_pocket = /obj/item/ammo_magazine/ww2/stg44
	l_pocket = /obj/item/ammo_magazine/ww2/stg44

/singleton/hierarchy/outfit/ww2/german/machinegunner
	name = "WW2 - German Machinegunner"
	back = /obj/item/storage/backpack/urist/ww2/german
	backpack_contents = list(
		/obj/item/device/flashlight/seclite = 1, /obj/item/ammo_magazine/ww2/mg42 = 4,
		/obj/item/grenade/smokebomb = 1)
	r_hand = /obj/item/gun/projectile/automatic/l6_saw/mg42
	r_pocket = /obj/item/grenade/smokebomb
	l_pocket = /obj/item/grenade/frag/stielhandgranate

/singleton/hierarchy/outfit/ww2/german/officer
	name = "WW2 - German Officer"
	head = /obj/item/clothing/head/urist/ww2/germanofficer
	uniform = /obj/item/clothing/under/urist/ww2/germanofficer
	shoes = /obj/item/clothing/shoes/urist/ww2/germanboots
	backpack_contents = list(
		/obj/item/device/flashlight/seclite = 1, /obj/item/ammo_magazine/ww2/g43mag = 2, /obj/item/ammo_magazine/pistol/ww2/p38 = 2,
		/obj/item/grenade/smokebomb = 1, /obj/item/device/binoculars = 1)
	r_hand = /obj/item/gun/projectile/g43
	r_pocket = /obj/item/grenade/frag/stielhandgranate
	l_pocket = /obj/item/ammo_magazine/pistol/ww2/p38
	belt = /obj/item/gun/projectile/p38

/singleton/hierarchy/outfit/ww2/german/post_equip(mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/storage/ww2/webbing_german/gear = new()
		if(uniform.can_attach_accessory(gear))
			uniform.attach_accessory(null, gear)
		else
			qdel(gear)

/singleton/hierarchy/outfit/ww2/russian
	name = "WW2 - Soviet Rifleman"
	head = /obj/item/clothing/head/helmet/urist/ww2/soviethelm
	uniform = /obj/item/clothing/under/urist/ww2/sovietrifleman
	shoes = /obj/item/clothing/shoes/urist/ww2/sovietboots
	back = /obj/item/storage/backpack/urist/ww2/soviet
	backpack_contents = list(
		/obj/item/device/flashlight/seclite = 1, /obj/item/ammo_magazine/speedloader/clip = 4, /obj/item/grenade/frag/sovietgrenade = 1)
	r_hand = /obj/item/gun/projectile/manualcycle/mosinnagant
	r_pocket = /obj/item/grenade/smokebomb
	l_pocket = /obj/item/ammo_magazine/speedloader/clip

/singleton/hierarchy/outfit/ww2/russian/automatic_rifleman
	name = "WW2 - Soviet Automatic Rifleman"
	back = /obj/item/storage/backpack/urist/ww2/soviet
	backpack_contents = list(
		/obj/item/device/flashlight/seclite = 1, /obj/item/ammo_magazine/rifle/svt40mag = 4, /obj/item/grenade/frag/sovietgrenade = 1, /obj/item/grenade/smokebomb = 1)
	r_hand = /obj/item/gun/projectile/svt40
	r_pocket = /obj/item/grenade/smokebomb
	l_pocket = /obj/item/ammo_magazine/rifle/svt40mag

/singleton/hierarchy/outfit/ww2/russian/medic
	name = "WW2 - Soviet Medic"
	back = /obj/item/storage/backpack/urist/ww2/soviet
	backpack_contents = list(
		/obj/item/device/flashlight/seclite = 1, /obj/item/roller_bed = 1,
		/obj/item/storage/firstaid/surgery = 1, /obj/item/storage/firstaid/combat = 1, /obj/item/storage/firstaid/adv = 1, /obj/item/ammo_magazine/pistol/tt33 = 2)
	r_hand = /obj/item/gun/projectile/pistol/tt33
	r_pocket = /obj/item/grenade/smokebomb
	l_pocket = /obj/item/ammo_magazine/pistol/tt33
	holster = /obj/item/clothing/accessory/storage/holster/armpit

/singleton/hierarchy/outfit/ww2/russian/stormtrooper
	name = "WW2 - Soviet Stormtrooper"
	back = /obj/item/storage/backpack/urist/ww2/soviet
	backpack_contents = list(
		/obj/item/device/flashlight/seclite = 1, /obj/item/ammo_magazine/pistol/ppsh = 4, /obj/item/grenade/frag/sovietgrenade = 3)
	r_hand = /obj/item/gun/projectile/automatic/ppsh
	r_pocket = /obj/item/grenade/smokebomb
	l_pocket = /obj/item/ammo_magazine/pistol/ppsh

/singleton/hierarchy/outfit/ww2/russian/machinegunner
	name = "WW2 - Soviet Machinegunner"
	back = /obj/item/storage/backpack/urist/ww2/soviet
	backpack_contents = list(
		/obj/item/device/flashlight/seclite = 1, /obj/item/ammo_magazine/rifle/dp27 = 5, /obj/item/grenade/frag/sovietgrenade = 1, /obj/item/grenade/smokebomb = 1)
	r_hand = /obj/item/gun/projectile/automatic/ppsh
	r_pocket = /obj/item/grenade/smokebomb
	l_pocket = /obj/item/ammo_magazine/rifle/dp27

/singleton/hierarchy/outfit/ww2/russian/machinegunner
	name = "WW2 - Very Lost 'Soviet' Machinegunner" // Keeping the legacy BAR guy
	back = /obj/item/storage/backpack/urist/ww2/soviet
	backpack_contents = list(
		/obj/item/device/flashlight/seclite = 1, /obj/item/ammo_magazine/rifle/military/barmag = 3, /obj/item/grenade/frag/sovietgrenade = 1, /obj/item/grenade/smokebomb = 1)
	r_hand = /obj/item/gun/projectile/automatic/bar
	r_pocket = /obj/item/grenade/smokebomb
	l_pocket = /obj/item/ammo_magazine/rifle/military/barmag

/singleton/hierarchy/outfit/ww2/russian/officer
	name = "WW2 - Soviet Officer" // we just going full commissar now
	head = /obj/item/clothing/head/urist/ww2/sovietofficer
	uniform = /obj/item/clothing/under/urist/ww2/sovietofficer
	shoes = /obj/item/clothing/shoes/urist/ww2/sovietboots
	back = /obj/item/storage/backpack/urist/ww2/soviet
	backpack_contents = list(
		/obj/item/device/flashlight/seclite = 1, /obj/item/ammo_magazine/speedloader/nagant = 3, /obj/item/device/binoculars = 1)
	r_hand = /obj/item/gun/projectile/revolver/nagantm1895
	r_pocket = /obj/item/grenade/smokebomb
	l_pocket = /obj/item/ammo_magazine/speedloader/nagant
	holster = /obj/item/clothing/accessory/storage/holster/armpit

/singleton/hierarchy/outfit/ww2/russian/post_equip(mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/storage/ww2/webbing_soviet/gear = new()
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

// Vietnam ERT.

// 'Nam Rifleman

/singleton/hierarchy/outfit/vietnam_ert
	name = "Vietnam - ERT: Rifleman"
	uniform = /obj/item/clothing/under/urist/nam
	suit = /obj/item/clothing/suit/urist/armor/nam
	head = /obj/item/clothing/head/helmet/urist/nam
	gloves = /obj/item/clothing/gloves/urist/nam
	shoes = /obj/item/clothing/shoes/urist/nam
	back = /obj/item/storage/backpack/urist/nam
	backpack_contents = list(/obj/item/ammo_magazine/rifle/m16 = 4,
		/obj/item/device/flashlight/seclite = 1, /obj/item/material/knife/combat = 1, /obj/item/grenade/frag = 1, /obj/item/grenade/smokebomb = 1)
	belt = /obj/item/storage/belt/urist/nam
	r_pocket = /obj/item/device/radio
	l_pocket = /obj/item/ammo_magazine/rifle/m16
	suit_store = /obj/item/gun/projectile/automatic/m16

// 'Nam Medic

/singleton/hierarchy/outfit/vietnam_ert/medic
	name = "Vietnam - ERT: Medic"
	head = /obj/item/clothing/head/helmet/urist/anfor/med // I'm stealing this Gloydd, sorry.
	gloves = /obj/item/clothing/gloves/latex/nitrile
	back = /obj/item/storage/backpack/dufflebag/med
	backpack_contents = list(/obj/item/ammo_magazine/pistol/a7 = 3,
		/obj/item/device/flashlight/seclite = 1, /obj/item/bodybag/cryobag = 1, /obj/item/defibrillator/compact/combat/loaded =  1,
		/obj/item/storage/firstaid/surgery = 1, /obj/item/storage/firstaid/combat = 1, /obj/item/storage/firstaid/adv = 1)
	belt = /obj/item/storage/belt/medical
	r_pocket = /obj/item/device/radio
	l_pocket = /obj/item/ammo_magazine/pistol/a7
	holster = /obj/item/clothing/accessory/storage/holster/armpit
	suit_store = /obj/item/gun/projectile/pistol/colt/a7

// 'Nam Machinegunner

/singleton/hierarchy/outfit/vietnam_ert/machinegunner
	name = "Vietnam - ERT: Machinegunner"
	gloves = /obj/item/clothing/gloves/thick
	head = /obj/item/clothing/mask/bandana/camo
	back = /obj/item/storage/backpack/urist/nam
	backpack_contents = list(/obj/item/ammo_magazine/box/rifle/military/m60 = 4,
		/obj/item/device/flashlight/seclite = 1, /obj/item/clothing/head/helmet/urist/nam = 1, /obj/item/grenade/smokebomb = 1)
	belt = /obj/item/storage/belt/urist/nam
	r_pocket = /obj/item/device/radio
	l_pocket = /obj/item/material/knife/combat
	suit_store = /obj/item/gun/projectile/automatic/l6_saw/m60

// 'Nam Pointman

/singleton/hierarchy/outfit/vietnam_ert/pointman
	name = "Vietnam - ERT: Pointman"
	gloves = /obj/item/clothing/gloves/thick/combat
	head = /obj/item/clothing/head/welding
	mask = /obj/item/clothing/mask/smokable/cigarette
	back = /obj/item/storage/backpack/industrial
	backpack_contents = list(/obj/item/ammo_magazine/shotholder/shell = 2, /obj/item/ammo_magazine/shotholder = 3, /obj/item/material/knife/combat = 1,
	/obj/item/device/multitool = 1, /obj/item/grenade/frag = 1, /obj/item/grenade/smokebomb = 2, /obj/item/device/flashlight/seclite = 1, /obj/item/clothing/head/helmet/urist/nam = 1, /obj/item/storage/fancy/smokable/luckystars = 1, /obj/item/device/radio = 1)
	belt = /obj/item/storage/belt/utility/full
	holster = /obj/item/clothing/accessory/storage/holster/knife
	r_pocket = /obj/item/ammo_magazine/shotholder/shell
	l_pocket = /obj/item/flame/lighter/zippo/vanity/engraved
	suit_store = /obj/item/gun/projectile/shotgun/pump/combat/ithaca

// 'Nam Grenadier

/singleton/hierarchy/outfit/vietnam_ert/grenadier
	name = "Vietnam - ERT: Grenadier"
	back = /obj/item/storage/backpack/urist/nam
	backpack_contents = list(/obj/item/ammo_magazine/rifle/m16 = 3,
	/obj/item/device/flashlight/seclite = 1, /obj/item/material/knife/combat = 1, /obj/item/grenade/frag/shell = 4, /obj/item/grenade/smokebomb = 3)
	belt = /obj/item/storage/belt/urist/nam
	r_pocket = /obj/item/grenade/frag
	l_pocket = /obj/item/device/radio
	suit_store = /obj/item/gun/projectile/automatic/m16/gl


/singleton/hierarchy/outfit/vietnam_ert/marksman
	name = "Vietnam - ERT: Marksman"
	back = /obj/item/storage/backpack/urist/nam
	mask = /obj/item/clothing/mask/balaclava/tactical
	head = /obj/item/clothing/mask/bandana/camo
	gloves =  /obj/item/clothing/gloves/tactical
	backpack_contents = list(/obj/item/ammo_magazine/rifle/military/stripper = 4, /obj/item/device/binoculars = 1, /obj/item/material/knife/combat = 1,
	/obj/item/grenade/smokebomb = 1, /obj/item/device/flashlight/seclite = 1, /obj/item/ammo_magazine/pistol/a7 = 2)
	belt = /obj/item/storage/belt/urist/nam
	holster = /obj/item/clothing/accessory/storage/holster/armpit
	r_pocket = /obj/item/gun/projectile/pistol/colt/a7
	l_pocket = /obj/item/device/radio
	suit_store = /obj/item/gun/projectile/manualcycle/hunterrifle/scoped


// 'Nam Squad Leader

/singleton/hierarchy/outfit/vietnam_ert/squadleader
	name = "Vietnam - ERT: Squad Leader"
	gloves = /obj/item/clothing/gloves/thick/combat
	head = /obj/item/clothing/head/helmet/urist/nam/officer
	back = /obj/item/storage/backpack/urist/nam
	backpack_contents = list(/obj/item/ammo_magazine/rifle/military/m14 = 5, /obj/item/device/flashlight/flare = 2, /obj/item/device/binoculars = 1, /obj/item/material/knife/combat = 1,
	/obj/item/grenade/smokebomb = 2, /obj/item/device/flashlight/seclite = 1, /obj/item/storage/fancy/smokable/carcinomas = 1, /obj/item/ammo_magazine/pistol/a7 = 2, /obj/item/flame/lighter/zippo/vanity/gold = 1)
	belt = /obj/item/storage/belt/urist/nam
	holster = /obj/item/clothing/accessory/storage/holster/armpit
	r_pocket = /obj/item/gun/projectile/pistol/colt/a7
	l_pocket = /obj/item/device/radio
	suit_store = /obj/item/gun/projectile/automatic/m14

// Columbo

/singleton/hierarchy/outfit/columbo
	name = "Gimmick - Detective Columbo" // Columbo doesn't need any weapons, his wits are enough
	mask = /obj/item/clothing/mask/smokable/cigarette/cigar/green
	suit = /obj/item/clothing/suit/urist/raincoat
	shoes = /obj/item/clothing/shoes/laceup
	uniform = /obj/item/clothing/under/det
	l_ear = /obj/item/device/radio/headset/headset_sec
	belt = /obj/item/storage/briefcase/crimekit
	r_pocket = /obj/item/device/taperecorder
	l_pocket = /obj/item/taperoll/police
	r_hand = /obj/item/reagent_containers/food/drinks/coffee
	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(/obj/item/flame/lighter/zippo = 1, /obj/item/storage/box/evidence = 1, /obj/item/device/holowarrant = 1, /obj/item/clothing/mask/smokable/cigarette/cigar/green = 1, /obj/item/paper = 1, /obj/item/pen/fancy = 1, /obj/item/material/folder = 1, /obj/item/device/camera = 1, /obj/item/device/camera_film = 1)

// Doom Guy

/singleton/hierarchy/outfit/doom_guy
	name = "Gimmick - Doom Marine" // Even though this is armor is trash protection-wise, atleast someone can think they can be the doom guy.
	uniform = /obj/item/clothing/under/syndicate/tacticool
	suit = /obj/item/clothing/suit/urist/armor/trash/doom
	r_pocket = /obj/item/ammo_magazine/shotholder/shell
	l_pocket = /obj/item/ammo_magazine/shotholder/shell
	back = /obj/item/gun/projectile/shotgun/doublebarrel
	belt = /obj/item/ammo_magazine/shotholder/shell
