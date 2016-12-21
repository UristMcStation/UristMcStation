//'Climates' (definitions of weather probabilities per area as lists) go here. You can use weights as for pick().
//NOTE: /clear weather's effect is overriden by all other types! If you have rain and clear, it's effectively rain.

/area
	var/climate = list(/obj/weathertype/clear)

/area/jungle
	climate = list(/obj/weathertype/rain = 200, /obj/weathertype/fog = 50, /obj/weathertype/clear)

/area/awaymission/train/snow
	climate = list(/obj/weathertype/snow = 500, /obj/weathertype/clear, /obj/weathertype/fog)