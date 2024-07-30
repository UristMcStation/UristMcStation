/*******************************
* Stealth and Camouflage Items *
*******************************/
/datum/uplink_item/item/stealth_items
	category = /datum/uplink_category/stealth_items

/datum/uplink_item/item/stealth_items/fakemoustache
	name = "Fake Moustache"
	desc = "A simple fiber moustache that will conceal the wearer's face."
	item_cost = 1
	path = /obj/item/clothing/mask/fakemoustache

/datum/uplink_item/item/stealth_items/sneaky_armor
	name = "Concealable Armor"
	desc = "An armor vest that can be worn under a jacket. About as tough as a light plate."
	item_cost = 15
	path = /obj/item/clothing/accessory/armor_plate/sneaky

/datum/uplink_item/item/stealth_items/tactical_sneaky_armor
	name = "Concealable Tactical Armor"
	desc = "An armor vest that can be worn under a jacket. About as tough as a medium plate."
	item_cost = 25
	path = /obj/item/clothing/accessory/armor_plate/sneaky/tactical

/datum/uplink_item/item/stealth_items/balaclava
	name = "Balaclava"
	desc = "Opachki!"
	item_cost = 1
	path =	/obj/item/clothing/mask/balaclava

/datum/uplink_item/item/stealth_items/syndigaloshes
	name = "No-Slip Shoes"
	desc = "These shoes have a non-slip grip on them, so those pesky janitors can't ruin your operations!"
	item_cost = 4
	path = /obj/item/clothing/shoes/syndigaloshes

/datum/uplink_item/item/stealth_items/spy
	name = "Bug Kit"
	desc = "For when you want to conduct voyeurism from afar. Comes with 6 bugs to plant, and a monitoring device to pair them with."
	item_cost = 6
	path = /obj/item/storage/box/syndie_kit/spy

/datum/uplink_item/item/stealth_items/id
	name = "Agent ID card"
	desc = "A unique ID card that is completely configurable. Scan another ID card with it to clone its access capabilities."
	item_cost = 12
	path = /obj/item/card/id/syndicate

/datum/uplink_item/item/stealth_items/chameleon_kit
	name = "Chameleon Kit"
	desc = "A discreet disguise kit, with a full set of appearance changing clothes, and a voice modulator mask, allowing you \
	to impersonate most people"
	item_cost = 24 // Increase for Mask included.
	path = /obj/item/storage/backpack/chameleon/sydie_kit

/*/datum/uplink_item/item/stealth_items/voice   Urist Specific - Changed to be available with the Chameleon Kit.
	name = "Modified Gas Mask"
	desc = "A fully functioning gas mask that is able to conceal your face and has a built in voice modulator, \
	so you can become a true shadow operative!"
	item_cost = 20
	path = /obj/item/clothing/mask/chameleon/voice

*/
/datum/uplink_item/item/stealth_items/chameleon_projector
	name = "Chameleon Projector"
	desc = "Use this to scan a small, portable object in order to disguise yourself as said object."
	item_cost = 32
	path = /obj/item/device/chameleon

/datum/uplink_item/item/stealth_items/fleshsuit
	name = "Human-suit"
	item_cost = 5
	path = /obj/item/storage/box/syndie_kit/fleshsuit

/datum/uplink_item/item/stealth_items/sneakies
	name = "Sneakies"
	desc = "A fashionable pair of polished dress shoes. The soles are acousticly dampened to prevent audible footsteps \
	and a non-stick backing has been applied to remove the chance of trailing bloody footprints behind you."
	item_cost = 4
	path = /obj/item/clothing/shoes/laceup/sneakies

/datum/uplink_item/item/stealth_items/smuggler_satchel
	name = "Smuggler's Satchel"
	desc = "This satchel is thin enough to be hidden in the gap between plating and tiling, \
	great for stashing your stolen goods. Comes with a crowbar and a floor tile."
	item_cost = 16
	path = /obj/item/storage/backpack/satchel/flat
