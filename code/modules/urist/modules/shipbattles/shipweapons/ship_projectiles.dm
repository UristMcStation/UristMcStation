//you really don't want to get hit by any of these

/obj/item/projectile/var/ship = 0 //to override Bay's hardcoded damage cap on walls

/obj/item/projectile/ion/ship
	heavy_effect_range = 4
	light_effect_range = 8
	ship = 1
	kill_count = 300

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
//	penetrating = 2 //let's try this out
	armor_penetration = 100
	penetration_modifier = 1.5

/obj/item/projectile/bullet/ship/cannon/ship/on_impact(var/atom/A)
	explosion(A, -1, 0, 2)
	..()

/obj/item/projectile/bullet/ship/smallmissile
	name = "small missile"
	icon = 'icons/urist/items/ship_projectiles.dmi'
	icon_state= "smallmissile"
	damage = 100
	shake_range = 15

/obj/item/projectile/bullet/ship/smallmissile/on_hit(var/atom/target, var/blocked = 0)
	for(var/mob/M in range(shake_range, src))
		if(!M.stat && !istype(M, /mob/living/silicon/ai))\
			shake_camera(M, 3, 1)
	explosion(target, 0, 2, 4)
	return 1

/obj/item/projectile/bullet/ship/smallalienmissile
	name = "small alien missile"
	icon = 'icons/urist/items/ship_projectiles.dmi'
	icon_state= "smallalienmissile"
	damage = 150
	shake_range = 20

/obj/item/projectile/bullet/ship/smallalienmissile/on_hit(var/atom/target, var/blocked = 0)
	for(var/mob/M in range(shake_range, src))
		if(!M.stat && !istype(M, /mob/living/silicon/ai))\
			shake_camera(M, 3, 1)
	explosion(target, 0, 3, 6)
	return 1

/obj/item/projectile/bullet/ship/bigmissile
	name = "big missile"
	icon = 'icons/urist/items/ship_projectiles48x48.dmi'
	icon_state= "bigmissile"
	damage = 200
	shake_range = 25

/obj/item/projectile/bullet/ship/bigmissile/on_hit(var/atom/target, var/blocked = 0)
	for(var/mob/M in range(shake_range, src))
		if(!M.stat && !istype(M, /mob/living/silicon/ai))\
			shake_camera(M, 3, 1)
	explosion(target, 1, 3, 7)
	return 1

/obj/item/projectile/bullet/ship/bigalienmissile
	name = "big alien missile"
	icon = 'icons/urist/items/ship_projectiles48x48.dmi'
	icon_state= "bigalienmissile"
	damage = 250
	shake_range = 30

/obj/item/projectile/bullet/ship/bigalienmissile/on_hit(var/atom/target, var/blocked = 0)
	for(var/mob/M in range(shake_range, src))
		if(!M.stat && !istype(M, /mob/living/silicon/ai))\
			shake_camera(M, 3, 1)
	explosion(target, 1, 4, 9)
	return 1

/obj/item/projectile/bullet/ship/smalltorpedo
	name = "small torpedo"
	icon = 'icons/urist/items/ship_projectiles.dmi'
	icon_state= "smalltorpedo"
	damage = 100
	shake_range = 20

/obj/item/projectile/bullet/ship/smalltorpedo/on_hit(var/atom/target, var/blocked = 0)
	for(var/mob/M in range(shake_range, src))
		if(!M.stat && !istype(M, /mob/living/silicon/ai))\
			shake_camera(M, 3, 1)
	explosion(target, 3, 4, 5)
	return 1

/obj/item/projectile/bullet/ship/alientorpedo
	name = "alien torpedo"
	icon = 'icons/urist/items/ship_projectiles48x48.dmi'
	icon_state= "alientorpedo"
	damage = 150
	shake_range = 25

/obj/item/projectile/bullet/ship/alientorpedo/on_hit(var/atom/target, var/blocked = 0)
	for(var/mob/M in range(shake_range, src))
		if(!M.stat && !istype(M, /mob/living/silicon/ai))\
			shake_camera(M, 3, 1)
	explosion(target, 4, 5, 6)
	return 1

/obj/item/projectile/bullet/ship/bigtorpedo
	name = "big torpedo"
	icon = 'icons/urist/items/ship_projectiles48x48.dmi'
	icon_state= "bigtorpedo"
	damage = 200
	shake_range = 30

/obj/item/projectile/bullet/ship/bigtorpedo/on_hit(var/atom/target, var/blocked = 0)
	for(var/mob/M in range(shake_range, src))
		if(!M.stat && !istype(M, /mob/living/silicon/ai))\
			shake_camera(M, 3, 1)
	explosion(target, 5, 6, 7)
	return 1

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

/obj/item/projectile/beam/ship/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target))
		explosion(target, -1, 0, 1)
	..()
/*
/obj/item/projectile/beam/ship/Bump(atom/A)
	A.bullet_act(src, def_zone)
	src.life -= 10
	if(life <= 0)
		qdel(src)
	return*/

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

	muzzle_type = /obj/effect/projectile/laser/heavy/muzzle
	tracer_type = /obj/effect/projectile/laser/heavy/tracer
	impact_type = /obj/effect/projectile/laser/heavy/impact

/obj/item/projectile/beam/ship/alien
	icon = 'icons/urist/items/guns.dmi'
	muzzle_type = /obj/effect/projectile/laser/xray/muzzle
	tracer_type = /obj/effect/projectile/laser/xray/tracer
	impact_type = /obj/effect/projectile/laser/xray/impact

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
	damage = 1800
	armor_penetration = 200