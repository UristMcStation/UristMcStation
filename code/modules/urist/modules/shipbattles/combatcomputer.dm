/obj/machinery/computer/combatcomputer
	name = "weapons control computer"
	desc = "the control centre for the ship's weapons systems."
	anchored = 1
	var/list/linkedweapons = list() //put the weapons in here on their init
	var/shipid = null
	var/target = null
	var/obj/effect/overmap/ship/combat/homeship
	var/fallback_connect = FALSE
/*
/obj/machinery/computer/combatcomputer/attack_hand(user as mob)
	if(..(user))
		return
	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access Denied.</span>")
		return 1

	//quick and dirty hack below, make a real UI for this

	var/list/selectable = list()
	for(var/obj/machinery/shipweapons/SW in linkedweapons)
		if(SW.canfire)
			selectable |= SW

	if(target && homeship.incombat)
		var/obj/machinery/shipweapons/SW = input("Which charged weapon do you wish to fire?") as null|anything in selectable

		if(!istype(SW))
	//		to_chat(usr, "<font color='blue'><b>You don't do anything.</b></font>")
			return

		if(SW.charged && !SW.firing)
			SW.Fire()
			to_chat(user, "<span class='warning'>You fire the [SW.name].</span>")

		else
			to_chat(user, "<span class='warning'>The [SW.name] cannot be fired right now.</span>")

	else
		to_chat(user, "<span class='warning'>The ship is not in combat.</span>")*/

/obj/machinery/computer/combatcomputer/attack_hand(var/mob/user as mob)
	if(..())
		user.unset_machine()
		return

	if(!isAI(user))
		user.set_machine(src)

	if(!fallback_connect) //sometimes connecting is fucky, so this is a fallback in case something fucks up somewhere along the line
		for(var/obj/machinery/shipweapons/S in SSmachines.machinery)
			if(!S.linkedcomputer && S.shipid == src.shipid)
				S.linkedcomputer = src
				linkedweapons += S

		for(var/obj/effect/overmap/ship/combat/C in GLOB.overmap_ships)
			if(C.shipid == src.shipid)
				homeship = C

		for(var/obj/machinery/shipweapons/S in linkedweapons)
			if(!S.homeship)
				S.homeship = homeship

		fallback_connect = TRUE

	ui_interact(user)

/obj/machinery/computer/combatcomputer/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	var/list/weapons[0]
	var/list/targetcomponents[0]

	if(linkedweapons.len)
		for(var/obj/machinery/shipweapons/S in linkedweapons)
			/*var/status
			if(istype(S))
				if(S.canfire)
					status = "Ready to Fire"
				else if(S.recharging)
					status = "Charging"
				else if(!S.canfire)
					status = "Unable to Fire" */

			weapons.Add(list(list(
			"name" = S.name,
			"status" = S.status,
			"strengthhull" = S.hulldamage,
			"strengthshield" = S.shielddamage,
			"shieldpass" = S.passshield,
			"location" = S.loc.loc.name,
			"ref" = "\ref[S]"
			)))
			//maybe change passshield data to ammo?
			data["existing_weapons"] = weapons

	if(target) //come back to this when making pvp
		var/mob/living/simple_animal/hostile/overmapship/OM = target
		var/integrity = (OM.health / OM.maxHealth) * 100
		data["target"] = 1
		data["targetname"] = OM.name
		data["targethealth"] = integrity
		data["targetshield"] = OM.shields

		for(var/datum/shipcomponents/C in OM.components)
			var/status
			if(C.broken)
				status = "Broken"
			else if(!C.broken)
				status = "Operational"

			targetcomponents.Add(list(list(
			"componentname" = C.name,
			"componentstatus" = status,
			"componenttargeted" = C.targeted,
			"ref" = "\ref[C]"
			)))

			data["target_components"] = targetcomponents

	else if(!target)
		data["target"] = 0

//make all the components visible, then kill myself

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "combat_computer.tmpl", name, 1050, 800)
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/computer/combatcomputer/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["fire"])
		if(homeship?.incombat)
			var/obj/machinery/shipweapons/S = locate(href_list["fire"]) in linkedweapons

			if(S?.canfire)

				if(!istype(S))
					return

				if(S.charged && !S.firing)
					S.Fire()
					to_chat(usr, "<span class='warning'>You fire the [S.name].</span>")
					updateUsrDialog()

				else
					to_chat(usr, "<span class='warning'>The [S.name] cannot be fired right now.</span>")

		else
			to_chat(usr, "<span class='warning'>You cannot fire right now.</span>")	//this shouldn't happen

	if(href_list["settarget"])
		if(target)
			var/mob/living/simple_animal/hostile/overmapship/OM = target
			for(var/datum/shipcomponents/SC in OM.components)
				SC.targeted = FALSE

			var/datum/shipcomponents/C = locate(href_list["settarget"]) in OM.components
			C.targeted = TRUE

			for(var/obj/machinery/shipweapons/S in linkedweapons)
				S.targeted_component = C

	if(href_list["unsettarget"])
		for(var/obj/machinery/shipweapons/S in linkedweapons)
			S.targeted_component = null
		if(target)
			var/mob/living/simple_animal/hostile/overmapship/OM = target
			for(var/datum/shipcomponents/C in OM.components)
				C.targeted = FALSE

	updateUsrDialog()

/obj/machinery/computer/combatcomputer/nerva //different def just in case we have multiple ships that do combat. although, i think i might keep the cargo ship noncombat, fluff it as it being too small, slips right by the enemies. i dunno
	name = "ICS Nerva Combat Computer"
	shipid = "nerva"