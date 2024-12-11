//This artifact turns into a fabricator!
//This fabricator changes nearby floors and walls over time, as well as spawning hivebots and other fabricators (both limited)
//Then those fabricators change adjacent floors and walls and spawn more hivebots (to a limit)...

/datum/artifact_effect/greygoo
	name = "greygoo"
	effect_type = EFFECT_SYNTH
	var/activation_sound = 'sound/effects/turret/move1.wav'
	var/activation_messages = list(
		"whirs...",
		"whirs ominously.",
		"lets out a piercing whine as the world around it turns to circuitry!",
	)

/datum/artifact_effect/greygoo/New()
	..()
	effect = EFFECT_PULSE
	if (chargelevelmax > 30)
		chargelevelmax = rand(10, 30)

/datum/artifact_effect/greygoo/DoEffectPulse(send_message = TRUE)
	if(holder)
		for(var/turf/simulated/T in range(1, holder))
			T.mechanize()
		playsound(holder, activation_sound, 50)
		if (send_message)
			holder.visible_message(SPAN_DANGER("\The [holder] [pick(activation_messages)]"))
		new /obj/effect/gateway/artifact/fabricator/king(get_turf(holder))
		qdel(holder)

//Helper procs - cultify() but with robots
/turf/proc/mechanize()
	ChangeTurf(get_base_turf_by_area(src))
	return

/turf/simulated/floor/mechanize()
	mechanize_floor()

/turf/simulated/wall/mechanize()
	mechanize_wall()

/turf/proc/mechanize_wall(turf/simulated/wall/wall)
	wall = src
	if (!istype(wall, /turf/simulated/wall/alium))
		ChangeTurf(/turf/simulated/wall/alium)
		desc = "A wall of foreign metal."
		wall.material.icon_colour = "#8f3432"


/turf/simulated/floor/proc/mechanize_floor(turf/simulated/floor/T)
	if (!istype(T?.flooring, /singleton/flooring/reinforced/circuit/red))
		set_flooring(GET_SINGLETON(/singleton/flooring/reinforced/circuit/red))

/obj/effect/gateway/artifact/fabricator/proc/unregister_mob(mob/M)
	GLOB.destroyed_event.unregister(M, src)
	GLOB.death_event.unregister(M, src)
	mobs -= M

/obj/effect/gateway/artifact/fabricator/proc/register_mob(mob/M)
	mobs += M
	GLOB.destroyed_event.register(M, src, .proc/unregister_mob)
	GLOB.death_event.register(M, src, .proc/unregister_mob)

/obj/effect/gateway/artifact/fabricator
	name = "strange machine"
	desc = "Its circuitry spans into the floor beneath it."
	icon = 'icons/urist/obj/hivefabs.dmi'
	icon_state = "hivefab"
	pixel_x = 0
	pixel_y = 0
	light_outer_range = 2
	light_color = COLOR_SABER_RED
	density = TRUE
	anchored = TRUE
	health_current = 50
	health_max = 50
	health_resistances = list(
		DAMAGE_EMP       = 100
	)
	damage_hitsound = 'sound/weapons/Genhit.ogg'
	mob_spawn_sounds = list(
		'sound/effects/turret/open.wav',
		'sound/effects/metal_close.ogg'
	)
	spawnable = list(
				/mob/living/simple_animal/hostile/hivebot = 80)
	var/active = TRUE
	var/list/mobs = list()
	var/maximum_mob_count = 2
	var/obj/effect/gateway/artifact/fabricator/king/fabtracker

/obj/effect/gateway/artifact/fabricator/Initialize(turf/T, obj/O)
	. = ..()
	addtimer(new Callback(src, .proc/increment), rand(15, 30) SECONDS, TIMER_UNIQUE | TIMER_LOOP)

/obj/effect/gateway/artifact/fabricator/Process()
	if(active == FALSE)
		icon_state = "[icon_state]_d"

/obj/effect/gateway/artifact/fabricator/on_death()
	visible_message(SPAN_DANGER("[src] blows apart!"))
	new /obj/effect/decal/cleanable/blood/gibs/robot (src.loc)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	for(var/obj/effect/gateway/artifact/fabricator/king/A in world)
		A.fabs -= 1

	for (var/mob/M in mobs)
		unregister_mob(M)

	qdel(src)

/obj/effect/gateway/artifact/fabricator/proc/increment()
	if(active)
		if (length(mobs) < maximum_mob_count)
			var/mob/living/simple_animal/hostile/hivebot/B = pickweight(spawnable)
			icon_state = "[icon_state]_p"
			var/turf/simulated/nearby = CircularRandomTurfAround(src, 1)
			if(!nearby.density)
				B = new B(nearby)
				src.icon_state = initial(icon_state)
				B.faction = "nanomachines"
				if (!istype(B, /mob/living/simple_animal/hostile/hivebot/mega))
					B.icon_state = "red"
				register_mob(B)

				playsound(B, pick(mob_spawn_sounds), 50)
				visible_message(SPAN_WARNING("\The [src] churns out a hivebot!"))

		for(var/turf/simulated/floor/T in range(1, src))
			if (!istype(T.flooring, /singleton/flooring/reinforced/circuit/red))
				T.mechanize()
		for(var/turf/simulated/wall/wall in range(1, src))
			if (!istype(wall, /turf/simulated/wall/alium))
				wall.mechanize()

/obj/effect/gateway/artifact/fabricator/king
	name = "large strange machine"
	icon_state = "kingfab"
	spawnable = list(
				/mob/living/simple_animal/hostile/hivebot = 80,
				/mob/living/simple_animal/hostile/hivebot/range = 45,
				/mob/living/simple_animal/hostile/hivebot/strong = 25
				)
	health_current = 500 //slightly more than a blob core
	health_max = 500
	maximum_mob_count = 5
	var/fabs = 0
	var/mechradius = 2

/obj/effect/gateway/artifact/fabricator/king/increment()
	..()
	var/obj/effect/gateway/artifact/fabricator/king/A = src
	for(var/turf/simulated/s in range(mechradius, src))
		if(istype(s, /turf/simulated/floor))
			var/turf/simulated/floor/b = s
			if(istype(b.flooring, /singleton/flooring/reinforced/circuit/red) && rand(1,1000) == 7)
				if (A.fabs < 5 && !s.turf_is_crowded())
					var/obj/effect/gateway/artifact/fabricator/fab = new(b)
					to_chat(fab, SPAN_WARNING("A machine emerges from the circuitry!"))
					A.fabs += 1
			else if (rand(1,5) == 3)
				s.mechanize()
		if((!istype(s, /turf/simulated/wall/alium)) && (rand(1,7) == 7))
			s.mechanize()
	mechradius += 0.2

/obj/effect/gateway/artifact/fabricator/king/on_death()
	for (var/mob/M in mobs)
		unregister_mob(M)

	for (var/P in src.fabs)
		GLOB.destroyed_event.unregister(P, src)

	fabs = null
	visible_message(SPAN_DANGER("[src] explodes!"))
	explosion(src.loc, 8, EX_ACT_HEAVY, 0, turf_breaker = TRUE)
	for(var/obj/effect/gateway/artifact/fabricator/madefabs in world)
		madefabs.active = FALSE
	qdel(src)
