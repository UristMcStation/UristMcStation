//you really don't want to get hit by any of these

/obj/item/projectile/var/ship = 0 //to override Bay's hardcoded damage cap on walls

/obj/item/projectile/ion/ship
	heavy_effect_range = 4
	light_effect_range = 7
	ship = 1
	kill_count = 300

/obj/item/projectile/ion/ship/on_hit(var/atom/target, var/blocked = 0)
	var/flicker_range = light_effect_range * 2 //16 for the base ion pulse
	for(var/obj/machinery/light/L in range(flicker_range, target))
		L.flicker(rand(5,15))

	..()

/obj/item/projectile/ion/ship/heavy
	heavy_effect_range = 8
	light_effect_range = 15

/obj/item/projectile/bullet/ship
	ship = 1
	kill_count = 300
	var/shake_range = 0 //what's the range that we shake people's screens

/obj/item/projectile/bullet/ship/cannon //don't get hit by this
	name ="autocannon shell"
	icon = 'icons/urist/items/ship_projectiles.dmi'
	icon_state= "cannon"
	damage = 100
	check_armour = "bullet"
	sharp = 1
	edge = 1
	stun = 1
	weaken = 1
	penetrating = 2 //let's try this out
	armor_penetration = 100
	penetration_modifier = 1.5
	shake_range = 6

/obj/item/projectile/bullet/ship/cannon/on_impact(var/atom/A)
	if(isturf(A))
		explosion(A, -1, 0, 2, 0, 0)

	..()

///obj/item/projectile/bullet/ship/cannon/on_impact(var/atom/A)
//	explosion(A, -1, 0, 2)
//	..()

/obj/item/projectile/bullet/ship/missile
	var/ex_devestation = 0
	var/ex_heavy = 0
	var/ex_light = 0
	var/wall_decon = FALSE

/obj/item/projectile/bullet/ship/missile/on_hit(var/atom/target, var/blocked = 0)
	for(var/mob/M in range(shake_range, target))
		if(!M.stat && !istype(M, /mob/living/silicon/ai))\
			shake_camera(M, 3, 1)

	for(var/obj/machinery/light/L in range(ex_light, target))
		L.flicker(rand(5,15))

	missile_explosion(target)

	return 1

/obj/item/projectile/bullet/ship/missile/proc/missile_explosion(var/atom/target)
	var/location = (get_turf(target))

	if (istype(target, /turf/simulated/wall) && wall_decon)
		var/turf/simulated/wall/W = target

		W.dismantle_wall(1)

	explosion(location, ex_devestation, ex_heavy, ex_light, 0, 0)

/obj/item/projectile/bullet/ship/missile/smallmissile
	name = "small missile"
	icon = 'icons/urist/items/ship_projectiles.dmi'
	icon_state= "smallmissile"
	damage = 10
	shake_range = 15
	ex_devestation = 0
	ex_heavy = 2
	ex_light = 6

/obj/item/projectile/bullet/ship/missile/smallalienmissile
	name = "small alien missile"
	icon = 'icons/urist/items/ship_projectiles.dmi'
	icon_state= "smallalienmissile"
	wall_decon = TRUE
	damage = 100
	shake_range = 20
	ex_devestation = 0
	ex_heavy = 3
	ex_light = 7

/obj/item/projectile/bullet/ship/missile/bigmissile
	name = "big missile"
	icon = 'icons/urist/items/ship_projectiles48x48.dmi'
	icon_state= "bigmissile"
	damage = 10
	shake_range = 25
	wall_decon = TRUE
	ex_devestation = 1
	ex_heavy = 4
	ex_light = 9

/obj/item/projectile/bullet/ship/missile/bigalienmissile
	name = "big alien missile"
	icon = 'icons/urist/items/ship_projectiles48x48.dmi'
	icon_state= "bigalienmissile"
	damage = 150
	shake_range = 30
	wall_decon = TRUE
	ex_devestation = 1
	ex_heavy = 5
	ex_light = 10

/obj/item/projectile/bullet/ship/missile/smalltorpedo
	name = "small torpedo"
	icon = 'icons/urist/items/ship_projectiles.dmi'
	icon_state= "smalltorpedo"
	damage = 10
	shake_range = 20
	wall_decon = TRUE
	ex_devestation = 6
	ex_heavy = 7
	ex_light = 8

/obj/item/projectile/bullet/ship/missile/bigtorpedo
	name = "big torpedo"
	icon = 'icons/urist/items/ship_projectiles48x48.dmi'
	icon_state= "bigtorpedo"
	damage = 10
	shake_range = 30
	wall_decon = TRUE
	ex_devestation = 7
	ex_heavy = 8
	ex_light = 9

/obj/item/projectile/bullet/ship/missile/alientorpedo
	name = "alien torpedo"
	icon = 'icons/urist/items/ship_projectiles48x48.dmi'
	icon_state= "alientorpedo"
	damage = 150
	shake_range = 25
	wall_decon = TRUE
	ex_devestation = 7
	ex_heavy = 8
	ex_light = 9

/obj/item/projectile/bullet/ship/missile/bigalientorpedo
	name = "alien torpedo"
	icon = 'icons/urist/items/ship_projectiles48x48.dmi'
	icon_state= "alientorpedo"
	damage = 200
	shake_range = 30
	wall_decon = TRUE
	ex_devestation = 8
	ex_heavy = 9
	ex_light = 10

//beam weapons

/obj/effect/projectile/ship
	icon = 'icons/urist/items/ship_projectiles.dmi'

/obj/effect/projectile/ship/heavy_laser
	light_max_bright = 1

/obj/effect/projectile/ship/heavy_laser/tracer
	icon_state = "beam_heavy"

/obj/effect/projectile/ship/heavy_laser/muzzle
	icon_state = "muzzle_beam_heavy"

/obj/effect/projectile/ship/heavy_laser/impact
	icon_state = "impact_beam_heavy"

/obj/item/projectile/beam/ship
//	var/life = 20
	icon = 'icons/urist/items/ship_projectiles.dmi'
	ship = 1
	kill_count = 300
	var/wall_decon = FALSE
	var/shake_range = 10
	var/ex_devestation = 0
	var/ex_heavy = 0
	var/ex_light = 2

/obj/item/projectile/beam/ship/on_hit(var/atom/target, var/blocked = 0)
	for(var/mob/M in range(shake_range, target))
		if(!M.stat && !istype(M, /mob/living/silicon/ai))\
			shake_camera(M, 3, 1)

	var/location = (get_turf(target))


	if(istype(target, /turf/simulated/wall) && wall_decon)
		var/turf/simulated/wall/W = target

		W.dismantle_wall(1)

	for(var/obj/machinery/light/L in range(shake_range, target))
		L.flicker(rand(5,15))

	explosion(location, ex_devestation, ex_heavy, ex_light, 1, 0)

	return 1

/obj/item/projectile/beam/ship/lightlaser
	name = "light laser"
	icon_state = "heavylaser"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	damage = 300
	armor_penetration = 100

	muzzle_type = /obj/effect/projectile/laser/heavy/muzzle
	tracer_type = /obj/effect/projectile/laser/heavy/tracer
	impact_type = /obj/effect/projectile/laser/heavy/impact

/obj/item/projectile/beam/ship/heavylaser
	name = "heavy laser"
	icon_state = "heavylaser"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	damage = 600
	armor_penetration = 200
//	life = 30
	wall_decon = TRUE

	muzzle_type = /obj/effect/projectile/laser/heavy/muzzle
	tracer_type = /obj/effect/projectile/laser/heavy/tracer
	impact_type = /obj/effect/projectile/laser/heavy/impact

/obj/item/projectile/beam/ship/alien
	icon = 'icons/urist/items/guns.dmi'
	muzzle_type = /obj/effect/projectile/laser/xray/muzzle
	tracer_type = /obj/effect/projectile/laser/xray/tracer
	impact_type = /obj/effect/projectile/laser/xray/impact
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
	ex_heavy = 1
	ex_light = 3

/obj/item/projectile/beam/ship/pulse
	icon_state = "pulse"
	fire_sound='sound/weapons/pulse.ogg'

	muzzle_type = /obj/effect/projectile/laser/pulse/muzzle
	tracer_type = /obj/effect/projectile/laser/pulse/tracer
	impact_type = /obj/effect/projectile/laser/pulse/impact

/obj/item/projectile/beam/ship/pulse/light
	damage = 100
	ex_devestation = 3
	ex_heavy = 3
	ex_light = 3
	shake_range = 12

/obj/item/projectile/beam/ship/pulse/heavy
	damage = 100
	ex_devestation = 5
	ex_heavy = 5
	ex_light = 5
	shake_range = 15