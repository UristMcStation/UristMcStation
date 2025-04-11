var/global/const/access_morninglight = "ACCESS_MORNING_LIGHT" //850
/datum/access/morninglight
	id = access_morninglight
	desc = "Scavenger Crew"
	region = ACCESS_REGION_NONE

/singleton/hierarchy/outfit/job/colony_scavenger
	name = "Graveworld Scavenger"
	uniform = /obj/item/clothing/under/overalls
	shoes = /obj/item/clothing/shoes/dutyboots
	belt = /obj/item/storage/belt/utility/full
	id_types = list(/obj/item/card/id/morninglight)
	suit = /obj/item/clothing/suit/storage/hooded/sandsuit
	glasses = /obj/item/clothing/glasses/lgoggles
	mask = /obj/item/clothing/mask/urist/bandana/leather
	gloves = /obj/item/clothing/gloves/urist/leather
	l_pocket = /obj/item/device/radio
	r_pocket = /obj/item/modular_computer/pda
	back = /obj/item/storage/backpack/rucksack/tan
	backpack_contents = list(/obj/item/device/flashlight = 1, /obj/item/storage/firstaid/regular = 1, /obj/item/gun/projectile/revolver/webley = 1, /obj/item/ammo_magazine/speedloader/magnum = 2)

/obj/item/card/id/morninglight
	access = list(access_morninglight, access_merchant)

/datum/job/submap/colony_scavenger
	title = "Graveworld Scavenger"
	supervisors = "whatever's left of your conscience"
	total_positions = 3
	outfit_type = /singleton/hierarchy/outfit/job/colony_scavenger
	info = "You've recently become part of a small scale scavenging operation in the outer ring, \
			digging through the ruins of Graveworlds, the planets abandoned or razed during the Galactic Crisis. \
			You have access to your ship, the ICS Morning Light, an ugly little scrapheap with a pretty name. \
			There is also a nearby trading station, where you could likely make some good money with what you find. \
			Good luck, and be careful. There's a reason these worlds haven't been resettled."

/obj/submap_landmark/spawnpoint/colony_scavenger
	name = "Graveworld Scavenger"
