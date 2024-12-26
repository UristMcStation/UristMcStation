/datum/artifact_effect/hurt
	name = "hurt"
	effect_type = EFFECT_ORGANIC
	effect_state = "sparkles_3"

/datum/artifact_effect/hurt/DoEffectTouch(mob/living/toucher)
	if(iscarbon(toucher) && !toucher.isSynthetic())
		var/weakness = GetAnomalySusceptibility(toucher)
		if(prob(weakness * 100))
			var/mob/living/carbon/C = toucher
			to_chat(C, SPAN_DANGER("A painful discharge of energy strikes you!"))
			do_damage(C, rand(15,50), rand(15,50), rand(15,50), rand(15,25), rand(1, 5))
			C.apply_damage(25 * weakness, DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)
			C.set_nutrition(min(50 * weakness, C.nutrition))
			C.make_dizzy(6 * weakness)
			C.weakened += 6 * weakness

/datum/artifact_effect/hurt/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(C)
			if(prob(weakness * 100))
				if(prob(10) && !C.isSynthetic())
					to_chat(C, SPAN_DANGER("You feel a painful force radiating from something nearby."))
				do_damage(C)

/datum/artifact_effect/hurt/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(src.effectrange, T))
			var/weakness = GetAnomalySusceptibility(C)
			if(prob(weakness * 100) && !C.isSynthetic())
				to_chat(C, SPAN_DANGER("A wave of painful energy strikes you!"))
				do_damage(C, 3, 3, 3, 3)

/datum/artifact_effect/hurt/proc/do_damage(mob/living/C, brute = 1, fire = 1, tox = 1, oxy = 1, brain = 0.1)
	var/weakness = GetAnomalySusceptibility(C)
	C.adjustBruteLoss(brute * weakness)
	C.adjustFireLoss(fire * weakness)
	C.adjustToxLoss(tox * weakness)
	C.adjustOxyLoss(oxy * weakness)
	C.adjustBrainLoss(brain * weakness)
	C.updatehealth()

/datum/artifact_effect/hurt/destroyed_effect()
	. = ..()

	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(effectrange, T))
			var/weakness = GetAnomalySusceptibility(C)
			if(prob(weakness * 100) && !C.isSynthetic())
				to_chat(C, SPAN_DANGER("A wave of extremely painful energy strikes you!"))
				do_damage(C, 50, 50, 50, 50)
