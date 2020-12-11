// IFF Halper Jobs -
// Killing prisoners would lead to them failing their objectives.

/datum/job/submap/halper_warden
	title = "Prisoner Warden"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/halper/warden
	supervisors = "yourself"
	info = "Your vessel was recently attacked by UHA rebels, while you managed to fend them off, your vessel's engines  \
	were comprimised. You need to gather your crew and fix the damage, in order to make it back with your prisoners \
	at a nearby Terran outpost for processing, make sure that your prisoners arrive alive and well."

/datum/job/submap/halper_officer
	title = "Prisoner Officer"
	supervisors = "the Warden"
	total_positions = 2
	outfit_type = /decl/hierarchy/outfit/job/halper/officer
	info = "Your vessel has been cripplied by a recent UHA rebel attack, in an attempt to free the prisoners you have. \
	You need to work together with the Warden, repair the damage to the vessel and ensure that the prisoners make it \
	alive and well, or you'll face severe reprocussions."

/datum/job/submap/halper_prisoner
	title = "Prisoner"
	supervisors = "nobody"
	total_positions = 3
	outfit_type = /decl/hierachy/outfit/job/halper/prisoner
	info = "You are being transported to a nearby Terran prisoner port for processing, for your crimes of /CRIME/. \
	It's up to you to face the punishment of your actions, or rise up and take over the vessel, or escape using the \
	nearby shuttle. Remember, your cell may have hidden elements inside that could better your chances of escape..."

#define HALPER_OUTFIT_JOB_NAME(job_name) ("Halper - Job - " + job_name)
#define HALPER_CRIME(halper_crime) (CRIME_STATUS)

// Crimes:  Given crimes are usually major crimes, avoiding the usual no-no stuff. The people on this ship are /not/ good people, and this opens roleplay and
//ship - to - ship dynamics if they are rescued, or escape.

// First Degree Murder		Drug Trafficking		Hijacking			Bank Robbery		Espionage				Treason		Political Prisoner
// Assasination				Conspiracy				Piracy				Coercion			War Crimes				Torture		
// Fraud					Terrorism				Embezzlement		Hacking				Money Laundering		Marooning
// Genocide					Identity Theft			Grand Sabotage		Grant Theft			Smuggling				Extortion

/decl/hierarchy/outfit/job/halper
	hierarchy_type = /decl/hierarchy/outfit/job/halper
	pda_type = /obj/item/modular_computer/pda
	pda_slot = slot_l_store
	r_pocket = /obj/item/device/radio
	l_ear = null
	r_ear = null

/decl/hierarchy/outfit/job/halper/halper_officer
	name = HALPER_OUTFIT_JOB_NAME("Officer")
	id_type = /obj/item/weapon/card/id/halper

/decl/hierarchy/outfit/job/halper/halper_warden
	name = HALPER_OUTFIT_JOB_NAME("Warden")
	shoes = /obj/item/clothing/shoes/black

#undef BEARCAT_OUTFIT_JOB_NAME

/obj/effect/submap_landmark/spawnpoint/warden
	name = "Halper Warden"

/obj/effect/submap_landmark/spawnpoint/crewman
	name = "Halper Officer"

/obj/effect/submap_landmark/spawnpoint/prisoner
	name = "Halper Prisoner"
