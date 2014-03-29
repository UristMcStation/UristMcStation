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

