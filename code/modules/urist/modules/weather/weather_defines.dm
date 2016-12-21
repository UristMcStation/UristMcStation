//Those are objs only because they need to be drawn at various layers, *DO NOT* USE THEM DIRECTLY!
/obj/weathertype
	name = "DO NOT USE THIS, THIS IS ONLY AN OVERLAY!"
	icon = 'icons/urist/weather.dmi'
	icon_state = ""
	color = null
	alpha = 255
	mouse_opacity = 0
	anchored = 1

/obj/weathertype/proc/GetWeatherEffect(var/turf/T) //handles specific effects of weather on... stuff
	return

/obj/weathertype/clear //just for more intuitive climate speccing
	alpha = 0

/obj/weathertype/rain
	icon_state = "rain"
	color = null //fully supports colors, the null works but is very subtle

/obj/weathertype/rain/GetWeatherEffect()
	for(var/mob/living/carbon/M in src.loc)
		M.ExtinguishMob()

/obj/weathertype/snow
	icon_state = "bsnow"

/obj/weathertype/snow/GetWeatherEffect() //TODO: check for cold resistant clothing at some point
	if(istype(O, /mob/living/))
		var/mob/living/M = O
		if(COLD_RESISTANCE in M.mutations)
			M << ("<span class='warning'> The cold wind feels surprisingly pleasant to you.</span>")
		else
			if(prob(50))
				M.apply_damage(rand(1,3), BURN)
				M << ("<span class='warning'> The cold wind tears at your skin!</span>")

/obj/weathertype/splash
	icon_state = "splash"
	layer = 2
	color = null

/obj/weathertype/fog
	icon = 'icons/urist/96x96.dmi'
	icon_state = "fog"
	pixel_x = -32
	pixel_y = -32
	color = "#fff"
	alpha = 128

/obj/weathertype/fallout
	icon_state = "bsnow"
	color = "#5dca31"

/obj/weathertype/wind
	icon_state = "" //deliberately no icon