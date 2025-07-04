#define FARMBOT_COLLECT 1
#define FARMBOT_WATER 2
#define FARMBOT_UPROOT 3
#define FARMBOT_NUTRIMENT 4

/mob/living/bot/farmbot
	name = "Farmbot"
	desc = "The botanist's best friend."
	icon = 'icons/mob/bot/farmbot.dmi'
	icon_state = "farmbot0"
	health = 50
	maxHealth = 50
	req_access = list(list(access_hydroponics, access_robotics))

	var/action = "" // Used to update icon
	var/waters_trays = 1
	var/refills_water = 1
	var/uproots_weeds = 1
	var/replaces_nutriment = 0
	var/collects_produce = 0
	var/removes_dead = 0

	var/obj/structure/reagent_dispensers/watertank/tank


/mob/living/bot/farmbot/Initialize(mapload, newTank)
	. = ..()
	if(!newTank)
		newTank = new /obj/structure/reagent_dispensers/watertank(src)
	tank = newTank
	tank.forceMove(src)


/mob/living/bot/farmbot/premade
	name = "Old Ben"
	on = 0

/mob/living/bot/farmbot/GetInteractTitle()
	. = "<head><title>Farmbot controls</title></head>"
	. += "<b>Automatic Hyrdoponic Assisting Unit v1.0</b>"

/mob/living/bot/farmbot/GetInteractStatus()
	. = ..()
	. += "<br>Water tank: "
	if(tank)
		. += "[tank.reagents.total_volume]/[tank.reagents.maximum_volume]"
	else
		. += "error: not found"

/mob/living/bot/farmbot/GetInteractPanel()
	. = "Water plants : <a href='byond://?src=\ref[src];command=water'>[waters_trays ? "Yes" : "No"]</a>"
	. += "<br>Refill watertank : <a href='byond://?src=\ref[src];command=refill'>[refills_water ? "Yes" : "No"]</a>"
	. += "<br>Weed plants: <a href='byond://?src=\ref[src];command=weed'>[uproots_weeds ? "Yes" : "No"]</a>"
	. += "<br>Replace fertilizer: <a href='byond://?src=\ref[src];command=replacenutri'>[replaces_nutriment ? "Yes" : "No"]</a>"
	. += "<br>Collect produce: <a href='byond://?src=\ref[src];command=collect'>[collects_produce ? "Yes" : "No"]</a>"
	. += "<br>Remove dead plants: <a href='byond://?src=\ref[src];command=removedead'>[removes_dead ? "Yes" : "No"]</a>"

/mob/living/bot/farmbot/GetInteractMaintenance()
	. = "Plant identifier status: "
	switch(emagged)
		if(0)
			. += "<a href='byond://?src=\ref[src];command=emag'>Normal</a>"
		if(1)
			. += "<a href='byond://?src=\ref[src];command=emag'>Scrambled (DANGER)</a>"
		if(2)
			. += "ERROROROROROR-----"

/mob/living/bot/farmbot/ProcessCommand(mob/user, command, href_list)
	..()
	if(CanAccessPanel(user))
		switch(command)
			if("water")
				waters_trays = !waters_trays
			if("refill")
				refills_water = !refills_water
			if("weed")
				uproots_weeds = !uproots_weeds
			if("replacenutri")
				replaces_nutriment = !replaces_nutriment
			if("collect")
				collects_produce = !collects_produce
			if("removedead")
				removes_dead = !removes_dead

	if(CanAccessMaintenance(user))
		switch(command)
			if("emag")
				if(emagged < 2)
					emagged = !emagged

/mob/living/bot/farmbot/emag_act(remaining_charges, mob/user)
	. = ..()
	if(!emagged)
		if(user)
			to_chat(user, SPAN_NOTICE("You short out [src]'s plant identifier circuits."))
			ignore_list |= user
		emagged = TRUE
		return 1

/mob/living/bot/farmbot/update_icons()
	if(on && action)
		icon_state = "farmbot_[action]"
	else
		icon_state = "farmbot[on]"

/mob/living/bot/farmbot/handleRegular()
	if(emagged && prob(1))
		flick("farmbot_broke", src)

/mob/living/bot/farmbot/handleAdjacentTarget()
	UnarmedAttack(target)

/mob/living/bot/farmbot/lookForTargets()
	if(emagged)
		for(var/mob/living/carbon/human/H in view(7, src))
			target = H
			return
	else
		for(var/obj/machinery/portable_atmospherics/hydroponics/tray in view(7, src))
			if(confirmTarget(tray))
				target = tray
				return
		if(!target && refills_water && tank && tank.reagents.total_volume < tank.reagents.maximum_volume)
			for(var/obj/structure/hygiene/sink/source in view(7, src))
				target = source
				return

/mob/living/bot/farmbot/calcTargetPath() // We need to land NEXT to the tray, because the tray itself is impassable
	for(var/trayDir in list(NORTH, SOUTH, EAST, WEST))
		target_path = AStar(get_turf(loc), get_step(get_turf(target), trayDir), TYPE_PROC_REF(/turf, Euclidean3dDistance), TYPE_PROC_REF(/turf, Manhattan3dDistance), 0, max_target_dist, id = botcard)
		if(target_path)
			break
	if(!target_path)
		ignore_list |= target
		target = null
		target_path = list()
	return

/mob/living/bot/farmbot/stepToTarget() // Same reason
	var/turf/T = get_turf(target)
	if(!length(target_path) || !T?.Adjacent(target_path[length(target_path)]))
		calcTargetPath()
	makeStep(target_path)
	return

/mob/living/bot/farmbot/UnarmedAttack(atom/A, proximity)
	if(!..())
		return
	if(busy)
		return

	if(istype(A, /obj/machinery/portable_atmospherics/hydroponics))
		var/obj/machinery/portable_atmospherics/hydroponics/T = A
		var/t = confirmTarget(T)
		switch(t)
			if(0)
				return
			if(FARMBOT_COLLECT)
				action = "collect" // Needs a better one
				update_icons()
				visible_message(SPAN_NOTICE("[src] starts [T.dead? "removing the plant from" : "harvesting"] \the [A]."))
				busy = 1
				if(do_after(src, 3 SECONDS, A, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
					visible_message(SPAN_NOTICE("[src] [T.dead? "removes the plant from" : "harvests"] \the [A]."))
					T.physical_attack_hand(src)
			if(FARMBOT_WATER)
				action = "water"
				update_icons()
				visible_message(SPAN_NOTICE("[src] starts watering \the [A]."))
				busy = 1
				if(do_after(src, 3 SECONDS, A, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
					playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
					visible_message(SPAN_NOTICE("[src] waters \the [A]."))
					tank.reagents.trans_to(T, 100 - T.waterlevel)
			if(FARMBOT_UPROOT)
				action = "hoe"
				update_icons()
				visible_message(SPAN_NOTICE("[src] starts uprooting the weeds in \the [A]."))
				busy = 1
				if(do_after(src, 3 SECONDS, A, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
					visible_message(SPAN_NOTICE("[src] uproots the weeds in \the [A]."))
					T.weedlevel = 0
			if(FARMBOT_NUTRIMENT)
				action = "fertile"
				update_icons()
				visible_message(SPAN_NOTICE("[src] starts fertilizing \the [A]."))
				busy = 1
				if(do_after(src, 3 SECONDS, A, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
					visible_message(SPAN_NOTICE("[src] fertilizes \the [A]."))
					T.reagents.add_reagent(/datum/reagent/ammonia, 10)
		busy = 0
		action = ""
		update_icons()
		T.update_icon()
	else if(istype(A, /obj/structure/hygiene/sink))
		if(!tank || tank.reagents.total_volume >= tank.reagents.maximum_volume)
			return
		action = "water"
		update_icons()
		visible_message(SPAN_NOTICE("[src] starts refilling its tank from \the [A]."))
		busy = 1
		while(do_after(src, 1 SECOND, src, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS) && tank.reagents.total_volume < tank.reagents.maximum_volume)
			tank.reagents.add_reagent(/datum/reagent/water, 100)
			if(prob(5))
				playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		busy = 0
		action = ""
		update_icons()
		visible_message(SPAN_NOTICE("[src] finishes refilling its tank."))
	else if(emagged && ishuman(A))
		var/action = pick("weed", "water")
		busy = 1
		spawn(50) // Some delay
			busy = 0
		switch(action)
			if("weed")
				flick("farmbot_hoe", src)
				do_attack_animation(A)
				if(prob(50))
					visible_message(SPAN_DANGER("[src] swings wildly at [A] with a minihoe, missing completely!"))
					return
				var/t = pick("slashed", "sliced", "cut", "clawed")
				A.attack_generic(src, 5, t)
			if("water")
				flick("farmbot_water", src)
				visible_message(SPAN_DANGER("[src] splashes [A] with water!"))
				tank.reagents.splash(A, 100)

/mob/living/bot/farmbot/explode()
	visible_message(SPAN_DANGER("[src] blows apart!"))
	var/turf/Tsec = get_turf(src)

	new /obj/item/material/minihoe(Tsec)
	new /obj/item/reagent_containers/glass/bucket(Tsec)
	new /obj/item/device/assembly/prox_sensor(Tsec)
	new /obj/item/device/scanner/plant(Tsec)

	if(tank)
		tank.forceMove(Tsec)

	if(prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)

	var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
	return

/mob/living/bot/farmbot/confirmTarget(atom/targ)
	if(!..())
		return 0

	if(emagged && ishuman(targ))
		if(targ in view(world.view, src))
			return 1
		return 0

	if(istype(targ, /obj/structure/hygiene/sink))
		if(!tank || tank.reagents.total_volume >= tank.reagents.maximum_volume)
			return 0
		return 1

	var/obj/machinery/portable_atmospherics/hydroponics/tray = targ
	if(!istype(tray))
		return 0

	if(tray.closed_system || !tray.seed)
		return 0

	if(tray.dead && removes_dead || tray.harvest && collects_produce)
		return FARMBOT_COLLECT

	else if(refills_water && tray.waterlevel < 40 && !tray.reagents.has_reagent(/datum/reagent/water))
		return FARMBOT_WATER

	else if(uproots_weeds && tray.weedlevel > 3)
		return FARMBOT_UPROOT

	else if(replaces_nutriment && tray.nutrilevel < 1 && tray.reagents.total_volume < 1)
		return FARMBOT_NUTRIMENT

	return 0


/mob/living/bot/farmbot/get_construction_info()
	return list(
		"Attach a <b>Plant Scanner</b> to a <b>Water Tank</b>.",
		"Add a <b>Bucket</b>.",
		"Add a <b>Minihoe</b>.",
		"Add a <b>Proximity Sensor</b> to complete the farmbot."
	)


/mob/living/bot/farmbot/get_antag_interactions_info()
	. = ..()
	.[CODEX_INTERACTION_EMAG] += "<p>Enables a malfunction that causes \the [initial(name)] to attack mobs, except yourself.</p>"
