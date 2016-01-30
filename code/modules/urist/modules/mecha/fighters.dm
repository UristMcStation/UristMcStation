/obj/mecha/working/hoverpod/fighter
	health = 300
//	bound_width = 64
//	bound_height = 64
	step_in = 3
	deflect_chance = 15
	max_equip = 6
	damage_absorption = list("brute"=0.75,"fire"=1,"bullet"=0.8,"laser"=0.7,"energy"=0.85,"bomb"=1) //we start off the same as a gygax

/obj/mecha/working/hoverpod/fighter/add_cell(var/obj/item/weapon/cell/infinite/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new(src)
	cell.charge = INFINITY
	cell.maxcharge = INFINITY

/obj/mecha/working/hoverpod/fighter/small/alien
	name = "alien fighter"
	icon = 'icons/urist/vehicles/uristvehicles.dmi'
	icon_state = "alien"
	initial_icon = "alien"
	wreckage = /obj/effect/decal/mecha_wreckage/smallfighter
	deflect_chance = 18
	health = 320

/obj/mecha/working/hoverpod/fighter/small/alien/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/rapid/alien
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/repair_droid
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive
	ME.attach(src)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/rapid/alien
	equip_cooldown = 8
	name = "\improper Alien Burst laser"
	icon_state = "mecha_laser"
	energy_drain = 30
	projectiles_per_shot = 4
	projectile = /obj/item/projectile/beam/scom/alien6
	fire_sound = 'sound/weapons/Laser.ogg'

/obj/effect/decal/mecha_wreckage/smallfighter
	name = "fighter wreckage"
	icon = 'icons/urist/vehicles/uristvehicles.dmi'
	icon_state = "fighter-broken"

/obj/mecha/working/hoverpod/fighter/small/human
	health = 250
	name = "fighter"
	icon = 'icons/urist/vehicles/uristvehicles.dmi'
	icon_state = "fighter"
	initial_icon = "fighter"
	wreckage = /obj/effect/decal/mecha_wreckage/smallfighter

/obj/mecha/working/hoverpod/fighter/large
	bound_width = 64
	bound_height = 64
	step_in = 5

/obj/mecha/working/hoverpod/fighter/large/human
	name = "large fighter"
	icon = 'icons/urist/vehicles/64x64vehicles.dmi'
	icon_state = "bigfighter"
	initial_icon = "bigfighter"
	wreckage = /obj/effect/decal/mecha_wreckage/bigfighter

/obj/effect/decal/mecha_wreckage/bigfighter
	name = "large fighter wreckage"
	icon = 'icons/urist/vehicles/64x64vehicles.dmi'
	icon_state = "bigfighter-broken"

/obj/mecha/working/hoverpod/fighter/large/human/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/rapid
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive/heavy
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/passenger
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/passenger
	ME.attach(src)

/obj/mecha/working/hoverpod/fighter/small/human/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/rapid
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/repair_droid
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive
	ME.attach(src)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive/heavy
	name = "\improper HSRM-4 heavy missile rack"
	icon_state = "mecha_missilerack"
	projectile = /obj/item/missile/heavy
	fire_sound = 'sound/effects/bang.ogg'
	projectiles = 4
	projectile_energy_cost = 1000
	equip_cooldown = 60

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive/heavy/Fire(atom/movable/AM, atom/target, turf/aimloc)
	var/obj/item/missile/heavy/M = AM
	M.primed = 1
	..()

/obj/item/missile/heavy
	icon = 'icons/obj/grenade.dmi'
	icon_state = "missile"
	throwforce = 15

	throw_impact(atom/hit_atom)
		if(primed)
			explosion(hit_atom, 1, 2, 4, 4)
			qdel(src)
		else
			..()
		return

/mob/living/simple_animal/hostile/scom/fighter
	name = "alien fighter"
	icon = 'icons/urist/vehicles/uristvehicles.dmi'
	icon_state = "alien"
	melee_damage_lower = 15
	melee_damage_upper = 15
	ranged = 1
	projectilesound = 'sound/weapons/laser.ogg'
	minimum_distance = 5
	icon_living = "alien"
	icon_dead = "alien"
	projectiletype = /obj/item/projectile/beam/scom/alien6
	maxHealth = 250
	health = 250

/mob/living/simple_animal/hostile/scomfighter/death()
	..()
	visible_message("<span class='danger'>The [src.name] explodes!</span>")
	explosion(src.loc, 0, 0, 2)
	new /obj/effect/decal/mecha_wreckage/smallfighter(src.loc)
	qdel(src)
	return

/obj/mecha/working/hoverpod/fighter/large/alien
	name = "heavy alien drone"
	health = 800
	bound_height = 96
	bound_width = 96
	step_in = 8
	icon_state = "aliendrone"
	initial_icon = "aliendrone"
	icon = 'icons/urist/vehicles/cvrt.dmi'
	deflect_chance = 20

/obj/mecha/working/hoverpod/fighter/large/alien/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/rapid/alien
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive/heavy
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive/heavy
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive
	ME.attach(src)