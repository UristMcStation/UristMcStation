//weather effects

/obj/effect/weather
	name = "weather"
	icon = 'icons/urist/weather.dmi'
	icon_state = "bsnow"

	layer = 5
	anchored = 1 //prevents weather from being /draggable/
	mouse_opacity = 0 //doesn't need to be clickable and is less of an annoyance for players

/obj/effect/weather/blowingsnow
	name = "blowing snow"
	icon_state = "bsnow"
	var/safe = 0 //safe == not arctic; ugly, but better than changing the vars on the map

/obj/effect/weather/blowingsnow/Crossed(O as mob)
	..()
	if(!safe)
		if(istype(O, /mob/living/))
			var/mob/living/M = O
			if(COLD_RESISTANCE in M.mutations)
				M << ("<span class='warning'> The cold wind feels surprisingly pleasant to you.</span>")
			else
				if(prob(85))
					M.apply_damage(rand(3,5), BURN)
					M << ("<span class='warning'> The cold wind tears at your skin!</span>")

/obj/effect/weather/rain
	name = "rain"
	icon_state = "rain"
	color = null //fully supports colors, the null works but is very subtle

/obj/effect/weather/rain/Crossed(O as mob)
	..()
	if(istype(O, /mob/living/carbon/))
		var/mob/living/carbon/M = O
		M.ExtinguishMob()

//optional underlay thing for the rain - uses the same colors, #556 recommended for rain with null splash
/obj/effect/weather/splash
	name = "rain splashes"
	icon_state = "splash"
	color = null
	layer = 2

/obj/effect/weather/fog
	name = "fog"
	icon = 'icons/urist/96x96.dmi'
	icon_state = "fog"
	pixel_x = -32
	pixel_y = -32
	color = "#fff"
	alpha = "128"
