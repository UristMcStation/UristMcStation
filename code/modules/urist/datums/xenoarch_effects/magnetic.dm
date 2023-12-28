
/datum/artifact_effect/magnetic
	name = "magnetic"
	effect = EFFECT_PULSE
	effect_type = EFFECT_ELECTRO

	var/magnetism_speed = 10


/datum/artifact_effect/magnetic/New()
	..()
	if(!istype(trigger, /datum/artifact_trigger/touch))
		effect = pick(EFFECT_PULSE, EFFECT_AURA)

	effect_type = pick(EFFECT_ELECTRO, EFFECT_ENERGY)
	effectrange = max(effectrange, 3) // useless otherwise


/datum/artifact_effect/magnetic/DoEffectGeneric(atom/location, var/mob/ignore_mob = null)
	var/true_holder = isnull(location) ? src.holder : location

	if(isnull(true_holder))
		return

	var/turf/T = get_turf(true_holder)

	for(var/atom/movable/AM in range(effectrange, T))
		var/is_ferromagnetic = FALSE

		if(ismob(AM))
			var/mob/M = AM

			if(M == ignore_mob)
				continue

			if(!M.isSynthetic())
				continue

			addtimer(new Callback(src, /datum/artifact_effect/magnetic/proc/YeetCallback, M), rand(0.5 SECONDS, 2 SECONDS), TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)

		if(isitem(AM))
			var/obj/item/I = AM

			for(var/key in I.matter)
				if(key == MATERIAL_STEEL || key == MATERIAL_IRON || key == MATERIAL_PLASTEEL)
					is_ferromagnetic = TRUE
					break

			if(!is_ferromagnetic && istype(AM, /obj/item/material))
				var/obj/item/material/MI = AM

				// unfortunately not a flag on materials and CONDUCTIVE does not represent ferromagnetism -_-
				is_ferromagnetic ||= (MI.material == SSmaterials.materials_by_name[MATERIAL_STEEL])
				is_ferromagnetic ||= (MI.material == SSmaterials.materials_by_name[MATERIAL_PLASTEEL])
				is_ferromagnetic ||= (MI.material == SSmaterials.materials_by_name[MATERIAL_IRON])

			if(!is_ferromagnetic)
				continue

			I.visible_message(SPAN_WARNING("\The [true_holder] magnetically yanks \the [I] towards itself!"))
			I.throw_at(T, rand(1, effectrange), src.magnetism_speed)

	return


/datum/artifact_effect/magnetic/DoEffectAura(atom/holder)
	src.DoEffectGeneric(holder)


/datum/artifact_effect/magnetic/DoEffectPulse(atom/holder)
	src.DoEffectGeneric(holder)


/datum/artifact_effect/magnetic/proc/YeetCallback(mob/target)
	var/mob/M = target

	if(!istype(M))
		return

	var/true_holder = src.holder

	if(isnull(true_holder))
		return

	if(!M.isSynthetic())
		return

	var/turf/T = get_turf(true_holder)
	M.visible_message(SPAN_WARNING("\The [true_holder] magnetically yanks \the [M] towards itself!"))
	M.throw_at(T, rand(1, effectrange), src.magnetism_speed)
	return


/datum/artifact_effect/magnetic/DoEffectTouch(mob/toucher)
	var/mob/M = toucher
	src.DoEffectGeneric(M, M)

	if(!istype(M))
		return

	if(!M.isSynthetic())
		return

	addtimer(new Callback(src, /datum/artifact_effect/magnetic/proc/YeetCallback, M), rand(2 SECONDS, 6 SECONDS), TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)

	return
