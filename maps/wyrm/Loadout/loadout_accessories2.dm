/datum/gear/accessory/ubac
	display_name = "ubac selection"
	path = /obj/item/clothing/accessory/ubac

/datum/gear/accessory/ubac/New()
	..()
	var/ubac = list()
	ubac["black ubac"] = /obj/item/clothing/accessory/ubac
	ubac["tan ubac"] = /obj/item/clothing/accessory/ubac/tan
	ubac["green ubac"] = /obj/item/clothing/accessory/ubac/green
	gear_tweaks += new/datum/gear_tweak/path(ubac)

/datum/gear/accessory/dashiki
	display_name = "dashiki selection"
	path = /obj/item/clothing/accessory/dashiki

/datum/gear/accessory/dashiki/New()
	..()
	var/dashiki = list()
	dashiki["black dashiki"] = /obj/item/clothing/accessory/dashiki
	dashiki["red dashiki"] = /obj/item/clothing/accessory/dashiki/red
	dashiki["blue dashiki"] = /obj/item/clothing/accessory/dashiki/blue
	gear_tweaks += new/datum/gear_tweak/path(dashiki)

/datum/gear/accessory/colourtop
	display_name = "colourable tops selection"
	path = /obj/item/clothing/accessory/sweater
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/colourtop/New()
	..()
	var/colourtop = list()
	colourtop["turtleneck sweater"] = /obj/item/clothing/accessory/sweater
	colourtop["qipao"] = /obj/item/clothing/accessory/qipao
	colourtop["sherwani"] = /obj/item/clothing/accessory/sherwani
	gear_tweaks += new/datum/gear_tweak/path(colourtop)