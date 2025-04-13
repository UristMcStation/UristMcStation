GLOBAL_LIST_AS(all_fines, list("fineNum" = rand(1000,2500), "records" = list()))

/datum/computer_file/program/finesmanager
	filename = "digitalfines"
	filedesc = "Fines Manager"
	extended_desc = "Official NTsec program for the creation and management of fine penalties"
	program_icon_state = "warrant"
	program_key_state = "security_key"
	program_menu_icon = "notice"
	size = 8
	requires_ntnet = 1
	available_on_ntnet = 1
	requires_access_to_download = 1
	required_access = access_security
	nanomodule_path = /datum/nano_module/program/finesmanager
	usage_flags = PROGRAM_ALL
	category = PROG_SEC

/datum/nano_module/program/finesmanager
	name = "Fines Manager"
	var/display_state = 0
	var/max_fine = 1000
	var/list/fine_data = list("amount" = null, "author" = null, "reason" = null)
	var/list/log_info = list()
	var/datum/money_account/target
	var/target_email

/datum/nano_module/program/finesmanager/proc/get_auth(mob/user)
	get_access(user)
	if(!using_access)
		return 0
	if(check_access(user, list(list(access_hop, access_captain, access_hos))))
		return 3
	if(check_access(user, program.required_access))
		return 2
	else
		return 1

/datum/nano_module/program/finesmanager/proc/scan_id(mob/user)
	var/obj/item/card/id/id
	var/obj/item/stock_parts/computer/card_slot/card_slot = program.computer.get_component(PART_CARD)
	if(card_slot)
		id = card_slot.stored_card
	if(!id)
		to_chat(user, "<span class='warning'>\The [program.computer] flashes a warning: No ID card inserted. Please insert one and try again.</span>")
		playsound(program.computer, 'sound/machines/buzz-two.ogg', 30)
		return FALSE
	if(!id.associated_account_number)
		to_chat(user, "<span class='warning'>\The [program.computer] flashes a warning: Could not retrieve account from ID.</span>")
		playsound(program.computer, 'sound/machines/buzz-two.ogg', 30)
		return FALSE
	else
		target = get_account(id.associated_account_number)
		if(!target)
			to_chat(user, "<span class='warning'>\The [program.computer] flashes a warning: Unable to find associated account.</span>")
			playsound(program.computer, 'sound/machines/buzz-two.ogg', 30)
			return FALSE
		else
			target_email = id.associated_email_login["login"]
			to_chat(user, "<span class='notice'>Account details successfully found!</span>")
			playsound(program.computer, 'sound/machines/chime.ogg', 30)
			display_state = 1
			return TRUE

/datum/nano_module/program/finesmanager/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = program.computer.initial_data()
	var/obj/item/stock_parts/computer/card_slot/card_slot = program.computer.get_component(PART_CARD)


	data["state"] = display_state
	data["auth"] = get_auth(user)
	data["has_target"] = !isnull(target)
	data["has_cardslot"] = !!card_slot

	if(card_slot)
		data["id"] = !isnull(card_slot.stored_card)
		data["id_text"] = data["id"] ? card_slot.stored_card.registered_name : "--------"

	switch(display_state)
		if(1)
			data["name"] = target.owner_name
			data["funds"] = target.money
			data["reason"] = fine_data["reason"]
			data["amount"] = fine_data["amount"]
			data["author"] = fine_data["author"]
		if(2)
			var/list/f = GLOB.all_fines["records"]
			var/list/logs = f.Copy()
			for(var/i=1, i <= length(logs), i++)
				logs[i]["more_details"] = log_info["[i]"]
			data["logs"] = logs

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "fines_terminal.tmpl", name, 480, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(0)

/datum/nano_module/program/finesmanager/proc/print(mob/user, title, text)
	if(!program.computer.has_component(PART_PRINTER))
		to_chat(src, SPAN_WARNING("Hardware Error: Printer not found."))
		return FALSE
	if(!program.computer.print_paper(text, title))
		to_chat(src, SPAN_WARNING("Error: Printer was unable to print the document. It may be out of paper."))
	return TRUE

/datum/nano_module/program/finesmanager/proc/re_print(mob/user, index)
	if(!index)
		return
	if(!program.computer.has_component(PART_PRINTER))
		to_chat(src, SPAN_WARNING("Error: No printer detected. Unable to print document."))
		return

	var/list/fine = GLOB.all_fines["records"][index]
	if(!length(fine))
		return

	var/main = "<center><font size = \"2\">[GLOB.using_map.station_name] Disciplinary Committee</center></font><br><hr><br>"
	main += "<b>Issued to:</b> [fine["name"]]<br>"
	main += "<b>Fine Reference:</b> #[fine["number"]]<br>"
	main += "<b>Fine Amount:</b> [fine["amount"]] Th<br>"
	main += "<b>Reason for Issue:</b> [fine["reason"]]<br>"
	main += "<b>Issued by:</b> [fine["author"]]<br>"
	main += "<b>Authorising Signature:</b> <span class=\"paper_field\"></span><br>"
	main += "<b>Time:</b> [fine["time"]]<br>"
	main += "<b>Date:</b> [fine["date"]]<br><br><br>"

	var/paper1_txt = "<center><img src = [GLOB.using_map.logo]><br>"
	paper1_txt += "<b>Notice of Fine Penalty</b><br></center>"
	paper1_txt += main
	paper1_txt += "<hr><font size= \"1\">"
	paper1_txt += "This fine penalty has been issued in accordance with [GLOB.using_map.station_name] disciplinary procedures and authorised by the commanding body.<br>"
	paper1_txt += "Any grievances or objections are to be filed and raised with the commanding body. Subject to a 14-day grace period; failed resolutions will subsequently be taken to court in accordance with local space law. Appropriate legal representation may not be guaranteed.<br>"
	paper1_txt += "[GLOB.using_map.station_name] commanding body retains the right to pay any reimbursements in the form of working credits. By accepting this paper issue, you agree to these terms."
	paper1_txt += "</font>"

	var/paper2_txt = "<center><img src = [GLOB.using_map.logo]><br>"
	paper2_txt += "<b>Record of Fine Penalty</b><br></center>"
	paper2_txt += main
	paper2_txt += "<hr><font size= \"1\">"
	paper2_txt += "Administrative copy: Retain this copy for [GLOB.using_map.station_name] record keeping, and supply the notice copy to the penalized party.</font>"

	if(print(user, "Notice of Fine Penalty: [fine["name"]]", paper1_txt))
		print(user, "Record of Fine Penalty: [fine["name"]]", paper2_txt)
		playsound(program.computer, "sound/machines/dotprinter.ogg", 50, 1)

/datum/nano_module/program/finesmanager/Topic(href, href_list)
	var/obj/item/stock_parts/computer/card_slot/card_slot = program.computer.get_component(PART_CARD)
	if(..())
		return ..()

	var/mob/user = usr

	if(get_auth(user) < 2)
		return TOPIC_REFRESH

	var/obj/item/card/id/auth_card = user.GetIdCard()

	if(href_list["state"])
		display_state = text2num(href_list["state"])
		return TOPIC_REFRESH

	if(href_list["more"])
		var/k = text2num(href_list["more"])+1
		log_info["[k]"] = !log_info["[k]"]
		return TOPIC_REFRESH

	if(href_list["scan"])
		scan_id(user)
		return TOPIC_REFRESH

	if(href_list["eject"])
		card_slot.eject_id(user)
		return TOPIC_REFRESH

	if(href_list["print"])
		var/k = text2num(href_list["print"])+1
		re_print(user, k)
		return TOPIC_REFRESH

	if(href_list["action"])
		if(!target)
			return TOPIC_NOACTION

		switch(href_list["action"])
			if("cancel")
				target = null
				target_email = null
				fine_data = list("amount" = null, "author" = null, "reason" = null)
				display_state = 0
				return TOPIC_REFRESH

			if("amount")
				var/input = input("How much do you wish to fine [target.owner_name]?", "Fine Amount", 0) as num
				if(!input)
					return TOPIC_NOACTION
				if(get_auth(user) == 2)
					input = clamp(round(input),1,max_fine)
				else
					input = max(round(input), 1)
				if(target.money - input < 0)
					alert("Insufficient account funds (Amount short: [input - target.money] Th)", "Unable to Fine")
					return TOPIC_NOACTION
				fine_data["amount"] = input
				return TOPIC_REFRESH

			if("reason")
				var/input = sanitize(input("What is the reason for the fine?", "Fine Reason") as text, 30)
				if(!input)
					return TOPIC_NOACTION
				fine_data["reason"] = input
				return TOPIC_REFRESH

			if("author")
				var/input = sanitizeName(input("Who issued the fine?", "Fine Author", auth_card ? auth_card.registered_name : null) as text)
				if(!input)
					return TOPIC_NOACTION
				fine_data["author"] = input
				return TOPIC_REFRESH

			if("complete")
				for(var/i in fine_data)
					if(!fine_data[i])
						alert("Missing field: [i]","Issue Fine Error")
						return TOPIC_NOACTION

				var/amount = fine_data["amount"]
				var/author = fine_data["author"]
				var/reason = fine_data["reason"]
				var/fineNum = GLOB.all_fines["fineNum"]

				if(!target.transfer(station_account, amount, "Fine Issued (Ref. #[fineNum])"))
					alert("Cannot process money transfer. Ensure both accounts are not suspended and have the required funds", "Unable to Fine")
					return TOPIC_NOACTION

				var/main = "<center><font size = \"2\">[GLOB.using_map.station_name] Disciplinary Committee</font></center><br><hr><br>"
				main += "<b>Issued to:</b> [target.owner_name]<br>"
				main += "<b>Fine Reference:</b> #[fineNum]<br>"
				main += "<b>Fine Amount:</b> [amount] Th<br>"
				main += "<b>Reason for Issue:</b> [reason]<br>"
				main += "<b>Issued by:</b> [author]<br>"
				main += "<b>Authorising Signature:</b> <span class=\"paper_field\"></span><br>"
				main += "<b>Time:</b> [stationtime2text()]<br>"
				main += "<b>Date:</b> [stationdate2text()]<br><br><br>"

				var/paper1_txt = "<center><img src = [GLOB.using_map.logo]><br>"
				paper1_txt += "<b>Notice of Fine Penalty</b><br>"
				paper1_txt += main
				paper1_txt += "<hr><font size= \"1\">"
				paper1_txt += "This fine penalty has been issued in accordance with [GLOB.using_map.station_name] disciplinary procedures and authorised by the commanding body.<br>"
				paper1_txt += "Any grievances or objections are to be filed and raised with the commanding body. Subject to a 14-day grace period; failed resolutions will subsequently be taken to court in accordance with local space law. Appropriate legal representation may not be guaranteed.<br>"
				paper1_txt += "[GLOB.using_map.station_name] commanding body retains the right to pay any reimbursements in the form of working credits. By accepting this paper issue, you agree to these terms."
				paper1_txt += "</font></center>"

				var/paper2_txt = "<center><img src = [GLOB.using_map.logo]><br>"
				paper2_txt += "<b>Record of Fine Penalty</b><br>"
				paper2_txt += main
				paper2_txt += "<hr><font size= \"1\">"
				paper2_txt += "Administrative copy: Retain this copy for [GLOB.using_map.station_name] record keeping, and supply the notice copy to the penalized party.</font></center>"

				if(print(user, "Notice of Fine Penalty: [target.owner_name]", paper1_txt))
					print(user, "Record of Fine Penalty: [target.owner_name]", paper2_txt)
					playsound(program.computer, "sound/machines/dotprinter.ogg", 50, 1)

				if(target_email)
					var/datum/computer_file/data/email_account/server = ntnet_global.find_email_by_name(EMAIL_FINANCE)
					if(!server)
						return TOPIC_REFRESH
					var/datum/computer_file/data/email_message/message = new()
					message.title = "[GLOB.using_map.station_name] Account Services System"
					message.stored_data = "<b>**NOTICE OF FINE PENALTY**</b>\n\n[target.owner_name],\n\nA fine of <b>[amount] Th</b> has been issued and taken from your account, authorised by [author]. You should be issued with a paper copy shortly, if you haven't already. If this does not happen, please collect a copy from your accounts manager."
					message.source = server.login
					server.send_mail(target_email, message)

				var/list/logs = list()
				logs.Add(list(list(
					"time" = stationtime2text(),
					"date" = stationdate2text(),
					"name" = target.owner_name,
					"filed_by" = auth_card.registered_name,
					"author" = author,
					"number" = fineNum,
					"amount" = amount,
					"reason" = reason
				)))
				var/list/g = GLOB.all_fines["records"]
				g.Add(logs)
				GLOB.all_fines["fineNum"]++
				target = null
				target_email = null
				display_state = 0
				fine_data = list("amount" = null, "author" = null, "reason" = null)

				return TOPIC_REFRESH

		return TOPIC_NOACTION
	return TOPIC_NOACTION
