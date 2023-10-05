#include "crystalized_drugs_areas.dm"
#include "crystalized_drugs_items.dm"
#include "crystalized_drugs_tiles.dm"

/datum/map_template/ruin/away_site/crystaldrugs
	name = "Drug Manufacturing Lab"
	id = "awaysite_drug_lab"
	description = "An active drug manufacturing facility with smuggler ship."
	suffixes = list("crystalized_drugs/crystalized_drugs-1.dmm")
	spawn_cost = 1
	player_cost = 0
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/bacchus)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/obj/effect/overmap/visitable/sector/drug_lab
	name = "bluespace wake traces"
	desc = "Initial sector readings reported numerous bluespace wake traces from within this sector. Sensor reports indicate asteroids with abnormal refraction indexes are detected along with energy spikes."
	icon_state = "object"
	known = FALSE

/obj/effect/overmap/visitable/ship/landable/bacchus
	name = "ITV Bacchus"
	classification = "cargo vessel"
	shuttle = "ITV Bacchus"
	fore_dir = WEST
	vessel_mass = 750
	vessel_size = SHIP_SIZE_TINY

/datum/shuttle/autodock/overmap/bacchus
	name = "ITV Bacchus"
	warmup_time = 10
	move_time = 20
	shuttle_area = list(/area/crystaldrugs/bacchus,/area/crystaldrugs/bacchus/dorms,/area/crystaldrugs/bacchus/cargo,/area/crystaldrugs/bacchus/engine)
	current_location = "nav_crystaldrug_bacchus"
	dock_target = "crystaldrug"
	fuel_consumption = 0.7 // living the silent running life
	range = 3
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/bacchus
	name = "Bacchus Dock"
	landmark_tag = "nav_crystaldrug_bacchus"
	docking_controller = "druglab"
	base_area = /area/space
	base_turf = /turf/space

/obj/machinery/computer/shuttle_control/explore/bacchus
	name = "bacchus control console"
	shuttle_tag = "ITV Bacchus"

/area/crystaldrugs/bacchus
	name = "\improper ITV Bacchus Bridge"
	icon_state = "shuttle"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/crystaldrugs/bacchus/dorms
	name = "\improper ITV Bacchus Dormitory"

/area/crystaldrugs/bacchus/cargo
	name = "\improper ITV Bacchus Cargo Hold"

/area/crystaldrugs/bacchus/engine
	name = "\improper ITV Bacchus Engine Compartment"

/obj/effect/away_variety_loader/crystaldrugs
	weighted_templates = list('crystalized_drugs_active.dmm','crystalized_drugs_psycho.dmm')
	away_name = "Crystalized Drugs"