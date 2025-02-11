/material/skin/goat/generate_recipes(reinforce_material)
	. = ..(reinforce_material)

	. += new/datum/stack_recipe/goatpelt(src)
	. += new/datum/stack_recipe/sheeppelt(src)

/material/skin/fur/brown/generate_recipes(reinforce_material)
	. = ..(reinforce_material)

	. += new/datum/stack_recipe/brownbearpelt(src)
	. += new/datum/stack_recipe/bisonpelt(src)
	. += new/datum/stack_recipe/bisonhat(src)
	. += new/datum/stack_recipe/lionpelt(src)
	. += new/datum/stack_recipe/foxpelt(src)

/material/skin/fur/gray/generate_recipes(reinforce_material)
	. = ..(reinforce_material)

	. += new/datum/stack_recipe/graywolfpelt(src)

/material/skin/fur/white/generate_recipes(reinforce_material)
	. = ..(reinforce_material)

	. += new/datum/stack_recipe/whitewolfpelt(src)
	. += new/datum/stack_recipe/whitebearpelt(src)
	. += new/datum/stack_recipe/whitefoxpelt(src)

/material/skin/fur/black/generate_recipes(reinforce_material)
	. = ..(reinforce_material)

	. += new/datum/stack_recipe/pantherpelt(src)
	. += new/datum/stack_recipe/blackbearpelt(src)

/material/skin/lizard/generate_recipes(reinforce_material)
	. = ..(reinforce_material)

	. += new/datum/stack_recipe/gatorpelt(src)
	. += new/datum/stack_recipe/lizardpelt(src)

/material/skin/lizard/generate_recipes(reinforce_material)
	. = ..(reinforce_material)

	. += new/datum/stack_recipe/gatorpelt(src)
	. += new/datum/stack_recipe/lizardpelt(src)


/datum/stack_recipe/goatpelt
	title = "goat pelt"
	result_type = /obj/item/clothing/head/urist/pelt/goat
	req_amount = 8
	time = 30

/datum/stack_recipe/sheeppelt
	title = "sheep pelt"
	result_type = /obj/item/clothing/head/urist/pelt/sheep
	req_amount = 8
	time = 30

/datum/stack_recipe/brownbearpelt
	title = "bear pelt"
	result_type = /obj/item/clothing/head/urist/pelt/bear/brown
	req_amount = 15
	time = 30

/datum/stack_recipe/graywolfpelt
	title = "wolf pelt"
	result_type = /obj/item/clothing/head/urist/pelt/wolf
	req_amount = 8
	time = 30

/datum/stack_recipe/whitewolfpelt
	title = "wolf pelt"
	result_type = /obj/item/clothing/head/urist/pelt/wolf/white
	req_amount = 8
	time = 30

/datum/stack_recipe/whitebearpelt
	title = "bear pelt"
	result_type = /obj/item/clothing/head/urist/pelt/bear/white
	req_amount = 15
	time = 30

/datum/stack_recipe/pantherpelt
	title = "panther pelt"
	result_type = /obj/item/clothing/head/urist/pelt/panther
	req_amount = 8
	time = 30

/datum/stack_recipe/blackbearpelt
	title = "bear pelt"
	result_type = /obj/item/clothing/head/urist/pelt/bear
	req_amount = 15
	time = 30

/datum/stack_recipe/bisonpelt
	title = "bison pelt"
	result_type = /obj/item/clothing/head/urist/pelt/
	req_amount = 15
	time = 30

/datum/stack_recipe/bisonhat
	title = "bison hat"
	result_type = /obj/item/clothing/head/urist/pelt/bisonhat
	req_amount = 7
	time = 30

/datum/stack_recipe/lizardpelt
	title = "lizard pelt"
	result_type = /obj/item/clothing/head/urist/pelt/lizard
	req_amount = 3
	time = 30

/datum/stack_recipe/gatorpelt
	title = "gator pelt"
	result_type = /obj/item/clothing/head/urist/pelt/gator
	req_amount = 6
	time = 30

/datum/stack_recipe/lionpelt
	title = "lion pelt"
	result_type = /obj/item/clothing/head/urist/pelt/lion
	req_amount = 8
	time = 30

/datum/stack_recipe/foxpelt
	title = "fox pelt"
	result_type = /obj/item/clothing/head/urist/pelt/fox
	req_amount = 4
	time = 30

/datum/stack_recipe/whitefoxpelt
	title = "fox pelt"
	result_type = /obj/item/clothing/head/urist/pelt/whitefox
	req_amount = 4
	time = 30
