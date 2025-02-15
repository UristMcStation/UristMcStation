/datum/artifact_effect/heal
	name = "heal"
	effect_type = EFFECT_ORGANIC
	effect_state = "sparkles_1"

/datum/artifact_effect/heal/DoEffectTouch(mob/toucher)
	//todo: check over this properly
	if(toucher && iscarbon(toucher))
		var/weakness = GetAnomalySusceptibility(toucher)
		if(prob(weakness * 100))
			var/mob/living/carbon/C = toucher
			to_chat(C, SPAN_NOTICE("You feel a soothing energy invigorate you."))

			if(ishuman(toucher))
				var/mob/living/carbon/human/H = toucher
				for(var/obj/item/organ/external/affecting in H.organs)
					if(affecting && istype(affecting))
						affecting.heal_damage(25 * weakness, 25 * weakness)
				//H:heal_organ_damage(25, 25)
				H.vessel.add_reagent(/datum/reagent/blood,5)
				H.adjust_nutrition(50 * weakness)
				H.adjustBrainLoss(-25 * weakness)
				H.radiation -= min(H.radiation, 25 * weakness)
				H.bodytemperature = initial(H.bodytemperature)
				H.fixblood()
			//
			C.adjustOxyLoss(-25 * weakness)
			C.adjustToxLoss(-25 * weakness)
			C.adjustBruteLoss(-25 * weakness)
			C.adjustFireLoss(-25 * weakness)
			//
			C.regenerate_icons()
			return 1

/datum/artifact_effect/heal/DoEffectAura()
	//todo: check over this properly
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(C)
			if(prob(weakness * 100))
				if(prob(10))
					to_chat(C, SPAN_NOTICE("You feel a soothing energy radiating from something nearby."))
				C.adjustBruteLoss(-5 * weakness)
				C.adjustFireLoss(-5 * weakness)
				C.adjustToxLoss(-5 * weakness)
				C.adjustOxyLoss(-5 * weakness)
				C.adjustBrainLoss(-5 * weakness)
				C.updatehealth()

/datum/artifact_effect/heal/DoEffectPulse()
	//todo: check over this properly
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(C)
			if(prob(weakness * 100))
				to_chat(C, SPAN_NOTICE("A wave of energy invigorates you."))
				C.adjustBruteLoss(-15 * weakness)
				C.adjustFireLoss(-15 * weakness)
				C.adjustToxLoss(-15 * weakness)
				C.adjustOxyLoss(-15 * weakness)
				C.adjustBrainLoss(-15 * weakness)
				C.updatehealth()

/datum/artifact_effect/heal/destroyed_effect()
	. = ..()

	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(effectrange * 2,T))
			var/weakness = GetAnomalySusceptibility(C)
			if(prob(weakness * 100))
				to_chat(C, SPAN_NOTICE("A massive wave of energy invigorates and heals you!"))
				C.adjustBruteLoss(-100 * weakness)
				C.adjustFireLoss(-100 * weakness)
				C.adjustToxLoss(-100 * weakness)
				C.adjustOxyLoss(-100 * weakness)
				C.adjustBrainLoss(-100 * weakness)
				C.updatehealth()
