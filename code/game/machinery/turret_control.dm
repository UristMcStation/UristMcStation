////////////////////////
//Turret Control Panel//
////////////////////////

/// List (`/obj/machinery/turretid`). A list of all turret control panels in the area. Turrets use this list to see if individual power/lethal settings are allowed. Updated during `Initialize()` and `Destroy()` calls on the controllers.
/area/var/list/turret_controls = list()

/obj/machinery/turretid
	name = "turret control panel"
	desc = "Used to control a room's automated defenses."
	icon = 'icons/obj/machines/turret_control.dmi'
	icon_state = "control_standby"
	anchored = TRUE
	density = FALSE
	var/enabled = 0
	var/lethal = 0
	var/locked = 1
	var/area/control_area //can be area name, path or nothing.
	var/mob/living/silicon/ai/master_ai

	var/check_arrest = 1	//checks if the perp is set to arrest
	var/check_records = 1	//checks if a security record exists at all
	var/check_weapons = 0	//checks if it can shoot people that have a weapon they aren't authorized to have
	var/check_access = 1	//if this is active, the turret shoots everything that does not meet the access requirements
	var/check_anomalies = 1	//checks if it can shoot at unidentified lifeforms (ie xenos)
	var/check_synth = 0 	//if active, will shoot at anything not an AI or cyborg
	var/ailock = 0 	//Silicons cannot use this

	req_access = list(access_ai_upload)

/obj/machinery/turretid/stun
	enabled = 1
	icon_state = "control_stun"

/obj/machinery/turretid/lethal
	enabled = 1
	lethal = 1
	icon_state = "control_kill"

/obj/machinery/turretid/Destroy()
	if(control_area)
		var/area/A = control_area
		if(A && istype(A))
			A.turret_controls -= src
	. = ..()

/obj/machinery/turretid/Initialize()
	if(!control_area)
		control_area = get_area(src)
	else if(istext(control_area))
		for(var/area/A in world)
			if(A.name && A.name==control_area)
				control_area = A
				break
	else
		control_area = locate(control_area)

	if(control_area)
		var/area/A = control_area
		if(istype(A))
			A.turret_controls += src
		else
			control_area = null

	updateTurrets()	//Initial settings
	. = ..()

/obj/machinery/turretid/proc/isLocked(mob/user)
	if(ailock && issilicon(user))
		to_chat(user, SPAN_NOTICE("There seems to be a firewall preventing you from accessing this device."))
		return 1

	if(malf_upgraded && master_ai)
		if((user == master_ai) || (user in master_ai.connected_robots))
			return 0
		return 1

	if(locked && !issilicon(user))
		to_chat(user, SPAN_NOTICE("Access denied."))
		return 1

	return 0

/obj/machinery/turretid/CanUseTopic(mob/user)
	if(isLocked(user))
		return STATUS_CLOSE

	return ..()

/obj/machinery/turretid/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(MACHINE_IS_BROKEN(src))
		return FALSE

	if(istype(W, /obj/item/card/id)||istype(W, /obj/item/modular_computer))
		if(allowed(usr))
			if(emagged)
				to_chat(user, SPAN_NOTICE("The turret control is unresponsive."))
			else
				locked = !locked
				to_chat(user, SPAN_NOTICE("You [ locked ? "lock" : "unlock"] the panel."))
		return TRUE

	return ..()

/obj/machinery/turretid/emag_act(remaining_charges, mob/user)
	if(!emagged)
		to_chat(user, SPAN_DANGER("You short out the turret controls' access analysis module."))
		emagged = TRUE
		req_access.Cut()
		locked = 0
		ailock = 0
		return 1

/obj/machinery/turretid/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/turretid/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	var/data[0]
	data["access"] = !isLocked(user)
	data["locked"] = locked
	data["enabled"] = enabled
	data["is_lethal"] = 1
	data["lethal"] = lethal

	if(data["access"])
		var/settings[0]
		settings[LIST_PRE_INC(settings)] = list("category" = "Neutralize All Non-Synthetics", "setting" = "check_synth", "value" = check_synth)
		settings[LIST_PRE_INC(settings)] = list("category" = "Check Weapon Authorization", "setting" = "check_weapons", "value" = check_weapons)
		settings[LIST_PRE_INC(settings)] = list("category" = "Check Security Records", "setting" = "check_records", "value" = check_records)
		settings[LIST_PRE_INC(settings)] = list("category" = "Check Arrest Status", "setting" = "check_arrest", "value" = check_arrest)
		settings[LIST_PRE_INC(settings)] = list("category" = "Check Access Authorization", "setting" = "check_access", "value" = check_access)
		settings[LIST_PRE_INC(settings)] = list("category" = "Check misc. Lifeforms", "setting" = "check_anomalies", "value" = check_anomalies)
		data["settings"] = settings

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "turret_control.tmpl", "Turret Controls", 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/turretid/Topic(href, href_list)
	if(..())
		return 1


	if(href_list["command"] && href_list["value"])
		var/log_action = null

		var/list/toggle = list("disabled","enabled")

		var/value = text2num(href_list["value"])
		if(href_list["command"] == "enable")
			enabled = value
			log_action = "[toggle[enabled+1]] the turrets"
		else if(href_list["command"] == "lethal")
			lethal = value
			log_action = "[toggle[lethal+1]] the turrets lethal mode."
		else if(href_list["command"] == "check_synth")
			check_synth = value
		else if(href_list["command"] == "check_weapons")
			check_weapons = value
		else if(href_list["command"] == "check_records")
			check_records = value
		else if(href_list["command"] == "check_arrest")
			check_arrest = value
		else if(href_list["command"] == "check_access")
			check_access = value
		else if(href_list["command"] == "check_anomalies")
			check_anomalies = value

		if(!isnull(log_action))
			log_and_message_admins("has [log_action]", usr, loc)

		updateTurrets()
		return 1

/obj/machinery/turretid/proc/updateTurrets()
	var/datum/turret_checks/TC = new
	TC.enabled = enabled
	TC.lethal = lethal
	TC.check_synth = check_synth
	TC.check_access = check_access
	TC.check_records = check_records
	TC.check_arrest = check_arrest
	TC.check_weapons = check_weapons
	TC.check_anomalies = check_anomalies
	TC.ailock = ailock

	if(istype(control_area))
		for (var/obj/machinery/porta_turret/aTurret in control_area)
			aTurret.setState(TC)

	queue_icon_update()

/obj/machinery/turretid/on_update_icon()
	..()
	if(!is_powered())
		icon_state = "control_off"
		set_light(0)
	else if (enabled)
		if (lethal)
			icon_state = "control_kill"
			set_light(1.5, 1,"#990000")
		else
			icon_state = "control_stun"
			set_light(1.5, 1,"#ff9900")
	else
		icon_state = "control_standby"
		set_light(1.5, 1,"#003300")

/obj/machinery/turretid/emp_act(severity)
	if(enabled)
		//if the turret is on, the EMP no matter how severe disables the turret for a while
		//and scrambles its settings, with a slight chance of having an emag effect

		check_arrest = pick(0, 1)
		check_records = pick(0, 1)
		check_weapons = pick(0, 1)
		check_access = pick(0, 0, 0, 0, 1)	// check_access is a pretty big deal, so it's least likely to get turned on
		check_anomalies = pick(0, 1)
		locked = pick(0, 1)
		ailock = pick(0, 1)

		enabled=0
		updateTurrets()

		spawn(rand(60,600))
			if(!enabled)
				enabled=1
				updateTurrets()

	..()


/obj/machinery/turretid/malf_upgrade(mob/living/silicon/ai/user)
	..()
	malf_upgraded = 1
	locked = 1
	ailock = 0
	to_chat(user, "\The [src] has been upgraded. It has been locked and can not be tampered with by anyone but you and your cyborgs.")
	master_ai = user
	return 1
