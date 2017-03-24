/obj/item/weapon/fishingrod
	item_icons = DEF_URIST_INHANDS
	name = "fishing rod"
	desc = "A standard fishing rod. It's good for fishing. You fish with it, dumbass."
	icon = 'icons/urist/items/tools.dmi'
	icon_state = "fishingrod"
	item_state = "fishingrod"
	force = 5
	throwforce = 3
	attack_verb = list("hit", "bashed", "hooked")
	w_class = 4
	var/fishingpower = 1

/obj/item/weapon/fishingrod/improvised
	name = "improvised fishing rod"
	desc = "An improvised fishing rod made out of a wooden shaft and some cable. It's alright for fishing, probably. You can try to fish with it, dumbass."
	icon_state = "impfishingrod"
	fishingpower = 1.25 //maybe make this longer, I dunno

/obj/item/fish
	name = "fish"
	desc = "It's a dead freshly caught fish. Use a knife or something to fillet it."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "fish1"
	force = 5
	w_class = 2 //pocket fish!
	throwforce = 5

/obj/item/fish/New()
	..()
	if(prob(50))
		icon_state = "fish2"

/obj/item/fish/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/material/kitchen/utensil/knife))
		user << "<span class='notice'>You chop up the fish into wonderful fish fillet.</span>"
		new /obj/item/weapon/reagent_containers/food/snacks/fishmeat(user.loc)
		qdel(src)

/obj/item/weapon/reagent_containers/food/snacks/fishmeat
	name = "fish fillet"
	desc = "A fillet of fish meat."
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"
	center_of_mass = "x=17;y=13"

/obj/item/weapon/reagent_containers/food/snacks/fishmeat/New()
	..()
	reagents.add_reagent("protein", 3)
	src.bitesize = 6

/datum/recipe/fishburger2
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/weapon/reagent_containers/food/snacks/fishmeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/fishburger

/datum/recipe/fishandchips2
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/fries,
		/obj/item/weapon/reagent_containers/food/snacks/fishmeat,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/fishandchips

/datum/recipe/fishfingers2
	reagents = list("flour" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/fishmeat,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/fishfingers