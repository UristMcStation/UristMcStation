/proc/PlaySpoopysound(atom/location)
	if(!location)
		return

	playsound(
		location,
		pick(
			'sound/hallucinations/growl1.ogg',\
			'sound/hallucinations/growl2.ogg',\
			'sound/hallucinations/growl3.ogg',\
			'sound/effects/ghost.ogg',\
			'sound/effects/ghost2.ogg',\
			'sound/hallucinations/wail.ogg',\
			'sound/hallucinations/veryfar_noise.ogg',\
			'sound/effects/wind/wind_2_2.ogg',\
			'sound/effects/wind/wind_3_1.ogg',\
			'sound/hallucinations/far_noise.ogg',\
		),
		50,
		1,
		-3
	)

	return TRUE


//a more persistent variant of the shadow wight with a different soundset
/obj/effect/haunter
	name = "wight"
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost-narsie"
	density = FALSE

	var/disappear_chance = 1


/obj/effect/haunter/proc/GetNextPos()
	return get_turf(pick(orange(1,src)))


/obj/effect/haunter/proc/AffectOverlappedMob(mob/M)
	if(!M)
		return

	PlaySpoopysound(src.loc)
	//M.sleeping = max(M.sleeping,rand(5,10))

	return TRUE


/obj/effect/haunter/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)


/obj/effect/haunter/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/effect/haunter/Process()
	if(src.loc)
		var/turf/next_pos = src.GetNextPos()
		src.dir = get_dir(src.loc, next_pos)
		src.loc = next_pos

		var/mob/living/carbon/M = locate() in src.loc

		if(M)
			src.AffectOverlappedMob(M)

		if(is_holy_turf(src.loc))
			// Holiness dispels them
			src.loc = null

		if(prob(src.disappear_chance))
			src.loc = null

	else
		STOP_PROCESSING(SSobj, src)


/*
// Unused by the base class, but factored out for common behavior in independent subclasses
*/

/obj/effect/haunter/proc/ChaseMobTarget(mob/M, var/prob_random = 10, var/min_dist = 1)
	// factored out to reuse across different chasey types
	var/turf/next_pos = null
	var/clamped_odds = clamp(prob_random, 0, 100)

	if(M)
		var/turf/reference_point = get_turf(src)
		if(reference_point?.z != M.z)
			src.z = M.z
			reference_point = get_turf(src)

		if(get_dist(src, M) <= min_dist)
			return reference_point

		next_pos = get_turf(get_step_towards(reference_point, M))

	if((!next_pos) || prob(clamped_odds))
		next_pos = get_turf(pick(orange(1,src)))

	return next_pos


/obj/effect/haunter/proc/StoreMobTarget(mob/M)
	// factored out to reuse across different chasey types
	var/weakref/mob_ref = null

	if(M)
		mob_ref = weakref(M)

	return mob_ref


/obj/effect/haunter/proc/GetMobTarget(weakref/mob_ref)
	// factored out to reuse across different chasey types
	if(isnull(mob_ref))
		return

	var/mob/M = null
	M = mob_ref.resolve()

	return M


/*
// Subclass definitions
*/

// Basic, classic Haunter
/obj/effect/haunter/classic
	// A simple alias to make spawning easier and insulate from changes in the base class
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost-narsie"


/obj/effect/haunter/chaser
	// will follow the last touched mob around
	var/weakref/mob_target = null

	// configurable odds of wandering rather than chasing
	var/prob_random_chase = 1


/obj/effect/haunter/chaser/AffectOverlappedMob(mob/M)
	if(!M)
		return

	var/mob/living/L = M
	if(!(L && istype(L)))
		return

	if(!(src.mob_target) || (istype(src.mob_target) && src.mob_target.resolve() != L))
		// acquire a new target
		src.mob_target = StoreMobTarget(L)

	. = ..(M)
	return


/obj/effect/haunter/chaser/GetNextPos()
	var/turf/next_pos = null
	var/mob/M = GetMobTarget(src.mob_target)
	next_pos = src.ChaseMobTarget(M, src.prob_random_chase)
	return next_pos


/obj/effect/haunter/chaser/classic
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost-narsie"


/obj/effect/haunter/chaser/uristmonster
	icon = 'icons/uristmob/monsters.dmi'
	icon_state = "oozer"

	name = "horror"
	alpha = 200


/obj/effect/haunter/chaser/uristmonster/New()
	. = ..()

	src.icon_state = pick(
		10; "imp_green",
		10; "tentaclearm",
		10; "birdfencer",
		10; "shadowman",
		10; "shambler",
		10; "oozer",
		10; "amigara_red",
		10; "hoodthulhu"
	)

	return
