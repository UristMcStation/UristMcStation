/datum/artifact_effect/poltergeist
	name = "poltergeist"
	effect_type = EFFECT_ENERGY


/datum/artifact_effect/poltergeist/DoEffectTouch(mob/living/user)
	throw_at_mob(user, rand(10, 30))


/datum/artifact_effect/poltergeist/DoEffectAura()
	var/mob/living/target = null
	var/turf/holder_turf = get_turf(holder)
	for (var/mob/living/L in oview(holder_turf, effectrange))
		if (L.stat || !L.mind)
			continue
		if (target && get_dist(holder_turf, L) > get_dist(holder_turf, target))
			continue
		target = L
	if (target)
		throw_at_mob(target, rand(15, 30))


/datum/artifact_effect/poltergeist/DoEffectPulse()
	var/mob/living/target = null
	var/turf/holder_turf = get_turf(holder)
	for (var/mob/living/L in oview(holder_turf, effectrange))
		if (L.stat || !L.mind)
			continue
		if (target && get_dist(holder_turf, L) > get_dist(holder_turf, target))
			continue
		target = L
	if (target)
		throw_at_mob(target, chargelevelmax)


/datum/artifact_effect/poltergeist/proc/throw_at_mob(mob/living/target, damage = 10)
	var/list/valid_targets = list()
	for (var/obj/O in oview(world.view, target))
		if (!O.anchored && isturf(O.loc))
			valid_targets |= O
	if (length(valid_targets))
		var/obj/obj_to_throw = pick(valid_targets)
		obj_to_throw.visible_message(SPAN_CLASS("alien", "\The [obj_to_throw] levitates, before hurtling toward [target]!"))
		obj_to_throw.throw_at(target, world.view, min(40, damage * obj_to_throw.w_class))
