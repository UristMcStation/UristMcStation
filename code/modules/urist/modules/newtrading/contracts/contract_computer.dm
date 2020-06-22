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
//	var/selected_category
//	var/list/category_names
//	var/list/category_contents

/datum/nano_module/contract_database/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()

//	category_contents = list()
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

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "contract_database.tmpl", name, 1050, 800, state = state)
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()
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

/datum/nano_module/contract_database/proc/print_summary(var/mob/user)
	var/t = ""
	t += "<center><BR><b><large>[GLOB.using_map.station_name]</large></b><BR><i>[station_date]</i><BR><i>Contract overview<field></i></center><hr>"
	print_text(t, user)
*/