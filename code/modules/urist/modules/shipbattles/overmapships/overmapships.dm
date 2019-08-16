/area/boarding_ship
	name = "Ship - Boarding"
	icon_state = "away"
	requires_power = 0

/mob/living/simple_animal/hostile/overmapship //maybe do components as objects instead of datums
//	var/shipdatum = /datum/ships
	var/shields = 0
	var/firedelay = 100
	var/designation = "FFS"
	var/ship_category = "debug ship"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "ship"
	icon_living = "ship"
	icon_dead = "ship"
	var/boardingmap = "maps/shipmaps/ship_blank.dmm"
	var/list/components = list()
	var/incombat = 0
	var/aggressive = 0 //will always attack
	var/obj/effect/overmap/ship/combat/target_ship
	min_gas = null
	max_gas = null
	minbodytemp = 0
	var/dying = 0 //are we dying?
	var/event = 0 //are we part of an event
	var/boarding = 0 //are we being boarded
	var/can_board = FALSE //can we be boarded
	var/map_spawned = FALSE //have we spawned our boardingmap

/mob/living/simple_animal/hostile/overmapship/New()
	..()

	for(var/datum/shipcomponents/C in src.components)
		C.mastership = src

	for(var/datum/shipcomponents/shield/S in src.components)
		shields = S.strength
		return

	name = ship_category //once i get names, flesh this out

//	var/datum/ships/SD = shipdatum

//	src.shields = SD.shields
//	src.health = SD.health
//	src.faction = SD.faction
//	src.name = SD.name

/mob/living/simple_animal/hostile/overmapship/Allow_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for space carp!	//original comments do not steal

/mob/living/simple_animal/hostile/overmapship/Crossed(O as obj)
	..()

	if(!event)

		if(istype(O, /obj/effect/overmap/ship/combat))
			var/obj/effect/overmap/ship/combat/L = O
			if(L.canfight)
				if(!L.incombat && !L.crossed)
					L.Contact(src)

				else
					return


/mob/living/simple_animal/hostile/overmapship/Life() //here we do the attacking stuff. i hate that this is life, but fuck.
	if(incombat)
		shipfire()

	for(var/datum/shipcomponents/shield/S in src.components)
		if(!S.broken && !S.recharging)
			if(shields <= S.strength)
				shields += S.recharge_rate
				if(shields >= S.strength)
					shields = S.strength

				S.recharging = 1
				spawn(S.recharge_delay)
					S.recharging = 0

	..()


/mob/living/simple_animal/hostile/overmapship/proc/spawnmap()
	for(var/obj/effect/template_loader/ships/S in GLOB.trigger_landmarks) //there can only ever be one of these atm
		S.mapfile = src.boardingmap
		S.Load()
		map_spawned = TRUE
	return

/mob/living/simple_animal/hostile/overmapship/proc/despawnmap()
	for(var/obj/effect/template_loader/ships/S in GLOB.trigger_landmarks) //there can only ever be one of these atm
		S.mapfile = "maps/shipmaps/ship_blank.dmm"
		S.Load()
	return

/mob/living/simple_animal/hostile/overmapship/proc/shipdeath()
	if(dying)
		return

	else
		dying = 1

		if(GLOB.using_map.using_new_cargo)
			for(var/datum/contract/shiphunt/A in GLOB.using_map.contracts)
				if(A.hunt_faction == src.hiddenfaction)
					A.Complete(1)

		for(var/datum/shipcomponents/S in src.components)
			S.broken = TRUE

	//	GLOB.global_announcer.autosay("<b>The attacking [src.ship_category] is going to explode in 45 seconds! Evacuate any boarding parties immediately.</b>", "ICS Nerva Automated Defence Computer", "Common")

	//	spawn(45 SECONDS) //give people on board some time to get out
		target_ship.leave_combat()
		despawnmap()
		GLOB.global_announcer.autosay("<b>The attacking [src.ship_category] has been destroyed.</b>", "ICS Nerva Automated Defence Computer", "Common") //add name+designation if I get lists for that stuff

		spawn(30)
			adjustBruteLoss(maxHealth)
			qdel(src)

/mob/living/simple_animal/hostile/overmapship/proc/shipfire()
	for(var/datum/shipcomponents/weapons/W in src.components)
		if(W.ready && !W.broken)
			W.Fire()

/mob/living/simple_animal/hostile/overmapship/proc/boarded()

	GLOB.global_announcer.autosay("<b>The attacking [src.ship_category] is now able to be boarded via teleporter. Please await further instructions from Command.</b>", "ICS Nerva Automated Defence Computer", "Common") //add name+designation if I get lists for that stuff

	for(var/obj/effect/urist/triggers/boarding_landmark/L in GLOB.trigger_landmarks)
		new /obj/item/device/radio/beacon(L.loc)

	for(var/mob/observer/ghost/G in GLOB.player_list)
		if(G.client)
			G.shipdefender_spawn(src.hiddenfaction)

	for(var/obj/effect/urist/triggers/ai_defender_landmark/A in GLOB.trigger_landmarks)
		A.spawn_mobs()
