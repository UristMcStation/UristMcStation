/datum/artifact_effect/animate_anomaly
	name = "animate anomaly"
	effect_type = EFFECT_PSIONIC
	effect_state = "pulsing"
	var/mob/living/target

/datum/artifact_effect/animate_anomaly/New()
	..()
	effectrange = max(3, effectrange)


/datum/artifact_effect/animate_anomaly/ToggleActivate(reveal_toggle = TRUE)
	. = ..()
	find_target()


/datum/artifact_effect/animate_anomaly/DoEffectTouch(mob/living/user)
	var/obj/O = holder
	var/turf/T = get_step_away(O, user)
	if (target && istype(T) && isturf(O.loc))
		O.Move(T)
		O.visible_message(SPAN_CLASS("alien", "\The [holder] lurches away from [user]!"))


/datum/artifact_effect/animate_anomaly/DoEffectAura()
	var/obj/O = holder
	find_target()
	if (!target || !istype(O))
		return
	O.dir = get_dir(O, target)
	if (isturf(O.loc))
		if (get_dist(O.loc, target.loc) > 1)
			O.Move(get_step_to(O, target))
			O.visible_message(SPAN_CLASS("alien", "\The [O] lurches toward [target]!"))


/datum/artifact_effect/animate_anomaly/DoEffectPulse()
	DoEffectAura()


/datum/artifact_effect/animate_anomaly/proc/find_target()
	if (!target || target.z != holder?.z || get_dist(target, holder) > effectrange)
		var/mob/living/ClosestMob = null
		for (var/mob/living/L in range(effectrange, get_turf(holder)))
			if (!L.mind)
				continue
			if (!ClosestMob)
				ClosestMob = L
				continue
			if (!L.stat)
				if (get_dist(holder, L) < get_dist(holder, ClosestMob))
					ClosestMob = L
		target = ClosestMob
