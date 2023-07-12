SUBSYSTEM_DEF(trade_controller)
	name = "Trade Controller"
	flags = SS_NO_FIRE

	var/list/trade_items = list()
	var/list/trade_items_by_type = list()
	var/list/trade_categories = list()
	var/list/trade_categories_by_name = list()
	var/list/overmap_stations = list()

/datum/controller/subsystem/trade_controller/Initialize()
	for(var/category_type in typesof(/datum/trade_category) - /datum/trade_category)
		var/datum/trade_category/C = new category_type()
		trade_categories.Add(C)
		trade_categories_by_name[C.name] = C

	for(var/item_type in typesof(/datum/trade_item) - /datum/trade_item)
		var/datum/trade_item/I = new item_type()
		trade_items.Add(I)
		trade_items_by_type[I.item_type] = I
		var/datum/trade_category/C = trade_categories_by_name[I.category]
		if(C)
			C.trade_items.Add(I)
			C.trade_items_by_type[I.item_type] = I
			C.total_weighting += I.trader_weight
	for(var/mob/living/simple_animal/passive/npc/N in GLOB.simple_mob_list)
		N.generate_trade_items()

	. = ..()

/datum/controller/subsystem/trade_controller/proc/get_trade_category(category)
	return trade_categories_by_name[category]

/datum/controller/subsystem/trade_controller/proc/get_trade_item(item_type)
	return trade_items_by_type[item_type]

/datum/controller/subsystem/trade_controller/proc/get_item_category(obj/O)
	if(O.trader_category)
		return O.trader_category

/datum/controller/subsystem/trade_controller/UpdateStat()
	return
