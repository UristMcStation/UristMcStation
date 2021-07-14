#define ARMED_ROLES list(/datum/job/captain, /datum/job/firstofficer, /datum/job/hop, /datum/job/blueshield, /datum/job/hos, /datum/job/officer, /datum/job/merchant)
#define COMMAND_ROLES list(/datum/job/captain, /datum/job/firstofficer, /datum/job/hop, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/seniorscientist, /datum/job/qm, /datum/job/hos, /datum/job/blueshield, /datum/job/merchant)

/datum/gear/accessory/armband
	display_name = "armband selection"
	path = /obj/item/clothing/accessory/armband

/datum/gear/accessory/armband/New()
	..()
	var/armbands = list()
	armbands["red armband"] = /obj/item/clothing/accessory/armband
	armbands["cargo armband"] = /obj/item/clothing/accessory/armband/cargo
	armbands["EMT armband"] = /obj/item/clothing/accessory/armband/medgreen
	armbands["medical armband"] = /obj/item/clothing/accessory/armband/med
	armbands["engineering armband"] = /obj/item/clothing/accessory/armband/engine
	armbands["hydroponics armband"] = /obj/item/clothing/accessory/armband/hydro
	armbands["science armband"] = /obj/item/clothing/accessory/armband/science
	armbands["NanoTrasen armband"] = /obj/item/clothing/accessory/armband/whitered
	gear_tweaks += new/datum/gear_tweak/path(armbands)

/datum/gear/accessory/stethoscope
	allowed_roles = list(/datum/job/doctor,/datum/job/cmo)

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

/datum/gear/tactical
	allowed_roles = ARMED_ROLES

/datum/gear/tactical/armor_pouches
	flags = null

/datum/gear/tactical/large_pouches
	flags = null

/datum/gear/tactical/tacticool
	allowed_roles = null

/datum/gear/survivalkit
	display_name = "survival kit"
	path = /obj/item/weapon/storage/box/survivalkit
	allowed_roles = list(/datum/job/qm, /datum/job/cargo_tech)

/datum/gear/accessory/storage/drop_pouches
	display_name = "drop pouches selection"
	path = /obj/item/clothing/accessory/storage/drop_pouches
	allowed_roles = COMMAND_ROLES
	cost = 3

/datum/gear/accessory/storage/drop_pouches/New()
	..()
	var/drop_pouches = list()
	drop_pouches["black drop pouches"] = /obj/item/clothing/accessory/storage/drop_pouches/black
	drop_pouches["brown drop pouches"] = /obj/item/clothing/accessory/storage/drop_pouches/brown
	drop_pouches["white drop pouches"] = /obj/item/clothing/accessory/storage/drop_pouches/white
	gear_tweaks += new/datum/gear_tweak/path(drop_pouches)

/datum/gear/accessory/badge
	display_name = "badge selection"
	path = /obj/item/clothing/accessory/badge
	allowed_roles = list(/datum/job/officer, /datum/job/hos)

/datum/gear/accessory/badge/New()
	..()
	var/badge = list()
	badge["badge"] = /obj/item/clothing/accessory/badge
	badge["holobadge"] = /obj/item/clothing/accessory/badge/holo
	badge["neck-corded holobadge"] = /obj/item/clothing/accessory/badge/holo/cord
	gear_tweaks += new/datum/gear_tweak/path(badge)

#undef ARMED_ROLES
#undef COMMAND_ROLES
