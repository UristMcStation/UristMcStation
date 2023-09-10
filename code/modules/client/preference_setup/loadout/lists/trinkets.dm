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

/datum/gear/trinket/ring
	display_name = "ring selection"
	path = /obj/item/clothing/ring
	cost = 2

/datum/gear/ring/New()
	..()
	var/ringtype = list()
	ringtype["CTI ring"] = /obj/item/clothing/ring/cti
	ringtype["Mariner University ring"] = /obj/item/clothing/ring/mariner
	ringtype["engagement ring"] = /obj/item/clothing/ring/engagement
	ringtype["signet ring"] = /obj/item/clothing/ring/seal/signet
	ringtype["masonic ring"] = /obj/item/clothing/ring/seal/mason
	ringtype["ring, steel"] = /obj/item/clothing/ring/material/steel
	ringtype["ring, plasteel"] = /obj/item/clothing/ring/material/plasteel
	ringtype["ring, bronze"] = /obj/item/clothing/ring/material/bronze
	ringtype["ring, silver"] = /obj/item/clothing/ring/material/silver
	ringtype["ring, gold"] = /obj/item/clothing/ring/material/gold
	ringtype["ring, platinum"] = /obj/item/clothing/ring/material/platinum
	ringtype["ring, glass"] = /obj/item/clothing/ring/material/glass
	ringtype["ring, wood"] = /obj/item/clothing/ring/material/wood
	ringtype["ring, plastic"] = /obj/item/clothing/ring/material/plastic
	gear_tweaks += new/datum/gear_tweak/path(ringtype)
