/obj/effect/overmap/visitable/sector/station
	var/datum/factions/faction
	var/list/spawn_types //what kind of ships can we spawn
	var/list/spawned_ships //what ships have we spawned
	var/ship_amount = 0 //how many ships have we spawned
	var/total_ships = 0 //how many can we spawn
	var/remaining_ships = 0
	var/spawn_time_high = 10 MINUTES
	var/spawn_time_low = 5 MINUTES
//	var/cooldown = 0 //if we get crossed by a ship of the same faction, it gets eaten. this is so merchant ships can ferry between stations. Cooldown is so it can get away
	var/busy = FALSE
	var/spawn_ships = FALSE
	var/mob/living/simple_animal/hostile/overmapship/patrolship = null //if you piss us off, we start spawning the big boys
	known = TRUE
	icon = 'icons/urist/misc/overmap.dmi'
	icon_state = "station1"
	var/station_holder = null //the holder for station battles

/obj/effect/overmap/visitable/sector/station/Initialize() //I'm not really sure what i was doing here
	START_PROCESSING(SSobj, src)
	if(faction)
		for(var/datum/factions/F in SSfactions.factions)
			if(F.type == faction)
				faction = F
	. = ..()

/obj/effect/overmap/visitable/sector/station/Process()
	if(remaining_ships && !busy)
		if(ship_amount < total_ships)
			busy = TRUE
			var/newship = pick(spawn_types)
			var/mob/living/simple_animal/hostile/overmapship/S = new newship(get_turf(src))
			S.home_station = src
			if(S.faction != faction)
				S.hiddenfaction = faction //just in case

//			spawned_ships += S
			ship_amount++
			remaining_ships--

			spawn(rand(spawn_time_low,spawn_time_high))
				busy = FALSE

	if(remaining_ships == 0)
		STOP_PROCESSING(SSobj, src)

/obj/effect/overmap/visitable/sector/station/proc/fallback_spawning()
	if(remaining_ships)
		if(ship_amount < total_ships)
			var/newship = pick(spawn_types)
			var/mob/living/simple_animal/hostile/overmapship/S = new newship
			S.home_station = src
			if(S.faction != faction)
				S.hiddenfaction = faction //just in case

	//		spawned_ships += S
			ship_amount++
			remaining_ships--
			busy = TRUE

/obj/effect/overmap/visitable/sector/station/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/effect/overmap/visitable/sector/station/Crossed(atom/movable/M as mob|obj)
	if(station_holder)
		if(istype(M, /obj/effect/overmap/visitable/ship/combat))
			if(faction.hostile && known) //if we've discovered the station //come back to this
				var/mob/living/simple_animal/hostile/overmapship/S =  new station_holder(get_turf(src))
				S.hiddenfaction = src.faction
				S.home_station = src

				var/obj/effect/overmap/visitable/ship/combat/C = M
				C.Contact(S)

	..()

/obj/effect/overmap/visitable/sector/station/proc/update_visible()
	return

/obj/effect/overmap/visitable/sector/station/hostile
	hide_from_reports = TRUE
	known = FALSE