// Eyes
/datum/gear/eyes/security
	allowed_roles = list(/datum/job/officer,/datum/job/hos,/datum/job/warden)

/datum/gear/eyes/medical
	allowed_roles = list(/datum/job/doctor,/datum/job/cmo,/datum/job/chemist)

/datum/gear/eyes/meson
	allowed_roles = list(/datum/job/chief_engineer, /datum/job/engineer, /datum/job/mining, /datum/job/scientist, /datum/job/rd, /datum/job/seniorscientist)

/datum/gear/eyes/aviators
	display_name = "sunglasses, aviators"
	path = /obj/item/clothing/glasses/sunglasses/aviators
	cost = 3