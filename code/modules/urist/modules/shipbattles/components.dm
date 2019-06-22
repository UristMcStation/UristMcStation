//components, weapons, shields and stuff

/datum/shipcomponents
	var/name = "component"
	var/health = 100
	var/mob/living/simple_animal/hostile/overmapship/mastership = null
	var/broken = FALSE

/datum/shipcomponents/proc/BlowUp()
//	qdel(src)
	mastership.health -= 100
	broken = TRUE
	name = "destroyed [initial(name)]"
	if(mastership.health <= 0)
		mastership.shipdeath()
	return

/datum/shipcomponents/proc/DoActivate()
	return

//shields

/datum/shipcomponents/shield
	var/strength = 0
	var/recharge_rate = 0 //how much do we recharge each recharge_delay
	var/recharging = 0 //are we waiting for the next recharge delay?
	var/recharge_delay = 5 SECONDS //how long do we wait between recharges

/datum/shipcomponents/shield/BlowUp()
	strength = 0
	recharge_rate = 0
	mastership.shields = src.strength
	..()

/datum/shipcomponents/shield/debug
	strength = 800
	recharge_rate = 400 //super high for testing

/datum/shipcomponents/shield/light
	name = "light shield"
	strength = 800
	health = 200
	recharge_rate = 80
	recharge_delay = 10 SECONDS

/datum/shipcomponents/shield/medium
	name = "medium shield"
	strength = 1200
	health = 400
	recharge_rate = 70
	recharge_delay = 10 SECONDS

/datum/shipcomponents/shield/freighter
	name = "freighter shield"
	strength = 1000
	health = 300
	recharge_rate = 50
	recharge_delay = 10 SECONDS

/datum/shipcomponents/shield/fighter
	name = "high performance ultralight shield"
	strength = 400
	health = 100
	recharge_rate = 50
	recharge_delay = 5 SECONDS

/datum/shipcomponents/shield/alien_light
	name = "light alien shield"
	strength = 200
	health = 200
	recharge_rate = 60
	recharge_delay = 5 SECONDS

/datum/shipcomponents/shield/alien_heavy
	name = "heavy alien shield"
	strength = 500
	health = 200
	recharge_rate = 60
	recharge_delay = 8 SECONDS

//evasion

/datum/shipcomponents/bridge

/datum/shipcomponents/engines
	var/evasion_chance = 0

/datum/shipcomponents/engines/BlowUp()
	evasion_chance = 0
	..()

/datum/shipcomponents/engines/freighter
	name = "freighter engines"
	evasion_chance = 5
	health = 200

/datum/shipcomponents/engines/standard
	name = "standard engines"
	evasion_chance = 10
	health = 100

/datum/shipcomponents/engines/combat
	name = "high performance combat engines"
	evasion_chance = 20
	health = 250

/datum/shipcomponents/engines/fighter //for really small ships
	name = "small high performance combat engines"
	evasion_chance = 40
	health = 50

/datum/shipcomponents/engines/alien_light
	name = "alien engines"
	evasion_chance = 25
	health = 150

/datum/shipcomponents/engines/alien_heavy
	name = "heavy alien engines"
	evasion_chance = 15
	health = 250

//boarding

/datum/shipcomponents/teleporter
	name = "teleporter module"
	var/boarding_delay = 3 MINUTES //How long between boarding attempts?
	var/list/boarding_mobs = list(/mob/living/simple_animal/hostile/russian, /mob/living/simple_animal/hostile/russian/ranged) //What mobs do we spawn on boarding?
	var/boarding_number = 4 //We'll spawn this many every time we board.
	var/last_boarding = 0 //How long since we boarded last?
	var/boarding_turf = null//Where do we spawn our mobs?
	var/boarding_failure_chance = 0 //more shields = more chance of preventing teleportation.

/datum/shipcomponents/teleporter/DoActivate()
	if(last_boarding > world.time) //Are we too early?
		return

	boarding_failure_chance = 0 //Zero this var out.

	for(var/obj/machinery/power/shield_generator/S in SSmachines.machinery) //Calculate our failure chance.
		if(S.z in GLOB.using_map.station_levels)
			if(S.running == SHIELD_RUNNING)
				boarding_failure_chance += 25 // four shield generators to TOTALLY block boarding.

	world << "[boarding_failure_chance]"
	if(!boarding_turf) //Locate where we're boarding, give them a warning.
		var/obj/item/device/radio/beacon/active_beacon //what beacon are we locking onto?
		var/list/beacon_list = list()
		for(var/obj/item/device/radio/beacon/B in world)
			if(B.z in GLOB.using_map.station_levels)
				beacon_list += B
				world << "populating list"
		active_beacon = pick(beacon_list)
		world << "[active_beacon.name]"
		boarding_turf = get_turf(active_beacon)
		var/area/boarding_area = get_area(active_beacon)
		world << "[boarding_area.name]"
		GLOB.global_announcer.autosay("<b>Alert! Enemy teleporter locked on! Boarding imminient! Expected breach point: [boarding_area.name].</b>", "ICS Nerva Automated Defence Computer", "Common")

	if(prob(boarding_failure_chance))
		for(var/obj/machinery/power/shield_generator/S in GLOB.using_map.station_levels)
			S.current_energy -= S.max_energy * 0.15 //knock a little power off the shields, we're knocking at the damn door.
		GLOB.global_announcer.autosay("<b>Alert! Tachyon flux detected against shield membrane - shield instability likely.</b>", "ICS Nerva Automated Defence Computer", "Engineering")
		return //Stop here, the boarding failed.

	//Let's handle boarding.
	var/list/things_in_range = orange(3, boarding_turf)
	var/list/turfs_in_range = list()
	for (var/turf/T in things_in_range)
		if(!istype(T, /turf/simulated/floor))
			continue
		turfs_in_range.Add(T)
	for(var/S = 1 to boarding_number)
		var/boarding_type = pick(boarding_mobs)
		var/spawnturf = pick(turfs_in_range)
		new boarding_type(spawnturf)
		playsound(spawnturf, 'sound/effects/teleport.ogg', 90, 1)
	if(prob(15))
		boarding_turf = null //pick somewhere new to board.

	last_boarding = world.time + boarding_delay
