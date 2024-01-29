//below are ported from polaris

#define MATERIAL_SNOW "snow"

/material/snow
	name = MATERIAL_SNOW
	stack_type = /obj/item/stack/material/snow
	flags = MATERIAL_BRITTLE
	integrity = 10
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = COLOR_WHITE
	hardness = MATERIAL_SOFT
	weight = 1
	brute_armor = 1
	stack_origin_tech = list(TECH_MATERIAL = 1)
	ignition_point = T0C+1
	melting_point = T0C+1
	destruction_desc = "crumples"
	sheet_singular_name = "pile"
	sheet_plural_name = "piles"
	burn_armor = 5
	conductive = 0
	value = 0

/material/snow/generate_recipes()
	. = ..()
	. += new/datum/stack_recipe/snowball(src)
	. += new/datum/stack_recipe/snowman(src)
	. += new/datum/stack_recipe/snowborg(src)
	. += new/datum/stack_recipe/snowspider(src)

/datum/stack_recipe/snowball
	title = "snowball"
	result_type = /obj/item/material/snow/snowball
	time = 10
	apply_material_name = FALSE

/datum/stack_recipe/snowman
	title = "snowman"
	result_type = /obj/structure/snowman
	time = 15
	req_amount = 5
	apply_material_name = FALSE

/datum/stack_recipe/snowborg
	title = "snow robot"
	result_type = /obj/structure/snowman/borg
	time = 10
	req_amount = 5
	apply_material_name = FALSE

/datum/stack_recipe/snowspider
	title = "snow spider"
	result_type = /obj/structure/snowman/spider
	time = 20
	req_amount = 10
	apply_material_name = FALSE
