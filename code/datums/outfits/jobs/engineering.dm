/singleton/hierarchy/outfit/job/engineering
	hierarchy_type = /singleton/hierarchy/outfit/job/engineering
	belt = /obj/item/storage/belt/utility/full
	l_ear = /obj/item/device/radio/headset/headset_eng
	shoes = /obj/item/clothing/shoes/workboots
	gloves = /obj/item/clothing/gloves/urist/leather
	pda_slot = slot_l_store
	flags = OUTFIT_FLAGS_JOB_DEFAULT | OUTFIT_EXTENDED_SURVIVAL

/singleton/hierarchy/outfit/job/engineering/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING

/singleton/hierarchy/outfit/job/engineering/chief_engineer
	name = OUTFIT_JOB_NAME("Chief engineer")
	head = /obj/item/clothing/head/hardhat/white
	uniform = /obj/item/clothing/under/rank/chief_engineer
	l_ear = /obj/item/device/radio/headset/heads/ce
	id_types = list(/obj/item/card/id/engineering/head)
	pda_type = /obj/item/modular_computer/pda/heads/ce

/singleton/hierarchy/outfit/job/engineering/engineer
	name = OUTFIT_JOB_NAME("Engineer")
	head = /obj/item/clothing/head/hardhat
	uniform = /obj/item/clothing/under/rank/engineer
	r_pocket = /obj/item/device/t_scanner
	id_types = list(/obj/item/card/id/engineering)
	pda_type = /obj/item/modular_computer/pda/engineering

/singleton/hierarchy/outfit/job/engineering/engineer/void
	name = OUTFIT_JOB_NAME("Engineer - Voidsuit")
	head = /obj/item/clothing/head/helmet/space/void/engineering
	mask = /obj/item/clothing/mask/breath
	suit = /obj/item/clothing/suit/space/void/engineering

/singleton/hierarchy/outfit/job/engineering/atmos
	name = OUTFIT_JOB_NAME("Atmospheric technician")
	uniform = /obj/item/clothing/under/rank/atmospheric_technician
	belt = /obj/item/storage/belt/utility/atmostech
	pda_type = /obj/item/modular_computer/pda/engineering
	id_types = list(/obj/item/card/id/engineering)
