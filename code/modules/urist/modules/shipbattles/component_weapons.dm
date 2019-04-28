//weapons

/datum/shipcomponents/weapons
//	var/shielddamage = 0 //how much damage do we do to shields
//	var/passshield = 0 //do we go through shields to hit the hull?
//	var/hulldamage = 1 //these three vars don't do anything anymore
	var/firedelay = 0 //how long do we take to fire again
	var/burst = 0 //do we fire a burst
	var/ready = TRUE
	var/obj/item/projectile/projectile_type

/datum/shipcomponents/weapons/proc/Fire()
	if(broken)
		return

	else
		var/obj/effect/urist/projectile_landmark/ship/P = pick(GLOB.ship_projectile_landmarks)
		P.Fire(projectile_type)
//		GLOB.global_announcer.autosay("<b>The attacking [mastership.ship_category] has fired a [src.name] at the [mastership.target_ship.name]. Brace for impact.</b>", "[mastership.target_ship.name] Automated Defence Computer", "Combat")

		if(burst == 1)
			spawn(5)
				P.Fire(projectile_type)

		if(burst >= 2)
			spawn(5)
				P.Fire(projectile_type)
			spawn(10)
				P.Fire(projectile_type)
			if(burst >= 3) //for the autocannon currently
				spawn(15)
					P.Fire(projectile_type)
				spawn(20)
					P.Fire(projectile_type)



		ready = FALSE
		spawn(firedelay)
			ready = TRUE

//		src.announce_fire

///datum/shipcomponents/weapons/proc/announce_fire()
//	GLOB.global_announcer.autosay("<b>The attacking [mastership.ship_category] has fired a [src.name] at the ICS Nerva. Brace for impact.</b>", "ICS Nerva Automated Defence Computer", "Common")

/datum/shipcomponents/weapons/ioncannon
//	shielddamage = 300 //needs testing
	name = "ion cannon"
	firedelay = 12 SECONDS
	projectile_type = /obj/item/projectile/ion/ship

/datum/shipcomponents/weapons/ioncannon/dual
	name = "dual ion cannon"
	firedelay = 20 SECONDS
	burst = 1

/datum/shipcomponents/weapons/autocannon
	name = "autocannon"
	firedelay = 16 SECONDS
	projectile_type = /obj/item/projectile/bullet/ship/cannon
	burst = 3

/datum/shipcomponents/weapons/smallmissile
	name = "small missile launcher"
	projectile_type = /obj/item/projectile/bullet/ship/smallmissile
	firedelay = 20 SECONDS

/datum/shipcomponents/weapons/smallmissile/battery
	name = "small missile battery"
	burst = 2
	firedelay = 40 SECONDS

/datum/shipcomponents/weapons/smallalienmissile
	name = "small alien missile launcher"
	projectile_type = /obj/item/projectile/bullet/ship/smallalienmissile
	firedelay = 26 SECONDS

/datum/shipcomponents/weapons/smallalienmissile/dual
	name = "small alien dual missile launcher"
	firedelay = 32 SECONDS
	burst = 1

/datum/shipcomponents/weapons/smallalienmissile/battery
	name = "small alien missile battery"
	firedelay = 38 SECONDS
	burst = 2

/datum/shipcomponents/weapons/bigmissile
	name = "large missile launcher"
	projectile_type = /obj/item/projectile/bullet/ship/bigmissile
	firedelay = 30 SECONDS

/datum/shipcomponents/weapons/bigmissile/battery
	name = "large missile battery"
	firedelay = 50 SECONDS
	burst = 2

/datum/shipcomponents/weapons/bigalienmissile
	name = "large alien missile launcher"
	projectile_type = /obj/item/projectile/bullet/ship/bigalienmissile
	firedelay = 36 SECONDS

/datum/shipcomponents/weapons/bigalienmissile/dual
	name = "large alien dual missile launcher"
	firedelay = 44 SECONDS
	burst = 1

/datum/shipcomponents/weapons/smalltorpedo
	name = "small torpedo launcher"
	projectile_type = /obj/item/projectile/bullet/ship/smalltorpedo
	firedelay = 26 SECONDS

/datum/shipcomponents/weapons/bigtorpedo
	name = "large torpedo launcher"
	projectile_type = /obj/item/projectile/bullet/ship/bigtorpedo
	firedelay = 42 SECONDS

/datum/shipcomponents/weapons/alientorpedo
	name = "alien torpedo launcher"
	projectile_type = /obj/item/projectile/bullet/ship/alientorpedo
	firedelay = 34 SECONDS

/datum/shipcomponents/weapons/lightlaser
	name = "light laser cannon"
	firedelay = 10 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/lightlaser

/datum/shipcomponents/weapons/lightlaser/dual
	name = "dual light laser cannon"
	firedelay = 14 SECONDS
	burst = 1

/datum/shipcomponents/weapons/lightlaser/auto
	name = "light laser autocannon"
	firedelay = 18 SECONDS
	burst = 2

/datum/shipcomponents/weapons/heavylaser
	name = "heavy laser cannon"
	firedelay = 18 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/heavylaser

/datum/shipcomponents/weapons/heavylaser/dual
	name = "dual heavy laser cannon"
	firedelay = 24 SECONDS
	burst = 1

/datum/shipcomponents/weapons/heavylaser/auto
	name = "heavy laser autocannon"
	firedelay = 30 SECONDS
	burst = 2

//alien

/datum/shipcomponents/weapons/alien/light
	name = "alien rapid-fire beam cannon"
	firedelay = 22 SECONDS
	burst = 3
	projectile_type = /obj/item/projectile/beam/ship/alien/light

/datum/shipcomponents/weapons/alien/heavy
	name = "alien dual heavy beam cannon"
	burst = 1
	firedelay = 32 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/alien/heavy

/datum/shipcomponents/weapons/alien/heavy/burst
	name = "alien rapid-fire heavy beam cannon"
	firedelay = 36 SECONDS
	burst = 2
	projectile_type = /obj/item/projectile/beam/ship/alien/heavy