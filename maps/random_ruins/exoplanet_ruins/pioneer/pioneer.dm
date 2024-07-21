/datum/map_template/ruin/exoplanet/lonepioneer
	name = "Pioneer Cabin"
	id = "lonepioneer"
	description = "a lone pioneer living in a small cabin."
	suffixes = list("pioneer/pioneer.dmm")
	spawn_cost = 0
	player_cost = 0
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED | TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS | TEMPLATE_FLAG_NO_RADS | TEMPLATE_FLAG_SPAWN_GUARANTEED
	ruin_tags = RUIN_HUMAN|RUIN_HABITAT
	spawn_weight = 0.2
	apc_test_exempt_areas = list(
		/area/map_template/lonepioneer = NO_SCRUBBER|NO_VENT
	)

/singleton/submap_archetype/lonepioneer
	descriptor = "lone pioneer cabin"
	crew_jobs = list(/datum/job/submap/lonepioneer)

/datum/job/submap/lonepioneer
	title = "Lone Pioneer"
	supervisors = "your wits"
	info = "You are a lone pioneer, living in a small cabin you constructed after crashlanding, you are the only survivor of your \
	vessel, UHV-Foxbat. Strike the earth, and seize what resources your planet has to offer, in hopes that another ship will provide\
	you home."
	total_positions = 1
	outfit_type = /singleton/hierarchy/outfit/job/lonepioneer

/singleton/hierarchy/outfit/job/lonepioneer
	name = OUTFIT_JOB_NAME("Lone Pioneer")
	id_types = null
	pda_type = null

/obj/effect/submap_landmark/spawnpoint/lonepioneer
	name = "Lone Pioneer"

/obj/effect/submap_landmark/joinable_submap/lonepioneer
	name = "Pioneer Cabin"
	archetype = /singleton/submap_archetype/lonepioneer

// Areas //
/area/map_template/lonepioneer
	name = "\improper Pioneer Test Area"
	icon_state = "area"
	icon = 'maps/random_ruins/exoplanet_ruins/pioneer/pioneer.dmi'

/area/map_template/lonepioneer/cabin
	name = "\improper Pioneer Cabin"
	icon_state = "cabin"

/area/map_template/lonepioneer/shed
	name = "\improper Pioneer Shed"
	icon_state = "shed"
