/*										*****New space to put all UristMcStation medicine*****

Space for all Urist-done, non-pill medical items. Please keep it tidy, as usual. */

//Anti-rad autoinjectors for the engineers: for when you're above hoarding vodka bottles.

/obj/item/weapon/reagent_containers/hypospray/autoinjector/rad
	name = "anti-radiation autoinjector"
	desc = "An autoinjector with a small concotion of drugs designed to treat radiation poisoning. A label says: <b>Warning!</b> this product contains arithrazine."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "radinjector"
	item_state = "autoinjector"

/obj/item/weapon/reagent_containers/hypospray/autoinjector/rad/New()
	..()
	reagents.remove_reagent("inaprovaline", 5)
	reagents.add_reagent("arithrazine", 3)
	reagents.add_reagent("anti_toxin", 2)
	update_icon()
	return

/obj/item/weapon/storage/firstaid/rad
	name = "radiation first aid kit"
	desc = "A first aid kit loaded with medicine for radiation treatment."
	icon_state = "radfirstaid3"
	item_state = "firstaid-advanced"

	New()
		..()
		if (empty) return

		icon_state = pick("radfirstaid","radfirstaid2","radfirstaid3")

		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/rad( src )
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/rad( src )
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/rad( src )
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/rad( src )
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/rad( src )
		new /obj/item/weapon/reagent_containers/syringe/antitoxin( src )
		new /obj/item/device/healthanalyzer( src )
		return
