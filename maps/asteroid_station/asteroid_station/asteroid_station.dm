/obj/random/mining_gear
	name = "Random Mining Gear"
	icon = 'icons/mecha/mecha_equipment.dmi'
	icon_state = "mecha_diamond_drill"
	spawn_nothing_percentage = 10

obj/random/mining_gear/spawn_choices()
	return list(/obj/item/weapon/pickaxe/drill = 25,
				/obj/item/weapon/pickaxe/diamonddrill = 15,
				/obj/item/weapon/pickaxe/old = 35,
				/obj/item/device/flashlight/upgraded = 5,
				/obj/item/device/flashlight = 10
				)

/obj/random/mecha_wreakage
	name = "Random Mecha Wreckage"
	icon = 'icons/mecha/mecha.dmi'
	icon_state = "ripley-broken"
	spawn_nothing_percentage = 20

/obj/random/mecha_wreakage/spawn_choices()
	return list(/obj/effect/decal/mecha_wreckage/ripley = 35,
				/obj/effect/decal/mecha_wreckage/gygax = 25,
				/obj/effect/decal/mecha_wreckage/odysseus = 25,
				/obj/effect/decal/mecha_wreckage/durand = 15
				)

/turf/simulated/floor/asteroid/oxygen
	initial_gas = list("oxygen" = MOLES_CELLSTANDARD)
	temperature = T20C

/turf/simulated/floor/planet/update_air_properties()
	. = ..()