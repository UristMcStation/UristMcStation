/mob/living/exosuit/premade/cvrt //why working? because we don't want people to be able to hit things. //rip working
	name = "Combat Vehicle - Reconnaissance"
	desc = "A fast armoured vehicle designed to perform reconnaissance missions in combat situations."
	icon = 'icons/urist/vehicles/cvrt.dmi'
	icon_state = "cvrt"
	//initial_icon = "cvrt"
	health_max = 300
	bound_width = 64
	bound_height = 64
	wreckage_path = /obj/decal/mecha_wreckage/cvrt
	var/obj/item/cell/cell

/mob/living/exosuit/premade/cvrt/Initialize()
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/cvrt(src)
		legs.icon_state = null
	if(!head)
		head = new /obj/item/mech_component/sensors/combat(src)
		head.icon_state = null
	if(!body)
		body = new/obj/item/mech_component/chassis/cvrt(src)
		body.icon_state = null
	if(!arms)
		arms = new/obj/item/mech_component/manipulators/combat(src)
		arms.icon_state = null
	. = ..()

/mob/living/exosuit/premade/cvrt/spawn_mech_equipment()
	..()
	install_system(new /obj/item/mech_equipment/mounted_system/taser/laser/rapid(src), HARDPOINT_LEFT_HAND)
	//install_system(new /obj/item/mech_equipment/mounted_system/taser/ion(src), HARDPOINT_RIGHT_HAND)
	//install_system(new /obj/item/mech_equipment/flash(src), HARDPOINT_LEFT_SHOULDER)
	//install_system(new /obj/item/mech_equipment/light(src), HARDPOINT_RIGHT_SHOULDER)

/obj/item/mech_component/chassis/cvrt
	name = "CV-R system"
	hide_pilot = TRUE
	has_hardpoints = list(
		HARDPOINT_BACK,
		HARDPOINT_LEFT_SHOULDER,
		HARDPOINT_RIGHT_SHOULDER,
		HARDPOINT_LEFT_HAND,
		HARDPOINT_RIGHT_HAND,
		HARDPOINT_HEAD
		)
	diagnostics = /obj/item/robot_parts/robot_component/diagnosis_unit
	air_supply = /obj/machinery/portable_atmospherics/canister/oxygen

/obj/item/mech_component/chassis/cvrt/prebuild()
	. = ..()
	m_armour = new /obj/item/robot_parts/robot_component/armour/exosuit(src)
	cell = new /obj/item/cell/infinite(src)

/obj/item/mech_component/chassis/cvrt/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 0),
			"[SOUTH]" = list("x" = 8,  "y" = 0),
			"[EAST]"  = list("x" = 3,  "y" = 0),
			"[WEST]"  = list("x" = 13, "y" = 0)
		),
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 8,  "y" = 8),
			"[EAST]"  = list("x" = 10,  "y" = 8),
			"[WEST]"  = list("x" = 6, "y" = 8)
		),
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 8,  "y" = 8),
			"[EAST]"  = list("x" = 10,  "y" = 8),
			"[WEST]"  = list("x" = 6, "y" = 8)
		),
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 8,  "y" = 8),
			"[EAST]"  = list("x" = 10,  "y" = 8),
			"[WEST]"  = list("x" = 6, "y" = 8)
		)
	)
	. = ..()

/obj/item/mech_component/propulsion/cvrt
	name = "CV-R treads"
	mech_turn_sound = 'sound/machines/hiss.ogg'
	mech_step_sound = 'sound/machines/hiss.ogg'

//these three procs overriden to play different sounds
/*/mob/living/exosuit/cvrt/mechturn(direction)
	set_dir(direction)
	//playsound(src,'sound/machines/hiss.ogg',40,1)
	return 1

/mob/living/exosuit/cvrt/mechstep(direction)
	var/result = step(src,direction)
	if(result)
		playsound(src,'sound/machines/hiss.ogg',40,1)
	return result


/mob/living/exosuit/cvrt/mechsteprand()
	var/result = step_rand(src)
	if(result)
		playsound(src,'sound/machines/hiss.ogg',40,1)
	return result*/

/mob/living/exosuit/premade/cvrt/basic

/*/mob/living/exosuit/cvrt/basic/New() //we've got a gun and we take four passengers
	..()
	var/obj/item/mech_equipment/ME = new /obj/item/mech_equipment/weapon/ballistic/lmg
	ME.attach(src)
	ME = new /obj/item/mech_equipment/tool/passenger
	ME.attach(src)
	ME = new /obj/item/mech_equipment/tool/passenger
	ME.attach(src)
	ME = new /obj/item/mech_equipment/tool/passenger
	ME.attach(src)
	ME = new /obj/item/mech_equipment/tool/passenger
	ME.attach(src)*/

/obj/item/mech_equipment/mounted_system/taser/laser/rapid
	equipment_delay = 8
	name = "\improper CH-R \"Consecrator\" Burst laser"
	icon_state = "mech_lasercarbine"
	holding_type = /obj/item/gun/energy/lasercannon/mounted/mech/cvrt

/obj/item/gun/energy/lasercannon/mounted/mech/cvrt
	name = "\improper CH-R \"Consecrator\" Burst laser"
	icon_state = "mech_lasercarbine"
	use_external_power = TRUE
	burst = 3
	fire_sound = 'sound/weapons/Laser.ogg'

/mob/living/exosuit/premade/cvrt/upgraded
	name = "Upgraded Combat Vehicle"
	//deflect_chance = 20
	//damage_absorption = list("brute"=0.5,"fire"=1.1,"bullet"=0.65,"laser"=0.85,"energy"=0.9,"bomb"=0.8) //and move up to a durand

/mob/living/exosuit/premade/cvrt/upgraded/Initialize()
	if(!body)
		body = new/obj/item/mech_component/chassis/cvrt/advanced(src)
		body.icon_state = null
	. = ..()

/obj/item/mech_component/chassis/cvrt/advanced
	name = "advanced CV-R system"

/obj/item/mech_component/chassis/cvrt/advanced/prebuild()
	. = ..()
	m_armour = new /obj/item/robot_parts/robot_component/armour/exosuit/combat(src)

/*/mob/living/exosuit/premade/cvrt/upgraded/New()
	..()
	var/obj/item/mech_equipment/ME = new /obj/item/mech_equipment/mounted_system/taser/laser/rapid
	ME.attach(src)
	ME = new /obj/item/mech_equipment/tool/passenger
	ME.attach(src)
	ME = new /obj/item/mech_equipment/tool/passenger
	ME.attach(src)
	ME = new /obj/item/mech_equipment/tool/passenger
	ME.attach(src)
	ME = new /obj/item/mech_equipment/tool/passenger
	ME.attach(src)*/

/obj/decal/mecha_wreckage/cvrt
	name = "CVR wreckage"
	icon = 'icons/urist/vehicles/cvrt.dmi'
	bound_width = 64
	bound_height = 64
	icon_state = "cvrt-broken"

//ryclies

/mob/living/exosuit/premade/cvrt/ryclies
	icon_state = "rcvrt"
	//initial_icon = "rcvrt"
	wreckage_path = /obj/decal/mecha_wreckage/rcvrt

/obj/decal/mecha_wreckage/rcvrt
	name = "CVR wreckage"
	icon = 'icons/urist/vehicles/cvrt.dmi'
	bound_width = 64
	bound_height = 64
	icon_state = "rcvrt-broken"
