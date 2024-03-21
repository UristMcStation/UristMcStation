/datum/map_template/ruin/exoplanet/container_yard
	name = "Raided shipping container yard"
	id = "container_yard"
	description = "An abandoned shipping container yard with a warehouse and damaged scav shuttle."
	suffixes = list("container_yard/container_yard.dmm")
	spawn_cost = 0.5
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/old_snz)
	apc_test_exempt_areas = list(
		/area/map_template/container_yard/airstrip = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/map_template/container_yard/smes_crate = NO_SCRUBBER|NO_VENT,
		/area/map_template/container_yard/cabin_crate = NO_SCRUBBER|NO_VENT,
		/area/map_template/container_yard/control_crate = NO_SCRUBBER|NO_VENT
	)
	ruin_tags = RUIN_HUMAN|RUIN_WRECK
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS

	skip_main_unit_tests = "Ruin has shuttle landmark."

/area/map_template/container_yard/old_snz
	name = "\improper SNZ-210 Personnel Carrier"
	icon_state = "shuttlegrn"

/area/map_template/container_yard/smes_crate
	name = "\improper container yard Backup Generator crate"
	icon_state = "security_sub"

/area/map_template/container_yard/cabin_crate
	name = "\improper container yard Cabin crate"
	icon_state = "crew_quarters"

/area/map_template/container_yard/control_crate
	name = "\improper container yard Electrical Control crate"
	icon_state = "engineering_supply"

/area/map_template/container_yard/warehouse
	name = "\improper container yard Warehouse"
	icon_state = "storage"

/area/map_template/container_yard/airstrip
	name = "\improper container yard Airstrip"
	icon_state = "shuttle2"
	area_flags = AREA_FLAG_EXTERNAL

/datum/shuttle/autodock/overmap/old_snz
	name = "SNZ-210 Personnel Carrier"
	dock_target = "oldsnz_shuttle"
	current_location = "nav_oldsnz_start"
	range = 1
	shuttle_area = /area/map_template/container_yard/old_snz
	fuel_consumption = 4
	defer_initialisation = TRUE
	flags = SHUTTLE_FLAGS_PROCESS
	ceiling_type = /turf/simulated/floor/shuttle_ceiling

/obj/machinery/computer/shuttle_control/explore/old_snz
	name = "SNZ-210 Shuttle control console"
	shuttle_tag = "SNZ-210 Personnel Carrier"

/obj/overmap/visitable/ship/landable/old_snz
	name = "SNZ-210 Personnel Carrier"
	desc = "SNZ-210 'Little Beetle' Personnel Carrier. Multipurpose shuttle once used for intraplanetary fast mail delivery. Obsolete even before the Crisis."
	shuttle = "SNZ-210 Personnel Carrier"
	fore_dir = WEST
	color = "#8dc0d8"
	vessel_mass = 2500
	vessel_size = SHIP_SIZE_TINY

/obj/shuttle_landmark/old_snz/start
	name = "container yard Airstrip"
	landmark_tag = "nav_oldsnz_start"
	base_area = /area/map_template/container_yard/airstrip
	base_turf = /turf/simulated/floor/exoplanet/concrete
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/item/paper/container_yard
	language = LANGUAGE_HUMAN_IBERIAN

/obj/item/paper/container_yard/first
	name = "To Diego"
	info = {"
		<p>Diego, please don't make a scene about the fact that you're being forced to fly out to the edge of nowhere again.</p>
		<p>It's just a warehouse - a mountain of containers piled in one place, ready for the taking. It's even got a spot to land.</p>
		<p>I didn't buy the hopper from those graveworlders to just leave it in the hanger, so quit whining and get your haul for the week.</p>
		"}

/obj/item/paper/container_yard/second
		name = "Letter to an asshole"
		info = {"
		<p>Carlos, this is all kinds of fucked up - if you are reading this, it means I'm DEAD</p>
		<p>We were flying this hunk of scrap to the warehouse, I think a piece of space junk hit us as we were descending</p>
		<p>Engines are seized, the hull is torn, and we're not going to leave until we patch it.</p>
		<p>If something happens to me, my older brother is gonna tear you a new one!!!</p>
		"}

/obj/item/paper/container_yard/third
		name = "Another letter to Carlos"
		info = {"
		<p>Carlos, this in case the computer fails</p>
		<p>Some overgrown space parrots from a movie followed us down, they shot at us. We're taking apart the fence around this warehouse for barricades to hold them off.</p>
		<p>You better hope we make it out of here, or you're not seeing a single goddamn thaler</p>
		<p>Now it looks like they're dropping something from the air? Looks like eggs from here.</p>
		<p>None of us knows, so we're gonna head out and see what they are. Will write our findings</p>
		"}
