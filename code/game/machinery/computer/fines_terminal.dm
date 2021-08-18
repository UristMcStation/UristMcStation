/obj/machinery/computer/fines
	name = "fine issue terminal"
	icon_state = "guest"
	icon_keyboard = null
	icon_screen = "fines"
	density = 0
	req_access = list(access_hop, access_captain, access_hos, access_security)

	var/display_state = 0
	var/fineNum
	var/machine_id
	var/max_fine = 1000
	var/list/fine_data = list("amount" = null, "author" = null, "reason" = null)
	var/list/action_logs = list()
	var/datum/money_account/target
	var/target_email

/obj/machinery/computer/fines/New()
	..()
	fineNum = rand(1000,2500)
	machine_id = "Fines Terminal #[rand(100,500)]"

/obj/machinery/computer/fines/attack_hand(mob/user)
	if(..())
		user.unset_machine()
		return

	if(!isAI(user))
		user.set_machine(src)

	ui_interact(user)

/obj/machinery/computer/fines/attackby(obj/O, mob/user)
	if(!istype(O, /obj/item/weapon/card/id))
		return ..()

	if(display_state)
		return
	var/obj/item/weapon/card/id/id = O
	if(!id.associated_account_number)
		to_chat(user, "<span class='warning'>\The [src] flashes a warning: Could not retrieve account from ID.</span>")
		playsound(loc, 'sound/machines/buzz-two.ogg', 30)
	else
		target = get_account(id.associated_account_number)
		if(!target)
			to_chat(user, "<span class='warning'>\The [src] flashes a warning: Unable to find associated account.</span>")
			playsound(loc, 'sound/machines/buzz-two.ogg', 30)
		else
			target_email = id.associated_email_login["login"]
			to_chat(user, "<span class='notice'>Account details successfully found!</span>")
			playsound(loc, 'sound/machines/chime.ogg', 30)
			display_state = 1

/obj/machinery/computer/fines/proc/get_auth(var/mob/user)
	var/obj/item/weapon/card/id/auth_card = user.GetIdCard()
	if(!auth_card)
		return 0
	if(access_hop || access_captain || access_hos in auth_card.access)
		return 3
	if(check_access_list(auth_card.access))
		return 2
	else
		return 1

/obj/machinery/computer/fines/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	var/data[0]
	data["state"] = display_state
	data["auth"] = get_auth(user)
	data["has_target"] = !isnull(target)

	switch(display_state)
		if(1)
			data["name"] = target.owner_name
			data["funds"] = target.money
			data["reason"] = fine_data["reason"]
			data["amount"] = fine_data["amount"]
			data["author"] = fine_data["author"]
		if(2)
			data["logs"] = action_logs

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "fines_terminal.tmpl", machine_id, 470, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(0)

/obj/machinery/computer/fines/OnTopic(var/mob/user, var/list/href_list, state)
	if(..())
		return ..()

	if(get_auth(user) < 2)
		return TOPIC_REFRESH

	var/obj/item/weapon/card/id/auth_card = user.GetIdCard()

	if(href_list["state"])
		display_state = text2num(href_list["state"])
		return TOPIC_REFRESH
			
	if(href_list["more"])
		var/k = text2num(href_list["more"])+1
		action_logs[k]["more_details"] = !action_logs[k]["more_details"]
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
				var/input = sanitizeName(input("Who issued the fine?", "Fine Author", auth_card.registered_name) as text)
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
				fine.source_terminal = machine_id
				deposit.target_name = "[target.owner_name] (via [auth_card.registered_name])"
				deposit.purpose = "Fine Revenue (Ref. #[fineNum])"
				deposit.amount = amount
				deposit.date = stationdate2text()
				deposit.time = stationtime2text()
				deposit.source_terminal = machine_id
				target.do_transaction(fine)
				station_account.do_transaction(deposit)

				var/text = "<font size = \"2\">[GLOB.using_map.station_name] Disciplinary Committee</font></center><br><hr><br>"
				text += "<b>Issued to:</b> [target.owner_name]<br>"
				text += "<b>Fine Reference:</b> #[fineNum]<br>"
				text += "<b>Fine Amount:</b> [amount] Th<br>"
				text += "<b>Reason for Issue:</b> [reason]<br>"
				text += "<b>Issued by:</b> [author]<br>"
				text += "<b>Authorising Signature:</b> <span class=\"paper_field\"></span><br>"
				text += "<b>Time:</b> [stationtime2text()]<br>"
				text += "<b>Date:</b> [stationdate2text()]<br><br><br>"
				text += "<font size= \"1\">Terminal: [machine_id]</font>"

				var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(src.loc)
				P.SetName("Notice of Fine Penalty: [target.owner_name]")
				P.info = "<center><img src = nervalogo.png><br>"
				P.info += "<b>Notice of Fine Penalty</b><br>"
				P.info += text
				P.info += "<hr><font size= \"1\">"
				P.info += "This fine penalty has been issued in accordance with [GLOB.using_map.station_name] disciplinary procedures and authorised by the commanding body.<br>"
				P.info += "Any grievances or objections are to be filed and raised with the commanding body. Subject to a 14-day grace period; failed resolutions will subsequently be taken to court in accordance with local space law. Appropriate legal representation may not be guaranteed.<br>"
				P.info += "[GLOB.using_map.station_name] commanding body retains the right to pay any reimbursements in the form of working credits. By accepting this paper issue, you agree to these terms."
				P.info += "</font>"

				var/obj/item/weapon/paper/P2 = new /obj/item/weapon/paper(src.loc)
				P2.SetName("Record of Fine Penalty: [target.owner_name]")
				P2.info = "<center><img src = nervalogo.png><br>"
				P2.info += "<b>Record of Fine Penalty</b><br>"
				P2.info += text
				P2.info += "<hr><font size= \"1\">"
				P2.info += "Administrative copy: Retain this copy for [GLOB.using_map.station_name] record keeping, and supply the notice copy to the penalized party.</font>"

				var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
				stampoverlay.icon_state = "paper_stamp-ward"
				if(!P.stamped)
					P.stamped = new
				P.stamped += /obj/item/weapon/stamp
				P.overlays += stampoverlay
				P.stamps += "<HR><i>This paper has been stamped by the Fine Issue Terminal.</i>"
				P.fields++
				P.updateinfolinks()
				P.update_icon()

				if(!P2.stamped)
					P2.stamped = new
				P2.stamped += /obj/item/weapon/stamp
				P2.overlays += stampoverlay
				P2.stamps += "<HR><i>This paper has been stamped by the Fine Issue Terminal.</i>"
				P2.fields++
				P2.updateinfolinks()
				P2.update_icon()

				playsound(loc, "sound/machines/dotprinter.ogg", 50, 1)

				if(target_email)
					var/datum/computer_file/data/email_account/server = ntnet_global.find_email_by_name(EMAIL_FINANCE)
					if(!server)
						return TOPIC_REFRESH
					var/datum/computer_file/data/email_message/message = new()
					message.title = "[GLOB.using_map.station_name] Account Services System"
					message.stored_data = "<b>**NOTICE OF FINE PENALTY**</b>\n\n[target.owner_name],\n\nA fine of <b>[amount] Th</b> has been issued and taken from your account, authorised by [author]. You should be issued with a paper copy shortly, if you haven't already. If this does not happen, please collect a copy from your accounts manager."
					message.source = server.login
					server.send_mail(target_email, message)

				var/list/log = list()
				log.Add(list(list(
					"time" = stationtime2text(),
					"date" = stationdate2text(),
					"name" = target.owner_name,
					"filed_by" = auth_card.registered_name,
					"author" = author,
					"number" = fineNum,
					"amount" = amount,
					"reason" = reason,
					"more_details" = FALSE
				)))
				action_logs.Add(log)
				fineNum++
				target = null
				target_email = null
				display_state = 0
				fine_data = list("amount" = null, "author" = null, "reason" = null)

				return TOPIC_REFRESH

		return TOPIC_NOACTION
	return TOPIC_NOACTION