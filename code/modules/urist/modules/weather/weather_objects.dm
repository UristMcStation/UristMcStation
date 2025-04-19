/* weather objects, handle weather effects together with a controller and weathertypes */

/obj/spawner/weatherspawn
	icon_state = "splash"

/obj/urist_intangible/weather
	name = "weather"
	icon = 'icons/urist/weather.dmi'
	icon_state = "splash" //mapping indicator only!

	layer = 5
	anchored = TRUE //prevents weather from being /draggable
	mouse_opacity = 0 //doesn't need to be clickable and is less of an annoyance for players
	var/weather_safe = 0 //1 makes it aesthetic-only
	var/list/active_weathers = list()
	var/weather_dynamic = 1 //if 1, changes periodically
	var/list/weather_tracker = list()
	var/list/weather_overlays = list() //so we don't remove non-weather overlays by accident

/obj/urist_intangible/weather/New()
	icon_state = ""
	/*if(weather_dynamic)
		weather_report()*/

	/*if(!(active_weathers) || !(length(active_weathers)))
		active_weathers += get_climate_weather(get_area(src))
	var/index = 0
	for(var/i in active_weathers) //paths don't work with implicit types
		index++
		if(ispath(i, /obj/weathertype))
			var/obj/weathertype/WT = i
			active_weathers[index] = new WT //instantiate all types
			*/

	var/list/new_weathers = list()
	for(var/i in active_weathers)
		new_weathers += new i
	active_weathers = new_weathers
	update_icon()
	..()

//Handles initializing weather processing for a new object
/obj/urist_intangible/weather/proc/weather_report()
	if(SSurist_weather)
		SSurist_weather.weather_cache += src
	else
		pending_weathers += src //no controller? add it on the bucket list.


//An 'I'm alive!' response, for minimal possible load
/obj/urist_intangible/weather/proc/weather_check_in()
	if(weather_dynamic)
		return 1

//Something entered the weather zone so the weather has to do work
/obj/urist_intangible/weather/proc/weather_activate()
	if(!(weather_safe) || !(SSurist_weather)) //does not process effects, so don't bother
		SSurist_weather.active_cache += src

//If there's still processable objects, return 1
/obj/urist_intangible/weather/proc/WActive()
	if(!(weather_safe))
		if(length(weather_tracker))
			return 1
	return 0

/obj/urist_intangible/weather/on_update_icon()
	..()
	update_weather_icon()

/obj/urist_intangible/weather/proc/update_weather_icon()
	/* first, clean up */
	for(var/old_overlay in weather_overlays)
		if(old_overlay in overlays)
			overlays -= old_overlay
	/* now, add new ones */
	for(var/obj/weathertype/WT in active_weathers)
		weather_overlays += WT
	overlays += weather_overlays

//Handles all weather effects
/obj/urist_intangible/weather/proc/inflictW()
	if(!(weather_safe))
		for(var/obj/weathertype/WT in active_weathers)
			WT.GetWeatherEffect(src.loc)

/obj/urist_intangible/weather/Crossed(O)
	if(!(weather_safe))
		src.weather_activate()
		weather_tracker += O
	..()

/obj/urist_intangible/weather/Uncrossed(O)
	if(!(weather_safe))
		if(O in weather_tracker)
			weather_tracker -= O
	..()

/*did not really merit a subtype just for weather_dynamic=0, adding this
so that static new weathers can be mapped in easily by VVing it directly*/
/obj/urist_intangible/weather/invariant
	weather_dynamic = 0
	active_weathers = list()

/obj/urist_intangible/weather/invariant/mildsnow
	name = "snow"
	icon_state = "msnow"
	active_weathers = list(/obj/weathertype/snow)

/obj/urist_intangible/weather/invariant/blowingsnow
	name = "blizzard"
	icon_state = "bsnow"
	active_weathers = list(/obj/weathertype/snow/arctic)

/obj/urist_intangible/weather/invariant/rain
	name = "rain"
	icon_state = "rain"
	active_weathers = list(/obj/weathertype/rain)

/obj/urist_intangible/weather/invariant/bloodrain
	name = "blood rain" //ow the edge
	icon_state = "rain"
	weather_safe = 0
	active_weathers = list(/obj/weathertype/rain/blood)

/obj/urist_intangible/weather/invariant/acidrain
	name = "acid rain"
	icon_state = "rain"
	weather_safe = 0
	active_weathers = list(/obj/weathertype/rain/acid)

//optional underlay thing for the rain - uses the same colors, #556 recommended for rain with null splash
/obj/urist_intangible/weather/invariant/splash
	name = "rain splashes"
	icon_state = "splash"
	weather_safe = 1
	weather_dynamic = 0
	active_weathers = list(/obj/weathertype/splash)

/obj/urist_intangible/weather/invariant/fog
	name = "fog"
	icon_state = "fog"
	weather_safe = 1
	weather_dynamic = 0
	active_weathers = list(/obj/weathertype/fog)

/obj/urist_intangible/weather/invariant/fallout
	name = "fallout"
	icon_state = "bsnow"
	weather_safe = 0
	weather_dynamic = 0
	active_weathers = list(/obj/weathertype/rain/fallout)

/obj/urist_intangible/weather/invariant/sandstorm
	name = "sandstorm"
	icon_state = "fog"
	weather_safe = 0
	weather_dynamic = 0
	active_weathers = list(/obj/weathertype/sandstorm)

/obj/urist_intangible/weather/invariant/holo_rain
	name = "rain"
	icon_state = "rain"
	weather_safe = 1
	active_weathers = list(/obj/weathertype/holorain)

/obj/urist_intangible/weather/invariant/holo_snow
	name = "snow"
	icon_state = "msnow"
	weather_safe = 1
	active_weathers = list(/obj/weathertype/holosnow)
