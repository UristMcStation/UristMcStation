SUBSYSTEM_DEF(payment_controller)
	name = "Payment"
	wait = 15 SECONDS
	var/timerbuffer = 60 MINUTES //buffer for time check
	var/list/brand = list("Cheesie Honkers", "Men At Arms Tobacco", "Lucky Stars Cigarettes", "Carcinoma Angels Cigarettes", "Robust Coffee", "Getmore Chocolate Corp products", "4no Raisins", "SweatMax products", "Space Cola", "Space Mountain Wind", "Dr.Gibb", "ClothingLord 9000 Clothes", "NanoTrasen Personal Computers", "Rougelady Chewing Tobacco", "Robust Softdrinks products") //this is just for the jokes
	var/list/slogan = list("Now with 18% less carcinogens!", "Lawsuit free since 2579!", "Leading doctors only moderately advise against our products!", "Now occasionally without illegal narcotics!", "Now complying with 94% of trading standards laws!", "Condemned by the Space Pope!", "Larva-tested, pupa-approved", "For external use only", "Fun for the whole family except grandma and grandpa", "Beats a hard kick in the face", "The proud result of prison labor!", "No refunds", "For the sophisticated shut-in", "Tell your parents it's educational!")
	var/payment_modifier = 5 //economic_power * this number = pay. tweak this number!
	var/moneybuffer = 0 //how much money are we removing from the nerva's account?
	var/total_paid = 0 //how much money have we paid out in total

/datum/controller/subsystem/payment_controller/fire()
	if (TimeUntilPayday() <= 0)
		timerbuffer += 60 MINUTES

		if(station_account.money <= 0) //we can go into debt, a bit, but then we can't pay people anymore.
			GLOB.global_announcer.autosay("<b>Hourly salary payments have been not been processed due to a lack of funds. Please direct all criticism towards the Captain.</b>", "[GLOB.using_map.station_name] Automated Payroll System", "Common")
			return

		else
			PayPeople()
			var/newbrand = pick(brand) //this is a dumb meme
			GLOB.global_announcer.autosay("<b>Hourly salary payments have been processed and deposited into your accounts. Thank you for your service to the [GLOB.using_map.station_name]. This message is brought to you by [newbrand]: make sure to buy [newbrand] at your nearest vending machine.</b>", "[GLOB.using_map.station_name] Automated Payroll System", "Common")
			total_paid += moneybuffer
			var/datum/transaction/T = new("[GLOB.using_map.station_name] Payroll", "Automated Payroll Deposits", -moneybuffer, "[GLOB.using_map.station_name] Automated Payroll System")
			station_account.do_transaction(T)
			GLOB.global_announcer.autosay("<b>[moneybuffer]Th has been removed from the [GLOB.using_map.station_name]'s main account due to automated payroll services.</b>", "[GLOB.using_map.station_name] Automated Payroll System", "Command")
			moneybuffer = 0

/datum/controller/subsystem/payment_controller/proc/TimeUntilPayday()
	return timerbuffer - round_duration_in_ticks

/datum/controller/subsystem/payment_controller/proc/PayPeople()
	var/datum/computer_file/data/email_account/server = ntnet_global.find_email_by_name(EMAIL_PAYROLL)
	var/thisbrand = pick(brand)
	var/thisslogan = pick(slogan)
	for(var/mob/living/carbon/human/H in GLOB.living_mob_list_) //we don't pay dead people
		if(H.mind)
			if(H.mind.initial_account && H.mind.assigned_role) //this excludes stowaways and other non-crew roles including derelict ships
				if(H.mind.assigned_role == "Captain" && GLOB.using_map.name == "Nerva") //todo, make a map var for captain ownership if we have other ship maps in a similar situation (never)
					continue

				else
					var/economic_modifier
					if(H.mind.pay_suspended)
						economic_modifier = 0
					else
						economic_modifier = H.mind.get_pay()
						var/datum/transaction/T = new("[station_account.owner_name]", "Automated Payroll Deposit", economic_modifier, "[GLOB.using_map.station_name] Automated Payroll System")
						H.mind.initial_account.do_transaction(T)

					if(H.mind.initial_email_login["login"])
						var/datum/computer_file/data/email_message/message = new()
						message.title = "[GLOB.using_map.station_name] Automated Payroll System"
						if(!H.mind.pay_suspended)
							message.stored_data = "[H.real_name],\n\n<b>[economic_modifier] Th</b> has been deposited into your account following hourly payroll payouts.\nThank you for your continued hard work.\n\n<i>This message is brought to you by [thisbrand] - [thisslogan]</i>"
						else
							message.stored_data = "[H.real_name],\n\nAs your wages have been suspended, your payout has not been processed. Please direct all complaints to your payroll administrator."
						message.source = server.login
						server.send_mail(H.mind.initial_email_login["login"], message)

					if((H.mind.assigned_role == "NanoTrasen Scientist" || H.mind.assigned_role == "Senior Scientist") && GLOB.using_map.name == "Nerva") //NanoTrasen pays the scientists on Nerva
						continue

					moneybuffer += economic_modifier