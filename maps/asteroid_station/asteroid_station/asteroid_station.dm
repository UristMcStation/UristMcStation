/obj/random/mining_gear
	name = "Random Mining Gear"
	icon = 'icons/mecha/mecha_equipment.dmi'
	icon_state = "mining_drill"
	spawn_nothing_percentage = 10

obj/random/mining_gear/spawn_choices()
	return list(/obj/item/weapon/pickaxe/drill = 25,
				/obj/item/weapon/pickaxe/diamonddrill = 15,
				/obj/item/weapon/pickaxe/old = 35,
				/obj/item/device/flashlight/upgraded = 5,
				/obj/item/device/flashlight = 10)