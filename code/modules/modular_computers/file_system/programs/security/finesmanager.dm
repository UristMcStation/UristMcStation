GLOBAL_LIST_INIT(all_fines, list("fineNum" = rand(1000,2500), "records" = list()))

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

/datum/nano_module/program/finesmanager
	name = "Fines Manager"
	var/display_state = 0
	var/max_fine = 1000
	var/list/fine_data = list("amount" = null, "author" = null, "reason" = null)
	var/list/log_info = list()
	var/datum/money_account/target
	var/target_email

/datum/nano_module/program/finesmanager/proc/get_auth(var/mob/user)
	get_access(user)
	if(!using_access)
		return 0
	if(check_access(user, list(list(access_hop, access_captain, access_hos))))
		return 3
	if(check_access(user, program.required_access))
		return 2
	else
		return 1

/datum/nano_module/program/finesmanager/proc/scan_id(var/mob/user)
	var/obj/item/weapon/card/id/id
	if(program.computer.card_slot)
		id = program.computer.card_slot.stored_card
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

/datum/nano_module/program/finesmanager/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = program.computer.initial_data()

	data["state"] = display_state
	data["auth"] = get_auth(user)
	data["has_target"] = !isnull(target)
	data["has_cardslot"] = !isnull(program.computer.card_slot)
	
	if(program.computer.card_slot)
		data["id"] = !isnull(program.computer.card_slot.stored_card)
		data["id_text"] = data["id"] ? program.computer.card_slot.stored_card.registered_name : "--------"

	switch(display_state)
		if(1)
			data["name"] = target.owner_name
			data["funds"] = target.money
			data["reason"] = fine_data["reason"]
			data["amount"] = fine_data["amount"]
			data["author"] = fine_data["author"]
		if(2)
			var/list/logs = GLOB.all_fines["records"].Copy()
			for(var/i=1, i <= length(logs), i++)
				logs[i]["more_details"] = log_info["[i]"]
			data["logs"] = logs

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "fines_terminal.tmpl", name, 480, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(0)

/datum/nano_module/program/finesmanager/proc/print(var/mob/user, var/title, var/text)
	if(!program.computer.nano_printer)
		to_chat(user, "<span class='warning'>Error: No printer detected. Unable to print document.</span>")
		return FALSE
	if(!program.computer.nano_printer.print_text(text, title))
		to_chat(user, "<span class='warning'>Error: Printer was unable to print the document. It may be out of paper.</span>")
		return FALSE
	return TRUE

/datum/nano_module/program/finesmanager/proc/re_print(var/mob/user, var/index)
	if(!index)
		return
	if(!program.computer.nano_printer)
		to_chat(user, "<span class='warning'>Error: No printer detected. Unable to print document.</span>")
		return

	var/list/fine = GLOB.all_fines["records"][index]
	if(!length(fine))
		return

	var/main = "<font size = \"2\">[GLOB.using_map.station_name] Disciplinary Committee</font></center><br><hr><br>"
	main += "<b>Issued to:</b> [fine["name"]]<br>"
	main += "<b>Fine Reference:</b> #[fine["number"]]<br>"
	main += "<b>Fine Amount:</b> [fine["amount"]] Th<br>"
	main += "<b>Reason for Issue:</b> [fine["reason"]]<br>"
	main += "<b>Issued by:</b> [fine["author"]]<br>"
	main += "<b>Authorising Signature:</b> <span class=\"paper_field\"></span><br>"
	main += "<b>Time:</b> [fine["time"]]<br>"
	main += "<b>Date:</b> [fine["date"]]<br><br><br>"

	var/paper1_txt = "<center><img src = nervalogo.png><br>"
	paper1_txt += "<b>Notice of Fine Penalty</b><br>"
	paper1_txt += main
	paper1_txt += "<hr><font size= \"1\">"
	paper1_txt += "This fine penalty has been issued in accordance with [GLOB.using_map.station_name] disciplinary procedures and authorised by the commanding body.<br>"
	paper1_txt += "Any grievances or objections are to be filed and raised with the commanding body. Subject to a 14-day grace period; failed resolutions will subsequently be taken to court in accordance with local space law. Appropriate legal representation may not be guaranteed.<br>"
	paper1_txt += "[GLOB.using_map.station_name] commanding body retains the right to pay any reimbursements in the form of working credits. By accepting this paper issue, you agree to these terms."
	paper1_txt += "</font>"

	var/paper2_txt = "<center><img src = nervalogo.png><br>"
	paper2_txt += "<b>Record of Fine Penalty</b><br>"
	paper2_txt += main
	paper2_txt += "<hr><font size= \"1\">"
	paper2_txt += "Administrative copy: Retain this copy for [GLOB.using_map.station_name] record keeping, and supply the notice copy to the penalized party.</font>"

	if(print(user, "Notice of Fine Penalty: [fine["name"]]", paper1_txt))
		print(user, "Record of Fine Penalty: [fine["name"]]", paper2_txt)
		playsound(program.computer, "sound/machines/dotprinter.ogg", 50, 1)

/datum/nano_module/program/finesmanager/Topic(href, href_list)
	if(..())
		return ..()

	var/mob/user = usr

	if(get_auth(user) < 2)
		return TOPIC_REFRESH

	var/obj/item/weapon/card/id/auth_card = user.GetIdCard()

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
		program.computer.proc_eject_id(user)
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
					input = Clamp(round(input),1,max_fine)
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

				if(target.money - amount < 0)
					alert("Insufficient account funds (Amount short: [amount - target.money] Th)", "Unable to Fine")
					return TOPIC_NOACTION

				var/datum/transaction/fine = new()
				var/datum/transaction/deposit = new()

				fine.target_name = "[station_account.owner_name] (via [auth_card.registered_name])"
				fine.purpose = "Fine Issued (Ref. #[fineNum])"
				fine.amount = -amount
				fine.date = stationdate2text()
				fine.time = stationtime2text()
				fine.source_terminal = "Fines Manager"
				deposit.target_name = "[target.owner_name] (via [auth_card.registered_name])"
				deposit.purpose = "Fine Revenue (Ref. #[fineNum])"
				deposit.amount = amount
				deposit.date = stationdate2text()
				deposit.time = stationtime2text()
				deposit.source_terminal = "Fines Manager"
				target.do_transaction(fine)
				station_account.do_transaction(deposit)

				var/main = "<font size = \"2\">[GLOB.using_map.station_name] Disciplinary Committee</font></center><br><hr><br>"
				main += "<b>Issued to:</b> [target.owner_name]<br>"
				main += "<b>Fine Reference:</b> #[fineNum]<br>"
				main += "<b>Fine Amount:</b> [amount] Th<br>"
				main += "<b>Reason for Issue:</b> [reason]<br>"
				main += "<b>Issued by:</b> [author]<br>"
				main += "<b>Authorising Signature:</b> <span class=\"paper_field\"></span><br>"
				main += "<b>Time:</b> [stationtime2text()]<br>"
				main += "<b>Date:</b> [stationdate2text()]<br><br><br>"

				var/paper1_txt = "<center><img src = nervalogo.png><br>"
				paper1_txt += "<b>Notice of Fine Penalty</b><br>"
				paper1_txt += main
				paper1_txt += "<hr><font size= \"1\">"
				paper1_txt += "This fine penalty has been issued in accordance with [GLOB.using_map.station_name] disciplinary procedures and authorised by the commanding body.<br>"
				paper1_txt += "Any grievances or objections are to be filed and raised with the commanding body. Subject to a 14-day grace period; failed resolutions will subsequently be taken to court in accordance with local space law. Appropriate legal representation may not be guaranteed.<br>"
				paper1_txt += "[GLOB.using_map.station_name] commanding body retains the right to pay any reimbursements in the form of working credits. By accepting this paper issue, you agree to these terms."
				paper1_txt += "</font>"

				var/paper2_txt = "<center><img src = nervalogo.png><br>"
				paper2_txt += "<b>Record of Fine Penalty</b><br>"
				paper2_txt += main
				paper2_txt += "<hr><font size= \"1\">"
				paper2_txt += "Administrative copy: Retain this copy for [GLOB.using_map.station_name] record keeping, and supply the notice copy to the penalized party.</font>"

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
				GLOB.all_fines["records"].Add(logs)
				GLOB.all_fines["fineNum"]++
				target = null
				target_email = null
				display_state = 0
				fine_data = list("amount" = null, "author" = null, "reason" = null)

				return TOPIC_REFRESH

		return TOPIC_NOACTION
	return TOPIC_NOACTION