var/datum/controller/process/weather/weatherProcess

//weather controller - handles weather changes
/datum/controller/process/weather
	var/weather_change_ticks = 50 //delays weather changes by N scheduler intervals
	var/current_wcticks = 0
	var/list/weather_cache = list() //meteorologically active weather objects
	var/list/active_cache = list() //weathers with new objects to process, EVEN STATIC
	var/area_weather_change_prob = 100 //odds, per area, weather is changed

/datum/controller/process/weather/setup()
	name = "weather"
	schedule_interval = 20
	if(weatherProcess != src)
		qdel(weatherProcess)
		weatherProcess = src
	update_cache()
	update_active()
	//change_weather(1)

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
	if(pending_weathers.len) //uh-oh, we have a backlog
		for(var/WO in pending_weathers)
			weather_cache += WO
			pending_weathers -= WO //transfer from backlog
	weather_cache = get_weather_objs() //prune dead/VVd safe references

/datum/controller/process/weather/proc/update_active()
	var/list/responsive = list()
	for(var/i in active_cache)
		if(istype(i, /obj/effect/weather))
			var/obj/effect/weather/WO = i
			if(WO.WActive()) //not active, not processed
				responsive += WO
		else if(istype(i, /turf))
			var/obj/effect/weather/WTu = i
			if(WTu.WActive())
				responsive += WTu
	active_cache.Cut()
	active_cache = responsive //process only 'tripped' weathers

/datum/controller/process/weather/proc/get_weather_objs()
	var/act_weathers = list()
	for(var/i in weather_cache)
		if(istype(i, /obj/effect/weather))
			var/obj/effect/weather/WO = i
			if(WO.weather_check_in()) //should be always true while object exists and should change
				act_weathers += WO
		else if(istype(i, /turf))
			var/obj/effect/weather/WTu = i
			if(WTu.weather_check_in())
				act_weathers += WTu
	return act_weathers

//handles changes; call with initial=1 to ensure every area is changed
/datum/controller/process/weather/proc/change_weather(var/initial = 0)
	var/list/processed = list()
	for(var/weather_handler in weather_cache)
		if(istype(weather_handler, /obj/effect/weather))
			var/obj/effect/weather/WO = weather_handler
			var/area/WA = get_area(WO)
			if(!(WA in processed))
				processed += WA
				if(prob(area_weather_change_prob) || initial)
					WA.weather = get_climate_weather(WA)
				else
					continue //no change, move on
			/*else if(WA.weather == WO.active_weathers) //no reassignment was made
				continue //same as before
				*/
			if(!(WA.weather))
				WA.weather = /obj/weathertype/error
			WO.active_weathers.Cut()
			for(var/i in WA.weather)
				if(ispath(i, /obj/weathertype))
					var/obj/weathertype/WT = i
					WA.weather.Add(new WT)
					WA.weather.Remove(i)
			for(var/j in WA.weather)
				if(istype(j, /obj/weathertype))
					var/obj/weathertype/WT = j
					WO.active_weathers.Add(WT)
				else if(ispath(j))
					world.log << "Weathertype ([j]) received from [WA.name] by [WO.name] in [WO.loc] is path instead of instance!"
			WO.update_weather_icon()
		else if(istype(weather_handler, /turf))
			var/turf/WTu = weather_handler
			/* I didn't want to copypaste, but
			BYOND sucks for duck typing -_- */
			var/area/WA = get_area(WTu)
			if(!(WA in processed))
				processed += WA
				if(prob(area_weather_change_prob) || initial)
					WA.weather = get_climate_weather(WA)
				/*else
					continue //no change, move on
			else if(WA.weather == WTu.active_weathers) //no reassignment was made
				continue //same as before
				*/
			if(!(WA.weather))
				WA.weather = /obj/weathertype/error
			WTu.active_weathers.Cut()
			for(var/i in WA.weather)
				if(ispath(i, /obj/weathertype))
					var/obj/weathertype/WT = i
					WA.weather.Add(new WT)
					WA.weather.Remove(i)
			for(var/j in WA.weather)
				if(istype(j, /obj/weathertype))
					var/obj/weathertype/WT = j
					WTu.active_weathers.Add(WT)
				else if(ispath(j))
					world.log << "Weathertype ([j]) received from [WA.name] by [WTu.name] in [WTu.loc] is path instead of instance!"
			WTu.update_weather_icon()


/datum/controller/process/weather/proc/inflict_effects()
	for(var/weatherhandler in active_cache)
		if(istype(weatherhandler, /obj/effect/weather))
			var/obj/effect/weather/WO = weatherhandler
			if(!(WO.weather_safe) && WO.weather_check_in())
				WO.inflictW()
		else if(istype(weatherhandler, /turf))
			var/turf/WTu = weatherhandler
			if(!(WTu.weather_safe) && WTu.weather_check_in())
				WTu.inflictW()