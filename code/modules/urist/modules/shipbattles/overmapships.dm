/mob/living/simple_animal/hostile/overmapship //maybe do components as objects instead of datums
	var/shipdatum = /datum/ships
	var/shields = 0
	var/firedelay = 100
	icon = 'icons/obj/overmap.dmi'
	icon_state = "ship"
	icon_living = "ship"
	icon_dead = "ship"

/mob/living/simple_animal/hostile/overmapship/New()
	..()

	var/datum/ships/SD = shipdatum

	src.shields = SD.shields
	src.health = SD.health
	src.faction = SD.faction
	src.name = SD.name


/mob/living/simple_animal/hostile/overmapship/Process() //here we do the attacking stuff
	..()

/mob/living/simple_animal/hostile/overmapship/debug
	shipdatum = /datum/ships/debug

/mob/living/simple_animal/hostile/overmapship/piratesmall
	shipdatum = /datum/ships/piratesmall

/mob/living/simple_animal/hostile/overmapship/nanotrasen
	color = "#4286f4"
	wander = 1 //temporary

/mob/living/simple_animal/hostile/overmapship/nanotrasen/ntmerchant
	shipdatum = /datum/ships/nanotrasen/ntmerchant
