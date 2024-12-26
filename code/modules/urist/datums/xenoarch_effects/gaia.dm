/datum/artifact_effect/gaia
	name = "gaia"
	effect_type = EFFECT_ORGANIC
	effect_state = "sparkles_2"
	var/list/my_glitterflies = list()


/datum/artifact_effect/gaia/DoEffectTouch(mob/living/user)
	to_chat(user, SPAN_CLASS("alien", "You feel the presence of something long forgotten."))
	for (var/obj/machinery/portable_atmospherics/hydroponics/Tray in view(world.view,get_turf(holder)))
		age_plantlife(Tray)
	for (var/obj/effect/vine/P in view(world.view,get_turf(holder)))
		age_plantlife(P)


/datum/artifact_effect/gaia/DoEffectAura()
	for (var/obj/machinery/portable_atmospherics/hydroponics/Tray in view(effectrange,holder))
		age_plantlife(Tray)
	for (var/obj/effect/vine/P in view(effectrange,get_turf(holder)))
		age_plantlife(P)


/datum/artifact_effect/gaia/DoEffectPulse()
	for (var/obj/machinery/portable_atmospherics/hydroponics/Tray in view(effectrange,holder))
		age_plantlife(Tray)
	for (var/obj/effect/vine/P in view(effectrange,get_turf(holder)))
		age_plantlife(P)


/datum/artifact_effect/gaia/proc/age_plantlife(obj/machinery/portable_atmospherics/hydroponics/Tray)
	if (istype(Tray) && Tray.seed)
		Tray.health += rand(1,3) * HYDRO_SPEED_MULTIPLIER
		Tray.age += 1
		if (Tray.health > 0 && Tray.dead)
			Tray.dead = FALSE
		Tray.check_health()
		if (!Tray.dead)
			if ((Tray.age > Tray.seed.get_trait(TRAIT_MATURATION)) && \
			 ((Tray.age - Tray.lastproduce) > Tray.seed.get_trait(TRAIT_PRODUCTION)) && \
			 (!Tray.harvest && !Tray.dead))
				Tray.harvest = 1
				Tray.lastproduce = Tray.age
	else if (istype(Tray, /obj/effect/vine))
		var/obj/effect/vine/P = Tray
		Tray = P.plant
		if (Tray)
			age_plantlife(Tray)
			P.update_icon()
