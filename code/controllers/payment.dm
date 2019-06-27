var/datum/controller/payment_controller/payment_controller

/datum/controller/payment_controller
	var/timerbuffer = 0 //buffer for time check
	var/list/brand = list("Cheesie Honkers", "Men At Arms Tobacco", "Lucky Stars Cigarettes", "Carcinoma Angels Cigarettes", "Robust Coffee", "Getmore Chocolate Corp products", "4no Raisins", "SweatMax products", "Space Cola", "Space Mountain Wind", "Dr.Gibb", "ClothingLord 9000 Clothes", "NanoTrasen Personal Computers", "Rougelady Chewing Tobacco", "Robust Softdrinks products") //this is just for the jokes
	var/payment_modifier = 4 //economic_power * this number = pay. tweak this number!
	var/moneybuffer = 0 //how much money are we removing from the nerva's account?

/datum/controller/payment_controller/New()
	timerbuffer = 6 MINUTES
	START_PROCESSING(SSprocessing, src)

/datum/controller/payment_controller/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

/datum/controller/payment_controller/Process()
	if (TimeUntilPayday() <= 0)
		timerbuffer += 60 MINUTES

		if(station_account.money <= 0) //we can go into debt, a bit, but then we can't pay people anymore.
			GLOB.global_announcer.autosay("<b>Hourly salary payments have been not been processed due to a lack of funds. Please direct all criticism towards the Captain.</b>", "[GLOB.using_map.station_name] Automated Payroll System", "Common")
			return

		else

			PayPeople()
			var/newbrand = pick(brand) //this is a dumb meme
			GLOB.global_announcer.autosay("<b>Hourly salary payments have been processed and deposited into your accounts. Thank you for your service to the [GLOB.using_map.station_name]. This message is brought to you by [newbrand]: make sure to buy [newbrand] at your nearest vending machine.</b>", "[GLOB.using_map.station_name] Automated Payroll System", "Common")
			station_account.money -= moneybuffer
			GLOB.global_announcer.autosay("<b>[moneybuffer]Th has been removed from the [GLOB.using_map.station_name]'s main account due to automated payroll services.</b>", "[GLOB.using_map.station_name] Automated Payroll System", "Command")
			moneybuffer = 0

/datum/controller/payment_controller/proc/TimeUntilPayday()
	return timerbuffer - round_duration_in_ticks

/datum/controller/payment_controller/proc/PayPeople()
	for(var/mob/living/carbon/human/H in GLOB.living_mob_list_) //we don't pay dead people
		if(H.mind)
			if(H.mind.initial_account && H.mind.assigned_role) //this excludes stowaways and other non-crew roles including derelict ships
				if(H.mind.assigned_role == "Captain" && GLOB.using_map.name == "Nerva") //todo, make a map var for captain ownership if we have other ship maps in a similar situation (never)
					return

				else
					var/datum/job/job = job_master.occupations_by_title[H.mind.assigned_role]
					var/economic_modifier = job.economic_power * payment_modifier

					var/datum/transaction/T = new("[H.name]", "Automated Payroll Deposit", economic_modifier, "[GLOB.using_map.station_name] Automated Payroll System")

					H.mind.initial_account.do_transaction(T)

	//				H.mind.initial_account.money += economic_modifier

					if(H.mind.assigned_role == "Nanotrasen Scientist" && GLOB.using_map.name == "Nerva") //NanoTrasen pays the scientists
						return

					else
						moneybuffer += economic_modifier
						return