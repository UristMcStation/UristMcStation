// Alien clothing.

//Teshari Clothing
/datum/gear/uniform/resomi
	display_name = "smock, grey (Teshari)"
	path = /obj/item/clothing/under/resomi
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_RESOMI)

/datum/gear/uniform/resomi/rainbow
	display_name = "smock, rainbow (Teshari)"
	path = /obj/item/clothing/under/resomi/rainbow

/datum/gear/uniform/resomi/white
	display_name = "smock, colored (Teshari)"
	path = /obj/item/clothing/under/resomi/white
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/resomi/dress
	display_name = "dress, fancy (Teshari)"
	path = /obj/item/clothing/under/resomi/dress

/datum/gear/uniform/resomi/formal
	display_name = "formal uniform (Teshari)"
	path = /obj/item/clothing/under/resomi/formal

/datum/gear/uniform/resomi/eng
	display_name = "uniform, Engineering (Teshari)"
	path = /obj/item/clothing/under/resomi/yellow
	allowed_roles = list(/datum/job/chief_engineer, /datum/job/engineer)

/datum/gear/uniform/resomi/sec
	display_name = "uniform, Security (Teshari)"
	path = /obj/item/clothing/under/resomi/red
	allowed_roles = list(/datum/job/officer, /datum/job/hos, /datum/job/warden, /datum/job/detective)

/datum/gear/uniform/resomi/med
	display_name = "uniform, Medical (Teshari)"
	path = /obj/item/clothing/under/resomi/medical

/datum/gear/uniform/resomi/science
	display_name = "uniform, Science (Teshari)"
	path = /obj/item/clothing/under/resomi/science

/datum/gear/uniform/resomi/coat
	display_name = "small coat (Teshari)"
	path = /obj/item/clothing/suit/storage/toggle/urist/resomicoat
