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
	generate_mining_by_z = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/bacchus)

/obj/effect/overmap/visitable/sector/drug_lab
	name = "bluespace wake traces"
	desc = "Initial sector readings reported numerous bluespace wake traces from within this sector. Sensor reports indicate asteroids with abnormal refraction indexes are detected along with energy spikes."
	icon_state = "object"
	known = FALSE

/obj/effect/overmap/visitable/sector/drug_lab/generate_skybox()
	var/image/res = overlay_image('icons/skybox/rockbox.dmi', "rockbox", COLOR_ASTEROID_ROCK, RESET_COLOR)
	res.blend_mode = BLEND_OVERLAY
	return res

/obj/effect/overmap/visitable/sector/drug_lab/get_skybox_representation()
	var/image/res = overlay_image('icons/skybox/rockbox.dmi', "rockbox", COLOR_ASTEROID_ROCK, RESET_COLOR)
	res.blend_mode = BLEND_OVERLAY
	res.SetTransform(scale = 0.5)
	return res

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

/obj/effect/landmark/map_load_mark/crystal_drugs
	templates = list(/datum/map_template/crystal_drugs_active,/datum/map_template/crystal_drugs_psycho)
	load_centered = FALSE

/datum/map_template/crystal_drugs_psycho
	name = "psycho drug smugglers"
	id = "crystaldrugs_1"
	mappaths = list('maps/away/crystalized_drugs/crystalized_drugs_psycho.dmm')

/datum/map_template/crystal_drugs_active
	name = "active drug smugglers"
	id = "crystaldrugs_2"
	mappaths = list('maps/away/crystalized_drugs/crystalized_drugs_active.dmm')

/obj/effect/computer_file_creator/crystal_drugs_dc
	file_info = "This week's vault code: 0451\[br]Delete this file after opening."
	file_name = "delete_after_reading"

/obj/effect/computer_file_creator/crystal_drugs_eml
	file_info = "Hey Carter! Hope you're still holding out up there.\[br]Hope the Trade Union isn't working you too hard. I've been hearing some worrying stories about them, but nothing from your sector. I'm sure it's just a bad manager out there.\[br]Anyway, can't wait to see you home again soon!\[br]Love, Emilia"
	file_name = "EML_from_emilia"

/obj/effect/computer_file_creator/crystal_drugs_recipe
	file_info = "Found an interesting compound last night. Incredible rejuvinating effects on the rats we have lying around here.\[br]Some of our regular smugglers mentioned they'd be interested in buying some. Assistant, put together 30u ph, 10u peri, and 10u parox for when our buyers next arrive.\[br]The rats from yesterday are nowhere to be found, seems they've become more skittish since the test treatments. Perhaps a psychological side-effect?"
	file_name = "special_recipe"

/obj/effect/computer_file_creator/crystal_drugs_receipt
	file_info = "Order #97f2b\[br]Thank you for conducting business with Vey-Med Chemical Supply.\[br]Your pickup location is: Nyx-sector NT Trading Station ID#522\[br]If this is your first time purchasing, please meet with a Vey-Med representative to verify your identity for an access keycard."
	file_name = "veymed_receipt"
