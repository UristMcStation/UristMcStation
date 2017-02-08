//'Climates' (definitions of weather probabilities per area as lists) go here. You can use weights as for pick().
//NOTE: /clear weather's effect is overriden by all other types! If you have rain and clear, it's effectively rain.

/area
	var/list/climate = list(/obj/weathertype/clear) //all potential area weather types
	var/list/weather = list(/obj/weathertype/clear) //current pick for all objects in area

/area/jungle
	climate = list(/obj/weathertype/rain, /obj/weathertype/fog, /obj/weathertype/clear)

/area/awaymission/train/snow
	climate = list(/obj/weathertype/snow, /obj/weathertype/clear, /obj/weathertype/fog)