/datum/artifact_effect/tesla
	name = "tesla"
	effect_type = EFFECT_ELECTRO
	effect_state = "sparkles_4"


/datum/artifact_effect/tesla/New()
	. = ..()
	effect = pick(EFFECT_TOUCH, EFFECT_PULSE)


/datum/artifact_effect/tesla/proc/arc(list/exempt = list())
	holder.visible_message(SPAN_DANGER("The [holder] discharges energy wildly in all directions!"))
	for(var/mob/living/L in oview(world.view, get_turf(holder)))
		if(chargelevel < 3)
			break

		if(L in exempt)
			continue

		var/obj/item/projectile/P = new /obj/item/projectile/beam/stun/shock(get_turf(holder))
		P.launch(L, BP_CHEST)
		chargelevel -= 3


/datum/artifact_effect/tesla/DoEffectTouch(mob/living/user)
	if(chargelevel < 3)
		return
	arc(list(user))


/datum/artifact_effect/tesla/DoEffectPulse()
	if(chargelevel < 3)
		return
	arc()
