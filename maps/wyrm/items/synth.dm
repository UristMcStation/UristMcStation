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