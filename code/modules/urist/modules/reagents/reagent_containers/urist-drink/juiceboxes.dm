// Juicebox of Testing, that's it.
/obj/item/reagent_containers/food/drinks/cans/juicebox
	name = "juicebox"
	desc = "A test juicebox, contact the admins if you see this, something has broken."
	icon = 'icons/urist/obj/food/juiceboxes.dmi'
	icon_state = "juicebox-test"
	var/trash = /obj/item/trash/urist/mingus_trash

// Add the noise and the straw overlay to show it's open.
/obj/item/reagent_containers/food/drinks/cans/juicebox/open(mob/user)
	playsound(loc,'sound/effects/bonebreak1.ogg', rand(10,50), 1)
	to_chat(user, "<span class='notice'>You take the straw out of \the [src], piercing the film!</span>")
	AddOverlays(image('icons/urist/obj/food/juiceboxes.dmi', "straw_overlay"))
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER

// Juicebox of Mingus Dew.
/obj/item/reagent_containers/food/drinks/cans/juicebox/mingusdew
	name = "\improper Mingus Dew"
	desc = "Give me my damn Mingus Dew!"
	icon_state = "mingus"
	trash = /obj/item/trash/urist/mingus_trash

/obj/item/reagent_containers/food/drinks/cans/juicebox/mingusdew/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/mingusdew, 30)

// Juicebox of Mango Reinhardt.
/obj/item/reagent_containers/food/drinks/cans/juicebox/mangoreinhardt
	name = "\improper Mango Reinhardt"
	desc = "The thinking man's pop!"
	icon_state = "mango"
	trash = /obj/item/trash/urist/mango_trash

/obj/item/reagent_containers/food/drinks/cans/juicebox/mangoreinhardt/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/mangorein, 30)

// Juicebox of Starman Sparkle.
/obj/item/reagent_containers/food/drinks/cans/juicebox/starman
	name = "\improper Starman Sparkle"
	desc = "A popular drink near some of the outer rimworlds, known for it's unique taste."
	icon_state = "starman"
	trash = /obj/item/trash/urist/starman_trash

/obj/item/reagent_containers/food/drinks/cans/juicebox/starman/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/starmansparkle, 30)

// Juicebox of Royal Mix
/obj/item/reagent_containers/food/drinks/cans/juicebox/royal
	name = "\improper Royal Mix"
	desc = "A mixture of cranberries and some other strange spices in a Juicebox."
	icon_state = "royal"
	trash = /obj/item/trash/urist/royal_trash

/obj/item/reagent_containers/food/drinks/cans/juicebox/royal/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/royal, 30)

// Juicebox of Barry's Red Kola
/obj/item/reagent_containers/food/drinks/cans/juicebox/redkola
	name = "\improper Red Kola"
	desc = "Sparkling, tasty and refreshing. A great companion on any adventure."
	icon_state = "redkola"
	trash = /obj/item/trash/urist/redkola_trash

/obj/item/reagent_containers/food/drinks/cans/juicebox/redkola/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/redkola, 30)

// Juicebox of Aloha Coe
/obj/item/reagent_containers/food/drinks/cans/juicebox/aloha
	name = "\improper Aloha Coe"
	desc = "A juicebox full of delicious tropical coconut flavors."
	icon_state = "aloha"
	trash = /obj/item/trash/urist/aloha_trash

/obj/item/reagent_containers/food/drinks/cans/juicebox/aloha/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/aloha, 30)

// Juicebox of Happy Brain
/obj/item/reagent_containers/food/drinks/cans/juicebox/happybrain
	name = "\improper Happy Brain"
	desc = "I feel happy, don't you?"
	icon_state = "happybrain"
	trash = /obj/item/trash/urist/happybrain_trash

/obj/item/reagent_containers/food/drinks/cans/juicebox/happybrain/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/happybrain, 30)
