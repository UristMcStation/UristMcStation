// Uniform slot
/datum/gear/uniform
	display_name = "blazer, blue"
	path = /obj/item/clothing/under/blazer
	slot = slot_w_uniform
	sort_category = "Uniforms and Casual Dress"

/datum/gear/uniform/roboticist_skirt
	display_name = "skirt, roboticist"
	path = /obj/item/clothing/under/rank/roboticist/skirt
	allowed_roles = list(/datum/job/roboticist)

/datum/gear/uniform/standard_scrubs
	display_name = "standard medical scrubs"
	path = /obj/item/clothing/under/rank/medical/scrubs/black
	allowed_roles = list(/datum/job/doctor,/datum/job/cmo,/datum/job/chemist)

/datum/gear/uniform/standard_scrubs/New()
	..()
	var/scrubcolor = list()
	scrubcolor["black scrubs"] = /obj/item/clothing/under/rank/medical/scrubs/black
	scrubcolor["blue scrubs"] = /obj/item/clothing/under/rank/medical/scrubs/blue
	scrubcolor["green scrubs"] = /obj/item/clothing/under/rank/medical/scrubs/green
	scrubcolor["heliodor scrubs"] = /obj/item/clothing/under/rank/medical/scrubs/heliodor
	scrubcolor["lilac scrubs"] = /obj/item/clothing/under/rank/medical/scrubs/lilac
	scrubcolor["navy blue scrubs"] = /obj/item/clothing/under/rank/medical/scrubs/navyblue
	scrubcolor["purple scrubs"] = /obj/item/clothing/under/rank/medical/scrubs/purple
	scrubcolor["teal scrubs"] = /obj/item/clothing/under/rank/medical/scrubs/teal
	gear_tweaks += new/datum/gear_tweak/path(scrubcolor)

/datum/gear/uniform/uniform_captain
	display_name = "uniform, captain's dress"
	path = /obj/item/clothing/under/dress/dress_cap
	allowed_roles = list(/datum/job/captain)

/datum/gear/uniform/corpsecsuit
	display_name = "uniform, corporate (Security)"
	path = /obj/item/clothing/under/rank/security/corp
	allowed_roles = list(/datum/job/officer,/datum/job/hos,/datum/job/warden)

/datum/gear/uniform/uniform_hop
	display_name = "uniform, HoP's dress"
	path = /obj/item/clothing/under/dress/dress_hop
	allowed_roles = list("Head of Personnel")

/datum/gear/uniform/uniform_hr
	display_name = "uniform, HR director (HoP)"
	path = /obj/item/clothing/under/dress/dress_hr
	allowed_roles = list("Head of Personnel")

/datum/gear/uniform/navysecsuit
	display_name = "uniform, navyblue (Security)"
	path = /obj/item/clothing/under/rank/security/navyblue
	allowed_roles = list(/datum/job/officer,/datum/job/hos,/datum/job/warden)

/datum/gear/uniform/pants
	display_name = "pants selection"
	path = /obj/item/clothing/under/formal_pants

/datum/gear/uniform/pants/New()
	..()
	var/list/pants = list()
	for(var/pant in subtypesof(/obj/item/clothing/under/pants/urist))
		var/obj/item/clothing/under/pants/urist/pant_type = pant
		pants[initial(pant_type.name)] = pant_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(pants))

/datum/gear/uniform/shorts
	display_name = "shorts selection"
	path = /obj/item/clothing/under/shorts/jeans

/datum/gear/uniform/shorts/New()
	..()
	var/list/shorts = list()
	for(var/short in typesof(/obj/item/clothing/under/shorts))
		var/obj/item/clothing/under/pants/short_type = short
		shorts[initial(short_type.name)] = short_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(shorts))

/datum/gear/uniform/tacticool
	display_name = "tacticool turtleneck"
	path = /obj/item/clothing/under/syndicate/tacticool

/datum/gear/uniform/turtleneck
	display_name = "sweater"
	path = /obj/item/clothing/under/rank/psych/turtleneck/sweater
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/corporate
	display_name = "corporate uniform selection"
	path = /obj/item/clothing/under/mbill

/datum/gear/uniform/corporate/New()
	..()
	var/corps = list()
	corps["major bill's shipping uniform"] = /obj/item/clothing/under/mbill
	corps["SAARE uniform"] = /obj/item/clothing/under/saare
	corps["aether atmospherics uniform"] = /obj/item/clothing/under/aether
	corps["hephaestus uniform"] = /obj/item/clothing/under/hephaestus
	corps["PCRC uniform"] = /obj/item/clothing/under/pcrc
	corps["ward-takahashi uniform"] = /obj/item/clothing/under/wardt
	corps["grayson uniform"] = /obj/item/clothing/under/grayson
	corps["focal point uniform"] = /obj/item/clothing/under/focal
	gear_tweaks += new/datum/gear_tweak/path(corps)
