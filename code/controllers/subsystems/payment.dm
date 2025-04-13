SUBSYSTEM_DEF(payment_controller)
	name = "Payment"
	wait = 15 SECONDS
	var/timerbuffer = 60 MINUTES //buffer for time check

	var/list/brand = list(  //this is just for the jokes
		"Cheesie Honkers",
		"Men At Arms Tobacco",
		"Lucky Stars Cigarettes",
		"Carcinoma Angels Cigarettes",
		"Robust Coffee",
		"Getmore Chocolate Corp products",
		"4no Raisins",
		"SweatMax products",
		"Space Cola",
		"Space Mountain Wind",
		"Dr.Gibb",
		"ClothingLord 9000 Clothes",
		"NanoTrasen Personal Computers",
		"Rougelady Chewing Tobacco",
		"Robust Softdrinks products"
	)

	var/list/slogan = list(
		"Now with 18% less carcinogens!",
		"Lawsuit free since 2579!",
		"Leading doctors only moderately advise against our products!",
		"Now occasionally without illegal narcotics!",
		"Now complying with 94% of trading standards laws!",
		"Condemned by the Space Pope!",
		"Larva-tested, pupa-approved",
		"For external use only",
		"Fun for the whole family except grandma and grandpa",
		"Beats a hard kick in the face",
		"The proud result of prison labor!",
		"No refunds",
		"For the sophisticated shut-in",
		"Tell your parents it's educational!"
	)

	//Don't forget our coporate overlords!
	var/list/nanotrasen_nags = list(
		"NanoTrasen staff are reminded that salaries cannot be re-negotiated once employment has commenced",
		"NanoTrasen would like to remind staff that the Intellectual Property rights of any inventions and/or concepts created during your employment with NanoTrasen are waived in their entirety to NanoTrasen",
		"Staff are reminded that unionizing is in direct violation of your employment contract. Dissatisfied staff are to book an appointment with a NanoTrasen Productivity and Morale Advisor, who will arrange an appointment with you within the next 895 working day(s)",
		"NanoTrasen staff are reminded that minimising overhead and wastage is of paramount importance to NanoTrasen, and is everyone's joint responsibility",
		"NanoTrasen would like to remind contracted staff that failure to meet expectations during your annual performance review, can and will result in contract termination (termination fees applicable)",
		"Staff are reminded that termination of the employment contract will incur a fee of 38.9% of your agreed annual salary for each year you have been employed by NanoTrasen, retrospectively adjusted for current inflation rates",
		"NanoTrasen reserves the right to reimburse lost productivity caused by staff absence from the workplace for any reason (such as sickness), automatically from staff salary payment(s) until the lost sum is recovered in its entirety",
		"Staff are once again reminded that comfort breaks are indeed on personal time, and as such will be docked from your pay entitlement",
		"NanoTrasen staff are reminded that payment processing fees are automatically deducted from your hourly pay entitlement, along with the mandatory convenience fees for the automatic deduction of the aforementioned processing fees"
	)

	var/payment_modifier = 5 //economic_power * this number = pay. tweak this number!
	var/moneybuffer = 0 //how much money are we removing from the nerva's account?
	var/total_paid = 0 //how much money have we paid out in total
	var/list/penniless_passengers //names of passengers who can't pay passenger fees
	var/passenger_fee = 50 //50 thaler by default. how much are passengers paying per hour?
	var/passenger_count = 0 //how many passengers are alive?

/datum/controller/subsystem/payment_controller/fire()
	if (TimeUntilPayday() > 0)
		return

	timerbuffer += 60 MINUTES

	if(station_account.money <= 0) //we can go into debt, a bit, but then we can't pay people anymore.
		GLOB.global_announcer.autosay("<b>Hourly salary payments have been not been processed due to a lack of funds. Please direct all criticism towards the Captain.</b>", "[GLOB.using_map.station_name] Automated Payroll System", "Common")
		return
	var/newbrand = pick(brand) //this is a dumb meme
	penniless_passengers = list()
	PayPeople(newbrand)
	GLOB.global_announcer.autosay("<b>Hourly salary payments have been processed and deposited into your accounts. Thank you for your service to the [GLOB.using_map.station_name]. This message is brought to you by [newbrand]: make sure to buy [newbrand] at your nearest vending machine.</b>", "[GLOB.using_map.station_name] Automated Payroll System", "Common")
	total_paid += moneybuffer

	var/paying_passengers = passenger_count - length(penniless_passengers)
	if(paying_passengers)
		var/datum/transaction/singular/U = new(station_account, "Automated Fee Deposits", (passenger_fee * paying_passengers), "[GLOB.using_map.station_name] Automated Fee System")
		U.perform()
		GLOB.global_announcer.autosay("<b>[paying_passengers] passenger[paying_passengers > 1 ? "s have" : " has"] paid [(passenger_fee*paying_passengers)]Th to the [GLOB.using_map.station_name]'s main account.</b>", "[GLOB.using_map.station_name] Automated Payroll System", "Command")
	if(length(penniless_passengers))
		GLOB.global_announcer.autosay("The following passengers have failed to pay for transport: [english_list(penniless_passengers)].", "[GLOB.using_map.station_name] Automated Fee System", "Command")

	var/datum/transaction/singular/T = new(station_account, "Automated Payroll Deposits", -moneybuffer, "[GLOB.using_map.station_name] Automated Payroll System")
	T.perform()
	GLOB.global_announcer.autosay("<b>[max(0,moneybuffer)]Th has been removed from the [GLOB.using_map.station_name]'s main account due to automated payroll services.</b>", "[GLOB.using_map.station_name] Automated Payroll System", "Command")

	moneybuffer = 0
	passenger_count = 0

/datum/controller/subsystem/payment_controller/proc/TimeUntilPayday()
	return timerbuffer - round_duration_in_ticks

/datum/controller/subsystem/payment_controller/proc/PayPeople(sponsor = pick(brand))
	var/datum/computer_file/data/email_account/server = ntnet_global.find_email_by_name(EMAIL_PAYROLL)
	var/this_slogan = pick(slogan)
	var/nanotrasen_nag = pick(nanotrasen_nags)

	for(var/mob/living/carbon/H in GLOB.living_players) //we don't pay dead people
		if(!H.mind?.assigned_role || !H.mind?.initial_account) //this excludes stowaways and other non-crew roles including derelict ships
			continue
		if(H.mind.assigned_role == "Captain" && GLOB.using_map.name == "Nerva") //todo, make a map var for captain ownership if we have other ship maps in a similar situation (never)
			continue
		if(H.mind.assigned_role == "Passenger")
			passenger_count += 1
			var/datum/transaction/singular/U = new(H.mind.initial_account, station_account.account_name, -passenger_fee, "[GLOB.using_map.station_name] Automated Fee System")
			if(!U.perform())
				penniless_passengers += H.mind.name	//name and shame passengers for not paying

		var/economic_modifier = H.mind.pay_suspended ? 0 : H.mind.get_pay()

		if(economic_modifier)
			var/datum/transaction/singular/T = new(H.mind.initial_account, station_account.account_name, economic_modifier, "[GLOB.using_map.station_name] Automated Payroll System")
			T.perform()

		if(H.mind.initial_email_login["login"] && server)
			var/datum/computer_file/data/email_message/message = new()
			if((H.mind.assigned_role == "NanoTrasen Scientist" || H.mind.assigned_role == "Senior Scientist") && GLOB.using_map.name == "Nerva") ///NanoTrasen pays the scientists on Nerva
				message.title = "NanoTrasen Payroll Services"
				message.stored_data = "[H.real_name], \n\nYour agreed salary of <b>[economic_modifier] Th</b> has been deposited into your account on behalf of the NanoTrasen Research and Development department.\n\n<i>[nanotrasen_nag]</i>"

				message.source = server.login
				server.send_mail(H.mind.initial_email_login["login"], message)
				continue

			message.title = "[GLOB.using_map.station_name] Automated Payroll System"

			if(H.mind.assigned_role == "Passenger")
				message.stored_data = "[H.real_name],\n\n<b>[passenger_fee] Th</b> has been deducted from your account as part of the hourly passenger fee.\nThank you for travelling with us.\n\n<i>This message is brought to you by [sponsor] - [this_slogan]</i>"
			else if(!H.mind.pay_suspended)
				message.stored_data = "[H.real_name],\n\n<b>[economic_modifier] Th</b> has been deposited into your account following hourly payroll payouts.\nThank you for your continued hard work.\n\n<i>This message is brought to you by [sponsor] - [this_slogan]</i>"
			else
				message.stored_data = "[H.real_name],\n\nAs your wages have been suspended, your payout has not been processed. Please direct all complaints to your payroll administrator."

			message.source = server.login
			server.send_mail(H.mind.initial_email_login["login"], message)

		moneybuffer += economic_modifier
