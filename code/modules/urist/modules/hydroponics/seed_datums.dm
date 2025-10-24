// Urist-specific seeds

/datum/seed/cotton
	name = "cotton"
	seed_name = "cotton"
	display_name = "cotton plant"
	chems = list(/datum/reagent/cottonfiber = list(6,1))

/datum/seed/cotton/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,8)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"cotton")
	set_trait(TRAIT_PRODUCT_COLOUR,"#f0f0f0")
	set_trait(TRAIT_PLANT_ICON,"bush2")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/obj/item/seeds/cotton
	seed_type = "cotton"

/obj/item/loom/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W, /obj/item/reagent_containers/food/snacks/grown))
		var/obj/item/reagent_containers/food/snacks/grown/plant = W
		if(plant.seed?.chems)
			if(!isnull(plant.seed.chems[/datum/reagent/cottonfiber]))
				user.visible_message(SPAN_NOTICE("\The [user] weaves \the [plant] into cotton cloth"), SPAN_NOTICE("You weave \the [plant] into cotton cloth"))
				new /obj/item/stack/material/cloth(user.loc)
				qdel(plant)
				return
	..()

/datum/seed/maneater
	name = "maneater"
	seed_name = "maneater"
	seed_noun = SEED_NOUN_PITS
	display_name = "bulbous pod"
	can_self_harvest = TRUE
	product_type = /mob/living/simple_animal/hostile/man_eater

/datum/seed/maneater/New()
	..()
	set_trait(TRAIT_IMMUTABLE,1)
	set_trait(TRAIT_ENDURANCE,10)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_YIELD,1)
	set_trait(TRAIT_PRODUCT_COLOUR,"#40641a")
	set_trait(TRAIT_PLANT_COLOUR,"#579712")
	set_trait(TRAIT_PLANT_ICON,"alien4")
	set_trait(TRAIT_HARVEST_REPEAT,1)
