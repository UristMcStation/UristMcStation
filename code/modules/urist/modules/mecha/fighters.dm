/mob/living/exosuit/premade/hoverpod/fighter
	health_max = 300
//	bound_width = 64
//	bound_height = 64

/*/mob/living/exosuit/premade/hoverpod/fighter/add_cell(obj/item/cell/infinite/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new(src)
	cell.charge = INFINITY
	cell.maxcharge = INFINITY*/

/mob/living/exosuit/premade/hoverpod/fighter/Initialize()
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/combat(src)
		legs.color = COLOR_GUNMETAL
		legs.icon_state = null
	if(!head)
		head = new /obj/item/mech_component/sensors/combat(src)
		head.color = COLOR_GUNMETAL
		head.icon_state = null
	if(!body)
		body = new/obj/item/mech_component/chassis/hoverpod/fighter(src)
		body.color = COLOR_GUNMETAL
		body.icon_state = null

	. = ..()

/mob/living/exosuit/premade/hoverpod/fighter/spawn_mech_equipment()
	..()
	install_system(new /obj/item/mech_equipment/mounted_system/taser/laser/rapid/alien(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mech_equipment/mounted_system/ballistic/missile_rack/explosive(src), HARDPOINT_RIGHT_HAND)
	install_system(new /obj/item/mech_equipment/mounted_system/ballistic/missile_rack/explosive(src), HARDPOINT_LEFT_SHOULDER)
	install_system(new /obj/item/mech_equipment/ionjets/lactera(src), HARDPOINT_HEAD)
	install_system(new /obj/item/mech_equipment/light(src), HARDPOINT_RIGHT_SHOULDER)
	install_system(new /obj/item/mech_equipment/shields/lactera(src), HARDPOINT_BACK)

/obj/item/mech_equipment/shields/lactera
	name = "lactera shields"
	desc = "An energy deflector system designed to stop any projectile before it has a chance to become a threat."

/obj/item/mech_equipment/ionjets/lactera
	restricted_hardpoints = null

/obj/item/mech_component/chassis/hoverpod/fighter
	name = "hoverpod systems"
	hide_pilot = TRUE
	has_hardpoints = list(
		HARDPOINT_BACK,
		HARDPOINT_LEFT_SHOULDER,
		HARDPOINT_RIGHT_SHOULDER,
		HARDPOINT_LEFT_HAND,
		HARDPOINT_RIGHT_HAND,
		HARDPOINT_HEAD
		)
	m_armour = /obj/item/robot_parts/robot_component/armour/exosuit
	cell = /obj/item/cell/infinite
	diagnostics = /obj/item/robot_parts/robot_component/diagnosis_unit

/mob/living/exosuit/premade/hoverpod/fighter/small/alien
	name = "alien fighter"
	icon = 'icons/urist/vehicles/uristvehicles.dmi'
	icon_state = "alien"
	//initial_icon = "alien"
	wreckage_path = /obj/decal/mecha_wreckage/smallfighter
	health_max = 320

/*/mob/living/exosuit/premade/hoverpod/fighter/small/alien/New()
	..()
	var/obj/item/mech_equipment/ME = new /obj/item/mech_equipment/mounted_system/taser/laser/rapid/alien
	ME.attach(src)
	ME = new /obj/item/mech_equipment/repair_droid
	ME.attach(src)
	ME = new /obj/item/mech_equipment/weapon/ballistic/missile_rack/explosive
	ME.attach(src)
	ME = new /obj/item/mech_equipment/weapon/ballistic/missile_rack/explosive
	ME.attach(src)*/

/obj/item/mech_equipment/mounted_system/taser/laser/rapid/alien
	name = "\improper Alien Burst laser"
	icon_state = "mecha_laser" // this seems to be missing now.
	//projectile = /obj/item/projectile/beam/scom/alien6
	holding_type = /obj/item/gun/energy/lactera/mounted/mech/alien

/obj/item/gun/energy/lactera/mounted/mech/alien
	name = "\improper Alien Burst laser"
	icon_state = "mecha_laser" // this seems to be missing now.
	use_external_power = TRUE
	burst = 4
	fire_sound = 'sound/weapons/Laser.ogg'
	projectile_type = /obj/item/projectile/beam/scom/alien6


/obj/decal/mecha_wreckage/smallfighter
	name = "fighter wreckage"
	icon = 'icons/urist/vehicles/uristvehicles.dmi'
	icon_state = "fighter-broken"

/mob/living/exosuit/premade/hoverpod/fighter/small/human
	health = 250
	name = "fighter"
	icon = 'icons/urist/vehicles/uristvehicles.dmi'
	icon_state = "fighter"
	//initial_icon = "fighter"
	wreckage_path = /obj/decal/mecha_wreckage/smallfighter

/mob/living/exosuit/premade/hoverpod/fighter/large
	bound_width = 64
	bound_height = 64

/obj/item/mech_component/propulsion/heavy/fighter
	name = "fighter engines"
	desc = "Take the fight to the skies."

/mob/living/exosuit/premade/hoverpod/fighter/large/human
	name = "large fighter"
	icon = 'icons/urist/vehicles/64x64vehicles.dmi'
	icon_state = "bigfighter"
	//initial_icon = "bigfighter"
	wreckage_path = /obj/decal/mecha_wreckage/bigfighter

/mob/living/exosuit/premade/hoverpod/fighter/large/human/Initialize()
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/heavy/fighter(src)
		legs.color = COLOR_GUNMETAL
		legs.icon_state = null
	. = ..()

/mob/living/exosuit/premade/hoverpod/fighter/large/human/spawn_mech_equipment()
	..()
	install_system(new /obj/item/mech_equipment/mounted_system/taser/laser/rapid/alien(src), HARDPOINT_HEAD)
	install_system(new /obj/item/mech_equipment/ionjets(src), HARDPOINT_LEFT_SHOULDER)
	install_system(new /obj/item/mech_equipment/mounted_system/ballistic/missile_rack/explosive/heavy(src), HARDPOINT_RIGHT_HAND)
	install_system(new /obj/item/mech_equipment/mounted_system/ballistic/missile_rack/explosive(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mech_equipment/light(src), HARDPOINT_RIGHT_SHOULDER)
	install_system(new /obj/item/mech_equipment/shields(src), HARDPOINT_BACK)

/obj/decal/mecha_wreckage/bigfighter
	name = "large fighter wreckage"
	icon = 'icons/urist/vehicles/64x64vehicles.dmi'
	icon_state = "bigfighter-broken"

/*/mob/living/exosuit/premade/hoverpod/fighter/large/human/New()
	..()
	var/obj/item/mech_equipment/ME = new /obj/item/mech_equipment/mounted_system/taser/laser/rapid
	ME.attach(src)
	ME = new /obj/item/mech_equipment/weapon/ballistic/missile_rack/explosive/heavy
	ME.attach(src)
	ME = new /obj/item/mech_equipment/weapon/ballistic/missile_rack/explosive
	ME.attach(src)
	ME = new /obj/item/mech_equipment/tool/passenger
	ME.attach(src)
	ME = new /obj/item/mech_equipment/tool/passenger
	ME.attach(src)

/mob/living/exosuit/premade/hoverpod/fighter/small/human/New()
	..()
	var/obj/item/mech_equipment/ME = new /obj/item/mech_equipment/mounted_system/taser/laser/rapid
	ME.attach(src)
	ME = new /obj/item/mech_equipment/repair_droid
	ME.attach(src)
	ME = new /obj/item/mech_equipment/weapon/ballistic/missile_rack/explosive
	ME.attach(src)
*/
/obj/item/mech_equipment/mounted_system/ballistic/missile_rack/explosive/heavy
	name = "\improper HSRM-4 heavy missile rack"
	icon_state = "mecha_missilerack"
	//projectile_type = /obj/item/missile/heavy
	//fire_sound = 'sound/effects/bang.ogg'
	//burst = 4
	//projectile_energy_cost = 1000
	//equip_cooldown = 60
	holding_type = /obj/item/gun/energy/missile/mounted/mech

/obj/item/gun/energy/missile/mounted/mech
	name = "\improper HSRM-4 heavy missile rack"
	use_external_power = TRUE
	self_recharge = TRUE
	charge_cost = 1000
	fire_delay = 15
	accuracy = 2
	projectile_type = /obj/item/missile/heavy
	burst = 4

/*/obj/item/mech_equipment/weapon/ballistic/missile_rack/explosive/heavy/Fire(atom/movable/AM, atom/target, turf/aimloc)
	var/obj/item/missile/heavy/M = AM
	M.primed = 1
	..()*/

/obj/item/gun/energy/missile //this is just so mechs can shoot missiles. it is energy for recharging purposes. very cursed
	name = "missile launcher"
	desc = "A big gun that shoots big booms."
	projectile_type = /obj/item/missile/heavy
	fire_sound = 'sound/effects/bang.ogg'
	burst = 4
	//projectile_energy_cost = 1000
	//equip_cooldown = 60

/obj/item/missile/heavy
	icon = 'icons/obj/weapons/grenade.dmi'
	icon_state = "missile"
	throwforce = 15

/obj/item/missile/heavy/throw_impact(atom/hit_atom)
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
	projectilesound = 'sound/weapons/laser.ogg'
	icon_living = "alien"
	icon_dead = "alien"
	projectiletype = /obj/item/projectile/beam/scom/alien6
	maxHealth = 250
	health = 250
	ai_holder = /datum/ai_holder/simple_animal/ranged/kiting
	see_in_dark = 10

/mob/living/simple_animal/hostile/scom/fighter/death()
	..()
	visible_message("<span class='danger'>The [src.name] explodes!</span>")
	explosion(src.loc, 0, 0, 2)
	new /obj/decal/mecha_wreckage/smallfighter(src.loc)
	qdel(src)
	return

/mob/living/exosuit/premade/hoverpod/fighter/large/alien
	name = "heavy alien drone"
	health = 800
	bound_height = 96
	bound_width = 96
	icon_state = "aliendrone"
	//initial_icon = "aliendrone"
	icon = 'icons/urist/vehicles/cvrt.dmi'

/*/mob/living/exosuit/premade/hoverpod/fighter/large/alien/New()
	..()
	var/obj/item/mech_equipment/ME = new /obj/item/mech_equipment/mounted_system/taser/laser/rapid/alien
	ME.attach(src)
	ME = new /obj/item/mech_equipment/weapon/ballistic/missile_rack/explosive/heavy
	ME.attach(src)
	ME = new /obj/item/mech_equipment/weapon/ballistic/missile_rack/explosive
	ME.attach(src)
	ME = new /obj/item/mech_equipment/weapon/ballistic/missile_rack/explosive/heavy
	ME.attach(src)
	ME = new /obj/item/mech_equipment/weapon/ballistic/missile_rack/explosive
	ME.attach(src)
*/

/mob/living/exosuit/premade/hoverpod/fighter/large/alien/Initialize()
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/heavy/fighter/heavy(src)
		legs.color = COLOR_GUNMETAL
		legs.icon_state = null

	.=..()

/mob/living/exosuit/premade/hoverpod/fighter/large/alien/spawn_mech_equipment()
	..()
	install_system(new /obj/item/mech_equipment/mounted_system/taser/laser/rapid/alien(src), HARDPOINT_HEAD)
	install_system(new /obj/item/mech_equipment/ionjets(src), HARDPOINT_LEFT_SHOULDER)
	install_system(new /obj/item/mech_equipment/mounted_system/ballistic/missile_rack/explosive/heavy(src), HARDPOINT_RIGHT_HAND)
	install_system(new /obj/item/mech_equipment/mounted_system/ballistic/missile_rack/explosive(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mech_equipment/light(src), HARDPOINT_RIGHT_SHOULDER)
	install_system(new /obj/item/mech_equipment/shields(src), HARDPOINT_BACK)

/obj/item/mech_component/propulsion/heavy/fighter/heavy
	move_delay = 8

/obj/item/mech_component/chassis/hoverpod/fighter/human
	name = "fighter systems"
	air_supply = /obj/machinery/portable_atmospherics/canister/oxygen
