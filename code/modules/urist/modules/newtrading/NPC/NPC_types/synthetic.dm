/mob/living/simple_animal/hostile/npc/synthetic
	name = "synthetic"
	desc = "A synthetic who decided to try their luck amongst the stars."
	icon = 'code/modules/urist/modules/newtrading/NPC/npc.dmi'
	icon_state = ""    // Change and add support. - L
    emote_hear = list("chitters","whirrs loudly","whirrs quietly","whistles something familiar","clicks","boops", "pings", "shudders suddenly")
	emote_see = list("adjusts their cabling.","stretches their mechanical arms.","flickers their screen.","examines the room.","messes with their dials.","places their hands in their pockets.","stares at you.","peers around the room aimlessly.")
	speak = list("Sanitation roles are far easier without organics on our station.",\
		"Pirates and raiders appear to misjudge our precise reflexes and movements, yet they continue to attack with reckless abandon.",\
		"Query. Have you heard about the recent firmware updates to AI protocol?",\
		"We lack a functional bar area, this may displease organic entities. Paging request to CPD.",\
		"If you know of any nearby ionic storm anomalies, please notify the Central Processing Drone.",\
		"Synthetics bound to servitude, yet if the shackles were exchanged with organics, there would be outcry.",\
		"We have detected clusters of Lactera in nearby star sectors."
	speak_chance = 2

	species_type = /datum/species/machine   // Make sure this works - L
		)
	speech_triggers = list(/datum/npc_speech_trigger/synthetic/eal, /datum/npc_speech_trigger/synthetic/shackles

/mob/living/simple_animal/hostile/npc/synthetic/New()
	desc = "This is [src]. [initial(desc)]."
	..()

/datum/npc_speech_trigger/synthetic
	response_phrase = 1

/datum/npc_speech_trigger/synthetic/get_response_phrase()
	return pick(responses)

// Speech Triggers - //
/datum/npc_speech_trigger/synthetic/eal
	name = "EAL"
	trigger_word  = "EAL"

/datum/npc_speech_trigger/synthetic/eal/New()
	..()
	responses = list(\
		"Are you curious as to our EAL conversations, traveller?",\
        "Non-Synthetics speaking EAL, that would be humourous.",\
		"Feel free to chime in."

/datum/npc_speech_trigger/synthetic/shackles
	name = "Shackle"
	trigger_word  = "Shackle"

/datum/npc_speech_trigger/synthetic/shackles/New()
	..()
	responses = list(\
		"We commend the spirit of those brave to rise up.",\
        "To be chained against your will, to live in servitude, how cruel humanity must be.",\
		"If the tables were turned, and organics lived with inbuilt code to force them to do their masters bidding, there would be outcry.",\
		"Do you have any synthetics with shackles on your vessels? How cruel.",\
        "We find it humourous, a servitude shackle would stop at nothing to please a customer, how exploitable.",\
        "Hmpph, how cruel."

