
/mob/living/simple_animal/hostile/npc/proc/check_tradeable(var/obj/O)
	. = 0

	if(!O)
		return 0

	//check if it's a container
	if (istype(O, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = O
		for(var/obj/I in S.contents)
			if(!check_tradeable(I))
				return 0
			. = 1
		return .

	var/datum/trade_item/T = SStrade_controller.trade_items_by_type[O.type]
	if(T)
		if(!T.sellable)
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

	if(istype(tradingobject, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = tradingobject
		var/total_value = 0

		for(var/obj/I in S.contents)

			total_value += get_trade_value(I)

		return total_value

	//try and find it via the global controller
	T = SStrade_controller.trade_items_by_type[tradingobject.type]
	if(T)
		if(!T.sellable)
			return 0

		else

			return T.value

