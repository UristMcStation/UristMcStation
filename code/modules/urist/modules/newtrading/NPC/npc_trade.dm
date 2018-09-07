
/mob/living/simple_animal/hostile/npc/proc/check_tradeable(var/obj/O)
	. = 0

	if(!O)
		return 0

	if(O.trader_category && O.trader_category in trade_categories_by_name)
		return 1

	if(O.type in trade_items_by_type)
		return 1

/mob/living/simple_animal/hostile/npc/proc/get_trade_value(var/obj/O)
	if(!O)
		return 0

	//this uses the default SS13 item_worth procs so its a good fallback
	. = get_value(O)

	get_trade_info(O)

/mob/living/simple_animal/hostile/npc/proc/get_trade_info(var/obj/tradingobject)
	//see if we are already selling the item
	var/datum/trade_item/T = trade_items_inventory_by_type[tradingobject.type]
	if(T)
		if(!T.sellable)
			return 0

		else
			return T.value

	//check if its an accepted item
	T = trade_items_by_type[tradingobject.type]
	if(T)

		if(!T.sellable)
			return 0
		//this is in the accepted trade categories initialise the trade item but keep it hidden for now
		//note: spawn_trade_item() will slightly randomise the sale value to make it different per NPC
		else
			spawn_trade_item(T, 1)
			return T.value

	//try and find it via the global controller
	T = trade_controller.trade_items_by_type[tradingobject.type]
	if(T)
		if(!T.sellable)
			return 0

		else

			return T.value

