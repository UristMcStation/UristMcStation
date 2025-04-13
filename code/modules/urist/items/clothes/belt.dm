//
//File created by TGameCo
//

/obj/item/storage/belt/robotics
	name = "Robotics Toolbelt"
	desc = "A toolbelt that has roboticist markings on it."
	icon = 'icons/urist/items/clothes/belt.dmi'
	icon_override = 'icons/uristmob/belt_mirror.dmi'
	icon_state = "beltRobo"
	storage_slots = 7
	contents_allowed = list(
 	/obj/item/crowbar,
 	/obj/item/screwdriver,
 	/obj/item/weldingtool,
 	/obj/item/wirecutters,
 	/obj/item/wrench,
 	/obj/item/device/multitool,
 	/obj/item/device/flashlight,
 	/obj/item/stack/cable_coil,
 	/obj/item/device/scanner/gas,
 	/obj/item/device/mmi,
	/obj/item/device/integrated_electronics,
	/obj/item/clothing/gloves,
	/obj/item/hand_labeler,
	/obj/item/taperoll
 	)

/obj/item/storage/belt/robotics/full/New()
	..()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/wirecutters(src)
	new /obj/item/stack/cable_coil(src, 30, pick("red", "yellow", "orange"))

/obj/item/storage/belt/vanity
	icon = 'icons/urist/items/clothes/belt.dmi'
	icon_override = 'icons/uristmob/belt_mirror.dmi'
	storage_slots = 1
	contents_allowed = list(
		/obj/item/modular_computer/pda
		)

/obj/item/storage/belt/vanity/leather
	name = "leather belt"
	desc = "A belt made out of the finest space cow hide!"
	icon_state = "leatherbelt"
	item_state = "leatherbelt"

/obj/item/storage/belt/vanity/cowboy
	name = "cowboy belt"
	desc = "Just like in the Wild West!"
	icon_state = "cowboybelt"
	item_state = "cowboybelt"

/obj/item/storage/belt/vanity/black
	name = "black belt"
	desc = "A simple black belt."
	icon_state = "blackbelt"
	item_state = "blackbelt"

/obj/item/storage/belt/vanity/red
	name = "red belt"
	desc = "A simple red belt."
	icon_state = "redbelt"
	item_state = "redbelt"

/obj/item/storage/belt/vanity/green
	name = "green belt"
	desc = "A simple green belt."
	icon_state = "greenbelt"
	item_state = "greenbelt"

/obj/item/storage/belt/vanity/purple
	name = "purple belt"
	desc = "A simple purple belt."
	icon_state = "purplebelt"
	item_state = "purplebelt"

/obj/item/storage/belt/vanity/blue
	name = "blue belt"
	desc = "A simple blue belt."
	icon_state = "bluebelt"
	item_state = "bluebelt"

/obj/item/storage/belt/vanity/orange
	name = "orange belt"
	desc = "A simple orange belt."
	icon_state = "orangebelt"
	item_state = "orangebelt"

//use this from now on

/obj/item/storage/belt/urist
	icon = 'icons/urist/items/clothes/belt.dmi'
	icon_override = 'icons/uristmob/belt_mirror.dmi'

//military belt

/obj/item/storage/belt/urist/military
	name = "military belt"
	desc = "A syndicate belt designed to be used by boarding parties. Its style is modeled after the hardsuits they wear."
	icon_state = "militarybelt"
	item_state = "military"

/obj/item/storage/belt/urist/military/scom
	w_class = 4
	storage_slots = 7
	max_w_class = 3
	max_storage_space = 24
	contents_allowed = list(
		/obj/item
		)
