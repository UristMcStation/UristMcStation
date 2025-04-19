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
	speak_emote = list("purrs", "barks")
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	ai_holder = /datum/ai_holder/simple_animal/passive/fox
	say_list_type = /datum/say_list/fox

/datum/ai_holder/simple_animal/passive/fox
	speak_chance = 1

/datum/say_list/fox
	speak = list("Ack-Ack","Ack-Ack-Ack-Ackawoooo","Purr","Awoo","Tchoff")
	emote_hear = list("howls","barks")
	emote_see = list("shakes its head", "shivers")

//Renault, the captain's fox.

/mob/living/simple_animal/fox/Renault
	name = "Renault"
	desc = "Renault, the Captain's trustworthy fox. I wonder what it says?"
	var/turns_since_scan = 0
	var/mob/living/simple_animal/passive/mouse/movement_target

//Space bats from tg

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
	a_intent = "harm"
	maxHealth = 15
	health = 15
	see_in_dark = 10
	harm_intent_damage = 6
	natural_weapon = /obj/item/natural_weapon/bite
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
	desc = "A fierce companion for any person of power, this spider has been carefully trained by NanoTrasen specialists. Its beady, staring eyes send shivers down your spine."
	faction = "spiders"
	harm_intent_damage = 3
	health = 200
	icon = 'icons/mob/simple_animal/spider.dmi'
	icon_dead = "guard_dead"
	icon_gib = "guard_dead"
	icon_living = "guard"
	icon_state = "guard"
	l_move_time = 1
	maxHealth = 250
	natural_weapon = /obj/item/natural_weapon/bite/spider/strong
	name = "Araneus"
	real_name = "Araneus"
	response_help = "pets"
	turns_per_move = 10
	voice_name = "unidentifiable voice"
	speak_emote = list("chitters")
	bone_material = null
	bone_amount = 0

//TGC: Turtle, art+code by me, nothing revolutionary here.

/mob/living/simple_animal/turtle
	name = "turtle"
	desc = "Look out for bites!"
	icon = 'icons/urist/uristicons.dmi'
	icon_state = "turtle"
	icon_living = "turtle"
	icon_dead = "turtle_dead"
	//Turtles don't speak or make noise...
	turns_per_move = 10
	health = 150 //Turtles are tanky
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "hits"
	say_list_type = /datum/say_list/turtle

/datum/say_list/turtle
	emote_see = list("blinks", "snaps the air")
/mob/living/simple_animal/turtle/mule
	name = "Mule"
	desc = "The QuarterMaster's turtle. Look out for bites!"

/*holds a random chem for animal venom
  should be used WITH copy=1 on transfer */
/obj/item/venom_sac
	name = "venom sac"
	desc = "A sac something evolved to store venom in."
	icon = 'icons/obj/organs.dmi'
	icon_state = "roro core"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	var/chem_type_amt = 3 //should def it probably; max chem types

	//blacklist for subtypes!
	var/list/banned_chems = list(
		/datum/reagent/adminordrazine,
		/datum/reagent/toxin/phoron/oxygen,
		/datum/reagent/water,
		/datum/reagent/nutriment,
		/datum/reagent/drink,
		/datum/reagent/peridaxon,
		/datum/reagent/crayon_dust
		)

	//exceptions to the above in case you have a subtype you do want
	var/list/ban_excepted = list()

//pretty basic random chem picker; blacklist overriden and picks from 1 to argument chem types
/obj/item/venom_sac/proc/generate_venom(maxchems = 3)
	var/list/mix = list()
	var/new_chem = null
	var/max_chemtypes = rand(1, maxchems)
	var/list/blacklist = list() //actual utility list

	for(var/Reagent in subtypesof(/datum/reagent))
		for(var/Banned in banned_chems) //O(n^2), bleh, couldn't think of anything else
			if(istype(Reagent, Banned))
				if(!(Reagent in ban_excepted))
					blacklist += Reagent

	while (length(mix) < max_chemtypes)
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


/mob/living/simple_animal/hostile/retaliate/goose/doctor/urist
	name = "\improper Dr. Anser"
	desc = "A large waterfowl, known for its beauty and quick temper when provoked. This one has a nametag, 'Dr. Anser'. What an odd pet.."
	icon_state = "goose_labcoat"
	icon_living = "goose_labcoat"
	icon_dead = "goose_labcoat_dead"


/mob/living/simple_animal/hostile/mutated_rat
	name = "large rat"
	desc = "an unsightly large grey rat, it has quite sharp teeth."
	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "big_rat_white"
	icon_living = "big_rat_white"
	icon_dead = "big_rat_white_dead"
	speak_emote = list("squeaks")
	response_help =  "nuzzles"
	response_disarm = "swipes"
	response_harm = "bites"
	health = 25
	maxHealth = 30
	natural_weapon = /obj/item/natural_weapon/bite
	pass_flags = PASS_FLAG_TABLE
	faction = "factory"
	attacktext = "bites"
	say_list_type = /datum/say_list/mutated_rat
	ai_holder = /datum/ai_holder/simple_animal/mutated_rat

/datum/ai_holder/simple_animal/mutated_rat
	speak_chance = 5
	aggro_sound = 'sound/urist/rat_aggro.ogg'


/datum/say_list/mutated_rat
	speak = list("squeaks")
	emote_see = list("skitters")

/mob/living/simple_animal/hostile/mutated_rat/corpserat
	name = "large corpse rat"
	desc = "a large, rotund rat that is clearly well fed, its teeth look unusually dangerous."
	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "big_rat_brown"
	icon_living = "big_rat_brown"
	icon_dead = "big_rat_brown_dead"
	speak_emote = list("scrowls")
	response_help =  "hungrily nuzzles"
	response_disarm = "swipes"
	response_harm = "bites"
	health = 35
	maxHealth = 45
	natural_weapon = /obj/item/natural_weapon/bite/strong

/* By the laws of universal balance, the concept of catgirls must imply their categorical dual - a cat with human ears.
** Hostile to crew, since they are a mirror image of a normally protagonist-friendly stereotype.
** Well, that, and to Strongly Discourage people from getting Ideas.
*/
/mob/living/simple_animal/hostile/girlcat
	name = "girlcat"
	desc = "A strange creature resembling a housecat with disturbingly humanoid earlobes and a cold, malicious gleam in its eyes."

	// Icons
	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "girlcat"
	icon_living = "girlcat"
	icon_dead = "girlcat_dead"

	// Health
	maxHealth = 50
	health = 50
	bleed_colour = "#06065c"
	min_gas = null
	max_gas = null
	minbodytemp = 0

	// Combat
	natural_weapon = /obj/item/natural_weapon/claws/weak
	melee_attack_delay = 10 // pounce - big windup
	speed = 0.5
	movement_cooldown = 1  // *Sanic speed*
	move_to_delay = 3
	break_stuff_probability = 25
	pry_desc = "clawing"
	grab_resist = 80 // slippery

	// AI
	mob_class = MOB_CLASS_DEMONIC
	faction = "girlcat"  // absolutely hostile to all life
	ai_holder = /datum/ai_holder/simple_animal/melee/evasive
	say_list_type = /datum/say_list/girlcat

/datum/say_list/girlcat
	/* By the same logic, girlcat speech is a mirror of catgirl tropes...
	** Should be read as basically reversed audio. Added bonus: is clearly uncanny bullshit.
	*/
	speak = list("~!aaaaayN", "?weoM", "~wUw!~", "?prrrrM?", "rrrrruP...")
	emote_hear = list("weoms", "wems")
	emote_see = list("shakes their head", "shivers")
