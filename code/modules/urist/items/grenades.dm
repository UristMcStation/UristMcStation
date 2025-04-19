/obj/item/grenade/chem_grenade/hhg
	name = "The Holy Hand Grenade of Antioch"
	desc = "The Holy Hand Grenade of Antioch."
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "hhg"
	item_state = "hhg"
	path = 1
	stage = 2
	item_icons = DEF_URIST_INHANDS

/obj/item/grenade/chem_grenade/hhg/attack_self()
	usr.client.mob.say("O LORD, bless this Thy hand grenade that with it Thou mayest blow Thine enemies to tiny bits, in Thy mercy")
	..()

/obj/item/grenade/chem_grenade/hhg/dumb

/obj/item/grenade/chem_grenade/hhg/dumb/New()
	..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)
	B1.reagents.add_reagent(/datum/reagent/drugs/hextro, 1)
	B1.reagents.add_reagent(/datum/reagent/potassium, 32)
	B1.reagents.add_reagent(/datum/reagent/sugar, 17)
	B2.reagents.add_reagent(/datum/reagent/drugs/hextro, 3)
	B2.reagents.add_reagent(/datum/reagent/sugar, 15)
	B2.reagents.add_reagent(/datum/reagent/phosphorus, 32)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	beakers += B1
	beakers += B2

	icon_state = initial(icon_state) +"_locked"


/obj/item/grenade/chem_grenade/hhg/good

/obj/item/grenade/chem_grenade/hhg/good/New()
	..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)
	B1.reagents.add_reagent(/datum/reagent/water/holywater, 1)
	B1.reagents.add_reagent(/datum/reagent/potassium, 32)
	B1.reagents.add_reagent(/datum/reagent/sugar, 17)
	B2.reagents.add_reagent(/datum/reagent/water/holywater, 3)
	B2.reagents.add_reagent(/datum/reagent/sugar, 15)
	B2.reagents.add_reagent(/datum/reagent/phosphorus, 32)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	beakers += B1
	beakers += B2

	icon_state = initial(icon_state) +"_locked"

//Sonic Grenades: Shatter windows and stun people.
/obj/item/grenade/sonic
	name = "sonic grenade"
	origin_tech = "combat=2;illegal=1"
	desc = "A grenade which blows out windows and stuns people. Probably illegal."
	icon_state = "emp"
	item_state = "emp"
/obj/item/grenade/sonic/detonate()
	..()

	for(var/obj/structure/window/W in view(6, src.loc)) //Shatters windows
		W.hit(20,1)
		if(get_dist(W, src.loc) <= 3) //Reinf windows
			W.hit(60,0)
		if(get_dist(W, src.loc) <= 1)
			W.hit(40,0)
	for(var/obj/machinery/door/window/D in view(4, src.loc)) //Busting windoors
		D.damage_health(150)
		if(get_dist(D, src.loc) <= 2)
			D.damage_health(150)

	for(var/mob/living/carbon/M in hearers(6, src.loc))
		var/distance = get_dist(M, src.loc)
		var/safety = 1
		to_chat(M, "<span class='warning'><font size='3'><b>You hear a tremendous bang!</font></b></span>")
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
/obj/item/storage/box/sonics
	name = "box of sonic grenades"
	desc = "A box with 4 sonic grenades. WARNING: Wear ear protection!"
	icon_state = "flashbang"

/obj/item/storage/box/sonics/New()
		..()
		new /obj/item/grenade/sonic(src)
		new /obj/item/grenade/sonic(src)
		new /obj/item/grenade/sonic(src)
		new /obj/item/grenade/sonic(src)

/obj/item/grenade/chem_grenade/heal
	name = "healing grenade"
	path = 1
	stage = 2

/obj/item/grenade/chem_grenade/heal/New()
		..()
		var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/reagent_containers/glass/beaker/B2 = new(src)
		B1.reagents.add_reagent(/datum/reagent/tricordrazine, 10)
		B1.reagents.add_reagent(/datum/reagent/potassium, 32)
		B1.reagents.add_reagent(/datum/reagent/sugar, 17)
		B2.reagents.add_reagent(/datum/reagent/tramadol, 6)
		B2.reagents.add_reagent(/datum/reagent/sugar, 15)
		B2.reagents.add_reagent(/datum/reagent/phosphorus, 32)

		detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

		beakers += B1
		beakers += B2

		icon_state = "grenade"

/obj/item/storage/box/cleangrenades
	name = "box of cleaner grenades"
	desc = "A box of cleaner grenades"

/obj/item/storage/box/cleangrenades/New()
	..()
	new /obj/item/grenade/chem_grenade/cleaner(src)
	new /obj/item/grenade/chem_grenade/cleaner(src)
	new /obj/item/grenade/chem_grenade/cleaner(src)

/obj/item/grenade/chem_grenade/heal2
	name = "light healing grenade"
	path = 1
	stage = 2

/obj/item/grenade/chem_grenade/heal2/New()
		..()
		var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/reagent_containers/glass/beaker/B2 = new(src)
		B1.reagents.add_reagent(/datum/reagent/inaprovaline, 10)
		B1.reagents.add_reagent(/datum/reagent/potassium, 32)
		B1.reagents.add_reagent(/datum/reagent/sugar, 17)
		B2.reagents.add_reagent(/datum/reagent/paracetamol, 6)
		B2.reagents.add_reagent(/datum/reagent/sugar, 15)
		B2.reagents.add_reagent(/datum/reagent/phosphorus, 32)

		detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

		beakers += B1
		beakers += B2

		icon_state = "grenade"

//Syndie mini-bomb from tg

/obj/item/grenade/syndieminibomb
	desc = "A syndicate manufactured explosive used to sow destruction and chaos"
	name = "syndicate minibomb"
	icon = 'icons/urist/items/tgitems.dmi'
	icon_state = "syndicate"
	item_state = "flashbang"
	origin_tech = "materials=3;magnets=4;syndicate=4"

/obj/item/grenade/syndieminibomb/detonate()
	explosion(src.loc, 9, EX_ACT_DEVASTATING)
	qdel(src)
