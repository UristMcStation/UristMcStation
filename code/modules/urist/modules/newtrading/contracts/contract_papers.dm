/obj/item/weapon/paper/contract
	var/contract_type = null
	var/datum/contract/Contract = null
	var/stored_faction = null
	var/list/potential_contracts = null //only use this for random ones, it'll pick one

/obj/item/weapon/paper/contract/New()
	..()

	if(potential_contracts)
		contract_type = pick(potential_contracts)

	Contract = new contract_type

	name = Contract.name
	info = Contract.desc

	if(stored_faction && !Contract.faction)
		Contract.faction = src.stored_faction

	GLOB.using_map.contracts += Contract
//	AddContract()

///obj/item/weapon/paper/contract/proc/AddContract(var/contract)
//	GLOB.using_map.contracts += contract

/obj/item/weapon/paper/contract/nanotrasen
	stored_faction = "NanoTrasen"

/obj/item/weapon/paper/contract/nanotrasen/anomaly
	contract_type = /datum/contract/nanotrasen/anomaly

/obj/item/weapon/paper/contract/nanotrasen/piratehunt
	contract_type = /datum/contract/shiphunt/pirate

/obj/item/weapon/paper/contract/nanotrasen/alienhunt
	contract_type = /datum/contract/shiphunt/alien

