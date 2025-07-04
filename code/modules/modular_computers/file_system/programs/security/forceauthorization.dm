/datum/computer_file/program/forceauthorization
	filename = "forceauthorization"
	filedesc = "Use of Force Authorization Manager"
	extended_desc = "Control console used to activate the NT1019 authorization chip."
	size = 4
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP
	program_icon_state = "security"
	program_key_state = "security_key"
	program_menu_icon = "locked"
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	required_access = access_armory
	nanomodule_path = /datum/nano_module/forceauthorization
	category = PROG_SEC

/datum/nano_module/forceauthorization
	name = "Use of Force Authorization Manager"

/datum/nano_module/forceauthorization/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

	data["registered_guns"] = list()
	data["unregistered_guns"] = list()
	var/atom/movable/AM = nano_host()
	if(!istype(AM))
		return
	var/list/zlevels = GetConnectedZlevels(AM.z)
	for(var/obj/item/gun/G in GLOB.secure_weapons)
		var/out_of_range = FALSE
		var/area_name = "OUT OF RANGE"
		var/turf/T = get_turf(G)
		if(!T || !(T.z in zlevels))
			out_of_range = TRUE
		else
			var/area/A = get_area(T)
			area_name = sanitize(A.name)

		var/list/modes = list()
		for(var/i = 1 to length(G.firemodes))
			if(G.authorized_modes[i] == ALWAYS_AUTHORIZED)
				continue
			var/datum/firemode/firemode = G.firemodes[i]
			modes += list(list("index" = i, "mode_name" = firemode.name, "authorized" = G.authorized_modes[i]))

		if(!isnull(G.registered_owner))
			data["registered_guns"] += list(list("name" = "[G]", "ref" = "\ref[G]", "owner" = G.registered_owner, "modes" = modes, "area" = area_name, "out_of_range" = out_of_range))
		else
			data["unregistered_guns"] += list(list("name" = "[G]", "ref" = "\ref[G]", "modes" = modes, "area" = area_name, "out_of_range" = out_of_range))

	var/list/safes = list()
	for(var/obj/item/storage/secure/alert_safe/S in GLOB.alert_locked)
		var/status
		if(S.secure)
			status = "Secure"
		else if (!S.locked && S.alert_unlocked)
			status = "Open"
		else if(S.alert_unlocked)
			status = "Unlocked"
		else
			if(S.check_arms())
				status = "Pending Lock"
			else
				status = "Missing Arms"

		var/list/safe = list(list(
			"name" = S.name,
			"loc" = S.loc.loc.name,
			"state" = status
			))
		safes.Add(safe)
	data["safes"] = safes

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "forceauthorization.tmpl", name, 700, 450, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/forceauthorization/Topic(href, href_list)
	if(..())
		return TRUE

	if(href_list["gun"] && ("authorize" in href_list) && href_list["mode"])
		var/obj/item/gun/G = locate(href_list["gun"]) in GLOB.secure_weapons
		var/do_authorize = text2num(href_list["authorize"])
		var/mode = text2num(href_list["mode"])
		return isnum(do_authorize) && isnum(mode) && G && G.authorize(mode, do_authorize)

	return FALSE
