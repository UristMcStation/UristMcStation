//All of the scissor stuff <-- TGameCo
/obj/item/scissors //DON'T USE THIS FOR THE GAME! THIS IS FOR ORGINIZATIONAL THINGS ONLY!!
	name = "Scissors"
	desc = "Those are scissors. Don't run with them!"
	icon = 'icons/urist/uristicons.dmi'
	icon_state = "scissors"
	item_state = "scissors"
	force = 5
	matter = list("steel" = 35)
	sharp = 1
	edge = 1
	w_class = 2
	item_icons = DEF_URIST_INHANDS
	attack_verb = list("slices", "cuts", "stabs", "jabs")
	var/childpart = /obj/item/improvised/scissorknife //This is so any thing made is specified. It's helpful for things

/obj/item/Scissors/IsWirecutter()
	return TRUE

/obj/item/scissors/use_tool(obj/item/I, mob/living/user, list/click_params) //Seperation of the scissors
	if(istype(I, /obj/item/screwdriver))

		var/obj/item/improvised/scissorknife/left_part = new childpart
		var/obj/item/improvised/scissorknife/right_part = new childpart

		// Craft scissors have unique left/right colors. To maintain this with the knives, I set the right part to have the icon of the right part
		if(istype(src, /obj/item/scissors/craft))
			right_part.icon_state = "scissors_knife_craft_right"
			right_part.item_state = "scissors_knife_craft_right"
		else
			right_part.icon_state = right_part.icon_state + "_right"

		user.remove_from_mob(src)
		user.drop_from_inventory(src)

		user.put_in_hands(left_part)
		user.put_in_hands(right_part)
		to_chat(user, "<span class='notice'>You seperate the parts of the [src]</span>")

		qdel(src)
	..()

/obj/item/improvised/scissorsassembly //So you can put it together!
	name = "Scissor Assembly"
	desc = "Two parts of a scissor loosely combined"
	icon = 'icons/urist/uristicons.dmi'
	icon_state = "scissors"
	item_state = "scissors"
	matter = list("steel" = 35)
	force = 3
	edge = 1
	w_class = 2
	item_icons = DEF_URIST_INHANDS
	attack_verb = list("slices", "cuts", "stabs", "jabs")
	var/parentscissor = /obj/item/scissors

/obj/item/improvised/scissorsassembly/barber
	icon_state = "scissors_barber"
	item_state = "scissors_barber"
	attack_verb = list("beautifully slices", "artistically cuts", "smoothly stabs", "quickly jabs")
	parentscissor = /obj/item/scissors/barber

/obj/item/improvised/scissorsassembly/craft
	icon_state = "scissors_craft"
	item_state = "scissors_craft"
	matter = null
	force = 0
	edge = 0
	attack_verb = list("prods", "pokes", "nudges", "annoys")
	parentscissor = /obj/item/scissors/craft

/obj/item/improvised/scissorsassembly/use_tool(obj/item/I, mob/living/user, list/click_params) //Putting it together
	if(istype(I, /obj/item/screwdriver))

		var/obj/item/scissors/N = new parentscissor

		user.remove_from_mob(src)

		user.put_in_hands(N)
		to_chat(user, "<span class='notice'>You tighten the screw on the screwdriver assembley</span>")

		qdel(src)
	..()

//Makes scissors cut hair, special thanks to Miauw and Xerux -Nien
/obj/item/scissors/barber/use_before(mob/living/carbon/M, mob/user, click_parameters)
	if(user.a_intent != "help")
		return FALSE

	if(!(M in view(1))) //Adjacency test
		return FALSE

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		//see code/modules/mob/new_player/preferences.dm at approx line 545 for comments!
		//this is largely copypasted from there.
		//handle facial hair (if necessary)
		var/list/species_facial_hair = list()

		if(H.gender == MALE)
			if(H.species)
				for(var/i in GLOB.facial_hair_styles_list)
					var/datum/sprite_accessory/facial_hair/tmp_facial = GLOB.facial_hair_styles_list[i]
					if(H.species.name in tmp_facial.species_allowed)
						species_facial_hair += i
			else
				species_facial_hair = GLOB.facial_hair_styles_list

		var/f_new_style = input(user, "Select a facial hair style", "Grooming")  as null|anything in species_facial_hair

		//handle normal hair
		var/list/species_hair = list()
		if(H.species)
			for(var/i in GLOB.hair_styles_list)
				var/datum/sprite_accessory/hair/tmp_hair = GLOB.hair_styles_list[i]
				if(H.species.name in tmp_hair.species_allowed)
					species_hair += i
		else
			species_hair = GLOB.hair_styles_list

		var/h_new_style = input(user, "Select a hair style", "Grooming")  as null|anything in species_hair

		user.visible_message("[user] starts cutting [M]'s hair!", "You start cutting [M]'s hair!", "You hear the sound of scissors.") //arguments for this are: 1. what others see 2. what the user sees 3. what blind people hear. --Fixed grammar, (TGameCo)

		if(do_after(user, 50)) //this is the part that adds a delay. delay is in deciseconds. --Made it 5 seconds, because hair isn't cut in one second in real life, and I want at least a little bit longer time, (TGameCo)
			if(!(M in view(1))) //Adjacency test
				user.visible_message("[user] stops cutting [M]'s hair.", "You stop cutting [M]'s hair.", "The sounds of scissors stop")
				return TRUE

			if(f_new_style)
				H.facial_hair_style = f_new_style

			if(h_new_style)
				H.head_hair_style = h_new_style

		H.update_hair()
		user.visible_message("[user] finishes cutting [M]'s hair!")
		return TRUE

// --- Scissor Children ---

// Barber scissors, used especially for cutting of hair
/obj/item/scissors/barber
	name = "Barber's Scissors"
	desc = "A pair of scissors used by the barber."
	icon_state = "scissors_barber"
	item_state = "scissors_barber"
	attack_verb = list("beautifully slices", "artistically cuts", "smoothly stabs", "quickly jabs")
	childpart = /obj/item/improvised/scissorknife/barber

// This used to be standard office scissors, but I moved those down to the root scissors
// Plastic Craft scissors, like those used by schoolchildren.
/obj/item/scissors/craft
	name = "Craft Scissors"
	desc = "A pair of scissors used for arts and crafts. It's probably safe to run with"
	icon_state = "scissors_craft"
	item_state = "scissors_craft"
	attack_verb = list("prods", "pokes", "nudges", "annoys")
	force = 0 // Use the scissors of a child, recieve the strength of a child
	matter = null // Remove the metal matter inherited from scissors
	sharp = 0 // It's a child's scissors, it's more likely to tear the paper than cut it
	edge = 0
	childpart = /obj/item/improvised/scissorknife/craft
