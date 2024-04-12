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
	
/datum/gear/uniform/informalsec_uniform
	display_name = "informal security uniorm"
	path = /obj/item/clothing/under/fluff/lilith_vinous_1
	allowed_roles = SECURITY_ROLES	

/datum/gear/uniform/terran_uniform
	display_name = "terran trader uniform"
	path = /obj/item/clothing/under/urist/terran/trader

/datum/gear/uniform/green_rd_suit
	display_name = "green RD outfit"
	path = /obj/item/clothing/under/urist/rank/rdgreen
	//allowed_roles = list(/datum/job/seniorscientist)

/datum/gear/uniform/trickster_suit
	display_name = "trickster suit"
	path = /obj/item/clothing/under/urist/trickster

/datum/gear/uniform/jester_outfit
	display_name = "jester outfit"
	path = /obj/item/clothing/under/urist/jester
	//allowed_roles = list(/datum/job/clown, /datum/job/mime)
	
/datum/gear/uniform/affairs_dress
	display_name = "internal affairs dress"
	path = /obj/item/clothing/under/urist/rank/iaadress
	
/datum/gear/uniform/bartender_classy
	display_name = "classy bartender uniform"
	path = /obj/item/clothing/under/rank/bartender/fluff/classy
	//allowed_roles = list(/datum/job/chef)
	
/datum/gear/uniform/nanotrasen_intel_jumpsuit
	display_name = "nanotrasen intel jumpsuit"
	path = /obj/item/clothing/under/fluff/jane_sidsuit
	
/datum/gear/uniform/medical_shortsuit
	display_name = "short sleeve medical jumpsuit"
	path = /obj/item/clothing/under/rank/medical/fluff/short
	allowed_roles = MEDICAL_ROLES
	
/datum/gear/uniform/history_uniforms
	display_name = "historical reenactor clothes"
	path = /obj/item/clothing/under/urist/historic
	cost = 2
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/nanotransen_outfits
	display_name = "nanotrasen outfits"
	path = /obj/item/clothing/under/urist/nanotrasen
	cost = 1
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/urist_dresses
	display_name = "dress selection"
	path = /obj/item/clothing/under/urist/dress
	cost = 1
	flags = GEAR_HAS_TYPE_SELECTION


