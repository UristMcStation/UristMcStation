// Meat-related food goes here
// It's a shame virology is fully gutted, otherwise we could make raw meat a lot more risky to eat, i ain't redoin' virology in my lifetime - y

// Raw Meat - For Butchery

// Panther
/obj/item/reagent_containers/food/snacks/meat/panther
	name = "panther meat"
	desc = ""
	icon_state = ""

// Cougar
/obj/item/reagent_containers/food/snacks/meat/cougar

// Wolf
/obj/item/reagent_containers/food/snacks/meat/wolf

// Monkey
/obj/item/reagent_containers/food/snacks/meat/monkey

// Deer
/obj/item/reagent_containers/food/snacks/meat/venison

// Snake
/obj/item/reagent_containers/food/snacks/meat/snake

// Bear
/obj/item/reagent_containers/food/snacks/meat/bear

// Fox
/obj/item/reagent_containers/food/snacks/meat/fox

// Bat
/obj/item/reagent_containers/food/snacks/meat/bat

// Turtle
/obj/item/reagent_containers/food/snacks/meat/turtle

// Goose
/obj/item/reagent_containers/food/snacks/meat/goose

// Mutated Rat
/obj/item/reagent_containers/food/snacks/meat/rat

// Mutated Rat - Plague
/obj/item/reagent_containers/food/snacks/meat/rat/plague


// Offal - For Butchery


/obj/item/reagent_containers/food/snacks/urist/yakidango
	name = "Yakidango Skewers"
	desc = "A skewer of Dangos. Made often of rice flour, they look delicious."
	icon = 'icons/urist/obj/food/food.dmi'
	icon_state = "yakidango-s"
	trash = /obj/item/trash/urist/skewers
	filling_color = "#7a3d11"

/obj/item/reagent_containers/food/snacks/urist/yakidango/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment, 5)
	bitesize = 4
