/obj/machinery/floor_light/developer // Developer/Example Map Usage.
	name = "enhanced floor light"
	icon = 'icons/obj/machines/floor_light.dmi'
	icon_state = "base"
	desc = "A backlit floor panel with an enhanced lighting panel, for when you REALLY want to see things."
	layer = ABOVE_TILE_LAYER
	anchored = FALSE
	use_power = POWER_USE_OFF
	idle_power_usage = 0
	active_power_usage = 0
	power_channel = LIGHT
	health_max = 5
	damage_hitsound = 'sound/effects/Glasshit.ogg'
	default_light_power = 1
	default_light_range = 20
	default_light_colour = "#ffffff"

/obj/machinery/floor_light/developer/mapped_off
	anchored = TRUE
	use_power = POWER_USE_OFF

/obj/machinery/floor_light/developer/mapped_on
	anchored = TRUE
	use_power = POWER_USE_ACTIVE
