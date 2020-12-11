#include "halper_areas.dm"
#include "halper_jobs.dm"
#include "halper_access.dm"
#include "halper_shuttle.dm"

/obj/effect/submap_landmark/joinable_submap/halper
	name = "IFF Halper"
	archetype = /decl/submap_archetype/derelict/hakper

/decl/submap_archetype/derelict/halper
	descriptor = "damaged prison vessel"
	map = "IFF Halper"
	crew_jobs = list(
		/datum/job/submap/halper_warden,
		/datum/job/submap/halper_guard,
		/datum/job/submap/halper_prisoner
	)

/obj/effect/overmap/ship/halper
	name = "prison freighter"
	color = "#cf5525"
	vessel_mass = 60
	max_speed = 1/(10 SECONDS)
	burn_delay = 2 SECONDS
	initial_restricted_waypoints = list(
		"Valley" = list("nav_halper_dock")
	)
/obj/effect/overmap/ship/halper/New()
	name = "[pick("IFF","PTF","IPV")] [pick("Halper", "Tannhäuser", "Naxos", "Faust")]"	// Named mostly after German Opera guys, they have cool sounding names.
	for(var/area/ship/scrap/A)
		A.name = "\improper [name] - [A.name]"
		GLOB.using_map.area_purity_test_exempt_areas += A.type
	name = "[name], \a [initial(name)]"
	..()

/datum/map_template/ruin/away_site/halper_vessel
	name = "IFF Halper"
	id = "awaysite_halper_vessel"
	description = "A damaged prisoner transport vessel."
	suffixes = list("halper/halper-1.dmm", "halper/halper-2.dmm")
	cost = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/ferry/lift, /datum/shuttle/autodock/overmap/damselfly)

/datum/shuttle/autodock/ferry/prisonlift
	name = "Prisoner Lift"
	shuttle_area = /area/ship/scrap/shuttle/lift
	warmup_time = 3	//give those below some time to get out of the way
	waypoint_station = "nav_prison_lift_bottom"
	waypoint_offsite = "nav_prison_lift_top"
	sound_takeoff = 'sound/effects/lift_heavy_start.ogg'
	sound_landing = 'sound/effects/lift_heavy_stop.ogg'
	ceiling_type = null
	knockdown = 0
	defer_initialisation = TRUE

/obj/machinery/computer/shuttle_control/prisonlift
	name = "prison lift controls"
	shuttle_tag = "Prison Lift"
	ui_template = "shuttle_control_console_lift.tmpl"
	icon_state = "tiny"
	icon_keyboard = "tiny_keyboard"
	icon_screen = "lift"
	density = 0

/obj/effect/shuttle_landmark/lift/prisontop
	name = "Top Deck"
	landmark_tag = "nav_prison_lift_top"
	flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/lift/prisonbottom
	name = "Lower Deck"
	landmark_tag = "nav_prison_lift_bottom"
	base_area = /area// fill this in
	base_turf = /turf/simulated/floor

