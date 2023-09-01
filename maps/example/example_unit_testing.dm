/datum/map/example
	// Unit test exemptions
	apc_test_exempt_areas = list(
		/area/space = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/shuttle/escape = NO_SCRUBBER|NO_VENT|NO_APC
	)

	area_usage_test_exempted_areas = list(
		/area/rnd/xenobiology/cell_1,
		/area/rnd/xenobiology/cell_2,
		/area/rnd/xenobiology/cell_3,
		/area/rnd/xenobiology/cell_4,
		/area/chapel,
		/area/hallway,
		/area/supply,
		/area/beach,
		/area/engineering,
		/area/turbolift,
		/area/template_noop,
		/area/overmap,
		/area/infestation,
		/area/boarding_ship,
		/area/ship,
		/area/syndicate_elite_squad
	)

	area_usage_test_exempted_root_areas = list(
		/area/shuttle/naval1,
		/area/shuttle/scom,
		/area/shuttle/train,
		/area/shuttle/event1,
		/area/shuttle/event2,
		/area/shuttle/assault,
		/area/shuttle/infestation,
		/area/centcom,
		/area/security,
		/area/rnd,
		/area/shuttle,
		/area/exoplanet,
		/area/awaymission,
		/area/scom,
		/area/planet,
		/area/jungleoutpost,
		/area/map_template,
		/area/icarus
	)
