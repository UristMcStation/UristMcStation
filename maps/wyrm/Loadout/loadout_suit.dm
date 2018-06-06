// Suit slot
/datum/gear/suit
	display_name = "apron, blue"
	path = /obj/item/clothing/suit/apron
	slot = slot_wear_suit
	sort_category = "Suits and Overwear"
	cost = 2

/datum/gear/suit/blue_labcoat
	display_name = "blue-edged labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/blue

/datum/gear/suit/overalls
	display_name = "overalls"
	path = /obj/item/clothing/suit/apron/overalls
	cost = 1

/datum/gear/suit/roles/poncho/security
	allowed_roles = list(/datum/job/officer, /datum/job/hos)

/datum/gear/suit/roles/poncho/medical
	allowed_roles = list(/datum/job/doctor)

/datum/gear/suit/roles/poncho/engineering
	allowed_roles = list(/datum/job/engineer, /datum/job/chief_engineer)

/datum/gear/suit/roles/poncho/science
	allowed_roles = list(/datum/job/scientist, /datum/job/rd)

/datum/gear/suit/roles/poncho/cargo
	allowed_roles = list(/datum/job/cargo_tech, /datum/job/qm)

/datum/gear/suit/roles/surgical_apron
	display_name = "surgical apron"
	path = /obj/item/clothing/suit/surgicalapron
	allowed_roles = list(/datum/job/doctor)

/datum/gear/suit/unathi_robe
	display_name = "roughspun robe"
	path = /obj/item/clothing/suit/unathi/robe
	cost = 1

/datum/gear/suit/wintercoat/captain
	display_name = "winter coat, captain"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/captain
	allowed_roles = list(/datum/job/captain)

/datum/gear/suit/wintercoat/security
	allowed_roles = list(/datum/job/officer, /datum/job/hos)

/datum/gear/suit/wintercoat/medical
	display_name = "winter coat, medical"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical
	allowed_roles = list(/datum/job/doctor)

/datum/gear/suit/wintercoat/science
	display_name = "winter coat, science"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/science
	allowed_roles = list(/datum/job/scientist, /datum/job/rd)

/datum/gear/suit/wintercoat/engineering
	display_name = "winter coat, engineering"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering
	allowed_roles = list(/datum/job/engineer, /datum/job/chief_engineer)

/datum/gear/suit/wintercoat/atmos
	display_name = "winter coat, atmospherics"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos
	allowed_roles = list(/datum/job/engineer, /datum/job/chief_engineer)

/datum/gear/suit/wintercoat/hydro
	display_name = "winter coat, hydroponics"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/hydro

/datum/gear/suit/wintercoat/cargo
	display_name = "winter coat, cargo"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/cargo
	allowed_roles = list(/datum/job/cargo_tech, /datum/job/qm)

/datum/gear/suit/wintercoat/miner
	display_name = "winter coat, mining"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/miner
	allowed_roles = list(/datum/job/cargo_tech, /datum/job/qm)

/datum/gear/suit/labcorp
	display_name = "corporate labcoat selection"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/corp/wardt

/datum/gear/suit/labcorp/New()
	..()
	var/list/labcoats = list()
	for(var/lab in subtypesof(/obj/item/clothing/suit/storage/toggle/labcoat/corp))
		var/obj/item/clothing/suit/storage/toggle/labcoat/corp/lab_type = lab
		labcoats[initial(lab_type.name)] = lab_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(labcoats))

/datum/gear/suit/trenchcoat
	display_name = "trenchcoat selection"
	path = /obj/item/clothing/suit/storage/det_trench
	cost = 3

/datum/gear/suit/trenchcoat/New()
	..()
	var/trenchcoats = list()
	trenchcoats["trenchcoat, brown"] = /obj/item/clothing/suit/storage/det_trench
	trenchcoats["trenchcoat, grey"] = /obj/item/clothing/suit/storage/det_trench/grey
	trenchcoats["coat, duster"] = /obj/item/clothing/suit/leathercoat
	gear_tweaks += new/datum/gear_tweak/path(trenchcoats)