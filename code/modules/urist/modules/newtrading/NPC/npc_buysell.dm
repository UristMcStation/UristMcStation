/mob/living/simple_animal/passive/npc/proc/player_sell(obj/O, var/mob/M, var/resell = 1)
	if(no_resell)
		resell = 0
	var/worth = get_trade_value(O)	//Update the price here aswell as nanoUI updates are slow and can allow for multiple sales at the same rate
	if(!worth)
		to_chat(M,"<span class = 'warning'>It's not worth your time to do that.</span>")
		return

	if(istype(O, /obj/item/storage))
		var/obj/item/storage/S = O
		for(var/obj/I in S.contents)
			S.remove_from_storage(I, src)
			if(resell)
				try_list_for_sale(I)

			else
				qdel(I)

	if(istype(O, /obj/item/stack))
		var/obj/item/stack/S = O
		var/newworth = worth * S.amount
		worth = newworth

	else
		M.drop_from_inventory(O, src)

		//add it to the trader's inventory

		if(resell)
			try_list_for_sale(O)

		else
			qdel(O)



	M.visible_message("<span class='info'>[M] exchanges items with [src]</span>",\
		"<span class='info'>You give [O] to [src] who gives you a bundle of thalers worth Th-[worth].</span>")
	spawn_money(worth, M.loc, M)
	src.playsound_local(src.loc, "rustle", 100, 1)


/*	//add it to the trader inventory
	if(resell)
		var/datum/trade_item/T = trade_items_inventory_by_type[O.type]
		if(T)
			T.quantity += 1
			T.value = round(T.value * src.sellmodifier)		//price goes down a little
			update_trade_item_ui(T)*/

/mob/living/simple_animal/passive/npc/proc/try_list_for_sale(obj/O)
	var/datum/trade_item/T = trade_items_inventory_by_type[O.type]
	if(T)
		T.quantity += 1
		T.value = round(T.value * (1-src.price_modifier))		//price goes down a little
		update_trade_item_ui(T)
		return 1
	return 0

/mob/living/simple_animal/passive/npc/proc/player_buy(item_name, var/mob/M)
	var/datum/trade_item/D = trade_items_inventory_by_name[item_name]
	var/value = D.value
	var/obj/item/spacecash/B = M.l_hand

	if(!value) //for contracts and the like
		if(D.req_access)
			if(!CanPurchase(M, D.req_access))
				var/user_msg = "<span class='game say'><span class='name'>[src.name]</span> whispers to you, <span class='message emote'><span class='body'>\"Sorry, you're not authorized to take that.\"</span></span></span>"
				M.visible_message("<span class='info'>[src] whispers something to [M].</span>", user_msg)

			else
				GiveFreeItem(D, M)

		else
			GiveFreeItem(D, M)

	else

		if(!B || !istype(B))
			B = M.r_hand

		if(!B || !istype(B) || B.worth < value)
			var/money_phrases = list("Show me the Th-[value].","Where is the cash? Th-[value]","That's not enough, you'd be out of pocket Th-[value]","I don't do credit. That's Th-[value]")
			var/user_msg = "<span class='game say'><span class='name'>[src.name]</span> whispers to you, <span class='message emote'><span class='body'>\"[pick(money_phrases)]\"</span></span></span>"
			M.visible_message("<span class='info'>[src] whispers something to [M].</span>", user_msg)
		else

			if(D.req_access)
				if(!CanPurchase(M, D.req_access))
					var/user_msg = "<span class='game say'><span class='name'>[src.name]</span> whispers to you, <span class='message emote'><span class='body'>\"Sorry, you're not authorized to buy that.\"</span></span></span>"
					M.visible_message("<span class='info'>[src] whispers something to [M].</span>", user_msg)
				else
					if(istype (B, /obj/item/spacecash/bundle))
						//take the cash
						var/obj/item/spacecash/bundle/P = B
						var/obj/item/spacecash/bundle/payment = P.split_off(value, M)
						payment.loc = src
						qdel(payment)

					GiveItem(D, M)
			else
				if(istype (B, /obj/item/spacecash/bundle))
					//take the cash
					var/obj/item/spacecash/bundle/P = B
					var/obj/item/spacecash/bundle/payment = P.split_off(value, M)
					payment.loc = src
					qdel(payment)

				GiveItem(D, M)

/mob/living/simple_animal/passive/npc/proc/GiveItem(datum/trade_item/D, var/mob/M)
	//create the object and pass it over

	if(D.is_bulky)

		var/obj/O = new D.item_type(M.loc)

		//tell the user
		M.visible_message("<span class='info'>[M] exchanges items with [src]</span>",\
			"<span class='info'>You split off Th-[D.value] to [src] who pulls out [O] and places it in front of you.</span>") //out of where? fuck knows.

	else
		var/obj/O = new D.item_type(M.loc)
		M.put_in_hands(O)

		//tell the user
		M.visible_message("<span class='info'>[M] exchanges items with [src]</span>",\
			"<span class='info'>You split off Th-[D.value] to [src] who hands you [O].</span>")

	src.playsound_local(src.loc, "rustle", 100, 1)

	//update the inventory
	D.quantity -= 1
	D.value = round(D.value * (1+src.price_modifier))		//price goes up a little
	update_trade_item_ui(D)

/mob/living/simple_animal/passive/npc/proc/GiveFreeItem(datum/trade_item/D, var/mob/M)
	var/obj/O = new D.item_type(M.loc)
	M.put_in_hands(O)
	M.visible_message("<span class='info'>[src] hands [M] an item.</span>",\
	"<span class='info'>[src] pulls out [O] and places it in front of you.</span>")
	var/user_msg = "<span class='game say'><span class='name'>[src.name]</span> whispers to you, <span class='message emote'><span class='body'>\"Thanks for your help.\"</span></span></span>"
	M.visible_message("<span class='info'>[src] whispers something to [M].</span>", user_msg)


/mob/living/simple_animal/passive/npc/proc/CanPurchase(mob/M, var/access)
	var/obj/item/card/id/id_card = M.GetIdCard()
	var/list/L = id_card.GetAccess()
	if(has_access(access, list(), L))
		return 1
