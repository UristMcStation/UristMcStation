/datum/job/submap/colony_scavenger
	title = "Graveworld Scavenger"
	supervisors = "whatever's left of your conscience"
	total_positions = 3
	outfit_type = /decl/hierarchy/outfit/colony_scavenger
	info = "You've recently become part of a small scale scavenging operation in the outer ring, \
			digging through the ruins of Graveworlds, the planets abandoned or razed during the Galactic Crisis. \
			You have access to your ship, the ICS Morning Light, an ugly little scrapheap with a pretty name. \
			There is also a nearby trading station, where you could likely make some good money with what you find. \
			Good luck, and be careful. There's a reason these worlds haven't been resettled."

/obj/effect/submap_landmark/spawnpoint/colony_scavenger
	name = "Graveworld Scavenger"

/var/const/access_morninglight = "ACCESS_MORNING_LIGHT" //850
/datum/access/morninglight
	id = access_morninglight
	desc = "Scavenger Crew"
	region = ACCESS_REGION_NONE

/obj/item/weapon/card/id/morninglight
	access = list(access_morninglight, access_merchant)