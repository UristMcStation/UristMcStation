//this is for atmospherics items that aren't structures. so small oxytanks, masks, that sort of stuff.

/datum/trade_item/atmospherics/oxyengi
	name = "extended oxygen tank"
	item_type = /obj/item/tank/oxygen_emergency_extended
	category = "atmospherics"
	quantity = 5
	value = 80

/datum/trade_item/atmospherics/emergsuit
	name = "emergency space suit"
	item_type = /obj/item/clothing/suit/space/emergency
	category = "atmospherics"
	quantity = 5
	value = 100

/datum/trade_item/atmospherics/emerghelm
	name = "emergency space helmet"
	item_type = /obj/item/clothing/head/helmet/space/emergency
	category = "atmospherics"
	quantity = 5
	value = 100

/datum/trade_item/atmospherics/gasmask
	name = "gas mask"
	item_type = /obj/item/clothing/mask/gas
	category = "atmospherics"
	quantity = 5
	value = 80

/datum/trade_item/atmospherics/hydrogentank
	name = "fuel tank"
	item_type = /obj/item/tank/hydrogen
	category = "atmospherics"
	quantity = 5
	value = 225
	req_access = access_atmospherics

/datum/trade_item/atmospherics/phorontank
	name = "phoron tank"
	item_type = /obj/item/tank/phoron
	category = "atmospherics"
	quantity = 5
	value = 450
	req_access = access_atmospherics

/datum/trade_item/atmospherics/atmosscanner
	name = "atmospherics scanner module"
	item_type = /obj/item/stock_parts/computer/scanner/atmos
	category = "atmospherics"
	quantity = 5
	value = 202
