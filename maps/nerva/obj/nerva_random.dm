// Nerva-related Random Obj/Turf/Mob Spawners - Seperated from Baystation to avoid merge issues later on.

/obj/random/vendor/urist
	name = "random urist vending machine"
	desc = "This is a randomly selected vending machine."
	icon = 'icons/obj/machines/vending.dmi'
	icon_state = "green-outline"

/obj/random/vendor/spawn_choices()
	return list(/obj/machinery/vending/weeb,
				/obj/machinery/vending/snix,
				/obj/machinery/vending/soda,
				/obj/machinery/vending/cigarette,
				/obj/machinery/vending/coffee,
				/obj/machinery/vending/whitedragon,
				/obj/machinery/vending/cola,
				/obj/machinery/vending/sol
				)
