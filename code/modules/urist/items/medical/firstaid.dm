/*										*****New space to put all UristMcStation medicine*****

Space for all Urist-done, non-pill medical items. Please keep it tidy, as usual. */

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
