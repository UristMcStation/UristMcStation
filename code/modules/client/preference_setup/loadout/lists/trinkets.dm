// Small items of little importance; adding another category helps squash General a little.
/datum/gear/trinket
	sort_category = "Trinkets"
	category = /datum/gear/trinket
	cost = 1

/datum/gear/trinket/locket
	display_name = "locket"
	path = /obj/item/clothing/accessory/locket

/datum/gear/trinket/bracelet
	display_name = "bracelet, color select"
	path = /obj/item/clothing/accessory/bracelet
	cost = 1
	flags = GEAR_HAS_COLOR_SELECTION


/datum/gear/trinket/wristwatch
	display_name = "wrist watch selection"
	path = /obj/item/clothing/accessory/wristwatches
	cost = 1
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/trinket/necklace
	display_name = "necklace, colour select"
	path = /obj/item/clothing/accessory/necklace
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/trinket/ntaward
	display_name = "corporate award selection"
	description = "A medal or ribbon awarded to corporate personnel for significant accomplishments."
	path = /obj/item/clothing/accessory/medal
	cost = 8
	flags = GEAR_HAS_NO_CUSTOMIZATION


/datum/gear/trinket/ntaward/New()
	..()
	var/ntawards = list()
	ntawards["sciences medal"] = /obj/item/clothing/accessory/medal/bronze/nanotrasen
	ntawards["distinguished service"] = /obj/item/clothing/accessory/medal/silver/nanotrasen
	ntawards["command medal"] = /obj/item/clothing/accessory/medal/gold/nanotrasen
	gear_tweaks += new/datum/gear_tweak/path(ntawards)

/datum/gear/trinket/ftu_pin
	display_name = "Free Trade Union pin"
	path = /obj/item/clothing/accessory/ftu_pin
	flags = GEAR_HAS_NO_CUSTOMIZATION
