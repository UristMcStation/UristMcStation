/* Helper for grabbing and instantiating new weather types */
/proc/take_weather_from(list/climate)
	var/weather = pick_n_take(climate)
	if(ispath(weather, /obj/weathertype))
		var/obj/weathertype/WT = weather
		return (WT)
	return

//Gets weather based on what the area can get
/proc/get_climate_weather(area/WA)
	var/list/local_climate = list()
	var/list/nuweather = list(/obj/weathertype/error) //highly visible failure mode
	if(WA)
		if(WA.climate && length(WA.climate))
			nuweather = list()
			local_climate = WA.climate.Copy() //so we can remove values from it
			nuweather += (take_weather_from(local_climate))
			if(prob(10) && length(local_climate)) //check values on prob
				nuweather += (take_weather_from(local_climate))
	return nuweather
