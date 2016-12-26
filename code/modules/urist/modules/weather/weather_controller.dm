var/datum/controller/process/weather/weatherProcess

//weather controller - handles weather changes
/datum/controller/process/weather
	var/weather_change_ticks = 50 //delays weather changes by N scheduler intervals
	var/current_wcticks = 0
	var/weather_cache = list() //meteorologically active weather objects
	var/active_cache = list() //weathers with new objects to process, EVEN STATIC

/datum/controller/process/weather/setup()
	name = "weather"
	schedule_interval = 20
	weatherProcess = src
	update_cache()
	update_active()

/datum/controller/process/weather/doWork()
	update_cache()
	update_active()
	inflict_effects()
	current_wcticks++
	if(current_wcticks >= weather_change_ticks)
		change_weather()
		current_wcticks = 0
	SCHECK

/datum/controller/process/weather/proc/update_cache()
	weather_cache = get_weather_objs() //prune dead/VVd safe references

/datum/controller/process/weather/proc/update_active()
	var/list/responsive = list()
	for(var/obj/effect/weather/WO in active_cache)
		if(WO.Active()) //if there are no objects to process, don't
			responsive += WO
	active_cache = responsive //process only 'tripped' weathers

/datum/controller/process/weather/proc/get_weather_objs()
	var/act_weathers = list()
	for(var/obj/effect/weather/WO in weather_cache)
		if(WO.check_in()) //should be always true while object exists and should change
			act_weathers += WO
	return act_weathers

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

/datum/controller/process/weather/proc/change_weather()
	var/list/processed = list()
	for(var/obj/effect/weather/WO in weather_cache)
		var/area/WA = get_area(WO)
		if(!(WA in processed))
			WA.weather = get_climate_weather(WA)
			processed += WA
		if(!(WA.weather))
			WA.weather = /obj/weathertype/error
		WO.active_weathers.Cut()
		for(var/i in WA.weather)
			if(ispath(i, /obj/weathertype))
				var/obj/weathertype/WT = i
				WO.active_weathers.Add(new WT)
		WO.update_icon()

/datum/controller/process/weather/proc/inflict_effects()
	for(var/obj/effect/weather/WO in active_cache)
		WO.inflict()