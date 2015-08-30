/obj/mecha/working/cvrt //why working? because we don't want people to be able to hit things.
	name = "Combat Vehicle - Reconnaissance"
	desc = "A fast armoured vehicle designed to perform reconnaissance missions in combat situations."
	icon = 'icons/urist/vehicles/cvrt.dmi'
	icon_state = "cvrt"
	initial_icon = "cvrt"
	health = 300
	bound_width = 64
	bound_height = 64
	step_in = 5
	deflect_chance = 15
	max_equip = 6
	damage_absorption = list("brute"=0.75,"fire"=1,"bullet"=0.8,"laser"=0.7,"energy"=0.85,"bomb"=1) //we start off the same as a gygax
	wreckage = /obj/effect/decal/mecha_wreckage/cvrt

/obj/mecha/working/cvrt/add_cell(var/obj/item/weapon/cell/infinite/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new(src)
	cell.charge = INFINITY
	cell.maxcharge = INFINITY

//these three procs overriden to play different sounds
/obj/mecha/working/cvrt/mechturn(direction)
	set_dir(direction)
	//playsound(src,'sound/machines/hiss.ogg',40,1)
	return 1

/obj/mecha/working/cvrt/mechstep(direction)
	var/result = step(src,direction)
	if(result)
		playsound(src,'sound/machines/hiss.ogg',40,1)
	return result


/obj/mecha/working/cvrt/mechsteprand()
	var/result = step_rand(src)
	if(result)
		playsound(src,'sound/machines/hiss.ogg',40,1)
	return result

/obj/mecha/working/cvrt/basic/New() //we've got a gun and we take four passengers
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/passenger
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/passenger
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/passenger
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/passenger
	ME.attach(src)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/rapid
	equip_cooldown = 8
	name = "\improper CH-R \"Consecrator\" Burst laser"
	icon_state = "mecha_laser"
	energy_drain = 30
	projectiles_per_shot = 3
	projectile = /obj/item/projectile/beam
	fire_sound = 'sound/weapons/Laser.ogg'

/obj/mecha/working/cvrt/upgraded
	name = "Upgraded Combat Vehicle"
	deflect_chance = 20
	damage_absorption = list("brute"=0.5,"fire"=1.1,"bullet"=0.65,"laser"=0.85,"energy"=0.9,"bomb"=0.8) //and move up to a durand

/obj/mecha/working/cvrt/upgraded/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/rapid
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/passenger
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/passenger
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/passenger
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/passenger
	ME.attach(src)

/obj/effect/decal/mecha_wreckage/cvrt
	name = "CVR wreckage"
	icon = 'icons/urist/vehicles/cvrt.dmi'
	bound_width = 64
	bound_height = 64
	icon_state = "cvrt-broken"

//ryclies

/obj/mecha/working/cvrt/ryclies
	icon_state = "rcvrt"
	initial_icon = "rcvrt"
	wreckage = /obj/effect/decal/mecha_wreckage/rcvrt

/obj/effect/decal/mecha_wreckage/rcvrt
	name = "CVR wreckage"
	icon = 'icons/urist/vehicles/cvrt.dmi'
	bound_width = 64
	bound_height = 64
	icon_state = "rcvrt-broken"