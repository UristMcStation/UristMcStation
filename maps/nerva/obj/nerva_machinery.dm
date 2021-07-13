// Suit cyclers and storage
/obj/machinery/suit_cycler/exploration
	name = "Exploration suit cycler"
	model_text = "Exploration"
	req_access = list(access_expedition)
	species = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI)

/obj/machinery/suit_storage_unit/explorer
	name = "Exploration Voidsuit Storage Unit"
	suit_type = /obj/item/clothing/suit/space/void/exploration
	helmet_type = /obj/item/clothing/head/helmet/space/void/exploration
	boots_type = /obj/item/clothing/shoes/magboots
	tank_type = /obj/item/weapon/tank/oxygen
	mask_type = /obj/item/clothing/mask/breath
	req_access = list(access_expedition)
	islocked = 1

/obj/machinery/suit_storage_unit/pilot
	name = "Pilot Voidsuit Storage Unit"
	suit_type = /obj/item/clothing/suit/space/void/pilot
	helmet_type = /obj/item/clothing/head/helmet/space/void/pilot
	boots_type = /obj/item/clothing/shoes/magboots
	tank_type = /obj/item/weapon/tank/oxygen
	mask_type = /obj/item/clothing/mask/breath
	req_access = list(access_expedition)
	islocked = 1