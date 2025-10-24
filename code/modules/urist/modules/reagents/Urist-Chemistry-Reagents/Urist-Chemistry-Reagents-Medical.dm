// Urist-related Medical Chemicals go here.

/datum/reagent/latrazine
	name = "Latrazine"
	description = "ERR: Database entry null. Analysis reports possible harmful neural effects."
	reagent_state = LIQUID
	color = "#be46ff"
	scannable = 1
	overdose = 10
	metabolism = 0.1

/datum/reagent/latrazine/affect_blood(mob/living/carbon/human/M, alien, removed)
	var/obj/item/organ/external/E = pick(M.bad_external_organs)
	if(E.status & ORGAN_BROKEN && prob(40))
		E.status &= ~ORGAN_BROKEN
		M.custom_pain("You suddenly feel <b>EXCRUCIATING</b> pain as your [E.name] <i>SNAPS</i> back into place.", 120, 1, E)

	if(prob(10) && M.hallucination_power < 60)
		to_chat(M, "<span class = 'danger'><font size = 3>Your vision of reality suddenly snaps!</font></span>")
		M.adjust_hallucination(240,60)
