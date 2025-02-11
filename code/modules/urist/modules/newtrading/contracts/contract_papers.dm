/obj/item/paper/contract
	var/contract_type = null
	var/datum/contract/Contract = null
	var/stored_faction = null
	var/list/potential_contracts = null //only use this for random ones, it'll pick one

/obj/item/paper/contract/New()
	..()

	if(potential_contracts)
		contract_type = pick(potential_contracts)

	Contract = new contract_type

	name = Contract.name
	info = Contract.desc //change this to another var maybe?

	if(stored_faction && !Contract.faction)
		for(var/datum/factions/F in SSfactions.factions)
			if(F.factionid == stored_faction)
				Contract.faction = F

	GLOB.using_map.contracts += Contract
//	AddContract()

///obj/item/paper/contract/proc/AddContract(var/contract)
//	GLOB.using_map.contracts += contract

/obj/item/paper/contract/nanotrasen
	stored_faction = "nanotrasen"

/obj/item/paper/contract/nanotrasen/anomaly
	contract_type = /datum/contract/nanotrasen/anomaly
