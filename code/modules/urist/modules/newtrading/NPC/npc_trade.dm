
/mob/living/simple_animal/passive/npc/proc/check_tradeable(obj/O)
	. = 0

	if(!O)
		return 0

	//check if it's a container
	if (istype(O, /obj/item/storage))
		var/obj/item/storage/S = O
		for(var/obj/I in S.contents)
			if(!check_tradeable(I))
				return 0
			. = 1
		return .

	var/datum/trade_item/T = SStrade_controller.trade_items_by_type[O.type]
	if(T)
		if(!T.sellable)
			return 0

	if(O.trader_category && (O.trader_category in trade_categories_by_name))
		return 1

	if(O.type in trade_items_by_type)
		return 1

/mob/living/simple_animal/passive/npc/proc/get_trade_value(obj/O, count = 1)
	if(!O)
		return 0

	//this uses the default SS13 item_worth procs so its a good fallback
	var/worth = get_trade_info(O, count)

	return isnull(worth) ? get_value(O)*count : worth

/mob/living/simple_animal/passive/npc/proc/get_trade_info(obj/tradingobject, count)
	//see if we are already selling the item
	var/datum/trade_item/T = trade_items_inventory_by_type[tradingobject.type]
	if(T)
		if(!T.sellable)
			return 0

		if(count > 1)
			return calculate_multiple_sales(T, count)	//As price changes are % based, this compounds. Let's calculate that

		return round(T.value * sell_modifier)

	//check if its an accepted item
	T = trade_items_by_type[tradingobject.type]
	if(T)

		if(!T.sellable)
			return 0
		//this is in the accepted trade categories initialise the trade item but keep it hidden for now
		//note: spawn_trade_item() will slightly randomise the sale value to make it different per NPC

		spawn_trade_item(T, 1)
		if(count > 1)
			return calculate_multiple_sales(T, count)

		return round(T.value * sell_modifier)

	if(istype(tradingobject, /obj/item/storage))
		var/obj/item/storage/S = tradingobject
		var/total_value = 0
		var/list/tempItems = list()
		for(var/obj/I in S.contents)
			if(tempItems[I.type])
				tempItems[I.type]["count"]++
			else
				tempItems[I.type] = list("obj" = I, "count" = 1)
		for(var/k in tempItems)
			var/list/v = tempItems[k]
			total_value += get_trade_value(v["obj"], v["count"])

		return total_value

	//try and find it via the global controller
	T = SStrade_controller.trade_items_by_type[tradingobject.type]
	if(T)
		if(!T.sellable)
			return 0

		if(count > 1)
			return calculate_multiple_sales(T, count)

		return round(T.value * sell_modifier)

/mob/living/simple_animal/passive/npc/proc/calculate_multiple_sales(datum/trade_item/T , count)
	if(!T || !count)
		return
	var/newPrice = T.value
	var/total_value = round(T.value * sell_modifier)	//Price changes AFTER an obj is sold. Let's skip the first trade then.
	count--
	while(count)
		newPrice = round((newPrice * (1-src.price_modifier)) * sell_modifier)	//Calculate what the new price would be with the devalue of selling individually, then apply the selling modifier
		total_value += newPrice
		count--
	return total_value
