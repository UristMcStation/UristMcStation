/* Helper for grabbing and instantiating new weather types */
/proc/take_weather_from(var/list/climate)
	var/weather = pick_n_take(climate)
	if(ispath(weather, /obj/weathertype))
		var/obj/weathertype/WT = weather
		return (WT)
	return

//Gets weather based on what the area can get
/proc/get_climate_weather(var/area/WA)
	var/list/local_climate = list()
	var/list/nuweather = list(/obj/weathertype/error) //highly visible failure mode
	if(WA)
		if(WA.climate && WA.climate.len)
			nuweather = list()
			local_climate = WA.climate.Copy() //so we can remove values from it
			nuweather += (take_weather_from(local_climate))
			if(prob(10) && local_climate.len) //check values on prob
				nuweather += (take_weather_from(local_climate))
	return nuweather