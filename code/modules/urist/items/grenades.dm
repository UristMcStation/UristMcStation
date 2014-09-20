/obj/item/weapon/grenade/chem_grenade/hhg
	name = "The Holy Hand Grenade of Antioch"
	desc = "The Holy Hand Grenade of Antioch."
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "hhg"
	item_state = "hhg"
	path = 1
	stage = 2
	urist_only = 1

/obj/item/weapon/grenade/chem_grenade/hhg/attack_self()
	usr.client.mob.say("O LORD, bless this Thy hand grenade that with it Thou mayest blow Thine enemies to tiny bits, in Thy mercy")
	..()

/obj/item/weapon/grenade/chem_grenade/hhg/dumb
	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)
		B1.reagents.add_reagent("space_drugs", 1)
		B1.reagents.add_reagent("potassium", 32)
		B1.reagents.add_reagent("sugar", 17)
		B2.reagents.add_reagent("space_drugs", 3)
		B2.reagents.add_reagent("sugar", 15)
		B2.reagents.add_reagent("phosphorus", 32)

		detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

		beakers += B1
		beakers += B2

		icon_state = initial(icon_state) +"_locked"


/obj/item/weapon/grenade/chem_grenade/hhg/good
	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)
		B1.reagents.add_reagent("holywater", 1)
		B1.reagents.add_reagent("potassium", 32)
		B1.reagents.add_reagent("sugar", 17)
		B2.reagents.add_reagent("holywater", 3)
		B2.reagents.add_reagent("sugar", 15)
		B2.reagents.add_reagent("phosphorus", 32)

		detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

		beakers += B1
		beakers += B2

		icon_state = initial(icon_state) +"_locked"