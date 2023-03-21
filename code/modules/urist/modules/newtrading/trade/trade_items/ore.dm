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

/datum/trade_item/coal
	name = "coal"
	item_type = /obj/item/ore/coal
	category = "ore"
	quantity = 10
	value = 25
	trader_weight = 1

/datum/trade_item/iron
	name = "iron"
	item_type = /obj/item/ore/iron
	category = "ore"
	quantity = 10
	value = 50
	trader_weight = 1

/datum/trade_item/silver
	name = "silver"
	item_type = /obj/item/ore/silver
	category = "ore"
	quantity = 5
	value = 200
	trader_weight = 1

/datum/trade_item/gold
	name = "gold"
	item_type = /obj/item/ore/gold
	category = "ore"
	quantity = 5
	value = 225
	trader_weight = 1

/datum/trade_item/platinum
	name = "platinum"
	item_type = /obj/item/ore/osmium
	category = "ore"
	quantity = 0
	value = 750
	trader_weight = 0

/datum/trade_item/diamond
	name = "diamond"
	item_type = /obj/item/ore/diamond
	category = "ore"
	quantity = 0
	value = 450
	trader_weight = 0

/datum/trade_item/uranium
	name = "uranium"
	item_type = /obj/item/ore/uranium
	category = "ore"
	quantity = 0
	value = 360
	trader_weight = 0

/datum/trade_item/phoron
	name = "uranium"
	item_type = /obj/item/ore/phoron
	category = "ore"
	quantity = 0
	value = 360
	trader_weight = 0


/*

/datum/trade_item/coal
	name = "coal"
	item_type = /obj/item/ore/coal
	category = "ore"
	quantity = 10
	value = 25
	trader_weight = 1

/datum/trade_item/iron
	name = "iron"
	item_type = /obj/item/ore/iron
	category = "ore"
	quantity = 10
	value = 50
	trader_weight = 1

/datum/trade_item/silver
	name = "silver"
	item_type = /obj/item/ore/silver
	category = "ore"
	quantity = 5
	value = 200
	trader_weight = 1

/datum/trade_item/gold
	name = "gold"
	item_type = /obj/item/ore/gold
	category = "ore"
	quantity = 5
	value = 225
	trader_weight = 1

/datum/trade_item/platinum
	name = "platinum"
	item_type = /obj/item/ore/osmium
	category = "ore"
	quantity = 0
	value = 750
	trader_weight = 0

/datum/trade_item/diamond
	name = "diamond"
	item_type = /obj/item/ore/diamond
	category = "ore"
	quantity = 0
	value = 450
	trader_weight = 0

/datum/trade_item/uranium
	name = "uranium"
	item_type = /obj/item/ore/uranium
	category = "ore"
	quantity = 0
	value = 360
	trader_weight = 0

/datum/trade_item/phoron
	name = "uranium"
	item_type = /obj/item/ore/phoron
	category = "ore"
	quantity = 0
	value = 360
	trader_weight = 0

*/
