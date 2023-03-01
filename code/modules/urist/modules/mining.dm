//honks all the way down

/turf/simulated/mineral/ore
	var/mineralName = ""
	var/mineralAmt = 0
	var/spread = 0 //will the seam spread?
	var/spreadChance = 0 //the percentual chance of an ore spreading to the neighbouring tiles

/turf/simulated/mineral/ore/New()
	if (mineralName && mineralAmt && spread && spreadChance)
		for(var/dir in GLOB.cardinal)
			if(prob(spreadChance))
				var/turf/T = get_step(src, dir)
				if(istype(T, /turf/simulated/mineral/random))
					Spread(T)
	return

/turf/simulated/mineral/ore/proc/Spread(var/turf/T)
	new src.type(T)

/turf/simulated/mineral/ore/uranium
	name = "Uranium deposit"
	icon_state = "rock_Uranium"
	mineralName = "Uranium"
	mineralAmt = 5
	spreadChance = 10
	spread = 1

/turf/simulated/mineral/ore/iron
	name = "Iron deposit"
	icon_state = "rock_Iron"
	mineralName = "Iron"
	mineralAmt = 5
	spreadChance = 25
	spread = 1

/turf/simulated/mineral/ore/diamond
	name = "Diamond deposit"
	icon_state = "rock_Diamond"
	mineralName = "Diamond"
	mineralAmt = 5
	spreadChance = 10
	spread = 1

/turf/simulated/mineral/ore/gold
	name = "Gold deposit"
	icon_state = "rock_Gold"
	mineralName = "Gold"
	mineralAmt = 5
	spreadChance = 10
	spread = 1

/turf/simulated/mineral/ore/silver
	name = "Silver deposit"
	icon_state = "rock_Silver"
	mineralName = "Silver"
	mineralAmt = 5
	spreadChance = 10
	spread = 1

/turf/simulated/mineral/ore/plasma
	name = "Plasma deposit"
	icon_state = "rock_Plasma"
	mineralName = "Plasma"
	mineralAmt = 5
	spreadChance = 25
	spread = 1

/turf/simulated/mineral/ore/clown
	name = "Bananium deposit"
	icon_state = "rock_Clown"
	mineralName = "Clown"
	mineralAmt = 3
	spreadChance = 0
	spread = 0

//honk

/obj/item/weapon/ore/clown
	name = "Bananium ore"
	icon_state = "Clown ore"
	origin_tech = "materials=4"

//planet

/turf/simulated/mineral/planet
	mined_turf = /turf/simulated/floor/asteroid/planet

/turf/simulated/mineral/random/planet
	mined_turf = /turf/simulated/floor/asteroid/planet

/turf/simulated/mineral/random/high_chance/planet
	mined_turf = /turf/simulated/floor/asteroid/planet

/datum/random_map/automata/cave_system/planet
	descriptor = "planet caves"
	floor_type = /turf/simulated/floor/asteroid/planet
	wall_type = /turf/simulated/mineral/planet

/obj/effect/landmark/random_gen/planet/Initialize()
	. = ..()

	if (!config.generate_map)
		return

	var/min_x = 1
	var/min_y = 1
	var/max_x = world.maxx
	var/max_y = world.maxy

	if (generation_width)
		min_x = max(src.x, min_x)
		max_x = min(src.x + generation_width, max_x)
	if (generation_height)
		min_y = max(src.y, min_y)
		max_y = min(src.y + generation_height, max_y)

	new /datum/random_map/automata/cave_system/planet(seed, min_x, min_y, src.z, max_x, max_y)
	new /datum/random_map/noise/ore(seed, min_x, min_y, src.z, max_x, max_y)

	GLOB.using_map.refresh_mining_turfs(src.z)