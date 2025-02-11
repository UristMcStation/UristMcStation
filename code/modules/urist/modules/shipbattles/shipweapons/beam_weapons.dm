//beams

/obj/machinery/shipweapons/beam
	icon = 'icons/urist/structures&machinery/64x64machinery.dmi'
	fire_sound = 'sound/weapons/marauder.ogg'

/obj/machinery/shipweapons/beam/lightlaser //lasers are pretty good against shields, relatively weak against hulls
	name = "light laser cannon"
	shield_damage = 220 //14.66 dps
	hull_damage = 100 //6.67 dps
	icon_state = "lasercannon"
	idle_power_usage = 10
	active_power_usage = 5000
	component_hit = 20
	rechargerate = 15 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/lightlaser
	fire_anim = 5


/obj/machinery/shipweapons/beam/rapidlightlaser
	name = "rapid-fire light laser cannon"
	shield_damage = 500
	hull_damage = 200
	icon_state = "biglasercannon"
	idle_power_usage = 10
	active_power_usage = 6500
	component_hit = 30
	rechargerate = 23 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/lightlaser

/obj/machinery/shipweapons/beam/heavylaser
	name = "heavy laser cannon"
	shield_damage = 500 //comparable damage to the rapid lasercannon, faster firing //26.31 dps
	hull_damage = 250 //13.16 dps
	icon_state = "biglasercannon" //needs a better sprite
	idle_power_usage = 10
	active_power_usage = 10000
	component_hit = 20
	rechargerate = 19 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/heavylaser

/obj/machinery/shipweapons/beam/lightpulse //pulse is good against hull, weak against shields
	name = "light pulse cannon"
	shield_damage = 100
	hull_damage = 300 //18.75 dps
	icon_state = "pulsecannon"
	idle_power_usage = 10
	active_power_usage = 7000
	component_hit = 20
	rechargerate = 16 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/pulse/light

/obj/machinery/shipweapons/beam/heavypulse
	name = "heavy pulse cannon"
	shield_damage = 200
	hull_damage = 600 //27.27 dps
	icon_state = "bigpulsecannon"
	idle_power_usage = 10
	active_power_usage = 16000
	component_hit = 20
	rechargerate = 22 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/pulse/heavy

/obj/machinery/shipweapons/beam/ion //no hull damage, big shield damage
	name = "ion cannon"
	icon_state = "ioncannon"
	shield_damage = 400 //28.57 dps
	hull_damage = 0
	active_power_usage = 8000
	component_hit = 35
	rechargerate = 14 SECONDS
	projectile_type = /obj/item/projectile/ion/ship
	var/offline_delay = 30 SECONDS

/obj/machinery/shipweapons/beam/ion/HitComponents(targetship)
	var/mob/living/simple_animal/hostile/overmapship/OM = targetship

//	for(var/datum/shipcomponents/SC in OM.components)
//		health -= 1

	var/datum/shipcomponents/targetcomponent = pick(OM.components)
	if(!targetcomponent.broken)
		targetcomponent.broken = TRUE
		spawn(offline_delay)
			targetcomponent.broken = FALSE

/obj/machinery/shipweapons/beam/ion/heavy
	name = "heavy ion cannon"
	icon_state = "bigioncannon"
	idle_power_usage = 10
	active_power_usage = 16000
	shield_damage = 700 //31.82 dps
	component_hit = 50
	rechargerate = 22 SECONDS
	projectile_type = /obj/item/projectile/ion/ship/heavy
	offline_delay = 50 SECONDS
