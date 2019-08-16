//this is the contract file. contract datums go here, but the actual meat of the contracts go in different files. please make a note of where the contract stuff is.
//all contracts need an accompanying paper

/datum/contract
	var/name = "contract"
	var/desc = "contract"
	var/faction = null //who are we doing this for
	var/money = 0 //how much money are we getting
	var/rep_points = 0 //how much rep are we getting
	var/neg_rep_points = 0 //how much rep do we lose
	var/neg_faction = null //and from who
	var/amount = 0 //how much of whatever we have to do
	var/completed = 0 //how much have we done

/datum/contract/proc/Complete(var/number = 0)
	completed += number
	if(completed >= amount)
		station_account.money += money
		GLOB.using_map.completed_contracts += 1
		GLOB.using_map.contracts -= src
		qdel(src)

/datum/contract/nanotrasen
	faction = "NanoTrasen"

/datum/contract/nanotrasen/anomaly //code\modules\xenoarcheaology\tools\artifact_analyser.dm
	name = "Anomaly Research Contract"

/datum/contract/nanotrasen/anomaly/New()
	..()
	amount = rand(1,3)
	money = (amount * rand(850,1400))
	rep_points = amount
	desc = "The Galactic Crisis has nearly eliminated NanoTrasen's presence in this sector. That's why NanoTrasen has contracted the [GLOB.using_map.station_name] to analyze [amount] of the anomalies in this sector for us. Good luck."

/datum/contract/terran
	faction = "the Terran Confederacy"

/datum/contract/uha //united human alliance
	faction = "the United Human Alliance"

/datum/contract/shiphunt
	var/hunt_faction = null

/datum/contract/shiphunt/New()
	..()
	if(!amount)
		amount = rand(1,3)

	var/oldmoney = money
	money = (amount * oldmoney)

	desc = "This sector is plagued by [hunt_faction]s, [faction] needs the [GLOB.using_map.station_name] to hunt down and destroy [amount] [hunt_faction] ships in this sector."

//money values are very much in flux

/datum/contract/shiphunt/pirate
	name = "Pirate Ship Hunt Contract"
	hunt_faction = "pirate"
	rep_points = 5
	money = 3500

/datum/contract/shiphunt/alien
	name = "Lactera Ship Hunt Contract"
	hunt_faction = "alien"
	rep_points = 8
	amount = 1
	money = 7500
