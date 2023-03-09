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


// Add Envelope Shit here.

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
