/obj/decal/cleanable/blood/gibs/robot
	name = "robot debris"
	desc = "It's a useless heap of junk..."
	icon = 'icons/mob/robots_gibs.dmi'
	icon_state = "gib1"
	basecolor = SYNTH_BLOOD_COLOUR
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6", "gib7")
	cleanable_scent = "industrial lubricant"
	scent_intensity = /singleton/scent_intensity/normal
	scent_range = 2
	weather_sensitive = FALSE

/obj/decal/cleanable/blood/gibs/robot/on_update_icon()
	color = "#ffffff"

/obj/decal/cleanable/blood/gibs/robot/dry()	//pieces of robots do not dry up like
	return

/obj/decal/cleanable/blood/gibs/robot/streak(list/directions)
	var/direction = pick(directions)
	for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
		sleep(3)
		if (i > 0)
			if (prob(40))
				var/obj/decal/cleanable/blood/oil/streak = new(src.loc)
				streak.update_icon()
			else if (prob(10))
				var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
				s.set_up(3, 1, src)
				s.start()
		if (step_to(src, get_step(src, direction), 0))
			break

/obj/decal/cleanable/blood/gibs/robot/limb
	random_icon_states = list("gibarm", "gibleg")

/obj/decal/cleanable/blood/gibs/robot/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6", "gib7","gibup1","gibup1") //2:7 is close enough to 1:4

/obj/decal/cleanable/blood/gibs/robot/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6", "gib7","gibdown1","gibdown1") //2:7 is close enough to 1:4

/obj/decal/cleanable/blood/oil
	basecolor = SYNTH_BLOOD_COLOUR
	cleanable_scent = "industrial lubricant"

/obj/decal/cleanable/blood/oil/dry()
	return

/obj/decal/cleanable/blood/oil/streak
	random_icon_states = list("mgibbl1", "mgibbl2", "mgibbl3", "mgibbl4", "mgibbl5")
	amount = 2
