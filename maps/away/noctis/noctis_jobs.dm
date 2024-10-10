/datum/job/submap/noctis_crew
	title = "Hijacker"
	supervisors = "whatever's left of your conscience"
	total_positions = 2
	outfit_type = /singleton/hierarchy/outfit/job/pirate_hijacker
	info = "You've recently become part of a small scale hijacking operation in the outer ring. \
			The last job you did with your team was taking over this small exploration ship for the purposes of refitting it for combat, \
			however, your shift is long past due and nobody seems to have woken you up."

/datum/job/submap/noctis_crew/New(datum/submap/_owner, var/abstract_job = FALSE)
	if(prob(90))
		title = "Exploration Crewmember"
		total_positions = 3
		outfit_type = /singleton/hierarchy/outfit/job/exploration_crew
		info = "You've recently been contracted as a general crew member for an outer ring exploration vessel in search of abormal artifacts. \
				It appears, however, that your ship has been raided while you were in cryosleep, leaving it as a half functional mess floating through space."
	..()

/obj/effect/submap_landmark/spawnpoint/hijacker
	name = "Hijacker"

/obj/effect/submap_landmark/spawnpoint/crewmember
	name = "Exploration Crewmember"

/singleton/hierarchy/outfit/job/pirate_hijacker
	name = "Noctis - Job - Hijacker"
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/armor/pcarrier/light/hijacker
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/mask/bandana/red
	id_types = list(/obj/item/card/id/noctis)
	flags = OUTFIT_HAS_BACKPACK

/singleton/hierarchy/outfit/job/exploration_crew
	name = "Noctis - Job - Exploration Crew"
	uniform = /obj/item/clothing/under/frontier
	shoes = /obj/item/clothing/shoes/workboots
	belt = /obj/item/storage/belt/utility/full
	id_types = list(/obj/item/card/id/noctis)

var/global/const/access_noctis = "ACCESS_NOCTIS" //850
/datum/access/noctis
	id = access_noctis
	desc = "Explorer Crew"
	region = ACCESS_REGION_NONE

/obj/item/card/id/noctis
	access = list(access_noctis, access_merchant)

/singleton/hierarchy/outfit/freightercap
	name = "Freighter Captain"
	uniform = /obj/item/clothing/under/shorts/jeans/grey
	suit = /obj/item/clothing/suit/armor/vest/jacket
	shoes = /obj/item/clothing/shoes/workboots
	head = /obj/item/clothing/head/beret/solgov/customs
	mask = /obj/item/clothing/mask/smokable/cigarette/cigar
	r_pocket = /obj/item/flame/lighter/zippo
