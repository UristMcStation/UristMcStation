//beams

/obj/machinery/shipweapons/beam
	icon = 'icons/urist/structures&machinery/64x64machinery.dmi'
	fire_sound = 'sound/weapons/marauder.ogg'

/obj/machinery/shipweapons/beam/lightlaser
	name = "light laser cannon"
	shielddamage = 200
	hulldamage = 100
	icon_state = "lasercannon"
	idle_power_usage = 10
	active_power_usage = 4000
	component_hit = 20
	rechargerate = 15 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/lightlaser
	fire_anim = 5


/obj/machinery/shipweapons/beam/rapidlightlaser
	name = "rapid-fire light laser cannon"
	shielddamage = 500
	hulldamage = 200
	icon_state = "biglasercannon"
	idle_power_usage = 10
	active_power_usage = 6500
	component_hit = 30
	rechargerate = 23 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/lightlaser

/obj/machinery/shipweapons/beam/heavylaser
	name = "heavy laser cannon"
	shielddamage = 500 //comparable damage to the dual lasercannon, faster firing
	hulldamage = 250
	icon_state = "biglasercannon" //needs a better sprite
	idle_power_usage = 10
	active_power_usage = 8000
	component_hit = 20
	rechargerate = 19 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/heavylaser

/obj/machinery/shipweapons/beam/lightpulse //pulse is good against hull, weak against shields
	name = "light pulse cannon"
	shielddamage = 100
	hulldamage = 300
	icon_state = "pulsecannon"
	idle_power_usage = 10
	active_power_usage = 7000
	component_hit = 20
	rechargerate = 16 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/pulse/light

/obj/machinery/shipweapons/beam/heavypulse
	name = "heavy pulse cannon"
	shielddamage = 150
	hulldamage = 600
	icon_state = "bigpulsecannon"
	idle_power_usage = 10
	active_power_usage = 14000
	component_hit = 20
	rechargerate = 22 SECONDS
	projectile_type = /obj/item/projectile/beam/ship/pulse/heavy

/obj/machinery/shipweapons/beam/ion
	name = "ion cannon"
	icon_state = "ioncannon"
	shielddamage = 400
	hulldamage = 0
	active_power_usage = 8000
	component_hit = 35
	rechargerate = 13 SECONDS
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