
datum/event/viral_outbreak
	severity = 1

datum/event/viral_outbreak/setup()
	announceWhen = rand(0, 3000)
	endWhen = announceWhen + 1
	severity = rand(2, 4)

datum/event/viral_outbreak/announce()
	command_announcement.Announce("Confirmed outbreak of level 7 biohazard aboard the [location_name()]. All personnel must contain the outbreak.", "Biohazard Alert", new_sound = GLOB.using_map.level_x_biohazard_sound(7))

datum/event/viral_outbreak/start()
	var/list/candidates = list()	//list of candidate keys
	for(var/mob/living/carbon/human/G in GLOB.player_list)
		if(G.client && G.stat != DEAD && !G.full_prosthetic)
			candidates += G
	if(!candidates.len)	return
	candidates = shuffle(candidates)//Incorporating Donkie's list shuffle

	var/datum/disease2/disease/unique_disease = new /datum/disease2/disease
	unique_disease.makerandom(VIRUS_UNIQUE)

	while(severity > 0 && candidates.len)
		infect_virus2(candidates[1],unique_disease,TRUE)

		candidates.Remove(candidates[1])
		severity--
