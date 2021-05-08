/mob/living/simple_animal/hostile/overmapship/pirate
	wander = 1 //temporary
	color = "#660000"
	hiddenfaction = /datum/factions/pirate
	aggressive = 1

/mob/living/simple_animal/hostile/overmapship/pirate/small
//	shipdatum = /datum/ships/piratesmall
	shields = 800
	health = 800
	maxHealth = 800
	name = "small pirate ship"
	ship_category = "small pirate ship"
	boardingmap = "maps/shipmaps/ship_pirate_small1.dmm"
	can_board = TRUE
	potential_weapons = list(/datum/shipcomponents/weapons/autocannon, /datum/shipcomponents/weapons/lightlaser/auto, /datum/shipcomponents/weapons/heavylaser, /datum/shipcomponents/weapons/pulse)

/mob/living/simple_animal/hostile/overmapship/pirate/small/Initialize()
	components = list(
		new /datum/shipcomponents/shield/light,
		new /datum/shipcomponents/engines/standard,
		new /datum/shipcomponents/weapons/smallmissile,
		new /datum/shipcomponents/weapons/lightlaser/auto,
		new /datum/shipcomponents/teleporter/pirate/small
	)

	add_weapons()
	add_weapons()

	.=..()

/mob/living/simple_animal/hostile/overmapship/pirate/med
//	shipdatum = /datum/ships/piratesmall
	shields = 2000
	health = 1000
	maxHealth = 1000
	name = "pirate vessel"
	ship_category = "medium pirate vessel"
	boardingmap = "maps/shipmaps/ship_pirate_small1.dmm"
	can_board = TRUE
	potential_weapons = list(/datum/shipcomponents/weapons/pulse/rapid, /datum/shipcomponents/weapons/smalltorpedo, /datum/shipcomponents/weapons/heavylaser/auto, /datum/shipcomponents/weapons/bigmissile, /datum/shipcomponents/weapons/heavylaser/dual)

/mob/living/simple_animal/hostile/overmapship/pirate/med/Initialize()
	components = list(
		new /datum/shipcomponents/shield/medium,
		new /datum/shipcomponents/engines/standard,
		new /datum/shipcomponents/weapons/smallmissile/battery,
		new /datum/shipcomponents/weapons/heavylaser,
		new /datum/shipcomponents/weapons/ioncannon,
		new /datum/shipcomponents/weapons/autocannon,
		new /datum/shipcomponents/point_defence/basic,
		new /datum/shipcomponents/shield_disruptor,
		new /datum/shipcomponents/teleporter/pirate
	)

	add_weapons()
	add_weapons()

	.=..()

/mob/living/simple_animal/hostile/overmapship/alien
	wander = 1
	color = "#660000"
	hiddenfaction = /datum/factions/alien
	aggressive = 1
	name = "Unknown"
	designation = ""

/mob/living/simple_animal/hostile/overmapship/alien/small
	shields = 250 //really weak, but fast charging shields
	health = 1200 //and beefy hulls
	maxHealth = 1200
	ship_category = "Lactera fast attack craft"
	boardingmap = "maps/shipmaps/ship_lactera_small.dmm"
	can_board = TRUE

/mob/living/simple_animal/hostile/overmapship/alien/small/New() //we'll see
	components = list(
		new /datum/shipcomponents/shield/alien_light,
		new /datum/shipcomponents/engines/alien_light,
		new /datum/shipcomponents/weapons/alien/light,
		new /datum/shipcomponents/weapons/alien/light,
		new /datum/shipcomponents/weapons/alien/heavy,
		new /datum/shipcomponents/weapons/smallalienmissile,
		new /datum/shipcomponents/weapons/smallalienmissile,
		new /datum/shipcomponents/point_defence/alienlight,
		new /datum/shipcomponents/shield_disruptor,
		new /datum/shipcomponents/teleporter/alien/small
	)

	..()

/mob/living/simple_animal/hostile/overmapship/alien/heavy //you have to board this motherfucker
	shields = 500 //really weak, but fast charging shields
	health = 2200 //and beefy hulls
	maxHealth = 2200
	ship_category = "Lactera frigate"
	boardingmap = "maps/shipmaps/ship_lactera_large.dmm"
	can_board = TRUE

/mob/living/simple_animal/hostile/overmapship/alien/heavy/New() //only for admemes. this will fuck your day up.
	components = list(
		new /datum/shipcomponents/shield/alien_heavy,
		new /datum/shipcomponents/engines/alien_heavy,
		new /datum/shipcomponents/weapons/alien/light,
		new /datum/shipcomponents/weapons/alien/heavy/burst,
		new /datum/shipcomponents/weapons/alien/heavy/burst,
		new /datum/shipcomponents/weapons/bigalienmissile,
		new /datum/shipcomponents/weapons/bigalienmissile,
		new /datum/shipcomponents/weapons/smallalienmissile/battery,
		new /datum/shipcomponents/weapons/smallalienmissile/battery,
		new /datum/shipcomponents/weapons/alientorpedo,
		new /datum/shipcomponents/point_defence/alienstandard,
		new /datum/shipcomponents/shield_disruptor/overcharge,
		new /datum/shipcomponents/teleporter/alien
	)

	..()