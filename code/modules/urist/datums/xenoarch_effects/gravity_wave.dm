/datum/artifact_effect/gravity_wave
	name = "gravity wave"
	effect_type = EFFECT_ENERGY
	var/last_wave_pull = 0
	var/pull_power
	effect_state = "gravisphere"

/datum/artifact_effect/gravity_wave/New()
	..()
	effect_type = pick(EFFECT_ENERGY, EFFECT_BLUESPACE, EFFECT_PSIONIC)
	switch (pick(100;1, 50;2, 25;3))
		if (1) //short range
			effectrange = rand(2, 4)
		if (2) //medium range
			effectrange = rand(5, 9)
		if (3) //large range
			effectrange = rand(9, 14)
	pull_power = rand(STAGE_ONE, STAGE_FOUR)


/datum/artifact_effect/gravity_wave/DoEffectTouch(mob/living/user)
	if(!istype(user))
		return

	gravwave(user, effectrange, pull_power)

/datum/artifact_effect/gravity_wave/DoEffectAura()
	var/seconds_since_last_pull = max(0, round((last_wave_pull - world.time) / 10))
	if (prob(10 + seconds_since_last_pull))
		holder.visible_message(SPAN_CLASS("alien", "\The [holder] distorts as local gravity intensifies, and shifts toward it."))
		last_wave_pull = world.time
		gravwave(get_turf(holder), effectrange, pull_power)


/datum/artifact_effect/gravity_wave/DoEffectPulse()
	holder.visible_message(SPAN_CLASS("alien", "\The [holder] distorts as local gravity intensifies, and shifts toward it."))
	gravwave(get_turf(holder), effectrange, pull_power)


/datum/artifact_effect/gravity_wave/proc/gravwave(atom/target, pull_range = 7, pull_power = STAGE_TWO)
	for (var/atom/A in oview(pull_range, target))
		A.singularity_pull(target, pull_power)
