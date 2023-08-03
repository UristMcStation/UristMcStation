/datum/computer_file/program/contract_database
	filename = "contractdatabase"
	filedesc = "Contract Database"
	extended_desc = "This program allows access to the database of contracts currently accepted by the ICS Nerva."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	size = 3
	requires_ntnet = 0
	available_on_ntnet = 0
	nanomodule_path = /datum/nano_module/contract_database
//	usage_flags = PROGRAM_ALL

/datum/nano_module/contract_database
	name = "Contract Database"
	var/display_state = 1
	var/datum/factions/focused
//	var/selected_category
//	var/list/category_names
//	var/list/category_contents

/datum/nano_module/contract_database/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

//	category_contents = list()
	data["display_state"] = display_state

	switch(display_state)
		if(1)	//Contracts
			var/list/category[0]
			for(var/datum/contract/C in GLOB.using_map.contracts)
		//		if(C.is_category())
		//		category_names.Add(C.faction)
		//			category_names.Add(C.name)
				category.Add(list(list(
					"name" = C.name,
					"desc" = C.desc,
					"issuer" = C.faction.name,
					"money" = C.money,
					"amount" = C.amount,
					"progress" = C.completed
				)))
			data["existing_contracts"] = category
		//		category_contents = category

			data["credits"] = "[SSsupply.points]"
			data["currency"] = GLOB.using_map.supply_currency_name
		//	data["categories"] = category_names
		//	if(selected_category)
		//	data["category"] = selected_category
		//	data["existing_contracts"] = category_contents

		if(2)	//Factions
			var/list/factions[0]
			for(var/datum/factions/f in SSfactions.factions)
				var/col = 2 //1 = red, 2 = yellow, 3 = green
				if(f.hostile)
					col = 1
				else
					if(f.reputation < -30)	//-100 to -30 but not hostile
						col = 1
					else if(f.reputation < -10)	//-30 to -10 but not hostile
						col = 2
					else if(f.reputation > 30)	// 30 to 100
						col = 3
					else if (f.reputation > 10)	//10 to 30
						col = 2
				factions.Add(list(list(
					"name" = f.name,
					"col" = col,
					"ref" = "\ref[f]"
				)))
			data["factions"] = factions

		if(3)	//Detailed faction view
			var/col = 2 //1 = red, 2 = yellow, 3 = green
			var/standing = "<span class='average'>Neutral</span>"	//-10 to 10
			if(focused.hostile)
				standing = "<span class='bad'>Hostile</span>"
				col = 1
			else
				if(focused.reputation < -30)	//-100 to -30 but not hostile
					standing = "<span class='bad'>Threatening</span>"
					col = 1
				else if(focused.reputation < -10)	//-30 to -10 but not hostile
					standing = "<span class='average'>Dubious</span>"
					col = 2
				else if(focused.reputation > 30)	// 30 to 100
					standing = "<span class='good'>Friendly</span>"
					col = 3
				else if (focused.reputation > 10)	//10 to 30
					standing = "<span class='average'>Warm</span>"
					col = 2
			data["name"] = focused.name
			data["rep"] = focused.reputation
			data["col"] = col
			data["standing"] = standing
			data["desc"] = focused.desc

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "contract_database.tmpl", name, 1050, 800)
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/contract_database/Topic(href, href_list)
	if(..())
		return ..()

	if(href_list["display_state"])
		display_state = text2num(href_list["display_state"])
		return TOPIC_REFRESH

	if(href_list["return"])
		display_state = 2
		focused = null
		return TOPIC_REFRESH

	if(href_list["more"])
		focused = locate(href_list["more"])
		display_state = 3
		return TOPIC_REFRESH

/*
/datum/nano_module/contract_database/Topic(href, href_list)
//	var/mob/user = usr
	if(..())
		return 1

	if(href_list["select_category"])
		selected_category = href_list["select_category"]
		return 1

	if(href_list["print_summary"])
		if(!can_print())
			return
		print_summary(user)
*/
/*
/datum/nano_module/contract_database/proc/can_print()
	var/obj/item/modular_computer/MC = nano_host()
	if(!istype(MC) || !istype(MC.nano_printer))
		return 0
	return 1

/datum/nano_module/contract_database/proc/print_summary(mob/user)
	var/t = ""
	t += "<center><BR><b><large>[GLOB.using_map.station_name]</large></b><BR><i>[station_date]</i><BR><i>Contract overview<field></i></center><hr>"
	print_text(t, user)
*/
