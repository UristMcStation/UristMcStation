/obj/item/weapon/paper/contract
	var/contract_type = null
	var/datum/contract/Contract = null
	var/stored_faction = null

/obj/item/weapon/paper/contract/New()
	..()

	Contract = new contract_type

	name = Contract.name
	info = Contract.desc

	if(stored_faction && !Contract.faction)
		Contract.faction = src.stored_faction

	AddContract(Contract)

/obj/item/weapon/paper/contract/proc/AddContract(var/contract)
	GLOB.using_map.contracts += contract

/obj/item/weapon/paper/contract/nanotrasen
	stored_faction = "NanoTrasen"

/obj/item/weapon/paper/contract/nanotrasen/anomaly
	contract_type = /datum/contract/nanotrasen/anomaly

/obj/item/weapon/paper/contract/nanotrasen/piratehunt
	contract_type = /datum/contract/shiphunt/pirate

/obj/item/weapon/paper/contract/nanotrasen/alienhunt
	contract_type = /datum/contract/shiphunt/alien