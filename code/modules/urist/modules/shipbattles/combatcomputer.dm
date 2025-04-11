#define RECHARGING	0x1
#define CHARGED		0x2
#define FIRING		0x4
#define NO_AMMO		0x8
#define LOADING		0x10

/obj/machinery/computer/combatcomputer
	name = "weapons control computer"
	desc = "the control centre for the ship's weapons systems."
	anchored = TRUE
	var/list/linkedweapons = list() //put the weapons in here on their init
	var/shipid = null
	var/target = null
	var/obj/overmap/visitable/ship/combat/homeship
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

/obj/machinery/computer/combatcomputer/New()
	. = ..()
	if(!shipid)	//New computers being built won't have an ID
		for(var/obj/overmap/visitable/ship/combat/C in GLOB.overmap_ships)
			if(src.z in C.map_z)	//See if our loc is within an overmap z level
				var/found = FALSE
				for(var/obj/machinery/computer/combatcomputer/CC in SSmachines.machinery)
					if(CC.homeship == C)	//Already got a combat computer linked? We don't copy the shipid, so this board will not connect. Only 1 allowed!
						found = TRUE
						break
				if(!found)
					src.shipid = C.shipid
					break

/obj/machinery/computer/combatcomputer/Destroy()
	for(var/obj/machinery/shipweapons/S in linkedweapons)
		S.linkedcomputer = null
	. = ..()

/obj/machinery/computer/combatcomputer/attack_hand(mob/user as mob)
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

		for(var/obj/overmap/visitable/ship/combat/C in GLOB.overmap_ships)
			if(C.shipid == src.shipid)
				homeship = C

		for(var/obj/machinery/shipweapons/S in linkedweapons)
			if(!S.homeship)
				S.homeship = homeship

		fallback_connect = TRUE

	ui_interact(user)

/obj/machinery/computer/combatcomputer/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	else ui_interact(user)

/obj/machinery/computer/combatcomputer/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	var/list/weapons[0]
	var/list/targetcomponents[0]

	if(length(linkedweapons))
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
			"status" = S.getStatusString(),
			"strengthhull" = S.hull_damage,
			"strengthshield" = S.shield_damage,
			"shieldpass" = S.pass_shield,
			"location" = S.loc.loc.name,
			"recharge_end" = S.rechargerate,
			"recharge_current" = world.time - S.recharge_init_time,
			"ref" = "\ref[S]"
			)))
			//maybe change pass_shield data to ammo?
			data["existing_weapons"] = weapons

	if(target && istype(target, /mob/living/simple_animal/hostile/overmapship)) //We need a different UI for player ships
		var/mob/living/simple_animal/hostile/overmapship/OM = target
		var/integrity = round(max((OM.health / OM.maxHealth) * 100, 0), 0.01)
		var/maxshields = 0

		for(var/datum/shipcomponents/C in OM.components)
			var/status
			if(C.broken)
				status = "Broken"
			else if(istype(C, /datum/shipcomponents/shield))
				var/datum/shipcomponents/shield/S = C
				maxshields = S.strength
				if(S.overcharged)	//If shields are overcharged, let's display that.
					status = "Overcharged"
				else
					status = "Operational"
			else
				status = "Operational"

			targetcomponents.Add(list(list(
			"componentname" = C.name,
			"componentstatus" = status,
			"componenthealth" = round(max((C.health / initial(C.health) * 100), 0), 0.01),
			"componenttargeted" = C.targeted,
			"ref" = "\ref[C]"
			)))

			data["target_components"] = targetcomponents

		data["status"] = 1
		data["targetname"] = OM.name
		data["targethealth"] = integrity
		data["targetshield"] = OM.shields
		data["targethealthnum"] = OM.health
		data["targetmaxhealth"] = OM.maxHealth
		data["targetmaxshield"] = maxshields

	else if(target && istype(target, /obj/overmap/visitable/ship/combat))
		var/obj/overmap/visitable/ship/combat/OM = target
		data["status"] = 2
		data["targetname"] = OM.ship_name
		data["classification"] = OM.classification
		data["target_flee_timer"] = OM.flee_timer
		data["target_can_escape"] = OM.can_escape
		data["self_flee_type"] = homeship.fleeing
		data["self_flee_timer"] = homeship.flee_timer
		data["self_can_escape"] = homeship.can_escape

	else if(length(homeship.contacts))
		var/list/nearby_contacts[0]
		data["status"] = 3

		for(var/obj/overmap/visitable/ship/combat/OM in homeship.contacts)
			nearby_contacts.Add(list(list(
			"name" = OM.ship_name,
			"classification" = OM.classification,
			"cannotEngage" = OM.incombat || OM.crossed || !OM.canfight || !homeship.canfight || homeship.pvp_cooldown > 0 || OM.pvp_cooldown > 0,
			"ref" = "\ref[OM]"
			)))

			data["nearby_contacts"] = nearby_contacts

	else if(!target)
		data["status"] = 0

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

			if(!istype(S))
				return

			if(S.status == CHARGED)
				to_chat(usr, "<span class='warning'>You fire the [S.name].</span>")
				S.Fire()
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

	if(href_list["intercept"])
		var/obj/overmap/visitable/ship/combat/OM = locate(href_list["intercept"])
		if(!OM.crossed && !OM.incombat && OM.canfight)
			homeship.intercept(OM)
		else
			to_chat(usr, "<span class='warning'>You cannot intercept the [OM.ship_name] right now.</span>")

	if(href_list["startflee"])
		if(!homeship.incombat) return
		homeship.restabilize_engines()

	if(href_list["cancelflee"])
		if(!homeship.incombat || homeship.fleeing != 1)	return
		homeship.cancel_restabilize_engines(TRUE)

	if(href_list["flee"])
		if(!homeship.incombat || !homeship.can_escape && homeship.fleeing != 2) return
		homeship.flee()

	updateUsrDialog()

/obj/machinery/computer/combatcomputer/nerva //different def just in case we have multiple ships that do combat. although, i think i might keep the cargo ship noncombat, fluff it as it being too small, slips right by the enemies. i dunno
	name = "ICS Nerva Combat Computer"
	shipid = "nerva"
