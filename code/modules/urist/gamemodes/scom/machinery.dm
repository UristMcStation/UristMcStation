/obj/machinery/door/airlock/multi_tile/marine
	name = "Airlock"
	icon = 'icons/urist/structures&machinery/doors/Door2x1marine.dmi'
	assembly_type = /obj/structure/door_assembly/multi_tile
	bound_height = 64
	bound_width = 64 //changed in New(), meant to stop geometry from breaking

//blatent copypasta of autolathe. soooooorry, but autolathe is very not object oriented, and I don't feel like rewriting it to be.

/obj/machinery/scom/scomscience //i'll come back to clean up this later, promise
	name = "\improper S.C.I.E.N.C.E"
	desc = "Science!"
	icon = 'icons/urist/structures&machinery/scomscience.dmi'
	icon_state = "science"
	density = 1
	anchored = 1
	bound_width = 64
	var/animation_state = "science_o"
	var/list/machine_recipes

	var/scomtechlvl = 0
	var/scommoney = 0

	var/show_category = "All"

	panel_open = 0
	var/busy = 0

	var/novehicles = 0
	var/science_capable = 1
	var/restricted_category = "All"

	var/squad = 0

/obj/machinery/scom/scomscience/proc/update_recipe_list()
	if(!machine_recipes)
		machine_recipes = scomscience_recipes

/obj/machinery/scom/scomscience/interact(mob/user as mob)

	update_recipe_list()

	var/dat = "<center><h1>Control Panel</h1><hr/>"

	dat += "<table width = '100%'>"
	dat += "Money - $[scommoney]</tr> Tech Level - [scomtechlvl]</tr></table><hr>"
	dat += "<h2>Printable Designs</h2><h3>Showing: <a href='?src=\ref[src];change_category=1'>[show_category]</a>.</h3></center><table width = '100%'>"

	var/index = 0
	for(var/datum/scomscience/recipe/R in machine_recipes)
		index++
		if(R.hidden && R.scomtechlvl > scomtechlvl || (show_category != "All" && show_category != R.category))
			continue
		if(novehicles && R.category == "Vehicles")
			continue
		if(restricted_category != "All" && restricted_category != R.category)
			continue
		var/can_make = 1
		var/material_string = "$[R.resources]"

		//Make sure it's buildable and list required resources.
		for(var/scommoney in R.resources)
			if(!isnull(scommoney) && scommoney < R.resources[scommoney])
				can_make = 0

			if(R.scomtechlvl <= scomtechlvl)
				R.hidden = 0

		dat += "<tr><td width = 180><b>[can_make ? "<a href='?src=\ref[src];make=[index];multiplier=1'>" : ""][R.name][can_make ? "</a>" : ""]</b></td><td align = right>[material_string]</tr>"

	dat += "</table><hr>"

	user << browse(dat, "window=autolathe")
	onclose(user, "autolathe")

/obj/machinery/scom/scomscience/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (busy)
		user << "<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>"
		return

	if(!science_capable)
		user << "<span class='notice'>\The [src] is not designed for deconstruction!.</span>"
		return

	if(O.scomtechlvl > scomtechlvl)
		scomtechlvl = O.scomtechlvl

	for(var/obj/machinery/scom/scomscience/S in machines)
		if(S.scomtechlvl < scomtechlvl)
			S.scomtechlvl = scomtechlvl

		else if(scomtechlvl < S.scomtechlvl)
			scomtechlvl = S.scomtechlvl

//		if(S.scommoney < scommoney)
//			S.scommoney = scommoney
		if(O.scomtechlvl <= S.scomtechlvl)
			S.scommoney = (S.scommoney + O.scommoney)

//		else if(scommoney < S.scommoney)
//			scommoney = S.scommoney

	flick("[animation_state]",src)

	user.drop_item(O)
	qdel(O)

	updateUsrDialog()

/obj/machinery/scom/scomscience/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/machinery/scom/scomscience/Topic(href, href_list)

	if(..())
		return

	usr.set_machine(src)

	if(busy)
		usr << "<span class='notice'>The autolathe is busy. Please wait for completion of previous operation.</span>"
		return

	if(href_list["change_category"])

		var/choice = input("Which category do you wish to display?") as null|anything in scomscience_categories+"All"
		if(!choice) return
		show_category = choice

	if(href_list["make"] && machine_recipes)

		var/index = text2num(href_list["make"])
		var/multiplier = text2num(href_list["multiplier"])
		var/datum/scomscience/recipe/making

		if(index > 0 && index <= machine_recipes.len)
			making = machine_recipes[index]

		//Exploit detection, not sure if necessary after rewrite.
		if(!making || multiplier < 0 || multiplier > 100)
			var/turf/exploit_loc = get_turf(usr)
			message_admins("[key_name_admin(usr)] tried to exploit an autolathe to duplicate an item! ([exploit_loc ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[exploit_loc.x];Y=[exploit_loc.y];Z=[exploit_loc.z]'>JMP</a>" : "null"])", 0)
			log_admin("EXPLOIT : [key_name(usr)] tried to exploit an autolathe to duplicate an item!")
			return

		busy = 1


		if(making.scomtechlvl > scomtechlvl)
			usr << "<span class='notice'>You don't have the tech level for that!</span>"
			busy = 0
			return

		if(making.resources > scommoney)
			usr << "<span class='notice'>You don't have the money for that!</span>"
			busy = 0
			return

		if(scommoney >= making.resources)
			for(var/obj/machinery/scom/scomscience/S in machines)
//				if(S.squad == 0) //test this
//					scommoney = scommoney - making.resources

				if(S.squad == squad)
					S.scommoney = S.scommoney - making.resources


		flick("[animation_state]",src)

		sleep(50)

		busy = 0

		//Sanity check.
		if(!making || !src) return

		//Create the desired item.
		new making.path(get_step(loc, get_dir(src,usr)))

	updateUsrDialog()

/obj/machinery/scom/scomscience/vehicles
	name = "vehicle fabricator"
	show_category = "Vehicles"
	restricted_category = "Vehicles"
	science_capable = 0
	icon = 'icons/obj/machines/drone_fab.dmi'
	icon_state = "drone_fab_idle"
	animation_state = "h_lathe_leave"

/obj/machinery/scom/scomscience/squadlead
	name = "Squad Leader fabricator"
	show_category = "Squad Leader"
	restricted_category = "Squad Leader"
	science_capable = 0
	icon = 'icons/urist/structures&machinery/machinery.dmi'
	icon_state = "lead"
	animation_state = "lead_o"
	bound_width = 32

/obj/machinery/scom/scomscience/squadlead/interact(mob/living/user as mob)
	if(user.job in list("Head of Personnel", "Head of Security", "Chief Engineer", "Chief Medical Officer"))
		..()
	else
		return

/obj/machinery/scom/scomscience/squad
	name = "squad fabricator"
	bound_width = 32
	icon = 'icons/urist/structures&machinery/machinery.dmi'
	animation_state = "science_o"
	novehicles = 1
	science_capable = 0

/obj/machinery/scom/classchanger
	name = "Class-O-Matic 9000"
	desc = "This allows you to choose your class as an S-COM operative"
	icon = 'icons/urist/structures&machinery/machinery.dmi'
	icon_state = "squad"
	anchored = 1
	density = 1
	var/list/already_picked = list() //stores mobs who used it to limit reuse

/obj/machinery/scom/classchanger/attack_hand(var/mob/living/carbon/user)
	if(!(user in already_picked))
		if(user.mind && isscom(user))
			var/want = input("Which class would you like to be?", "Your Choice", "Cancel") in list ("Cancel", "Heavy", "Assault", "Medic", "Sniper")
			switch(want)
				if("Cancel")
					return

				if("Heavy")
					user.equip_to_slot_or_del(new /obj/item/clothing/suit/urist/armor/heavy(user), slot_wear_suit)
					new /obj/item/clothing/accessory/storage/black_vest(src.loc)
					new /obj/item/ammo_magazine/c45m(src.loc)
					new /obj/item/weapon/reagent_containers/hypospray/autoinjector(src.loc)
					new /obj/item/weapon/gun/projectile/automatic/l6_saw(src.loc)
					new /obj/item/weapon/storage/box/lmgammo(src.loc)

					for (var/obj/item/weapon/card/id/W in user)
						if(W.assignment == "S-COM Operative")
							W.assignment = "S-COM Heavy Operative"

				if("Assault")
					user.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(user), slot_wear_suit)
					new /obj/item/clothing/accessory/storage/black_vest(src.loc)
					new /obj/item/ammo_magazine/c45m(src.loc)
					new /obj/item/weapon/gun/projectile/shotgun/pump/combat(src.loc)
					new /obj/item/weapon/reagent_containers/hypospray/autoinjector(src.loc)
					new /obj/item/weapon/storage/box/shotgunammo(src.loc)
					new /obj/item/weapon/storage/box/shotgunammo(src.loc)
					new /obj/item/weapon/storage/box/shotgunammo(src.loc)

					for (var/obj/item/weapon/card/id/W in user)
						if(W.assignment == "S-COM Operative")
							W.assignment = "S-COM Assault Operative"

				if("Medic")
					user.equip_to_slot_or_del(new /obj/item/clothing/suit/urist/armor/medic(user), slot_wear_suit)
					user.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(user), slot_glasses)
					user.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/ert/medical(user), slot_back)
					user.equip_to_slot_or_del(new /obj/item/weapon/defibrillator/compact/combat/loaded(user.back), slot_in_backpack)
					user.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/fire(user.back), slot_in_backpack)
					user.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/adv(user.back), slot_in_backpack)
					user.equip_to_slot_or_del(new /obj/item/bodybag/cryobag(user.back), slot_in_backpack)
					new /obj/item/bodybag/cryobag(src.loc)
					new /obj/item/clothing/accessory/storage/black_vest(src.loc)
					new /obj/item/weapon/gun/projectile/automatic/c20r(src.loc)
					new /obj/item/weapon/storage/box/c20ammo(src.loc)
					new /obj/item/weapon/grenade/chem_grenade/heal2(src.loc)
					new /obj/item/ammo_magazine/c45m(src.loc)
					new /obj/item/weapon/storage/firstaid/adv(src.loc)
					for (var/obj/item/weapon/card/id/W in user)
						if(W.assignment == "S-COM Operative")
							W.assignment = "S-COM Combat Medic"

				if("Sniper")
					user.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/jacket(user), slot_wear_suit)
					new /obj/item/ammo_magazine/a50(src.loc)
					new /obj/item/ammo_magazine/a50(src.loc)
					new /obj/item/clothing/accessory/storage/black_vest(src.loc)
					new /obj/item/weapon/reagent_containers/hypospray/autoinjector(src.loc)
					new /obj/item/weapon/storage/box/sniperammo(src.loc)
					new /obj/item/weapon/gun/projectile/sniper(src.loc)
					new /obj/item/weapon/gun/projectile/magnum_pistol(src.loc)
					for (var/obj/item/weapon/card/id/W in user)
						if(W.assignment == "S-COM Operative")
							W.assignment = "S-COM Sniper"

			user.regenerate_icons()
			for(var/obj/machinery/scom/classchanger/CC in machines)
				CC.already_picked |= user

	else
		to_chat(usr, "<span class='warning'>Access denied.</span>")
		return

/obj/machinery/scom/teleporter1
	icon_state = "tele1"
	name = "teleporter"
	anchored = 1
	density = 1

/obj/machinery/scom/teleporter1/attack_hand(var/mob/living/carbon/A)
	. = ..()
	if(A)
		handle_teleport(A)

/obj/machinery/scom/teleporter1/Bumped(var/mob/living/carbon/A)
	if(A)
		handle_teleport(A)
	. = ..()

/obj/machinery/scom/teleporter1/proc/handle_teleport(var/mob/living/carbon/A)
	if(A)
		var/obj/machinery/scom/teleporter2/destination = get_paired_destination()
		if(destination)
			destination.teleport_to(A)

/obj/machinery/scom/teleporter1/proc/get_paired_destination()
	var/obj/machinery/scom/teleporter2/destination
	var/list/all_destinations = list()
	for(var/obj/machinery/scom/teleporter2/T in machines)
		all_destinations += T
	if(all_destinations.len)
		destination = pick(all_destinations)
	return destination

/obj/machinery/scom/teleporter2/proc/teleport_to(var/atom/movable/A)
	if(A && src.loc)
		if(isturf(src.loc))
			var/turf/destination = src.loc
			A.forceMove(destination)
			new /obj/effect/sparks(destination)

/obj/machinery/scom/teleporter2
	icon_state = "tele1"
	name = "teleporter"
	anchored = 1

/obj/machinery/telecomms/relay/preset/scom1
	id = "Centcom1 Relay"
	hide = 1
	toggled = 1
	//anchored = 1
	//use_power = 0
	//idle_power_usage = 0
	produces_heat = 0
	autolinkers = list("s1_relay")

/obj/machinery/telecomms/relay/preset/scom2
	id = "Centcom2 Relay"
	hide = 1
	toggled = 1
	//anchored = 1
	//use_power = 0
	//idle_power_usage = 0
	produces_heat = 0
	autolinkers = list("s2_relay")

/obj/machinery/telecomms/relay/preset/planet
	id = "Planet Relay"
	autolinkers = list("p_relay")