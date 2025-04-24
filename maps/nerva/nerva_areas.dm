/datum/map/nerva
	base_floor_area = /area/maintenance/exterior
	post_round_safe_areas = list(/area/shuttle/escape_pod1,/area/shuttle/escape_pod2,/area/shuttle/escape_pod3)

//Order is as follows Command, Civilian, Security, Science, Engineering, Medical, Cargo, Maintenance, Hallways

//////////////////////////////////////
//			COMMAND					//
//////////////////////////////////////

/area/command
	icon_state = "head_quarters"
	req_access = list(access_bridge)
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/command/bridge
	name = "\improper ICS Nerva Bridge"
	icon_state = "bridge"
	is_critical = TRUE

/area/command/hop
	name = "\improper Personnel Office"
	req_access = list(access_hop)

/area/command/captain
	name = "\improper Captain's Office"
	icon_state = "captain"
	sound_env = MEDIUM_SOFTFLOOR
	req_access = list(access_captain)

/area/command/meeting
	name = "\improper Meeting Room"
	icon_state = "bridge"
	ambience = list()
	sound_env = MEDIUM_SOFTFLOOR

///area/command/headquarters
//	name = "\improper Officers' Quarters"

/area/command/ce_dorm
	name = "\improper Chief Engineer Dorm"
	req_access = list(access_ce)

/area/command/cos_dorm
	name = "\improper Chief Security Dorm"
	req_access = list(access_hos)

/area/command/cmo_dorm
	name = "\improper Chief Medical Dorm"
	req_access = list(access_cmo)

/area/command/so_dorm
	name = "\improper Second Officers Dorm"
	req_access = list(access_hop)

/area/command/fo
	name = "\improper First Officer's Office"
	req_access = list(access_fo)

/area/command/fobedroom
	name = "\improper First Officer's Bedroom"
	req_access = list(access_fo)

/*/area/command/seniorntbedroom
	name = "\improper Senior Researcher's Quarters"
	req_access = list(access_seniornt)
	icon_state = "bridge"*/

/area/command/seniorntoffice
	name = "\improper Senior Researcher's Office."
	req_access = list(access_seniornt)
	icon_state = "bridge"

/area/command/ce
	name = "\improper Chief Engineer's Office"
	req_access = list(access_ce)

/area/command/teleporter
	name = "\improper Teleporter Chamber"
	req_access = list(access_teleporter)
	is_critical = TRUE //for boarding

/area/command/storage
	name = "\improper Bridge Storage"
	icon_state = "bridge"

/area/command/aiupload
	name = "\improper AI Upload"
	icon_state = "ai_chamber"
	req_access = list(access_ai_upload)

/area/command/aicore
	name = "\improper AI Core"
	icon_state = "ai_chamber"
	req_access = list(access_ai_upload)

/*/area/command/aicomputer
	name = "\improper AI Data Room" //???
	icon_state = "ai_chamber"
	req_access = list(access_ai_upload)*/ //genuinely what the fuck is this area

/area/command/eva
	name = "\improper EVA"
	icon_state = "eva"
	req_access = list(access_eva)

/area/command/bodyguard
	name = "\improper Bodyguard's Office"
	req_access = list(access_blueshield)

/area/security/nuke_storage
	name = "\improper Vault"
	icon_state = "nuke_storage"

/area/command/bottom_hallway
	name = "\improper Fourth Deck Command Hallway"
	icon_state = "hallC1"

/*/area/command/fourth_emergency_storage
	name = "\improper Fourth Deck Emergency Storage"
	sound_env = SMALL_ENCLOSED
	icon_state = "green"*/

/area/command/safe_room
	name = "\improper Safe Room"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	is_critical = TRUE

/area/command/weapons_command
	name = "\improper Weapons Command"
	sound_env = SMALL_ENCLOSED
	area_flags = AREA_FLAG_ION_SHIELDED
	is_critical = TRUE

//////////////////////////////////////
//			CIVILIAN				//
//////////////////////////////////////

/area/civilian
	icon_state = "green"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/civilian/observatory
	name = "\improper Starboard Observatory"

/area/civilian/cryo1
	name = "\improper Primary Cryogenic Storage"
	icon_state = "bluenew"
	area_flags = AREA_FLAG_RAD_SHIELDED
	is_critical = TRUE

/area/civilian/cryo2
	name = "\improper Secondary Cryogenic Storage"
	icon_state = "bluenew"
	area_flags = AREA_FLAG_RAD_SHIELDED
	is_critical = TRUE

/area/civilian/freezer
	name = "\improper Kitchen Freezer"
	req_access = list(access_kitchen)

/area/civilian/kitchen
	name = "\improper Kitchen"
	icon_state = "kitchen"
	req_access = list(access_kitchen)

/*/area/civilian/messhall
	name = "\improper Mess Hall"*/

/area/civilian/hydro
	name = "\improper Hydroponics"

/area/civilian/holodeck
	name = "\improper Holodeck"

/area/civilian/janitor
	name = "\improper Janitor's Closet"
	req_access = list(access_janitor)

/area/civilian/bath
	name = "\improper Bathrooms"
	area_flags = AREA_FLAG_RAD_SHIELDED
	icon_state = "blueold"

/area/civilian/personal
	name = "\improper Personal Storage"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/civilian/dorms
	name = "\improper Dormitory"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/civilian/lounge
	name = "\improper Lounge"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/civilian/bar
	name = "\improper Bar"
	icon_state = "bar"
	sound_env = LARGE_SOFTFLOOR
	is_critical = TRUE

/area/civilian/abandonedoffice
	name = "\improper Abandoned Office"

/area/civilian/abandonedwarehouse
	name = "\improper Abandoned Warehouse"
	sound_env = LARGE_ENCLOSED

/area/civilian/first_deck_lobby
	name = "\improper First Deck Lobby"

/area/civilian/first_emergency_storage
	name = "\improper First Emergency Storage"
	sound_env = SMALL_ENCLOSED

/area/civilian/counselor
	name = "\improper Counselor's Office"
	req_access = list(access_psychiatrist)

/area/civilian/entertainer
	name = "\improper Entertainer's Room"
	sound_env = SMALL_ENCLOSED

/*/area/civilian/exercise
	name = "\improper Exercise Room"
	sound_env = SMALL_ENCLOSED*/

/area/civilian/journalist
	name = "\improper Journalist's Office"
	sound_env = SMALL_ENCLOSED

/area/chapel
	name = "\improper Chapel"
	icon_state = "chapel"
	sound_env = LARGE_SOFTFLOOR

/area/chapel/office
	name = "\improper Chapel Office"
	icon_state = "chapeloffice"
	sound_env = SMALL_ENCLOSED

//////////////////////////////////////
//			SECURITY				//
//////////////////////////////////////

/area/security
	icon_state = "security"
	req_access = list(access_security)

/area/security/entrance
	name = "\improper Brig Entrance"
	icon_state = "checkpoint1"
	req_access = list()

/area/security/checkpoint
	name = "\improper Brig Checkpoint"
	icon_state = "Warden"

/area/security/hangercheckpoint
	name = "\improper Hangar Checkpoint"
	icon_state = "checkpoint1"

/area/security/dockingcheckpoint
	name = "\improper Docking Area Checkpoint"
	icon_state = "checkpoint1"

/area/security/abandonedcheckpoint
	name = "\improper Abandoned Checkpoint"
	icon_state = "checkpoint1"

/area/security/cosoffice
	name = "\improper Chief of Security's Office"
	icon_state = "Warden"
	req_access = list(access_hos)

/area/security/armoury
	name = "\improper Armoury"
	icon_state = "Warden"
	req_access = list(access_armory)
	is_critical = TRUE

/area/security/breakroom
	name = "\improper Security Dorms"

/area/security/office
	name = "\improper Security Office"
	is_critical = TRUE

/area/security/forensics
	name = "\improper Forensics Lab"
	icon_state = "detective"
	req_access = list(access_forensics_lockers)

/area/security/evidence
	name = "\improper Evidence Storage"
	icon_state = "detective"
	req_access = list(access_forensics_lockers)

/area/security/interrogation
	name = "\improper Interrogation Room"
	icon_state = "Warden"

/area/security/boardarmoury
	name = "\improper Boarding Armory"
	icon_state = "Warden"
	req_access = list(access_armory)
	is_critical = TRUE

/area/security/lockers
	name = "\improper Security Locker Room"

/area/security/portgun
	name = "\improper Port Gunnery Room"
	icon_state = "LP"
	req_access = list(list(access_bridge, access_gunnery))
	is_critical = TRUE

/area/security/portexternalgun
	name = "\improper Port External Gun Bay"
	icon_state = "LP"
	req_access = list(list(access_bridge, access_gunnery))
	is_critical = TRUE

/area/security/starboardgun
	name = "\improper Starboard Gunnery Room"
	icon_state = "LP"
	req_access = list(list(access_bridge, access_gunnery))
	is_critical = TRUE

/area/security/starboardexternalgun
	name = "\improper Starboard External Gun Bay"
	icon_state = "LP"
	req_access = list(list(access_bridge, access_gunnery))
	is_critical = TRUE

/area/security/bottomgun
	name = "\improper Fourth Deck Gunnery Room"
	icon_state = "LP"
	req_access = list(list(access_bridge, access_gunnery))
	is_critical = TRUE

/area/security/topgun
	name = "\improper First Deck Gunnery Room"
	icon_state = "LP"
	req_access = list(list(access_bridge, access_gunnery))
	is_critical = TRUE

//////////////////////////////////////
//			SCIENCE					//
//////////////////////////////////////

/area/rnd
	icon_state = "research"
	req_access = list(access_tox)

/area/rnd/office
	name = "\improper NanoTrasen Office"

/area/rnd/chemlab
	name = "\improper Research Chemistry Lab"

///area/rnd/xenobio
//	name = "\improper Xenobiology Wing"
//	icon_state = "xeno_lab"

/area/rnd/xenoarch
	name = "\improper Xenoarcheology Lab"
	icon_state = "anomaly"

/area/rnd/dorms
	name = "\improper Research Dormitory"
	icon_state = "blue"

/area/rnd/storage
	name = "\improper Research Expedition Prep"
	icon_state = "exploration"

//////////////////////////////////////
//			ENGINEERING				//
//////////////////////////////////////

/area/engineering
	icon_state = "yellow"
	req_access = list(access_engine)

/area/engineering/tool
	name = "\improper Engineering Workshop"

/area/engineering/lobby
	name = "\improper Engineering"
	icon_state = "engineering_foyer"

/area/engineering/break_room
	name = "\improper Engineering Break Room"
	icon_state = "engineering_foyer"

/area/engineering/locker
	name = "\improper Engineering Locker Room"
	icon_state = "engineering_locker"

/area/engineering/genstorage
	name = "\improper Engineering Storage"
	icon_state = "engineering_storage"

/area/engineering/smmon
	name = "\improper Supermatter Monitoring Room"
	icon_state = "engine_monitoring"
	req_access = list(access_engine_equip)
	is_critical = TRUE

/area/engineering/atmospherics
	name = "\improper Atmospherics"
	icon_state = "atmos"
	req_access = list(access_atmospherics)

/area/engineering/engine
	name = "\improper Engine Room"
	icon_state = "engine"
	sound_env = LARGE_ENCLOSED
	req_access = list(access_engine_equip)
	is_critical = TRUE

/area/engineering/smes
	name = "\improper SMES Room"
	sound_env = SMALL_ENCLOSED
	icon_state = "engine_smes"
	is_critical = TRUE

/area/engineering/securestorage
	name = "\improper Secure Storage"
	sound_env = SMALL_ENCLOSED

/area/engineering/techstorage
	name = "\improper Tech Storage"

/area/engineering/stech
	name = "\improper Secure Tech Storage"

/area/engineering/tcomms
	name = "\improper Telecommunications Server"
	req_access = list(access_tcomsat)

/area/engineering/tcommsmon
	name = "\improper Telecommunication Monitoring Room"
	req_access = list(access_tcomsat)

/area/engineering/engine_waste
	name = "\improper Engine Waste Handling"
	icon_state = "engine_waste"

/area/engineering/fuelbay
	name = "\improper Fuel Bay"

/area/engineering/fdengine
	name = "\improper Top Deck Engine Bay"

/area/engineering/bdportengine
	name = "\improper Bottom Deck Port Engine Bay"

/area/engineering/bdstarengine
	name = "\improper Bottom Deck Starboard Engine Bay"

/area/engineering/drone_fabrication
	name = "\improper Drone Fabrication"
	icon_state = "drone_fab"
	sound_env = SMALL_ENCLOSED

/area/engineering/first_deck_storage
	name = "\improper Auxiliary Engineering Storage"
	icon_state = "engineering_storage"
	sound_env = SMALL_ENCLOSED

/area/engineering/first_deck_atmos
	name = "\improper First Deck Atmospherics Storage"
	icon_state = "engineering_storage"
	sound_env = SMALL_ENCLOSED

/area/engineering/bluespace
	name = "Bluespace Drive Containment"
	icon_state = "engineering"
	color = COLOR_BLUE_LIGHT
	req_access = list(list(access_engine_equip, access_heads), access_engine, access_maint_tunnels)

// Substations

/area/engineering/substation
	name = "/improper Substation"
	icon_state = "engine_smes"
	sound_env = SMALL_ENCLOSED
	area_flags = AREA_FLAG_RAD_SHIELDED
	req_access = list(access_engine)

/area/engineering/substation/first_deck
	name = "\improper First Deck Substation"

/area/engineering/substation/second_deck
	name = "\improper Second Deck Substation"

/area/engineering/substation/third_deck
	name = "\improper Third Deck Substation"

/area/engineering/substation/fourth_deck
	name = "\improper Fourth Deck Substation"

/area/engineering/substation/atmos
	name = "\improper Atmospherics Substation"

/area/engineering/substation/command
	name ="\improper Command Substation"

//solars

/area/solar
	req_access = list(access_maint_tunnels)
	area_flags = AREA_FLAG_EXTERNAL
	has_gravity = FALSE

/area/solar/main
	name = "\improper Main Solar Array"
	icon_state = "panelsS"

/area/solar/auxaft
	name = "\improper Aft Auxiliary Solar Array"
	icon_state = "panelsA"

/area/maintenance/mainsolar
	name = "\improper Solar Maintenance - Main"
	icon_state = "SolarcontrolS"
	sound_env = SMALL_ENCLOSED
	holomap_color = HOLOMAP_AREACOLOR_AIRLOCK

/area/maintenance/aftsolar
	name = "\improper Solar Maintenance - Aft Auxiliary"
	icon_state = "SolarcontrolA"
	sound_env = SMALL_ENCLOSED
	holomap_color = HOLOMAP_AREACOLOR_AIRLOCK

//////////////////////////////////////
//			MEDICAL					//
//////////////////////////////////////

/area/medical
	icon_state = "medbay"
	req_access = list(access_medical)

/area/medical/cmo
	name = "\improper Chief Medical Officer's Office"
	req_access = list(access_cmo)

/area/medical/lobby
	name = "\improper Medical Lobby"
	ambience = list('sound/ambience/signal.ogg')

/area/medical/treatment
	name = "\improper Medical Treatment Center"
	icon_state = "medbay3"
	is_critical = TRUE

/area/medical/hallway
	name = "\improper Medical Hallway"
	icon_state = "medbay2"
	req_access = list()
	is_critical = TRUE

/area/medical/morgue
	name = "\improper Morgue"
	icon_state = "morgue"
	req_access = list(access_morgue)

/area/medical/examroom
	name = "\improper Exam Room"
	icon_state = "exam_room"

/area/medical/ward
	name = "\improper Patient Ward"

/area/medical/locker
	name = "\improper Medical Locker Room"
	icon_state = "bluenew"

/area/medical/storage
	name = "\improper Medical Storage"
	icon_state = "medbay4"
	req_access = list(access_medical_equip)

/area/medical/chemistry
	name = "\improper Chemistry Lab"
	icon_state = "chem"
	req_access = list(access_chemistry)
	is_critical = TRUE

/area/medical/surgery
	name = "\improper Operating Theatre"
	icon_state = "surgery"
	req_access = list(access_surgery)
	is_critical = TRUE

/area/medical/virology
	name = "\improper Virology Lab"
	req_access = list(access_virology)

/area/medical/cloning
	name = "\improper Cloning Bay"
	req_access = list(access_medical)
	is_critical = TRUE

/area/medical/extstorage
	name = "\improper Medbay Extra Storage"
	icon_state = "bluenew"
	req_access = list(access_medical_equip)

//////////////////////////////////////
//			LOGISTICS				//
//////////////////////////////////////

/area/logistics
	icon_state = "yellow"
	req_access = list(access_cargo)
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/logistics/qm
	name = "\improper Quartermaster's Office"
	icon_state = "quartoffice"
	req_access = list(access_qm)

/*/area/logistics/storage
	name = "\improper Cargo General Storage"
	icon_state = "quartstorage"*/

/area/logistics/primtool
	name = "\improper General Storage"
	req_access = list(access_prim_tool)

/area/logistics/auxtool
	name = "\improper Auxiliary Storage"
	req_access = list()

/area/logistics/uppercargo
	name = "\improper Upper Cargo Bay"

/area/logistics/lowercargo
	name = "\improper Lower Cargo Bay"

/area/logistics/lockers
	name = "\improper Cargo Locker Room"
	icon_state = "quartstorage"

/area/logistics/fabwork
	name = "\improper Cargo Fabrication Workshop"
	icon_state = "quartoffice"
	is_critical = TRUE

/area/logistics/advwork
	name = "\improper Cargo Advanced Workshop"
	icon_state = "quart"

/area/logistics/mailing
	name = "\improper Mailing Office"
	icon_state = "quartoffice"

/area/logistics/prep
	name = "\improper Cargo Expedition Prep"
	icon_state = "exploration"

/area/logistics/genprep
	name = "\improper General Expedition Prep"
	icon_state = "exploration"
	req_access = list(access_expedition)
	holomap_color = HOLOMAP_AREACOLOR_EXPLORATION

/area/logistics/robotics
	name = "\improper Robotics Lab"
	icon_state = "research"
	req_access = list(access_robotics)

/area/logistics/mechbay
	name = "\improper Mech Bay"
	icon_state = "mechbay"
	req_access = list(access_robotics)

/area/logistics/hangar
	name = "\improper Hangar"
	req_access = list()
	holomap_color = HOLOMAP_AREACOLOR_EXPLORATION

/area/supply/dock
	name = "Supply Shuttle"
	icon_state = "shuttle3"
	requires_power = 0

//////////////////////////////////////
//			MAINTENANCE				//
//////////////////////////////////////

//first deck

/area/maintenance/first_deck/fs
	name = "\improper First Deck Fore Starboard Maintenance"
	icon_state = "fsmaint"

/area/maintenance/first_deck/fp
	name = "\improper First Deck Fore Port Maintenance"
	icon_state = "fpmaint"

/area/maintenance/first_deck/afs
	name = "\improper First Deck Aft Starboard Maintenance"
	icon_state = "maint_engineering"

/area/maintenance/first_deck/afp
	name = "\improper First Deck Aft Port Maintenance"
	icon_state = "amaint"

/area/maintenance/first_deck/central
	name = "\improper First Deck Central Maintenance"
	icon_state = "maintcentral"

/area/maintenance/first_deck/fore
	name = "\improper First Deck Fore Maintenance"
	icon_state = "maintcentral"

//second deck

/area/maintenance/second_deck/fs
	name = "\improper Second Deck Fore Starboard Maintenance"
	icon_state = "fsmaint"

/area/maintenance/second_deck/fp
	name = "\improper Second Deck Fore Port Maintenance"
	icon_state = "fpmaint"

/area/maintenance/second_deck/afs
	name = "\improper Second Deck Aft Starboard Maintenance"
	icon_state = "maint_engineering"

/area/maintenance/second_deck/afp
	name = "\improper Second Deck Aft Port Maintenance"
	icon_state = "amaint"

/area/maintenance/second_deck/central
	name = "\improper Second Deck Central Maintenance"
	icon_state = "maintcentral"

//third deck

/area/maintenance/third_deck/fs
	name = "\improper Third Deck Fore Starboard Maintenance"
	icon_state = "fsmaint"

/area/maintenance/third_deck/fp
	name = "\improper Third Deck Fore Port Maintenance"
	icon_state = "fpmaint"

/area/maintenance/third_deck/centp
	name = "\improper Third Deck Central Port Maintenance"
	icon_state = "maintcentral"

/area/maintenance/third_deck/cents
	name = "\improper Third Deck Central Starboard Maintenance"
	icon_state = "maintcentral"

/area/maintenance/third_deck/afs
	name = "\improper Third Deck Aft Starboard Maintenance"
	icon_state = "maint_engineering"

/area/maintenance/third_deck/afp
	name = "\improper Third Deck Aft Port Maintenance"
	icon_state = "amaint"

/area/maintenance/third_deck/central
	name = "\improper Third Deck Central Maintenance"
	icon_state = "maintcentral"

//fourth deck

/area/maintenance/fourth_deck/fs
	name = "\improper Fourth Deck Fore Starboard Maintenance"
	icon_state = "fsmaint"

/area/maintenance/fourth_deck/fp
	name = "\improper Fourth Deck Fore Port Maintenance"
	icon_state = "fpmaint"

/area/maintenance/fourth_deck/afs
	name = "\improper Fourth Deck Aft Starboard Maintenance"
	icon_state = "maint_engineering"

/area/maintenance/fourth_deck/afp
	name = "\improper Fourth Deck Aft Port Maintenance"
	icon_state = "amaint"

/area/maintenance/fourth_deck/central
	name = "\improper Fourth Deck Central Maintenance"
	icon_state = "maintcentral"

/area/maintenance/fourth_deck/disposals
	name = "\improper Waste Disposal"
	icon_state = "disposal"

/area/maintenance/exterior
	name = "\improper Exterior Maintenance"

//////////////////////////////////////
//			HALLWAYS   				//
//////////////////////////////////////

/area/hallway
	sound_env = LARGE_ENCLOSED

/area/hallway/fore
	icon_state = "hallF"

/area/hallway/aft
	icon_state = "hallA"

//top/first deck
/area/hallway/centralfirst
	name = "\improper Primary First Deck Hallway"
	icon_state = "hallC1"

//second deck
/area/hallway/fore/second_deck
	name = "\improper Fore Second Deck Hallway"

/area/hallway/aft/second_deck
	name = "\improper Aft Second Deck Hallway"

//third deck

/area/hallway/fore/third_deck
	name = "\improper Fore Third Deck Hallway"

/area/hallway/central/third_deck
	name = "\improper Central Third Deck Hallway"
	icon_state = "hallC1"

/area/hallway/aft/third_deck
	name = "\improper Aft Third Deck Hallway"

/area/hallway/commandoffices
	name = "\improper Command Offices Hallway"
	icon_state = "hallC1"
	req_access = list(access_bridge)

/area/hallway/commandport
	name = "\improper Command Port Hallway"
	icon_state = "hallP"
	req_access = list(access_bridge)
	is_critical = TRUE

/area/hallway/commandstarboard
	name = "\improper Command Starboard Hallway"
	icon_state = "hallS"
	req_access = list(list(access_bridge, access_gunnery))
	is_critical = TRUE

//bottom/fourth deck

/area/hallway/centralfourth
	name = "\improper Primary Fourth Deck Hallway"
	icon_state = "hallC1"

//////////////////////////////////////
//			Z-LEVEL 5 / ADMIN		//
//////////////////////////////////////

/area/centcom
	name = "Admin Area"

//holodeck

/area/holodeck
	name = "\improper Holodeck"
	icon_state = "Holodeck"
	dynamic_lighting = 0
	requires_power = 0
	sound_env = LARGE_ENCLOSED
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/holodeck/source_battle_arena
	name = "\improper Holodeck - Battle Arena"
	sound_env = ARENA

/area/holodeck/source_beach
	name = "\improper Holodeck - Beach Simulation"
	sound_env = PLAIN

/area/holodeck/source_winter
	name = "\improper Holodeck - Winter Simulation"
	sound_env = FOREST

/area/holodeck/source_chapel
	name = "\improper Holodeck - Chapel"
	sound_env = AUDITORIUM

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

/area/holodeck/source_volleyball
	name = "\improper Holodeck - Volleyball"
	sound_env = PLAIN

/area/holodeck/source_desert
	name = "\improper Holodeck - Desert"
	sound_env = PLAIN

/area/holodeck/source_space
	name = "\improper Holodeck - Space"
	has_gravity = 0
	sound_env = SPACE

/area/holodeck/source_cafe
	name = "\improper Holodeck - Cafe"
	sound_env = PLAIN

/area/holodeck/source_plaza
	name = "\improper Holodeck - Plaza"
	sound_env = SMALL_ENCLOSED

/area/holodeck/source_gym
	name = "\improper Holodeck - Gym"
	sound_env = SMALL_ENCLOSED

/area/drone_test
	name = "\improper Biohazard Simulation Arena"
	requires_power = 0
	dynamic_lighting = 0

/area/holodeck/source_rainycafe
	name = "\improper Holodeck - Rainy Cafe Simulation"
	sound_env = SMALL_ENCLOSED

/area/holodeck/source_ocean
	name = "\improper Holodeck - Ocean Simulation"
	sound_env = PLAIN

/area/holodeck/source_jungle
	name = "\improper Holodeck - Jungle Simulation"
	sound_env = PLAIN

/area/holodeck/source_christmas
	name = "\improper Holodeck - Christmas Simulation"
	sound_env = PLAIN

///area/wizard
//	name = "Wizard's Lair"
//	requires_power = 0
//	dynamic_lighting = 0

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

/area/fightclub
	name = "\improper Actor's Guild Break Room"
	requires_power = FALSE

/area/merchant_station
	name = "\improper Merchant Station"

/area/map_template/syndicate_mothership/raider_base
	name = "\improper Raider Base"

/area/deity_spawn
	name = "\improper Deity Spawn"
	icon_state = "yellow"
	requires_power = 0
	dynamic_lighting = 0

//////////////////////////////////////
//			AWAY MISSION			//
//////////////////////////////////////

/area/mine
	icon_state = "mining"
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')
	sound_env = ASTEROID

/area/mine/explored
	name = "Mine"
	icon_state = "explored"

/area/mine/unexplored
	name = "Mine"
	icon_state = "unexplored"

/area/away/abandoned
	name = "\improper Abandoned Facility"

/area/away/forgotten
	name = "\improper Contact Light"
	has_gravity = 0

/area/away/shipremains
	name = "\improper Unknown"
	has_gravity = 0

/area/away/dionaship
	name = "\improper Unknown Signature"
	ambience = list('sound/ambience/biomass.ogg')
	requires_power = 0
	base_turf = /turf/simulated/floor/diona

/area/away/crashedvox
	name = "\improper Rakaheti"

/area/away/virolabs
	name = "\improper Virology Labratory"
/*
/area/jungle/southruins

/area/jungle/northruins

/area/jungle/southeastruins

/area/jungle/southwild
	dynamic_lighting = FALSE

/area/jungle/northwild
	dynamic_lighting = FALSE

/area/jungle/northeastwild
	dynamic_lighting = FALSE

/area/jungle/southeastwild
	dynamic_lighting = FALSE

/area/jungle/river
	dynamic_lighting = FALSE

/area/jungle/plains
	dynamic_lighting = FALSE

/area/jungle/shack
	name = "\improper Makeshift Building"

/area/jungle/shuttle
*/
//ship

/area/ship/combat
	name = "\improper Ship"
