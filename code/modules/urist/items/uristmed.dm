/*										*****New space to put all UristMcStation medicine*****

Space for all Urist-done, non-pill medical items. Please keep it tidy, as usual. */

//Anti-rad autoinjectors for the engineers: for when you're above hoarding vodka bottles.

/obj/item/reagent_containers/hypospray/autoinjector/rad
	name = "anti-radiation autoinjector"
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

/obj/item/storage/firstaid/rad
	name = "radiation first aid kit"
	desc = "A first aid kit loaded with medicine for radiation treatment."
	icon_state = "radfirstaid3"
	item_state = "firstaid-advanced"

	startswith = list(
		/obj/item/reagent_containers/hypospray/autoinjector/rad = 5,
		/obj/item/reagent_containers/syringe/antitoxin,
		/obj/item/device/scanner/health
		)

/obj/item/storage/firstaid/rad/New()
	..()
	icon_state = pick("radfirstaid","radfirstaid2","radfirstaid3")

/obj/item/storage/firstaid/tactical
	name = "tactical medicine kit"
	desc = "Contains experimental medicines and advanced tools."
	icon = 'icons/urist/items/misc.dmi'
	item_icons = URIST_ALL_ONMOBS
	icon_state = "tactical"
	item_state = "tactical"
	max_storage_space = 20

	startswith = list(
		/obj/item/device/scanner/health,
		/obj/item/reagent_containers/hypospray,
		/obj/item/storage/pill_bottle/bloodloss,
		/obj/item/storage/pill_bottle/peridaxon,
		/obj/item/storage/pill_bottle/emergency,
		/obj/item/reagent_containers/glass/beaker/stabilization,
		/obj/item/reagent_containers/glass/beaker/brute,
		/obj/item/reagent_containers/glass/beaker/burns,
		/obj/item/reagent_containers/glass/beaker/radiation,
		/obj/item/reagent_containers/glass/beaker/painkiller,
		)

/obj/item/reagent_containers/hypospray/autoinjector/adv
	name = "advanced autoinjector"
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
	name = "advanced autoinjector"
	desc = "An advanced autoinjector, containing a number of helpful chemicals."
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

///obj/item/reagent_containers/hypospray/autoinjector/quickclot/New()
//	..()
//	reagents.add_reagent("tramadol", 5)
//	reagents.add_reagent("quickclot", 5)
//	update_icon()
//	return

///obj/item/reagent_containers/hypospray/autoinjector/quickclot
//	name = "Quick Clot"
//	desc = "An Auto-injector loaded with Quick-clot, a chemical designed to stop internal bleeding instantly."
//	icon_state = "autoinjector"
//	item_state = "autoinjector"

/obj/item/storage/box/autoinjectorscom
	name = "box of advanced autoinjectors"
	desc = "A box containing a number of advanced autoinjectors and a cryobag just in case."

	startswith = list(
		/obj/item/reagent_containers/hypospray/autoinjector/adv = 5,
		/obj/item/bodybag/cryobag
		)

//Tactical medicine

/obj/item/reagent_containers/glass/beaker/stabilization
	name = "Stabilization mix"
	desc = "A label on the side reads 'Inaprovaline | Dexalin Plus 1|1'."
	icon_state = "bottle-3"

/obj/item/reagent_containers/glass/beaker/stabilization/New()
	..()
	reagents.add_reagent(/datum/reagent/inaprovaline, 30)
	reagents.add_reagent(/datum/reagent/dexalinp, 30)
	update_icon()

/obj/item/reagent_containers/glass/beaker/brute
	name = "Brute treatment mix"
	desc = "A label on the side reads 'Bicaridine | Tricordrazine 3|1'."
	icon_state = "bottle-3"

/obj/item/reagent_containers/glass/beaker/brute/New()
	..()
	reagents.add_reagent(/datum/reagent/bicaridine, 45)
	reagents.add_reagent(/datum/reagent/tricordrazine, 15)
	update_icon()

/obj/item/reagent_containers/glass/beaker/burns
	name = "Burn treatment mix"
	desc = "A label on the side reads 'Kelotane | Dermaline 1|1'."
	icon_state = "bottle-3"

/obj/item/reagent_containers/glass/beaker/burns/New()
	..()
	reagents.add_reagent(/datum/reagent/kelotane, 30)
	reagents.add_reagent(/datum/reagent/dermaline, 30)
	update_icon()

/obj/item/reagent_containers/glass/beaker/radiation
	name = "Radiation treatment mix"
	desc = "A label on the side reads 'Arithrazine | Hyronalin | Dylovene 2|1|1'."
	icon_state = "bottle-3"

/obj/item/reagent_containers/glass/beaker/radiation/New()
	..()
	reagents.add_reagent(/datum/reagent/arithrazine, 30)
	reagents.add_reagent(/datum/reagent/hyronalin, 15)
	reagents.add_reagent(/datum/reagent/dylovene, 15)
	update_icon()

/obj/item/reagent_containers/glass/beaker/painkiller
	name = "Painkillers"
	desc = "A label on the side reads 'Oxycodone | Dexalin Plus 3|1'."
	icon_state = "bottle-3"

/obj/item/reagent_containers/glass/beaker/painkiller/New()
	..()
	reagents.add_reagent(/datum/reagent/tramadol/oxycodone, 45)
	reagents.add_reagent(/datum/reagent/dexalinp, 15)
	update_icon()

//resomi / teshari blood

/obj/item/reagent_containers/ivbag/blood/teshari
	abstract_type = /obj/item/reagent_containers/ivbag/blood/teshari


/obj/item/reagent_containers/ivbag/blood/teshari/Initialize(mapload, blood_type)
	return ..(mapload, blood_type, SPECIES_RESOMI)


/obj/item/reagent_containers/ivbag/blood/teshari/apos/Initialize(mapload)
	return ..(mapload, "A+")


/obj/item/reagent_containers/ivbag/blood/teshari/aneg/Initialize(mapload)
	return ..(mapload, "A-")


/obj/item/reagent_containers/ivbag/blood/teshari/bpos/Initialize(mapload)
	return ..(mapload, "B+")


/obj/item/reagent_containers/ivbag/blood/teshari/bneg/Initialize(mapload)
	return ..(mapload, "B-")


/obj/item/reagent_containers/ivbag/blood/teshari/abpos/Initialize(mapload)
	return ..(mapload, "AB+")


/obj/item/reagent_containers/ivbag/blood/teshari/abneg/Initialize(mapload)
	return ..(mapload, "AB-")


/obj/item/reagent_containers/ivbag/blood/teshari/opos/Initialize(mapload)
	return ..(mapload, "O+")


/obj/item/reagent_containers/ivbag/blood/teshari/oneg/Initialize(mapload)
	return ..(mapload, "O-")
