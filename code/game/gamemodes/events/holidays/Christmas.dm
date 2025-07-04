/obj/item/toy/xmas_cracker
	name = "xmas cracker"
	icon = 'icons/obj/gifts.dmi'
	icon_state = "cracker"
	desc = "Directions for use: Requires two people, one to pull each end."
	var/cracked = 0

/obj/item/toy/xmas_cracker/New()
	..()

/obj/item/toy/xmas_cracker/use_before(mob/target, mob/user)
	. = FALSE
	if (!cracked && istype(target,/mob/living/carbon/human) && (target.stat == CONSCIOUS) && !target.get_active_hand() )
		target.visible_message(SPAN_NOTICE("[user] and [target] pop \an [src]! *pop*"), SPAN_NOTICE("You pull \an [src] with [target]! *pop*"), SPAN_NOTICE("You hear a *pop*."))
		var/obj/item/paper/Joke = new /obj/item/paper(user.loc)
		Joke.SetName("[pick("awful","terrible","unfunny")] joke")
		Joke.info = pick("What did one snowman say to the other?\n\n<i>'Is it me or can you smell carrots?'</i>",
			"Why couldn't the snowman get laid?\n\n<i>He was frigid!</i>",
			"Where are santa's helpers educated?\n\n<i>Nowhere, they're ELF-taught.</i>",
			"What happened to the man who stole advent calanders?\n\n<i>He got 25 days.</i>",
			"What does Santa get when he gets stuck in a chimney?\n\n<i>Claus-trophobia.</i>",
			"Where do you find chili beans?\n\n<i>The north pole.</i>",
			"What do you get from eating tree decorations?\n\n<i>Tinsilitis!</i>",
			"What do snowmen wear on their heads?\n\n<i>Ice caps!</i>",
			"Why is Christmas just like life on ss13?\n\n<i>You do all the work and the fat guy gets all the credit.</i>",
			"Why doesn't Santa have any children?\n\n<i>Because he only comes down the chimney.</i>")
		new /obj/item/clothing/head/festive(target.loc)
		user.update_icons()
		cracked = 1
		icon_state = "cracker1"
		var/obj/item/toy/xmas_cracker/other_half = new /obj/item/toy/xmas_cracker(target)
		other_half.cracked = 1
		other_half.icon_state = "cracker2"
		target.put_in_active_hand(other_half)
		playsound(user, 'sound/effects/snap.ogg', 50, 1)
		return TRUE

/obj/item/clothing/head/festive
	name = "festive paper hat"
	icon_state = "xmashat"
	desc = "A crappy paper crown that you are REQUIRED to wear."
	flags_inv = 0
	body_parts_covered = 0
	var/list/permitted_colors = list(COLOR_RED, COLOR_ORANGE, COLOR_YELLOW, COLOR_GREEN, COLOR_BLUE, COLOR_INDIGO, COLOR_VIOLET)

/obj/item/clothing/head/festive/Initialize()
	. = ..()
	color = pick(permitted_colors)

