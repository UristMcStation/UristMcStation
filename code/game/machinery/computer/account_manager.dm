/obj/machinery/computer/accounts
	name = "account management console"
	desc = "Used to administrate all aspects of financial accounts."
	density = TRUE
	anchored = TRUE
	icon_keyboard = "id_key"
	icon_screen = "comm_logs"
	req_access = list(list(access_hop, access_captain))
	// circuit =/obj/item/stock_parts/circuitboard/account_manager

	var/fineNum
	var/display_state = "payroll"
	var/account_type = null
	var/more_details = FALSE
	var/machine_id = "SO Accounts Management Terminal"
	var/do_fallback = FALSE
	var/copy_mode = FALSE
	var/list/action_logs[0]
	var/list/temp_account_items = list("name" = null, "pay" = null, "jobtitle" = null, "dept" = null, "email" = null)
	var/list/station_departments = list()
	var/datum/money_account/focused_account
	var/datum/mind/target_mind


/obj/machinery/computer/accounts/New()
	..()
	fineNum = rand(300,1000)

/obj/machinery/computer/accounts/Initialize()
	.=..()
	for(var/department in department_accounts)
		if(department == "Vendor")
			continue
		station_departments.Add(department)
	if(!length(station_departments))	//This doesn't always like to populate. Let's make a fallback on first ui interact to avoid nulls
		do_fallback = TRUE

/obj/machinery/computer/accounts/attack_hand(mob/user)
	if(..())
		user.unset_machine()
		return

	if(!isAI(user))
		user.set_machine(src)

	if(do_fallback)
		for(var/department in department_accounts)
			if(department == "Vendor")
				continue
			station_departments.Add(department)
		do_fallback = FALSE

	ui_interact(user)

/obj/machinery/computer/accounts/use_tool(obj/item/I, mob/living/user, list/click_params)
	if(!istype(I, /obj/item/card/id))
		return ..()

	//Although not necessary; it's nice to be able to set the email and account info to the ID, so that they can ID login to email and swipe to pay at vendors
	//We don't want to expose these details to anyone but the crewmember, so we'll copy them over here once account creation is complete
	if(copy_mode && temp_account_items["new_email"])
		var/obj/item/card/id/target_id = O
		var/list/email_login = temp_account_items["new_email"]
		if(target_id.associated_account_number || target_id.associated_email_login["login"])	//So we cannot copy bank details to our own ID card.
			to_chat(user, "<span class='warning'>\The [src] flashes a warning: Unassociated ID card required</span>")
			playsound(loc, 'sound/machines/buzz-two.ogg', 30)
		else
			target_id.associated_account_number = temp_account_items["account"]
			target_id.associated_email_login = email_login.Copy()
			target_id.registered_name = temp_account_items["name"]
			temp_account_items = list("name" = null, "pay" = null, "jobtitle" = null, "dept" = null, "email" = null)
			copy_mode = FALSE
			display_state = "crew_accounts"
			to_chat(user, "<span class='notice'>Account details successfully transferred!</span>")
			playsound(loc, 'sound/machines/chime.ogg', 30)

/obj/machinery/computer/accounts/proc/get_auth(mob/user)
	var/obj/item/card/id/auth_card = user.GetIdCard()
	if(!auth_card)
		return 0	//No ID
	if(check_access_list(auth_card.access))
		return 1	//Correct access
	else
		return 2	//ID but no access

/obj/machinery/computer/accounts/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, var/force_open = 1)

	var/data[0]
	data["state"] = display_state
	data["auth"] = get_auth(user)

	switch(display_state)
		if("dep_accounts")
			var/list/accounts[0]
			accounts.Add(list(list(
			"name" = station_account.owner_name,
			"account_number" = station_account.account_number,
			"funds" = station_account.money,
			"suspended" = station_account.suspended,
			"account_type" = "department",
			"account_ref" = "\ref[station_account]"
			)))
			for(var/department in station_departments)
				var/datum/money_account/currentAccount = department_accounts[department]
				accounts.Add(list(list(
				"name" = currentAccount.owner_name,
				"account_number" = currentAccount.account_number,
				"funds" = currentAccount.money,
				"suspended" = currentAccount.suspended,
				"account_type" = "department",
				"account_ref" = "\ref[currentAccount]"
				)))
			data["accounts"] = accounts

		if("crew_accounts")
			var/list/accounts[0]
			for(var/datum/mind/M in SSticker.minds)
				if(M.initial_account && M.assigned_role)
					var/datum/money_account/currentAccount = M.initial_account
					accounts.Add(list(list(
					"name" = currentAccount.owner_name,
					"account_number" = currentAccount.account_number,
					"funds" = currentAccount.money,
					"suspended" = currentAccount.suspended,
					"account_type" = "personal",
					"owner_ref" = "\ref[M]",
					"account_ref" = "\ref[currentAccount]"
					)))
			data["accounts"] = accounts

		if("payroll")
			var/list/departments = list()
			var/totalpayroll = 0
			for(var/mob/living/carbon/human/H in GLOB.living_players)
				if(!H.mind?.initial_account || !H.mind.assigned_role)
					continue

				if(H.mind.assigned_role == "Captain" && GLOB.using_map.name == "Nerva")
					continue	//We don't pay the captain

				if(H.mind.assigned_role == "Passenger")
					continue	//we don't pay passengers

				var/datum/job/job = SSjobs.titles_to_datums[H.mind.assigned_role]
				var/dept = H.mind.manual_department || (job ? flag2text(job.department_flag) : "Misc")	//We use flags so command staff show under command payroll, rather than their department
				if(dept == "Science" && GLOB.using_map.name == "Nerva")
					continue	//We don't pay NT scientists
				var/pay = H.mind.get_pay()
				var/list/member = list()
				member.Add(list(list(
					"name" = H.real_name,
					"job" = H.mind.assigned_role,
					"pay" = pay,
					"suspended" = H.mind.pay_suspended,
					"ref" = "\ref[H.mind]"
				)))
				if(H.mind.pay_suspended)
					pay = 0
				var/found = FALSE
				for(var/i in departments)	//NanoUI hates working with keyed tables, so we have to do it this way...
					if(i["name"] == dept)
						var/list/e = i["members"]
						e.Add(member)
						i["totalpay"] += pay
						found = TRUE
						break
				if(!found)
					var/list/depart = list()
					depart.Add(list(list(
						"name" = dept,
						"members" = member,
						"totalpay" = pay
					)))
					departments.Add(depart)
				totalpayroll += pay

			data["departments"] = departments
			data["totalpay"] = totalpayroll

		if("account_overview")
			data["name"] = focused_account.owner_name
			data["account_number"] = focused_account.account_number
			data["funds"] = focused_account.money
			data["suspended"] = focused_account.suspended
			data["more_details"] = more_details
			data["account_type"] = account_type

			var/list/transactions = list()
			for(var/datum/transaction/T in focused_account.transaction_log)
				var/list/transaction = list()
				transaction.Add(list(list(
					"target_name" = focused_account.get_transaction_ledger(T),
					"purpose" = T.purpose,
					"amount" = focused_account.get_transaction_amount(T),
					"date" = T.date,
					"time" = T.time
				)))
				transactions.Add(transaction)

			data["transactions"] = transactions
			data["transaction_num"] = length(transactions)

		if("new_account")
			data["name"] = temp_account_items["name"]
			data["owner_ref"] = temp_account_items["owner_ref"]
			data["pay"] = temp_account_items["pay"]
			data["jobtitle"] = temp_account_items["jobtitle"]
			data["dept"] = temp_account_items["dept"]
			data["email"] = temp_account_items["email"]

		if("logs")
			data["logs"] = action_logs

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "account_management.tmpl", "[GLOB.using_map.station_name] Account Management", 900, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(0)

/obj/machinery/computer/accounts/OnTopic(mob/user, var/list/href_list, state)
	if(..())
		return ..()

	if(get_auth(user) != 1)
		return TOPIC_REFRESH

	var/obj/item/card/id/auth_card = user.GetIdCard()

	if(href_list["state"])
		display_state = href_list["state"]
		return TOPIC_REFRESH

	if(href_list["close"])
		display_state = href_list["close"]
		focused_account = null
		target_mind = null
		account_type = null
		more_details = FALSE
		temp_account_items = list("name" = null, "pay" = null, "jobtitle" = null, "dept" = null, "email" = null)
		copy_mode = FALSE
		return TOPIC_REFRESH

	if(href_list["action"])
		switch(href_list["action"])
			if("suspend_account")
				if(!focused_account)
					return TOPIC_NOACTION
				var/confirm = alert("Are you sure you wish to [focused_account.suspended ? "release" : "suspend"] [focused_account.owner_name]'s account?","Suspend Account","Yes","No")
				if(confirm == "No")
					return TOPIC_NOACTION
				focused_account.suspended = !focused_account.suspended
				if(target_mind)
					if(target_mind.initial_email_login["login"])
						var/message
						if(focused_account.suspended)
							message = "[target_mind.name],\n\nDue to suspicious activities, your account has been frozen. Please report to your accounts administrator to rectify this."
						else
							message = "[target_mind.name],\n\nYour account has been released. We apologise for any inconveniences this may have caused."
						email_client(target_mind.initial_email_login["login"], message)
				addLog("ACCOUNT FREEZE", "[focused_account.owner_name], [focused_account.suspended ? "frozen" : "released"]", auth_card)
				return TOPIC_REFRESH

			if("fine_account")
				if(!focused_account || !target_mind)
					return TOPIC_NOACTION
				var/amount = input("How much do you wish to fine [focused_account.owner_name]?", "Fine Amount", 0) as num
				if(!amount)
					return TOPIC_NOACTION
				amount = max(round(amount), 1)	//Remove negative (thus positive) amounts & remove decimals
				var/reason = sanitize(input("What is the reason for the fine?", "Fine Reason") as text,30)
				if(!reason)
					return TOPIC_NOACTION
				var/author = sanitizeName(input("Who issued the fine?", "Fine Author", auth_card.registered_name) as text)	//The person processing the fine may not be the same one issuing it
				if(!author)
					return TOPIC_NOACTION

				if(!focused_account.transfer(station_account, amount, "Fine Issued (Ref. #[fineNum])"))
					alert("Cannot process money transfer. Ensure both accounts are not suspended and have the required funds", "Unable to Fine")
					return TOPIC_NOACTION

				//For those pencil-pushers. Forms to sign and file!
				var/text = "<center><font size = \"2\">[GLOB.using_map.station_name] Disciplinary Committee</font></center><br><hr><br>"
				text += "<b>Issued to:</b> [focused_account.owner_name]<br>"
				text += "<b>Fine Reference:</b> #[fineNum]<br>"
				text += "<b>Fine Amount:</b> [amount] Th<br>"
				text += "<b>Reason for Issue:</b> [reason]<br>"
				text += "<b>Issued by:</b> [author]<br>"
				text += "<b>Authorising Signature:</b> <span class=\"paper_field\"></span><br>"
				text += "<b>Time:</b> [stationtime2text()]<br>"
				text += "<b>Date:</b> [stationdate2text()]<br><br><br>"
				text += "<font size= \"1\">Terminal: [machine_id]</font>"

				var/obj/item/paper/P = new /obj/item/paper(src.loc)
				P.SetName("Notice of Fine Penalty: [focused_account.owner_name]")
				P.info = "<center><img src = [GLOB.using_map.logo]><br>"
				P.info += "<b>Notice of Fine Penalty</b><br></center>"
				P.info += text
				P.info += "<hr><font size= \"1\">"
				P.info += "This fine penalty has been issued in accordance with [GLOB.using_map.station_name] disciplinary procedures and authorised by the commanding body.<br>"
				P.info += "Any grievances or objections are to be filed and raised with the commanding body. Subject to a 14-day grace period; failed resolutions will subsequently be taken to court in accordance with local space law. Appropriate legal representation may not be guaranteed.<br>"
				P.info += "[GLOB.using_map.station_name] commanding body retains the right to pay any reimbursements in the form of working credits. By accepting this paper issue, you agree to these terms."
				P.info += "</font>"

				var/obj/item/paper/P2 = new /obj/item/paper(src.loc)
				P2.SetName("Record of Fine Penalty: [focused_account.owner_name]")
				P2.info = "<center><img src = [GLOB.using_map.logo]><br>"
				P2.info += "<b>Record of Fine Penalty</b><br></center>"
				P2.info += text
				P2.info += "<hr><font size= \"1\">"
				P2.info += "Administrative copy: Retain this copy for [GLOB.using_map.station_name] record keeping, and supply the notice copy to the penalized party.</font>"

				var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
				stampoverlay.icon_state = "paper_stamp-hop"
				if(!P.stamped)
					P.stamped = new
				P.stamped += /obj/item/stamp
				P.overlays += stampoverlay
				P.stamps += "<HR><i>This paper has been stamped by the Second Officer's Desk.</i>"
				P.fields++
				P.updateinfolinks()
				P.update_icon()

				if(!P2.stamped)
					P2.stamped = new
				P2.stamped += /obj/item/stamp
				P2.overlays += stampoverlay
				P2.stamps += "<HR><i>This paper has been stamped by the Second Officer's Desk.</i>"
				P2.fields++
				P2.updateinfolinks()
				P2.update_icon()

				playsound(loc, "sound/machines/dotprinter.ogg", 50, 1)
				fineNum++

				if(target_mind.initial_email_login["login"])
					var/message = "<b>**NOTICE OF FINE PENALTY**</b>\n\n[target_mind.name],\n\nA fine of <b>[amount] Th</b> has been issued and taken from your account, authorised by [author]. You should be issued with a paper copy shortly, if you haven't already. If this does not happen, please collect a copy from your accounts manager."
					email_client(target_mind.initial_email_login["login"], message)
				addLog("FINE ISSUED", "[focused_account.owner_name], [amount] Th authorised by [author]", auth_card)
				return TOPIC_REFRESH

			if("pay_bonus")
				if(!focused_account || !target_mind)
					return TOPIC_NOACTION
				if(focused_account.owner_name == user.name)	//We COULD use their equiped ID here, but that'd be too easy to fake
					alert("You cannot pay yourself a bonus!", "Conflict detected")
					addLog("CONFLICT DETECTED", "Attempted to pay themselves a bonus", auth_card)	//Log the attempt. Shame them.
					return TOPIC_NOACTION
				var/amount = input("Pay them how much? (Enter 0 to cancel)", "Pay Bonus") as num
				if(!amount)
					return TOPIC_NOACTION
				amount = max(round(amount), 1)
				var/author = sanitizeName(input("Who issued the bonus?", "Bonus Author", auth_card.registered_name) as text)
				if(!author)
					return TOPIC_NOACTION
				var/list/sources[0]
				sources.Add(station_account.owner_name)	//Station account is listed differently to the deparment accounts. Let's add it here
				for(var/department in station_departments)
					sources.Add(department)
				var/dept = input("Which department account should pay this?") in sources //Idea from AseaHeru in Discord: Pick which department pays for the bonus!
				var/confirm = alert("Pay [target_mind.name] [amount] Th from [dept]?", "Confirmation", "Yes", "No")
				if(confirm == "No")
					return TOPIC_NOACTION
				var/datum/money_account/dept_account
				if(dept == station_account.owner_name)
					dept_account = station_account
				else
					dept_account = department_accounts[dept]

				if(!dept_account.transfer(focused_account, amount, "Bonus Pay from [author]"))
					alert("Cannot process money transfer. Ensure both accounts are not suspended and have the required funds", "Unable to Pay Bonus")
					return TOPIC_NOACTION

				if(target_mind.initial_email_login["login"])
					var/message = "[target_mind.name],\n\n<b>Congratulations!</b> You have been awarded a bonus of <b>[amount] Th</b> from the [dept_account.owner_name] on behalf of [author]. Keep up the continued hard work!"
					email_client(target_mind.initial_email_login["login"], message)
				addLog("BONUS ISSUED", "[dept_account.owner_name] -> [focused_account.owner_name], [amount] Th by [author]", auth_card)
				return TOPIC_REFRESH

			if("more_details")
				more_details = !more_details
				return TOPIC_REFRESH

			if("edit_pay")
				var/datum/mind/M = locate(href_list["mind"])
				if(!M)
					return TOPIC_NOACTION
				if(M == user.mind)	//Once again, we COULD check their ID against account owner here instead.
					alert("You cannot edit your own pay!", "Conflict detected")
					addLog("CONFLICT DETECTED", "Attempted to edit their own pay", auth_card)
					return TOPIC_NOACTION
				var/currentpay	= text2num(href_list["current_pay"])
				var/newpay = input(user, "Enter new payrate (Enter 0 for job default)", "Edit Payrate", currentpay) as num
				newpay = max(round(newpay), 0)
				if(newpay == currentpay)
					return TOPIC_NOACTION
				if(newpay)
					M.manual_pay_rate = newpay
				else
					M.manual_pay_rate = null	//If we want to use the job default payout, we need to remove this override
					newpay = M.get_pay()

				if(M.initial_email_login["login"])
					var/message = "[M.name],\n\n[newpay > currentpay ? "Congratulations" : "Unfortunately"], your pay has been [newpay > currentpay ? "raised" : "cut"] from <b>[currentpay] Th</b> to <b>[newpay] Th</b>. This will be effective immediately and reflected in your next paycheck."
					email_client(M.initial_email_login["login"], message, EMAIL_PAYROLL)
				addLog("UPDATED PAY", "[M.name], [currentpay] Th -> [newpay] Th", auth_card)
				return TOPIC_REFRESH

			if("suspend_pay")
				var/datum/mind/M = locate(href_list["mind"])
				if(!M)
					return TOPIC_NOACTION
				var/confirm = alert("Are you sure you wish to [M.pay_suspended ? "resume" : "suspend"] [M.name]'s pay?","Suspend Pay","Yes","No")
				if(confirm == "No")
					return TOPIC_NOACTION
				M.pay_suspended = !M.pay_suspended
				if(M.initial_email_login["login"])
					var/message
					if(!M.pay_suspended)
						message = "[M.name],\n\nYour salary has been <b>unsuspended</b> effective immediately and will be processed as per usual at hourly intervals."
					else
						message = "[M.name],\n\nYour salary has been <b>suspended</b> effective immediately and will no longer be processed. Please direct any complaints to your payroll administrator."
					email_client(M.initial_email_login["login"], message, EMAIL_PAYROLL)
				addLog("PAY SUSPENSION", "[M.name], [M.pay_suspended ? "suspended" : "unsuspended"]", auth_card)
				return TOPIC_REFRESH

			if("overview")
				focused_account = locate(href_list["account"])
				account_type = href_list["account_type"]
				target_mind = locate(href_list["owner_ref"])
				if(!focused_account)
					return TOPIC_NOACTION
				display_state = "account_overview"
				return TOPIC_REFRESH
			if("passenger_rate")
				SSpayment_controller.passenger_fee = input(user, "Input desired passenger rate:", "Passenger Rate", SSpayment_controller.passenger_fee) as num
				return TOPIC_REFRESH

		return TOPIC_NOACTION

	if(href_list["new_account_details"])
		switch(href_list["new_account_details"])
			if("owner")
				var/search_name = input(user, "Enter the account holder's name", "New Account Name") as text
				var/datum/mind/M
				for(var/datum/mind/S in SSticker.minds)
					if(S.name == search_name)
						M = S
						break
				if(!M)
					alert("Unable to find [search_name]", "Search Error")
					return TOPIC_NOACTION
				if(M.initial_account)
					alert("[search_name] already has an account!", "Search Error")
					return TOPIC_NOACTION

				temp_account_items["name"] = M.name
				temp_account_items["owner_ref"] = "\ref[M]"
				return TOPIC_REFRESH

			if("job")
				var/jobtitle = sanitize(input(user, "Enter the desired job title", "New Account Job", temp_account_items["jobtitle"]) as text)
				if(!jobtitle)
					return TOPIC_NOACTION
				temp_account_items["jobtitle"] = jobtitle
				return TOPIC_REFRESH

			if("pay")
				var/pay = input(user, "Enter a payrate (Enter 0 for job standard)", "New Account Pay", temp_account_items["pay"]) as num
				pay = max(round(pay), 0)
				temp_account_items["pay"] = pay
				return TOPIC_REFRESH

			if("dept")	//If a correct jobtitle is added, then we'll use the job datum's dept. This is a fallback if the job couldn't be found, or is a made-up position
				var/dept = input(user, "Pick a department", "New Account Department") in station_departments
				temp_account_items["dept"] = dept
				return TOPIC_REFRESH

			if("email")
				var/email = sanitize_for_email(input(user,"Pick an email name (Excluding domain)", "New Account Email", temp_account_items["email"]) as text)
				if(!email)
					return TOPIC_NOACTION
				if(length(email) > 20)
					alert("Domain name is too long!", "Domain Name Error")
					return TOPIC_NOACTION
				temp_account_items["email"] = email
				return TOPIC_REFRESH

			if("create")
				for(var/i in temp_account_items)	//Roll through all fields and make sure they're present
					if(!temp_account_items[i] && i != "pay")	//Excluding pay. This can be 0 to use job default pay
						alert("Missing field: [i]","Account Creation Error")
						return TOPIC_NOACTION
				var/datum/mind/M = locate(temp_account_items["owner_ref"])
				if(!istype(M))
					return TOPIC_NOACTION

				var/datum/job/job = SSjobs.titles_to_datums[temp_account_items["jobtitle"]]
				if(!job)	//If an incorrect/custom jobtitle was used, use the department fallback
					job = SSjobs.titles_to_datums["Assistant"]	//We assign them the assistant job datum, so they at least register as crew
					M.manual_department = temp_account_items["dept"]

				M.assigned_job = job
				M.assigned_role = temp_account_items["jobtitle"]
				M.manual_pay_rate = temp_account_items["pay"]
				ntnet_global.create_email(M.current, temp_account_items["email"], "freemail.net")
				var/datum/money_account/acc = create_account("[M.current.real_name]'s account", M.current.real_name, 0)
				var/datum/transaction/singular/T = new(acc, machine_id, 0, "Account creation")
				acc.transaction_log[1] = T
				M.initial_account = acc

				//More paperwork! This time for pins and account info. Only the crewmember should know this, so we'll put it in an envelope with a seal
				var//obj/item/material/folder/envelope/P = new /obj/item/material/folder/envelope(src.loc)
				P.name = "envelope - Account Details: [acc.owner_name] (CONFIDENTIAL)"
				P.desc += "\nA large red label on the front reads \"CONFIDENTIAL - For account holder eyes only\""
				var/obj/item/paper/R = new /obj/item/paper(P)

				R.SetName("Account information: [acc.owner_name]")
				R.info = "<center><img src = [GLOB.using_map.logo]><br>"
				R.info += "<b>New Account Details</b><br>"
				R.info += "<font size = \"2\">Strictly Confidential</font></center><br><hr><br>"
				R.info += "Welcome, [acc.owner_name], to the [GLOB.using_map.station_name]. Please find bellow all relevant account details that have been assigned to you.<br>"
				R.info += "Be sure to keep these safe and shred this paper once memorised.<br><br><br>"
				R.info += "<h4><b><u>Bank Account Details:</u></b></h4><br>"
				R.info += "<b>Account holder:</b> [acc.owner_name]<br>"
				R.info += "<b>Account number:</b> [acc.account_number]<br>"
				R.info += "<b>Account pin:</b> [acc.remote_access_pin]<br>"
				R.info += "<b>Starting balance:</b> [acc.money] Th<br><br><br>"
				R.info += "<h4><b><u>Email Account Details:</u></b></h4><br>"
				R.info += "<b>Address:</b> [M.initial_email_login["login"]]<br>"
				R.info += "<b>Password:</b> [M.initial_email_login["password"]]<br><br>"
				R.info += "<b>Time:</b> [stationtime2text()]<br>"
				R.info += "<b>Date:</b> [stationdate2text()]<br><br><br>"
				R.info += "<b>Creation terminal ID:</b> [machine_id]<br>"
				R.info += "<b>Authorised officer overseeing creation:</b> [auth_card.registered_name], [auth_card.assignment]<br>"

				var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
				stampoverlay.icon_state = "paper_stamp-hop"
				if(!R.stamped)
					R.stamped = new
				R.stamped += /obj/item/stamp
				R.overlays += stampoverlay
				R.stamps += "<HR><i>This paper has been stamped by the Second Officer's Desk.</i>"
				R.update_icon()

				playsound(loc, "sound/machines/dotprinter.ogg", 50, 1)

				temp_account_items = list("new_email" = M.initial_email_login.Copy(), "account" = acc.account_number, "name" = M.current.real_name)
				display_state = "copy"
				copy_mode = TRUE
				addLog("ACCOUNT CREATION", acc.owner_name, auth_card)
				return TOPIC_REFRESH
		return TOPIC_NOACTION

	return TOPIC_NOACTION

/obj/machinery/computer/accounts/proc/email_client(address, var/txt, var/sending = EMAIL_FINANCE)
	if(!address || !txt)
		return
	var/datum/computer_file/data/email_account/server = ntnet_global.find_email_by_name(sending)
	if(!server)
		return
	var/datum/computer_file/data/email_message/message = new()
	if(sending == EMAIL_FINANCE)
		message.title = "[GLOB.using_map.station_name] Account Services System"
	else
		message.title = "[GLOB.using_map.station_name] Automated Payroll System"
	message.stored_data = txt
	message.source = server.login
	server.send_mail(address, message)

/obj/machinery/computer/accounts/proc/addLog(action, var/details, var/obj/item/card/id/auth_card)
	if(!details || !action || !auth_card)
		return
	var/log = "\[[stationdate2text()] [stationtime2text()]] - [auth_card.registered_name] ([auth_card.assignment]) - \[[action]]: [details]"
	action_logs.Add(log)

/obj/machinery/computer/accounts/proc/flag2text(bitflag)
	if(!bitflag)
		return null
	if(bitflag & COM)
		return "Command"
	if(bitflag & CIV)
		return "Civillian"
	if(bitflag & SUP)
		return "Supply"
	if(bitflag & SPT)
		return "Support"
	if(bitflag & SEC)
		return "Security"
	if(bitflag & ENG)
		return "Engineering"
	if(bitflag & MED)
		return "Medical"
	if(bitflag & SCI)
		return "Science"
	if(bitflag & SRV)
		return "Service"
	if(bitflag & EXP)
		return "Exploration"
	return "Misc"
