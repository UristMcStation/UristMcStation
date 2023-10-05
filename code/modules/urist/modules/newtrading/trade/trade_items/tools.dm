/*
/datum/trade_item
	var/name
	var/item_type
	var/category
	var/quantity = 0
	var/value = 0
	var/trader_weight = 1
	var/list/bonus_items = list()
	var/is_template = 1
*/

/datum/trade_item/tool
	sellable = 0

/datum/trade_item/tool/crowbar
	name = "crowbar"
	item_type = /obj/item/crowbar
	category = "tools"
	quantity = 10
	value = 30
//	trader_weight = 1

/datum/trade_item/tool/wrench
	name = "wrench"
	item_type = /obj/item/wrench
	category = "tools"
	quantity = 10
	value = 30
//	trader_weight = 1

/datum/trade_item/tool/screwdriver
	name = "screwdriver"
	item_type = /obj/item/screwdriver
	category = "tools"
	quantity = 10
	value = 30
//	trader_weight = 1

/datum/trade_item/tool/wirecutters
	name = "wirecutters"
	item_type = /obj/item/wirecutters
	category = "tools"
	quantity = 10
	value = 40
//	trader_weight = 1

/datum/trade_item/tool/weldingtool
	name = "empty welding tool"
	item_type = /obj/item/weldingtool/empty
	category = "tools"
	quantity = 10
	value = 70
//	trader_weight = 1

/datum/trade_item/tool/welder_tank
	name = "welding fuel tank"
	item_type = /obj/item/welder_tank
	category = "tools"
	quantity = 10
	value = 60
//	trader_weight = 1

/datum/trade_item/tool/welder_tank_large
	name = "large welding fuel tank"
	item_type = /obj/item/welder_tank/large
	category = "tools"
	quantity = 10
	value = 100
//	trader_weight = 1

/datum/trade_item/tool/utilitybelt
	name = "utility belt"
	item_type = /obj/item/storage/belt/utility
	category = "tools"
	quantity = 5
	value = 70
//	trader_weight = 1

/datum/trade_item/tool/t_scanner
	name = "T-ray scanner"
	item_type = /obj/item/device/t_scanner
	category = "tools"
	quantity = 5
	value = 100
//	trader_weight = 1

/datum/trade_item/tool/multitool
	name = "multitool"
	item_type = /obj/item/device/multitool
	category = "tools"
	quantity = 5
	value = 120
//	trader_weight = 1

/datum/trade_item/tool/mesons
	name = "meson goggles"
	item_type = /obj/item/clothing/glasses/meson
	category = "tools"
	quantity = 10
	value = 200
//	trader_weight = 1

/datum/trade_item/tool/radio
	name = "shortwave radio"
	item_type = /obj/item/device/radio
	category = "tools"
	quantity = 10
	value = 60
//	trader_weight = 1
