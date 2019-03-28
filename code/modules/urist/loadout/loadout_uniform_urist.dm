/datum/gear/uniform/uristdress
	display_name = "fancy dress selection"
	path = /obj/item/clothing/under/urist/dress

/datum/gear/uniform/uristdress/New()
	..()
	var/udresses = list()
	udresses += /obj/item/clothing/under/urist/dress/pinksun
	udresses += /obj/item/clothing/under/urist/dress/whitesun
	udresses += /obj/item/clothing/under/urist/dress/bowsun
	udresses += /obj/item/clothing/under/urist/dress/bluesun
	udresses += /obj/item/clothing/under/urist/dress/shortpink
	udresses += /obj/item/clothing/under/urist/dress/twopiece
	udresses += /obj/item/clothing/under/urist/dress/gothic
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(udresses)