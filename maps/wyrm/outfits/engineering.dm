/obj/item/card/id/wyrm/engineering
	name = "identification card"
	desc = "A card issued to problem solvers."
	detail_color = COLOR_SUN

/singleton/hierarchy/outfit/job/wyrm/hand/engine
	name = WYRM_OUTFIT_JOB_NAME("Junior Engineer")
	head = /obj/item/clothing/head/hardhat
	id_types = list(/obj/item/card/id/wyrm/engineering)
	shoes = /obj/item/clothing/shoes/workboots
	belt = /obj/item/storage/belt/utility/full
	l_ear = /obj/item/device/radio/headset/headset_eng
	r_pocket = /obj/item/device/flashlight
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/singleton/hierarchy/outfit/job/wyrm/chief_engineer
	name = WYRM_OUTFIT_JOB_NAME("Chief Engineer")
	uniform = /obj/item/clothing/under/rank/chief_engineer
	glasses = /obj/item/clothing/glasses/welding/superior
	suit = /obj/item/clothing/suit/storage/hazardvest
	gloves = /obj/item/clothing/gloves/thick
	shoes = /obj/item/clothing/shoes/workboots
	pda_type = /obj/item/modular_computer/pda/heads/ce
	belt = /obj/item/storage/belt/utility/full
	id_types = list(/obj/item/card/id/wyrm/engineering/head)
	l_ear = /obj/item/device/radio/headset/heads/ce
	r_pocket = /obj/item/device/flashlight
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/obj/item/card/id/wyrm/engineering/head
	name = "identification card"
	desc = "A card which represents creativity and ingenuity in spite of the universe."
	extra_details = list("goldstripe")
