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

/obj/item/weapon/paper/contract
	var/contract = /datum/contract

/obj/item/weapon/paper/contract/New()
	var/datum/contract/C
	C = contract

	name = C.name
	info = C.desc

	AddContract()

/obj/item/weapon/paper/contract/proc/AddContract()
	GLOB.using_map.contracts += new contract

/datum/contract/nanotrasen
	faction = "nanotrasen"

/datum/contract/nanotrasen/anomaly //code\modules\xenoarcheaology\tools\artifact_analyser.dm
	name = "Anomaly Research Contract"
	desc = "A contract issued by Nanotrasen to research anomalies."

/datum/contract/nanotrasen/anomaly/New()
	amount = rand(1,5)
	desc = "A contract issued by Nanotrasen to research [amount] of the anomalies found throughout this sector."
	money = (amount * rand(300,500))
	rep_points = amount

/obj/item/weapon/paper/contract/nanotrasen/anomaly
	contract = /datum/contract/nanotrasen/anomaly

/datum/contract/terran
	faction = "terran"

/datum/contract/uha //united human alliance
	faction = "uha"

