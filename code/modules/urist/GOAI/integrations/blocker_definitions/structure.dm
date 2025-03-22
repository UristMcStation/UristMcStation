# ifdef GOAI_SS13_SUPPORT

// STRUCTURES
/obj/structure
	blocker_gen_enabled = TRUE

/obj/structure/GenerateBlocker()
	return GenerateGenericFullBlocker(src)


// AYYLMAO STRUCTURES
/obj/structure/alien/egg
	blocker_gen_enabled = FALSE

/obj/structure/alien/egg/GenerateBlocker()
	return


/obj/structure/alien/node
	blocker_gen_enabled = FALSE

/obj/structure/alien/node/GenerateBlocker()
	return


// BEDS AND CHAIRS
/obj/structure/bed
	blocker_gen_enabled = FALSE

/obj/structure/bed/GenerateBlocker()
	return


// CABLES fsr
/obj/structure/cable
	blocker_gen_enabled = FALSE

/obj/structure/cable/GenerateBlocker()
	return


// CATWALKS
/obj/structure/catwalk
	blocker_gen_enabled = FALSE

/obj/structure/catwalk/GenerateBlocker()
	return


// HYGIENE
/obj/structure/hygiene
	blocker_gen_enabled = FALSE

/obj/structure/hygiene/GenerateBlocker()
	return


// LADDERS & STAIRS
/obj/structure/ladder
	blocker_gen_enabled = FALSE

/obj/structure/ladder/GenerateBlocker()
	return


/obj/structure/stairs
	blocker_gen_enabled = FALSE

/obj/structure/stairs/GenerateBlocker()
	return


// TABLE
/obj/structure/table/GenerateBlocker()
	var/datum/directional_blocker/blocker_data = null

	if(src.flipped)
		blocker_data = new(src.dir, FALSE, TRUE)

	else
		blocker_data = new(ALL_CARDINAL_DIRS, TRUE, TRUE)

	return blocker_data


// WINDOWS
/obj/structure/window/GenerateBlocker()
	var/datum/directional_blocker/blocker_data = null

	if(src.is_fulltile())
		blocker_data = new(ALL_CARDINAL_DIRS, TRUE, TRUE)

	else
		blocker_data = new(src.dir, FALSE, TRUE)

	return blocker_data

# endif
