
/area/shuttle/merchant
	icon_state = "shuttlegrn"

/area/shuttle/merchant/home
	name = "\improper Merchant Van - Home"

/datum/map/glloydstation
	post_round_safe_areas = list (
		/area/centcom,
		/area/shuttle/escape/centcom,
		/area/shuttle/escape_pod1,
		/area/shuttle/escape_pod2,
		/area/shuttle/escape_pod3,
		/area/shuttle/escape_pod5,
		/area/shuttle/transport1/centcom,
		/area/shuttle/administration/centcom,
		/area/shuttle/specops/centcom,
	)

////////////
//SHUTTLES//
////////////
//shuttle areas must contain at least two areas in a subgroup if you want to move a shuttle from one
//place to another. Look at escape shuttle for example.
//All shuttles should now be under shuttle since we have smooth-wall code.

/area/shuttle/merchant
	icon_state = "shuttlegrn"

/area/shuttle/merchant/home
	name = "\improper Merchant Van"

// Command
/area/crew_quarters/heads/chief
	name = "\improper Engineering - CE's Office"

/area/crew_quarters/heads/hos
	name = "\improper Security - HoS' Office"

/area/crew_quarters/heads/hop
	name = "\improper Command - HoP's Office"

/area/crew_quarters/heads/hor
	name = "\improper Research - RD's Office"

/area/crew_quarters/heads/cmo
	name = "\improper Command - CMO's Office"

// Shuttles

/area/shuttle/constructionsite
	name = "\improper Construction Site Shuttle"
	icon_state = "yellow"

/area/shuttle/constructionsite/station
	name = "\improper Construction Site Shuttle"
	base_turf = null

/area/shuttle/mining
	name = "\improper Mining Shuttle"

/area/shuttle/mining/station
	icon_state = "shuttle2"
	base_turf = null

/area/shuttle/specops/centcom
	name = "\improper Special Ops Shuttle"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/shuttle/administration
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/shuttle/syndicate_elite
	name = "\improper Merc Elite Shuttle"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/shuttle/transport1/centcom
	icon_state = "shuttle"
	name = "\improper Transport Shuttle Centcom"

/area/shuttle/arrivals
	name = "\improper Arrival Shuttle"

/area/shuttle/arrivals/centcom
	name = "\improper Arrival Shuttle CentComm"
	icon_state = "shuttle"

/area/shuttle/escape
	name = "\improper Emergency Shuttle"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/shuttle/escape_pod1
	name = "\improper Escape Pod One"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/shuttle/escape_pod1/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod2
	name = "\improper Escape Pod Two"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/shuttle/escape_pod2/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod3
	name = "\improper Escape Pod Three"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/shuttle/escape_pod3/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod5 //Pod 4 was lost to meteors
	name = "\improper Escape Pod Five"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/shuttle/escape_pod5/station
	icon_state = "shuttle2"

/area/shuttle/administration/centcom
	name = "\improper Administration Shuttle"
	icon_state = "shuttlered"

/area/supply/dock
	name = "Supply Shuttle"
	icon_state = "shuttle3"
	requires_power = 0

// Elevators
/area/shuttle/elevator
	dynamic_lighting = 0

/area/shuttle/elevator/mining/surface
	name = "\improper Mining Elevator"
	icon_state = "shuttle"

/area/shuttle/elevator/research/surface
	name = "\improper Research Elevator"
	icon_state = "shuttle"

// === Trying to remove these areas:

/area/shuttle/research
	name = "\improper Research Shuttle"
	base_turf = null

/area/shuttle/research/station
	icon_state = "shuttle2"

/area/shuttle/planet
	name = "\improper Planet Outpost Shuttle"
	base_turf = null

/area/shuttle/planet/station
	icon_state = "shuttle"

//SYNDICATES

/area/map_template/syndicate_mothership
	name = "\improper Mercenary Base"
	icon_state = "syndie-ship"
	requires_power = 0
	dynamic_lighting = 0
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/map_template/syndicate_mothership/ninja
	name = "\improper Ninja Base"

//RESCUE

//names are used
/area/rescue_base
	name = "\improper Response Team Base"
	icon_state = "yellow"
	requires_power = 0
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/rescue_base/base
	name = "\improper Barracks"
	icon_state = "yellow"
	dynamic_lighting = 0

/area/rescue_base/start
	name = "\improper Response Team Base"
	icon_state = "shuttlered"
	base_turf = /turf/unsimulated/floor/rescue_base

/area/rescue_base/southwest
	name = "south-west of SS13"
	icon_state = "southwest"

/area/rescue_base/northwest
	name = "north-west of SS13"
	icon_state = "northwest"

/area/rescue_base/northeast
	name = "north-east of SS13"
	icon_state = "northeast"

/area/rescue_base/southeast
	name = "south-east of SS13"
	icon_state = "southeast"

/area/rescue_base/north
	name = "north of SS13"
	icon_state = "north"

/area/rescue_base/south
	name = "south of SS13"
	icon_state = "south"

/area/rescue_base/commssat
	name = "west of the communication satellite"
	icon_state = "west"

/area/rescue_base/mining
	name = "northeast of the engineering station"
	icon_state = "northeast"
	base_turf = /turf/simulated/floor/planet/jungle/clear

/area/rescue_base/arrivals_dock
	name = "docked with station"
	icon_state = "shuttle"

/area/rescue_base/transit
	name = "\proper bluespace"
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north

//ENEMY

//names are used
/area/syndicate_station
	name = "\improper Independant Station"
	icon_state = "yellow"
	requires_power = 0
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/syndicate_station/start
	name = "\improper Mercenary Forward Operating Base"
	icon_state = "yellow"
/*
/area/syndicate_station/southwest
	name = "south-west of SS13"
	icon_state = "southwest"

/area/syndicate_station/northwest
	name = "north-west of SS13"
	icon_state = "northwest"

/area/syndicate_station/northeast
	name = "north-east of SS13"
	icon_state = "northeast"

/area/syndicate_station/southeast
	name = "south-east of SS13"
	icon_state = "southeast"

/area/syndicate_station/north
	name = "north of SS13"
	icon_state = "north"

/area/syndicate_station/south
	name = "south of SS13"
	icon_state = "south"

/area/syndicate_station/commssat
	name = "south of the communication satellite"
	icon_state = "south"

/area/syndicate_station/mining
	name = "northeast of the mining station"
	icon_state = "north"
	base_turf = /turf/simulated/floor/planet/jungle/clear

/area/syndicate_station/transit
	name = "\proper bluespace"
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north
*/
/area/skipjack_station
	name = "\improper Skipjack"
	icon_state = "yellow"
	requires_power = 0
	area_flags = AREA_FLAG_RAD_SHIELDED
/*
/area/skipjack_station/transit
	name = "\proper bluespace"
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north

/area/skipjack_station/southwest_solars
	name = "aft port solars"
	icon_state = "southwest"

/area/skipjack_station/northwest_solars
	name = "fore port solars"
	icon_state = "northwest"

/area/skipjack_station/northeast_solars
	name = "fore starboard solars"
	icon_state = "northeast"

/area/skipjack_station/southeast_solars
	name = "aft starboard solars"
	icon_state = "southeast"

/area/skipjack_station/mining
	name = "south of mining station"
	icon_state = "north"
	base_turf = /turf/simulated/floor/planet/jungle/clear //These have been rendered useless by new shuttle code, leaving here for reference -Vak
*/

// Maintenance

/area/maintenance/atmos_control
	name = "\improper Atmospherics Maintenance"
	icon_state = "fpmaint"

/area/maintenance/bar
	name = "\improper Bar Maintenance"
	icon_state = "maint_bar"

/area/maintenance/kitchen
	name = "\improper Kitchen Maintenance"
	icon_state = "maint_bar"

/area/maintenance/cargo
	name = "\improper Cargo Maintenance"
	icon_state = "maint_cargo"

/area/maintenance/engineering
	name = "\improper Engineering Maintenance"
	icon_state = "maint_engineering"

/area/maintenance/evahallway
	name = "\improper EVA Maintenance"
	icon_state = "maint_eva"

/area/maintenance/library
	name = "\improper Library Maintenance"
	icon_state = "maint_library"

/area/maintenance/locker
	name = "\improper Locker Room Maintenance"
	icon_state = "maint_locker"

/area/maintenance/medbay
	name = "\improper Medbay Maintenance"
	icon_state = "maint_medbay"

/area/maintenance/exterior
	name = "\improper Exterior Reinforcements"
	icon_state = "maint_security_starboard"

// Dank Maintenance

/area/maintenance
	forced_ambience = list('sound/urist/ambience/ambimaint1.ogg','sound/urist/ambience/ambimaint2.ogg','sound/urist/ambience/ambimaint3.ogg','sound/urist/ambience/ambimaint4.ogg','sound/urist/ambience/ambimaint5.ogg',)

/*
/area/maintenance/sub
	turf_initializer = /singleton/turf_initializer/maintenance/heavy
	ambience = list(
		'sound/ambience/ambiatm1.ogg',
		'sound/ambience/ambigen3.ogg',
		'sound/ambience/ambigen4.ogg',
		'sound/ambience/ambigen5.ogg',
		'sound/ambience/ambigen6.ogg',
		'sound/ambience/ambigen7.ogg',
		'sound/ambience/ambigen8.ogg',
		'sound/ambience/ambigen9.ogg',
		'sound/ambience/ambigen10.ogg',
		'sound/ambience/ambigen11.ogg',
		'sound/ambience/ambigen12.ogg',
		'sound/ambience/ambimine.ogg',
		'sound/ambience/ambimo2.ogg',
		'sound/ambience/ambisin4.ogg',
		'sound/effects/wind/wind_2_1.ogg',
		'sound/effects/wind/wind_2_2.ogg',
		'sound/effects/wind/wind_3_1.ogg',
	)*/

// Hallway

/area/hallway/primary
	sound_env = LARGE_ENCLOSED

/area/hallway/primary/fore
	name = "\improper Fore Primary Hallway"
	icon_state = "hallF"

/area/hallway/primary/starboard
	name = "\improper Starboard Primary Hallway"
	icon_state = "hallS"

/area/hallway/primary/aft
	name = "\improper Aft Primary Hallway"
	icon_state = "hallA"

/area/hallway/primary/port
	name = "\improper Port Primary Hallway"
	icon_state = "hallP"

/area/hallway/primary/central_one
	name = "\improper Central Primary Hallway"
	icon_state = "hallC1"

/area/hallway/secondary/exit
	name = "\improper Escape Shuttle Hallway"
	icon_state = "escape"

/area/hallway/secondary/entry
	name = "\improper Arrival Shuttle Hallway"
	icon_state = "entry_1"

// Command

/area/crew_quarters/captain
	name = "\improper Command - Captain's Office"
	icon_state = "captain"
	sound_env = MEDIUM_SOFTFLOOR

/area/command
	req_access = list(access_bridge)
	icon_state = "heads"
/area/command/ce
	name = "\improper Chief Engineer's Office"
	icon_state = "heads_ce"

/area/command/cmo
	name = "\improper Chief Medical Officer's Office"
	icon_state = "heads_cmo"

/area/command/rd
	name = "\improper Research Director's Office"
	icon_state = "heads_rd"

/area/command/hos
	name = "\improper Head of Security's Office"
	icon_state = "heads_hos"

/area/command/hop
	name = "\improper Head of Personnel's Office"
	icon_state = "heads_hop"

/area/command/quarters
	name = "\improper Command Quarters"
	icon_state = "heads"
	area_flags = AREA_FLAG_RAD_SHIELDED

// Crew

/area/crew_quarters
	name = "\improper Dormitories"
	icon_state = "Sleep"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/crew_quarters/locker
	name = "\improper Locker Room"
	icon_state = "locker"

/area/crew_quarters/toilet
	name = "\improper Dormitory Toilets"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/crew_quarters/sleeping
	name = "\improper Dormitories"
	icon_state = "Sleep"

/area/crew_quarters/locker/locker_toilet
	name = "\improper Locker Toilets"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/crew_quarters/fitness
	name = "\improper Fitness Room"
	icon_state = "fitness"

/area/crew_quarters/kitchen
	name = "\improper Kitchen"
	icon_state = "kitchen"

/area/crew_quarters/bar
	name = "\improper Bar"
	icon_state = "bar"
	sound_env = LARGE_SOFTFLOOR

/area/library
 	name = "\improper Library"
 	icon_state = "library"
 	sound_env = LARGE_SOFTFLOOR

/area/chapel/office
	name = "\improper Chapel Office"
	icon_state = "chapeloffice"

/area/lawoffice
	name = "\improper Internal Affairs"
	icon_state = "law"

//Engineering

/area/engineering
	name = "\improper Engineering"
	icon_state = "engineering"
	ambience = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg','sound/ambience/ambisin4.ogg')

/area/engineering/engine_airlock
	name = "\improper Engine Room Airlock"
	icon_state = "engine"

/area/engineering/engine_waste
	name = "\improper Engine Waste Handling"
	icon_state = "engine_waste"

/area/engineering/break_room
	name = "\improper Engineering Break Room"
	icon_state = "engineering_break"
	sound_env = MEDIUM_SOFTFLOOR

/area/engineering/singulo
	name = "\improper Engineering Singularity"
	icon_state = "engineering_workshop"

// Medbay
/area/medical/storage
	name = "\improper Medical Storage"
	icon_state = "medbay4"

/area/medical/genetics
	name = "\improper Genetics Lab"
	icon_state = "genetics"

/area/medical/genetics_cloning
	name = "\improper Cloning Lab"
	icon_state = "cloning"

/area/medical/psychoffice
	name = "\improper Psychologist's Office"
	icon_state = "medbay3"

/area/medical/biostorage
	name = "\improper Secondary Storage"
	icon_state = "medbay4"
	ambience = list('sound/ambience/signal.ogg')

/area/medical/chemistry
	name = "\improper Chemistry"
	icon_state = "chem"

/area/medical/exam_room
	name = "\improper Exam Room"
	icon_state = "exam_room"

/area/medical/morgue
	name = "\improper Morgue"
	icon_state = "morgue"
	ambience = list('sound/ambience/ambimo1.ogg','sound/ambience/ambimo2.ogg','sound/music/main.ogg')

/area/medical/sleeper
	name = "\improper Emergency Treatment Centre"
	icon_state = "exam_room"

/area/medical/surgery
	name = "\improper Operating Theatre"
	icon_state = "surgery"

/area/medical/lounge
	name = "\improper Medbay Lounge"
	icon_state = "medbay2"

/area/medical/medbay
	name = "\improper Medbay Hallway - Port"
	icon_state = "medbay"
	ambience = list('sound/ambience/signal.ogg')

/area/medical/medbay2
	name = "\improper Medbay Hallway - Starboard"
	icon_state = "medbay2"
	ambience = list('sound/ambience/signal.ogg')

/area/medical/reception
	name = "\improper Medbay Reception"
	icon_state = "medbay"
	ambience = list('sound/ambience/signal.ogg')

/area/medical/patient_wing
	name = "\improper Patient Wing"
	icon_state = "patients"

/area/medical/patient_a
	name = "\improper Isolation A"
	icon_state = "patients"

/area/medical/patient_b
	name = "\improper Isolation B"
	icon_state = "patients"

/area/medical/patient_c
	name = "\improper Isolation C"
	icon_state = "patients"

/area/medical/surgeryobs
	name = "\improper Operation Observation Room"
	icon_state = "surgery"

/area/medical/surgeryprep
	name = "\improper Pre-Op Prep Room"
	icon_state = "surgery"

/area/medical/surgery2
	name = "\improper Operating Theatre 2"
	icon_state = "surgery"

/area/medical/cryo
	name = "\improper Cryogenics"
	icon_state = "cryo"

// Solars

/area/solar/starboard
	name = "\improper Starboard Auxiliary Solar Array"
	icon_state = "panelsS"

/area/solar/auxport
	name = "\improper Fore Port Solar Array"
	icon_state = "panelsA"

/area/solar/fore
	name = "\improper Fore Solar Array"
	icon_state = "yellow"

/area/maintenance/foresolar
	name = "\improper Solar Maintenance - Fore"
	icon_state = "SolarcontrolA"
	sound_env = SMALL_ENCLOSED

/area/maintenance/portsolar
	name = "\improper Solar Maintenance - Aft Port"
	icon_state = "SolarcontrolP"
	sound_env = SMALL_ENCLOSED

/area/maintenance/starboardsolar
	name = "\improper Solar Maintenance - Aft Starboard"
	icon_state = "SolarcontrolS"
	sound_env = SMALL_ENCLOSED

//Teleporter

/area/teleporter
	name = "\improper Teleporter"
	icon_state = "teleporter"

/area/gateway
	name = "\improper Gateway"
	icon_state = "teleporter"

//Security

/area/security/main
	name = "\improper Security Office"
	icon_state = "security"
/*
/area/security/brig/prison_break()
	for(var/obj/structure/closet/secure_closet/brig/temp_closet in src)
		temp_closet.locked = 0
		temp_closet.icon_state = temp_closet.icon_closed
	for(var/obj/machinery/door_timer/temp_timer in src)
		temp_timer.releasetime = 1
	..()

/area/security/prison/prison_break()
	for(var/obj/structure/closet/secure_closet/brig/temp_closet in src)
		temp_closet.locked = 0
		temp_closet.icon_state = temp_closet.icon_closed
	for(var/obj/machinery/door_timer/temp_timer in src)
		temp_timer.releasetime = 1
	..()
*/
/area/security/warden
	name = "\improper Security - Warden's Office"
	icon_state = "Warden"

/area/security/vacantoffice
	name = "\improper Vacant Office"
	icon_state = "security"

/area/quartermaster
	name = "\improper Quartermasters"
	icon_state = "quart"

/area/quartermaster/storage
	name = "\improper Warehouse"
	icon_state = "quartstorage"
	sound_env = LARGE_ENCLOSED

/area/quartermaster/qm
	name = "\improper Cargo - Quartermaster's Office"
	icon_state = "quart"

/area/quartermaster/miningdock
	name = "\improper Cargo Mining Dock"
	icon_state = "mining"

/area/rnd/mixing
	name = "\improper Toxins Mixing Room"
	icon_state = "toxmix"

/area/rnd/storage
	name = "\improper Toxins Storage"
	icon_state = "toxstorage"

/area/rnd/test_area
	name = "\improper Toxins Test Area"
	icon_state = "toxtest"

/area/rnd/server
	name = "\improper Research Server Room"
	icon_state = "server"

/area/rnd/electrical_engineering
	name = "\improper Electrical Engineering Lab"
	icon_state = "toxlab"

/area/rnd/breakroom
	name = "\improper Research Break Room"
	icon_state = "research"

//Storage

/area/storage/art
	name = "Art Supply Storage"
	icon_state = "storage"

/area/storage/emergency
	name = "Starboard Emergency Storage"
	icon_state = "emergencystorage"

/area/storage/emergency2
	name = "Port Emergency Storage"
	icon_state = "emergencystorage"

//HALF-BUILT STATION (REPLACES DERELICT IN BAYCODE, ABOVE IS LEFT FOR DOWNSTREAM)

/area/shuttle/constructionsite/site
	name = "\improper Construction Site Shuttle"
	base_turf = /turf/simulated/floor/plating

/*******
* Moon *
*******/

// Mining main outpost

/area/outpost/mining_main
	icon_state = "outpost_mine_main"
	base_turf = /turf/simulated/floor/planet/jungle/clear

/area/outpost/mining_main/eva
	name = "Mining Outpost EVA storage"

/area/outpost/mining_main/dorms
	name = "Mining Outpost Dormitory"

/area/outpost/mining_main/refinery
	name = "Mining Outpost Refinery"

// Mining outpost
/area/outpost/mining_main/maintenance
	name = "Mining Outpost Maintenance"

/area/outpost/mining_main/hallway
	name = "Mining Outpost Hallway"

/area/outpost/mining_main/medbay
	name = "Mining Outpost Medbay"

// Engineering outpost

/area/outpost/engineering
	icon_state = "outpost_engine"

/area/outpost/engineering/hallway
	name = "Engineering Outpost Hallway"

/area/outpost/engineering/power
	name = "Engineering Outpost Power Distribution"

/area/outpost/engineering/storage
	name = "Engineering Outpost Storage"

// Research Outpost
/area/outpost/research
	icon_state = "outpost_research"

/area/outpost/research/hallway
	name = "Research Outpost Hallway"

/area/outpost/research/dock
	name = "Research Outpost Shuttle Dock"

/area/outpost/research/eva
	name = "Research Outpost EVA"

/area/outpost/research/analysis
	name = "Research Outpost Sample Analysis"

/area/outpost/research/chemistry
	name = "Research Outpost Chemistry"

/area/outpost/research/medical
	name = "Research Outpost Medical"

/area/outpost/research/power
	name = "Research Outpost Maintenance"

/area/outpost/research/isolation_a
	name = "Research Outpost Isolation A"

/area/outpost/research/isolation_b
	name = "Research Outpost Isolation B"

/area/outpost/research/isolation_c
	name = "Research Outpost Isolation C"

/area/outpost/research/isolation_monitoring
	name = "Research Outpost Isolation Monitoring"

/area/outpost/research/lab
	name = "Research Outpost Laboratory"

/area/outpost/research/emergency_storage
	name = "Research Outpost Emergency Storage"

/area/outpost/research/anomaly_storage
	name = "Research Outpost Anomalous Storage"

/area/outpost/research/anomaly_analysis
	name = "Research Outpost Anomaly Analysis"

// Security Outpost

/area/shuttle/securityoutpost
	icon_state = "shuttle"

/area/shuttle/securityoutpost/station
	name = "\improper Security Outpost Shuttle Station"
	base_turf = null

/area/outpost/security
	icon_state = "security"

/area/outpost/security/hallway
	name = "\improper Security Outpost Hallway"

/area/outpost/security/lounge
	name = "\improper Security Outpost Lounge"
	icon_state = "checkpoint1"

/area/outpost/security/storage
	name = "\improper Security Outpost Storage"
	icon_state = "storage"

// Maintenance

/area/maintenance/aft
	name = "Aft Maintenance"
	icon_state = "amaint"

/area/maintenance/fore
	name = "Fore Maintenance"
	icon_state = "fmaint"

/area/maintenance/atmos_control
	name = "Atmospherics Maintenance"
	icon_state = "fpmaint"

/area/maintenance/fpmaint
	name = "Fore Port Maintenance - 1"
	icon_state = "fpmaint"

/area/maintenance/fsmaint
	name = "Fore Starboard Maintenance - 1"
	icon_state = "fsmaint"

/area/maintenance/asmaint
	name = "Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/maintenance/asmaint2
	name = "Science Maintenance"
	icon_state = "asmaint"

/area/maintenance/apmaint
	name = "Cargo Maintenance"
	icon_state = "apmaint"

/area/maintenance/maintcentral
	name = "Bridge Maintenance"
	icon_state = "maintcentral"

/area/maintenance/bar
	name = "Bar Maintenance"
	icon_state = "maint_bar"

/area/maintenance/cargo
	name = "Cargo Maintenance"
	icon_state = "maint_cargo"

/area/maintenance/disposal
	name = "Waste Disposal"
	icon_state = "disposal"

/area/maintenance/engineering
	name = "Engineering Maintenance"
	icon_state = "maint_engineering"

/area/maintenance/evahallway
	name = "\improper EVA Maintenance"
	icon_state = "maint_eva"

/area/maintenance/incinerator
	name = "\improper Incinerator"
	icon_state = "disposal"

/area/maintenance/library
	name = "Library Maintenance"
	icon_state = "maint_library"

/area/maintenance/locker
	name = "Locker Room Maintenance"
	icon_state = "maint_locker"

/area/maintenance/medbay
	name = "Medbay Maintenance"
	icon_state = "maint_medbay"

/area/hallway/primary
	sound_env = LARGE_ENCLOSED

/area/hallway/primary/fore
	name = "\improper Fore Primary Hallway"
	icon_state = "hallF"

/area/hallway/primary/starboard
	name = "\improper Starboard Primary Hallway"
	icon_state = "hallS"

/area/hallway/primary/aft
	name = "\improper Aft Primary Hallway"
	icon_state = "hallA"

/area/hallway/primary/port
	name = "\improper Port Primary Hallway"
	icon_state = "hallP"

/area/hallway/primary/central_one
	name = "\improper Central Primary Hallway"
	icon_state = "hallC1"

/area/hallway/secondary/exit
	name = "\improper Escape Shuttle Hallway"
	icon_state = "escape"

/area/crew_quarters/courtroom
	name = "\improper Courtroom"
	icon_state = "courtroom"

/area/turret_protected/aisat_interior
	name = "\improper AI Satellite Foyer"
	icon_state = "ai"

/area/turret_protected/aisat_stationside
	name = "\improper AI Satellite Station Entrance"
	icon_state = "ai"

/area/turret_protected/aisat_eva
	name = "\improper AI Satellite EVA Entrance"
	icon_state = "ai"

// Crew Quarters

/area/crew_quarters/pool
	name = "\improper Pool"
	icon_state = "bluenew"

/area/crew_quarters/lounge
	name = "\improper Lounge"
	icon_state = "lounge"

/area/crew_quarters/heads_dorms //Noble's Quarters, hehehe.
	name = "\improper Heads of Staff Dorms"
	icon_state = "head_quarters"

/area/crew_quarters/heads
	icon_state = "head_quarters"

/area/crew_quarters/cafeteria
	name = "\improper Cafeteria"
	icon_state = "cafeteria"

/area/crew_quarters/theatre
	name = "\improper Theatre"
	icon_state = "Theatre"
	sound_env = LARGE_SOFTFLOOR

/area/crew_quarters/party //needs the crewquarters before it because of gamemode code
 	name = "\improper Party Room"
 	icon_state = "yellow"

/area/crew_quarters/sleeping/sci
	name = "\improper Research Dormitories"
	icon_state = "Sleep"

/area/crew_quarters/sleeping/med
	name = "\improper Medbay Dormitories"
	icon_state = "Sleep"

/area/crew_quarters/sleeping/engi
	name = "\improper Engineering Dormitories"
	icon_state = "Sleep"

/area/crew_quarters/sleeping/sec
	name = "\improper Security Dormitories"
	icon_state = "Sleep"

//DERELICT

/area/derelict
	name = "\improper Derelict Station"
	icon_state = "storage"

/area/derelict/hallway/primary
	name = "\improper Derelict Primary Hallway"
	icon_state = "hallP"

/area/derelict/hallway/secondary
	name = "\improper Derelict Secondary Hallway"
	icon_state = "hallS"

/area/derelict/arrival
	name = "\improper Derelict Arrival Centre"
	icon_state = "yellow"

/area/derelict/bridge
	name = "\improper Derelict Control Room"
	icon_state = "bridge"

/area/derelict/armory
	name = "\improper Derelict Armory"
	icon_state = "red"

/area/derelict/bridge/access
	name = "Derelict Control Room Access"
	icon_state = "auxstorage"

/area/derelict/bridge/ai_upload
	name = "\improper Derelict Computer Core"
	icon_state = "ai"

/area/derelict/solar_control
	name = "\improper Derelict Solar Control"
	icon_state = "engine"

/area/derelict/medical
	name = "Derelict Medbay"
	icon_state = "medbay"

/area/derelict/medical/chapel
	name = "\improper Derelict Chapel"
	icon_state = "chapel"

/area/derelict/teleporter
	name = "\improper Derelict Teleporter"
	icon_state = "teleporter"

/area/derelict/ship
	name = "\improper Abandoned Ship"
	icon_state = "yellow"

/area/solar/derelict_starboard
	name = "\improper Derelict Starboard Solar Array"
	icon_state = "panelsS"

/area/solar/derelict_aft
	name = "\improper Derelict Aft Solar Array"
	icon_state = "aft"

/area/derelict/singularity_engine
	name = "\improper Derelict Singularity Engine"
	icon_state = "engine"

/area/djstation
	name = "\improper Listening Post"
	icon_state = "LP"

//Areas from the deceased shared folder
// Command

/area/bridge
	name = "\improper Bridge"
	icon_state = "bridge"

/area/bridge/meeting_room
	name = "\improper Heads of Staff Meeting Room"
	icon_state = "bridge"
	ambience = list()
	sound_env = MEDIUM_SOFTFLOOR

/area/bridge/meeting_hall
	name = "\improper Meeting Hall"
	icon_state = "bridge"

/area/bridge/blueshield
	name = "\improper Blueshield's Office"

/area/maintenance/substation
	name = "Substation"
	icon_state = "substation"
	sound_env = SMALL_ENCLOSED

/area/maintenance/exterior
	name = "\improper Exterior Reinforcements"
	icon_state = "maint_security_starboard"
	area_flags = AREA_FLAG_EXTERNAL
	has_gravity = FALSE
	turf_initializer = /singleton/turf_initializer/maintenance/space

// CentCom

/area/centcom/evac
	name = "\improper Centcom Emergency Shuttle"

/area/centcom/scom
	name = "\improper S-COM Headquarters"

/area/centcom/antag
	name = "\improper A.N.T.A.G Base"

/area/centcom/transit
	name = "\improper Centcom Transit Area"

// Solars
/area/maintenance/auxsolarport
	name = "Solar Maintenance - Port"
	icon_state = "SolarcontrolP"
	sound_env = SMALL_ENCLOSED

/area/maintenance/auxsolarstarboard
	name = "Solar Maintenance - Starboard"
	icon_state = "SolarcontrolS"
	sound_env = SMALL_ENCLOSED

/area/solar
	area_flags = AREA_FLAG_EXTERNAL
	requires_power = 1
	always_unpowered = 1
	has_gravity = FALSE
	base_turf = /turf/space

/area/solar/auxstarboard
	name = "\improper Fore Starboard Solar Array"
	icon_state = "panelsA"

/area/solar/port
	name = "\improper Port Auxiliary Solar Array"
	icon_state = "panelsP"

// Maintenance

/area/maintenance/disposal
	name = "Waste Disposal"
	icon_state = "disposal"

/area/maintenance/incinerator
	name = "\improper Incinerator"
	icon_state = "disposal"

// Storage

/area/storage/primary
	name = "Primary Tool Storage"
	icon_state = "primarystorage"

/area/storage/tech
	name = "Technical Storage"
	icon_state = "storage"

/area/storage/tools
	name = "Auxiliary Tool Storage"
	icon_state = "auxstorage"

/area/storage/emergency3
	name = "\improper Escape Emergency Storage" //Because yolo
	icon_state = "emergencystorage"

// Holodecks

/area/holodeck
	name = "\improper Holodeck"
	icon_state = "Holodeck"
	dynamic_lighting = 0
	sound_env = LARGE_ENCLOSED

/area/holodeck/alphadeck
	name = "\improper Holodeck Alpha"

/area/holodeck/source_plating
	name = "\improper Holodeck - Off"

/area/holodeck/source_emptycourt
	name = "\improper Holodeck - Empty Court"
	sound_env = ARENA

/area/holodeck/source_boxingcourt
	name = "\improper Holodeck - Boxing Court"
	sound_env = ARENA

/area/holodeck/source_basketball
	name = "\improper Holodeck - Basketball Court"
	sound_env = ARENA

/area/holodeck/source_thunderdomecourt
	name = "\improper Holodeck - Thunderdome Court"
	sound_env = ARENA

/area/holodeck/source_courtroom
	name = "\improper Holodeck - Courtroom"
	sound_env = AUDITORIUM

/area/holodeck/source_beach
	name = "\improper Holodeck - Beach"
	sound_env = PLAIN

/area/holodeck/source_wildlife
	name = "\improper Holodeck - Wildlife Simulation"

/area/holodeck/source_meetinghall
	name = "\improper Holodeck - Meeting Hall"
	sound_env = AUDITORIUM

/area/holodeck/source_theatre
	name = "\improper Holodeck - Theatre"
	sound_env = CONCERT_HALL

/area/holodeck/source_picnicarea
	name = "\improper Holodeck - Picnic Area"
	sound_env = PLAIN

/area/holodeck/source_snowfield
	name = "\improper Holodeck - Snow Field"
	sound_env = FOREST

/area/holodeck/source_desert
	name = "\improper Holodeck - Desert"
	sound_env = PLAIN

/area/holodeck/source_space
	name = "\improper Holodeck - Space"
	has_gravity = 0
	sound_env = SPACE

// Construction Site

/area/constructionsite
	name = "\improper Construction Site"
	icon_state = "storage"
	ambience = list('sound/ambience/spookyspace1.ogg', 'sound/ambience/spookyspace2.ogg')

/area/constructionsite/storage
	name = "\improper Construction Site Storage Area"

/area/constructionsite/bridge
	name = "\improper Construction Site Bridge"
	icon_state = "bridge"

/area/constructionsite/hallway/aft
	name = "\improper Construction Site Aft Hallway"
	icon_state = "hallP"

/area/constructionsite/hallway/fore
	name = "\improper Construction Site Fore Hallway"
	icon_state = "hallS"

/area/constructionsite/atmospherics
	name = "\improper Construction Site Atmospherics"
	icon_state = "green"

/area/constructionsite/medical
	name = "\improper Construction Site Medbay"
	icon_state = "medbay"

/area/constructionsite/ai
	name = "\improper Construction Computer Core"
	icon_state = "ai"

/area/constructionsite/engineering
	name = "\improper Construction Site Engine Bay"
	icon_state = "engine"

/area/constructionsite/teleporter
	name = "Construction Site Teleporter"
	icon_state = "yellow"

/area/solar/constructionsite
	name = "\improper Construction Site Solars"
	icon_state = "aft"

/area/constructionsite/maintenance
	name = "\improper Construction Site Maintenance"
	icon_state = "yellow"

// Engineering

/area/engineering/atmos/storage
	name = "\improper Atmospherics Storage"
	icon_state = "atmos_storage"
	sound_env = SMALL_ENCLOSED

/area/engineering/engine_room
	name = "\improper Engine Room"
	icon_state = "engine"
	sound_env = LARGE_ENCLOSED

/area/engineering/drone_fabrication
	name = "\improper Engineering Drone Fabrication"
	icon_state = "drone_fab"
	sound_env = SMALL_ENCLOSED

/area/engineering/engine_eva
	name = "\improper Engine EVA"
	icon_state = "engine_eva"

/area/engineering/engine_monitoring
	name = "\improper Engine Monitoring Room"
	icon_state = "engine_monitoring"

/area/engineering/engine_smes
	name = "\improper Engineering SMES"
	icon_state = "engine_smes"
	sound_env = SMALL_ENCLOSED

/area/engineering/engineering_monitoring
	name = "\improper Engineering Monitoring Room"
	icon_state = "engine_monitoring"

/area/engineering/foyer
	name = "\improper Engineering Foyer"
	icon_state = "engineering_foyer"

/area/engineering/locker_room
	name = "\improper Engineering Locker Room"
	icon_state = "engineering_locker"

/area/engineering/storage
	name = "\improper Engineering Storage"
	icon_state = "engineering_storage"

/area/engineering/atmos
 	name = "\improper Atmospherics"
 	icon_state = "atmos"
 	sound_env = LARGE_ENCLOSED

// Research
/area/assembly/chargebay
	name = "\improper Mech Bay"
	icon_state = "mechbay"

/area/assembly/robotics
	name = "\improper Robotics Lab"
	icon_state = "robotics"

/area/rnd/lab
	name = "\improper Research Lab"
	icon_state = "toxlab"

/area/rnd/misc_lab
	name = "\improper Miscellaneous Research"
	icon_state = "toxmisc"

/area/rnd/research
	name = "\improper Research and Development"
	icon_state = "research"

/area/toxins/telesci
	name = "\improper Telescience Lab"
	icon_state = "toxmisc"

// Derelict

/area/derelict/ship
	name = "\improper Abandoned Ship"
	icon_state = "yellow"

// Misc
/area/AIsattele
	name = "\improper AI Satellite Teleporter Room"
	icon_state = "teleporter"
	ambience = list('sound/ambience/ambimalf.ogg')

/area/alien
	name = "\improper Alien base"
	icon_state = "yellow"
	requires_power = 0



// Security

/area/security/armoury
	name = "\improper Security - Armory"
	icon_state = "Warden"

/area/security/checkpoint2
	name = "\improper Security - Checkpoint"
	icon_state = "checkpoint1"

/area/security/detectives_office
	name = "\improper Security - Forensic Office"
	icon_state = "detective"
	sound_env = MEDIUM_SOFTFLOOR

/area/security/nuke_storage
	name = "\improper Vault"
	icon_state = "nuke_storage"

/area/security/range
	name = "\improper Security - Firing Range"
	icon_state = "firingrange"

// Cargo
/area/quartermaster/office
	name = "\improper Supply Office"
	icon_state = "quartoffice"

/area/quartermaster/storage
	name = "\improper Warehouse"
	icon_state = "quartstorage"
	sound_env = LARGE_ENCLOSED

// Crew

/area/crew_quarters/sleeping/cryo
	name = "\improper Cryogenic Storage"
	icon_state = "Sleep"

/area/hydroponics
	name = "\improper Hydroponics"
	icon_state = "hydro"

/area/janitor
	name = "\improper Custodial Closet"
	icon_state = "janitor"

// Tcomm
/area/tcommsat
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')

/area/tcommsat/chamber
	name = "\improper Telecoms Central Compartment"
	icon_state = "tcomsatcham"

/area/tcommsat/computer
	name = "\improper Telecoms Control Room"
	icon_state = "tcomsatcomp"

/area/tcommsat/pirate
	name = "\improper Pirate Server Room"
	icon_state = "tcomsatcham"

/area/tcommsat/chamber/abandoned
	name = "\improper Abandoned Satellite"
	icon_state = "tcomsatcham"

/area/tcommsat/chamber/server
	name = "\improper Telecoms Server Room"
	icon_state = "tcomsatcham"

// AI

/area/ai_monitored
	name = "AI Monitored Area"

/area/ai_monitored/storage/eva
	name = "\improper EVA Storage"
	icon_state = "eva"

/area/turret_protected/ai
	name = "\improper AI Chamber"
	icon_state = "ai_chamber"
	ambience = list('sound/ambience/ambimalf.ogg')

/area/turret_protected/ai_cyborg_station
	name = "\improper Cyborg Station"
	icon_state = "ai_cyborg"
	sound_env = SMALL_ENCLOSED

/area/turret_protected/ai_upload
	name = "\improper AI Upload Chamber"
	icon_state = "ai_upload"
	ambience = list('sound/ambience/ambimalf.ogg')

/area/turret_protected/ai_upload_foyer
	name = "\improper  AI Upload Access"
	icon_state = "ai_foyer"
	ambience = list('sound/ambience/ambimalf.ogg')
	sound_env = SMALL_ENCLOSED

// Chapel

/area/chapel/main
	name = "\improper Chapel"
	icon_state = "chapel"
	ambience = list('sound/ambience/ambicha1.ogg','sound/ambience/ambicha2.ogg','sound/ambience/ambicha3.ogg','sound/ambience/ambicha4.ogg','sound/music/traitor.ogg')
	sound_env = LARGE_ENCLOSED

// Merchant

/area/merchant_station
	name = "\improper Merchant Station"
	icon_state = "LP"

// Syndicate

/area/map_template/syndicate_mothership/raider_base
	name = "\improper Raider Base"

// ACTORS GUILD
/area/acting
	name = "\improper Centcom Acting Guild"
	icon_state = "red"
	dynamic_lighting = 0
	requires_power = 0

/area/acting/backstage
	name = "\improper Backstage"

/area/acting/stage
	name = "\improper Stage"
	dynamic_lighting = 1
	icon_state = "yellow"

// Thunderdome

/area/tdome
	name = "\improper Thunderdome"
	icon_state = "thunder"
	requires_power = 0
	dynamic_lighting = 0
	sound_env = ARENA

/area/tdome/tdome1
	name = "\improper Thunderdome (Team 1)"
	icon_state = "green"

/area/tdome/tdome2
	name = "\improper Thunderdome (Team 2)"
	icon_state = "yellow"

/area/tdome/tdomeadmin
	name = "\improper Thunderdome (Admin.)"
	icon_state = "purple"

/area/tdome/tdomeobserve
	name = "\improper Thunderdome (Observer.)"
	icon_state = "purple"

// GENERIC MINING AREAS

/area/mine
	icon_state = "mining"
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')
	sound_env = ASTEROID
	base_turf = /turf/simulated/floor/asteroid/glloydplanet

/area/mine/explored
	name = "Mine"
	icon_state = "explored"

/area/mine/unexplored
	name = "Mine"
	icon_state = "unexplored"

// OUTPOSTS

/area/outpost/abandoned
	name = "Abandoned Outpost"
	icon_state = "dark"

//REMEMBER THIS FOR THE MERGE //I forgot

/area/outpost/abandoned/base_turf = /turf/simulated/floor/asteroid

/area/outpost/mining_main/eva/base_turf = /turf/simulated/floor/asteroid/glloydplanet

/area/outpost/research/eva/base_turf = /turf/simulated/floor/asteroid/glloydplanet

/area/shuttle/elevator/base_turf = /turf/simulated/floor/plating

/area/shuttle/constructionsite/base_turf = /turf/simulated/floor/planet/jungle/clear

/area/shuttle/securityoutpost/base_turf = /turf/simulated/floor/planet/jungle/clear
