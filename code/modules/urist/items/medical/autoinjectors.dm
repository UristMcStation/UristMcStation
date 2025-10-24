/obj/item/reagent_containers/hypospray/autoinjector/rad
	name = "autoinjector (anti-radiation)"
	desc = "An autoinjector with a small concotion of drugs designed to treat radiation poisoning." //A label says: <b>Warning!</b> this product contains arithrazine."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "radinjector"
	item_state = "autoinjector"

/obj/item/reagent_containers/hypospray/autoinjector/rad/New()
	..()
	reagents.remove_reagent(/datum/reagent/inaprovaline, 5)
	reagents.add_reagent(/datum/reagent/hyronalin, 3)
	reagents.add_reagent(/datum/reagent/dylovene, 2)
	update_icon()
	return

/obj/item/reagent_containers/hypospray/autoinjector/adv
	name = "advanced autoinjector (restoration)"
	desc = "An advanced autoinjector, containing a number of helpful chemicals."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "radinjector"
	item_state = "autoinjector"
	volume = 20
	amount_per_transfer_from_this = 20

/obj/item/reagent_containers/hypospray/autoinjector/adv/New()
	..()
	reagents.add_reagent(/datum/reagent/tricordrazine, 5)
	reagents.add_reagent(/datum/reagent/tramadol, 5)
	reagents.add_reagent(/datum/reagent/dexalinp, 5)
	update_icon()
	return

/obj/item/reagent_containers/hypospray/autoinjector/admin
	name = "advanced autoinjector (admin)"
	desc = "An advanced autoinjector, containing a number of helpful chemicals... it's labelled... admin?"
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "radinjector"
	item_state = "autoinjector"
	volume = 20
	amount_per_transfer_from_this = 20

/obj/item/reagent_containers/hypospray/autoinjector/admin/New()
	..()
	reagents.add_reagent(/datum/reagent/adminordrazine, 5)
	reagents.add_reagent(/datum/reagent/tramadol, 5)
	reagents.add_reagent(/datum/reagent/dexalinp, 5)
	update_icon()
	return
