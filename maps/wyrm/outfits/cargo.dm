/obj/item/card/id/wyrm/logistics
	name = "identification card"
	desc = "A card issued to logistics staff."
	detail_color = COLOR_BROWN

/singleton/hierarchy/outfit/job/wyrm/logistics
	name = WYRM_OUTFIT_JOB_NAME("Supply Technician")
	uniform = /obj/item/clothing/under/rank/cargotech
	shoes = /obj/item/clothing/shoes/brown
	pda_type = /obj/item/modular_computer/pda/cargo
	l_ear = /obj/item/device/radio/headset/headset_cargo
	r_pocket = /obj/item/device/flashlight

/singleton/hierarchy/outfit/job/wyrm/salvage
	name = WYRM_OUTFIT_JOB_NAME("Salvage Technician")
	uniform = /obj/item/clothing/under/rank/ntwork
	l_ear = /obj/item/device/radio/headset/headset_scilog
	pda_type = /obj/item/modular_computer/pda/science
	belt = /obj/item/storage/belt/utility
	shoes = /obj/item/clothing/shoes/black

/obj/item/device/radio/headset/headset_scilog
	name = "research logistics radio headset"
	desc = "A headset that is a result of the mating between logistics and science."
	icon_state = "com_headset"
	ks1type = /obj/item/device/encryptionkey/headset_scilog

/obj/item/device/encryptionkey/headset_scilog
	name = "research logistics radio encryption key"
	icon_state = "cargo_cypherkey"
	channels = list("Supply" = 1, "Science" = 1)
