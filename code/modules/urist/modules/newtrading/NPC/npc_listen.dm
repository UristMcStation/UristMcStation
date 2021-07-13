/mob/living/simple_animal/hostile/npc/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(speech_triggers.len)
		if(speaker in view(7, src))
			for(var/datum/npc_speech_trigger/T in speech_triggers)
				if(T.trigger_phrase)
					if(message == T.trigger_phrase)
						do_react(T)
				else if(T.trigger_word)
					for(var/triggerword in T.trigger_word)
						if(findtext(message,triggerword))
							do_react(T)

/mob/living/simple_animal/hostile/npc/proc/do_react(var/datum/npc_speech_trigger/T)
	if(prob(T.response_chance))
		if(!angryspeak)
			if(T.response_phrase)
				say_next = T.get_response_phrase()
				say_time = world.time + 2 SECONDS

		else
			if(T.angryresponse_phrase)
				say_next = T.get_angryresponse_phrase()
				say_time = world.time + 2 SECONDS

			else if(T.response_phrase)
				say_next = T.get_response_phrase()
				say_time = world.time + 2 SECONDS


