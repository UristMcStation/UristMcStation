// Suit slot
/datum/gear/suit/security_poncho
	allowed_roles = list(/datum/job/hos, /datum/job/officer)

/datum/gear/suit/medical_poncho
	allowed_roles = list(/datum/job/doctor,/datum/job/cmo)

/datum/gear/suit/engineering_poncho
	allowed_roles = list(/datum/job/chief_engineer, /datum/job/engineer)

/datum/gear/suit/science_poncho
	allowed_roles = list(/datum/job/scientist,/datum/job/seniorscientist)

/datum/gear/suit/cargo_poncho
	allowed_roles = list(/datum/job/qm,/datum/job/cargo_tech)

/datum/gear/suit/wintercoat/captain
	display_name = "winter coat, captain"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/captain
	allowed_roles = list(/datum/job/captain)

/datum/gear/suit/wintercoat/security
	display_name = "winter coat, security"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/security
	allowed_roles = list(/datum/job/officer, /datum/job/hos, /datum/job/warden, /datum/job/detective)

/datum/gear/suit/wintercoat/medical
	display_name = "winter coat, medical"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical
	allowed_roles = list(/datum/job/doctor,/datum/job/cmo,/datum/job/chemist,)

/datum/gear/suit/wintercoat/science
	display_name = "winter coat, science"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/science
	allowed_roles = list(/datum/job/rd,/datum/job/scientist, /datum/job/roboticist, /datum/job/seniorscientist)

/datum/gear/suit/wintercoat/engineering
	display_name = "winter coat, engineering"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering
	allowed_roles = list(/datum/job/chief_engineer, /datum/job/engineer)

/datum/gear/suit/wintercoat/atmos
	display_name = "winter coat, atmospherics"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos
	allowed_roles = list(/datum/job/chief_engineer, /datum/job/engineer)

/datum/gear/suit/wintercoat/hydro
	display_name = "winter coat, hydroponics"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/hydro

/datum/gear/suit/wintercoat/cargo
	display_name = "winter coat, cargo"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/cargo
	allowed_roles = list(/datum/job/qm,/datum/job/cargo_tech)

/datum/gear/suit/wintercoat/miner
	display_name = "winter coat, mining"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/miner
	allowed_roles = list(/datum/job/mining)

/*
 * Loadout definitions unique to NERVA
 */

/datum/gear/suit/cloak_security
	display_name = "cloak, security"
	path = /obj/item/clothing/suit/storage/hooded/seccloak
	allowed_roles = list(/datum/job/officer, /datum/job/hos, /datum/job/warden, /datum/job/detective)

/datum/gear/suit/meido_costume
	display_name = "meido costume"
	path = /obj/item/clothing/suit/urist/meido

/datum/gear/suit/meido_costume
	display_name = "meido costume"
	path = /obj/item/clothing/suit/urist/meido

/datum/gear/suit/psych_suit
	display_name = "psychologist's suit"
	path = /obj/item/clothing/under/rank/psychologist
	//allowed_roles = list(/datum/job/psychiatrist)

/datum/gear/suit/psych_tweed
	display_name = "tweed jacket"
	path = /obj/item/clothing/suit/psychologist
	//allowed_roles = list(/datum/job/psychiatrist)

/datum/gear/suit/terran_cloak
	display_name = "terran trader's cloak"
	path = /obj/item/clothing/suit/urist/terran/trader

/datum/gear/suit/trickster_coat
	display_name = "trickster's coat"
	path = /obj/item/clothing/suit/urist/trickster

/datum/gear/suit/CMO_labcoat_alt
	display_name = "fancy CMO labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/cmo/alt
	//allowed_roles = list(/datum/job/cmo)

/datum/gear/suit/robotist_labcoat
	display_name = "robotist's labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/robotics
	//allowed_roles = list(/datum/job/roboticist)

/datum/gear/suit/janitor_shirt
	display_name = "janitor's workshirt"
	path = /obj/item/clothing/suit/urist/janicoat
	//allowed_roles = list(/datum/job/janitor)

/datum/gear/suit/factory_apron
	display_name = "factory apron"
	path = /obj/item/clothing/suit/storage/urist/apron

/datum/gear/suit/welder_apron
	display_name = "welder's apron"
	path = /obj/item/clothing/suit/urist/welderapron

/datum/gear/suit/jester_suit
	display_name = "jester suit"
	path = /obj/item/clothing/suit/urist/jester
	//allowed_roles = list(/datum/job/clown, /datum/job/mime)
	
/datum/gear/suit/red_labcoat
	display_name = "informal red labcoat"
	path = /obj/item/clothing/suit/storage/labcoat/fluff/red

/datum/gear/suit/urist_leather_coats
	display_name = "leather jacket"
	path = /obj/item/clothing/suit/storage/urist/coat
	cost = 3
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/suit/urist_costume_suits
	display_name = "suit costume selection"
	path = /obj/item/clothing/suit/urist/historic
	cost = 1
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/suit/urist_overalls
	display_name = "overalls selection"
	path = /obj/item/clothing/suit/storage/urist/overalls
	cost = 1
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/suit/urist_coats
	display_name = "coat selection"
	path = /obj/item/clothing/suit/storage/toggle/urist/coat
	cost = 1
	flags = GEAR_HAS_TYPE_SELECTION

