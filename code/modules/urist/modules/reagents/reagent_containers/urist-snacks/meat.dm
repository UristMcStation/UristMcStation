// Meat-related food goes here
// It's a shame virology is fully gutted, otherwise we could make raw meat a lot more risky to eat, i ain't redoin' virology in my lifetime - y

// Raw Meat - For Butchery

// Panther
/obj/item/reagent_containers/food/snacks/meat/panther
	name = "panther meat"
	desc = "Fresh meat harvested from a panther, stringy and gamey."

// Cougar
/obj/item/reagent_containers/food/snacks/meat/cougar
	name = "cougar meat"
	desc = "Fresh meat harvested from a cougar, stringy and gamey."

// Wolf
/obj/item/reagent_containers/food/snacks/meat/wolf
	name = "wolf meat"
	desc = "Fresh meat harvested from a wolf, not the safest thing to eat in a survival situation."

// Monkey
/obj/item/reagent_containers/food/snacks/meat/monkey
	name = "monkey meat"
	desc = "Fresh meat harvested from a monkey, does not contain bananas."

// Deer
/obj/item/reagent_containers/food/snacks/meat/venison
	name = "slab of venison"
	desc = "Fresh venison harvested from a deer, makes a great steak if you don't mind the taste of game."

// Snake
/obj/item/reagent_containers/food/snacks/meat/snake
	name = "snake meat"
	desc = "Known for tasting like chicken."

// Bear
/obj/item/reagent_containers/food/snacks/meat/bear
	name = "slab of bear meat"
	desc = "A fresh slab of bear meat, it is not very safe to eat in most situations."

// Fox
/obj/item/reagent_containers/food/snacks/meat/fox
	name = "fox meat"
	desc = "A fresh slab of fox meat, gamey."

// Bat
/obj/item/reagent_containers/food/snacks/meat/bat
	name = "bat meat"
	desc = "Tastes like chicken."

// Turtle
/obj/item/reagent_containers/food/snacks/meat/turtle
	name = "turtle meat"
	desc = "A fresh slab of turtle meat, you monster."
// Goose
/obj/item/reagent_containers/food/snacks/meat/goose
	name = "slab of goose poultry"
	desc = "A fresh cut of goose, no longer honking at you."

// Mutated Rat
/obj/item/reagent_containers/food/snacks/meat/rat
	name = "rat meat"
	desc = "A fresh slab of rat meat, are you sure you want to eat this?"

// Mutated Rat - Plague
/obj/item/reagent_containers/food/snacks/meat/rat/plague
	name = "plague rat meat"
	desc = "A 'fresh' slab of rat meat, it looks covered in disgusting lesions. You REALLY don't want to eat this, right?"

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
