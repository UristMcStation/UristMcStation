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
	/mob/living/simple_animal/hostile/retaliate/bat/goose
	name = "goose"
	desc = "A large waterfowl, known for its beauty and quick temper when provoked."
	icon = 'icons/uristmob/goose.dmi'
	icon_state = "goose"
	icon_living = "goose"
	icon_dead = "goose_dead"
	speak_emote = list("honks")
	response_help =  "pets"
	response_disarm = "gently pushes aside"
	response_harm = "strikes"
	health = 45
	maxHealth = 45
	natural_weapon = /obj/item/natural_weapon/goosefeet
	pass_flags = PASS_FLAG_TABLE
	faction = "geese"
	pry_time = 8 SECONDS
	break_stuff_probability = 5


	var/enrage_potency = 3
	var/enrage_potency_loose = 4
	var/loose_threshold = 15
	var/max_damage = 22
	var/loose = FALSE //goose loose status

	ai_holder = /datum/ai_holder/simple_animal/retaliate/bat/goose
	say_list_type = /datum/say_list/goose


/datum/ai_holder/simple_animal/retaliate/bat/goose/react_to_attack(atom/movable/attacker)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/bat/goose/G = holder
	if(G.stat == CONSCIOUS)
		G.enrage(G.enrage_potency)

/obj/item/natural_weapon/goosefeet
	name = "goose feet"
	gender = PLURAL
	attack_verb = list("smacked around")
	force = 0
	damtype = DAMAGE_BRUTE
	canremove = FALSE

/mob/living/simple_animal/hostile/retaliate/bat/goose/on_update_icon()
	if(stat == DEAD)
		icon_state = icon_dead
	else if(loose)
		icon_state = "goose_loose"
		icon_living = "goose_loose"

/mob/living/simple_animal/hostile/retaliate/bat/goose/death(gibbed, deathmessage, show_dead_message)
	. = ..()
	update_icon()

/mob/living/simple_animal/hostile/retaliate/bat/goose/proc/enrage(potency)
	var/obj/item/W = get_natural_weapon()
	if(W)
		W.force = min((W.force + potency), max_damage)
	if(!loose && prob(25) && (W && W.force >= loose_threshold)) //second wind
		loose = TRUE
		health = (initial(health) * 1.5)
		maxHealth = (initial(maxHealth) * 1.5)
		enrage_potency = enrage_potency_loose
		desc += " The [name] is loose! Oh no!"
		update_icon()

/mob/living/simple_animal/hostile/retaliate/bat/goose/dire
	name = "dire goose"
	desc = "A large bird. It radiates destructive energy."
	icon_state = "dire"
	icon_living = "dire"
	icon_dead = "dire_dead"
	health = 250
	maxHealth = 250
	enrage_potency = 3
	loose_threshold = 20
	max_damage = 35

/mob/living/simple_animal/hostile/retaliate/bat/goose/doctor
	name = "\improper Dr. Anatidae"
	desc = "A large waterfowl, known for its beauty and quick temper when provoked. This one has a nametag, 'Dr. Anatidae'. What an odd Pet.."
	icon_state = "goose_labcoat"
	icon_living = "goose_labcoat"
	icon_dead = "goose_labcoat_dead"

/datum/say_list/goose
	speak = list("Honk!")
	emote_hear = list("honks","flaps its wings","clacks")
	emote_see = list("flaps its wings", "scratches the ground")
