/datum/gear/head
	display_name = "natural philosopher's wig"
	path = /obj/item/clothing/head/philosopher_wig
	slot = slot_head
	sort_category = "Hats and Headwear"

/datum/gear/head/beret/bsec
	display_name = "beret, navy (officer)"
	path = /obj/item/clothing/head/beret/sec/navy/officer
	allowed_roles = SECURITY_ROLES

/datum/gear/head/beret/bsec_warden
	display_name = "beret, navy (warden)"
	path = /obj/item/clothing/head/beret/sec/navy/warden
	allowed_roles = list(/datum/job/hos,/datum/job/warden)

/datum/gear/head/beret/bsec_hos
	display_name = "beret, navy (hos)"
	path = /obj/item/clothing/head/beret/sec/navy/hos
	allowed_roles = list(/datum/job/hos)

/datum/gear/head/beret/eng
	display_name = "beret, engineering"
	path = /obj/item/clothing/head/beret/engineering
	allowed_roles = ENGINEERING_ROLES

/datum/gear/head/beret/purp
	display_name = "beret, purple"
	path = /obj/item/clothing/head/beret/purple

/datum/gear/head/beret/sec
	display_name = "beret, red (security)"
	path = /obj/item/clothing/head/beret/sec
	allowed_roles = SECURITY_ROLES

/datum/gear/head/seccap
	display_name = "cap, security"
	path = /obj/item/clothing/head/soft/sec
	allowed_roles = SECURITY_ROLES

/datum/gear/head/seccap/corp
	display_name = "cap, corporate security"
	path = /obj/item/clothing/head/soft/sec/corp
	allowed_roles = SECURITY_ROLES

/datum/gear/head/welding
	allowed_roles = TECHNICAL_ROLES
	
/*
 * Loadout definitions unique to NERVA
 */
 
/datum/gear/head/terrain_hat
	display_name = "terran confederacy hat"
	path = /obj/item/clothing/head/urist/terran/trader
	
/datum/gear/head/formal_cmo
	display_name = "formal CMO cap"
	path = /obj/item/clothing/head/urist/altcmo
	allowed_roles = MEDICAL_ROLES

/datum/gear/head/motor_helmet
	display_name = "motorcycle helmet"
	path = /obj/item/clothing/head/urist/motorhelm
	cost = 3
	
/datum/gear/head/janitor_hat
	display_name = "grubby hat"
	path = /obj/item/clothing/head/urist/janihat
	//allowed_roles = list(/datum/job/janitor)
	
/datum/gear/head/cowboy
	display_name = "cowboy hat"
	path = /obj/item/clothing/head/urist/cowboy
	
/datum/gear/head/cowboy/brown
	display_name = "brown cowboy hat"
	path = /obj/item/clothing/head/urist/cowboy2
	
/datum/gear/head/cowboy/brown
	display_name = "grey cape, colourable"
	path = /obj/item/clothing/head/urist/historic/light/cape
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/fedora
	display_name = "fedora"
	path = /obj/item/clothing/head/urist/fedora
	
/datum/gear/head/boater_hat
	display_name = "boater's hat"
	path = /obj/item/clothing/head/urist/boaterhat
	
/datum/gear/head/trickster_hat
	display_name = "trickster's hat"
	path = /obj/item/clothing/head/urist/trickster
	cost = 2

	
	
	
