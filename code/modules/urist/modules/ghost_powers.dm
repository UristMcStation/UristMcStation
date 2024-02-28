/* Various attack_ghost definitions for extra spoopy */

// Works like the Cult spookiness, but independent of Cultmode logic
// Can be used to enable spookiness without faking having cultists.
// Not boolean, each source of spoop should bump this by +1 until it's done (i.e. more like a counter)
GLOBAL_VAR_INIT(globally_spooky, 0)


/proc/add_global_spookiness()
	GLOB.globally_spooky++
	return TRUE


/proc/remove_global_spookiness()
	GLOB.globally_spooky--
	return TRUE


/obj/item/device/taperecorder/attack_ghost(mob/observer/ghost/user as mob)
	. = ..()
	if(round_is_spooky())
		if(mytape && recording)
			var/msg = sanitize(input(user, "Whisper what into the radio?", "Radio whisper") as text|null)
			if(msg)
				mytape.record_speech("Something whispers, \"[msg]\"")
				log_admin("[key_name(user)] has radio-whispered: [msg].")

/obj/structure/window/attack_ghost(mob/observer/ghost/user as mob)
	. = ..()
	if(round_is_spooky())
		playsound(src.loc, 'sound/effects/glassknock.ogg', 80, 1)
		user.visible_message("Something knocks on the [src.name].",
								"You knock on the [src.name].",
								"You hear a knocking sound.")

/mob/living/carbon/attack_ghost(mob/observer/ghost/user as mob)
	. = ..()
	if(src.sleeping && src.client && round_is_spooky())
		user.ghost_dream_invasion(src, TRUE)


/mob/observer/ghost/proc/ghost_dream_invasion(var/mob/living/carbon/human/target = null, var/target_optional = TRUE)
	// Write messages into people's dreams. Spooooookyyyyy.
	// To make it more Fun, you have to use normal dream strings, BUT:
	// a) There's a small chance you get to write anything you want instead
	// b)

	set category = "Cult"
	set name = "Invade dreams"
	set desc = "Insert a message into someone's dream. Remember, no IC in OOC or OOC in IC."

	if(!round_is_spooky())
		to_chat(src, SPAN_NOTICE("The veil is not thin enough to let you use this power."))
		return

	if(!ghost_ability_check())
		return

	if(!istype(target) && target_optional)
		// if target_optional is FALSE, we MUST use the target
		// otherwise, allow picks from adjacent sleepers
		var/list/mob/living/carbon/human/choices = list()

		for(var/mob/living/carbon/human/H in range(1))
			if(H.sleeping && H.client)
				choices += H

		if(!choices)
			return

		target = input(src, "Who do you want to speak to?") as null|anything in choices

	if(!istype(target))
		return

	if(!ghost_ability_check())
		// input can take a while so we should recheck
		return

	var/spoke = FALSE

	if(prob(10))
		var/dream = sanitize(input(src, "Enter dream message directly", "Dream") as text|null)
		if(dream)
			to_chat(target, SPAN_NOTICE("... [dream] ..."))
			log_admin("[key_name(src)] has dream-whispered: [dream] to [key_name(target)].")
			spoke = TRUE

	else
		var/is_subtle = prob(80)

		var/token_choice_one = input(src, "Select two dream tokens", "Dream 1") as null|anything in GLOB.dream_tokens
		var/token_choice_two = input(src, "Select two dream tokens", "Dream 2") as null|anything in GLOB.dream_tokens

		if(!(token_choice_one && token_choice_two))
			return

		if(is_subtle)
			// mimic normal dreams...
			to_chat(target, SPAN_NOTICE("... [token_choice_one] [token_choice_two] ..."))
		else
			// ...with a chance of different styling to draw attention to the dream
			to_chat(target, SPAN_OCCULT("... [token_choice_one] [token_choice_two] ..."))

		// In both cases, we concatenate tokens to make it slightly more obvious this is not just RNG
		spoke = TRUE
		log_admin("[key_name(src)] has dream-whispered: [token_choice_one] / [token_choice_two] to [key_name(target)].")

	if(spoke)
		ghost_magic_cd = world.time + 10 SECONDS

	return