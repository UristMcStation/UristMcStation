/* Parrots!
 * Contains
 * 		Defines
 *		Inventory (headset stuff)
 *		Attack responses
 *		AI
 *		Procs / Verbs (usable by players)
 *		Poly
 */

/*
 * Defines
 */

//Only a maximum of one action and one intent should be active at any given time.
//Actions
#define PARROT_PERCH 1		//Sitting/sleeping, not moving
#define PARROT_SWOOP 2		//Moving towards or away from a target
#define PARROT_WANDER 4		//Moving without a specific target in mind

//Intents
#define PARROT_STEAL 8		//Flying towards a target to steal it/from it
#define PARROT_ATTACK 16	//Flying towards a target to attack it
#define PARROT_RETURN 32	//Flying towards its perch
#define PARROT_FLEE 64		//Flying away from its attacker


/mob/living/simple_animal/hostile/retaliate/parrot
	name = "parrot"
	desc = "A large, colourful tropical bird native to Earth, known for its strong beak and ability to mimic speech."
	icon = 'icons/mob/simple_animal/parrot.dmi'
	icon_state = "parrot_fly"
	icon_living = "parrot_fly"
	icon_dead = "parrot_dead"
	pass_flags = PASS_FLAG_TABLE
	mob_size = MOB_SMALL

	blocks_emissive = EMISSIVE_BLOCK_UNIQUE

	speak_emote = list("squawks","says","yells")

	natural_weapon = /obj/item/natural_weapon/beak
	turns_per_move = 5
	meat_type = /obj/item/reagent_containers/food/snacks/cracker

	response_help  = "pets"
	response_disarm = "gently moves aside"
	response_harm   = "swats"
	universal_speak = TRUE

	meat_type = /obj/item/reagent_containers/food/snacks/meat/chicken/game
	meat_amount = 3
	skin_material = MATERIAL_SKIN_FEATHERS

	var/parrot_state = PARROT_WANDER //Hunt for a perch when created
	var/parrot_sleep_max = 25 //The time the parrot sits while perched before looking around. Mostly a way to avoid the parrot's AI in life() being run every single tick.
	var/parrot_sleep_dur = 25 //Same as above, this is the var that physically counts down
	var/parrot_dam_zone = list(BP_CHEST, BP_HEAD, BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG) //For humans, select a bodypart to attack

	var/parrot_speed = 5 //"Delay in world ticks between movement." according to byond. Yeah, that's BS but it does directly affect movement. Higher number = slower.
	var/parrot_been_shot = 0 //Parrots get a speed bonus after being shot. This will deincrement every Life() and at 0 the parrot will return to regular speed.

	var/list/speech_buffer = list()
	var/list/available_channels = list()

	//Headset for Poly to yell at engineers :)
	var/obj/item/device/radio/headset/ears = null

	//The thing the parrot is currently interested in. This gets used for items the parrot wants to pick up, mobs it wants to steal from,
	//mobs it wants to attack or mobs that have attacked it
	var/atom/movable/parrot_interest = null

	//Parrots will generally sit on their perch unless something catches their eye.
	//These vars store their preferred perch and if they don't have one, what they can use as a perch
	var/obj/parrot_perch = null
	var/list/desired_perches = list(
		/obj/machinery/constructable_frame/computerframe,
		/obj/structure/displaycase,
		/obj/structure/filingcabinet,
		/obj/machinery/computer,
		/obj/machinery/telecomms,
		/obj/machinery/nuclearbomb,
		/obj/machinery/particle_accelerator,
		/obj/machinery/recharge_station,
		/obj/machinery/smartfridge,
		/obj/machinery/suit_storage_unit,
		/obj/structure/showcase,
		/obj/structure/fountain
	)

	//Parrots are kleptomaniacs. This variable ... stores the item a parrot is holding.
	var/obj/item/held_item = null

	var/simple_parrot = FALSE //simple parrots ignore all the cool stuff that occupies bulk of this file
	var/relax_chance = 75 //we're only little and we know it
	var/parrot_isize = ITEM_SIZE_SMALL
	var/impatience = 5 //we lose this much from relax_chance each time we calm down
	var/icon_set = "parrot"

	var/list/spawn_headset_options = list(
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/device/radio/headset/headset_eng,
		/obj/item/device/radio/headset/headset_med,
		/obj/item/device/radio/headset/headset_sci,
		/obj/item/device/radio/headset/headset_cargo
	)

	ai_holder = /datum/ai_holder/simple_animal/retaliate/parrot


/mob/living/simple_animal/hostile/retaliate/parrot/Initialize(mapload)
	. = ..()
	if (!ears && length(spawn_headset_options))
		var/headset = pick(spawn_headset_options)
		ears = new headset(src)

	icon_state = "[icon_set]_fly"
	icon_living = "[icon_set]_fly"
	icon_dead = "[icon_set]_dead"

	parrot_sleep_dur = parrot_sleep_max //In case someone decides to change the max without changing the duration var

	verbs += /mob/living/simple_animal/hostile/retaliate/parrot/proc/steal_from_ground
	verbs += /mob/living/simple_animal/hostile/retaliate/parrot/proc/steal_from_mob
	verbs += /mob/living/simple_animal/hostile/retaliate/parrot/verb/drop_held_item_player
	verbs += /mob/living/simple_animal/hostile/retaliate/parrot/proc/perch_player

	icon_state = "[icon_set]_fly"
	icon_living = "[icon_set]_fly"
	icon_dead = "[icon_set]_dead"

	update_icon()

/mob/living/simple_animal/hostile/retaliate/parrot/death(gibbed, deathmessage, show_dead_message)
	if(held_item)
		held_item.dropInto(loc)
		held_item = null
	walk(src,0)
	..(gibbed, deathmessage, show_dead_message)

/mob/living/simple_animal/hostile/retaliate/parrot/Stat()
	. = ..()
	stat("Held Item", held_item)

/*
 * Inventory
 */
/mob/living/simple_animal/hostile/retaliate/parrot/show_inv(mob/user as mob)
	user.set_machine(src)
	if(user.stat) return

	var/dat = 	"<div align='center'><b>Inventory of [name]</b></div><p>"
	if(ears)
		dat +=	"<br><b>Headset:</b> [ears] (<a href='byond://?src=\ref[src];remove_inv=ears'>Remove</a>)"
	else
		dat +=	"<br><b>Headset:</b> <a href='byond://?src=\ref[src];add_inv=ears'>Nothing</a>"

	show_browser(user, dat, text("window=mob[];size=325x500", name))
	onclose(user, "mob[real_name]")
	return

/mob/living/simple_animal/hostile/retaliate/parrot/DefaultTopicState()
	return GLOB.physical_state

/mob/living/simple_animal/hostile/retaliate/parrot/OnTopic(mob/user, href_list)
	//Is the user's mob type able to do this?
	if(ishuman(user) || issmall(user) || isrobot(user))

		//Removing from inventory
		if(href_list["remove_inv"])
			var/remove_from = href_list["remove_inv"]
			switch(remove_from)
				if("ears")
					if(ears)
						if(length(available_channels))
							src.say("[pick(available_channels)] BAWWWWWK LEAVE THE HEADSET BAWKKKKK!")
						else
							src.say("BAWWWWWK LEAVE THE HEADSET BAWKKKKK!")
						ears.dropInto(loc)
						ears = null
						for(var/possible_phrase in say_list.speak)
							if(copytext(possible_phrase,1,3) in department_radio_keys)
								possible_phrase = copytext(possible_phrase,3,length(possible_phrase))
					else
						to_chat(user, SPAN_WARNING("There is nothing to remove from its [remove_from]."))
			return TOPIC_HANDLED

		//Adding things to inventory
		if(href_list["add_inv"])
			var/add_to = href_list["add_inv"]
			if(!user.get_active_hand())
				to_chat(user, SPAN_WARNING("You have nothing in your hand to put on its [add_to]."))
				return TOPIC_HANDLED
			switch(add_to)
				if("ears")
					if(ears)
						to_chat(user, SPAN_WARNING("It's already wearing something."))
						return TOPIC_HANDLED
					else
						var/obj/item/item_to_add = usr.get_active_hand()
						if(!item_to_add)
							return TOPIC_HANDLED

						if( !istype(item_to_add,  /obj/item/device/radio/headset) )
							to_chat(user, SPAN_WARNING("This object won't fit."))
							return TOPIC_HANDLED
						if(!user.unEquip(item_to_add, src))
							return TOPIC_HANDLED
						var/obj/item/device/radio/headset/headset_to_add = item_to_add

						src.ears = headset_to_add
						to_chat(user, "You fit the headset onto [src].")

						available_channels.Cut()
						for(var/ch in headset_to_add.channels)
							switch(ch)
								if("Engineering")
									available_channels.Add(":e")
								if("Command")
									available_channels.Add(":c")
								if("Security")
									available_channels.Add(":s")
								if("Science")
									available_channels.Add(":n")
								if("Medical")
									available_channels.Add(":m")
								if("Mining")
									available_channels.Add(":d")
								if("Cargo")
									available_channels.Add(":q")
			return TOPIC_HANDLED

	return ..()


/*
 * Attack responces
 */
//Humans, monkeys, aliens
/mob/living/simple_animal/hostile/retaliate/parrot/attack_hand(mob/living/carbon/M as mob)
	..()
	if(client)
		return

	if(simple_parrot) //all the real stuff gets handled in /hostile/retaliate
		return

	if(!stat && M.a_intent == I_HURT)
		icon_state = "[icon_set]_fly" //It is going to be flying regardless of whether it flees or attacks

		if(parrot_state == PARROT_PERCH)
			parrot_sleep_dur = parrot_sleep_max //Reset it's sleep timer if it was perched

		parrot_interest = M
		parrot_state = PARROT_SWOOP //The parrot just got hit, it WILL move, now to pick a direction..

		if(M.health < 50) //Weakened mob? Fight back!
			parrot_state |= PARROT_ATTACK
		else
			parrot_state |= PARROT_FLEE		//Otherwise, fly like a bat out of hell!
			drop_held_item(0)
	return


/mob/living/simple_animal/hostile/retaliate/parrot/post_use_item(obj/item/tool, mob/user, interaction_handled, use_call, click_params)
	..()

	// React to being hit
	if ((use_call == "weapon" || use_call == "use") && !stat && !client)
		if (parrot_state == PARROT_PERCH)
			parrot_sleep_dur = parrot_sleep_max //Reset it's sleep timer if it was perched

		parrot_interest = user
		parrot_state = PARROT_SWOOP | PARROT_FLEE
		icon_state = "[icon_set]_fly"
		drop_held_item(FALSE)


//Bullets
/mob/living/simple_animal/hostile/retaliate/parrot/bullet_act(obj/item/projectile/Proj)
	if (status_flags & GODMODE)
		return PROJECTILE_FORCE_MISS
	..()
	if(!stat && !client)
		if(parrot_state == PARROT_PERCH)
			parrot_sleep_dur = parrot_sleep_max //Reset it's sleep timer if it was perched

		parrot_interest = null
		parrot_state = PARROT_WANDER //OWFUCK, Been shot! RUN LIKE HELL!
		parrot_been_shot += 5
		icon_state = "[icon_set]_fly"
		drop_held_item(0)
	return


/*
 * AI - Not really intelligent, but I'm calling it AI anyway.
 */
/mob/living/simple_animal/hostile/retaliate/parrot/Life()
	. = ..()
	if(!.)
		return FALSE

	if(length(ai_holder.attackers) && prob(relax_chance))
		give_up()

	if(simple_parrot)
		return FALSE

	//Sprite and AI update for when a parrot gets pulled
	if(pulledby && stat == CONSCIOUS)
		icon_state = "[icon_set]_fly"
		if(!client)
			parrot_state = PARROT_WANDER
		return

	if(client || stat)
		return //Lets not force players or dead/incap parrots to move

	if(!isturf(src.loc))
		return // Let's not bother in nullspace


//-----SPEECH
	/* Parrot speech mimickry!
	   Phrases that the parrot hears in mob/living/say() get added to speach_buffer.
	   Every once in a while, the parrot picks one of the lines from the buffer and replaces an element of the 'speech' list.
	   Then it clears the buffer to make sure they don't magically remember something from hours ago. */
	if(length(speech_buffer) && prob(10))
		if(length(say_list.speak))
			say_list.speak.Remove(pick(say_list.speak))

		say_list.speak.Add(pick(speech_buffer))
		speech_buffer.Cut()

//-----SLEEPING
	if(parrot_state == PARROT_PERCH)
		if(parrot_perch && parrot_perch.loc != src.loc) //Make sure someone hasnt moved our perch on us
			if(parrot_perch in view(src))
				parrot_state = PARROT_SWOOP | PARROT_RETURN
				icon_state = "[icon_set]_fly"
				return
			else
				parrot_state = PARROT_WANDER
				icon_state = "[icon_set]_fly"
				return

		if(--parrot_sleep_dur) //Zzz
			return

		else
			//This way we only call the stuff below once every [sleep_max] ticks.
			parrot_sleep_dur = parrot_sleep_max

			//Cycle through message modes for the headset
			if(length(say_list.speak))
				var/list/newspeak = list()

				if(length(available_channels) && src.ears)
					for(var/possible_phrase in say_list.speak)

						//50/50 chance to not use the radio at all
						var/useradio = 0
						if(prob(50))
							useradio = 1

						if(copytext(possible_phrase,1,3) in department_radio_keys)
							possible_phrase = "[useradio?pick(available_channels):""] [copytext(possible_phrase,3,length(possible_phrase)+1)]" //crop out the channel prefix
						else
							possible_phrase = "[useradio?pick(available_channels):""] [possible_phrase]"

						newspeak.Add(possible_phrase)

				else //If we have no headset or channels to use, don't try to use any!
					for(var/possible_phrase in say_list.speak)
						if(copytext(possible_phrase,1,3) in department_radio_keys)
							possible_phrase = "[copytext(possible_phrase,3,length(possible_phrase)+1)]" //crop out the channel prefix
						newspeak.Add(possible_phrase)
				say_list.speak = newspeak

			//Search for item to steal
			parrot_interest = search_for_item()
			if(parrot_interest)
				visible_emote("looks in [parrot_interest]'s direction and takes flight")
				parrot_state = PARROT_SWOOP | PARROT_STEAL
				icon_state = "[icon_set]_fly"
			return

//-----WANDERING - This is basically a 'I don't know what to do yet' state
	else if(parrot_state == PARROT_WANDER)
		//Stop movement, we'll set it later
		walk(src, 0)
		parrot_interest = null

		//Wander around aimlessly. This will help keep the loops from searches down
		//and possibly move the mob into a new are in view of something they can use
		if(prob(90))
			SelfMove(pick(GLOB.cardinal))
			return

		if(!held_item && !parrot_perch) //If we've got nothing to do.. look for something to do.
			var/atom/movable/AM = search_for_perch_and_item() //This handles checking through lists so we know it's either a perch or stealable item
			if(AM)
				if((isitem(AM) && can_pick_up(AM)) || isliving(AM))	//If stealable item
					parrot_interest = AM
					visible_emote("turns and flies towards [parrot_interest]")
					parrot_state = PARROT_SWOOP | PARROT_STEAL
					return
				else	//Else it's a perch
					parrot_perch = AM
					parrot_state = PARROT_SWOOP | PARROT_RETURN
					return
			return

		if(parrot_interest && (parrot_interest in view(src)))
			parrot_state = PARROT_SWOOP | PARROT_STEAL
			return

		if(parrot_perch && (parrot_perch in view(src)))
			parrot_state = PARROT_SWOOP | PARROT_RETURN
			return

		else //Have an item but no perch? Find one!
			parrot_perch = search_for_perch()
			if(parrot_perch)
				parrot_state = PARROT_SWOOP | PARROT_RETURN
				return
//-----STEALING
	else if(parrot_state == (PARROT_SWOOP | PARROT_STEAL))
		walk(src,0)
		if(!parrot_interest || held_item)
			parrot_state = PARROT_SWOOP | PARROT_RETURN
			return

		if(!(parrot_interest in view(src)))
			parrot_state = PARROT_SWOOP | PARROT_RETURN
			return

		if(in_range(src, parrot_interest))

			if(isliving(parrot_interest))
				steal_from_mob()

			if(isitem(parrot_interest) && can_pick_up(parrot_interest))//This should ensure that we only grab the item we want, and make sure it's not already collected on our perch, a correct size, and not bolted to the floor
				if(!parrot_perch || parrot_interest.loc != parrot_perch.loc)
					held_item = parrot_interest
					parrot_interest.forceMove(src)
					visible_message("[src] grabs \the [held_item]!", SPAN_NOTICE("You grab \the [held_item]!"), "You hear the sounds of wings flapping furiously.")

			parrot_interest = null
			parrot_state = PARROT_SWOOP | PARROT_RETURN
			return

		walk_to(src, parrot_interest, 1, parrot_speed)
		return

//-----RETURNING TO PERCH
	else if(parrot_state == (PARROT_SWOOP | PARROT_RETURN))
		walk(src, 0)
		if(!parrot_perch || !isturf(parrot_perch.loc)) //Make sure the perch exists and somehow isnt inside of something else.
			parrot_perch = null
			parrot_state = PARROT_WANDER
			return

		if(in_range(src, parrot_perch))
			forceMove(parrot_perch.loc)
			drop_held_item()
			parrot_state = PARROT_PERCH
			icon_state = "[icon_set]_sit"
			return

		walk_to(src, parrot_perch, 1, parrot_speed)
		return

//-----FLEEING
	else if(parrot_state == (PARROT_SWOOP | PARROT_FLEE))
		walk(src,0)
		give_up()
		if(!parrot_interest || !isliving(parrot_interest)) //Sanity
			parrot_state = PARROT_WANDER

		walk_away(src, parrot_interest, 1, parrot_speed-parrot_been_shot)
		parrot_been_shot--
		return

//-----ATTACKING
	else if(parrot_state == (PARROT_SWOOP | PARROT_ATTACK))

		//If we're attacking a nothing, an object, a turf or a ghost for some stupid reason, switch to wander
		if(!parrot_interest || !isliving(parrot_interest))
			parrot_interest = null
			parrot_state = PARROT_WANDER
			return

		var/mob/living/L = parrot_interest

		//If the mob is close enough to interact with
		if(in_range(src, parrot_interest))

			//If the mob we've been chasing/attacking dies or falls into crit, check for loot!
			if(L.stat)
				parrot_interest = null
				if(!held_item)
					held_item = steal_from_ground()
					if(!held_item)
						held_item = steal_from_mob() //Apparently it's possible for dead mobs to hang onto items in certain circumstances.
				if(parrot_perch in view(src)) //If we have a home nearby, go to it, otherwise find a new home
					parrot_state = PARROT_SWOOP | PARROT_RETURN
				else
					parrot_state = PARROT_WANDER
				return

			//Time for the hurt to begin!
			var/obj/item/weapon = get_natural_weapon()
			weapon.resolve_attackby(L, src)
			return

		//Otherwise, fly towards the mob!
		else
			walk_to(src, parrot_interest, 1, parrot_speed)
		return

//-----STATE MISHAP
	else //This should not happen. If it does lets reset everything and try again
		walk(src,0)
		parrot_interest = null
		parrot_perch = null
		drop_held_item()
		parrot_state = PARROT_WANDER
		return

/*
 * Procs
 */

/mob/living/simple_animal/hostile/retaliate/parrot/movement_delay(singleton/move_intent/using_intent = move_intent)
	if(client && stat == CONSCIOUS && parrot_state != "parrot_fly")
		icon_state = "[icon_set]_fly"
	..()

/mob/living/simple_animal/hostile/retaliate/parrot/proc/search_for_item()
	for(var/atom/movable/AM in view(src))
		//Skip items we already stole or are wearing or are too big
		if(parrot_perch && AM.loc == parrot_perch.loc || AM.loc == src)
			continue

		if(isitem(AM) && can_pick_up(AM))
			return AM

		if(iscarbon(AM))
			var/mob/living/carbon/C = AM
			for (var/obj/item as anything in C.GetAllHeld())
				if (can_pick_up(item))
					return C
	return null

/mob/living/simple_animal/hostile/retaliate/parrot/proc/search_for_perch()
	for(var/obj/O in view(src))
		for(var/path in desired_perches)
			if(istype(O, path))
				return O
	return null

//This proc was made to save on doing two 'in view' loops seperatly
/mob/living/simple_animal/hostile/retaliate/parrot/proc/search_for_perch_and_item()
	for(var/atom/movable/AM in view(src))
		for(var/perch_path in desired_perches)
			if(istype(AM, perch_path))
				return AM

		//Skip items we already stole or are wearing or are too big
		if(parrot_perch && AM.loc == parrot_perch.loc || AM.loc == src)
			continue

		if(isitem(AM) && can_pick_up(AM))
			return AM

		if(iscarbon(AM))
			var/mob/living/carbon/C = AM
			for (var/obj/item as anything in C.GetAllHeld())
				if (can_pick_up(item))
					return C
	return null

/mob/living/simple_animal/hostile/retaliate/parrot/proc/give_up()
	ai_holder.attackers = list()
	ai_holder.lose_target()
	visible_message(SPAN_NOTICE("\The [src] seems to calm down."))
	relax_chance -= impatience

/*
 * Verbs - These are actually procs, but can be used as verbs by player-controlled parrots.
 */
/mob/living/simple_animal/hostile/retaliate/parrot/proc/steal_from_ground()
	set name = "Steal from ground"
	set category = "Parrot"
	set desc = "Grabs a nearby item."

	if(stat)
		return -1

	if(held_item)
		to_chat(src, SPAN_WARNING("You are already holding the [held_item]"))
		return 1

	for(var/obj/item/I in view(1,src))
		//Make sure we're not already holding it and it's small enough
		if(I.loc != src && can_pick_up(I))

			//If we have a perch and the item is sitting on it, continue
			if(!client && parrot_perch && I.loc == parrot_perch.loc)
				continue

			held_item = I
			I.forceMove(src)
			visible_message("[src] grabs \the [held_item]!", SPAN_NOTICE("You grab \the [held_item]!"), "You hear the sounds of wings flapping furiously.")
			return held_item

	to_chat(src, SPAN_WARNING("There is nothing of interest to take."))
	return 0

/mob/living/simple_animal/hostile/retaliate/parrot/proc/steal_from_mob()
	set name = "Steal from mob"
	set category = "Parrot"
	set desc = "Steals an item right out of a person's hand!"

	if(stat)
		return -1

	if(held_item)
		to_chat(src, SPAN_WARNING("You are already holding the [held_item]"))
		return 1

	var/obj/item/stolen_item = null

	for(var/mob/living/carbon/C in view(1,src))
		for (var/obj/item as anything in C.GetAllHeld())
			if (can_pick_up(item))
				stolen_item = item
				break

		if(stolen_item && C.unEquip(stolen_item, src))
			held_item = stolen_item
			visible_message("[src] grabs \the [held_item] out of [C]'s hand!", SPAN_WARNING("You snag \the [held_item] out of [C]'s hand!"), "You hear the sounds of wings flapping furiously.")
			return held_item

	to_chat(src, SPAN_WARNING("There is nothing of interest to take."))
	return 0

/mob/living/simple_animal/hostile/retaliate/parrot/verb/drop_held_item_player()
	set name = "Drop held item"
	set category = "Parrot"
	set desc = "Drop the item you're holding."

	if(stat)
		return

	src.drop_held_item()

	return

/mob/living/simple_animal/hostile/retaliate/parrot/proc/drop_held_item(drop_gently = 1)
	set name = "Drop held item"
	set category = "Parrot"
	set desc = "Drop the item you're holding."

	if(stat)
		return -1

	if(!held_item)
		to_chat(src, SPAN_WARNING("You have nothing to drop!"))
		return 0

	if(!drop_gently)
		if(istype(held_item, /obj/item/grenade))
			var/obj/item/grenade/G = held_item
			G.dropInto(loc)
			G.detonate()
			to_chat(src, "You let go of \the [held_item]!")
			held_item = null
			return 1

	to_chat(src, "You drop \the [held_item].")

	held_item.dropInto(loc)
	held_item = null
	return 1

/mob/living/simple_animal/hostile/retaliate/parrot/proc/perch_player()
	set name = "Sit"
	set category = "Parrot"
	set desc = "Sit on a nice comfy perch."

	if(stat || !client)
		return

	if(icon_state == "[icon_set]_fly")
		for(var/atom/movable/AM in view(src,1))
			for(var/perch_path in desired_perches)
				if(istype(AM, perch_path))
					forceMove(AM.loc)
					icon_state = "[icon_set]_sit"
					return
	to_chat(src, SPAN_WARNING("There is no perch nearby to sit on."))
	return

/*
 * Sub-types
 */
/mob/living/simple_animal/hostile/retaliate/parrot/Poly
	name = "Poly"
	desc = "Poly the Parrot. An expert on quantum cracker theory."
	spawn_headset_options = list(/obj/item/device/radio/headset/headset_eng)


/mob/living/simple_animal/hostile/retaliate/parrot/say(message)

	if(stat)
		return

	var/verb = "says"
	if(length(speak_emote))
		verb = pick(speak_emote)


	var/message_mode=""
	if(copytext_char(message,1,2) == get_prefix_key(/singleton/prefix/radio_main_channel))
		message_mode = "headset"
		message = copytext(message,2)

	if(length(message) >= 2)
		var/channel_prefix = copytext(message, 1 ,3)
		message_mode = department_radio_keys[channel_prefix]

	if(copytext_char(message,1,2) == get_prefix_key(/singleton/prefix/radio_channel_selection))
		var/positioncut = 3
		message = trimtext(copytext(message,positioncut))

	message = capitalize(trim_left(message))

	if(message_mode)
		if(message_mode in radiochannels)
			if(ears && istype(ears,/obj/item/device/radio))
				ears.talk_into(src,sanitize(message), message_mode, verb, null)


	..(message)


/mob/living/simple_animal/hostile/retaliate/parrot/hear_say(message, verb = "says", datum/language/language = null, alt_name = "",italics = 0, mob/speaker = null)
	if(prob(50))
		parrot_hear(message)
	..()



/mob/living/simple_animal/hostile/retaliate/parrot/hear_radio(message, verb="says", datum/language/language=null, part_a, part_b, part_c, mob/speaker = null, hard_to_hear = 0)
	if(prob(50) && length(available_channels))
		parrot_hear("[pick(available_channels)] [message]")
	..()


/mob/living/simple_animal/hostile/retaliate/parrot/proc/parrot_hear(message="")
	if(!message || stat)
		return
	speech_buffer.Add(message)

/mob/living/simple_animal/hostile/retaliate/parrot/attack_generic(mob/user, damage, attack_message)
	if(client)
		return

	if(parrot_state == PARROT_PERCH)
		parrot_sleep_dur = parrot_sleep_max //Reset it's sleep timer if it was perched

	if(!damage)
		return

	parrot_interest = user
	parrot_state = PARROT_SWOOP | PARROT_ATTACK //Attack other animals regardless
	icon_state = "[icon_set]_fly"

/mob/living/simple_animal/hostile/retaliate/parrot/proc/can_pick_up(obj/item/I)
	. = (Adjacent(I) && I.w_class <= parrot_isize && !I.anchored)

/datum/ai_holder/simple_animal/retaliate/parrot
	speak_chance = 1
