//weapons

/datum/shipcomponents/weapons
//	var/shield_damage = 0 //how much damage do we do to shields
//	var/pass_shield = 0 //do we go through shields to hit the hull?
//	var/hull_damage = 1 //these three vars don't do anything anymore
	var/firedelay = 0 //how long do we take to fire again
	var/burst = 0 //do we fire a burst, and if so, how much?
	var/shot_number = 0 //how much have we fired in this burst?
	var/burst_delay = 5 //how long between shots in a burst
	var/ready = TRUE
	var/obj/item/projectile/projectile_type
	var/obj/machinery/shipweapons/weapon_type = /obj/machinery/shipweapons/beam/lightlaser

/datum/shipcomponents/weapons/DoActivate()
	if(ready && !broken)
		Fire()

/datum/shipcomponents/weapons/proc/Fire(var/obj/effect/urist/projectile_landmark/ship/map_landmark) //now infinitely less hacky and broken
	if(broken) //check one more time, just in case. doing it this way can stop burst fire mid burst
		return

	else
		if(!map_landmark)
			var/obj/effect/overmap/ship/combat/T = mastership.target_ship
			map_landmark = pick(T.landmarks)

		if(burst)
			if(map_landmark)
				ready = FALSE
				if(shot_number < burst)
					shot_number ++
					map_landmark.Fire(projectile_type)
					spawn(burst_delay)
						Fire(map_landmark) //doing this so we fire from the same landmark. this gets us sustained fire on parts of the ship instead of the random scatter we have now.

				else if(shot_number >= burst)
					spawn(firedelay)
						shot_number = 0
						ready = TRUE
		else
			if(map_landmark)
				map_landmark.Fire(projectile_type)
				ready = FALSE
				spawn(firedelay)
					ready = TRUE




//		GLOB.global_announcer.autosay("<b>The attacking [mastership.ship_category] has fired a [src.name] at the [mastership.target_ship.name]. Brace for impact.</b>", "[mastership.target_ship.name] Automated Defence Computer", "Combat")

//		src.announce_fire

///datum/shipcomponents/weapons/proc/announce_fire()
//	GLOB.global_announcer.autosay("<b>The attacking [mastership.ship_category] has fired a [src.name] at the ICS Nerva. Brace for impact.</b>", "[GLOB.using_map.full_name] Automated Defence Computer", "Common")

/datum/shipcomponents/weapons/ioncannon
	name = "ion cannon"
	firedelay = 14 SECONDS
	projectile_type = /obj/item/projectile/ion/ship
	weapon_type = /obj/machinery/shipweapons/beam/ion
	burst = 2

/datum/shipcomponents/weapons/ioncannon/heavy
	name = "heavy ion cannon"
	firedelay = 22 SECONDS
	projectile_type = /obj/item/projectile/ion/ship/heavy
	burst = 2

/datum/shipcomponents/weapons/autocannon
	name = "autocannon"
	firedelay = 16 SECONDS
	projectile_type = /obj/item/projectile/bullet/ship/cannon
	burst = 7

/datum/shipcomponents/weapons/smallmissile
	name = "small missile launcher"
	projectile_type = /obj/item/projectile/bullet/ship/missile/smallmissile
	firedelay = 20 SECONDS
	burst = 2

/datum/shipcomponents/weapons/smallmissile/battery
	name = "small missile battery"
	burst = 4
	firedelay = 40 SECONDS

/datum/shipcomponents/weapons/smallalienmissile
	name = "small alien missile launcher"
	projectile_type = /obj/item/projectile/bullet/ship/missile/smallalienmissile
	firedelay = 26 SECONDS
	burst = 2

/datum/shipcomponents/weapons/smallalienmissile/battery
	name = "small alien missile battery"
	firedelay = 38 SECONDS
	burst = 4

/datum/shipcomponents/weapons/bigmissile
	name = "large missile launcher"
	projectile_type = /obj/item/projectile/bullet/ship/missile/bigmissile
	firedelay = 30 SECONDS
	burst = 2

/datum/shipcomponents/weapons/bigmissile/battery
	name = "large missile battery"
	firedelay = 50 SECONDS
	burst = 4

/datum/shipcomponents/weapons/bigalienmissile
	name = "large alien missile launcher"
	projectile_type = /obj/item/projectile/bullet/ship/missile/bigalienmissile
	firedelay = 36 SECONDS

/datum/shipcomponents/weapons/bigalienmissile/dual
	name = "large alien dual missile launcher"
	firedelay = 44 SECONDS
	burst = 2

/datum/shipcomponents/weapons/smalltorpedo
	name = "small torpedo launcher"
	projectile_type = /obj/item/projectile/bullet/ship/missile/smalltorpedo
	firedelay = 26 SECONDS

/datum/shipcomponents/weapons/bigtorpedo
	name = "large torpedo launcher"
	projectile_type = /obj/item/projectile/bullet/ship/missile/bigtorpedo
	firedelay = 42 SECONDS

/datum/shipcomponents/weapons/alientorpedo
	name = "alien torpedo launcher"
	projectile_type = /obj/item/projectile/bullet/ship/missile/alientorpedo
	firedelay = 34 SECONDS

/datum/shipcomponents/weapons/lightlaser
	name = "light laser cannon"
	firedelay = 10 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/lightlaser

/datum/shipcomponents/weapons/lightlaser/dual
	name = "dual light laser cannon"
	firedelay = 14 SECONDS
	burst = 2

/datum/shipcomponents/weapons/lightlaser/auto
	name = "light laser autocannon"
	firedelay = 18 SECONDS
	burst = 4
	weapon_type = /obj/machinery/shipweapons/beam/rapidlightlaser

/datum/shipcomponents/weapons/heavylaser
	name = "heavy laser cannon"
	firedelay = 18 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/heavylaser
	weapon_type = /obj/machinery/shipweapons/beam/heavylaser

/datum/shipcomponents/weapons/heavylaser/dual
	name = "dual heavy laser cannon"
	firedelay = 24 SECONDS
	burst = 2

/datum/shipcomponents/weapons/heavylaser/auto
	name = "heavy laser autocannon"
	firedelay = 30 SECONDS
	burst = 4

/datum/shipcomponents/weapons/pulse
	name = "pulse cannon"
	firedelay = 24 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/pulse/light
	weapon_type = /obj/machinery/shipweapons/beam/lightpulse
	burst = 3

/datum/shipcomponents/weapons/pulse/rapid
	name = "multi-phasic pulse cannon"
	firedelay = 28 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/pulse/light
	weapon_type = /obj/machinery/shipweapons/beam/lightpulse
	burst = 5

/datum/shipcomponents/weapons/pulse/heavy
	name = "heavy pulse cannon"
	firedelay = 32 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/pulse/heavy
	weapon_type = /obj/machinery/shipweapons/beam/heavypulse
	burst = 3

//alien

/datum/shipcomponents/weapons/alien/light
	name = "alien rapid-fire beam cannon"
	firedelay = 22 SECONDS
	burst = 6
	projectile_type = /obj/item/projectile/beam/ship/alien/light

/datum/shipcomponents/weapons/alien/heavy
	name = "alien dual heavy beam cannon"
	burst = 2
	firedelay = 32 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/alien/heavy

/datum/shipcomponents/weapons/alien/heavy/burst
	name = "alien rapid-fire heavy beam cannon"
	firedelay = 36 SECONDS
	burst = 5
	projectile_type = /obj/item/projectile/beam/ship/alien/heavy