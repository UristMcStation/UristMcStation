#define ARMED_ROLES list(/datum/job/captain, /datum/job/hop, /datum/job/officer, /datum/job/warden, /datum/job/hos, /datum/job/detective, /datum/job/blueshield)

/datum/gear/accessory/armband
	display_name = "armband selection"
	path = /obj/item/clothing/accessory/armband

/datum/gear/accessory/armband/New()
	..()
	var/armbands = list()
	armbands["red armband"] = /obj/item/clothing/accessory/armband
	armbands["science armband"] = /obj/item/clothing/accessory/armband/science
	armbands["corporate armband"] = /obj/item/clothing/accessory/armband/whitered
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

#undef ARMED_ROLES
