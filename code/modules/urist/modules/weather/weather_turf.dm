/* let's try to do this shit by turf then... */

/turf
	var/weather_enabled = 0
	var/weather_safe = 0 //1 makes it weather fx aesthetic-only
	var/list/active_weathers = list() //weathertypes in action
	var/weather_dynamic = 1 //if 1, weather changes periodically
	var/list/weather_tracker = list() //handles activating weather fx only if needed
	var/list/weather_overlays = list() //so we don't remove non-weather overlays by accident

//Too much work to just tick it on manually
/turf/proc/weather_enable(dynamic = 1)
	weather_enabled = 1
	if(dynamic)
		weather_dynamic = dynamic
	if(SSurist_weather)
		if(!(src in SSurist_weather.weather_cache))
			SSurist_weather.weather_cache += src
	else
		if(!(src in pending_weathers))
			pending_weathers += src

//clean up and disable weather
/turf/proc/weather_disable()
	weather_enabled = 0
	active_weathers.Cut()
	weather_tracker.Cut()
	update_weather_icon()

//An 'I'm alive!' response, for minimal possible load
/turf/proc/weather_check_in()
	if(weather_enabled)
		return 1

/turf/proc/WActive()
	if(!(weather_safe))
		if(length(weather_tracker))
			return 1
	return 0

/turf/proc/update_weather_icon()
	/* first, clean up */
	var/list/curr_overlays = list()
	curr_overlays.Copy(src.overlays)
	ClearOverlays()
	for(var/old_overlay in curr_overlays)
		if(old_overlay in weather_overlays)
			continue
		else
			AddOverlays(old_overlay)
	weather_overlays.Cut()
	/* now, add new ones */
	for(var/obj/weathertype/WT in active_weathers)
		weather_overlays += WT
		AddOverlays(weather_overlays)

//Something entered the weather zone so the weather has to do work
/turf/proc/weather_activate()
	if(SSurist_weather)
		if(!(weather_safe)) //does not process effects, so don't bother
			SSurist_weather.active_cache += src

/turf/proc/inflictW()
	if(!(weather_safe))
		for(var/obj/weathertype/WT in active_weathers)
			WT.GetWeatherEffect(src)

/* hook into game/turfs/turf.dm's Entered() */
/turf/Entered(atom/O)
	. = ..()
	if(weather_enabled)
		if(!(weather_safe))
			weather_activate()
			weather_tracker += O

/turf/Exited(atom/O)
	. = ..()
	if(O in weather_tracker)
		weather_tracker -= O

/* a lightweight, self-deleting turf weather enabler
for when you don't want to mess with the obj weather

DO NOT map it in en-masse to enable a lot of turfs,
use area procs or whatever, or you'll break the map */
/obj/urist_intangible/weather_enabler
	icon_state = "splash"

/obj/urist_intangible/weather_enabler/New()
	if(isturf(src.loc))
		var/turf/WT = src.loc
		WT.weather_enable()
	qdel(src)
	..()

#undef WEATHER_PLANE
