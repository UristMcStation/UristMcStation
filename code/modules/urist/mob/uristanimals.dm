/*										*****New space to put all UristMcStation Animals*****

Please keep it tidy, by which I mean put comments describing the item before the entry. -Glloyd */

//Fox **Icons and code by Nienhaus** What does it say?

/mob/living/simple_animal/fox
	name = "fox"
	desc = "It's a fox. I wonder what it says?"
	icon = 'icons/urist/uristicons.dmi'
	icon_state = "fox"
	icon_living = "fox"
	icon_dead = "fox_dead"
	speak = list("Ack-Ack","Ack-Ack-Ack-Ackawoooo","Purr","Awoo","Tchoff")
	speak_emote = list("purrs", "barks")
	emote_hear = list("howls","barks")
	emote_see = list("shakes its head", "shivers")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"

//Renault, the captain's fox.

/mob/living/simple_animal/fox/Renault
	name = "Renault"
	desc = "Renault, the Captain's trustworthy fox. I wonder what it says?"
	var/turns_since_scan = 0
	var/mob/living/simple_animal/mouse/movement_target

//Space bats from /tg/

/mob/living/simple_animal/hostile/retaliate/bat
	name = "Space Bat"
	desc = "A rare breed of bat which roosts in spaceships, probably not vampiric."
	icon = 'icons/urist/uristicons.dmi'
	icon_state = "bat"
	icon_living = "bat"
	icon_dead = "bat_dead"
	icon_gib = "bat_dead"
	turns_per_move = 1
	response_help = "brushes aside"
	response_disarm = "flails at"
	response_harm = "hits"
	speak_chance = 0
	a_intent = "harm"
	stop_automated_movement_when_pulled = 0
	maxHealth = 15
	health = 15
	see_in_dark = 10
	harm_intent_damage = 6
	melee_damage_lower = 6
	melee_damage_upper = 5
	attacktext = "bites"
	pass_flags = PASS_FLAG_TABLE
	faction = "carp"
	attack_sound = 'sound/weapons/bite.ogg'

	//Space bats need no air to fly in.
	min_gas = null
	max_gas = null
	minbodytemp = 0

//ARANEUS. Squee?

/mob/living/simple_animal/hostile/retaliate/bat/araneus
	desc = "A fierce companion for any person of power, this spider has been carefully trained by NanoTrasen specialists. Its beady, staring eyes send shivers down your spine"
	emote_hear = list("chitters")
	faction = "spiders"
	harm_intent_damage = 3
	health = 200
	icon = 'icons/mob/spider.dmi'
	icon_dead = "brown_dead"
	icon_gib = "brown_dead"
	icon_living = "brown"
	icon_state = "brown"
	l_move_time = 1
	maxHealth = 250
	melee_damage_lower = 15
	melee_damage_upper = 20
	name = "Araneus"
	real_name = "Araneus"
	response_help = "pets"
	turns_per_move = 10
	voice_name = "unidentifiable voice"

//TGC: Turtle, art+code by me, nothing revolutionary here.

/mob/living/simple_animal/turtle
	name = "turtle"
	desc = "Look out for bites!"
	icon = 'icons/urist/uristicons.dmi'
	icon_state = "turtle"
	icon_living = "turtle"
	icon_dead = "turtle_dead"
	//Turtles don't speak or make noise...
	emote_see = list("blinks", "snaps the air")
	turns_per_move = 10
	health = 150 //Turtles are tanky
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "hits"

/mob/living/simple_animal/turtle/mule
	name = "Mule"
	desc = "The QuarterMaster's turtle. Look out for bites!"

/*holds a random chem for animal venom
  should be used WITH copy=1 on transfer */
/obj/item/venom_sac
	name = "venom sac"
	desc = "A sac something evolved to store venom in."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "roro core"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	var/chem_type_amt = 3 //should def it probably; max chem types

	//blacklist for subtypes!
	var/list/banned_chems = list(
		/datum/reagent/adminordrazine,
		/datum/reagent/toxin/phoron/oxygen,
		/datum/reagent/water,
		/datum/reagent/antibodies,
		/datum/reagent/nutriment,
		/datum/reagent/drink,
		/datum/reagent/peridaxon,
		/datum/reagent/crayon_dust
		)

	//exceptions to the above in case you have a subtype you do want
	var/list/ban_excepted = list()

//pretty basic random chem picker; blacklist overriden and picks from 1 to argument chem types
/obj/item/venom_sac/proc/generate_venom(var/maxchems = 3)
	var/list/mix = list()
	var/new_chem = null
	var/max_chemtypes = rand(1, maxchems)
	var/list/blacklist = list() //actual utility list

	for(var/Reagent in subtypesof(/datum/reagent))
		for(var/Banned in banned_chems) //O(n^2), bleh, couldn't think of anything else
			if(istype(Reagent, Banned))
				if(!(Reagent in ban_excepted))
					blacklist += Reagent

	while (mix.len < max_chemtypes)
		new_chem = pick(subtypesof(/datum/reagent))
		if(new_chem in blacklist)
			new_chem = null
		else
			mix += new_chem

	for(var/ingredient in mix)
		if(!(src.reagents))
			src.create_reagents(chem_type_amt * 15)
		src.reagents.add_reagent(ingredient, 10, safety = 1)

/obj/item/venom_sac/New()
	..()

	if(!reagents)
		create_reagents(chem_type_amt * 10)
	generate_venom(chem_type_amt)


	//geese from Bay
/mob/living/simple_animal/hostile/retaliate/goose
	name = "goose"
	desc = "A large waterfowl, known for its beauty and quick temper when provoked."
	icon = 'icons/uristmob/goose.dmi'
	icon_state = "goose"
	icon_living = "goose"
	icon_dead = "goose_dead"
	speak = list("honk")
	speak_emote = list("honks")
	emote_see = list("flaps its wings")
	speak_chance = 1
	turns_per_move = 5
	response_help =  "pets"
	response_disarm = "gently pushes aside"
	response_harm = "strikes"
	health = 45
	maxHealth = 45
	melee_damage_lower = 5
	melee_damage_upper = 10
	pass_flags = PASS_FLAG_TABLE
	faction = "geese"
	attacktext = "strikes"
	pry_time = 8 SECONDS
	break_stuff_probability = 5


	var/enrage_potency = 3
	var/enrage_potency_loose = 4
	var/loose_threshold = 15
	var/max_damage = 22



/mob/living/simple_animal/hostile/retaliate/goose/death(gibbed, deathmessage, show_dead_message)
	. = ..()
	update_icon()

/mob/living/simple_animal/hostile/retaliate/goose/proc/enrage(potency)
//	var/obj/item/W = get_natural_weapon()
		health = (initial(health) * 1.5)
		maxHealth = (initial(maxHealth) * 1.5)
		enrage_potency = enrage_potency_loose
		desc += " The [name] is loose! Oh no!"
		update_icon()

/mob/living/simple_animal/hostile/retaliate/goose/dire
	name = "dire goose"
	desc = "A large bird. It radiates destructive energy."
	icon_state = "dire"
	icon_living = "dire"
	icon_dead = "dire_dead"
	health = 250
	maxHealth = 250
	enrage_potency = 3
	melee_damage_lower = 15
	melee_damage_upper = 35

/mob/living/simple_animal/hostile/retaliate/goose/doctor
	name = "\improper Dr. Anatidae"
	desc = "A large waterfowl, known for its beauty and quick temper when provoked. This one has a nametag, 'Dr. Anatidae'. What an odd Pet.."
	icon_state = "goose_labcoat"
	icon_living = "goose_labcoat"
	icon_dead = "goose_labcoat_dead"


//POSSUM!
/mob/living/simple_animal/opossum
	name = "opossum"
	real_name = "opossum"
	desc = "It's an opossum, a small scavenging marsupial."
	icon_state = "possum"
	item_state = "possum"
	icon_living = "possum"
	icon_dead = "possum_dead"
	icon = 'icons/uristmob/possum.dmi'
	speak_emote = list("hisses")
	speak = list("Hiss!","Aaa!","Aaa?")
	emote_hear = list("hisses")
	emote_see = list("forages for trash", "lounges")
	speak_chance = 1
	pass_flags = PASS_FLAG_TABLE
	turns_per_move = 3
	see_in_dark = 6
	maxHealth = 50
	health = 50
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "stamps on"
	density = FALSE
	minbodytemp = 223
	maxbodytemp = 323
	universal_speak = FALSE
	universal_understand = TRUE
	holder_type = /obj/item/weapon/holder/possum
	mob_size = MOB_SMALL
	possession_candidate = 1
	can_escape = TRUE
	can_pull_size = ITEM_SIZE_SMALL
	can_pull_mobs = MOB_PULL_SMALLER
	var/is_angry = FALSE




/mob/living/simple_animal/opossum/adjustBruteLoss(damage)
	. = ..()
	if(damage >= 3)
		respond_to_damage()





/mob/living/simple_animal/opossum/proc/respond_to_damage()
	if(!resting && stat == CONSCIOUS)
		if(!is_angry)
			is_angry = TRUE
			custom_emote(src, "hisses!")
		else
			resting = TRUE
			custom_emote(src, "dies!")
		update_icon()

/mob/living/simple_animal/opossum/on_update_icon()

	if(stat == DEAD || (resting && is_angry))
		icon_state = icon_dead
	else if(resting || stat == UNCONSCIOUS)
		icon_state = "[icon_living]_sleep"
	else if(is_angry)
		icon_state = "[icon_living]_aaa"
	else
		icon_state = icon_living

/mob/living/simple_animal/opossum/Initialize()
	. = ..()
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

/mob/living/simple_animal/opossum/poppy
	name = "Poppy the Safety Possum"
	desc = "It's an opossum, a small scavenging marsupial. It's wearing appropriate personal protective equipment, though."
	icon_state = "poppy"
	item_state = "poppy"
	icon_living = "poppy"
	icon_dead = "poppy_dead"
	holder_type = /obj/item/weapon/holder/possum/poppy
	var/aaa_words = list("delaminat", "meteor", "fire", "breach")

/mob/living/simple_animal/opossum/poppy/hear_broadcast(datum/language/language, mob/speaker, speaker_name, message)
  . = ..()
  check_keywords(message)

/mob/living/simple_animal/opossum/poppy/hear_say(message, verb = "says", datum/language/language = null, alt_name = "",italics = 0, mob/speaker = null, sound/speech_sound, sound_vol)
  . = ..()
  check_keywords(message)

/mob/living/simple_animal/opossum/poppy/proc/check_keywords(message)
	if(!client && stat == CONSCIOUS)
		message = lowertext(message)
		for(var/aaa in aaa_words)
			if(findtext(message, aaa))
				respond_to_damage()
				return

