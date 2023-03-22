/* Because of how the hallucination system works, definitions here will get picked up automagically. */

/* Will show nightmarish monsters at random. They're not real - probably... */
/datum/hallucination/mirage/monsters
	min_power = 50
	max_power = INFINITY

	var/min_number = 1
	var/max_number = 5

	number = 3



/datum/hallucination/mirage/monsters/New()
	. = ..()

	// Randomize the number of monsters shown
	src.number = rand(src.min_number, src.max_number)
	return


/datum/hallucination/mirage/monsters/generate_mirage()
	var/icon/T = new('icons/uristmob/monsters.dmi')
	return image(T, pick(T.IconStates()), layer = ABOVE_HUMAN_LAYER)
