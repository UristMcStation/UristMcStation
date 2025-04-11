/datum/artifact_effect/vampire
	name = "vampire"
	effect_type = EFFECT_ORGANIC
	var/last_bloodcall = 0
	var/bloodcall_interval = 50
	var/last_eat = 0
	var/eat_interval = 100
	var/charges = 0
	var/list/nearby_mobs = list()


/datum/artifact_effect/vampire/DoEffectTouch(mob/living/user)
	bloodcall(user)
	DoEffectAura()


/datum/artifact_effect/vampire/DoEffectAura(atom/holder)

	if (length(nearby_mobs))
		nearby_mobs.Cut()

	var/turf/T = get_turf(holder)

	for (var/mob/living/L in oview(effectrange, T))
		if (!L.stat && L.mind)
			nearby_mobs |= L

	if (world.time - bloodcall_interval >= last_bloodcall && LAZYLEN(nearby_mobs))
		var/mob/living/carbon/human/M = pick(nearby_mobs)
		if (get_dist(M, T) <= effectrange && M.health > 20 && !M.isSynthetic())
			bloodcall(M)
			holder.Beam(M, icon_state = "r_beam", time = 1 SECOND)

	if (world.time - last_eat >= eat_interval)
		var/obj/decal/cleanable/blood/B = locate() in range(2,holder)
		if (B)
			last_eat = world.time
			B.loc = null
			if (istype(B, /obj/decal/cleanable/blood/drip))
				charges += 0.25
			else
				charges += 1
				playsound(holder, 'sound/effects/splat.ogg', 50, 1, -3)
			qdel(B)

	if (charges >= 10)
		charges -= 10
		var/manifestation = pick(/obj/item/device/soulstone, /mob/living/simple_animal/hostile/faithless, /mob/living/simple_animal/hostile/creature/cult, /mob/living/simple_animal/hostile/scarybat)
		new manifestation(pick(RANGE_TURFS(T, 1)))

	if (charges >= 3)
		if (prob(5))
			charges -= 1
			var/spawn_type = pick(/mob/living/simple_animal/hostile/scarybat, /mob/living/simple_animal/hostile/creature/cult, /mob/living/simple_animal/hostile/faithless)
			new spawn_type(pick(RANGE_TURFS(T, 1)))
			playsound(holder, pick('sound/hallucinations/growl1.ogg','sound/hallucinations/growl2.ogg','sound/hallucinations/growl3.ogg'), 50, 1, -3)

	if (charges >= 1 && length(nearby_mobs) && prob(15 * length(nearby_mobs)))
		var/mob/living/L = pick(nearby_mobs)
		if (!L.isSynthetic())
			holder.Beam(L, icon_state = "r_beam", time = 1 SECOND)
			L.apply_damage(40, DAMAGE_PAIN, damage_flags = DAMAGE_FLAG_DISPERSED)
			to_chat(L, SPAN_WARNING("Horrendous pain rocks through your body!"))

	if (charges >= 0.1)
		if (prob(5))
			holder?.visible_message(SPAN_CLASS("alien", "\icon[holder] \The [holder] gleams a bloody red!"))
			charges -= 0.1


/datum/artifact_effect/vampire/DoEffectPulse()
	DoEffectAura()


/datum/artifact_effect/vampire/proc/bloodcall(mob/living/carbon/human/M)
	last_bloodcall = world.time
	if (istype(M) && !M.isSynthetic())
		playsound(holder, pick('sound/hallucinations/wail.ogg','sound/hallucinations/veryfar_noise.ogg','sound/hallucinations/far_noise.ogg'), 50, 1, -3)

		var/target = pick(M.organs_by_name)
		M.apply_damage(rand(5, 10), INJURY_TYPE_CUT, target)
		to_chat(M, SPAN_DANGER("The skin on your [parse_zone(target)] feels like it's ripping apart, and a stream of blood flies out."))
		var/obj/decal/cleanable/blood/splatter/animated/B = new(M.loc)
		B.basecolor = M.species.get_blood_colour(M)
		B.color = M.species.get_blood_colour(M)
		B.target_turf = pick(range(1, get_turf(holder)))
		B.blood_DNA = list()
		B.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
		M.vessel.remove_reagent("blood",rand(10,30))
