/***********
* Grenades *
************/
/datum/uplink_item/item/grenades
	category = /datum/uplink_category/grenades

/datum/uplink_item/item/grenades/anti_photon
	name = "1x Photon Disruption Grenade"
	desc = "An experimental device for temporarily removing light in a limited area for a small amount of time."
	item_cost = 4
	path = /obj/item/grenade/anti_photon

/datum/uplink_item/item/grenades/anti_photons
	name = "5x Photon Disruption Grenades"
	item_cost = 16
	path = /obj/item/storage/box/anti_photons

/datum/uplink_item/item/grenades/smoke
	name = "1x Smoke Grenade"
	desc = "A grenade that will erupt into a vision obscuring cloud of smoke. Makes for great getaways!"
	item_cost = 4
	path = /obj/item/grenade/smokebomb

/datum/uplink_item/item/grenades/smokes
	name = "5x Smoke Grenades"
	item_cost = 16
	path = /obj/item/storage/box/smokes

/datum/uplink_item/item/grenades/emp
	name = "1x EMP Grenade"
	desc = "A grenade that will send electronics into a frenzy, or possibly fry them altogether. The timer is adjustable with a screwdriver."
	item_cost = 8
	path = /obj/item/grenade/empgrenade

/datum/uplink_item/item/grenades/emps
	name = "5x EMP Grenades"
	item_cost = 24
	path = /obj/item/storage/box/emps
	antag_costs = list(MODE_PARANOIA = 15)

/datum/uplink_item/item/grenades/frag_high_yield
	name = "Fragmentation Bomb"
	item_cost = 24
	antag_roles = list(MODE_MERCENARY) // yeah maybe regular traitors shouldn't be able to get these
	path = /obj/item/grenade/frag/high_yield

/datum/uplink_item/item/grenades/fragshell
	name = "1x Fragmentation Shell"
	desc = "Weaker than standard fragmentation grenades, these devices can be fired from a grenade launcher."
	item_cost = 10
	antag_roles = list(MODE_MERCENARY)
	path = /obj/item/grenade/frag/shell

/datum/uplink_item/item/grenades/fragshells
	name = "5x Fragmentation Shells"
	desc = "Weaker than standard fragmentation grenades, these devices can be fired from a grenade launcher."
	item_cost = 40
	antag_roles = list(MODE_MERCENARY)
	path = /obj/item/storage/box/fragshells

/datum/uplink_item/item/grenades/frag
	name = "1x Fragmentation Grenade"
	item_cost = 10
	path = /obj/item/grenade/frag

/datum/uplink_item/item/grenades/frags
	name = "5x Fragmentation Grenades"
	item_cost = 40
	path = /obj/item/storage/box/frags

/datum/uplink_item/item/grenades/supermatter
	name = "1x Supermatter Grenade"
	desc = "This grenade contains a small supermatter shard which will delaminate upon activation and pull in nearby objects, irradiate lifeforms, and eventually explode."
	item_cost = 15
	path = /obj/item/grenade/supermatter

/datum/uplink_item/item/grenades/supermatters
	name = "5x Supermatter Grenades"
	desc = "These grenades contains a small supermatter shard which will delaminate upon activation and pull in nearby objects, irradiate lifeforms, and eventually explode."
	item_cost = 60
	antag_roles = list(MODE_MERCENARY) // Keep this Merc only.
	path = /obj/item/storage/box/supermatters

/datum/uplink_item/item/grenades/metalfoam
	name = "1x Metal Foam Grenade"
	item_cost = 4
	path = /obj/item/grenade/chem_grenade/metalfoam

/datum/uplink_item/item/grenades/metalfoams
	name = "5x Metal Foam Grenades"
	item_cost = 16
	path = /obj/item/storage/box/metalfoams

/datum/uplink_item/item/grenades/minibomb
	name = "1x Syndicate Minibomb"
	desc = "A highly dangerous non-fragmenting explosive, capable of grevious damage to anything in it's radius."
	item_cost = 28
	path = /obj/item/grenade/syndieminibomb
	antag_costs = list(MODE_MERCENARY = 38) // Lots of structural damage.
