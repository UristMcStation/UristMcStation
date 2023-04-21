/**********
* Medical *
**********/
/datum/uplink_item/item/medical
	category = /datum/uplink_category/medical

/datum/uplink_item/item/medical/sinpockets
	name = "Box of Sin-Pockets"
	item_cost = 8
	path = /obj/item/weapon/storage/box/sinpockets

/datum/uplink_item/item/medical/combatstim
	name = "Combat Stimulants"
	desc = "A single-use medical injector filled with performance enhancing drugs."
	item_cost = 10
	path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/combatstim

/datum/uplink_item/item/medical/stabilisation
	name = "Slimline Stabilisation Kit"
	desc = "A pocket-sized medkit filled with lifesaving equipment."
	item_cost = 16
	path = /obj/item/weapon/storage/firstaid/sleekstab

/datum/uplink_item/item/medical/stasis
	name = "Stasis Bag"
	desc = "Reusable bag designed to slow down life functions of occupant, especially useful if short on time or in a hostile enviroment."
	item_cost = 12
	path = /obj/item/bodybag/cryobag

/datum/uplink_item/item/medical/defib
	name = "Combat Defibrillator"
	desc = "A belt-equipped defibrillator that can be rapidly deployed. Does not have the restrictions or safeties of conventional defibrillators and can revive through space suits."
	item_cost = 16
	path = /obj/item/weapon/defibrillator/compact/combat/loaded

/datum/uplink_item/item/medical/advancedmedibag
	name = "Advanced medical toolkit"
	desc = "A duffle bag containing a roller bed, syringes, health analyzer, health HUD, auto-compressor, auto-resuscitator, nanoblood, an advanced first-aid kit, and a pair of nitrile gloves."
	item_cost = 24
	path = /obj/item/weapon/storage/backpack/dufflebag/syndie/urist/med/full

/datum/uplink_item/item/medical/surgery
	name = "Surgery kit"
	item_cost = 32  // Lowered for Solo/Duo Traitors.
	antag_costs = list(MODE_MERCENARY = 40)
	path = /obj/item/weapon/storage/firstaid/surgery

/datum/uplink_item/item/medical/combat
	name = "Combat medical kit"
	item_cost = 36 // Lowered, for traitors.
	antag_costs = list(MODE_MERCENARY = 48)
	path = /obj/item/weapon/storage/firstaid/combat
