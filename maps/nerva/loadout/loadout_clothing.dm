/datum/gear/clothing/croptop
	display_name = "croptop"
	path = /obj/item/clothing/accessory/urist/croptop

/datum/gear/clothing/croptop/New()
	..()
	var/list/croptops = list()
	croptops["heart croptop"] = /obj/item/clothing/accessory/urist/croptop
	croptops["sweater croptop"] = /obj/item/clothing/accessory/urist/croptop/sweater
	croptops["blue croptop"] = /obj/item/clothing/accessory/urist/croptop/blue
	croptops["nt croptop"] = /obj/item/clothing/accessory/urist/croptop/nt
	croptops["pink croptop"] = /obj/item/clothing/accessory/urist/croptop/pink
	croptops["tropical croptop"] = /obj/item/clothing/accessory/urist/croptop/tropical
	gear_tweaks += new/datum/gear_tweak/path(croptops)
