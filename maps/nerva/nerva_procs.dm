/datum/map/nerva/ship_jump()
	for(var/obj/overmap/visitable/ship/combat/nerva/nerva)
		new /obj/ftl (get_turf(nerva))
		qdel(nerva)
		animate(nerva, time = 0.5 SECONDS)
		animate(alpha = 0, time = 0.5 SECONDS)

/datum/map/nerva/setup_economy()
	..()
	if (!nanotrasen_account)
		nanotrasen_account = create_account("Nanotrasen Company Expense Card", "Nanotrasen Representative", rand(11000,44000), ACCOUNT_TYPE_DEPARTMENT)

/datum/map/nerva/do_interlude_teleport(atom/movable/target, atom/destination, duration = 30 SECONDS, precision, type) // copypasta from torch proc to do the same
	var/turf/T = pick_area_turf(/area/bluespace_interlude/platform, list(/proc/not_turf_contains_dense_objects, /proc/IsTurfAtmosSafe))

	if (!T)
		do_teleport(target, destination)
		return

	if (isliving(target))
		to_chat(target, FONT_LARGE(SPAN_WARNING("Your vision goes blurry and nausea strikes your stomach. Where are you...?")))
		do_teleport(target, T, precision, type)
		addtimer(new Callback(GLOBAL_PROC, /proc/do_teleport, target, destination), duration)

/datum/map/nerva/bolt_saferooms()
	for(var/obj/machinery/door/airlock/vault/door in SSmachines.machinery)
		if(door.id_tag == "bridgesafedoor")
			door.lock()

/datum/map/nerva/unbolt_saferooms()
	for(var/obj/machinery/door/airlock/vault/door in SSmachines.machinery)
		if(door.id_tag == "bridgesafedoor")
			door.unlock()

/datum/map/nerva/RoundEndInfo()
	if(length(all_money_accounts))
		var/max_profit = 0
		var/max_profit_owner = "Greedy Profiteer"
		var/max_loss = 0
		var/max_loss_owner = "Thriftless Wastrel"
		var/stationmoney

		for(var/datum/money_account/D in all_money_accounts)
			if(D == station_account)
				stationmoney = station_account.money
				stationmoney -= starting_money //how much money did we make from the start of the round
				continue

			if(D == vendor_account) //yes we know you get lots of money
				continue

			var/saldo = D.get_profit()

			if (saldo > max_profit)
				max_profit = saldo
				max_profit_owner = D.owner_name

			if (saldo < max_loss)
				max_loss = saldo
				max_loss_owner = D.owner_name

		if (max_profit > 0)
			to_world("<b>[max_profit_owner]</b> received most [SPAN_COLOR("green", "<B>PROFIT</B>")] today, with net profit of <b>T[max_profit]</b>.")
		else
			to_world("[SPAN_BAD("Nobody")] earned any extra profit today!")

		if (max_loss < 0)
			to_world("[max_profit > 0 ? "On the other hand," : "On top of that,"] <b>[max_loss_owner]</b> had most [SPAN_BAD("LOSS")], with total loss of <b>[GLOB.using_map.local_currency_name_short][max_loss]</b>.")
		else
			to_world("[SPAN_COLOR("green", "<B>Nobody</B>")] suffered any extra losses today!")

		to_world("The <b>[station_name]</b> itself made <b>T[stationmoney]</b> in revenue today, with <b>T[station_account.money]</b> in its account.")
		to_world("<b>T<font color='red'>[SSpayment_controller.total_paid]</font></b> was paid to the crew of the <b>[station_name]</b> in hourly salary payments today.")
		to_world("The crew of the <b>[station_name]</b> completed <b>[completed_contracts]</b> contracts today, earning <b>T[contract_money]</b>.")
		to_world("In addition <b>[destroyed_ships]</b> hostile ships were destroyed by the crew of the <b>[station_name]</b> today.")