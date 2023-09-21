//weapons

/datum/shipcomponents/weapons
//	var/shield_damage = 0 //how much damage do we do to shields
//	var/pass_shield = 0 //do we go through shields to hit the hull?
//	var/hull_damage = 1 //these three vars don't do anything anymore
	var/firedelay = 0 //how long do we take to fire again
	var/salvo = 1 //how much do we shoot in one salvo?
	var/shot_number = 0 //how much have we fired in this salvo?
	var/salvo_delay = 5 //how long between shots in a salvo
	var/ready = TRUE
	var/atom/movable/projectile_type
	var/obj/machinery/shipweapons/weapon_type = /obj/machinery/shipweapons/beam/lightlaser

/datum/shipcomponents/weapons/DoActivate()
	if(ready && !broken)
		Fire()

/datum/shipcomponents/weapons/proc/Fire(var/turf/start_turf, var/turf/target_turf, var/target_edge, var/target_z) //now infinitely less hacky and broken
	if(broken || !projectile_type) //check one more time, just in case. doing it this way can stop salvo fire mid salvo
		return

	var/obj/effect/overmap/visitable/ship/combat/target = mastership?.target_ship
	if(!target)
		return

	else
//		var/obj/effect/overmap/visitable/ship/combat/T = mastership.target_ship

		if(!start_turf)
			if(!target_z)
				target_z = pick(target.target_zs)

			if(!target_edge)
				if(target.target_dirs)
					target_edge = pick(target.target_dirs)
				else
					target_edge = pick(GLOB.cardinal)

			start_turf = spaceDebrisStartLoc(target_edge, target_z)

		if(!target_turf && target_z)
			target_turf = locate_target(target_z)

		if(start_turf && target_turf)
			ready = FALSE
			if(shot_number < salvo)
				shot_number ++
				launch_projectile(start_turf, target_turf)

				if(shot_number >= salvo)
					spawn(firedelay)
						shot_number = 0
						ready = TRUE
				else
					spawn(salvo_delay)
						Fire(start_turf, target_turf) //doing this so we fire from the same spot. this gets us sustained fire on parts of the ship instead of the random scatter we had in the distant past.

//		GLOB.global_announcer.autosay("<b>The attacking [mastership.ship_category] has fired a [src.name] at the [mastership.target_ship.name]. Brace for impact.</b>", "[mastership.target_ship.name] Automated Defence Computer", "Combat")

//		src.announce_fire

///datum/shipcomponents/weapons/proc/announce_fire()
//	GLOB.global_announcer.autosay("<b>The attacking [mastership.ship_category] has fired a [src.name] at the ICS Nerva. Brace for impact.</b>", "[GLOB.using_map.full_name] Automated Defence Computer", "Common")

/datum/shipcomponents/weapons/proc/locate_target(var/target_z)
	var/target_x = rand(mastership.target_ship.target_x_bounds[1],mastership.target_ship.target_x_bounds[2])
	var/target_y = rand(mastership.target_ship.target_y_bounds[1],mastership.target_ship.target_y_bounds[2])

	var/turf/target = locate(target_x, target_y, target_z)

	return target

/datum/shipcomponents/weapons/proc/launch_projectile(var/turf/start_turf, var/turf/target_turf)
	var/atom/movable/projectile = new projectile_type(start_turf)
	if(istype(projectile, /obj/item/projectile))
		var/obj/item/projectile/P = projectile
		P.launch(target_turf) //projectiles have their own special proc

	else if(istype(projectile, /obj/effect/meteor))
		var/obj/effect/meteor/M = projectile
		M.dest = target_turf
		spawn(0)
			walk_towards(M, M.dest, 3) //meteors do their own thing too

	else
		projectile.throw_at(target_turf) //anything else just uses the default throw proc. this potentially allows for ship weapons that do things like throw mobs. clown cannon anyone?

//ion

/datum/shipcomponents/weapons/ioncannon
	name = "ion cannon"
	firedelay = 18 SECONDS
	projectile_type = /obj/item/projectile/ion/ship
	weapon_type = /obj/machinery/shipweapons/beam/ion
	salvo = 2

/datum/shipcomponents/weapons/ioncannon/heavy
	name = "heavy ion cannon"
	firedelay = 26 SECONDS
	projectile_type = /obj/item/projectile/ion/ship/heavy
	salvo = 2

//cannons

/datum/shipcomponents/weapons/autocannon
	name = "autocannon"
	firedelay = 16 SECONDS
	projectile_type = /obj/item/projectile/bullet/ship/cannon
	salvo = 7

/datum/shipcomponents/weapons/heavy_cannon
	name = "heavy armour-piercing cannon"
	firedelay = 48 SECONDS
	projectile_type = /obj/effect/meteor/supermatter/missile/sabot_round

/datum/shipcomponents/weapons/mininuke
	name = "mini-nuke launcher"
	firedelay = 28 SECONDS
	projectile_type = /obj/effect/meteor/shipmissile/mininuke

//missiles

/datum/shipcomponents/weapons/smallmissile
	name = "small missile launcher"
	projectile_type = /obj/effect/meteor/shipmissile/smallmissile
	firedelay = 20 SECONDS
	salvo = 2

/datum/shipcomponents/weapons/smallmissile/battery
	name = "small missile battery"
	salvo = 4
	firedelay = 40 SECONDS

/datum/shipcomponents/weapons/smallalienmissile
	name = "small alien missile launcher"
	projectile_type = /obj/effect/meteor/shipmissile/smallalienmissile
	firedelay = 26 SECONDS
	salvo = 2

/datum/shipcomponents/weapons/smallalienmissile/battery
	name = "small alien missile battery"
	firedelay = 38 SECONDS
	salvo = 4

/datum/shipcomponents/weapons/bigmissile
	name = "large missile launcher"
	projectile_type = /obj/effect/meteor/shipmissile/bigmissile
	firedelay = 30 SECONDS
	salvo = 2

/datum/shipcomponents/weapons/bigmissile/battery
	name = "large missile battery"
	firedelay = 50 SECONDS
	salvo = 4

/datum/shipcomponents/weapons/bigalienmissile
	name = "large alien missile launcher"
	projectile_type = /obj/effect/meteor/shipmissile/bigalienmissile
	firedelay = 36 SECONDS

/datum/shipcomponents/weapons/bigalienmissile/dual
	name = "large alien dual missile launcher"
	firedelay = 44 SECONDS
	salvo = 2

//torpedo

/datum/shipcomponents/weapons/smalltorpedo
	name = "small torpedo launcher"
	projectile_type = /obj/effect/meteor/shipmissile/smalltorpedo
	firedelay = 26 SECONDS

/datum/shipcomponents/weapons/bigtorpedo
	name = "large torpedo launcher"
	projectile_type = /obj/effect/meteor/shipmissile/bigtorpedo
	firedelay = 42 SECONDS

/datum/shipcomponents/weapons/alientorpedo
	name = "alien torpedo launcher"
	projectile_type = /obj/effect/meteor/shipmissile/alientorpedo
	firedelay = 34 SECONDS

//beam

/datum/shipcomponents/weapons/lightlaser
	name = "light laser cannon"
	firedelay = 10 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/lightlaser

/datum/shipcomponents/weapons/lightlaser/dual
	name = "dual light laser cannon"
	firedelay = 14 SECONDS
	salvo = 2

/datum/shipcomponents/weapons/lightlaser/auto
	name = "light laser autocannon"
	firedelay = 18 SECONDS
	salvo = 4
	weapon_type = /obj/machinery/shipweapons/beam/rapidlightlaser

/datum/shipcomponents/weapons/heavylaser
	name = "heavy laser cannon"
	firedelay = 18 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/heavylaser
	weapon_type = /obj/machinery/shipweapons/beam/heavylaser

/datum/shipcomponents/weapons/heavylaser/dual
	name = "dual heavy laser cannon"
	firedelay = 24 SECONDS
	salvo = 2

/datum/shipcomponents/weapons/heavylaser/auto
	name = "heavy laser autocannon"
	firedelay = 30 SECONDS
	salvo = 4

/datum/shipcomponents/weapons/pulse
	name = "pulse cannon"
	firedelay = 24 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/pulse/light
	weapon_type = /obj/machinery/shipweapons/beam/lightpulse
	salvo = 3

/datum/shipcomponents/weapons/pulse/rapid
	name = "multi-phasic pulse cannon"
	firedelay = 28 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/pulse/light
	weapon_type = /obj/machinery/shipweapons/beam/lightpulse
	salvo = 5

/datum/shipcomponents/weapons/pulse/heavy
	name = "heavy pulse cannon"
	firedelay = 32 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/pulse/heavy
	weapon_type = /obj/machinery/shipweapons/beam/heavypulse
	salvo = 3

//alien

/datum/shipcomponents/weapons/alien/light
	name = "alien rapid-fire beam cannon"
	firedelay = 22 SECONDS
	salvo = 6
	projectile_type = /obj/item/projectile/beam/ship/alien/light

/datum/shipcomponents/weapons/alien/heavy
	name = "alien dual heavy beam cannon"
	salvo = 2
	firedelay = 32 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/alien/heavy

/datum/shipcomponents/weapons/alien/heavy/burst
	name = "alien rapid-fire heavy beam cannon"
	firedelay = 36 SECONDS
	salvo = 5
	projectile_type = /obj/item/projectile/beam/ship/alien/heavy
