/datum/gear/gloves
	cost = 2
	slot = slot_gloves
	sort_category = "Gloves and Handwear"
	category = /datum/gear/gloves

/datum/gear/gloves/colored
	display_name = "gloves, colored"
	flags = GEAR_HAS_COLOR_SELECTION
	path = /obj/item/clothing/gloves/color

/datum/gear/gloves/latex
	display_name = "gloves, latex"
	path = /obj/item/clothing/gloves/latex
	cost = 3
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/gloves/nitrile
	display_name = "gloves, nitrile"
	path = /obj/item/clothing/gloves/latex/nitrile
	cost = 3
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/gloves/rainbow
	display_name = "gloves, rainbow"
	path = /obj/item/clothing/gloves/rainbow

/datum/gear/gloves/evening
	display_name = "gloves, evening, colour select"
	path = /obj/item/clothing/gloves/color/evening
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/gloves/botany
	display_name = "gloves, botany"
	path = /obj/item/clothing/gloves/thick/botany
	cost = 3
	allowed_roles = list(
		/datum/job/rd,
		/datum/job/scientist,
		/datum/job/chef,
		/datum/job/assistant
	)

/datum/gear/gloves/work
	display_name = "gloves, work"
	path = /obj/item/clothing/gloves/thick
	cost = 3
