//trash
/obj/item/trash/urist
	icon = 'icons/urist/items/misc.dmi'
	w_class = 2.0
	desc = "This is rubbish."

/obj/item/trash/urist/blamco
	name = "blamCo mac & cheese"
	icon_state= "blamco"

/obj/item/trash/urist/bubblegum
	name = "bubblegum"
	icon_state= "bubblegum"

/obj/item/trash/urist/cram
	name = "cram"
	icon_state= "cram"

/obj/item/trash/urist/dapples
	name = "dandy boy apples"
	icon_state= "dapples"

/obj/item/trash/urist/fancycakes
	name = "fancy lads snack cakes"
	icon_state= "fancycakes"

/obj/item/trash/urist/instamash
	name = "instamash"
	icon_state= "instamash"

//food
/obj/item/reagent_containers/food/snacks/urist
	name = "snack"
	desc = "yummy"
	icon = 'icons/urist/kitchen.dmi'
	icon_state = null

/obj/item/reagent_containers/food/snacks/urist/blamco
	name = "blamCo mac & cheese"
	desc = "BlamCo brings you, Mac & Cheese!"
	icon_state = "blamco"
	trash = /obj/item/trash/urist/blamco
	filling_color = "#ffe98c"

/obj/item/reagent_containers/food/snacks/urist/blamco/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment, 3)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/urist/bubblegum
	name = "bubblegum."
	desc = "Bubblegum for chewing, what more to ask for!"
	icon_state = "bubblegum"
	trash = /obj/item/trash/urist/bubblegum
	filling_color = "#ffe98c"

/obj/item/reagent_containers/food/snacks/urist/bubblegum/New()
	..()
	reagents.add_reagent(/datum/reagent/sugar, 2)

/obj/item/reagent_containers/food/snacks/urist/cram
	name = "cram"
	desc = "Cram! You know, food, we think."
	icon_state = "cram"
	trash = /obj/item/trash/urist/cram
	filling_color = "#ffbec7"

/obj/item/reagent_containers/food/snacks/urist/cram/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment, 3)
	reagents.add_reagent(/datum/reagent/sugar, 2)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/urist/dapples
	name = "dandy boy apples"
	desc = "An apple flavored treat for anyone!"
	icon_state = "dapples"
	trash = /obj/item/trash/urist/dapples
	filling_color = "#ffbec7"

/obj/item/reagent_containers/food/snacks/urist/dapples/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment, 1)
	reagents.add_reagent(/datum/reagent/sugar, 3)

/obj/item/reagent_containers/food/snacks/urist/fancycakes
	name = "fancy lads snack cakes"
	desc = "A snack cake for the most fancy of people"
	icon_state = "fancycakes"
	trash = /obj/item/trash/urist/fancycakes
	filling_color = "#f3f6ff"

/obj/item/reagent_containers/food/snacks/urist/fancycakes/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment, 2)
	reagents.add_reagent(/datum/reagent/sugar, 3)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/urist/instamash
	name = "instaMash"
	desc = "InstaMash, the best mash around!"
	icon_state = "instamash"
	trash = /obj/item/trash/urist/instamash
	filling_color = "#f94a32"

/obj/item/reagent_containers/food/snacks/urist/instamash/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment, 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/urist/onigiri
	name = "Umeboshi Onigiri"
	desc = "A riceball made of white rice, wrapped in seaweed. This one appears to be filled with Umeboshi."
	icon = 'icons/urist/items/uristfood.dmi'
	icon_state = "onigiri"
	trash = /obj/item/trash/onigiri
	filling_color = "#eddd00"

/obj/item/reagent_containers/food/snacks/urist/onigiri/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment, 3)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/urist/onigiri2
	name = "Katsoubushi Onigiri"
	desc = "A riceball made of white rice, wrapped in seaweed. This one appears to be filled with Katsuobushi."
	icon = 'icons/urist/items/uristfood.dmi'
	icon_state = "onigiri2"
	trash = /obj/item/trash/onigiri
	filling_color = "#eddd00"

/obj/item/reagent_containers/food/snacks/urist/onigiri2/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment, 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/urist/onigiri4
	name = "Cat-Shaped Onigiri"
	desc = "A riceball made of white rice, wrapped in seaweed. This one appears to shaped into a cute face!"
	icon = 'icons/urist/items/uristfood.dmi'
	icon_state = "onigiri4"
	trash = /obj/item/trash/onigiri
	filling_color = "#eddd00"

/obj/item/reagent_containers/food/snacks/urist/onigiri4/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment, 3)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/urist/yakidango
	name = "Yakidango Skewers"
	desc = "A skewer of Dangos. Made often of rice flour, they look delicious."
	icon = 'icons/urist/items/uristfood.dmi'
	icon_state = "yakidango-s"
	trash = /obj/item/trash/skewers
	filling_color = "#7a3d11"

/obj/item/reagent_containers/food/snacks/urist/yakidango/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment, 5)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/urist/ramenmiso
	name = "Miso Ramen"
	desc = "A small recycable bowl containing piping hot Ramen. The label reads that it is the Miso flavour variant."
	icon = 'icons/urist/items/uristfood.dmi'
	icon_state = "ramen-o"
	trash = /obj/item/trash/ramenbowl
	filling_color = "#7a3d11"

/obj/item/reagent_containers/food/snacks/urist/ramenmiso/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment, 5)
	bitesize = 3

// Mingus Dew Reagent
/datum/reagent/drink/mingusdew
	name = "Mingus Dew"
	description = "And I say to myself, I need exact change."
	taste_description = "sweet citris"
	reagent_state = LIQUID
	color = "#15ea6f"
	nutrition = 1

	glass_name = "Mingus Dew"
	glass_desc = "Give me my damn Mingus Dew!"

// Mango Reinhardt Reagent
/datum/reagent/drink/mangorein
	name = "Mango Reinhardt"
	description = "Ah, Mango Reinhardt the thinking man's pop."
	taste_description = "mango"
	reagent_state = LIQUID
	color = "#ffc445"
	nutrition = 1

	glass_name = "Mango Reinhardt"
	glass_desc = "Ah, Mango Reinhadrt the thinking man's pop"

// Starman Sparkle Reagent
/datum/reagent/drink/starmansparkle
	name = "Starman Sparkle"
	description = "A once famous drink in some of the outer rimworlds."
	taste_description = "out of this world"
	reagent_state = LIQUID
	color = "#171717"

	glass_name = "Starman Sparkle"
	glass_desc = "It slowly spins with beautiful sparkly glitter."
	glass_special = list(DRINK_FIZZ)

// Red Kola Reagent
/datum/reagent/drink/redkola
	name = "Red Kola"
	description = "A cheap knock-off of a distinctive cola brand."
	taste_description = "cheap cola"
	reagent_state = LIQUID
	color = "#705353"

	glass_name = "Red Kola"
	glass_desc = "Sparkling, tasty and refreshing. A great companion on any adventure."
	glass_special = list(DRINK_FIZZ)

// Aloha Coe Reagent
/datum/reagent/drink/aloha
	name = "Aloha Coe"
	description = "A tropical coconut-y mix, reminds you of a nice beach."
	taste_description = "coconut"
	reagent_state = LIQUID
	color = "#f7f4f4"

	glass_name = "Aloha Coe"
	glass_desc = "You wish you were on shoreleave."

// Happy Brain Reagent
/datum/reagent/drink/happybrain
	name = "Happy Brain"
	description = "A tasty lime and banana mix."
	taste_description = "lime"
	reagent_state = LIQUID
	color = "#a5cfcf"

	glass_name = "Happy Brain"
	glass_desc = "I feel great, don't you?"

// Royal Mix Reagent
/datum/reagent/drink/royal
	name = "Royal Mix"
	description = "This looks pretty fancy."
	taste_description = "cranberries"
	reagent_state = LIQUID
	color = "#d34646"

	glass_name = "Royal Mix"
	glass_desc = "Royalty at an affordable price!"

// Juicebox of Testing, that's it.
/obj/item/reagent_containers/food/drinks/cans/juicebox
	name = "juicebox"
	desc = "A test juicebox, contact the admins if you see this, something has broken."
	icon = 'icons/urist/items/uristfood.dmi'
	icon_state = "juicebox-test"
	var/trash = /obj/item/trash/urist/mingus_trash

// Add the noise and the straw overlay to show it's open.
/obj/item/reagent_containers/food/drinks/cans/juicebox/open(mob/user)
	playsound(loc,'sound/effects/bonebreak1.ogg', rand(10,50), 1)
	to_chat(user, "<span class='notice'>You take the straw out of \the [src], piercing the film!</span>")
	overlays += image('icons/urist/items/uristfood.dmi', "straw_overlay")
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER

// Juicebox of Mingus Dew.
/obj/item/reagent_containers/food/drinks/cans/juicebox/mingusdew
	name = "\improper Mingus Dew"
	desc = "Give me my damn Mingus Dew!"
	icon = 'icons/urist/items/uristfood.dmi'
	icon_state = "mingus"
	trash = /obj/item/trash/urist/mingus_trash

/obj/item/reagent_containers/food/drinks/cans/juicebox/mingusdew/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/mingusdew, 30)

// Juicebox of Mango Reinhardt.
/obj/item/reagent_containers/food/drinks/cans/juicebox/mangoreinhardt
	name = "\improper Mango Reinhardt"
	desc = "The thinking man's pop!"
	icon = 'icons/urist/items/uristfood.dmi'
	icon_state = "mango"
	trash = /obj/item/trash/urist/mango_trash

/obj/item/reagent_containers/food/drinks/cans/juicebox/mangoreinhardt/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/mangorein, 30)

// Juicebox of Starman Sparkle.
/obj/item/reagent_containers/food/drinks/cans/juicebox/starman
	name = "\improper Starman Sparkle"
	desc = "A popular drink near some of the outer rimworlds, known for it's unique taste."
	icon = 'icons/urist/items/uristfood.dmi'
	icon_state = "starman"
	trash = /obj/item/trash/urist/starman_trash

/obj/item/reagent_containers/food/drinks/cans/juicebox/starman/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/starmansparkle, 30)

// Juicebox of Royal Mix
/obj/item/reagent_containers/food/drinks/cans/juicebox/royal
	name = "\improper Royal Mix"
	desc = "A mixture of cranberries and some other strange spices in a Juicebox."
	icon = 'icons/urist/items/uristfood.dmi'
	icon_state = "royal"
	trash = /obj/item/trash/urist/royal_trash

/obj/item/reagent_containers/food/drinks/cans/juicebox/royal/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/royal, 30)

// Juicebox of Barry's Red Kola
/obj/item/reagent_containers/food/drinks/cans/juicebox/redkola
	name = "\improper Red Kola"
	desc = "Sparkling, tasty and refreshing. A great companion on any adventure."
	icon = 'icons/urist/items/uristfood.dmi'
	icon_state = "redkola"
	trash = /obj/item/trash/urist/redkola_trash

/obj/item/reagent_containers/food/drinks/cans/juicebox/redkola/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/redkola, 30)

// Juicebox of Aloha Coe
/obj/item/reagent_containers/food/drinks/cans/juicebox/aloha
	name = "\improper Aloha Coe"
	desc = "A juicebox full of delicious tropical coconut flavors."
	icon = 'icons/urist/items/uristfood.dmi'
	icon_state = "aloha"
	trash = /obj/item/trash/urist/aloha_trash

/obj/item/reagent_containers/food/drinks/cans/juicebox/aloha/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/aloha, 30)

// Juicebox of Happy Brain
/obj/item/reagent_containers/food/drinks/cans/juicebox/happybrain
	name = "\improper Happy Brain"
	desc = "I feel happy, don't you?"
	icon = 'icons/urist/items/uristfood.dmi'
	icon_state = "happybrain"
	trash = /obj/item/trash/urist/happybrain_trash

/obj/item/reagent_containers/food/drinks/cans/juicebox/happybrain/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/happybrain, 30)

// Juicebox Trash Shit.

// Trash Happy Brain Carton
/obj/item/trash/urist/happybrain_trash
	name = "empty happy brain carton"
	icon = 'icons/urist/items/uristtrash.dmi'
	icon_state= "happybrain_trash"

	// Trash Royal Mix Carton
/obj/item/trash/urist/royal_trash
	name = "empty royal mix carton"
	icon = 'icons/urist/items/uristtrash.dmi'
	icon_state= "royal_trash"

// Trash Mingus Dew Carton
/obj/item/trash/urist/mingus_trash
	name = "empty mingus dew carton"
	icon = 'icons/urist/items/uristtrash.dmi'
	icon_state= "mingus_trash"

// Trash Mango Reinhardt Carton
/obj/item/trash/urist/mango_trash
	name = "empty mango reinhardt carton"
	icon = 'icons/urist/items/uristtrash.dmi'
	icon_state= "mango_trash"

// Trash Starman Sparkle Carton
/obj/item/trash/urist/starman_trash
	name = "empty starman sparkle carton"
	icon = 'icons/urist/items/uristtrash.dmi'
	icon_state= "starman_trash"

// Trash Red Kola Carton
/obj/item/trash/urist/redkola_trash
	name = "empty red kola carton"
	icon = 'icons/urist/items/uristtrash.dmi'
	icon_state= "redkola_trash"

// Trash Aloha Coe Carton
/obj/item/trash/urist/aloha_trash
	name = "empty aloha coe carton"
	icon = 'icons/urist/items/uristtrash.dmi'
	icon_state= "aloha_trash"

//tesh food
/obj/item/reagent_containers/food/snacks/bird
	name = "\improper Chicken's Choice"
	desc = "Bird seed for Teshari and Livestock, or insane people."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "birdseed"
	filling_color = "#a66829"
	center_of_mass = "x=15;y=12"
	nutriment_desc = list("sunflower seeds" = 3, "bits of shell" = 3)
	nutriment_amt = 6
	bitesize = 3

//a bay food with no bay recipe - clown's tears
/datum/microwave_recipe/clownstears
	required_reagents = list(
		/datum/reagent/water = 10
	)
	required_items = list(
		/obj/item/clothing/shoes/clown_shoes = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/clownstears
