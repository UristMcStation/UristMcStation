/mob/goai/combatant/GeneratePersonality()

	var/dict/new_personality = ..()
	var/list/trait_tags = list()

	// Min Safe Dist
	var/min_safe_dist = rand(2, 4)

	switch(min_safe_dist)
		if(2)
			trait_tags.Add("Bold")
		if(4)
			trait_tags.Add("Coward")

	new_personality[KEY_PERS_MINSAFEDIST] = min_safe_dist

	// Frustration Threshold
	var/max_frustration_threshold = rand(2, 4)

	switch(max_frustration_threshold)
		if(2)
			trait_tags.Add("Decisive")
		if(4)
			trait_tags.Add("Vaccilating")

	new_personality[KEY_PERS_FRUSTRATION_THRESH] = max_frustration_threshold

	//
	if(trait_tags?.len)
		var/trait_text = jointext(trait_tags, " & ")
		src.name += " ([trait_text])"

	return new_personality
