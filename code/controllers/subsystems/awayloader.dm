/*
SUBSYSTEM_DEF(awaymissions)
	name = "Away Missions"
	init_order = INIT_ORDER_MAPPING
	flags = SS_NO_FIRE

/datum/controller/subsystem/atoms/Initialize(timeofday)
	createRandomZlevel()
	return ..()
*/