//todo
/datum/artifact_effect/sleepy
	name = "sleepy"

/datum/artifact_effect/sleepy/New()
	..()
	effect_type = pick(EFFECT_PSIONIC, EFFECT_ORGANIC)

/datum/artifact_effect/sleepy/DoEffectTouch(mob/living/toucher)
	if(istype(toucher))
		var/weakness = GetAnomalySusceptibility(toucher)
		if(toucher.isSynthetic())
			to_chat(toucher, SPAN_WARNING("SYSTEM ALERT: CPU cycles slowing down."))
			toucher.drowsyness = min(toucher.drowsyness + rand(5,25) * weakness, 50 * weakness)
			toucher.eye_blurry = min(toucher.eye_blurry + rand(1,3) * weakness, 50 * weakness)
			return 1
		else if(ishuman(toucher) && prob(weakness * 100))
			var/mob/living/carbon/human/H = toucher
			to_chat(H, pick(SPAN_NOTICE("You feel like taking a nap."),SPAN_NOTICE("You feel a yawn coming on."),SPAN_NOTICE("You feel a little tired.")))
			H.drowsyness = min(H.drowsyness + rand(5,25) * weakness, 50 * weakness)
			H.eye_blurry = min(H.eye_blurry + rand(1,3) * weakness, 50 * weakness)
			return 1

/datum/artifact_effect/sleepy/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/H in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(H)
			if(H.isSynthetic())
				to_chat(H, SPAN_WARNING("SYSTEM ALERT: CPU cycles slowing down."))
				continue
			else if(ishuman(H) && prob(weakness * 100))
				if(prob(10))
					to_chat(H, pick(SPAN_NOTICE("You feel like taking a nap."),SPAN_NOTICE("You feel a yawn coming on."),SPAN_NOTICE("You feel a little tired.")))
			H.drowsyness = min(H.drowsyness + 1 * weakness, 25 * weakness)
			H.eye_blurry = min(H.eye_blurry + 1 * weakness, 25 * weakness)
		return 1

/datum/artifact_effect/sleepy/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/H in range(src.effectrange, T))
			var/weakness = GetAnomalySusceptibility(H)
			if(H.isSynthetic())
				to_chat(H, SPAN_WARNING("SYSTEM ALERT: CPU cycles slowing down."))
				continue
			else if(prob(weakness * 100))
				to_chat(H, pick(SPAN_NOTICE("You feel like taking a nap."),SPAN_NOTICE("You feel a yawn coming on."),SPAN_NOTICE("You feel a little tired.")))
			H.drowsyness = min(H.drowsyness + rand(5,15) * weakness, 50 * weakness)
			H.eye_blurry = min(H.eye_blurry + rand(5,15) * weakness, 50 * weakness)
		return 1

/datum/artifact_effect/sleepy/destroyed_effect()
	. = ..()

	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/H in range(src.effectrange, T))
			var/weakness = GetAnomalySusceptibility(H)
			if(H.isSynthetic())
				to_chat(H, SPAN_WARNING("SYSTEM ALERT: CPU cycles shutting down."))
				continue
			else if(prob(weakness * 100))
				to_chat(H, (SPAN_NOTICE("Some sort of energy hits you, and you black out!")))
			H.drowsyness = min(H.drowsyness + rand(20, 30) * weakness, 50 * weakness)
			H.eye_blurry = min(H.eye_blurry + rand(20, 30) * weakness, 50 * weakness)
