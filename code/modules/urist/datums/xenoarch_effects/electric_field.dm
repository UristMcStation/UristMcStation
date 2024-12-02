/datum/artifact_effect/electric_field
	name = "electric field"
	effect_type = EFFECT_ENERGY
	effect_icon = "sparkles_4"

/datum/artifact_effect/electric_field/proc/zap(damage, mob/living/toucher)
	var/list/nearby_mobs = list()
	for (var/mob/living/L in oview(effectrange, get_turf(holder)))
		if (!L.stat)
			nearby_mobs |= L
	nearby_mobs -= toucher
	for (var/obj/machinery/light/light in range(effectrange, get_turf(holder)))
		light.flicker()
	for (var/mob/living/L in nearby_mobs)
		if (L.isSynthetic())
			to_chat(L, SPAN_DANGER("ERROR: Electrical fault detected!"))
			L.stuttering += 15
		if (ishuman(L))
			var/mob/living/carbon/human/H = L
			var/obj/item/organ/external/affected = H.get_organ(check_zone(BP_CHEST))
			H.electrocute_act(damage, holder, H.get_siemens_coefficient_organ(affected), affected)
		else
			L.electrocute_act(damage, holder, 0.75, BP_CHEST)

/datum/artifact_effect/electric_field/DoEffectTouch(mob/living/toucher)
	if(istype(toucher))
		zap((rand(10, 40)), toucher)
		toucher.setClickCooldown(2 SECONDS)

/datum/artifact_effect/electric_field/DoEffectAura()
	zap(damage = (rand(1, 10)))

/datum/artifact_effect/electric_field/DoEffectPulse()
	zap(damage = (rand(10, 30)))
