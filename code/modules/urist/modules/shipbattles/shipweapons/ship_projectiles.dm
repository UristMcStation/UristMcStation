//you really don't want to get hit by any of these

/obj/item/projectile/var/ship = 0 //to override Bay's hardcoded damage cap on walls

/obj/item/projectile/ion/ship
	heavy_effect_range = 4
	light_effect_range = 7
	ship = 1
	life_span = 300

/obj/item/projectile/ion/ship/on_hit(atom/target, var/blocked = 0)
	var/flicker_range = light_effect_range * 2 //16 for the base ion pulse
	for(var/obj/machinery/light/L in range(flicker_range, target))
		L.flicker(rand(5,15))

	..()

/obj/item/projectile/ion/ship/heavy
	heavy_effect_range = 8
	light_effect_range = 15

/obj/item/projectile/bullet/ship
	ship = 1
	life_span = 300
	var/shake_range = 0 //what's the range that we shake people's screens

/obj/item/projectile/bullet/ship/cannon //don't get hit by this
	name ="autocannon shell"
	icon = 'icons/urist/items/ship_projectiles.dmi'
	icon_state= "cannon"
	damage = 100
	damage_flags = DAMAGE_FLAG_BULLET
	sharp = 1
	edge = 1
	stun = 1
	weaken = 1
	penetrating = 2 //let's try this out
	armor_penetration = 100
	penetration_modifier = 1.5
	shake_range = 6

/obj/item/projectile/bullet/ship/cannon/on_impact(atom/A)
	if(isturf(A))
		explosion(A, 2, EX_ACT_LIGHT, adminlog = 0, turf_breaker = FALSE)
	..()

///obj/item/projectile/bullet/ship/cannon/on_impact(var/atom/A)
//	explosion(A, -1, 0, 2)
//	..()

/obj/meteor/shipmissile
	meteordrop = null
	ismissile = TRUE
	dropamt = 0
	icon = 'icons/urist/items/ship_projectiles.dmi'
	hits = 1
	var/ex_range
	var/wall_decon = FALSE

/obj/meteor/shipmissile/meteor_effect()
	..()
	explosion(src.loc, ex_range, hitpwr, adminlog = 0, turf_breaker = wall_decon)

//missiles

/obj/meteor/shipmissile/smallmissile
	name = "small missile"
	icon_state= "smallmissile"
	shield_damage_override = 10
	shake_range = 15
	hitpwr = EX_ACT_LIGHT
	ex_range = 8
	flicker_range = 12

/obj/meteor/shipmissile/smallalienmissile
	name = "small alien missile"
	icon_state= "smallalienmissile"
	wall_decon = TRUE
	shield_damage_override = 100
	shake_range = 20
	hitpwr = EX_ACT_HEAVY
	ex_range = 11
	flicker_range = 15

/obj/meteor/shipmissile/bigmissile
	name = "big missile"
	icon = 'icons/urist/items/ship_projectiles48x48.dmi'
	icon_state= "bigmissile"
	shield_damage_override = 10
	shake_range = 25
	wall_decon = TRUE
	hitpwr = EX_ACT_HEAVY
	ex_range = 12
	flicker_range = 15

/obj/meteor/shipmissile/bigalienmissile
	name = "big alien missile"
	icon = 'icons/urist/items/ship_projectiles48x48.dmi'
	icon_state= "bigalienmissile"
	shield_damage_override = 150
	shake_range = 30
	wall_decon = TRUE
	hitpwr = EX_ACT_DEVASTATING
	ex_range = 11
	flicker_range = 15

//torpedoes

/obj/meteor/shipmissile/smalltorpedo
	name = "small torpedo"
	icon_state= "smalltorpedo"
	shield_damage_override = 10
	shake_range = 20
	wall_decon = TRUE
	hitpwr = EX_ACT_HEAVY
	ex_range = 15
	flicker_range = 20

/obj/meteor/shipmissile/bigtorpedo
	name = "big torpedo"
	icon = 'icons/urist/items/ship_projectiles48x48.dmi'
	icon_state= "bigtorpedo"
	shield_damage_override = 10
	shake_range = 30
	wall_decon = TRUE
	hitpwr = EX_ACT_DEVASTATING
	ex_range = 20
	flicker_range = 25

/obj/meteor/shipmissile/alientorpedo
	name = "alien torpedo"
	icon = 'icons/urist/items/ship_projectiles48x48.dmi'
	icon_state= "alientorpedo"
	shield_damage_override = 150
	shake_range = 25
	wall_decon = TRUE
	hitpwr = EX_ACT_DEVASTATING
	ex_range = 20
	flicker_range = 25

/obj/meteor/shipmissile/bigalientorpedo
	name = "alien torpedo"
	icon = 'icons/urist/items/ship_projectiles48x48.dmi'
	icon_state= "alientorpedo"
	shield_damage_override = 200
	shake_range = 30
	wall_decon = TRUE
	hitpwr = EX_ACT_DEVASTATING
	ex_range = 25
	flicker_range = 30

//misc "missiles"
/obj/meteor/shipmissile/mininuke
	name = "mininuke"
	icon_state = "minibomb-nuke"
	shield_damage_override = 10
	shake_range = 20
	wall_decon = TRUE
	hitpwr = EX_ACT_DEVASTATING
	ex_range = 6
	flicker_range = 30

/obj/meteor/shipmissile/mininuke/meteor_effect()
	..()
	new /obj/decal/cleanable/greenglow(get_turf(src))
	SSradiation.radiate(src, 50)


//beam weapons

/obj/projectile/ship
	icon = 'icons/urist/items/ship_projectiles.dmi'

/obj/projectile/ship/heavy_laser
	light_power = 1

/obj/projectile/ship/heavy_laser/tracer
	icon_state = "beam_heavy"

/obj/projectile/ship/heavy_laser/muzzle
	icon_state = "muzzle_beam_heavy"

/obj/projectile/ship/heavy_laser/impact
	icon_state = "impact_beam_heavy"

/obj/item/projectile/beam/ship
//	var/life = 20
	icon = 'icons/urist/items/ship_projectiles.dmi'
	ship = 1
	life_span = 300
	var/wall_decon = FALSE
	var/severity = EX_ACT_LIGHT
	var/ex_range = 2
	var/shake_range = 10

/obj/item/projectile/beam/ship/on_hit(atom/target, var/blocked = 0)
	for(var/mob/M in range(shake_range, target))
		if(!M.stat && !istype(M, /mob/living/silicon/ai))\
			shake_camera(M, 3, 1)

	var/location = (get_turf(target))


	if(istype(target, /turf/simulated/wall) && wall_decon)
		var/turf/simulated/wall/W = target

		W.dismantle_wall(1)

	for(var/obj/machinery/light/L in range(shake_range, target))
		L.flicker(rand(5,15))

	explosion(location, ex_range, severity, 0, 0)

	return 1

/obj/item/projectile/beam/ship/lightlaser
	name = "light laser"
	icon_state = "heavylaser"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	damage = 300
	armor_penetration = 100

	muzzle_type = /obj/projectile/laser/heavy/muzzle
	tracer_type = /obj/projectile/laser/heavy/tracer
	impact_type = /obj/projectile/laser/heavy/impact

/obj/item/projectile/beam/ship/heavylaser
	name = "heavy laser"
	icon_state = "heavylaser"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	damage = 600
	armor_penetration = 200
//	life = 30
	wall_decon = TRUE

	muzzle_type = /obj/projectile/laser/heavy/muzzle
	tracer_type = /obj/projectile/laser/heavy/tracer
	impact_type = /obj/projectile/laser/heavy/impact

/obj/item/projectile/beam/ship/alien
	icon = 'icons/urist/items/guns.dmi'
	muzzle_type = /obj/projectile/laser/xray/muzzle
	tracer_type = /obj/projectile/laser/xray/tracer
	impact_type = /obj/projectile/laser/xray/impact
	wall_decon = TRUE

/obj/item/projectile/beam/ship/alien/light
	name = "light laser"
	icon_state = "alienprojectile"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	damage = 1000
	armor_penetration = 200

/obj/item/projectile/beam/ship/alien/heavy
	name = "heavy laser"
	icon_state = "alienprojectile"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	damage = 2000
	armor_penetration = 200
	severity = EX_ACT_HEAVY
	ex_range = 4

/obj/item/projectile/beam/ship/pulse
	icon_state = "pulse"
	fire_sound='sound/weapons/pulse.ogg'

	muzzle_type = /obj/projectile/laser/pulse/muzzle
	tracer_type = /obj/projectile/laser/pulse/tracer
	impact_type = /obj/projectile/laser/pulse/impact

/obj/item/projectile/beam/ship/pulse/light
	damage = 100
	severity = EX_ACT_DEVASTATING
	ex_range = 9
	shake_range = 15

/obj/item/projectile/beam/ship/pulse/heavy
	damage = 100
	severity = EX_ACT_DEVASTATING
	ex_range = 15
	shake_range = 20
