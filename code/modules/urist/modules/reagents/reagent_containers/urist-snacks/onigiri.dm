/obj/item/reagent_containers/food/snacks/urist/onigiri
	name = "Umeboshi Onigiri"
	desc = "A riceball made of white rice, wrapped in seaweed. This one appears to be filled with Umeboshi."
	icon = 'icons/urist/obj/food/food.dmi'
	icon_state = "onigiri"
	trash = /obj/item/trash/urist/onigiri
	filling_color = "#eddd00"

/obj/item/reagent_containers/food/snacks/urist/onigiri/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment, 3)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/urist/onigiri2
	name = "Katsoubushi Onigiri"
	desc = "A riceball made of white rice, wrapped in seaweed. This one appears to be filled with Katsuobushi."
	icon_state = "onigiri2"
	filling_color = "#eddd00"

/obj/item/reagent_containers/food/snacks/urist/onigiri2/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment, 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/urist/onigiri4
	name = "Cat-Shaped Onigiri"
	desc = "A riceball made of white rice, wrapped in seaweed. This one appears to shaped into a cute face!"
	icon_state = "onigiri4"
	filling_color = "#eddd00"

/obj/item/reagent_containers/food/snacks/urist/onigiri4/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment, 3)
	bitesize = 2
