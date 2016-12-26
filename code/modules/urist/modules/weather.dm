//weather effects

/obj/effect/weather
	name = "weather"
	icon = 'icons/urist/weather.dmi'
	icon_state = ""

	layer = 5
	anchored = 1 //prevents weather from being /draggable/
	mouse_opacity = 0 //doesn't need to be clickable and is less of an annoyance for players
	var/safe = 0 //1 makes it aesthetic-only
	var/list/active_weathers = list()
	var/mutable = 1 //if 1, changes periodically
	var/list/tracker = list()

/obj/effect/weather/New()
	if(mutable)
		weather_report()
	if(!(active_weathers) || !(active_weathers.len))
		active_weathers += get_climate_weather(get_area(src))
	var/index = 0
	for(var/i in active_weathers) //paths don't work with implicit types
		index++
		if(ispath(i, /obj/weathertype))
			var/obj/weathertype/WT = i
			active_weathers[index] = new WT //instantiate all types
	update_icon()
	..()

//Handles initializing weather processing for a z-level if an instance is spawned on a new z
/obj/effect/weather/proc/weather_report()
	while(!(weatherProcess))
		sleep(1) //await controller setup
	weatherProcess.weather_cache += src

//An 'I'm alive!' response, for minimal possible load
/obj/effect/weather/proc/check_in()
	if(mutable)
		return 1

//Something entered the weather zone so the weather has to do work
/obj/effect/weather/proc/activate()
	if(!(safe)) //does not process effects, so don't bother
		weatherProcess.active_cache += src

//If there's still processable objects, return 1
/obj/effect/weather/proc/Active()
	if(!(safe))
		if(tracker.len)
			return 1
	return 0

/obj/effect/weather/update_icon()
	..()
	overlays.Cut()
	for(var/obj/weathertype/WT in active_weathers)
		overlays += WT

//Handles all weather effects
/obj/effect/weather/proc/inflict()
	for(var/obj/weathertype/WT in active_weathers)
		WT.GetWeatherEffect(src.loc)
	return 1

/obj/effect/weather/Crossed(O)
	if(!(safe))
		src.activate()
		tracker += O
	..()

/obj/effect/weather/Uncrossed(O)
	if(!(safe))
		if(O in tracker)
			tracker -= O
	..()

/obj/effect/weather/blowingsnow
	name = "blowing snow"
	mutable = 0
	active_weathers = list(/obj/weathertype/snow)

/obj/effect/weather/rain
	name = "rain"
	mutable = 0
	active_weathers = list(/obj/weathertype/rain)

//optional underlay thing for the rain - uses the same colors, #556 recommended for rain with null splash
/obj/effect/weather/splash
	name = "rain splashes"
	safe = 1
	mutable = 0
	active_weathers = list(/obj/weathertype/splash)

/obj/effect/weather/fog
	name = "fog"
	safe = 1
	mutable = 0
	active_weathers = list(/obj/weathertype/fog)

/* Helper for grabbing and instantiating new weather types */
/proc/take_weather_from(var/list/climate)
	var/weather = pick_n_take(climate)
	if(ispath(weather, /obj/weathertype))
		var/obj/weathertype/WT = weather
		return (WT)
	return