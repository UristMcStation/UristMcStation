/mob/living/simple_animal/hostile/overmapship //maybe do components as objects instead of datums
//	var/shipdatum = /datum/ships
	var/shields = 0
	var/firedelay = 100
	icon = 'icons/obj/overmap.dmi'
	icon_state = "ship"
	icon_living = "ship"
	icon_dead = "ship"
	var/boardingmap = null
	var/list/components = list()
	var/incombat = 0
	var/aggressive = 0 //will always attack

/mob/living/simple_animal/hostile/overmapship/New()
	..()

//	var/datum/ships/SD = shipdatum

//	src.shields = SD.shields
//	src.health = SD.health
//	src.faction = SD.faction
//	src.name = SD.name


/mob/living/simple_animal/hostile/overmapship/Process() //here we do the attacking stuff
	..()
//	if(incombat)

/mob/living/simple_animal/hostile/overmapship/debug
//	shipdatum = /datum/ships/debug
	shields = 800
	health = 800
	wander = 1
	components = list(
		new /datum/shipcomponents/shield,
		new /datum/shipcomponents/weapons/ioncannon
	)

/mob/living/simple_animal/hostile/overmapship/pirate
	wander = 1 //temporary
	color = "#660000"
	hiddenfaction = "pirates"
	aggressive = 1

/mob/living/simple_animal/hostile/overmapship/pirate/small
//	shipdatum = /datum/ships/piratesmall
	shields = 800
	health = 800
	name = "small pirate vessel"

/mob/living/simple_animal/hostile/overmapship/piratemed
//	shipdatum = /datum/ships/piratesmall
	shields = 2000
	health = 1000
	name = "pirate vessel"

/mob/living/simple_animal/hostile/overmapship/nanotrasen
	color = "#4286f4"
	wander = 1 //temporary
	hiddenfaction = "nanotrasen"

/mob/living/simple_animal/hostile/overmapship/nanotrasen/ntmerchant
//	shipdatum = /datum/ships/nanotrasen/ntmerchant
	name = "Nanotrasen merchant vessel"
	shields = 1000
	health = 600

/mob/living/simple_animal/hostile/overmapship/nanotrasen/patrol
	name = "Nanotrasen patrol vessel"
	shields = 3000
	health = 1600