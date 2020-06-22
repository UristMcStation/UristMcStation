//this is the contract file. contract datums go here, but the actual meat of the contracts go in different files. please make a note of where the contract stuff is.
//all contracts need an accompanying paper //this isn't entirely true anymore, just for the physical traders

/datum/contract
	var/name = null
	var/desc = null
	var/datum/factions/faction = null //who are we doing this for
	var/money = 0 //how much money are we getting
	var/rep_points = 0 //how much rep are we getting
	var/points_per_unit = 0
	var/neg_rep_points = 0 //how much rep do we lose
	var/datum/factions/neg_faction = null //and from who
	var/amount = 0 //how much of whatever we have to do
	var/completed = 0 //how much have we done

/datum/contract/New()
	..()

	if(faction)
		for(var/datum/factions/F in SSfactions.factions) //maybe turn this into an SSfactions proc?
			if(F.type == faction)
				faction = F

	if(neg_faction)
		for(var/datum/factions/F in SSfactions.factions)
			if(F.type == neg_faction)
				neg_faction = F

	if(points_per_unit && amount)
		rep_points = (points_per_unit * amount)

/datum/contract/proc/Complete(var/number = 0)
	completed += number
	if(completed >= amount)
		SSfactions.update_reputation(faction, rep_points)

		if(neg_faction)
			SSfactions.update_reputation(neg_faction, neg_rep_points)

		var/datum/transaction/T = new("[GLOB.using_map.station_name]", "Contract Completion", money, "[faction.name]")
		station_account.do_transaction(T)
		GLOB.using_map.completed_contracts += 1
		GLOB.using_map.contracts -= src
		qdel(src)

/datum/contract/nanotrasen
	faction = /datum/factions/nanotrasen

/datum/contract/nanotrasen/anomaly //code\modules\xenoarcheaology\tools\artifact_analyser.dm
	name = "Anomaly Research Contract"

/datum/contract/nanotrasen/anomaly/New()
	amount = rand(1,3)
	money = (amount * rand(850,1400))
	rep_points = amount
	desc = "The Galactic Crisis has nearly eliminated NanoTrasen's presence in this sector. That's why NanoTrasen has contracted the [GLOB.using_map.station_name] to analyze [amount] of the anomalies in this sector for us. Good luck."

	..()

/datum/contract/terran
	faction = /datum/factions/terran

/datum/contract/uha //united human alliance
	faction = /datum/factions/uha

//shiphunting

/datum/contract/shiphunt/New()
	if(!amount)
		amount = rand(1,3)

	var/oldmoney = money
	money = (amount * oldmoney)

	..()

	if(!neg_rep_points)
		neg_rep_points -= rep_points

	if(!desc)
		desc = "This sector is plagued by [neg_faction.factionid]s, [faction.name] needs the [GLOB.using_map.station_name] to hunt down and destroy [amount] [neg_faction.name] ships in this sector."

//money values are very much in flux

/datum/contract/shiphunt/pirate
	name = "Pirate Ship Hunt Contract"
	neg_faction = /datum/factions/pirate
	points_per_unit = 3
	money = 3500

/datum/contract/shiphunt/alien
	name = "Lactera Ship Hunt Contract"
	neg_faction = /datum/factions/alien
	rep_points = 7
	amount = 1
	money = 7500
