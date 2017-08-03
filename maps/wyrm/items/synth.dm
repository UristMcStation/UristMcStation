/obj/item/clothing/suit/storage/toggle/labcoat/synth
	name = "\improper Mysterious Coat"
	desc = "It's a long labcoat with a number of inlays."
	icon = 'maps/wyrm/icons/synth.dmi'
	item_icons = URIST_ALL_ONMOBS
	icon_state = "synthcoat"

/obj/item/clothing/suit/armor/synth
	name = "makeshift iron body armor"
	desc = "Some iron plates have been welded together to form some basic protection."
	icon = 'maps/wyrm/icons/synth.dmi'
	item_icons = URIST_ALL_ONMOBS
	icon_state = "syntharmor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 35, bullet = 35, laser = 25, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/synth/sl
	desc = "Some armor with a complicated circuit board and receiver on its back."
	icon_state = "syntharmorsl"

/obj/item/clothing/suit/storage/toggle/labcoat/corp
	icon = 'maps/wyrm/icons/corporate.dmi'
	item_icons = URIST_ALL_ONMOBS

/obj/item/clothing/suit/storage/toggle/labcoat/corp/wardt
	name = "\improper Ward-Takahashi labcoat"
	desc = "A labcoat decorated with the logo of Ward-Takahashi GMB."
	icon_state = "wardt_lab"
	icon_open = "wardt_lab"
	icon_closed = "wardt_lab_closed"

/obj/item/clothing/under/rank/medical/veymed
	name = "\improper Vey-Med scrubs"
	icon = 'maps/wyrm/icons/corporate.dmi'
	item_icons = URIST_ALL_ONMOBS
	icon_state = "veymed_scrubs"
	worn_state = "veymed_scrubs"

/obj/item/clothing/suit/storage/toggle/labcoat/corp/veymed
	name = "\improper Vey-Med labcoat"
	icon_state = "veymed_lab"
	icon_open = "veymed_lab"
	icon_closed = "veymed_lab_closed"
