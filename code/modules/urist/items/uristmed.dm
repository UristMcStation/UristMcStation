/*										*****New space to put all UristMcStation medicine*****

Space for all Urist-done, non-pill medical items. Please keep it tidy, as usual. */

//Anti-rad autoinjectors for the engineers: for when you're above hoarding vodka bottles.

/obj/item/weapon/reagent_containers/hypospray/autoinjector/rad
	name = "anti-radiation autoinjector"
	desc = "An autoinjector with a small concotion of drugs designed to treat radiation poisoning." //A label says: <b>Warning!</b> this product contains arithrazine."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "radinjector"
	item_state = "autoinjector"

/obj/item/weapon/reagent_containers/hypospray/autoinjector/rad/New()
	..()
	reagents.remove_reagent("inaprovaline", 5)
	reagents.add_reagent("hyronalin", 3)
	reagents.add_reagent("anti_toxin", 2)
	update_icon()
	return

/obj/item/weapon/storage/firstaid/rad
	name = "radiation first aid kit"
	desc = "A first aid kit loaded with medicine for radiation treatment."
	icon_state = "radfirstaid3"
	item_state = "firstaid-advanced"

	startswith = list(
		/obj/item/weapon/reagent_containers/hypospray/autoinjector/rad = 5,
		/obj/item/weapon/reagent_containers/syringe/antitoxin,
		/obj/item/device/healthanalyzer
		)

	New()
		..()
		icon_state = pick("radfirstaid","radfirstaid2","radfirstaid3")

/obj/item/weapon/reagent_containers/hypospray/autoinjector/adv
	name = "advanced autoinjector"
	desc = "An advanced autoinjector, containing a number of helpful chemicals."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "radinjector"
	item_state = "autoinjector"

/obj/item/weapon/reagent_containers/hypospray/autoinjector/adv/New()
	..()
	reagents.add_reagent("tricordrazine", 5)
	reagents.add_reagent("tramadol", 5)
	reagents.add_reagent("dexalinp", 5)
	update_icon()
	return

/obj/item/weapon/reagent_containers/hypospray/autoinjector/admin
	name = "advanced autoinjector"
	desc = "An advanced autoinjector, containing a number of helpful chemicals."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "radinjector"
	item_state = "autoinjector"

/obj/item/weapon/reagent_containers/hypospray/autoinjector/admin/New()
	..()
	reagents.add_reagent("adminordrazine", 5)
	reagents.add_reagent("tramadol", 5)
	update_icon()
	return

///obj/item/weapon/reagent_containers/hypospray/autoinjector/quickclot/New()
//	..()
//	reagents.add_reagent("tramadol", 5)
//	reagents.add_reagent("quickclot", 5)
//	update_icon()
//	return

///obj/item/weapon/reagent_containers/hypospray/autoinjector/quickclot
//	name = "Quick Clot"
//	desc = "An Auto-injector loaded with Quick-clot, a chemical designed to stop internal bleeding instantly."
//	icon_state = "autoinjector"
//	item_state = "autoinjector"

/obj/item/weapon/storage/box/autoinjectorscom
	name = "box of advanced autoinjectors"
	desc = "A box containing a number of advanced autoinjectors and a cryobag just in case."

	startswith = list(
		/obj/item/weapon/reagent_containers/hypospray/autoinjector/adv = 5,
		/obj/item/bodybag/cryobag
		)
