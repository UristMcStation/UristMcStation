// Uniform slot
/datum/gear/uniform/roboticist_skirt
	allowed_roles = TECHNICAL_ROLES

/datum/gear/uniform/scrubs
	allowed_roles = MEDICAL_ROLES

/datum/gear/uniform/uniform_captain
	display_name = "uniform, captain's dress"
	path = /obj/item/clothing/under/dress/dress_cap
	allowed_roles = list(/datum/job/captain)

/datum/gear/uniform/corpsecsuit
	display_name = "uniform, corporate (Security)"
	path = /obj/item/clothing/under/rank/security/corp
	allowed_roles = SECURITY_ROLES

/datum/gear/uniform/uniform_hop
	display_name = "uniform, HoP's dress"
	path = /obj/item/clothing/under/dress/dress_hop
	allowed_roles = list(/datum/job/hop)

/datum/gear/uniform/navysecsuit
	display_name = "uniform, navyblue (Security)"
	path = /obj/item/clothing/under/rank/security/navyblue
	allowed_roles = SECURITY_ROLES

/datum/gear/uniform/pants
	display_name = "pants selection"
	path = /obj/item/clothing/under/pants

/datum/gear/uniform/pants/New()
	..()
	var/list/pants = list()
	for(var/pant in subtypesof(/obj/item/clothing/under/pants/urist))
		var/obj/item/clothing/under/pants/urist/pant_type = pant
		pants[initial(pant_type.name)] = pant_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(pants))

/*
 * Loadout definitions unique to NERVA
 */

/datum/gear/uniform/nervasecfield
	display_name = "uniform, field (Security)"
	path = /obj/item/clothing/under/urist/nerva/secfield
	allowed_roles = SECURITY_ROLES
