
//landmarks


/obj/effect/urist/triggers/New()
	..()
	GLOB.trigger_landmarks += src

/obj/effect/urist/triggers/Destroy()
	GLOB.trigger_landmarks -= src
	return ..()

//where we tele in

/obj/effect/urist/triggers/boarding_landmark
	icon_state = "x3"
	icon = 'icons/mob/screen1.dmi'
	invisibility = 101

//ai spawns

/obj/effect/urist/triggers/ai_defender_landmark
	icon_state = "x3"
	icon = 'icons/mob/screen1.dmi'
	invisibility = 101
	var/spawn_type = null //what's the path of the thing we're spawning

/obj/effect/urist/triggers/ai_defender_landmark/proc/spawn_mobs()
	new spawn_type(src.loc)
	qdel(src)

/obj/effect/urist/triggers/ai_defender_landmark/pirate
	spawn_type = /mob/living/simple_animal/hostile/pirate //temp

/obj/effect/urist/triggers/ai_defender_landmark/terran/space_marine
	spawn_type = /mob/living/simple_animal/hostile/urist/terran/marine_space

/obj/effect/urist/triggers/ai_defender_landmark/terran/marine
	spawn_type = /mob/living/simple_animal/hostile/urist/terran/marine

/obj/effect/urist/triggers/ai_defender_landmark/terran/officer
	spawn_type = /mob/living/simple_animal/hostile/urist/terran/marine_officer

/obj/effect/urist/triggers/ai_defender_landmark/rebel
	spawn_type = /mob/living/simple_animal/hostile/urist/rebel

//humans

/obj/effect/urist/triggers/defender_landmark
	icon_state = "x3"
	icon = 'icons/mob/screen1.dmi'
	invisibility = 101
	var/defender_outfit = null
/*
	var/species = list(SPECIES_HUMAN)                 // List of species to pick from.
	var/spawn_flags = (~0)

	var/skin_colors_per_species   = list() // Custom skin colors, per species -type-, if any. For example if you want dead Skrell to always have blue headtails, or similar
	var/skin_tones_per_species    = list() // Custom skin tones, per species -type-, if any. See above as to why.
	var/eye_colors_per_species    = list() // Custom eye colors, per species -type-, if any. See above as to why.
	var/hair_colors_per_species   = list() // Custom hair colors, per species -type-, if any. See above as to why.
	var/hair_styles_per_species   = list() // Custom hair styles, per species -type-, if any. For example if you want a punk gang with handlebars.
	var/facial_styles_per_species = list() // Custom facial hair styles, per species -type-, if any. See above as to why
	var/genders_per_species       = list() // For gender biases per species -type-
*/

/obj/effect/urist/triggers/defender_landmark/proc/trigger_spawn(var/mob/living/carbon/human/M, var/new_faction = null)
//	var/mob/living/carbon/human/M = new /mob/living/carbon/human(src.loc)
	var/datum/preferences/A = new() //Randomize appearance for the human
	A.randomize_appearance_and_body_for(M)

	var/decl/hierarchy/outfit/O = defender_outfit
	O.equip(M)

	M.update_icon()

//	M.ckey = G.ckey
	M.faction = new_faction

//	qdel(G)

/obj/effect/urist/triggers/defender_landmark/pirate
	defender_outfit = /decl/hierarchy/outfit/pirate/space //temp

/obj/effect/urist/triggers/defender_landmark/terran
	defender_outfit = /decl/hierarchy/outfit/terranmarinespace

/obj/effect/urist/triggers/defender_landmark/rebel/miner
	defender_outfit = /decl/hierarchy/outfit/grayson/miner