/singleton/cooking_recipe/fishburger2
	appliance = COOKING_APPLIANCE_SKILLET | COOKING_APPLIANCE_MICROWAVE | COOKING_APPLIANCE_GRILL
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/fishmeat
	)
	result_path = /obj/item/reagent_containers/food/snacks/fishburger

/singleton/cooking_recipe/fishandchips2
	appliance = COOKING_APPLIANCE_SKILLET | COOKING_APPLIANCE_MICROWAVE | COOKING_APPLIANCE_GRILL
	required_items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/fishmeat,
	)
	result_path = /obj/item/reagent_containers/food/snacks/fishandchips

/singleton/cooking_recipe/fishfingers2
	appliance = COOKING_APPLIANCE_SKILLET | COOKING_APPLIANCE_MICROWAVE | COOKING_APPLIANCE_GRILL
	required_reagents = list(/datum/reagent/nutriment/flour = 10)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/fishmeat,
	)
	result_path = /obj/item/reagent_containers/food/snacks/fishfingers
