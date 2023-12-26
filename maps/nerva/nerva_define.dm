/datum/map/nerva
	name = "Nerva"
	full_name = "\improper ICS Nerva"
	path = "nerva"

	lobby_screens = list('maps/nerva/nerva_lobby.dmi')
	station_levels = list(1,2,3,4)
	contact_levels = list(1,2,3,4)
	player_levels = list(1,2,3,4)
	admin_levels = list(5)
	empty_levels = list(6)
	accessible_z_levels = list("1"=5,"2"=5,"3"=5,"4"=5,"6"=30)
	overmap_size = 36
	overmap_event_areas = 32

	id_hud_icons = 'maps/nerva/icons/assignment_hud.dmi'
	logo = "nervalogo.png"

	allowed_spawns = list("Cryogenic Storage", "Secondary Cryogenic Storage", "Cyborg Storage")
	default_spawn = "Cryogenic Storage"

	station_name  = "\improper ICS Nerva"
	station_short = "\improper Nerva"
	dock_name     = "TBD"
	boss_name     = "Automated Announcement Systems"
	boss_short    = "AAS"
	company_name  = "Automated Announcement Systems"
	company_short = "AAS"
	ert_context = "The Emergency Response Team works for Asset Protection; your job is to protect NanoTrasen's ass-ets. There is a severe emergency on the ICS Nerva and you are tasked to go and fix the problem.\nYou should first gear up and discuss a plan with your team. More members may be joining, don't move out before you're ready."

	map_admin_faxes = list("NanoTrasen Central Office", "Terran Confederacy Sector Headquarters", "United Human Alliance Outpost")

	shuttle_docked_message = "Attention all hands: Jump preparation complete. The bluespace drive is now spooling up, secure all stations for departure. Time to jump: approximately %ETD%."
	shuttle_leaving_dock = "Attention all hands: Jump initiated, exiting bluespace in %ETA%."
	shuttle_called_message = "Attention all hands: Jump sequence initiated. Transit procedures are now in effect. Jump in %ETA%."
	shuttle_recall_message = "Attention all hands: Jump sequence aborted, return to normal operating conditions."

	starting_money = 22000		//Money in station account //tweak this value
	department_money = 1000		//Money in department accounts
	salary_modifier	= 1			//Multiplier to starting character money

	supply_currency_name = "Thalers"
	supply_currency_name_short = "Th."

	using_new_cargo = TRUE //this var inits the stuff related to the contract system, the new trading system, and other misc things including the endround station profit report.
	new_cargo_inflation = 45 //used to calculate how much points are now. this needs balancing //i didn't make this clear, it's the original point value times this number
	trading_faction = /datum/factions/nanotrasen //this is used to determine rep points/bonuses from trading and certain contracts

	evac_controller_type = /datum/evacuation_controller/starship

	default_law_type = /datum/ai_laws/manifest
	use_overmap = 1

	num_exoplanets = 1

	away_site_budget = 5
	min_offmap_players = 0

	date_offset = 560

	base_floor_type = /turf/simulated/floor/reinforced/airless
	// for base_floor_area, look in nerva_define.dm

	species_to_job_blacklist = list(
		/datum/species/unathi  = list(/datum/job/captain),
		/datum/species/skrell  = list(/datum/job/captain),
		/datum/species/machine = list(/datum/job/captain),
		/datum/species/diona   = list(/datum/job/captain),
		/datum/species/teshari = list(/datum/job/captain)
	)

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
		var/datum/money_account/max_profit = all_money_accounts[2]
		var/datum/money_account/max_loss = all_money_accounts[1]
		var/stationmoney
		for(var/datum/money_account/D in all_money_accounts)
			if(D == station_account)
				stationmoney = station_account.money
				stationmoney -= starting_money //how much money did we make from the start of the round
				continue
			if(D == vendor_account || D.account_type != ACCOUNT_TYPE_PERSONAL) //yes we know you get lots of money
				continue
			var/saldo = D.get_balance() - D.starting_amount
			if(saldo >= (max_profit.get_balance() - max_profit.starting_amount))
				max_profit = D
			if(saldo <= (max_loss.get_balance() - max_loss.starting_amount))
				max_loss = D

		to_world("<b>[max_profit.owner_name]</b> received most <font color='green'><B>PROFIT</B></font> today, with net profit of <b>T[max_profit.get_balance() - max_profit.starting_amount]</b>.")
		to_world("On the other hand, <b>[max_loss.owner_name]</b> had most <font color='red'><B>LOSS</B></font>, with total loss of <b>T[max_loss.get_balance() - max_loss.starting_amount]</b>.")
		to_world("The <b>[station_name]</b> itself made <b>T[stationmoney]</b> in revenue today, with <b>T[station_account.money]</b> in its account.")
		to_world("<b>T<font color='red'>[SSpayment_controller.total_paid]</font></b> was paid to the crew of the <b>[station_name]</b> in hourly salary payments today.")
		to_world("The crew of the <b>[station_name]</b> completed <b>[completed_contracts]</b> contracts today, earning <b>T[contract_money]</b>.")
		to_world("In addition <b>[destroyed_ships]</b> hostile ships were destroyed by the crew of the <b>[station_name]</b> today.")
