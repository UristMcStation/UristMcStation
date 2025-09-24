// Misc Urist Specific Recipes go here.

/datum/reagent/lube
	name = "Space Lube"
	description = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them."
	taste_description = "slime"
	reagent_state = LIQUID
	color = "#009ca8"
	value = 0.6
	should_admin_log = TRUE // So we can see who's spraying the hallways.

/datum/reagent/lube/touch_turf(turf/simulated/T)
	if(!istype(T))
		return
	if(volume >= 1)
		T.wet_floor(80) // Restored original wet floor value.
