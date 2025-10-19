/obj/machinery/rotating_alarm/start_on/capaneus
	alarm_light_color = COLOR_RED_LIGHT
	sound_file = 'packs/event_legion_capaneus/sounds/alarm_loop.ogg'


/obj/machinery/rotating_alarm/start_on/capaneus/Destroy()
	QDEL_NULL(sound_loop)
	. = ..()
