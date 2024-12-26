/datum/artifact_effect/disarmament
	name = "disarmament"
	effect_type = EFFECT_PSIONIC

/datum/artifact_effect/disarmament/proc/disarm(mob/living/L)
	if(istype(L))
		var/obj/item/Item = L.get_active_hand()
		if(istype(Item))
			to_chat(L, SPAN_WARNING("Something forces you to drop \the [Item]."))
			L.drop_item()

/datum/artifact_effect/disarmament/DoEffectTouch(mob/living/user)
	var/weakness = clamp(GetAnomalySusceptibility(user), 0, 1)
	if(prob(weakness * 100))
		disarm(user)

/datum/artifact_effect/disarmament/DoEffectPulse()
	var/turf/T = get_turf(holder)
	for(var/mob/living/L in oview(src.effectrange, T))
		var/weakness = clamp(GetAnomalySusceptibility(L), 0, 1)
		if(prob(weakness * 100))
			disarm(L)

/datum/artifact_effect/disarmament/DoEffectAura()
	var/turf/T = get_turf(holder)
	for(var/mob/living/L in oview(src.effectrange, T))
		var/weakness = clamp(GetAnomalySusceptibility(L), 0, 1)
		if(prob(10) && prob(weakness * 100))
			disarm(L)
