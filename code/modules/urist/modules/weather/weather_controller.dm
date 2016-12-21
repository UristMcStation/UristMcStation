/var/datum/weather_master/weathermaster

//weather controller - handles weather changes
/datum/controller/process/weather/setup()
	name = "weather controller"
	schedule_interval = 20
	new weathermaster()

/datum/controller/process/weather/doWork()
	weathermaster.update_cache()
	weathermaster.update_active()
	weathermaster.inflict_effects()
	weathermaster.change_weather()

//weather master object
/datum/weather_master
	var/weather_cache = list() //meteorologically active weather objects
	var/active_cache = list() //weathers with new objects to process, EVEN IMMUTABLE

/datum/weather_master/New()
	weathermaster = src

/datum/weather_master/proc/update_cache()
	weather_cache = get_weather_objs() //prune dead/inactive references

/datum/weather_master/proc/update_active()
	for(var/obj/effect/weather/WO in active_cache)
		if(!(WO.Active())) //if there are no objects to process, don't
			active_cache -= WO

/datum/weather_master/proc/get_weather_objs()
	var/active_weathers = list()
	for(var/obj/effect/weather/WO in weather_cache)
		if(WO.check_in()) //should be always true while object exists and should change
			active_weathers += WO
	return active_weathers

/datum/weather_master/proc/change_weather()
	for(var/obj/effect/weather/WO in weather_cache)
		var/local_climate = list()
		var/nuweather = list()
		var/area/WA = get_area(WO)
		if(WA)
			if(WA.climate)
				local_climate = WA.climate //copy so we can remove values from it
				nuweather = pick_n_take(local_climate)
				if(prob(10)) //check values on prob, 1% chance rn for double weather
					nuweather += pick_n_take(local_climate)
		WO.active_weathers = nuweather

/datum/weather_master/proc/inflict_effects()
	for(var/obj/effect/weather/WO in active_cache)
		WO.inflict()