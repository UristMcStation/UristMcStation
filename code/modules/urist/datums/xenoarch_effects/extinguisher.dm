/datum/artifact_effect/extinguisher
	name = "Extinguisher"
	effect_type = EFFECT_UNKNOWN
	effect_icon = 'icons/effects/effects.dmi'
	effect_state = "splash"


/datum/artifact_effect/extinguisher/New()
	. = ..()
	effect = pick(EFFECT_PULSE, EFFECT_TOUCH)


/datum/artifact_effect/extinguisher/DoEffectTouch(mob/living/user)
	for(user in oview(effectrange, get_turf(holder)))
		user.water_act(2)


/datum/artifact_effect/extinguisher/UpdateMove()
	DoEffectPulse()


/datum/artifact_effect/extinguisher/DoEffectPulse()
	for(var/turf/simulated/T in range(2, get_turf(holder)))
		if(prob(10))
			T.wet_floor()
		for(var/atom/movable/AM in T)
			AM.water_act(2)

		var/datum/gas_mixture/environment = T.return_air()
		var/min_temperature = T20C + rand(0, 20)

		var/hotspot = (locate(/obj/hotspot) in T)
		if(hotspot && !istype(T, /turf/space))
			var/datum/gas_mixture/lowertemp = T.remove_air(T:air:total_moles)
			if (lowertemp)
				lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
				lowertemp.react()
				T.assume_air(lowertemp)
			qdel(hotspot)

		if (environment && environment.temperature > min_temperature)
			var/removed_heat = clamp(120 * WATER_LATENT_HEAT, 0, -environment.get_thermal_energy_change(min_temperature))
			environment.add_thermal_energy(-removed_heat)
			if (prob(5) && environment && environment.temperature > T100C)
				T.visible_message(SPAN_WARNING("The water sizzles as it lands on \the [T]!"))
