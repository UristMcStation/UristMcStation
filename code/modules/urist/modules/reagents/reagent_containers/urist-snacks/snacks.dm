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

/obj/item/reagent_containers/food/snacks/urist/ramenmiso
	name = "Miso Ramen"
	desc = "A small recycable bowl containing piping hot Ramen. The label reads that it is the Miso flavour variant."
	icon = 'icons/urist/obj/food/food.dmi'
	icon_state = "ramen-o"
	trash = /obj/item/trash/urist/ramenbowl
	filling_color = "#7a3d11"

/obj/item/reagent_containers/food/snacks/urist/ramenmiso/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment, 5)
	bitesize = 3
