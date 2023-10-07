//this is the contract file. contract datums go here, but the actual meat of the contracts go in different files. please make a note of where the contract stuff is.
//all contracts need an accompanying paper //this isn't entirely true anymore, just for the physical traders

/datum/contract
	var/name = null
	var/desc = null
	var/datum/factions/faction = null //who are we doing this for //if unassigned, this uses GLOB.using_map.trading_faction
	var/money = 0 //how much money are we getting
	var/rep_points = 0 //how much rep are we getting //if points_per_unit and amount are set, that will determine this automatically
	var/points_per_unit = 0 //how much rep per var/amount
	var/neg_rep_points = 0 //how much rep do we lose
	var/datum/factions/neg_faction = null //and from who
	var/amount = 0 //how much of whatever we have to do
	var/completed = 0 //how much have we done

/datum/contract/New()
	..()

	if(points_per_unit && amount)
		rep_points = (points_per_unit * amount)

	assign_factions()

/datum/contract/proc/assign_factions()
	if(neg_faction)
		neg_faction = SSfactions.get_faction_by_type(neg_faction)

	if(faction)
		faction = SSfactions.get_faction_by_type(faction)

	else
		if(GLOB.using_map.trading_faction) //if we have no faction assigned, we use the trading_faction
			faction = GLOB.using_map.trading_faction


/datum/contract/proc/Complete(number = 0)
	completed += number
	if(completed >= amount)
		if(faction && rep_points)
			SSfactions.update_reputation(faction, rep_points)

		if(neg_faction && neg_rep_points)
			SSfactions.update_reputation(neg_faction, neg_rep_points)

		var/datum/transaction/T = new("[GLOB.using_map.station_name]", "Contract Completion", money, "[faction.name] contract completion")
		GLOB.global_announcer.autosay("<b>The [name] has been completed. [money]Th has been deposited into the station account by [faction.name].</b>", "[GLOB.using_map.station_name] Automated Account System", "Command")
		station_account.add_transaction(T)
		GLOB.using_map.completed_contracts += 1
		GLOB.using_map.contract_money += src.money
		GLOB.using_map.contracts -= src
		qdel(src)

/datum/contract/nanotrasen
	faction = /datum/factions/nanotrasen

/datum/contract/nanotrasen/anomaly //code\modules\xenoarcheaology\tools\artifact_analyser.dm
	name = "Anomaly Research Contract"

/datum/contract/nanotrasen/anomaly/New()
	..()

	amount = rand(1,3)
	money = (amount * rand(1200,2200))
	rep_points = amount
	desc = "The Galactic Crisis has nearly eliminated NanoTrasen's presence in this sector. That's why NanoTrasen has contracted the [GLOB.using_map.station_name] to analyze [amount] of the anomalies in this sector for them. Good luck."

/datum/contract/terran
	faction = /datum/factions/terran

/datum/contract/uha //united human alliance
	faction = /datum/factions/uha

//shiphunting

/datum/contract/shiphunt/New() //shiphunt contracts are resolved in urist/modules/shipbattles/overmapships/overmapships.dm, in the shipdeath() proc
	if(!amount)
		amount = rand(1,3)

	var/oldmoney = money
	money = (amount * oldmoney)

	..()

	if(!desc)
		desc = "This sector is plagued by [neg_faction.factionid]s, [faction.name] needs the [GLOB.using_map.station_name] to hunt down and destroy [amount] [neg_faction.name] ships in this sector."

	if(!neg_rep_points)
		neg_rep_points -= rep_points

//station_destroy, see urist/structures/boardingstructures for where these are resolved. these need to have a neg_faction set that matches the station's faction

/datum/contract/station_destroy
	amount = 1