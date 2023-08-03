//holder objects for station battles, and other stuff for stations

/mob/living/simple_animal/hostile/overmapship/station_holder
	icon_state = null
	can_board = FALSE
	ai_holder = /datum/ai_holder/simple_animal/inert

/mob/living/simple_animal/hostile/overmapship/station_holder/shipdeath() //todo: damage the station
	if(!dying)
		home_station.station_holder = null //defences are destroyed
		home_station.remaining_ships = 0

	..()

/mob/living/simple_animal/hostile/overmapship/station_holder/pirate
	hiddenfaction = /datum/factions/pirate
	aggressive = 1
	shields = 1500
	health = 100
	maxHealth = 100
	name = "pirate station external defences"
	ship_category = "pirate station external defences"

/mob/living/simple_animal/hostile/overmapship/station_holder/pirate/New()
	components = list(
		new /datum/shipcomponents/shield/pirate_station,
		new /datum/shipcomponents/weapons/smallmissile/battery,
		new /datum/shipcomponents/weapons/smallmissile/battery,
		new /datum/shipcomponents/weapons/heavylaser,
		new /datum/shipcomponents/weapons/heavylaser,
		new /datum/shipcomponents/weapons/ioncannon,
		new /datum/shipcomponents/repair_module/module_restore,
		new /datum/shipcomponents/point_defence/basic,
		new /datum/shipcomponents/shield_disruptor
		)

	..()
