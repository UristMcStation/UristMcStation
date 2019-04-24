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

		GLOB.using_map.contracts -= src
		qdel(src)

/datum/contract/nanotrasen
	faction = "NanoTrasen"

/datum/contract/nanotrasen/anomaly //code\modules\xenoarcheaology\tools\artifact_analyser.dm
	name = "Anomaly Research Contract"
	desc = "A contract issued by NanoTrasen to research anomalies."

/datum/contract/nanotrasen/anomaly/New()
	..()
	amount = rand(1,3)
	desc = "A contract issued by NanoTrasen to research [amount] of the anomalies found throughout this sector."
	money = (amount * rand(700,1000))
	rep_points = amount

/datum/contract/terran
	faction = "terran"

/datum/contract/uha //united human alliance
	faction = "uha"

/datum/contract/shiphunt
	var/hunt_faction = null

/datum/contract/shiphunt/New()
	..()
	if(!amount)
		amount = rand(1,3)
		var/oldmoney = money
		money = (amount * oldmoney)

	name = "[hunt_faction] Ship Hunt Contract"
	desc = "A contract issued by [faction] to hunt down and destroy [amount] [hunt_faction] ships in this sector."

//money values are very much in flux

/datum/contract/shiphunt/pirate
	hunt_faction = "pirate"
	rep_points = 5
	money = 2000

/datum/contract/shiphunt/alien
	hunt_faction = "alien"
	rep_points = 8
	amount = 1
	money = 5000