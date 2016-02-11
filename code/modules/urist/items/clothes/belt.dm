//
//File created by TGameCo
//

/obj/item/weapon/storage/belt/robotics
	name = "Robotics Toolbelt"
	desc = "A toolbelt that has roboticist markings on it."
	icon = 'icons/urist/items/clothes/belt.dmi'
	icon_override = 'icons/uristmob/belt_mirror.dmi'
	icon_state = "beltRobo"
	storage_slots = 7
	can_hold = list(
 	/obj/item/weapon/crowbar,
 	/obj/item/weapon/screwdriver,
 	/obj/item/weapon/weldingtool,
 	/obj/item/weapon/wirecutters,
 	/obj/item/weapon/wrench,
 	/obj/item/device/multitool,
 	/obj/item/device/flashlight,
 	/obj/item/stack/cable_coil,
 	/obj/item/device/analyzer,
 	/obj/item/device/mmi
 	)

 /obj/item/weapon/storage/belt/robotics/full/New()
 	..()
 	new /obj/item/weapon/screwdriver(src)
 	new /obj/item/weapon/wrench(src)
 	new /obj/item/weapon/weldingtool(src)
 	new /obj/item/weapon/crowbar(src)
 	new /obj/item/weapon/wirecutters(src)
 	new /obj/item/stack/cable_coil(src, 30, pick("red", "yellow", "orange"))

/obj/item/weapon/storage/belt/vanity
	icon = 'icons/urist/items/clothes/belt.dmi'
	icon_override = 'icons/uristmob/belt_mirror.dmi'
	storage_slots = 1
	can_hold = list(
		/obj/item/device/pda
		)

/obj/item/weapon/storage/belt/vanity/leather
	name = "leather belt"
	desc = "A belt made out of the finest space cow hide!"
	icon_state = "leatherbelt"
	item_state = "leatherbelt"

/obj/item/weapon/storage/belt/vanity/cowboy
	name = "cowboy belt"
	desc = "Just like in the Wild West!"
	icon_state = "cowboybelt"
	item_state = "cowboybelt"

/obj/item/weapon/storage/belt/vanity/black
	name = "black belt"
	desc = "A simple black belt."
	icon_state = "blackbelt"
	item_state = "blackbelt"

/obj/item/weapon/storage/belt/vanity/red
	name = "red belt"
	desc = "A simple red belt."
	icon_state = "redbelt"
	item_state = "redbelt"

/obj/item/weapon/storage/belt/vanity/green
	name = "green belt"
	desc = "A simple green belt."
	icon_state = "greenbelt"
	item_state = "greenbelt"

/obj/item/weapon/storage/belt/vanity/purple
	name = "purple belt"
	desc = "A simple purple belt."
	icon_state = "purplebelt"
	item_state = "purplebelt"

/obj/item/weapon/storage/belt/vanity/blue
	name = "blue belt"
	desc = "A simple blue belt."
	icon_state = "bluebelt"
	item_state = "bluebelt"

/obj/item/weapon/storage/belt/vanity/orange
	name = "orange belt"
	desc = "A simple orange belt."
	icon_state = "orangebelt"
	item_state = "orangebelt"

//use this from now on

/obj/item/weapon/storage/belt/urist
	icon = 'icons/urist/items/clothes/belt.dmi'
	icon_override = 'icons/uristmob/belt_mirror.dmi'

//bandoliers

/obj/item/weapon/storage/belt/urist/bandolier
	name = "bandolier"
	desc = "A bandolier for holding shotgun ammunition."
	icon_state = "bandolier"
	item_state = "bandolier"
	storage_slots = 6
	can_hold = list(
			/obj/item/ammo_casing/shotgun
			)

//military belt

/obj/item/weapon/storage/belt/urist/military
	name = "military belt"
	desc = "A syndicate belt designed to be used by boarding parties. Its style is modeled after the hardsuits they wear."
	icon_state = "militarybelt"
	item_state = "military"

/obj/item/weapon/storage/belt/urist/military/scom
	w_class = 4
	storage_slots = 7
	max_w_class = 3
	max_storage_space = 24
	can_hold = list(
		/obj/item
		)
