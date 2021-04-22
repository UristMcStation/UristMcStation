/decl/hierarchy/outfit/job/bodyguard
	name = OUTFIT_JOB_NAME("Bodyguard") //done
	uniform = /obj/item/clothing/under/bodyguard
	suit = /obj/item/clothing/suit/armor/vest/deus_blueshield
	l_ear = /obj/item/device/radio/headset/heads/hop
	shoes = /obj/item/clothing/shoes/jackboots
	id_type = /obj/item/weapon/card/id/bodyguard
	pda_type = /obj/item/modular_computer/pda/heads/hop
	backpack_contents = list(/obj/item/weapon/storage/box/deathimp = 1)
	gloves = /obj/item/clothing/gloves/thick/combat

/decl/hierarchy/outfit/job/bodyguard/New()
	..()
	BACKPACK_OVERRIDE_SECURITY

/decl/hierarchy/outfit/job/mime
	name = OUTFIT_JOB_NAME("Mime") //done
	uniform = /obj/item/clothing/under/mime
	head = /obj/item/clothing/head/beret
	mask = /obj/item/clothing/mask/gas/mime
	gloves = /obj/item/clothing/gloves/white
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/modular_computer/pda/mime
	id_type = /obj/item/weapon/card/id/civilian/mime

/decl/hierarchy/outfit/job/clown
	name = OUTFIT_JOB_NAME("Clown") //done
	uniform = /obj/item/clothing/under/rank/clown
	mask = /obj/item/clothing/mask/gas/clown_hat
	shoes = /obj/item/clothing/shoes/clown_shoes
	backpack_contents = list(/obj/item/weapon/reagent_containers/food/snacks/grown/banana = 1, /obj/item/weapon/bikehorn = 1,
		/obj/item/weapon/stamp/clown = 1, /obj/item/weapon/pen/crayon/rainbow = 1, /obj/item/weapon/storage/fancy/crayons = 1,
		/obj/item/weapon/reagent_containers/spray/waterflower = 1)
	back = /obj/item/weapon/storage/backpack/clown
	pda_type = /obj/item/modular_computer/pda/clown
	id_type = /obj/item/weapon/card/id/civilian/clown

//fo

/decl/hierarchy/outfit/job/nerva/firstofficer
	name = OUTFIT_JOB_NAME("First Officer")
	uniform = /obj/item/clothing/under/urist/nerva/foregular
	l_ear = /obj/item/device/radio/headset/heads/firstofficer
	shoes = /obj/item/clothing/shoes/black
	id_type = /obj/item/weapon/card/id/firstofficer
	pda_type = /obj/item/modular_computer/pda/heads/hop //change
	gloves = /obj/item/clothing/gloves/color/grey
	head = /obj/item/clothing/head/urist/beret/nervafo

//so

/decl/hierarchy/outfit/job/nerva/secondofficer //done
	name = OUTFIT_JOB_NAME("Second Officer")
	uniform = /obj/item/clothing/under/urist/nerva/soregular
	l_ear = /obj/item/device/radio/headset/heads/secondofficer
	shoes = /obj/item/clothing/shoes/black
	id_type = /obj/item/weapon/card/id/secondofficer
	pda_type = /obj/item/modular_computer/pda/heads/hop
	gloves = /obj/item/clothing/gloves/color/grey
	head = /obj/item/clothing/head/urist/beret/nervaso


//cargo

/decl/hierarchy/outfit/job/nerva/supplytech
	name = OUTFIT_JOB_NAME("Supply Technician")
	uniform = /obj/item/clothing/under/urist/nerva/cargo
	suit = /obj/item/clothing/suit/storage/toggle/urist/cargojacket
	l_ear = /obj/item/device/radio/headset/headset_cargo
	shoes = /obj/item/clothing/shoes/urist/leather
	id_type = /obj/item/weapon/card/id/cargo
	pda_type = /obj/item/modular_computer/pda/cargo
	gloves = /obj/item/clothing/gloves/urist/leather

/decl/hierarchy/outfit/job/nerva/qm
	name = OUTFIT_JOB_NAME("Nerva Quartermaster")
	uniform = /obj/item/clothing/under/urist/nerva/qm
	suit = /obj/item/clothing/suit/storage/toggle/urist/qmjacket
	l_ear = /obj/item/device/radio/headset/heads/nerva_qm
	shoes = /obj/item/clothing/shoes/black
	id_type = /obj/item/weapon/card/id/cargo/head
	pda_type = /obj/item/modular_computer/pda/heads/hop
	gloves = /obj/item/clothing/gloves/color/grey

/decl/hierarchy/outfit/job/science/nervaroboticist
	name = OUTFIT_JOB_NAME("Nerva Roboticist")
	uniform = /obj/item/clothing/under/rank/roboticist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/robotics
	l_ear = /obj/item/device/radio/headset/headset_cargo
	shoes = /obj/item/clothing/shoes/black
	belt = /obj/item/weapon/storage/belt/robotics/full
	id_type = /obj/item/weapon/card/id/cargo
	pda_slot = slot_r_store
	pda_type = /obj/item/modular_computer/pda/roboticist

/decl/hierarchy/outfit/job/science/nervaroboticist/New()
	..()
	backpack_overrides.Cut()

//cappy

/decl/hierarchy/outfit/job/nerva/captain //done
	name = OUTFIT_JOB_NAME("Nerva Captain")
	uniform = /obj/item/clothing/under/urist/nerva/capregular
	suit = /obj/item/clothing/suit/storage/toggle/urist/nervacapjacket
	l_ear = /obj/item/device/radio/headset/heads/nerva_cap
	shoes = /obj/item/clothing/shoes/urist/capboots
	id_type = /obj/item/weapon/card/id/gold
	pda_type = /obj/item/modular_computer/pda/captain
	gloves = /obj/item/clothing/gloves/thick/combat
	head = /obj/item/clothing/head/urist/beret/nervacap

//sec

/decl/hierarchy/outfit/job/security/nervasecofficer
	name = OUTFIT_JOB_NAME("Nerva Security Officer") //done
	uniform = /obj/item/clothing/under/urist/nerva/secregular
	l_pocket = /obj/item/device/flash
	r_pocket = /obj/item/weapon/handcuffs
	id_type = /obj/item/weapon/card/id/security
	pda_type = /obj/item/modular_computer/pda/security
	head = /obj/item/clothing/head/beret/sec
	l_ear = /obj/item/device/radio/headset/nerva_sec

/decl/hierarchy/outfit/job/security/nervacos //done
	name = OUTFIT_JOB_NAME("Chief of Security")
	uniform = /obj/item/clothing/under/urist/nerva/cosregular
	l_ear = /obj/item/device/radio/headset/heads/nerva_cos
	id_type = /obj/item/weapon/card/id/security/head
	pda_type = /obj/item/modular_computer/pda/heads/hos
	backpack_contents = list(/obj/item/weapon/handcuffs = 1)
	head = /obj/item/clothing/head/beret/sec/nervacos

//science

/decl/hierarchy/outfit/job/nerva/scientist
	name = OUTFIT_JOB_NAME("Scientist - Nerva")
	uniform = /obj/item/clothing/under/urist/nerva/sci
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science/nerva
	shoes = /obj/item/clothing/shoes/white
	pda_type = /obj/item/modular_computer/pda/science
	id_type = /obj/item/weapon/card/id/nerva_scientist
	l_ear = /obj/item/device/radio/headset/nervananotrasen

/decl/hierarchy/outfit/job/nerva/scientist/New()
	..()
	BACKPACK_OVERRIDE_RESEARCH

//bartender

/decl/hierarchy/outfit/job/service/nervabartender
	name = OUTFIT_JOB_NAME("Nerva Bartender")
	uniform = /obj/item/clothing/under/rank/bartender
	id_type = /obj/item/weapon/card/id/civilian/chef
	pda_type = /obj/item/modular_computer/pda

//stowaway
/decl/hierarchy/outfit/job/nerva/stowaway
	name = OUTFIT_JOB_NAME("Nerva Stowaway")
	shoes = /obj/item/clothing/shoes/black
	uniform = /obj/item/clothing/under/color/grey
	id_type = null
	pda_type = null
	l_ear = null
	l_pocket = /obj/item/weapon/wrench
	r_pocket = /obj/item/weapon/crowbar
	backpack_contents = list(/obj/item/device/flashlight = 1)

//psychiatrist

/decl/hierarchy/outfit/job/medical/psychiatrist/nerva
	name = OUTFIT_JOB_NAME("Nerva Psychiatrist")
	id_type = /obj/item/weapon/card/id/medical/psychiatrist/nerva

/decl/hierarchy/outfit/job/medical/psychiatrist/psychologist/nerva
	name = OUTFIT_JOB_NAME("Nerva Psychologist")
	id_type = /obj/item/weapon/card/id/medical/psychiatrist/nerva

// Senior Scientist

/decl/hierarchy/outfit/job/nerva/seniorscientist //Reworked old RD stuff from Torch
	name = OUTFIT_JOB_NAME("Nerva Senior Scientist")
	l_ear = /obj/item/device/radio/headset/heads/nerva_senior
	uniform = /obj/item/clothing/under/urist/nerva/seniornt
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science/nerva
	back = /obj/item/weapon/storage/backpack/satchel/leather
	shoes = /obj/item/clothing/shoes/brown
	l_hand = /obj/item/weapon/material/clipboard
	id_type = /obj/item/weapon/card/id/nerva_senior_scientist
	pda_type = /obj/item/modular_computer/pda/science
