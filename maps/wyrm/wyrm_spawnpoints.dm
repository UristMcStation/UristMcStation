GLOBAL_LIST_EMPTY(latejoin_cryo_captain)

/datum/map/wyrm
	allowed_spawns = list("Cryogenic Storage", "Secondary Cryogenic Storage", "Cyborg Storage", "Captain Compartment")
	default_spawn = "Secondary Cryogenic Bay"

/datum/spawnpoint/cryo
	msg = "has completed revival in the primary cryogenics bay"

/obj/effect/landmark/latejoin/cryo_captain/New()
	..()
	GLOB.latejoin_cryo_captain |= get_turf(src)
	delete_me = TRUE

/datum/spawnpoint/cryo/captain
	display_name = "Captain Compartment"
	msg = "has completed revival in the captain compartment"
	restrict_job = list("Captain")

/datum/spawnpoint/cryo/captain/New()
	..()
	turfs = GLOB.latejoin_cryo_captain

/obj/effect/landmark/latejoin/cryo_two/New()
	..()
	GLOB.latejoin_cryo2 |= get_turf(src)
	delete_me = TRUE

/datum/spawnpoint/cryo2
	msg = "has completed revival in the secondary cryogenics bay"
