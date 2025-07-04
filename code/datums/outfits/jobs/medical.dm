/singleton/hierarchy/outfit/job/medical
	hierarchy_type = /singleton/hierarchy/outfit/job/medical
	l_ear = /obj/item/device/radio/headset/headset_med
	shoes = /obj/item/clothing/shoes/white
	pda_type = /obj/item/modular_computer/pda/medical
	pda_slot = slot_l_store

/singleton/hierarchy/outfit/job/medical/New()
	..()
	BACKPACK_OVERRIDE_MEDICAL

/singleton/hierarchy/outfit/job/medical/cmo
	name = OUTFIT_JOB_NAME("Chief Medical Officer")
	l_ear  =/obj/item/device/radio/headset/heads/cmo
	uniform = /obj/item/clothing/under/rank/chief_medical_officer
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/cmo
	shoes = /obj/item/clothing/shoes/brown
	l_hand = /obj/item/storage/firstaid/adv
	r_pocket = /obj/item/device/flashlight/pen
	id_types = list(/obj/item/card/id/medical/head)
	pda_type = /obj/item/modular_computer/pda/heads/cmo

/singleton/hierarchy/outfit/job/medical/doctor
	name = OUTFIT_JOB_NAME("Medical Doctor")
	uniform = /obj/item/clothing/under/rank/medical
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	l_hand = /obj/item/storage/firstaid/adv
	r_pocket = /obj/item/device/flashlight/pen
	id_types = list(/obj/item/card/id/medical)

/singleton/hierarchy/outfit/job/medical/doctor/emergency_physician
	name = OUTFIT_JOB_NAME("Emergency physician")
	suit = /obj/item/clothing/suit/storage/toggle/fr_jacket

/singleton/hierarchy/outfit/job/medical/doctor/surgeon
	name = OUTFIT_JOB_NAME("Surgeon")
	uniform = /obj/item/clothing/under/rank/medical/scrubs/blue
	head = /obj/item/clothing/head/surgery/blue

/singleton/hierarchy/outfit/job/medical/doctor/virologist
	name = OUTFIT_JOB_NAME("Virologist")
	uniform = /obj/item/clothing/under/rank/virologist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/virologist
	mask = /obj/item/clothing/mask/surgical
/singleton/hierarchy/outfit/job/medical/doctor/virologist/New()
	..()
	BACKPACK_OVERRIDE_RESEARCH_CORP

/singleton/hierarchy/outfit/job/medical/doctor/chemist
	name = OUTFIT_JOB_NAME("Doctor - Chemist")
	uniform = /obj/item/clothing/under/rank/chemist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/chemist
	pda_type = /obj/item/modular_computer/pda/chemistry

/singleton/hierarchy/outfit/job/medical/doctor/nurse
	name = OUTFIT_JOB_NAME("Nurse")
	suit = null

/singleton/hierarchy/outfit/job/medical/doctor/nurse/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		if(prob(50))
			uniform = /obj/item/clothing/under/rank/nursesuit
		else
			uniform = /obj/item/clothing/under/rank/nurse
		head = /obj/item/clothing/head/nursehat
	else
		uniform = /obj/item/clothing/under/rank/medical/scrubs/purple
		head = null

/singleton/hierarchy/outfit/job/medical/chemist
	name = OUTFIT_JOB_NAME("Chemist")
	uniform = /obj/item/clothing/under/rank/chemist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/chemist
	id_types = list(/obj/item/card/id/medical/chemist)
	pda_type = /obj/item/modular_computer/pda/chemistry

/singleton/hierarchy/outfit/job/medical/chemist/New()
	..()
	BACKPACK_OVERRIDE_RESEARCH_CORP

/singleton/hierarchy/outfit/job/medical/geneticist
	name = OUTFIT_JOB_NAME("Geneticist")
	uniform = /obj/item/clothing/under/rank/geneticist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/genetics
	r_pocket = /obj/item/device/flashlight/pen
	id_types = list(/obj/item/card/id/medical/geneticist)
	pda_type = /obj/item/modular_computer/pda/medical

/singleton/hierarchy/outfit/job/medical/geneticist/New()
	..()
	backpack_overrides[/singleton/backpack_outfit/backpack] = /obj/item/storage/backpack/genetics
	backpack_overrides[/singleton/backpack_outfit/satchel]  = /obj/item/storage/backpack/satchel/gen

/singleton/hierarchy/outfit/job/medical/psychiatrist
	name = OUTFIT_JOB_NAME("Psychiatrist")
	uniform = /obj/item/clothing/under/rank/psych
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/laceup
	id_types = list(/obj/item/card/id/medical/psychiatrist)

/singleton/hierarchy/outfit/job/medical/paramedic
	name = OUTFIT_JOB_NAME("Paramedic")
	uniform = /obj/item/clothing/under/rank/medical/scrubs/black
	suit = /obj/item/clothing/suit/storage/toggle/fr_jacket
	shoes = /obj/item/clothing/shoes/jackboots
	l_hand = /obj/item/storage/firstaid/adv
	belt = /obj/item/storage/belt/medical/emt
	id_types = list(/obj/item/card/id/medical/paramedic)
	flags = OUTFIT_FLAGS_JOB_DEFAULT | OUTFIT_EXTENDED_SURVIVAL

/singleton/hierarchy/outfit/job/medical/paramedic/emt
	name = OUTFIT_JOB_NAME("Emergency medical technician")
	uniform = /obj/item/clothing/under/rank/medical/paramedic
