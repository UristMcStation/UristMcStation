
/mob/proc/make_bsrevenant()

	if(!mind)
		return

	if(!mind.bluespace_revenant)
		mind.bluespace_revenant = new /datum/bluespace_revenant()

	for(var/datum/power/revenant/P in mind.bluespace_revenant.unlocked_powers)
		if(P.isVerb)
			if(!(P in src.verbs))
				src.verbs += P.verbpath

	/*
	verbs += /datum/changeling/proc/EvolutionMenu

	if(!powerinstances.len)
		for(var/P in powers)
			powerinstances += new P()

	var/mob/living/carbon/human/H = src
	if(istype(H))
		var/datum/absorbed_dna/newDNA = new(H.real_name, H.dna, H.species.name, H.languages)
		absorbDNA(newDNA)

	*/

	return 1


//removes our Revenant verbs
/mob/proc/remove_bsrevenant_powers()
	if(!(isbsrevenant(src)))
		return

	for(var/datum/power/revenant/P in mind.bluespace_revenant.unlocked_powers)
		if(P.isVerb)
			verbs -= P.verbpath
