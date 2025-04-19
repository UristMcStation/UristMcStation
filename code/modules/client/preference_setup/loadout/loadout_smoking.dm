/datum/gear/smokingpipe
	display_name = "pipe, smoking"
	path = /obj/item/clothing/mask/smokable/pipe

/datum/gear/cornpipe
	display_name = "pipe, corn"
	path = /obj/item/clothing/mask/smokable/pipe/cobpipe

/datum/gear/matchbook
	display_name = "matchbook"
	path = /obj/item/storage/fancy/matches/matchbox

/datum/gear/zippo
	display_name = "plain zippo"
	path = /obj/item/flame/lighter/zippo

/datum/gear/zippo/vanity
	display_name = "fancy zippo"
	path = /obj/item/flame/lighter/zippo/vanity

/datum/gear/zippo/vanity/New()
	..()
	var/list/zippos = list()
	for(var/zippo in typesof(/obj/item/flame/lighter/zippo/vanity))
		var/obj/item/flame/lighter/zippo/vanity/zippo_type = zippo
		zippos[initial(zippo_type.name)] = zippo_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(zippos))

/datum/gear/ashtray
	display_name = "ashtray, plastic"
	path = /obj/item/material/ashtray/plastic

/datum/gear/cigars
	display_name = "fancy cigar case"
	path = /obj/item/storage/fancy/smokable/cigar
	cost = 2

/datum/gear/ecigs
	display_name = "electronic cigarette, deluxe version"
	path = /obj/item/clothing/mask/smokable/ecig/deluxe
