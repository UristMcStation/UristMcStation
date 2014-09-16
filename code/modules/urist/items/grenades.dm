/obj/item/weapon/grenade/chem_grenade/hhg
	name = "The Holy Hand Grenade of Antioch"
	desc = "O LORD, bless this Thy hand grenade that with it Thou mayest blow Thine enemies to tiny bits, in Thy mercy."
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "hhg"
	path = 1
	stage = 2

/obj/item/weapon/grenade/chem_grenade/hhg/dumb
	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)
		B1.reagents.add_reagent("fluorine", 10)
		B1.reagents.add_reagent("water", 10)
		B1.reagents.add_reagent("silicon", 10)
		B2.reagents.add_reagent("sacid", 5)
		B2.reagents.add_reagent("oxygen", 10)
		B1.reagents.add_reagent("carbon", 10)
		icon_state = "hhg"


/obj/item/weapon/grenade/chem_grenade/hhg/good
	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)
		B1.reagents.add_reagent("fluorine", 10)
		B1.reagents.add_reagent("carbon", 10)
		B1.reagents.add_reagent("inaprovaline", 20)
		B2.reagents.add_reagent("sacid", 5)
		B2.reagents.add_reagent("anti-toxin", 20)