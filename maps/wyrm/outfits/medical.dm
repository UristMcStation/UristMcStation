/obj/item/card/id/wyrm/medical
	name = "identification card"
	desc = "A card issued to those fighting the call of the void."
	detail_color = COLOR_PALE_BLUE_GRAY

/singleton/hierarchy/outfit/job/wyrm/doc/surgeon
	name = WYRM_OUTFIT_JOB_NAME("Surgeon")
	uniform = /obj/item/clothing/under/rank/medical/scrubs/teal
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/cmoalt
	shoes = /obj/item/clothing/shoes/white
	belt = /obj/item/device/scanner/health
//	r_pocket = /obj/item/sutures

/singleton/hierarchy/outfit/job/wyrm/doc
	name = WYRM_OUTFIT_JOB_NAME("Junior Doctor")
	uniform = /obj/item/clothing/under/det/black
	shoes = /obj/item/clothing/shoes/dress
	pda_type = /obj/item/modular_computer/pda/medical
	id_types = list(/obj/item/card/id/wyrm/medical)
	backpack_contents = list(/obj/item/storage/firstaid/adv)
	l_ear = /obj/item/device/radio/headset/headset_med

/singleton/hierarchy/outfit/job/wyrm/doc/chemist
	name = WYRM_OUTFIT_JOB_NAME("Chemist")
	uniform = /obj/item/clothing/under/rank/medical/scrubs/black
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/rd/chemist
	gloves = /obj/item/clothing/gloves/latex/nitrile

/obj/item/clothing/suit/storage/toggle/labcoat/rd/chemist
	name = "howie labcoat"
	desc = "A distinctive labcoat worn only by those focused on safety or insanity."
//	markings_color = COLOR_SEDONA
