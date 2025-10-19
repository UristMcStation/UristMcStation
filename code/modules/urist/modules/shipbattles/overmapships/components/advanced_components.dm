//boarding
/datum/shipcomponents/teleporter
	name = "teleporter module"
	var/boarding_delay = 3 MINUTES //How long between boarding attempts?
	var/list/boarding_mobs = list(/mob/living/simple_animal/hostile/russian, /mob/living/simple_animal/hostile/russian/ranged) //What mobs do we spawn on boarding?
	var/boarding_number = 4 //We'll spawn this many every time we board.
	var/last_boarding = 0 //How long since we boarded last?
	var/boarding_turf = null//Where do we spawn our mobs?
	var/boarding_failure_chance = 0 //more shields = more chance of preventing teleportation.
	var/boarded_max = 3 //how many times do we board?
	var/boarded_amount = 0 //how many times have we boarded
	var/boarding_message = "Enemy teleporter locked on! Boarding imminient! Expected breach point:"
	var/boarding_hint = "Counterboarding possible; residual portal detected at breach point."
	var/initial_delay = FALSE
	var/bypass_shields = FALSE
	var/counterboarding = FALSE
	var/hostile_counterboarding_chance = 60 //what is the chance that we open a portal to the enemy's ship that will let players board us back

/datum/shipcomponents/teleporter/DoActivate()
	if(mastership.boarding && !counterboarding)
		return //they have better things to do than board the Nerva right now.

	if(initial_delay)
		mastership.target_ship.autoannounce("<b>Hostile [name] detected powering up. Expected time until ready: [(boarding_delay/600)] minutes.</b>", "public")
		last_boarding = world.time + boarding_delay
		return

	if(last_boarding > world.time) //Are we too early?
		return

	if(boarded_amount >= boarded_max)
		return

	boarding_failure_chance = 0 //Zero this var out.

	if(!bypass_shields)
		for(var/obj/machinery/power/shield_generator/S in SSmachines.machinery) //Calculate our failure chance.
			if(S.z in mastership.target_ship.map_z)
				if(S.running == SHIELD_RUNNING)
					boarding_failure_chance += 25 // four shield generators to TOTALLY block boarding.

	if(!boarding_turf) //Locate where we're boarding, give them a warning.
		var/obj/machinery/tele_beacon/active_beacon //what beacon are we locking onto?
		var/list/beacon_list = list()
		for(var/obj/machinery/tele_beacon/B in SSmachines.machinery)
			if(B.z in mastership.target_ship.map_z)
				beacon_list += B
		active_beacon = pick(beacon_list)
		boarding_turf = get_turf(active_beacon)
		var/area/boarding_area = get_area(active_beacon)
		mastership.target_ship.autoannounce("<b>[boarding_message] [boarding_area.name].</b>", "public")

	if(prob(boarding_failure_chance))
		for(var/obj/machinery/power/shield_generator/S in SSmachines.machinery) //Calculate our failure chance.
			if(S.z in mastership.target_ship.map_z)
				S.current_energy -= S.max_energy * 0.05 //knock a little power off the shields, we're knocking at the damn door.
				if(S.hacked) //if it's hacked, the engineers get a small surprise
					var/EMP_turf = get_turf(S)
					empulse(EMP_turf, 0, 2, 0)
		mastership.target_ship.autoannounce("<b>Alert! Tachyon flux detected against shield membrane - shield instability likely.</b>", "technical")
		last_boarding = world.time + boarding_delay
		return //Stop here, the boarding failed.

	//Let's handle boarding.
	var/list/things_in_range = orange(3, boarding_turf)
	var/list/turfs_in_range = list()

	spawn(5 SECONDS)
		for (var/turf/T in things_in_range)
			if(!istype(T, /turf/simulated/floor))
				continue
			turfs_in_range.Add(T)
		if(mastership.boardingmap && mastership.map_spawned && !mastership.defenders_spawned && mastership.target_ship == GLOB.using_map.overmap_ship) //right now only the main ship can board
			if(prob(hostile_counterboarding_chance))
				mastership.target_ship.autoannounce("<b>[boarding_hint]</b>", "public")
				mastership.boarded(TRUE)
				new /obj/structure/boarding/shipportal/shipside(boarding_turf)
		for(var/S = 1 to boarding_number)
			var/boarding_type = pick(boarding_mobs)
			var/spawnturf = pick(turfs_in_range)
			spawn(0.5 SECONDS)
				new boarding_type(spawnturf)
				playsound(spawnturf, 'sound/effects/teleport.ogg', 90, 1)
				sparks(5,1,spawnturf)

		if(prob(80))
			boarding_turf = null //pick somewhere new to board.

	boarded_amount++
	last_boarding = world.time + boarding_delay

//boarding modules
/datum/shipcomponents/teleporter/robotic
	name = "hivebot remote warp module"
	boarding_mobs = list(/mob/living/simple_animal/hostile/hivebot, /mob/living/simple_animal/hostile/hivebot/range, /mob/living/simple_animal/hostile/hivebot/strong, /mob/living/simple_animal/hostile/hivebot/tele)
	boarding_number = 8
	boarded_max = 5
	hostile_counterboarding_chance = 0
	boarding_message = "Unknown electro-magnetic fluctuations detected! Incoming hivebot attack likely. Expected breach point:"

/datum/shipcomponents/teleporter/alien
	name = "alien matter deconstructor/reconstructor"
	boarding_mobs = list(/mob/living/simple_animal/hostile/scom/lactera/light, /mob/living/simple_animal/hostile/scom/lactera/medium, /mob/living/simple_animal/hostile/scom/lactera/heavy)
	boarding_number= 5
	boarding_delay = 2.5 MINUTES
	boarded_max = 5
	boarding_message = "Severe bluespace fluctuations detected! Incoming Lactera boarding party likely. Expected breach point:"
	bypass_shields = TRUE
	counterboarding = TRUE
	hostile_counterboarding_chance = 0

/datum/shipcomponents/teleporter/alien/small
	boarded_max = 3

/datum/shipcomponents/teleporter/pirate
	name = "pirate boarding teleporter"
	boarding_mobs = list(/mob/living/simple_animal/hostile/urist/newpirate,/mob/living/simple_animal/hostile/urist/newpirate/laser, /mob/living/simple_animal/hostile/urist/newpirate/ballistic)
	boarding_number = 6
	boarding_delay = 5 MINUTES
	boarded_max = 2

/datum/shipcomponents/teleporter/pirate/small
	name = "pirate boarding teleporter"
	boarding_number = 4
	boarding_delay = 4 MINUTES
	boarding_mobs = list(/mob/living/simple_animal/hostile/urist/newpirate,/mob/living/simple_animal/hostile/urist/newpirate/laser)
	hostile_counterboarding_chance = 65

/datum/shipcomponents/teleporter/terran
	name = "high-flux Terran Naval teleporter"
	boarding_mobs = list(/mob/living/simple_animal/hostile/urist/terran/marine_space)
	boarding_delay = 1 MINUTE
	boarding_number = 4
	boarded_max = 2
	hostile_counterboarding_chance = 15

/datum/shipcomponents/teleporter/terran/large
	name = "large high-flux Terran Naval teleporter"
	boarding_number = 5
	boarded_max = 3
	hostile_counterboarding_chance = 10

/datum/shipcomponents/teleporter/bluespace_artillery
	name = "bluespace artillery"
	boarding_number = 1
	boarding_delay = 6 MINUTES
	boarding_mobs = list(/obj/urist_intangible/spawn_bomb/bluespace_artillery)
	boarding_message = "Severe bluespace fluctuations detected, hostile Bluespace Artillery inbound! Immediately evacuate the affected area. Expected impact point:"
	boarded_max = 5 //if it manages to fire this many times, we have bigger issues
	counterboarding = TRUE
	hostile_counterboarding_chance = 0

//Shield Disruptors
/datum/shipcomponents/shield_disruptor
	name = "shield disruptor"
	var/disruption_amount = list(0.15, 0.50) // anywhere from 15% to 50%.
	var/disruption_delay = 5 MINUTES
	var/empulse_range = 3

/datum/shipcomponents/shield_disruptor/DoActivate()
	if(last_activation > world.time)
		return

	for(var/obj/machinery/power/shield_generator/S in SSmachines.machinery)
		if(S.z in mastership.target_ship.map_z)
			if(S.running == SHIELD_RUNNING)
				S.current_energy -= S.max_energy * rand(disruption_amount[1], disruption_amount[2])
				if(S.hacked) //if it's hacked, the engineers get a nasty surprise
					var/EMP_turf = get_turf(S)
					empulse(EMP_turf, 1, empulse_range, 0)

	mastership.target_ship.autoannounce("<b>Tachyonic energy surge detected, shields may fluctuate.</b>", "technical")
	last_activation = world.time + disruption_delay

/datum/shipcomponents/shield_disruptor/overcharge //For when someone's shields are SERIOUSLY persistent.
	name = "overcharge disruptor"
	disruption_delay = 5 MINUTES
	var/first_activate //we don't want this to activate immediately when it's in combat.
	empulse_range = 8

/datum/shipcomponents/shield_disruptor/overcharge/DoActivate()
	if(last_activation > world.time)
		return

	if(!first_activate) //they have a few minutes to win, or suffer terribly.

		mastership.target_ship.autoannounce("<b>Massive electromagnetic energy buildup detected in hostile [mastership.ship_category]! T-[(disruption_delay/600)] minutes until buildup is complete.</b>", "public")
		first_activate = 1
		last_activation = world.time + disruption_delay
		return
	//Warn them.

	if(!broken)
		mastership.target_ship.autoannounce("<b>Massive electromagnetic power surge detected! Brace for electromagnetic disruption, T-15 seconds.</b>", "public")

		spawn(15 SECONDS)
			for(var/obj/machinery/power/shield_generator/S in SSmachines.machinery)
				if(S.z in mastership.target_ship.map_z)
					if(S.running == SHIELD_RUNNING)
						var/EMP_turf = get_turf(S)
						empulse(EMP_turf, 4, empulse_range, 0)

						if(S.hacked) //this is what you get for hacking sensitive equipment
							explosion(EMP_turf, 0, 1, 6, 0)

			for(var/obj/machinery/power/apc/A in SSmachines.machinery)
				if(A.z in mastership.target_ship.map_z)
					if(!A.is_critical || !A.emp_hardened)
						var/EMP_turf = get_turf(A)
						empulse(EMP_turf, 1, 2, 0)

	/*				for(var/obj/effect/shield/SE in S.field_segments) //this is old behaviour, and honestly might crash the server if it ever happened inround
						var/EMP_turf = get_turf(SE)
						empulse(EMP_turf, 3.5, 7, 0)
*/

	last_activation = world.time + disruption_delay

/datum/shipcomponents/shield_disruptor/heavy
	name = "heavy shield disruptor"
	disruption_amount= list(0.35, 0.75)
	disruption_delay = 1.5 MINUTES
	empulse_range = 5

//Repair Modules

/datum/shipcomponents/repair_module
	name = "repair module"
	var/repair_amount = 50 //how much HP we restore per activation.
	var/can_fix_broken = FALSE // can we repair broken modules?
	var/hull_repair_prob = 20 //chance of fixing some hull
	var/module_repair_prob = 40 //chace of fixing a bit of a module
	var/module_restore_prob = 10 //chance of totally repairing a module, if can_fix_broken is TRUE.
	var/repair_delay = 1 MINUTES //delay on repairing

/datum/shipcomponents/repair_module/DoActivate()
	var/did_repair //if it did a repair, activate cooldown, otherwise it gets another try on the next life() tick
	if(last_activation > world.time)
		return
	//hull repair stuffs
	if(prob(hull_repair_prob))
		if(mastership.health < mastership.maxHealth)
			var/mastership_after_repair = mastership.health + repair_amount
			if(mastership_after_repair > mastership.maxHealth) //don't want to exceed the health value
				var/new_rep_amount = clamp(repair_amount, 0, mastership.maxHealth)
				mastership.health += new_rep_amount
				did_repair = TRUE
			else //if we good, just add a lump sum of health
				mastership.health += repair_amount
				did_repair = TRUE
	//module repair stuffs
	else if(prob(module_repair_prob))
		for(var/datum/shipcomponents/M in mastership.components)
			if(did_repair)
				break
			if(M.broken)
				continue
			var/mod_start_health = M.GetInitial(health)
			if(M.health < mod_start_health)
				var/module_after_repair = M.health + repair_amount
				if(module_after_repair > mod_start_health)
					var/new_mod_rep_amt = clamp(repair_amount, 0, mod_start_health)
					M.health = new_mod_rep_amt
					did_repair = TRUE
				else
					M.health += repair_amount
					did_repair = TRUE

	//module restoration
	else if(can_fix_broken)
		if(prob(module_restore_prob))
			for(var/datum/shipcomponents/M in mastership.components)
				if(!M.broken)
					continue
				if(did_repair)
					break
				M.health = clamp(repair_amount, 0, M.GetInitial(health)) //incase we're repairing more than a module has in terms of health
				M.broken = FALSE
				M.name = M.GetInitial(name)
				did_repair = TRUE

	if(did_repair) //hit the cooldown
		last_activation = world.time + repair_delay

/datum/shipcomponents/repair_module/module_repair
	name = "system integrity binder"
	repair_amount = 75
	hull_repair_prob = 0
	module_repair_prob = 50
	module_restore_prob = 0

/datum/shipcomponents/repair_module/module_restore
	name = "emergency module rebooter"
	can_fix_broken = TRUE
	hull_repair_prob = 0
	module_repair_prob = 0
	module_restore_prob = 50

/datum/shipcomponents/repair_module/heavy
	name = "heavy repair module"
	repair_amount = 100
	can_fix_broken = TRUE

/datum/shipcomponents/repair_module/hull_repair
	name = "hull integrity binder"
	repair_amount = 100
	hull_repair_prob = 80
	module_repair_prob = 0
	module_restore_prob = 0
	repair_delay = 30 SECONDS

/datum/shipcomponents/repair_module/hivebot
	name = "hivebot repair matrix"
	repair_amount = 100
	repair_delay = 30 SECONDS
	hull_repair_prob = 80
	module_repair_prob = 50
	module_restore_prob = 25
	can_fix_broken = TRUE

//Cloaking Modules

/datum/shipcomponents/cloaking_module
	name = "cloaking module"
	var/evasion_increase = 10 //increase master ship evasion by this much
	var/active = FALSE

/datum/shipcomponents/cloaking_module/DoActivate()
	if(active)
		return

	else
		for(var/datum/shipcomponents/engines/E in mastership.components)
			if((E.evasion_chance + evasion_increase) > 90)
				var/new_evasion_chance = clamp(evasion_increase, 0, 90)
				E.evasion_chance += new_evasion_chance
				active = TRUE
			else
				E.evasion_chance += evasion_increase
				active = TRUE

/datum/shipcomponents/cloaking_module/BlowUp()
	for(var/datum/shipcomponents/engines/E in mastership.components)
		E.evasion_chance -= evasion_increase
	active = FALSE
	..()
