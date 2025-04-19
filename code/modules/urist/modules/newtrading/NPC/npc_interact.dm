
/mob/living/simple_animal/passive/npc/verb/interact()
	set src in view(1)
	set name = "Interact with NPC"
	set category = "NPC"

	attack_hand(usr)

/mob/living/simple_animal/passive/npc/attack_hand(mob/living/user)
	if(src.stat != CONSCIOUS)
		to_chat(user, "[src] doesn't look like he's in any shape to trade right now...")
		interacting_mob = null
		return

	if(!can_use(user))
		return

	if(interacting_mob && !can_use(interacting_mob))
		interacting_mob = null

	if(interacting_mob && interacting_mob != user)
		to_chat(user, "[src] is already dealing with [interacting_mob]!")
		return

	current_greeting_index = rand(1, length(greetings))
	say(greetings[current_greeting_index])
	ai_holder.speak_chance = 0

	add_fingerprint(user)
	user.set_machine(src)
	interacting_mob = user
	ui_interact(user)

/mob/living/simple_animal/passive/npc/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)

	if(!can_use(user))
		close_ui(ui)
		return

	ai_holder.wander = 0
	/*spawn(600)
		wander = 1
		interacting_mob = null*/
	src.dir = get_dir(src, user)

	var/data[0]
	data["npc_name"] = src.name
	data["interact_icon"] = interact_icon
	data["interact_screen"] = interact_screen
	if(length(interact_inventory))
		data["can_trade"] = 1
	else
		data["can_trade"] = 0
	data["can_service"] = 0

	if(interact_screen == 1)
		data["greeting"] = greetings[current_greeting_index]

	else if(interact_screen == 2)
		data["interact_inventory"] = interact_inventory

		var/mob/living/carbon/M = user

		if(M.l_hand)
			data["l_hand"] = M.l_hand
			data["l_hand_icon"] = getFlatIcon(M.l_hand)
			data["l_hand_worth"] = get_trade_value(M.l_hand)
			if(check_tradeable(M.l_hand))
				data["l_sellable"] = 1
			else
				data["l_sellable"] = -1

		else

			data["l_hand"] = "empty"
			data["l_hand_icon"] = ""
			data["l_hand_worth"] = "0"
			data["l_sellable"] = 0

		if(M.r_hand)
			data["r_hand"] = M.r_hand
			data["r_hand_icon"] = getFlatIcon(M.r_hand)
			data["r_hand_worth"] = get_trade_value(M.r_hand)
			if(check_tradeable(M.r_hand))
				data["r_sellable"] = 1
			else
				data["r_sellable"] = -1

		else
			data["r_hand"] = "empty"
			data["r_hand_icon"] = ""
			data["r_hand_worth"] = "0"
			data["r_sellable"] = 0

		data["l_is_bag"] = 0
		if(istype(M.l_hand, /obj/item/storage))
			data["l_is_bag"] = 1
		data["r_is_bag"] = 0
		if(istype(M.r_hand, /obj/item/storage))
			data["r_is_bag"] = 1

	data["user"] = "\ref[user]"

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "npc.tmpl", "Talking to [src.name]", 800, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/mob/living/simple_animal/passive/npc/proc/close_ui(datum/nanoui/ui = null)
	if(ui)
		ui.close()
	interacting_mob = null
	say(pick(goodbyes))
	ai_holder.speak_chance = initial(ai_holder.speak_chance)

/mob/living/simple_animal/passive/npc/Topic(href, href_list)
	if(href_list["sell_item_l"])
		var/mob/living/carbon/M = locate(href_list["user"])
		if(M && istype(M))
			var/obj/O = M.l_hand
			player_sell(O, M)

	if(href_list["ask_question"])
		var/mob/living/carbon/M = locate(href_list["user"])
		if(say_next)
			to_chat(M,"<span class='warning'>[src] is already responding to something...</span>")

		else
			handle_question(M)

	if(href_list["sell_item_r"])
		var/mob/living/carbon/M = locate(href_list["user"])
		if(M && istype(M))
			var/obj/O = M.r_hand
			player_sell(O, M)

	if(href_list["buy_item"])
		var/mob/living/carbon/M = locate(href_list["user"])
		if(M && istype(M))
			var/item_name = href_list["buy_item"]
			player_buy(item_name, M)

	if(href_list["switch_screen"])
		interact_screen = text2num(href_list["switch_screen"])

	if(href_list["close"])
		close_ui()

/mob/living/simple_animal/passive/npc/proc/handle_question(mob/living/carbon/user)
	for(var/trigger in src.speech_triggers)

		var/datum/npc_speech_trigger/S = new trigger

		set_triggers[S.name] = S

	var/choice = input("What do you want to ask about?") as null|anything in set_triggers

	if(!choice)
		return

	var/datum/npc_speech_trigger/T = set_triggers[choice]

	if(angryspeak)
		src.say(T.get_angryresponse_phrase())

	else
		src.say(T.get_response_phrase())
