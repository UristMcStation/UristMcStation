/mob/living/carbon/alien/diona
	name = "diona nymph"
	voice_name = "diona nymph"
	adult_form = /mob/living/carbon/human
	speak_emote = list("chirrups")
	icon_state = "nymph"
	language = "Rootspeak"
	death_msg = "expires with a pitiful chirrup..."
	amount_grown = 0
	max_grown = 5 // Target number of donors.

	var/list/donors = list()
	var/last_checked_stage = 0

	universal_understand = 1 // Dionaea do not need to speak to people
	universal_speak = 1      // before becoming an adult. Use *chirp.
	holder_type = /obj/item/weapon/holder/diona

/mob/living/carbon/alien/diona/New()

	..()
	species = all_species["Diona"]
	verbs += /mob/living/carbon/alien/diona/proc/steal_blood
	verbs += /mob/living/carbon/alien/diona/proc/merge

/mob/living/carbon/alien/diona/show_evolution_blurb()
	//TODO
	return

/mob/living/carbon/alien/diona/update_progression()

	amount_grown = donors.len

	if(amount_grown <= last_checked_stage)
		return

	// Only fire off these messages once.
	last_checked_stage = amount_grown
	if(amount_grown == max_grown)
		src << "\green You feel ready to move on to your next stage of growth."
	else if(amount_grown == 3)
		universal_understand = 1
		src << "\green You feel your awareness expand, and realize you know how to understand the creatures around you."
	else
		src << "\green The blood seeps into your small form, and you draw out the echoes of memories and personality from it, working them into your budding mind."

/mob/living/carbon/alien/diona/proc/steal_blood()
	set category = "Abilities"
	set name = "Steal Blood"
	set desc = "Take a blood sample from a suitable donor."

	var/list/choices = list()
	for(var/mob/living/carbon/human/H in oview(1,src))
		if(src.Adjacent(H))
			choices += H

	var/mob/living/carbon/human/M = input(src,"Who do you wish to take a sample from?") in null|choices

	if(!M || !src) return

	if(M.species.flags & NO_BLOOD)
		src << "\red That donor has no blood to take."
		return

	if(donors.Find(M.real_name))
		src << "\red That donor offers you nothing new."
		return

	src.visible_message("\red [src] flicks out a feeler and neatly steals a sample of [M]'s blood.","\red You flick out a feeler and neatly steal a sample of [M]'s blood.")
	donors += M.real_name
	for(var/datum/language/L in M.languages)
		languages |= L

	spawn(25)
		update_progression()

