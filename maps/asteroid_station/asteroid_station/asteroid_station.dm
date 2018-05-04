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

/obj/random/med_crate
	name = "Random Medical Crate"
	icon = 'icons/obj/storage.dmi'
	icon_state = "med_red"

/obj/random/med_crate/spawn_choices()
	return list(/obj/structure/closet/crate/med_crate/burn,
				/obj/structure/closet/crate/med_crate/oxyloss,
				/obj/structure/closet/crate/med_crate/toxin,
				/obj/structure/closet/crate/med_crate/trauma
				)

/turf/simulated/floor/asteroid/oxygen
	initial_gas = list("oxygen" = MOLES_CELLSTANDARD)
	temperature = T20C

/turf/simulated/floor/planet/update_air_properties()
	. = ..()

/obj/structure/closet/secure_closet/freezer/fridge/WillContain()
	return list(
		/obj/item/weapon/reagent_containers/food/drinks/milk = 6,
		/obj/item/weapon/reagent_containers/food/drinks/soymilk = 4,
		/obj/item/weapon/storage/fancy/egg_box = 4,
		/obj/item/weapon/reagent_containers/food/condiment/flour = 7,
		/obj/item/weapon/reagent_containers/food/condiment/sugar = 2,
		/obj/item/weapon/reagent_containers/food/condiment/salt = 1,
		/obj/item/weapon/reagent_containers/food/snacks/meat/beef = 8,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat/safe = 4
		)

/obj/structure/sign/double/solgovflag
	name = "Sol Central Government Flag"
	desc = "The flag of the Sol Central Government, a symbol of many things to many people."
	icon = 'maps/torch/icons/obj/solgov-decals.dmi'

/obj/structure/sign/double/solgovflag/left
	icon_state = "solgovflag-left"

/obj/structure/sign/double/solgovflag/right
	icon_state = "solgovflag-right"