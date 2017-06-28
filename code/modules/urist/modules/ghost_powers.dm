/* Various attack_ghost definitions for extra spoopy */

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
		var/dream = sanitize(input(user, "Enter someone's dreams", "Dream") as text|null)
		if(dream)
			to_chat(src, "\blue <i>... [dream] ...</i>")
			log_admin("[key_name(user)] has dream-whispered: [dream] to [key_name(src)].")