
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

/datum/gear/survivalkit
	display_name = "survival kit"
	path = /obj/item/storage/box/survivalkit
	allowed_roles = SUPPLY_ROLES

/datum/gear/storage/pouches
	allowed_roles = null
	cost = 3

/datum/gear/accessory/badge
	display_name = "badge selection"
	path = /obj/item/clothing/accessory/badge
	allowed_roles = SECURITY_ROLES

/datum/gear/accessory/badge/New()
	..()
	var/badge = list()
	badge["badge"] = /obj/item/clothing/accessory/badge
	badge["holobadge"] = /obj/item/clothing/accessory/badge/holo
	badge["neck-corded holobadge"] = /obj/item/clothing/accessory/badge/holo/cord
	gear_tweaks += new/datum/gear_tweak/path(badge)

/datum/gear/accessory/armband_security
	allowed_roles = SECURITY_ROLES

/datum/gear/accessory/armband_cargo
	allowed_roles = SUPPLY_ROLES

/datum/gear/accessory/armband_medical
	allowed_roles = MEDICAL_ROLES

/datum/gear/accessory/armband_emt
	display_name = "EMT armband"
	path = /obj/item/clothing/accessory/armband/medgreen
	allowed_roles = list(
		/datum/job/doctor
	)
	flags = GEAR_HAS_NO_CUSTOMIZATION


/datum/gear/accessory/armband_engineering
	allowed_roles = ENGINEERING_ROLES
