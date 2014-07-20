//
//File created by TGameCo
//

/obj/item/weapon/storage/belt/robotics
	name = "Robotics Toolbelt"
	desc = "A toolbelt that has roboticist markings on it."
	icon = 'icons/urist/items/clothes/belt.dmi'
	icon_override = 'icons/uristmob/belt_mirror.dmi'
	icon_state = "beltRobo"
	can_hold = list(
 	"/obj/item/weapon/crowbar",
 	"/obj/item/weapon/screwdriver",
 	"/obj/item/weapon/weldingtool",
 	"/obj/item/weapon/wirecutters",
 	"/obj/item/weapon/wrench",
 	"/obj/item/device/multitool",
 	"/obj/item/device/flashlight",
 	"/obj/item/weapon/cable_coil",
 	"/obj/item/device/analyzer",
 	"/obj/item/device/mmi")

 /obj/item/weapon/storage/belt/robotics/full/New()
 	..()
 	new /obj/item/weapon/screwdriver(src)
 	new /obj/item/weapon/wrench(src)
 	new /obj/item/weapon/weldingtool(src)
 	new /obj/item/weapon/crowbar(src)
 	new /obj/item/weapon/wirecutters(src)
 	new /obj/item/weapon/cable_coil(src, 30, pick("red", "yellow", "orange"))