// Simply mimics cultify runes. More for arrpee flavor than anything.

/datum/artifact_effect/cultify
	name = "cultify"
	effect = EFFECT_PULSE
	effect_type = EFFECT_BLUESPACE
	effectrange = 2

	var/cultify_chance = 30

	var/last_cultify_time = 0
	var/cultify_interval = 20 SECONDS


/datum/artifact_effect/cultify/New()
	..()

	if(!istype(trigger, /datum/artifact_trigger/touch))
		effect = pick(EFFECT_PULSE, EFFECT_AURA)

	effectrange = rand(1, 2)
	cultify_interval = rand(10 SECONDS, 30 SECONDS)


/datum/artifact_effect/cultify/DoEffectGeneric(atom/holder)
	var/true_holder = src.holder || holder

	if(!true_holder)
		return

	if((world.time - src.last_cultify_time) < src.cultify_interval)
		return

	var/turf/HT = get_turf(true_holder)

	if(!istype(HT))
		return

	for(var/turf/T in range(effectrange, HT))
		if(!prob(src.cultify_chance))
			continue

		if(T.holy)
			T.holy = 0

		else
			T.cultify()

	src.last_cultify_time = world.time
	return


/datum/artifact_effect/cultify/DoEffectTouch(mob/toucher)
	src.DoEffectGeneric(toucher)


/datum/artifact_effect/cultify/DoEffectAura(atom/holder)
	src.DoEffectGeneric(holder)


/datum/artifact_effect/cultify/DoEffectPulse(atom/holder)
	src.DoEffectGeneric(holder)
