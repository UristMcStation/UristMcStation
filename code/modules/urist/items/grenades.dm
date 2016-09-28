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

//Sonic Grenades: Shatter windows and stun people.
/obj/item/weapon/grenade/sonic
	name = "sonic grenade"
	origin_tech = "combat=2;illegal=1"
	desc = "A grenade which blows out windows and stuns people. Probably illegal."
	icon_state = "emp"
	item_state = "emp"
/obj/item/weapon/grenade/sonic/detonate()
	..()

	for(var/obj/structure/window/W in view(6, src.loc)) //Shatters windows
		W.hit(20,1)
		if(get_dist(W, src.loc) <= 3) //Reinf windows
			W.hit(60,0)
		if(get_dist(W, src.loc) <= 1)
			W.hit(40,0)
	for(var/obj/machinery/door/window/D in view(4, src.loc)) //Busting windoors
		D.take_damage(150)
		if(get_dist(D, src.loc) <= 2)
			D.take_damage(150)

	for(var/mob/living/carbon/M in hearers(6, src.loc))
		var/distance = get_dist(M, src.loc)
		var/safety = 1
		M << "<span class='warning'><font size='3'><b>You hear a tremendous bang!</font></b></span>"
		if(ishuman(M))
			if(M:is_on_ears(/obj/item/clothing/ears/earmuffs))
				safety = 2

		if(distance <= 4) //Middle section
			M.Stun(4/safety)
			M.Weaken(2/safety)
			M.ear_deaf = (20/safety)
			M.stuttering = (20)
			M.make_jittery(60)
		else if(distance <= 1) //Adjacent or on top of it.
			M.Stun(6/safety)
			M.Weaken(4/safety)
			M.ear_deaf = (30/safety)
			M.stuttering = (30)
			M.make_jittery(90)
		else //Far away
			M.Stun(2/safety)
			M.Weaken(2/safety)
			M.ear_deaf = (10/safety)
			M.stuttering = (10)
			M.make_jittery(30)	//No ear damage because I don't want spam
			//To lead to deafness.

	playsound(src.loc, 'sound/effects/bang.ogg', 50, 1, 5)
	qdel(src)
	return

//A box for them
/obj/item/weapon/storage/box/sonics
	name = "box of sonic grenades"
	desc = "A box with 4 sonic grenades. WARNING: Wear ear protection!"
	icon_state = "flashbang"

/obj/item/weapon/storage/box/sonics/New()
		..()
		new /obj/item/weapon/grenade/sonic(src)
		new /obj/item/weapon/grenade/sonic(src)
		new /obj/item/weapon/grenade/sonic(src)
		new /obj/item/weapon/grenade/sonic(src)

/obj/item/weapon/grenade/chem_grenade/heal
	name = "healing grenade"
	path = 1
	stage = 2

/obj/item/weapon/grenade/chem_grenade/heal/New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)
		B1.reagents.add_reagent("tricordrazine", 10)
		B1.reagents.add_reagent("potassium", 32)
		B1.reagents.add_reagent("sugar", 17)
		B2.reagents.add_reagent("tramadol", 6)
		B2.reagents.add_reagent("sugar", 15)
		B2.reagents.add_reagent("phosphorus", 32)

		detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

		beakers += B1
		beakers += B2

		icon_state = "grenade"

/obj/item/weapon/storage/box/cleangrenades
	name = "box of cleaner grenades"
	desc = "A box of cleaner grenades"

	New()
		..()
		new /obj/item/weapon/grenade/chem_grenade/cleaner(src)
		new /obj/item/weapon/grenade/chem_grenade/cleaner(src)
		new /obj/item/weapon/grenade/chem_grenade/cleaner(src)

/obj/item/weapon/grenade/chem_grenade/heal2
	name = "light healing grenade"
	path = 1
	stage = 2

/obj/item/weapon/grenade/chem_grenade/heal2/New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)
		B1.reagents.add_reagent("inaprovaline", 10)
		B1.reagents.add_reagent("potassium", 32)
		B1.reagents.add_reagent("sugar", 17)
		B2.reagents.add_reagent("paracetemol", 6)
		B2.reagents.add_reagent("sugar", 15)
		B2.reagents.add_reagent("phosphorus", 32)

		detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

		beakers += B1
		beakers += B2

		icon_state = "grenade"

//Syndie mini-bomb from /tg/

/obj/item/weapon/grenade/syndieminibomb
	desc = "A syndicate manufactured explosive used to sow destruction and chaos"
	name = "syndicate minibomb"
	icon = 'icons/urist/items/tgitems.dmi'
	icon_state = "syndicate"
	item_state = "flashbang"
	origin_tech = "materials=3;magnets=4;syndicate=4"

/obj/item/weapon/grenade/syndieminibomb/detonate()
	explosion(src.loc, 1, 2, 4, 4)
	qdel(src)