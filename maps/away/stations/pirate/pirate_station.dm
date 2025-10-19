/area/spacestations/pirate
	name = "Pirate Hideout"
	base_turf = /turf/simulated/floor/asteroid

/area/spacestations/pirate/asteroid
	name = "Pirate Asteroid"
	icon_state = "yellow"

/area/spacestations/pirate/station
	name = "Pirate Station - Lower Level"

/area/spacestations/pirate/station/upper
	name = "Pirate Station - Upper Level"
	base_turf = /turf/simulated/open
	icon_state = "red"

/area/spacestations/pirate/exterior
	base_turf = /turf/simulated/open
	icon_state = "yellow"

var/global/const/access_away_pirate_station = "ACCESS_AWAY_PIRATE_STATION"
/datum/access/away_pirate_station
	id = access_away_pirate_station
	desc = "Pirate Station"
	access_type = ACCESS_TYPE_NONE
	region = ACCESS_REGION_NONE

/obj/overmap/visitable/sector/station/hostile/pirate
	name = "large asteroid"
	desc = "Sensor array detects a large asteroid."
	icon = 'icons/obj/overmap.dmi'
	icon_state = "meteor4"
	faction = /datum/factions/pirate
	color = "#fc1100"
	station_holder = /mob/living/simple_animal/hostile/overmapship/station_holder/pirate
	total_ships = 2
	remaining_ships = 4
	sensor_visibility = 10
	hidden = TRUE
	sector_flags = FLAGS_OFF
	spawn_ships = TRUE
	spawn_types = list(/mob/living/simple_animal/hostile/overmapship/pirate/small, /mob/living/simple_animal/hostile/overmapship/pirate/gantry)
	assigned_contracts = list(/datum/contract/shiphunt/pirate, /datum/contract/station_destroy/pirate)
	initial_generic_waypoints = list(
		"nav_piratestation_1",
		"nav_piratestation_2",
		"nav_piratestation_3"
		)

/obj/overmap/visitable/sector/station/hostile/pirate/generate_skybox()
	return overlay_image('icons/skybox/rockbox.dmi', "rockbox", COLOR_ASTEROID_ROCK, RESET_COLOR)

/obj/overmap/visitable/sector/station/hostile/pirate/get_skybox_representation()
	var/image/res = overlay_image('icons/skybox/rockbox.dmi', "rockbox", COLOR_ASTEROID_ROCK, RESET_COLOR)
	res.blend_mode = BLEND_OVERLAY
	res.SetTransform(scale = 0.3)
	return res

/datum/map_template/ruin/away_site/piratestation
	name = "Pirate Station"
	id = "awaysite_piratestation"
	description = "A hidden pirate station, tucked away on an asteroid."
	suffixes = list("stations/pirate/pirate_station-1.dmm", "stations/pirate/pirate_station-2.dmm")
	spawn_cost = 0
	accessibility_weight = 10
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED
	generate_mining_by_z = list(1,2)

/obj/shuttle_landmark/nav_piratestation
	special = TRUE
	spawn_id = "pirate_station"

/obj/shuttle_landmark/nav_piratestation/on_landing()
	for(var/obj/urist_intangible/triggers/away_ai_landmark/A in GLOB.trigger_landmarks)
		if(A.spawn_id == src.spawn_id)
			A.spawn_mobs()

	special = FALSE

/obj/shuttle_landmark/nav_piratestation/nav1
	name = "Station Exterior - East"
	landmark_tag = "nav_piratestation_1"
	base_area = /area/spacestations/pirate/asteroid
	base_turf = /turf/simulated/floor/asteroid

/obj/shuttle_landmark/nav_piratestation/nav2
	name = "Station Exterior - North"
	landmark_tag = "nav_piratestation_2"
	base_area = /area/spacestations/pirate/asteroid
	base_turf = /turf/simulated/floor/asteroid

/obj/shuttle_landmark/nav_piratestation/nav3
	name = "Station Exterior - Above"
	landmark_tag = "nav_piratestation_3"
	base_area = /area/spacestations/pirate/exterior
	base_turf = /turf/simulated/open

/obj/overmap/visitable/sector/station/hostile/pirate/update_visible()
	if(hidden)
		icon = 'icons/urist/misc/overmap.dmi'
		icon_state = "station_asteroid_0"
		color = "#660000"
		hidden = FALSE
		make_known(TRUE)
		layer = ABOVE_LIGHTING_LAYER
		plane = EFFECTS_ABOVE_LIGHTING_PLANE

//money values are very much in flux

/datum/contract/shiphunt/pirate
	name = "Pirate Ship Hunt Contract"
	neg_faction = /datum/factions/pirate
	points_per_unit = 3
	money = 4000

//station destroy

/datum/contract/station_destroy/pirate
	name = "Pirate Hideout Destruction Contract"
	desc = "This sector is plagued by pirates, who have set up a base somewhere in the asteroid fields. We need you to hunt down their hideout and destroy it for good. You can probably find more details regarding its location onboard the pirates' vessels."
	neg_faction = /datum/factions/pirate
	rep_points = 10
	money = 30000
