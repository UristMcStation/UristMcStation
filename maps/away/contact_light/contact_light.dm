/datum/map_template/ruin/away_site/contact_light
	name = "Contact Light"
	id = "awaysite_contact_light"
	description = "A broken cargo ship."
	suffixes = list("contact_light/contact_light.dmm")
	cost = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/lanius)

/obj/effect/overmap/sector/distress
	name = "distress signal"
	desc = "Emergency signal detected. No further data avaliable."
	icon_state = "event"
	initial_restricted_waypoints = list(
		"Hatchling" = list("distress_signal"),
		"Aura" = list("contact_light_lanius")
	)

/datum/shuttle/autodock/overmap/lanius
	name = "Aura"
	move_time = 40
	shuttle_area = /area/lanius/start
	current_location = "contact_light_lanius"
	landmark_transition = "nav_transit_lanius"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/distress
	name = "Unknown Navpoint"
	landmark_tag = "distress_signal"

/obj/effect/shuttle_landmark/contact_light_lanius
	name = "Unknown Navpoint"
	landmark_tag = "contact_light_lanius"

/area/lanius/start
	name = "\improper Aura"
	icon_state = "shuttlered"
	requires_power = 1
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED