//beams

/obj/machinery/shipweapons/beam
	icon = 'icons/urist/structures&machinery/64x64machinery.dmi'

/obj/machinery/shipweapons/beam/lightlaser
	name = "light laser cannon"
	shielddamage = 200
	hulldamage = 100
	icon_state = "lasercannon"
	idle_power_usage = 10
	active_power_usage = 3000
	component_hit = 20
	rechargerate = 15 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/lightlaser
	fire_anim = 5
	fire_sound = 'sound/weapons/marauder.ogg'

/obj/machinery/shipweapons/beam/ion
	name = "ion cannon"
	icon_state = "ioncannon"
	shielddamage = 400
	active_power_usage = 3500
	component_hit = 35
	rechargerate = 12 SECONDS
	fire_sound = 'sound/weapons/marauder.ogg'
	projectile_type = /obj/item/projectile/ion/ship

/obj/machinery/shipweapons/beam/ion/HitComponents(var/targetship)
	var/mob/living/simple_animal/hostile/overmapship/OM = targetship

//	for(var/datum/shipcomponents/SC in OM.components)
//		health -= 1

	var/datum/shipcomponents/targetcomponent = pick(OM.components)
	if(!targetcomponent.broken)
		targetcomponent.broken = TRUE
		spawn(45 SECONDS)
			targetcomponent.broken = FALSE