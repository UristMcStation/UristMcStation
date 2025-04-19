var/global/const/access_contact = "ACCESS_CONTACT"	//202

/datum/access/contact
	id = access_contact
	desc = "Contact Light Crew"
	region = ACCESS_REGION_NONE

/datum/map_template/ruin/away_site/contact_light
	name = "Contact Light"
	id = "awaysite_contact_light"
	description = "A broken cargo ship."
	suffixes = list("contact_light/contact_light.dmm")
	spawn_cost = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/lanius)

/obj/overmap/visitable/distress
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

/obj/shuttle_landmark/distress
	name = "Unknown Navpoint"
	landmark_tag = "distress_signal"

/obj/shuttle_landmark/contact_light_lanius
	name = "Unknown Navpoint"
	landmark_tag = "contact_light_lanius"

/area/lanius/start
	name = "\improper Aura"
	icon_state = "shuttlered"
	requires_power = 1
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/away/forgotten
	name = "\improper Contact Light"
	has_gravity = 0

/area/away/forgotten2
	name = "\improper Contact Light"
	has_gravity = 0
