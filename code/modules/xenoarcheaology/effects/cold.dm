//inverse of /datum/artifact_effect/heat, the two effects split up for neatness' sake
/datum/artifact_effect/cold
	name = "cold"
	effect_icon = "pulsing"
	var/target_temp

/datum/artifact_effect/cold/New()
	..()
	target_temp = rand(0, 250)
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = pick(EFFECT_ORGANIC, EFFECT_BLUESPACE, EFFECT_SYNTH)

/datum/artifact_effect/cold/DoEffectTouch(mob/user)
	if(holder)
		if (istype(user))
			to_chat(user, SPAN_NOTICE("A chill passes up your spine!"))
		var/datum/gas_mixture/env = holder.loc.return_air()
		if(env)
			env.temperature = max(env.temperature - rand(5,50), 0)

/datum/artifact_effect/cold/DoEffectAura()
	if(holder)
		var/datum/gas_mixture/env = holder.loc.return_air()
		if(env && env.temperature > target_temp)
			env.temperature -= pick(0, 0, 1)

/datum/artifact_effect/cold/destroyed_effect()
	. = ..()

	for (var/turf/T in trange(5, get_turf(holder)))
		var/datum/gas_mixture/env = T.return_air()
		if (env)
			env.temperature -= 10
