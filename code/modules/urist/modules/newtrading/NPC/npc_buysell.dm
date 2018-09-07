
/mob/living/simple_animal/hostile/npc/proc/player_sell(var/obj/O, var/mob/M, var/worth, var/resell = 1)
	M.drop_from_inventory(O, src)
	qdel(O)
	M.visible_message("<span class='info'>[M] exchanges items with [src]</span>",\
		"<span class='info'>You give [O] to [src] who gives you a bundle of credits worth cR-[worth].</span>")
	spawn_money(worth, M.loc, M)

	//add it to the trader inventory
	if(resell)
		var/datum/trade_item/T = trade_items_inventory_by_type[O.type]
		if(T)
			T.quantity += 1
			T.value = round(T.value * src.sellmodifier)		//price goes down a little
			update_trade_item_ui(T)

/mob/living/simple_animal/hostile/npc/proc/player_buy(var/item_name, var/mob/M)
	var/datum/trade_item/D = trade_items_inventory_by_name[item_name]
	var/value = D.value
	var/obj/item/weapon/spacecash/B = M.l_hand

	if(!B || !istype(B))
		B = M.r_hand

	if(!B || !istype(B) || B.worth < value)
		var/money_phrases = list("Show me the cR-[value].","Where is the cash? cR-[value]","That's not enough, you'd be out of pocket cR-[value]","I don't do credit. That's cR-[value]")
		var/user_msg = "<span class='game say'><span class='name'>[src.name]</span> whispers to you, <span class='message emote'><span class='body'>\"[pick(money_phrases)]\"</span></span></span>"
		M.visible_message("<span class='info'>[src] whispers something to [M].</span>", user_msg)
	else

		if(istype (B, /obj/item/weapon/spacecash/bundle))
			//take the cash
			var/obj/item/weapon/spacecash/bundle/P = B
			var/obj/item/weapon/spacecash/bundle/payment = P.split_off(value, M)
			payment.loc = src
			qdel(payment)

		GiveItem(D, M)

/mob/living/simple_animal/hostile/npc/proc/GiveItem(var/datum/trade_item/D, var/mob/M)
	//create the object and pass it over

	if(D.is_bulky)

		var/obj/O = new D.item_type(M.loc)

		//tell the user
		M.visible_message("<span class='info'>[M] exchanges items with [src]</span>",\
			"<span class='info'>You split off cR-[D.value] to [src] who pulls out [O] and places it in front of you.</span>") //out of where? fuck knows.

	else
		var/obj/O = new D.item_type(M.loc)
		M.put_in_hands(O)

		//tell the user
		M.visible_message("<span class='info'>[M] exchanges items with [src]</span>",\
			"<span class='info'>You split off cR-[D.value] to [src] who hands you [O].</span>")

	//update the inventory
	D.quantity -= 1
	D.value = round(D.value * src.price_increase)		//price goes up a little
	update_trade_item_ui(D)


