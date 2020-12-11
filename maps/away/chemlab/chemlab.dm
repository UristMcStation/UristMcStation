#include "chemlab_areas.dm"
#include "chemlab_jobs.dm"
#include "chemlab_access.dm"

// Joinables, Away Map Init, Etc.
/obj/effect/submap_landmark/joinable_submap/chemlab
	name = "Distant Labratory"
	archetype = /decl/submap_archetype/derelict/bearcat

/decl/submap_archetype/derelict/chemlab
	descriptor = "an old labratory, used for creating illict produce."
	map = "Chemlab"
	crew_jobs = list(
		/datum/job/submap/chemlab_supervisor,
		/datum/job/submap/chemlab_worker
	)

/obj/effect/overmap/sector/chemlab
	name = "Unknown Signal"
	desc = "A scrambled signal appears to be originating from a nearby asteroid."
	icon_state = "object"
	known = 0
	)

/datum/map_template/ruin/away_site/chemlab
	name = "Unknown Signal"
	id = "awaysite_bearcat_wreck"
	description = "A scrambled signal appearing to come from an asteroid."
	suffixes = list("chemlab/chemlab.dmm")
	cost = 1

// Additional Content


/obj/item/clothing/mask/gas/biohazardrespirator
/obj/item/clothing/gloves/biohazard
/obj/item/clothing/gloves/biohazard
/obj/item/clothing/head/biohazardbluehood
/obj/item/clothing/suit/biohazardblue
/obj/item/clothing/suit/biohazardradiation
/obj/item/clothing/head/biohazardradiationhood