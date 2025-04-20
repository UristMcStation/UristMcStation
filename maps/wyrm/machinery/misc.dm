/obj/machinery/ntnet_relay/wall_mounted
	icon = 'maps/wyrm/icons/wall_router.dmi'
	icon_state = "wall_router"
	density = FALSE

/obj/machinery/ntnet_relay/on_update_icon()
	if(operable())
		icon_state = "wall_router"
	else
		icon_state = "wall_router_off"

/obj/machinery/fabricator/filled/Initialize()
	. = ..()
	for(var/mat in base_storage_capacity)
		stored_material[mat] = base_storage_capacity[mat]
