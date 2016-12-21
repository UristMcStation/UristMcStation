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
	..()

//Handles initializing weather processing for a z-level if an instance is spawned on a new z
/obj/effect/weather/proc/weather_report()
	var/datum/weather_master/W = weathermaster
	W.weather_cache += src

//An 'I'm alive!' response, for minimal possible load
/obj/effect/weather/proc/check_in()
	if(mutable)
		return 1

//Something entered the weather zone so the weather has to do work
/obj/effect/weather/proc/activate()
	if(!(safe)) //does not process effects, so don't bother
		var/datum/weather_master/W = weathermaster
		W.active_cache += src

//If there's still processable objects, return 1
/obj/effect/weather/proc/Active()
	if(!(safe))
		if(tracker.len)
			return 1
	return 0

/obj/effect/weather/update_icon()
	overlays = null
	for(var/obj/weathertype/WT in active_weathers)
		overlays += WT

//Handles all weather effects
/obj/effect/weather/proc/inflict()
	for(var/obj/weathertype/WT in active_weathers)
		WT.GetWeatherEffect(src.loc)

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

/obj/effect/weather/rain
	name = "rain"

//optional underlay thing for the rain - uses the same colors, #556 recommended for rain with null splash
/obj/effect/weather/splash
	name = "rain splashes"

/obj/effect/weather/fog
	name = "fog"