// Eyes
/datum/gear/eyes
	display_name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	slot = slot_glasses
	sort_category = "Glasses and Eyewear"

/datum/gear/eyes/glasses
	display_name = "glasses"
	path = /obj/item/clothing/glasses

/datum/gear/eyes/glasses/New()
	..()
	var/glasses = list()
	glasses["prescription glasses"] = /obj/item/clothing/glasses/regular
	glasses["green glasses"] = /obj/item/clothing/glasses/gglasses
	glasses["hipster glasses"] = /obj/item/clothing/glasses/regular/hipster
	glasses["monocle"] = /obj/item/clothing/glasses/monocle
	glasses["scanning goggles"] = /obj/item/clothing/glasses/regular/scanners
	gear_tweaks += new/datum/gear_tweak/path(glasses)

/datum/gear/eyes/sciencegoggles
	display_name = "Science Goggles"
	path = /obj/item/clothing/glasses/science

/datum/gear/eyes/security
	display_name = "Security HUD"
	path = /obj/item/clothing/glasses/hud/security
	allowed_roles = list(/datum/job/officer,/datum/job/hos,/datum/job/warden)

/datum/gear/eyes/security/prescription
	display_name = "Security HUD, prescription"
	path = /obj/item/clothing/glasses/hud/security/prescription
	allowed_roles = list(/datum/job/officer,/datum/job/hos,/datum/job/warden)

/datum/gear/eyes/secaviators
	display_name = "Security HUD Aviators"
	path = /obj/item/clothing/glasses/sunglasses/sechud/toggle
	allowed_roles = list(/datum/job/officer,/datum/job/hos,/datum/job/warden)

/datum/gear/eyes/medical
	display_name = "Medical HUD"
	path = /obj/item/clothing/glasses/hud/health
	allowed_roles = list(/datum/job/doctor,/datum/job/cmo,/datum/job/chemist)

/datum/gear/eyes/medical/prescription
	display_name = "Medical HUD, prescription"
	path = /obj/item/clothing/glasses/hud/health/prescription
	allowed_roles = list(/datum/job/doctor,/datum/job/cmo,/datum/job/chemist)
