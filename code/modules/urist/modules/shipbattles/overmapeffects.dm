/obj/effect/overmap/station
	var/stationmap = null
	var/faction = null
	var/spawn_type = null
	var/mob/living/spawned_ship
	var/spawn_time_high = 2400
	var/spawn_time_low = 1200
	var/cooldown = 0 //if we get crossed by a ship of the same faction, it gets eaten. this is so merchant ships can ferry between stations. Cooldown is so it can get away

/obj/effect/overmap/station/New()
	if(!spawn_type)
		var/new_type = pick(typesof(/obj/effect/overmap/station) - /obj/effect/overmap/station)
		new new_type(get_turf(src))
		qdel(src)

	START_PROCESSING(SSobj, src)
	spawned_ship = new spawn_type(get_turf(src))

/obj/effect/overmap/station/Process()
	//if any of our ships are killed, spawn new ones
	if(!spawned_ship || spawned_ship.stat == DEAD)
		spawned_ship = new spawn_type(src)
		//after a random timeout, at the station's location (6-30 seconds)
		spawn(rand(spawn_time_low,spawn_time_high))
			spawned_ship.loc = src.loc
			cooldown = 3000
			spawn(cooldown)
				cooldown = 0

//was doing this with effects, I think I'm doing mobs now. it's too weird adding AI to effects, so here we go.

/mob/living/simple_animal/hostile/overmapship //maybe do components as objects instead of datums
	var/shipdatum = /datum/ships
	var/shields = 0
	var/firedelay = 100


/mob/living/simple_animal/hostile/overmapship/New()
	var/datum/ships/SD = shipdatum

	shields = SD.shields
	health = SD.health
	faction = SD.faction
	name = SD.name
	..()

/mob/living/simple_animal/hostile/overmapship/debug
	shipdatum = /datum/ships/debug

/mob/living/simple_animal/hostile/overmapship/piratesmall
	shipdatum = /datum/ships/piratesmall

/mob/living/simple_animal/hostile/overmapship/Process() //here we do the attacking stuff
	..()


