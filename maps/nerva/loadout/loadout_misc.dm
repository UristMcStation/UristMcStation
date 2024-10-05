// Misc Items:

datum/gear/cigpack
	display_name = "cigarette pack selection"
	path = /obj/item/storage/fancy/smokable
	cost = 1

/datum/gear/cigpack/New()
	..()
	var/cig = list()
	cig += /obj/item/storage/fancy/smokable/transstellar
	cig += /obj/item/storage/fancy/smokable/dromedaryco
	cig += /obj/item/storage/fancy/smokable/dromedaryco
	cig += /obj/item/storage/fancy/smokable/luckystars
	cig += /obj/item/storage/fancy/smokable/jerichos
	cig += /obj/item/storage/fancy/smokable/menthols
	cig += /obj/item/storage/fancy/smokable/carcinomas
	cig += /obj/item/storage/fancy/smokable/professionals
	cig += /obj/item/storage/fancy/smokable/trident
	cig += /obj/item/storage/fancy/smokable/trident_fruit
	cig += /obj/item/storage/fancy/smokable/trident_mint
	cig += /obj/item/storage/fancy/smokable/urist/uplift
	cig += /obj/item/storage/fancy/smokable/urist/devil
	cig += /obj/item/storage/fancy/smokable/urist/carp
	cig += /obj/item/storage/fancy/smokable/urist/midori
	cig += /obj/item/storage/fancy/smokable/urist/shadyjim
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(cig)

/datum/gear/rolledcig
	display_name = "rolled cigarette selection"
	path = /obj/item/clothing/mask/smokable/cigarette/rolled
	cost = 1

/datum/gear/rolledcig/New()
	..()
	var/rolled = list()
	rolled += /obj/item/clothing/mask/smokable/cigarette/rolled/tobacco
	rolled += /obj/item/clothing/mask/smokable/cigarette/rolled/psilocybin
	rolled += /obj/item/clothing/mask/smokable/cigarette/rolled/hextro
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(rolled)

/datum/gear/tobacco
	display_name = "rolling tobacco selection"
	path = /obj/item/storage/chewables/rollable
	path = 1

/datum/gear/tobacco/New()
	..()
	var/tobacco = list()
	tobacco += /obj/item/storage/chewables/rollable/bad
	tobacco += /obj/item/storage/chewables/rollable/generic
	tobacco += /obj/item/storage/chewables/rollable/fine
	tobacco += /obj/item/storage/chewables/rollable/rollingkit
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(tobacco)

/datum/gear/chewing
	display_name = "chewing tobacco selection"
	path = /obj/item/storage/chewables/tobacco
	cost = 1

/datum/gear/chewing/New()
	..()
	var/chewing = list()
	chewing += /obj/item/storage/chewables/tobacco
	chewing += /obj/item/storage/chewables/tobacco2
	chewing += /obj/item/storage/chewables/tobacco3
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(chewing)

datum/gear/rollingpaper
	display_name = "rolling paper selection"
	path = /obj/item/paper/cig
	cost = 1

/datum/gear/rollingpaper/New()
	..()
	var/rollingpaper = list()
	rollingpaper += /obj/item/paper/cig
	rollingpaper += /obj/item/paper/cig/fancy
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(rollingpaper)

datum/gear/misc/rollingfilter
	display_name = "cigarette filters"
	path = /obj/item/paper/cig/filter
	cost = 1
