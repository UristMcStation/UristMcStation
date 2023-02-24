#include "chemical_lab_areas.dm"
#include "chemical_lab_access.dm"
#include "chemical_lab_jobs.dm"

/obj/effect/submap_landmark/joinable_submap/chemical_lab
	name = "Hidden Laboratory"
	// archetype =

/decl/submap_archetype/derelict/chemical_lab
	descriptor = "A hidden illict labratory, used to create reagents, pathogens and other products."
	map = "chemical_lab"
	crew_jobs = list(/datum/job/submap/chemical_lab_supervisor, /datum/job/submap/chemical_lab_worker)


/obj/effect/overmap/sector/chemical_lab
	name = "Scrambled Signal"
	desc = "A scrambled signal appears to be originating from a nearby asteroid."
	icon_state = "object"
	known = 1


/datum/map_template/ruin/away_site/chemical_lab
	name = "Scrambled Signal"
	id = "awaysite_chemical_lab"
	description = "A scrambled signal appearing to come from an asteroid."
	suffixes = list("chemical_lab/chemical_lab.dmm")
	cost = 1