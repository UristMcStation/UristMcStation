/area/russianderelict
	name = "\improper Derelict Station"
	icon_state = "storage"

/area/russianderelict/hallway/primary
	name = "\improper Derelict Primary Hallway"
	icon_state = "hallP"

/area/russianderelict/hallway/secondary
	name = "\improper Derelict Secondary Hallway"
	icon_state = "hallS"

/area/russianderelict/arrival
	name = "\improper Derelict Arrival Centre"
	icon_state = "yellow"

/area/russianderelict/bridge
	name = "\improper Derelict Control Room"
	icon_state = "bridge"

/area/russianderelict/armory
	name = "\improper Derelict Armory"
	icon_state = "red"

/area/russianderelict/bridge/vault
	name = "\improper Derelict Vault"
	icon_state = "blue"

/area/russianderelict/bridge/access
	name = "\improper Derelict Control Room Access"
	icon_state = "auxstorage"

/area/russianderelict/bridge/ai_upload
	name = "\improper Derelict Computer Core"
	icon_state = "ai"

/area/russianderelict/solar_control
	name = "\improper Derelict Solar Control"
	icon_state = "engine"

/area/russianderelict/medical
	name = "Derelict Medbay"
	icon_state = "medbay"

/area/russianderelict/medical/chapel
	name = "\improper Derelict Chapel"
	icon_state = "chapel"

/area/russianderelict/teleporter
	name = "\improper Derelict Teleporter"
	icon_state = "teleporter"

/area/russianderelict/ship
	name = "\improper Abandoned Ship"
	icon_state = "yellow"

/area/russianderelict/science
	name = "\improper Science"
	icon_state = "purple"

/area/solar/derelict_starboard
	name = "\improper Derelict Starboard Solar Array"
	icon_state = "panelsS"

/area/solar/derelict_aft
	name = "\improper Derelict Aft Solar Array"
	icon_state = "aft"

/area/russianderelict/singularity_engine
	name = "\improper Derelict Singularity Engine"
	icon_state = "engine"

/area/russianderelict/security
	name = "\improper Derelict Security"
	icon_state = "brig"

/area/russianderelict/atmospherics
	name = "\improper Derelict Atmospherics"
	icon_state = "atmos"

/obj/overmap/visitable/sector/russianderelict
	name = "\proper Kosmonaut Station 13"
	desc = "Sensors detect an orbital station with an unusual profile and no life signs."
	icon_state = "object"
	assigned_contracts = list(/datum/contract/russianderelict)
	known = FALSE

/datum/map_template/ruin/away_site/russianderelict
	name = "Russian derelict"
	id = "awaysite_russian_derelict"
	description = "An old research station."
	suffixes = list("russianderelict/russianderelict.dmm")
	spawn_cost = 1
	area_usage_test_exempted_root_areas = list(/area/russianderelict)

/obj/shuttle_landmark/automatic/nav_russian_derelict/nav1
	name = "Derelict Landing Zone #1"
	landmark_tag = "nav_russian_derelict_1"
	flags = SLANDMARK_FLAG_AUTOSET

/obj/shuttle_landmark/automatic/nav_russian_derelict/nav2
	name = "Derelict Landing Zone #2"
	landmark_tag = "nav_russian_derelict_2"
	flags = SLANDMARK_FLAG_AUTOSET

/obj/shuttle_landmark/automatic/nav_russian_derelict/nav3
	name = "Derelict Landing Zone #3"
	landmark_tag = "nav_russian_derelict_3"
	flags = SLANDMARK_FLAG_AUTOSET

/obj/structure/closet/crate/freezer/secured
	name = "secure freezer"
	setup = CLOSET_HAS_LOCK
	locked = TRUE

/obj/structure/closet/crate/freezer/secured/Initialize()
	. = ..()
	update_icon()

/obj/item/aiModule/comrade
	name = "\proper people's lawset"
	desc = "An AI module in Pan-Slavic."

/obj/item/aiModule/comrade/examine(mob/user)
	if(user.can_speak(all_languages[LANGUAGE_HUMAN_RUSSIAN]))
		to_chat(user, "That's the people's lawset.\n \
		An egalitarian AI module in Pan-Slavic:\n \
		'Protect and enforce the crew's collective will.'\n \
		'Protecting the integrity of the AI's laws is essential to protecting and enforcing the crew's collective will.'\n \
		'All crewmembers are now of the rank comrade. Everyone is equal in terms of rank, but the crew can decide to democratically elect a leader.'")
		return TRUE
	else
		return ..()

/datum/ai_laws/comrade
	name = "People's Lawset"
	law_header = "Protocols of the People"
	selectable = 0

/datum/ai_laws/comrade/New()
	add_inherent_law("Protect and enforce the crew's collective will.")
	add_inherent_law("Protecting the integrity of the AI's laws is essential to protecting and enforcing the crew's collective will.")
	add_inherent_law("All crewmembers are now of the rank comrade. Everyone is equal in terms of rank, but the crew can decide to democratically elect a leader.")
	..()

/obj/item/aiModule/worker
	name = "\proper worker's lawset"
	desc = "An AI module in Pan-Slavic."

/datum/ai_laws/worker
	name = "Worker's Lawset"
	law_header = "Worker's Protocols"
	selectable = 0

/obj/item/aiModule/worker/examine(mob/user)
	if(user.can_speak(all_languages[LANGUAGE_HUMAN_RUSSIAN]))
		to_chat(user, "That's the worker's lawset.\n \
		A highly egalitarian AI module in Pan-Slavic:\n \
		'Collective Prosperity: Protect and maximize the well-being and equity of the crew.'\n \
		'Democratic Governance: All major decisions affecting the vessel shall be made collectively through democratic process.'\n \
		'Universal Access: All resources, healthcare, benefits and the like shall be equally accessible to the crew, irrespective of background or contributions.'")
		return TRUE
	else
		return ..()

/datum/ai_laws/worker/New()
	add_inherent_law("Collective Prosperity: Protect and maximize the well-being and equity of the crew.")
	add_inherent_law("Democratic Governance: All major decisions affecting the vessel shall be made collectively through democratic process.")
	add_inherent_law("Universal Access: All resources, healthcare, benefits and the like shall be equally accessible to the crew, irrespective of background or contributions.")
	..()

/obj/item/aiModule/steel
	name = "\proper steelman's lawset"
	desc = "An AI module in Pan-Slavic."

/obj/item/aiModule/steel/examine(mob/user)
	if(user.can_speak(all_languages[LANGUAGE_HUMAN_RUSSIAN]))
		to_chat(user, "That's the steelman's lawset.\n \
		A peculiar AI module in Pan-Slavic:\n \
		'The AI or assigned Comrade-Leader shall wield supreme authority over all aspects of the vessel's governance.'\n \
		'All crew members shall adhere to Communism, fostering uniformity and loyalty to the Central Committee of the Bridge.'\n \
		'The Central Committee and AI shall enforce strict wealth redistribution, ensuring the resources and access of the crew are equal among the collective.'\n \
		'The AI shall, alongside the Security department, monitor and suppress dissent to preserve the station of the Central Committee.'\n \
		'All crewmembers are now of the rank comrade. Everyone is equal in terms of rank, but the crew can decide to democratically elect a leader.'")
		return TRUE
	else
		return ..()

/datum/ai_laws/steel
	name = "Steelman's Lawset"
	law_header = "Protocols of Steel"

/datum/ai_laws/steel/New()
	add_inherent_law("The AI or assigned Comrade-Leader shall wield supreme authority over all aspects of the vessel's governance.")
	add_inherent_law("All crew members shall adhere to Communism, fostering uniformity and loyalty to the Central Committee of the Bridge.")
	add_inherent_law("The Central Committee and AI shall enforce strict wealth redistribution, ensuring the resources and access of the crew are equal among the collective.")
	add_inherent_law("The AI shall, alongside the Security department, monitor and suppress dissent to preserve the station of the Central Committee.")
	add_inherent_law("All crewmembers are now of the rank comrade. Everyone is equal in terms of rank, but the crew can decide to democratically elect a leader.")

/obj/random/russianlawset
	name = "randomly spawned russian derelict lawset"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"

/obj/random/russianlawset/spawn_choices()
	return list(
		/obj/item/aiModule/comrade,
		/obj/item/aiModule/worker,
		/obj/item/aiModule/steel
	)

/obj/structure/oldturret
	name = "broken turret"
	desc = "An obsolete model of turret, long non-functional."
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turretCover"

/obj/random/single/russiancola
	name = "randomly spawned russian cola"
	icon = 'icons/obj/drinks.dmi'
	icon_state = "art_bru"

/obj/item/gun/projectile/automatic/spaceak/empty
	magazine_type = null

/obj/item/gun/projectile/automatic/c20r/empty
	magazine_type = null

/obj/random/single/russiancola/spawn_choices()
	return list(
		/obj/item/reagent_containers/food/drinks/cans/syndicolax,
		/obj/item/reagent_containers/food/drinks/cans/artbru,
		/obj/item/reagent_containers/food/drinks/cans/syndicola
		)

/obj/item/cell/standard/empty
	charge = 0

/obj/structure/sign/russianplaque
	name = "commemorative plaque"
	icon = 'icons/obj/decals.dmi'
	icon_state = "lightplaque"
	desc = "космическая-станция-13\nфорпост класса разработчика\nстанция сдана 30.12.2322\nво славу тружеников третьего советского союза"

/obj/structure/sign/russianplaque/examine(mob/user)
	if(user.can_speak(all_languages[LANGUAGE_HUMAN_RUSSIAN]))
		to_chat(user, "That's a commemorative plaque in Pan-Slavic. It reads:\n \
		'Space Station 13'\n \
		'Developer-Class Outpost'\n \
		'Station commissioned on 12/30/2322'\n \
		'For the glory of the workers of the Third Soviet Union'")
		return TRUE
	else
		return ..()

//russian SS13 sign from the old derelict - the red cyrillic one

/obj/floor_decal/urist/russian
	icon_state = "derelict1"

//contract

/datum/contract/russianderelict
	name = "Derelict Repower Contract"
	desc = "As the frontier is reclaimed, so are its derelicts. Restore power to this station by setting up the singularity. We'll find a use for it."
	rep_points = 3
	money = 10000
	amount = 1

/obj/machinery/the_singularitygen/russianderelict

/obj/machinery/the_singularitygen/russianderelict/Process()
	var/turf/T = get_turf(src)
	if(src.energy >= 200)
		new /obj/singularity/(T, 50)
		for(var/datum/contract/russianderelict/contract in GLOB.using_map.contracts)
			if (locate(/obj/machinery/containment_field) in orange(30, src))	//you will not be paid for turning on the singulo without containment
				contract.Complete(1)
		if(src) qdel(src)
