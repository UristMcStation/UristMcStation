//unfuck this

/obj/item/reagent_containers/food/snacks/fishmeat
	name = "fish fillet"
	desc = "A fillet of fish meat."
	icon_state = "fishfillet"
	filling_color = "#ffdefe"
	center_of_mass = "x=17;y=13"

/obj/item/reagent_containers/food/snacks/fishmeat/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 3)
	src.bitesize = 6

/datum/microwave_recipe/fishburger2
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/fishmeat
	)
	result_path = /obj/item/reagent_containers/food/snacks/fishburger

/datum/microwave_recipe/fishandchips2
	required_items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/fishmeat,
	)
	result_path = /obj/item/reagent_containers/food/snacks/fishandchips

/datum/microwave_recipe/fishfingers2
	required_reagents = list(/datum/reagent/nutriment/flour = 10)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/fishmeat,
	)
	result_path = /obj/item/reagent_containers/food/snacks/fishfingers
