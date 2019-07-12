/obj/effect/overmap/sector/station
	var/faction = null
	var/spawn_type = null
	var/mob/living/spawned_ship
	var/spawn_time_high = 10 MINUTES
	var/spawn_time_low = 2 MINUTES
	var/cooldown = 0 //if we get crossed by a ship of the same faction, it gets eaten. this is so merchant ships can ferry between stations. Cooldown is so it can get away
	var/spawn_ships = FALSE
	var/patrolship = null //if you piss us off, we start spawning the big boys
	known = 1
	icon = 'icons/urist/misc/overmap.dmi'
	icon_state = "station1"

/*
/obj/effect/overmap/sector/station/Initialize()
	if(spawn_ships)
		qdel(src)
		return
	else
		..() */
/*
/obj/effect/overmap/sector/station/New()
	..()
	if(spawn_ships && spawn_type)

		START_PROCESSING(SSobj, src)
		spawned_ship = new spawn_type(get_turf(src))

/obj/effect/overmap/sector/station/Process()
	//if any of our ships are killed, spawn new ones
	if(!spawned_ship || spawned_ship.stat == DEAD)
		cooldown = 0 //cooldown is zero, just in case our ship is killed before the cooldown runs out for some reason
		var/newship = pick(spawn_type)
		spawned_ship = new newship(src)
		//after a random timeout, at the station's location (2-10 minutes currently, will probably change this)
		spawn(rand(spawn_time_low,spawn_time_high))
			spawned_ship.loc = src.loc
			cooldown = 3000
			spawn(cooldown)
				cooldown = 0

/obj/effect/overmap/sector/station/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/effect/overmap/sector/station/Crossed(mob/living/M)
	if(istype(M, /mob/living/simple_animal/hostile/overmapship)) //if we're crossed by a ship of the same faction, we eat it
		var/mob/living/simple_animal/hostile/overmapship/S = M
		if(!cooldown && !S.incombat && !S.dying && S.faction == src.faction)
			if(S == spawned_ship)
				spawned_ship = null
			qdel(S)
	else
		..()
*/