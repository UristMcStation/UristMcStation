/mob/living/simple_animal/passive/npc
	anchored = TRUE
	name = "NPC"
	desc = "npc"
	var/npc_job_title
	icon = 'code/modules/urist/modules/newtrading/NPC/npc.dmi'
	icon_state = "Human_m"
	turns_per_move = 5
	response_help = "pushes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 4
	maxHealth = 100
	health = 100
	faction = "neutral"
	var/list/jumpsuits = list()
	var/list/shoes = list()
	var/list/hats = list()
	var/hat_chance = 33
	var/list/masks = list()
	var/mask_chance = 0
	var/list/gloves = list()
	var/glove_chance = 10
	var/list/suits = list()
	var/suit_chance = 25
	var/list/glasses = list()
	var/glasses_chance = 0
	ai_holder = /datum/ai_holder/simple_animal/passive/nowandering

//	unsuitable_atoms_damage = 15
//	corpse = /obj/effect/landmark/mobcorpse/pirate
	var/weapon1 = /obj/item/melee/energy/sword/pirate

	var/list/speech_triggers = list()
	var/list/set_triggers = list()
	var/angryspeak = 0
	var/angryprob = 0

	var/icon/interact_icon
	var/mob/interacting_mob
	var/in_use = 0

	var/list/trade_items = list()
	var/list/trade_items_by_type = list()
	var/list/trade_items_inventory = list()
	var/list/trade_items_inventory_by_type = list()
	var/list/trade_items_inventory_by_name = list()
	var/list/trade_categories_by_name = list()
	var/total_trade_weight = 0
	var/starting_trade_items = 6
	//
	var/list/interact_inventory = list()
	//
	var/interact_screen = 1
	var/list/greetings = list(\
		"Hello.",\
		"How are you doing?",\
		"How can I help?",\
		"Good day.",\
		"What can I do for you?")
	var/list/goodbyes = list(\
		"See you.",\
		"See you later.",\
		"Have a good one.",\
		"Take it easy.",\
		"Later.",\
		"Bye.",\
		"Goodbye.",\
		"Bye for now.")
	var/current_greeting_index = 1
	var/list/confused_responses = list(\
		"I don't know anything about that.",\
		"Not sure.",\
		"No idea.",\
		"Can't help.",\
		"Never heard of it.")
	var/list/afraid_responses = list(\
		"Ahhh!",\
		"Oh no!",\
		"Save me!",\
		"Help!")
	var/say_time = 0
	var/say_next = 0
	var/last_afraid = 0
	var/duration_afraid = 30 SECONDS
	var/datum/controller/process/trade_controller/trade_controller_debug

	var/sell_modifier = 0.90 //how much less than the sell price will the merchants buy items from you
	var/price_modifier = 0.08 //how much the price changes on trades in % of base price. 0 is no change -- 8% increase/decrease per trade
	var/no_resell = 0

	var/npc_item_amount = 8
	var/randomize_value = 1
	var/randomize_quantity = 1
	var/inflate_value = 0 //only use this with randomize_value = 0, otherwise it will have no effect

	var/species_type = /datum/species/human
	var/datum/species/my_species
//	var/language_override = 0

/datum/ai_holder/simple_animal/passive/nowandering
	wander = FALSE
	speak_chance = 0

/datum/ai_holder/simple_animal/passive/nowandering/react_to_attack(atom/movable/attacker)
	. = ..()

	if(!attacker)
		return

	for(var/mob/living/simple_animal/hostile/scom/civ/combat/police/p in orange(7, holder))
		p.ai_holder.add_attacker(attacker)
		p.ai_holder.react_to_attack(attacker)

/mob/living/simple_animal/passive/npc/proc/can_use(mob/M)
	if(!istype(M, /mob/living) || M.stat || M.restrained() || M.lying || get_dist(M, src) > 1)
		return 0
	return 1

/mob/living/simple_animal/passive/npc/Life()
	. = ..()

	if(stat == CONSCIOUS)
		if(last_afraid)
			say_time = 0
			ai_holder.speak_chance = 0

			var/turf/target_turf = pick(view(7, src))
			for(var/i=0,i<5,i++)
				dir = get_dir(src,target_turf)
				Move(get_step_towards(src,target_turf))
				sleep(1)

			if(prob(25))
				if(prob(33))
					say(afraid_responses)
				else if(prob(50))
					audible_emote("screams in [pick("pain","fear")]!")
				else
					visible_emote("cowers to the ground.")

			if(world.time > last_afraid + duration_afraid)
				last_afraid = 0
				ai_holder.speak_chance = initial(ai_holder.speak_chance)

		else if(say_time && world.time >= say_time)
			say_time = 0
			say(say_next)

/mob/living/simple_animal/passive/npc/death(gibbed, deathmessage = "dies!", show_dead_message)
	. = ..()

	//fall over
	src.dir = 2
	var/matrix/M = src.transform
	M.Turn(90)
	M.Translate(1,-6)
	src.transform = M

/mob/living/simple_animal/passive/npc/say(var/message, var/language = LANGUAGE_GALCOM)
	..(message, language)
