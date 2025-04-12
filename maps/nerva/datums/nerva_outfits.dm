/singleton/hierarchy/outfit/job/bodyguard
	name = OUTFIT_JOB_NAME("Bodyguard") //done
	uniform = /obj/item/clothing/under/bodyguard
	l_ear = /obj/item/device/radio/headset/nerva_guard
	shoes = /obj/item/clothing/shoes/jackboots
	id_types = list(/obj/item/card/id/bodyguard)
	pda_type = /obj/item/modular_computer/pda/heads/hop
	backpack_contents = list(/obj/item/storage/box/deathimp = 1)
	gloves = /obj/item/clothing/gloves/thick/combat

/singleton/hierarchy/outfit/job/bodyguard/New()
	..()
	BACKPACK_OVERRIDE_SECURITY

/singleton/hierarchy/outfit/job/mime
	name = OUTFIT_JOB_NAME("Mime") //done
	uniform = /obj/item/clothing/under/mime
	head = /obj/item/clothing/head/beret
	mask = /obj/item/clothing/mask/gas/mime
	gloves = /obj/item/clothing/gloves/white
	shoes = /obj/item/clothing/shoes/black
	backpack_contents = list(/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing = 1, /obj/item/pen/crayon/mime = 1)
	pda_type = /obj/item/modular_computer/pda/mime
	id_types = list(/obj/item/card/id/civilian/mime)

/singleton/hierarchy/outfit/job/clown
	name = OUTFIT_JOB_NAME("Clown") //done
	uniform = /obj/item/clothing/under/rank/clown
	mask = /obj/item/clothing/mask/gas/clown_hat
	shoes = /obj/item/clothing/shoes/clown_shoes
	backpack_contents = list(/obj/item/reagent_containers/food/snacks/grown/banana = 1, /obj/item/bikehorn = 1,
		/obj/item/stamp/clown = 1, /obj/item/pen/crayon/rainbow = 1, /obj/item/storage/fancy/crayons = 1,
		/obj/item/reagent_containers/spray/waterflower = 1)
	back = /obj/item/storage/backpack/clown
	pda_type = /obj/item/modular_computer/pda/clown
	id_types = list(/obj/item/card/id/civilian/clown)

//fo

/singleton/hierarchy/outfit/job/nerva/firstofficer
	name = OUTFIT_JOB_NAME("First Officer")
	uniform = /obj/item/clothing/under/urist/nerva/foregular
	l_ear = /obj/item/device/radio/headset/heads/firstofficer
	shoes = /obj/item/clothing/shoes/black
	id_types = list(/obj/item/card/id/firstofficer)
	pda_type = /obj/item/modular_computer/pda/heads/hop //change
	gloves = /obj/item/clothing/gloves/color/grey
	head = /obj/item/clothing/head/urist/beret/nervafo

//so

/singleton/hierarchy/outfit/job/nerva/secondofficer //done
	name = OUTFIT_JOB_NAME("Second Officer")
	uniform = /obj/item/clothing/under/urist/nerva/soregular
	l_ear = /obj/item/device/radio/headset/heads/secondofficer
	shoes = /obj/item/clothing/shoes/black
	id_types = list(/obj/item/card/id/secondofficer)
	pda_type = /obj/item/modular_computer/pda/heads/hop
	gloves = /obj/item/clothing/gloves/color/grey
	head = /obj/item/clothing/head/urist/beret/nervaso


//cargo

/singleton/hierarchy/outfit/job/nerva/supplytech
	name = OUTFIT_JOB_NAME("Supply Technician")
	uniform = /obj/item/clothing/under/urist/nerva/cargo
	suit = /obj/item/clothing/suit/storage/toggle/urist/cargojacket
	l_ear = /obj/item/device/radio/headset/headset_cargo
	shoes = /obj/item/clothing/shoes/workboots
	id_types = list(/obj/item/card/id/cargo)
	pda_type = /obj/item/modular_computer/pda/cargo
	gloves = /obj/item/clothing/gloves/urist/leather

/singleton/hierarchy/outfit/job/nerva/qm
	name = OUTFIT_JOB_NAME("Nerva Quartermaster")
	uniform = /obj/item/clothing/under/urist/nerva/qm
	suit = /obj/item/clothing/suit/storage/toggle/urist/qmjacket
	l_ear = /obj/item/device/radio/headset/heads/nerva_qm
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/black
	id_types = list(/obj/item/card/id/cargo/head)
	pda_type = /obj/item/modular_computer/pda/heads/hop
	gloves = /obj/item/clothing/gloves/color/grey

/singleton/hierarchy/outfit/job/science/nervaroboticist
	name = OUTFIT_JOB_NAME("Nerva Roboticist")
	uniform = /obj/item/clothing/under/rank/roboticist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/robotics
	l_ear = /obj/item/device/radio/headset/headset_cargo
	shoes = /obj/item/clothing/shoes/black
	belt = /obj/item/storage/belt/robotics/full
	id_types = list(/obj/item/card/id/science/roboticist)
	pda_slot = slot_r_store
	pda_type = /obj/item/modular_computer/pda/roboticist

/singleton/hierarchy/outfit/job/science/nervaroboticist/New()
	..()
	backpack_overrides.Cut()

//cappy

/singleton/hierarchy/outfit/job/nerva/captain //done
	name = OUTFIT_JOB_NAME("Nerva Captain")
	uniform = /obj/item/clothing/under/urist/nerva/capregular
	suit = /obj/item/clothing/suit/storage/toggle/urist/nervacapjacket
	l_ear = /obj/item/device/radio/headset/heads/nerva_cap
	shoes = /obj/item/clothing/shoes/urist/capboots
	id_types = list(/obj/item/card/id/gold)
	pda_type = /obj/item/modular_computer/pda/captain
	gloves = /obj/item/clothing/gloves/thick/combat
	head = /obj/item/clothing/head/urist/beret/nervacap

//sec

/singleton/hierarchy/outfit/job/security/nervasecofficer
	name = OUTFIT_JOB_NAME("Nerva Security Officer") //done
	uniform = /obj/item/clothing/under/urist/nerva/secregular
	l_pocket = /obj/item/device/flash
	r_pocket = /obj/item/handcuffs
	id_types = list(/obj/item/card/id/security)
	pda_type = /obj/item/modular_computer/pda/security
	head = /obj/item/clothing/head/beret/sec
	l_ear = /obj/item/device/radio/headset/nerva_sec

/singleton/hierarchy/outfit/job/security/nervacos //done
	name = OUTFIT_JOB_NAME("Chief of Security")
	uniform = /obj/item/clothing/under/urist/nerva/cosregular
	l_ear = /obj/item/device/radio/headset/heads/nerva_cos
	id_types = list(/obj/item/card/id/security/head)
	pda_type = /obj/item/modular_computer/pda/heads/hos
	backpack_contents = list(/obj/item/handcuffs = 1)
	head = /obj/item/clothing/head/beret/sec/nervacos

//science

/singleton/hierarchy/outfit/job/nerva/scientist
	name = OUTFIT_JOB_NAME("Scientist - Nerva")
	uniform = /obj/item/clothing/under/urist/nerva/sci
	suit = /obj/item/clothing/suit/storage/toggle/urist/science
	shoes = /obj/item/clothing/shoes/white
	pda_type = /obj/item/modular_computer/pda/science
	id_types = list(/obj/item/card/id/nerva_scientist)
	l_ear = /obj/item/device/radio/headset/nervananotrasen

/singleton/hierarchy/outfit/job/nerva/scientist/New()
	..()
	BACKPACK_OVERRIDE_RESEARCH

//bartender

/singleton/hierarchy/outfit/job/service/nervabartender
	name = OUTFIT_JOB_NAME("Nerva Bartender")
	uniform = /obj/item/clothing/under/rank/bartender
	id_types = list(/obj/item/card/id/civilian/chef)
	pda_type = /obj/item/modular_computer/pda

//stowaway
/singleton/hierarchy/outfit/job/nerva/stowaway
	name = OUTFIT_JOB_NAME("Nerva Stowaway")
	shoes = /obj/item/clothing/shoes/black
	uniform = /obj/item/clothing/under/color/grey
	id_types = null
	pda_type = null
	l_ear = null
	r_hand = /obj/item/crowbar
	l_pocket = /obj/item/wrench
	r_pocket = /obj/item/device/flashlight

//psychiatrist

/singleton/hierarchy/outfit/job/medical/psychiatrist/nerva
	name = OUTFIT_JOB_NAME("Nerva Psychiatrist")
	id_types = list(/obj/item/card/id/medical/psychiatrist/nerva)

/singleton/hierarchy/outfit/job/medical/psychiatrist/nerva_psychologist
	name = OUTFIT_JOB_NAME("Nerva Psychologist")
	id_types = list(/obj/item/card/id/medical/psychiatrist/nerva)

// Senior Scientist

/singleton/hierarchy/outfit/job/nerva/seniorscientist //Reworked old RD stuff from Torch
	name = OUTFIT_JOB_NAME("Nerva Senior Scientist")
	l_ear = /obj/item/device/radio/headset/heads/nerva_senior
	uniform = /obj/item/clothing/under/urist/nerva/seniornt
	suit = /obj/item/clothing/suit/storage/toggle/urist/science
	shoes = /obj/item/clothing/shoes/brown
	l_hand = /obj/item/material/folder/clipboard
	id_types = list(/obj/item/card/id/nerva_senior_scientist)
	pda_type = /obj/item/modular_computer/pda/science

/singleton/hierarchy/outfit/job/nerva/ert
	name = OUTFIT_JOB_NAME("ERT - Nerva")
	uniform = /obj/item/clothing/under/syndicate/combat
	head = /obj/item/clothing/head/beret/centcom/officer
	gloves = /obj/item/clothing/gloves/thick
	id_types = list(/obj/item/card/id/centcom/ERT)
	pda_type = /obj/item/modular_computer/pda/ert
	l_ear = /obj/item/device/radio/headset/ert
	shoes = /obj/item/clothing/shoes/dutyboots

/singleton/hierarchy/outfit/job/nerva/ert/leader
	name = OUTFIT_JOB_NAME("ERT Leader - Nerva")
	uniform = /obj/item/clothing/under/rank/centcom
	head = /obj/item/clothing/head/beret/centcom/captain

/singleton/hierarchy/outfit/job/nerva/ert/suit
	name = OUTFIT_JOB_NAME("ERT Heavy - Nerva")
	back = /obj/item/rig/ert/assetprotection
	flags = OUTFIT_RESET_EQUIPMENT | OUTFIT_ADJUSTMENT_SKIP_BACKPACK
	head = null
	gloves = null

//passenger
/singleton/hierarchy/outfit/job/nerva/passenger
	name = OUTFIT_JOB_NAME("Nerva Passenger")
	l_ear = /obj/item/device/radio/headset
	uniform = /obj/item/clothing/under/rank/psych/turtleneck/sweater
	shoes = /obj/item/clothing/shoes/black
	id_types = list(/obj/item/card/id)
	pda_type = /obj/item/modular_computer/pda

// assistant - mainly for tool storage.
/singleton/hierarchy/outfit/job/nerva/assistant
	name = OUTFIT_JOB_NAME("Nerva Assistant")
	id_types = list(/obj/item/card/id/civilian/nerva_assistant)
