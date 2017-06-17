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

/obj/item/weapon/storage/firstaid/rad/New()
	..()
	icon_state = pick("radfirstaid","radfirstaid2","radfirstaid3")

/obj/item/weapon/storage/firstaid/tactical
	name = "tactical medicine kit"
	desc = "Contains experimental medicine and advanced tools."
	icon = 'icons/urist/items/misc.dmi'
	item_icons = URIST_ALL_ONMOBS
	icon_state = "tactical"
	item_state = "tactical"
	max_storage_space = 20

	startswith = list(
		/obj/item/device/healthanalyzer,
		/obj/item/weapon/reagent_containers/hypospray,
		/obj/item/weapon/storage/pill_bottle/bloodloss,
		/obj/item/weapon/storage/pill_bottle/peridaxon,
		/obj/item/weapon/storage/pill_bottle/emergency,
		/obj/item/weapon/reagent_containers/glass/beaker/stabilization,
		/obj/item/weapon/reagent_containers/glass/beaker/brute,
		/obj/item/weapon/reagent_containers/glass/beaker/burns,
		/obj/item/weapon/reagent_containers/glass/beaker/radiation,
		/obj/item/weapon/reagent_containers/glass/beaker/painkiller,
		)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/adv
	name = "advanced autoinjector"
	desc = "An advanced autoinjector, containing a number of helpful chemicals."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "radinjector"
	item_state = "autoinjector"
	volume = 20
	amount_per_transfer_from_this = 20

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
	volume = 20
	amount_per_transfer_from_this = 20

/obj/item/weapon/reagent_containers/hypospray/autoinjector/admin/New()
	..()
	reagents.add_reagent("adminordrazine", 5)
	reagents.add_reagent("tramadol", 5)
	reagents.add_reagent("dexalinp", 5)
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

//Tactical medicine

/obj/item/weapon/reagent_containers/glass/beaker/stabilization
	name = "Stabilization mix"
	desc = "Inaprovaline | Dexalin Plus 1|1"

/obj/item/weapon/reagent_containers/glass/beaker/stabilization/New()
	..()
	reagents.add_reagent("inaprovaline", 30)
	reagents.add_reagent("dexalinp", 30)
	update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/brute
	name = "Brute treatment mix"
	desc = "Bicaridine | Tricordrazine 3|1"

/obj/item/weapon/reagent_containers/glass/beaker/brute/New()
	..()
	reagents.add_reagent("bicaridine", 45)
	reagents.add_reagent("tricordrazine", 15)
	update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/burns
	name = "Burn treatment mix"
	desc = "Kelotane | Dermaline 1|1"

/obj/item/weapon/reagent_containers/glass/beaker/burns/New()
	..()
	reagents.add_reagent("kelotane", 30)
	reagents.add_reagent("dermaline", 30)
	update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/radiation
	name = "Radiation treatment mix"
	desc = "Arithrazine | Hyronalin | Dylovene 2|1|1"

/obj/item/weapon/reagent_containers/glass/beaker/radiation/New()
	..()
	reagents.add_reagent("arithrazine", 30)
	reagents.add_reagent("hyronalin", 15)
	reagents.add_reagent("anti_toxin", 15)
	update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/painkiller
	name = "Painkillers"
	desc = "Oxycodone | Dexalin Plus 3|1"

/obj/item/weapon/reagent_containers/glass/beaker/painkiller/New()
	..()
	reagents.add_reagent("oxycodone", 45)
	reagents.add_reagent("dexalinp", 15)
	update_icon()