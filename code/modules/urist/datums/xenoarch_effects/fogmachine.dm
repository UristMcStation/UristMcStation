
/datum/artifact_effect/fogmachine
	name = "fog machine"
	effect = EFFECT_PULSE
	effect_type = EFFECT_ENERGY

	var/fog_spawn_chance = 50


/datum/artifact_effect/fogmachine/New()
	..()
	if(!istype(trigger, /datum/artifact_trigger/touch))
		effect = pick(EFFECT_PULSE, EFFECT_AURA)

	effect_type = pick(EFFECT_BLUESPACE, EFFECT_PARTICLE, EFFECT_SYNTH)
	fog_spawn_chance = rand(20, 60)


/datum/artifact_effect/fogmachine/DoEffectGeneric(atom/location)
	var/true_holder = isnull(location) ? src.holder : location
	if(isnull(true_holder))
		return

	if(!prob(fog_spawn_chance))
		return

	var/turf/T = get_turf(true_holder)

	var/datum/effect/effect/system/smoke_spread/chill_mist/funfog = new()
	funfog.set_up(5, 0, T)
	funfog.start()
	return


/datum/artifact_effect/fogmachine/DoEffectTouch(mob/toucher)
	src.DoEffectGeneric(src.holder)


/datum/artifact_effect/fogmachine/DoEffectAura(atom/holder)
	src.DoEffectGeneric(holder)


/datum/artifact_effect/fogmachine/DoEffectPulse(atom/holder)
	src.DoEffectGeneric(holder)
