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
		GLOB.global_announcer.autosay("<b>The attacking [mastership.ship_category] has fired a [src.name] at the [mastership.target_ship.name]. Brace for impact.</b>", "[mastership.target_ship.name] Automated Defence Computer", "Common")

		if(burst == 1)
			P.Fire(projectile_type)

		if(burst == 2)
			P.Fire(projectile_type)
			P.Fire(projectile_type)

//		src.announce_fire

///datum/shipcomponents/weapons/proc/announce_fire()
//	GLOB.global_announcer.autosay("<b>The attacking [mastership.ship_category] has fired a [src.name] at the ICS Nerva. Brace for impact.</b>", "ICS Nerva Automated Defence Computer", "Common")

/datum/shipcomponents/weapons/ioncannon
//	shielddamage = 300 //needs testing
	name = "ion cannon"
	firedelay = 10 SECONDS
	projectile_type = /obj/item/projectile/ion/ship

/datum/shipcomponents/weapons/autocannon
	name = "autocannon"
	firedelay = 15 SECONDS
	projectile_type = /obj/item/projectile/bullet/ship/cannon
	burst = 2

/datum/shipcomponents/weapons/smallmissile
	name = "small missile launcher"
	projectile_type = /obj/item/projectile/bullet/ship/smallmissile
	firedelay = 20 SECONDS

/datum/shipcomponents/weapons/smallmissile/battery
	name = "small missile battery"
	burst = 2
	firedelay = 40 SECONDS

/datum/shipcomponents/weapons/bigmissile
	name = "large missile launcher"
	projectile_type = /obj/item/projectile/bullet/ship/bigmissile
	firedelay = 30 SECONDS

/datum/shipcomponents/weapons/bigmissile/battery
	name = "large missile battery"
	firedelay = 60 SECONDS
	burst = 1

/datum/shipcomponents/weapons/lightlaser
	name = "light laser cannon"
	firedelay = 10 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/lightlaser

/datum/shipcomponents/weapons/lightlaser/dual
	name = "dual light laser cannon"
	firedelay = 15 SECONDS
	burst = 1

/datum/shipcomponents/weapons/lightlaser/auto
	name = "light laser autocannon"
	firedelay = 20 SECONDS
	burst = 2
