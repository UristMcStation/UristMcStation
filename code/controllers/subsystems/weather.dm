SUBSYSTEM_DEF(weather)
	name =       "Weather"
	wait =       15 SECONDS
	init_order = SS_INIT_WEATHER
	priority =   SS_PRIORITY_WEATHER
	flags =      SS_BACKGROUND

	var/list/weather_systems = list()
	var/list/weather_by_z    = list()
	var/list/processing_systems

/datum/controller/subsystem/weather/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..("all systems: [length(weather_systems)], processing systems: [length(processing_systems)]")

/datum/controller/subsystem/weather/Initialize(start_timeofday)
	. = ..()
	for(var/obj/abstract/weather_system/weather as anything in weather_systems)
		weather.init_weather()

/datum/controller/subsystem/weather/fire(resumed)

	if(!resumed)
		processing_systems = weather_systems.Copy()

	var/obj/abstract/weather_system/weather
	while(length(processing_systems))
		weather = processing_systems[length(processing_systems)]
		LIST_DEC(processing_systems)
		weather.tick()
		if(MC_TICK_CHECK)
			return

///Sets a weather state to use for a given z level/z level stack. topmost_level may be a level_id or a level_data instance.
/datum/controller/subsystem/weather/proc/setup_weather_system(topmost_level, singleton/state/weather/initial_state, list/banned_states)

	//First check and clear any existing weather system on the level
	var/obj/abstract/weather_system/WS = LAZYACCESS(weather_by_z, topmost_level)
	if(WS)
		unregister_weather_system(WS)
		qdel(WS)
	//Create the new weather system and let it register itself
	new /obj/abstract/weather_system(locate(1, 1, topmost_level), topmost_level, initial_state, banned_states)

///Registers a given weather system obj for getting updates by SSweather.
/datum/controller/subsystem/weather/proc/register_weather_system(obj/abstract/weather_system/WS)
	if(LAZYACCESS(weather_by_z, WS.z))
		CRASH("Trying to register another weather system on the same z-level([WS.z]) as an existing one!")
	weather_systems |= WS

	//Mark all affected z-levels
	var/list/affected = GetConnectedZlevels(WS.z)
	for(var/Z in affected)
		if(LAZYACCESS(weather_by_z, Z))
			CRASH("Trying to register another weather system on the same z-level([Z]) as an existing one!")
		weather_by_z[Z] = WS

///Remove a weather systeam from the processing lists.
/datum/controller/subsystem/weather/proc/unregister_weather_system(obj/abstract/weather_system/WS)
	//Clear any and all references to our weather object
	for(var/Z = 1 to length(weather_by_z))
		if(weather_by_z[Z] == WS)
			weather_by_z[Z] = null
	weather_systems -= WS
