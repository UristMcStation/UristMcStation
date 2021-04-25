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
	var/list/weapons = list()
	var/incombat = 0
	var/aggressive = 0 //will always attack
	var/obj/effect/overmap/ship/combat/target_ship
	var/obj/effect/overmap/sector/station/home_station
	min_gas = null
	max_gas = null
	minbodytemp = 0
	var/dying = FALSE //are we dying?
	var/event = 0 //are we part of an event
	var/boarding = 0 //are we being boarded
	var/can_board = FALSE //can we be boarded
	var/map_spawned = FALSE //have we spawned our boardingmap
	turns_per_move = 10 //make this influenced by the engine on a ship
	autonomous = TRUE

/mob/living/simple_animal/hostile/overmapship/Initialize()
	.=..()

	for(var/datum/shipcomponents/C in src.components)
		C.mastership = src

	for(var/datum/shipcomponents/weapons/W in src.components)
		weapons += W

	for(var/datum/shipcomponents/shield/S in src.components)
		shields = S.strength

	name = ship_category //once i get names, flesh this out
	faction = "neutral" //come back to this


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
		for(var/datum/shipcomponents/M in src.components)
			if(M.broken)
				return
			else
				M.DoActivate()

	..()

/mob/living/simple_animal/hostile/overmapship/handle_automated_movement()
	turns_since_move++
	if(turns_since_move >= turns_per_move)
		DoMove(pick(GLOB.cardinal), src)
		turns_since_move = 0

/*
	if(turns_since_move >= turns_per_move)
		var/turf/T = get_step(src, pick(GLOB.cardinal))
		turns_since_move = 0
		if(!src.MayEnterTurf(T))
			return

		if(!src.forceMove(T))
			return

		mob.set_dir(direction)
*/
/*
	if(turns_since_move >= turns_per_move)
		var/move_dir = pick(GLOB.cardinal)
		get_step(src, move_dir) //temp
		turns_since_move = 0
*/
/mob/living/simple_animal/hostile/overmapship/proc/spawnmap()
	for(var/obj/effect/template_loader/ships/S in GLOB.trigger_landmarks) //there can only ever be one of these atm
		S.mapfile = src.boardingmap
		S.Load()
		map_spawned = TRUE
		if(home_station && !home_station.known)
			for(var/obj/effect/urist/triggers/station_disk/D in GLOB.trigger_landmarks)
				if(D.faction_id == hiddenfaction.factionid)
					D.spawn_disk(home_station)
	return

/mob/living/simple_animal/hostile/overmapship/proc/despawnmap()
	for(var/obj/effect/template_loader/ships/S in GLOB.trigger_landmarks) //there can only ever be one of these atm
		S.mapfile = "maps/shipmaps/ship_blank.dmm"
		S.Load()
	return

/mob/living/simple_animal/hostile/overmapship/death() //move shipdeath to this proc
	return

/mob/living/simple_animal/hostile/overmapship/proc/shipdeath()
	if(dying)
		return

	else
		dying = TRUE

		if(GLOB.using_map.using_new_cargo)
			GLOB.using_map.destroyed_ships += 1

			for(var/datum/contract/shiphunt/A in GLOB.using_map.contracts)
				if(A.neg_faction == src.hiddenfaction)
					A.Complete(1)

		if(home_station)
//			home_station.spawned_ships -= src
			home_station.ship_amount -= 1

		for(var/datum/shipcomponents/S in src.components)
			S.broken = TRUE

	//	GLOB.global_announcer.autosay("<b>The attacking [src.ship_category] is going to explode in 45 seconds! Evacuate any boarding parties immediately.</b>", "[GLOB.using_map.full_name] Automated Defence Computer", "Common")

	//	spawn(45 SECONDS) //give people on board some time to get out
		target_ship.leave_combat()
		despawnmap()
		GLOB.global_announcer.autosay("<b>The attacking [src.ship_category] has been destroyed.</b>", "[GLOB.using_map.full_name] Automated Defence Computer", "Common") //add name+designation if I get lists for that stuff

		spawn(30)
			adjustBruteLoss(maxHealth)
			qdel(src)

/mob/living/simple_animal/hostile/overmapship/proc/boarded()

	GLOB.global_announcer.autosay("<b>The attacking [src.ship_category] is now able to be boarded via teleporter. Please await further instructions from Command.</b>", "[GLOB.using_map.full_name] Automated Defence Computer", "Common") //add name+designation if I get lists for that stuff

	for(var/obj/effect/urist/triggers/boarding_landmark/L in GLOB.trigger_landmarks)
		new /obj/item/device/radio/beacon(L.loc)

	for(var/obj/effect/urist/triggers/shipweapons/S in GLOB.trigger_landmarks)
		var/datum/shipcomponents/weapons/W = pick(weapons)
		new W.weapon_type(S.loc)
		qdel(S)

	for(var/mob/observer/ghost/G in GLOB.player_list)
		if(G.client)
			G.shipdefender_spawn(src.hiddenfaction)

	for(var/obj/effect/urist/triggers/ai_defender_landmark/A in GLOB.trigger_landmarks)
		A.spawn_mobs()
