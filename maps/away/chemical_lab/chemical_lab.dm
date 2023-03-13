#include "chemical_lab_access.dm"
#include "chemical_lab_areas.dm"
#include "chemical_lab_jobs.dm"
#include "chemical_lab_shuttle.dm"


/obj/effect/submap_landmark/joinable_submap/chemical_lab
	name = "Hidden Laboratory"
	// archetype =

/decl/submap_archetype/derelict/chemical_lab
	descriptor = "Hidden Chemical Lab."
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


// Envelope

/obj/item/weapon/folder/envelope/urist/supervisor_instructions
	name = "employment details envelope"
	desc = "A small envelope with a classified symbol on it. The label reads 'OPEN UPON STARTING SHIFT'."

/obj/item/weapon/folder/envelope/urist/supervisor_instructions/Initialize()
	. = ..()
	var/obj/item/weapon/paper/R = new(src)
	R.set_content("<b>Classified Employment Information<br><br>\
	You have been hand selected for this role as <b>Lab Supervisor<b> by our employers. Your lab is equipped with multiple state-of-the-art production capabilities\
	mainly catering towards chemistry contraband production, with an additional virology and botanical wing provided.\
	Our Team has set up a listening post previous in this sector of space and reported only low traffic of nearby vessels, be aware however of any potential aggressors\
	that may attempt to board the labratory.<br><br>\
	You may be provided with additional lab workers that answer directly to you, while the work crew is expendable, be aware that abusing and killing your crew\
	without sufficent reason will result in reprocussions, relating to family, money, health, et cetera. You have been provided with a Brig to detain any unrulely\
	workers or boarders as you see fit.<br><br>\
	To the south of this station is a small auxilary tool storage and materials area, useful in construction additional protection, computers and other systems.\
	Be aware that it may be in a state of disrepair, and you will need to use the EVA Suits provided to get there. Feel free to take as much material as needed. <br> <br>\
	You have been provided with multiple arms, to be used in the event of boarding and lethal ammo if needed. Try to co-ordinate and defend with your employees\
	in this event. You have additionally been granted your own sidearm to be used for protection. Do not use the armory unless there is an active threat to the lab. <br> <br>\
	You have been provided with a VULTURE-32B Single Seater Escape Vessel, use this only in the event of total facility loss. This will provide enough fuel to escape\
	to a nearby exoplanet, or to stowaway in a nearby ship's hangar. Your Lab Workers are <b> NOT <b> to know of the existence of this vessel, and should knowledge\
	of this be discovered, you are able to do whatever in your power to silence them. <br><br>\
	In the event that the facility is going to fall into hostile hands, you have been provided with a self-destruct system, ensure that this is <b>ARMED<b> before\
	using the escape vessel in order to prevent any evidence of our employer being here. Instructions on how to arm the self-destruct are provided below.<br><br><br>\
	<b>Detonation Instructions<b><br><br>\
	1. Proceed to the Vault located north of your office.\
	2. Access the Warhead's Interface and slot in your ID and confirm your identity to start detonation.\
	3. Detonation will occur after 3 minutes for the activation point starting.\
	4. You will have two minutes to cancel the self-destruct system before it is impossible to stop.\
	5. Proceed to the Vulture-32B Single Seater Escape Shuttle and escape before detonation\
	6. Crew expendable.")

// Closets
// I don't know if I hate modular closets or not yet, nevermind i do now

// Setup

// Supervisors
/decl/closet_appearance/secure_closet/labsupervisor
	color = "#9b2525"
	decals = list(
		"lower_holes",
		"upper_holes"
	)
	extra_decals = list(
		"stripe_vertical_left_partial" = COLOR_GOLD,
	)

// Lab Worker
/decl/closet_appearance/secure_closet/labworker
	color = "#c76bca"
	decals = list(
		"lower_holes",
		"upper_holes"
	)
	extra_decals = list(
		"stripe_vertical_left_partial" = COLOR_GOLD,
		"stripe_vertical_right_partial" = COLOR_GOLD,
		"fo" = COLOR_GOLD
	)

// Generic Science
/decl/closet_appearance/secure_closet/labworker_generic
	color = "#b377a4"
	decals = list(
		"lower_holes",
		"upper_holes"
	)
	extra_decals = list(
		"stripe_vertical_left_partial" = COLOR_GOLD,
		"stripe_vertical_right_partial" = COLOR_GOLD,
		"fo" = COLOR_GOLD
	)

// Setup

/obj/structure/closet/secure_closet/supervisor
	name = "laboratory supervisor's closet"
	req_access = list()
	closet_appearance = /decl/closet_appearance/secure_closet/labsupervisor

/obj/structure/closet/secure_closet/labworker
	name = "labratory worker closet"
	req_access = list(access_)
	closet_appearance = /decl/closet_appearance/secure_closet/labworker

/obj/structure/closet/labworker_generic
	name = "labratory closet"
	req_access = list(access_)
	closet_appearance = /decl/closet_appearance/closet/labworker_generic


// Weapons:

/obj/weapon/projectile/bullet/pistol/lab_pistol // Change this later.
	name = ""			// Find a decent name, do icons, etc.
	desc = "A pistol well known for being used by criminal elements, for it's cheap cost and reliability. Uses .45 rounds"
	icon = ''
	icon_state = ''
	item_icons = URIST_ALL_ONMOBS
	wielded_item_state = ""
	w_class = ITEM_SIZE_SMALL
	load_method = MAGAZINE
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 2, TECH_ILLEGAL = 1)
	slot_flags = list(SLOT_BELT, SLOT_POCKET) // Make sure this works.
	ammo_type = /obk/item/ammo_casing/c45
	// Allowed Magazines - allowed_magazines
	// Magazine Type - magazine_type

// Spawners

// Shimmering Orbs.

/obj/effect/spawner/structure/shimmeringorb
	var/obj/structure/flora/shimmering_orb/H

/obj/effect/spawner/structure/shimmeringorb/Initialize()
	. = ..()
	if (rand(0, 3) == 0)
		H = new/obj/structure/flora/shimmering_orb/(loc)

// Chemical Spawner
/*

Note Making for Now...


/obj/effect/spawner/structure/chem_shelf
	var/obj/structure/chem_shelf/H

/obj/effect/spawner/structure/chem_shelf/Initialize()
	. = ..()


Banned Chemicals ---
/datum/reagent/adminordrazine - Everything else is free game. Round-ending, or incredibly insane OP stuff will have a tiny chance to spawn.


Modify Values
/datum/reagent/water/holywater,
/datum/reagent/chloralhydrate/beer2
/datum/reagent/toxin/fertilizer
/datum/reagent/xenomicrobes/uristzombie   --- SUPER RARE
/datum/reagent/toxin/zombie -- SUPER RARE
/datum/reagent/hell_water



*/

