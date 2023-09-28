# ifdef GOAI_LIBRARY_FEATURES
/*
	These are simple defaults for your project.
 */

world
	fps = 30		// 25 frames per second
	icon_size = 32	// 32x32 icon size by default

	view = 6		// show up to 6 tiles outward from center (13x13 view)


// Make objects move 8 pixels per tick when walking

mob
	//step_size = 16
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost1"


obj
	var/pathweight = 1
	//step_size = 32

/turf
	var/pathweight = 1

# endif
