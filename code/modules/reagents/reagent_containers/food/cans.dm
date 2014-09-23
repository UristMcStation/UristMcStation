/obj/item/weapon/reagent_containers/food/drinks/cans
	var canopened = 0

	attack_self(mob/user as mob)
		if (canopened == 0)
			playsound(src.loc,'sound/effects/canopen.ogg', rand(10,50), 1)
			user << "<span class='notice'>You open the drink with an audible pop!</span>"
			canopened = 1
		else
			return

	attack(mob/M as mob, mob/user as mob, def_zone)
		if (canopened == 0)
			user << "<span class='notice'>You need to open the drink!</span>"
			return
		var/datum/reagents/R = src.reagents
		var/fillevel = gulp_size

		if(!R.total_volume || !R)
			user << "\red The [src.name] is empty!"
			return 0

		if(M == user)
			M << "\blue You swallow a gulp of [src]."
			if(reagents.total_volume)
				reagents.trans_to_ingest(M, gulp_size)
				reagents.reaction(M, INGEST)
				spawn(5)
					reagents.trans_to(M, gulp_size)

			playsound(M.loc,'sound/items/drink.ogg', rand(10,50), 1)
			return 1
		else if( istype(M, /mob/living/carbon/human) )
			if (canopened == 0)
				user << "<span class='notice'>You need to open the drink!</span>"
				return

		else if (canopened == 1)
			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] attempts to feed [M] [src].", 1)
			if(!do_mob(user, M)) return
			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] feeds [M] [src].", 1)

			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [user.name] ([user.ckey]) Reagents: [reagentlist(src)]</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [M.name] by [M.name] ([M.ckey]) Reagents: [reagentlist(src)]</font>")
			msg_admin_attack("[key_name(user)] fed [key_name(M)] with [src.name] Reagents: [reagentlist(src)] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

			if(reagents.total_volume)
				reagents.trans_to_ingest(M, gulp_size)

			if(isrobot(user)) //Cyborg modules that include drinks automatically refill themselves, but drain the borg's cell
				var/mob/living/silicon/robot/bro = user
				bro.cell.use(30)
				var/refill = R.get_master_reagent_id()
				spawn(600)
					R.add_reagent(refill, fillevel)

			playsound(M.loc,'sound/items/drink.ogg', rand(10,50), 1)
			return 1

		return 0


	afterattack(obj/target, mob/user, proximity)
		if(!proximity) return

		if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.
			if (canopened == 0)
				user << "<span class='notice'>You need to open the drink!</span>"
				return

			if(!target.reagents.total_volume)
				user << "\red [target] is empty."
				return

			if(reagents.total_volume >= reagents.maximum_volume)
				user << "\red [src] is full."
				return

				var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
				user << "\blue You fill [src] with [trans] units of the contents of [target]."


		else if(target.is_open_container()) //Something like a glass. Player probably wants to transfer TO it.
			if (canopened == 0)
				user << "<span class='notice'>You need to open the drink!</span>"
				return

			if (istype(target, /obj/item/weapon/reagent_containers/food/drinks/cans))
				var/obj/item/weapon/reagent_containers/food/drinks/cans/cantarget = target
				if(cantarget.canopened == 0)
					user << "<span class='notice'>You need to open the drink you want to pour into!</span>"
					return

			if(!reagents.total_volume)
				user << "\red [src] is empty."
				return

			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				user << "\red [target] is full."
				return



			var/datum/reagent/refill
			var/datum/reagent/refillName
			if(isrobot(user))
				refill = reagents.get_master_reagent_id()
				refillName = reagents.get_master_reagent_name()

			var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
			user << "\blue You transfer [trans] units of the solution to [target]."

			if(isrobot(user)) //Cyborg modules that include drinks automatically refill themselves, but drain the borg's cell
				var/mob/living/silicon/robot/bro = user
				var/chargeAmount = max(30,4*trans)
				bro.cell.use(chargeAmount)
				user << "Now synthesizing [trans] units of [refillName]..."


				spawn(300)
					reagents.add_reagent(refill, trans)
					user << "Cyborg [src] refilled."

		return ..()

/*	examine()
		set src in view()
		..()
		if (!(usr in range(0)) && usr!=src.loc) return
		if(!reagents || reagents.total_volume==0)
			usr << "\blue \The [src] is empty!"
		else if (reagents.total_volume<=src.volume/4)
			usr << "\blue \The [src] is almost empty!"
		else if (reagents.total_volume<=src.volume*0.66)
			usr << "\blue \The [src] is half full!"
		else if (reagents.total_volume<=src.volume*0.90)
			usr << "\blue \The [src] is almost full!"
		else
			usr << "\blue \The [src] is full!"*/


//DRINKS

/obj/item/weapon/reagent_containers/food/drinks/cans/cola
	name = "Nien Juice"
	desc = "Just don't think about the salty taste."
	icon_state = "cola"
	center_of_mass = list("x"=16, "y"=10)
	New()
		..()
		reagents.add_reagent("cola", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle
	name = "Nottled Hauster"
	desc = "Introduced to the vending machines by Skrellian request, this hauster comes straight from the Hausian poles."
	icon_state = "waterbottle"
	center_of_mass = list("x"=15, "y"=8)
	New()
		..()
		reagents.add_reagent("water", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/beer
	name = "Jonson Beer"
	desc = "Contains only hauster, malt and hops."
	icon_state = "beer"
	center_of_mass = list("x"=16, "y"=12)
	New()
		..()
		reagents.add_reagent("beer", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/ale
	name = "Kert-Ale"
	desc = "A true dorf's drink of choice."
	icon_state = "alebottle"
	item_state = "beer"
	center_of_mass = list("x"=16, "y"=10)
	New()
		..()
		reagents.add_reagent("ale", 30)


/obj/item/weapon/reagent_containers/food/drinks/cans/space_mountain_wind
	name = "Code Red MNT Dew"
	desc = "The drink of Nienhaus"
	icon_state = "space_mountain_wind"
	center_of_mass = list("x"=16, "y"=10)
	New()
		..()
		reagents.add_reagent("spacemountainwind", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/thirteenloko
	name = "Nienteen Loko"
	desc = "The CMO has advised crew members that consumption of Nienteen Loko may result in being awesome and an admin."
	icon_state = "thirteen_loko"
	center_of_mass = list("x"=16, "y"=8)
	New()
		..()
		reagents.add_reagent("thirteenloko", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/dr_gibb
	name = "Dr. Petridis"
	desc = "The flavor of a man who poses for sexy newscasters."
	icon_state = "dr_gibb"
	center_of_mass = list("x"=16, "y"=10)
	New()
		..()
		reagents.add_reagent("dr_gibb", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/starkist
	name = "Star-haus"
	desc = "The taste of a star in liquid form. And, a bit of tuna...?"
	icon_state = "starkist"
	center_of_mass = list("x"=16, "y"=10)
	New()
		..()
		reagents.add_reagent("cola", 15)
		reagents.add_reagent("orangejuice", 15)

/obj/item/weapon/reagent_containers/food/drinks/cans/space_up
	name = "Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	icon_state = "space-up"
	center_of_mass = list("x"=16, "y"=10)
	New()
		..()
		reagents.add_reagent("space_up", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/lemon_lime
	name = "Lemon-Lime"
	desc = "You wanted ORANGE. It gave you Lemon Lime."
	icon_state = "lemon-lime"
	center_of_mass = list("x"=16, "y"=10)
	New()
		..()
		reagents.add_reagent("lemon_lime", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/iced_tea
	name = "Vrisk Serket Iced  NOT Tea"
	desc = "That sweet, refreshing southern earthy flavor. That's where it's from, right? South Earth?"
	icon_state = "ice_tea_can"
	center_of_mass = list("x"=16, "y"=10)
	New()
		..()
		reagents.add_reagent("icetea", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/grape_juice
	name = "Nienapel Juice"
	desc = "500 pages of rules of how to appropriately enter into a combat with this juice!"
	icon_state = "purple_can"
	center_of_mass = list("x"=16, "y"=10)
	New()
		..()
		reagents.add_reagent("grapejuice", 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/tonic
	name = "Kert's Tonic Water"
	desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."
	icon_state = "tonic"
	center_of_mass = list("x"=16, "y"=10)
	New()
		..()
		reagents.add_reagent("tonic", 50)

/obj/item/weapon/reagent_containers/food/drinks/cans/sodawater
	name = "Soda Hauster"
	desc = "A can of soda hauster. Still hauster's more refreshing cousin."
	icon_state = "sodawater"
	center_of_mass = list("x"=16, "y"=10)
	New()
		..()
		reagents.add_reagent("sodawater", 50)
