#define WEATHER_ACTION_VOLUME 15 //how much of the reagents transfers per act
//Those are objs only because they need to have access to some vars, *DO NOT* USE THEM DIRECTLY!
/obj/weathertype
	name = "DO NOT USE THIS, THIS IS ONLY AN OVERLAY!"
	icon = 'icons/urist/weather.dmi'
	icon_state = ""
	color = null
	alpha = 255
	mouse_opacity = 0
	anchored = 1
	layer = 9 //so it's at the tree level
	var/weathertemp = 310.15 //Kelvin temperature, default is neutral to mobs
	var/list/init_reagents = list() //carried reagents as ids

/obj/weathertype/New()
	. = ..()
	if(init_reagents.len)
		create_reagents(999)
		for(var/R in init_reagents) //TODO: secure this from non-reagent ID strings
			reagents.add_reagent(R, 50, null, 1)

/obj/weathertype/proc/GetWeatherEffect(var/turf/T) //handles specific effects of weather on... stuff
	return 1

/*hijacked from human/life.dm's handle_environment and simplified;
all-purpose cold/hot weather helper for exposure effects, wear a hat */
/obj/weathertype/proc/TemperatureEffect(var/mob/living/M)
	//Body temperature adjusts depending on surrounding atmosphere based on your thermal protection (convection)
	var/temp_adj = 0
	if(weathertemp < M.bodytemperature)			//Place is colder than we are
		var/thermal_protection = M.get_cold_protection(weathertemp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
		if(thermal_protection < 1)
			temp_adj = (1-thermal_protection) * ((weathertemp - M.bodytemperature) / BODYTEMP_COLD_DIVISOR)	//this will be negative
	else if (weathertemp > M.bodytemperature)			//Place is hotter than we are
		var/thermal_protection = M.get_heat_protection(weathertemp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
		if(thermal_protection < 1)
			temp_adj = (1-thermal_protection) * ((weathertemp - M.bodytemperature) / BODYTEMP_HEAT_DIVISOR)

	//Assume standard conditions, thermodynamics go home, atmos can handle that
	M.bodytemperature += between(BODYTEMP_COOLING_MAX, temp_adj, BODYTEMP_HEATING_MAX)

	//Manually triggering discomforts since they work on breath for some reason
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		//spam handled by procs itself
		if(H.bodytemperature >= H.species.heat_discomfort_level)
			H.species.get_environment_discomfort(H, "heat")
		if(H.bodytemperature <= H.species.cold_discomfort_level)
			H.species.get_environment_discomfort(H, "cold")

/obj/weathertype/proc/ReagentEffect(var/turf/T)
	if(reagents)
		for(var/mob/M in T)
			reagents.trans_to(M, WEATHER_ACTION_VOLUME, 1, 1)
		//TODO: handling objs if not too heavy performance-wise

/obj/weathertype/clear //just for more intuitive climate speccing
	alpha = 0

/* weathers that splash some chems around, *doesn't HAVE* to be a rain subtype */

/obj/weathertype/rain
	icon_state = "rain"
	color = null //fully supports colors, the null works but is very subtle
	init_reagents = list("water")

/obj/weathertype/rain/GetWeatherEffect(var/turf/T)
	..(T)
	ReagentEffect(T)

/obj/weathertype/rain/acid
	color = "#91C82F"
	init_reagents = list("sacid")

/obj/weathertype/rain/blood //spoop
	color = "#8A0707"
	init_reagents = list("blood")

/obj/weathertype/rain/fallout
	icon_state = "bsnow"
	color = "#5dca31"
	init_reagents = list("uranium")

/* heat-damage weathers - again, not necessary to subtype from snow */

//mild snow, mostly makes you feel cold
/obj/weathertype/snow
	icon_state = "bsnow"
	weathertemp = 265.0 //mild winter day

/obj/weathertype/snow/GetWeatherEffect(var/turf/T)
	..(T)
	for(var/mob/living/M in T)
		TemperatureEffect(M)

//wear protective clothing or get damage
/obj/weathertype/snow/arctic
	icon_state = "bsnow"
	weathertemp = 233.0 //mild winter day in Siberia, during the Ice Age

//wear insulated spacegear or get damage
/obj/weathertype/snow/cryo
	icon_state = "bsnow"
	weathertemp = 100.0 //when you really really don't want people running in the cold

/obj/weathertype/wind //can fake atmos for unsim like snow but w/o overlays
	icon_state = "" //deliberately no icon
	weathertemp = 265.0

/obj/weathertype/wind/GetWeatherEffect(var/turf/T)
	..(T)
	for(var/mob/living/M in T)
		if(prob(5))
			to_chat(M, "<span class='notice'>You feel a slight gust of wind.</span>")
		TemperatureEffect(M)

/obj/weathertype/wind/arctic
	weathertemp = 233.0

/obj/weathertype/wind/cryo
	weathertemp = 100.0

/obj/weathertype/wind/heatwave
	weathertemp = 343.13 //weirdly high but necessary to be felt at all

/* direct damage weathers */
/obj/weathertype/sandstorm
	icon = 'icons/urist/96x96.dmi'
	icon_state = "fog"
	pixel_x = -32
	pixel_y = -32
	color = "#fff0c9"
	alpha = 128

/obj/weathertype/sandstorm/GetWeatherEffect(var/turf/T)
	..(T)
	for(var/mob/living/O in T)
		var/damage = 5
		if(istype(O, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = O
			damage *= H.reagent_permeability() //wear covering clothes
			H.take_organ_damage(damage, 0, 1, 0) //check sharp vs edge
		else
			O.apply_damage(5, BRUTE)
		if(prob(25) && damage)
			to_chat(O, "<span class='warning'>The sand tears at your body!</span>")

/* miscellanea and aesthetic effects */

/obj/weathertype/splash
	icon_state = "splash"
	layer = 2
	color = null

/obj/weathertype/fog
	icon = 'icons/urist/96x96.dmi'
	icon_state = "fog"
	pixel_x = -32
	pixel_y = -32
	color = "#ffffff"
	alpha = 128

/* error indicator weather, abuss at own peril */
/obj/weathertype/error
	icon_state = "splash"
	color = "#FF0000"

#undef WEATHER_ACTION_VOLUME