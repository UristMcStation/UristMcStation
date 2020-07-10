/obj/effect/overmap/sector/station
	var/datum/factions/faction
	var/list/spawn_types
	var/list/spawned_ships
	var/ship_amount = 0
	var/total_ships = 0
	var/spawn_time_high = 10 MINUTES
	var/spawn_time_low = 5 MINUTES
	var/cooldown = 0 //if we get crossed by a ship of the same faction, it gets eaten. this is so merchant ships can ferry between stations. Cooldown is so it can get away
	var/busy = 0
	var/spawn_ships = FALSE
	var/mob/living/simple_animal/hostile/overmapship/patrolship = null //if you piss us off, we start spawning the big boys
	known = 1
	icon = 'icons/urist/misc/overmap.dmi'
	icon_state = "station1"

/*
/obj/effect/overmap/sector/station/Initialize() //I'm not really sure what i was doing here
	if(spawn_ships)
		qdel(src)
		return
	else
		..() */

/obj/effect/overmap/sector/station/New()
	..()
	if(spawn_ships)

		START_PROCESSING(SSobj, src)

	if(faction)
		for(var/datum/factions/F in SSfactions.factions)
			if(F.type == faction)
				faction = F


/obj/effect/overmap/sector/station/Process()
	if(!ship_amount >= total_ships && !busy)
		var/newship = pick(spawn_types)
		var/mob/living/simple_animal/hostile/overmapship/S = new newship
		S.home_station = src
		if(S.faction != faction)
			S.faction = faction //just in case

		spawned_ships += S
		ship_amount ++
		busy = 1
		spawn(rand(spawn_time_low,spawn_time_high))
			busy = 0

	..()

/*
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
	..()
*/
/obj/effect/overmap/sector/station/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/*
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