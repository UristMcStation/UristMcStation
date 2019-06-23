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
		for(var/datum/shipcomponents/M in src.components)
			M.DoActivate()

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

//ships

/mob/living/simple_animal/hostile/overmapship/debug
//	shipdatum = /datum/ships/debug
	shields = 800
	maxHealth = 800
	health = 800
	wander = 1
	aggressive = 1

/mob/living/simple_animal/hostile/overmapship/debug/New() //light shield for now to mess with some debug stuff
	components = list(
		new /datum/shipcomponents/shield/light,
		new /datum/shipcomponents/weapons/ioncannon,
		new /datum/shipcomponents/weapons/autocannon,
		new /datum/shipcomponents/weapons/lightlaser,
		new /datum/shipcomponents/weapons/smallmissile/battery,
		new /datum/shipcomponents/engines/standard,
		new /datum/shipcomponents/teleporter
	)

	..()

/mob/living/simple_animal/hostile/overmapship/pirate
	wander = 1 //temporary
	color = "#660000"
	hiddenfaction = "pirate"
	aggressive = 1

/mob/living/simple_animal/hostile/overmapship/pirate/small
//	shipdatum = /datum/ships/piratesmall
	shields = 800
	health = 800
	maxHealth = 800
	name = "small pirate ship"
	ship_category = "small pirate ship"
	boardingmap = "maps/shipmaps/ship_pirate_small1.dmm"
	can_board = TRUE

/mob/living/simple_animal/hostile/overmapship/pirate/small/New()
	components = list(
		new /datum/shipcomponents/shield/light,
		new /datum/shipcomponents/engines/standard,
		new /datum/shipcomponents/weapons/smallmissile
	)

	if(prob(50))
		components += new /datum/shipcomponents/weapons/autocannon

	else
		components += new /datum/shipcomponents/weapons/lightlaser/auto

	..()

/mob/living/simple_animal/hostile/overmapship/pirate/med
//	shipdatum = /datum/ships/piratesmall
	shields = 2000
	health = 1000
	maxHealth = 1000
	name = "pirate vessel"
	ship_category = "medium pirate vessel"
	boardingmap = "maps/shipmaps/ship_pirate_small1.dmm"
	can_board = TRUE

/mob/living/simple_animal/hostile/overmapship/pirate/med/New()
	components = list(
		new /datum/shipcomponents/shield/medium,
		new /datum/shipcomponents/engines/standard,
		new /datum/shipcomponents/weapons/smallmissile/battery,
		new /datum/shipcomponents/weapons/heavylaser,
		new /datum/shipcomponents/weapons/autocannon
	)

/mob/living/simple_animal/hostile/overmapship/nanotrasen
	color = "#4286f4"
	wander = 1 //temporary
	hiddenfaction = "nanotrasen"

/mob/living/simple_animal/hostile/overmapship/nanotrasen/ntmerchant
//	shipdatum = /datum/ships/nanotrasen/ntmerchant
	name = "NanoTrasen merchant ship"
	shields = 1000
	health = 800
	maxHealth = 800
	ship_category = "NanoTrasen merchant ship"
	can_board = TRUE

/mob/living/simple_animal/hostile/overmapship/nanotrasen/ntmerchant/New()
	components = list(
		new /datum/shipcomponents/shield/freighter,
		new /datum/shipcomponents/weapons/lightlaser,
		new /datum/shipcomponents/engines/freighter
	)

	..()

/mob/living/simple_animal/hostile/overmapship/nanotrasen/patrol
	name = "NanoTrasen patrol ship"
	shields = 3000
	health = 1600
	maxHealth = 1600
	ship_category = "NanoTrasen patrol ship"


/mob/living/simple_animal/hostile/overmapship/nanotrasen/fast_attack
	name = "NanoTrasen fast attack craft"
	shields = 3000
	health = 500
	maxHealth = 1000
	ship_category = "NanoTrasen fast attack craft"

/mob/living/simple_animal/hostile/overmapship/nanotrasen/fast_attack/New()
	components = list(
		new /datum/shipcomponents/shield/fighter,
		new /datum/shipcomponents/weapons/lightlaser/dual,
		new /datum/shipcomponents/weapons/lightlaser/dual,
		new /datum/shipcomponents/engines/fighter,
		new /datum/shipcomponents/weapons/smallmissile/battery
	)

	..()

/mob/living/simple_animal/hostile/overmapship/alien
	wander = 1
	color = "#660000"
	hiddenfaction = "alien"
	aggressive = 1
	name = "Unknown"
	designation = ""

/mob/living/simple_animal/hostile/overmapship/alien/small
	shields = 200 //really weak, but fast charging shields
	health = 1200 //and beefy hulls
	maxHealth = 1200
	ship_category = "Lactera fast attack craft"
	boardingmap = "maps/shipmaps/ship_lactera_small.dmm"
	can_board = TRUE

/mob/living/simple_animal/hostile/overmapship/alien/small/New() //we'll see
	components = list(
		new /datum/shipcomponents/shield/alien_light,
		new /datum/shipcomponents/engines/alien_light,
		new /datum/shipcomponents/weapons/alien/light,
		new /datum/shipcomponents/weapons/alien/light,
		new /datum/shipcomponents/weapons/alien/heavy,
		new /datum/shipcomponents/weapons/smallalienmissile,
		new /datum/shipcomponents/weapons/smallalienmissile
	)

	..()

/mob/living/simple_animal/hostile/overmapship/alien/heavy //you have to board this motherfucker
	shields = 500 //really weak, but fast charging shields
	health = 2200 //and beefy hulls
	maxHealth = 2200
	ship_category = "Lactera frigate"
	boardingmap = "maps/shipmaps/ship_lactera_large.dmm"
	can_board = TRUE

/mob/living/simple_animal/hostile/overmapship/alien/heavy/New() //only for admemes. this will fuck your day up.
	components = list(
		new /datum/shipcomponents/shield/alien_heavy,
		new /datum/shipcomponents/engines/alien_heavy,
		new /datum/shipcomponents/weapons/alien/light,
		new /datum/shipcomponents/weapons/alien/heavy/burst,
		new /datum/shipcomponents/weapons/alien/heavy/burst,
		new /datum/shipcomponents/weapons/bigalienmissile,
		new /datum/shipcomponents/weapons/bigalienmissile,
		new /datum/shipcomponents/weapons/smallalienmissile/battery,
		new /datum/shipcomponents/weapons/alientorpedo
	)

	..()

//terran

/mob/living/simple_animal/hostile/overmapship/terran
	color = "#9932cc"
//	wander = 1 //temporary
	hiddenfaction = "terran"

/mob/living/simple_animal/hostile/overmapship/terran/tcmerchant
//	shipdatum = /datum/ships/nanotrasen/ntmerchant
	name = "Terran Confederacy merchant ship"
	shields = 1000
	health = 800
	maxHealth = 800
	ship_category = "Terran Confederacy merchant ship"
	boardingmap = "maps/shipmaps/ship_light_freighter.dmm"
	can_board = TRUE

/mob/living/simple_animal/hostile/overmapship/terran/tcmerchant/New()
	components = list(
		new /datum/shipcomponents/shield/freighter,
		new /datum/shipcomponents/weapons/lightlaser,
		new /datum/shipcomponents/engines/freighter
	)

	..()

/mob/living/simple_animal/hostile/overmapship/terran/patrol
	name = "Terran Confederacy patrol ship"
	shields = 3000
	health = 1600
	maxHealth = 1600
	ship_category = "Terran Confederacy patrol ship"

/mob/living/simple_animal/hostile/overmapship/terran/fast_attack
	name = "Terran Confederacy fast attack craft"
	shields = 3000
	health = 500
	maxHealth = 1000
	ship_category = "Terran Confederacy fast attack craft"
	boardingmap = "maps/shipmaps/ship_fastattackcraft_terran.dmm"
	can_board = TRUE

/mob/living/simple_animal/hostile/overmapship/terran/fast_attack/New()
	components = list(
		new /datum/shipcomponents/shield/fighter,
		new /datum/shipcomponents/weapons/lightlaser/dual,
		new /datum/shipcomponents/weapons/lightlaser/dual,
		new /datum/shipcomponents/engines/fighter,
		new /datum/shipcomponents/weapons/smallmissile/battery
	)

	..()

//rebels

/mob/living/simple_animal/hostile/overmapship/rebel
	color = "#cd0000" //Boston University Red, also known as the red on the flag of the USSR
	hiddenfaction = "rebel"

/mob/living/simple_animal/hostile/overmapship/rebel/fast_attack
	name = "rebel fast attack craft"
	shields = 3000
	health = 500
	maxHealth = 1000
	ship_category = "rebel fast attack craft"
	boardingmap = "maps/shipmaps/ship_rebel_small1.dmm"
	can_board = TRUE

/mob/living/simple_animal/hostile/overmapship/rebel/fast_attack/New()
	components = list(
		new /datum/shipcomponents/shield/fighter,
		new /datum/shipcomponents/weapons/lightlaser/dual,
		new /datum/shipcomponents/weapons/lightlaser/dual,
		new /datum/shipcomponents/engines/fighter,
		new /datum/shipcomponents/weapons/smalltorpedo
	)

	..()