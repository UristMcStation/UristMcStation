#define LOC_KITCHEN 0
#define LOC_ATMOS 1
#define LOC_INCIN 2
#define LOC_CHAPEL 3
#define LOC_LIBRARY 4
#define LOC_HYDRO 5
#define LOC_VAULT 6
#define LOC_CONSTR 7
#define LOC_TECH 8
#define LOC_TACTICAL 9

#define VERM_MICE 0
#define VERM_LIZARDS 1
#define VERM_SPIDERS 2
#define VERM_POSSUMS 3
#define VERM_GEESE 4
#define VERM_BIGRAT 5
#define VERM_CORPSERAT 6

/datum/event/infestation
	announceWhen = 10
	endWhen = 11
	var/area/location
	var/vermin
	var/vermstring

/datum/event/infestation/start()
	var/list/vermin_turfs
	var/attempts = 3
	do
		vermin_turfs = set_location_get_infestation_turfs()
		if(!location)
			return
	while(!vermin_turfs && --attempts > 0)

	if(!vermin_turfs)
		log_debug("Vermin infestation failed to find a viable spawn after 3 attempts. Aborting.")
		kill(TRUE)

	var/list/spawn_types = list()
	var/max_number
	vermin = rand(0,6)
	switch(vermin)
		if(VERM_MICE)
			spawn_types = list(/mob/living/simple_animal/passive/mouse) // The base mouse type selects a random color for us
			max_number = 12
			vermstring = "mice"
		if(VERM_LIZARDS)
			spawn_types = list(/mob/living/simple_animal/passive/lizard)
			max_number = 6
			vermstring = "lizards"
		if(VERM_SPIDERS)
			spawn_types = list(/obj/spider/spiderling)
			max_number = 3
			vermstring = "spiders"
		if(VERM_POSSUMS)
			spawn_types = list(/mob/living/simple_animal/passive/opossum)
			max_number = 7
			vermstring = "possums"
		if(VERM_GEESE)
			spawn_types = list(/mob/living/simple_animal/hostile/retaliate/goose)
			max_number = 4
			vermstring = "geese"
		if(VERM_BIGRAT)
			spawn_types = list(/mob/living/simple_animal/hostile/mutated_rat)
			max_number = 5
			vermstring = "mutated rats"
		if(VERM_CORPSERAT)
			spawn_types = list(/mob/living/simple_animal/hostile/mutated_rat/corpserat)
			max_number = 3
			vermstring = "biohazardous rats"

	spawn(0)
		var/num = 0
		for(var/i = 1 to severity)
			num += rand(2,max_number)
		log_and_message_admins("Vermin infestation spawned ([vermstring] x[num]) in \the [location]", user = null, location = pick_area_turf(location))
		while(length(vermin_turfs) && num > 0)
			var/turf/simulated/floor/T = pick(vermin_turfs)
			vermin_turfs.Remove(T)
			num--

			var/spawn_type = pick(spawn_types)
			var/obj/spider/spiderling/S = new spawn_type(T)
			if(istype(S))
				S.amount_grown = -1

/datum/event/infestation/announce()
	command_announcement.Announce("Bioscans indicate that [vermstring] have been breeding in \the [location]. Further infestation is likely if left unchecked.", "[location_name()] Biologic Sensor Network", zlevels = affecting_z)

/datum/event/infestation/proc/set_location_get_infestation_turfs()
	location = pick_area(list(
		GLOBAL_PROC_REF(is_not_space_area),
		GLOBAL_PROC_REF(is_station_area)
	))
	if(!location)
		log_debug("Vermin infestation failed to find a viable area. Aborting.")
		kill(TRUE)
		return

	var/list/vermin_turfs = get_area_turfs(location, list(
		GLOBAL_PROC_REF(not_turf_contains_dense_objects),
		GLOBAL_PROC_REF(IsTurfAtmosSafe)
	))
	if(!length(vermin_turfs))
		log_debug("Vermin infestation failed to find viable turfs in \the [location].")
		return
	return vermin_turfs

#undef LOC_KITCHEN
#undef LOC_ATMOS
#undef LOC_INCIN
#undef LOC_CHAPEL
#undef LOC_LIBRARY
#undef LOC_HYDRO
#undef LOC_VAULT
#undef LOC_TECH
#undef LOC_TACTICAL

#undef VERM_MICE
#undef VERM_LIZARDS
#undef VERM_SPIDERS
#undef VERM_POSSUMS
#undef VERM_GEESE
#undef VERM_BIGRAT
#undef VERM_CORPSERAT
