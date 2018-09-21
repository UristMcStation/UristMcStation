//Order is as follows Hallways, Command, Civilian, Security, Science, Engineering, Medical, Cargo, Maintenance

//this is just the Wyrm areas right now, but is in flux as I add/remove areas

//////////////////////////////////////
//			HALLWAYS				//
//////////////////////////////////////

/area/hallway/primary/fore
	name = "\improper Fore Primary Hallway"
	icon_state = "hallF"

/area/hallway/primary/aft
	name = "\improper Aft Primary Hallway"
	icon_state = "hallA"

/area/hallway/primary/central
	name = "\improper Central Primary Hallway"
	icon_state = "hallC1"

//////////////////////////////////////
//			COMMAND					//
//////////////////////////////////////

/area/command
	icon_state = "head_quarters"

/area/command/bridge
	name = "\improper Bridge"
	icon_state = "bridge"

/area/command/hop
	name = "\improper Personnel Office"

/area/command/captain
	name = "\improper Captain's Office"
	icon_state = "captain"
	sound_env = MEDIUM_SOFTFLOOR

/area/command/meeting
	name = "\improper Meeting Room"
	icon_state = "bridge"
	ambience = list()
	sound_env = MEDIUM_SOFTFLOOR

/area/command/headquarters
	name = "\improper Officers' Quarters"

/area/command/fo
	name = "\improper First Officer's Office"

/area/command/fobedroom
	name = "\improper First Officer's Bedroom"

/area/command/ce
	name = "\improper Chief Engineer's Office"

/area/command/teleporter
	name = "\improper Teleporter Chamber"

/area/command/storage
	name = "\improper Bridge Storage"
	icon_state = "bridge"

/area/command/aiupload
	name = "\improper AI Upload"
	icon_state = "ai_chamber"

/area/command/aicore
	name = "\improper AI Core"
	icon_state = "ai_chamber"

/area/command/aiuploadfoyer
	name = "\improper AI Upload Foyer"
	icon_state = "ai_chamber"

/area/command/aiatmos
	name = "\improper AI Atmospherics"
	icon_state = "ai_chamber"

/area/command/aicomputer
	name = "\improper AI Data Room" //???
	icon_state = "ai_chamber"

/area/command/eva
	name = "\improper EVA"
	icon_state = "eva"

/area/command/bodyguard
	name = "\improper Bodyguard's Office"

//////////////////////////////////////
//			CIVILIAN				//
//////////////////////////////////////

/area/civilian
	icon_state = "green"

/area/civilian/observatory
	name = "\improper Starboard Observatory"

/area/civilian/cryo1
	name = "\improper Primary Cryogenic Storage"
	icon_state = "bluenew"

/area/civilian/cryo2
	name = "\improper Secondary Cryogenic Storage"
	icon_state = "bluenew"

/area/civilian/freezer
	name = "\improper Kitchen Freezer"

/area/civilian/kitchen
	name = "\improper Kitchen"
	icon_state = "kitchen"

/area/civilian/messhall
	name = "\improper Mess Hall"

/area/civilian/hydro
	name = "\improper Hydroponics"

/area/civilian/holodeck
	name = "\improper Holodeck"

/area/civilian/janitor
	name = "\improper Janitor's Closet"

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

/area/civilian/sbobserve
	name = "\improper Starboard Observatory"

/area/civilian/abandonedoffice
	name = "\improper Abandoned Office"

//////////////////////////////////////
//			SECURITY				//
//////////////////////////////////////

/area/security
	icon_state = "security"

/area/security/entrance
	name = "\improper Brig Entrance"
	icon_state = "checkpoint1"

/area/security/checkpoint
	name = "\improper Brig Checkpoint"
	icon_state = "Warden"

/area/security/cosoffice
	name = "\improper Chief of Security's Office"
	icon_state = "Warden"

/area/security/armoury
	name = "\improper Armoury"
	icon_state = "Warden"

/area/security/breakroom
	name = "\improper Security Break Room"

/area/security/office
	name = "\improper Security Office"

/area/security/forensics
	name = "\improper Forensics Lab"
	icon_state = "detective"

/area/security/evidence
	name = "\improper Evidence Storage"
	icon_state = "detective"

/area/security/tacarmoury
	name = "\improper Tactical Armory"
	icon_state = "Warden"

/area/security/boardarmoury
	name = "\improper Boarding Armory"
	icon_state = "Warden"

/area/security/lockers
	name = "\improper Security Locker Room"

/area/security/portgun
	name = "\improper Port Gunnery Room"
	icon_state = "LP"

/area/security/starboardgun
	name = "\improper Starboard Gunnery Room"
	icon_state = "LP"

/area/security/bottomgun
	name = "\improper Bottom Deck Gunnery Room"
	icon_state = "LP"

//////////////////////////////////////
//			SCIENCE					//
//////////////////////////////////////

/area/science
	icon_state = "research"

/area/science/office
	name = "\improper Nanotrasen Office"

/area/science/chemlab
	name = "\improper Research Chemistry Lab"

/area/science/xenobio
	name = "\improper Xenobiology Wing"
	icon_state = "xeno_lab"

/area/science/xenoarch
	name = "\improper Xenoarcheology Lab"
	icon_state = "anomaly"

/area/science/dorms
	name = "\improper Research Dormitory"
	icon_state = "blue"

/area/science/storage
	name = "\improper Research Expedition Prep"
	icon_state = "exploration"

//////////////////////////////////////
//			ENGINEERING				//
//////////////////////////////////////

/area/engineering
	icon_state = "yellow"

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

/area/engineering/atmospherics
	name = "\improper Atmospherics"
	icon_state = "atmos"

/area/engineering/atmosmon
	name = "\improper Atmospherics Monitoring"

/area/engineering/engine
	name = "\improper Engine Room"
	icon_state = "engine"
	sound_env = LARGE_ENCLOSED

/area/engineering/externalmaint
	name = "\improper External Engine Maintenance"
	icon_state = "engine_eva"

/area/engineering/smes
	name = "\improper SMES Room"
	sound_env = SMALL_ENCLOSED
	icon_state = "engine_smes"

/area/engineering/subsmes
	name = "\improper Sub Deck SMES Room"
	icon_state = "engine_smes"
	sound_env = SMALL_ENCLOSED

/area/engineering/securestorage
	name = "\improper Secure Storage"
	sound_env = SMALL_ENCLOSED

/area/engineering/techstorage
	name = "\improper Tech Storage"

/area/engineering/stech
	name = "\improper Secure Tech Storage"

/area/engineering/tcomms
	name = "\improper Telecommunications Server"

/area/engineering/tcommsmon
	name = "\improper Telecommunication Monitoring Room"

/area/engineering/extsubmaint
	name = "\improper External Sub Deck Engine Maintenance"

/area/engineering/teg
	name = "\improper TEG Room"

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
	name = "\improper First Deck Top Engine Bay"

//////////////////////////////////////
//			MEDICAL					//
//////////////////////////////////////

/area/medical
	icon_state = "medbay"

/area/medical/cmo
	name = "\improper Chief Medical Officer's Office"

/area/medical/lobby
	name = "\improper Medical Lobby"
	ambience = list('sound/ambience/signal.ogg')

/area/medical/treatment
	name = "\improper Medical Treatment Center"
	icon_state = "medbay3"

/area/medical/hallway
	name = "\improper Medical Hallway"
	icon_state = "medbay2"

/area/medical/morgue
	name = "\improper Morgue"
	icon_state = "morgue"

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

/area/medical/chemistry
	name = "\improper Chemistry Lab"
	icon_state = "chem"

/area/medical/surgery
	name = "\improper Operating Theatre"
	icon_state = "surgery"

/area/medical/virology
	name = "\improper Virology Lab"

//////////////////////////////////////
//			LOGISTICS				//
//////////////////////////////////////

/area/logistics
	icon_state = "yellow"

/area/logistics/qm
	name = "\improper Quartermaster's Office"
	icon_state = "quartoffice"

/area/logistics/storage
	name = "\improper Cargo General Storage"
	icon_state = "quartstorage"

/area/logistics/primtool
	name = "\improper General Storage"

/area/logistics/auxtool
	name = "\improper Auxiliary Storage"

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

/area/logistics/advwork
	name = "\improper Cargo Advanced Workshop"
	icon_state = "quart"

/area/logistics/mailing
	name = "\improper Mailing Office"
	icon_state = "quartoffice"

/area/logistics/lockers
	name = "\improper Cargo Expedition Prep"
	icon_state = "exploration"

/area/logistics/robotics
	name = "\improper Robotics Lab"
	icon_state = "research"

/area/logistics/mechbay
	name = "\improper Mech Bay"
	icon_state = "mechbay"

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

//second deck

/area/maintenance/second_deck/fs
	name = "\improper Second Deck Fore Starboard Maintenance"
	icon_state = "fsmaint"

/area/maintenance/second_deck/fp
	name = "\improper Second Deck Fore Port Maintenance"
	icon_state = "fpmaint"

/area/maintenance/second_deck/centp
	name = "\improper Second Deck Central Port Maintenance"
	icon_state = "maintcentral"

/area/maintenance/second_deck/cents
	name = "\improper Second Deck Central Port Maintenance"
	icon_state = "maintcentral"

/area/maintenance/second_deck/afs
	name = "\improper Second Deck Aft Starboard Maintenance"
	icon_state = "maint_engineering"

/area/maintenance/second_deck/afp
	name = "\improper Second Deck Aft Port Maintenance"
	icon_state = "amaint"

/area/maintenance/second_deck/central
	name = "\improper First Deck Central Maintenance"
	icon_state = "maintcentral"

//third deck

/area/maintenance/primary/sec
	name = "\improper Security Maintenance"
	icon_state = "maint_security_starboard"

/area/maintenance/primary/med
	name = "\improper Medical Maintenance"
	icon_state = "maint_medical"

/area/maintenance/primary/engs
	name = "\improper Engineering Starboard Maintenance"
	icon_state = "maint_engineering"

/area/maintenance/primary/engp
	name = "\improper Engineering Port Maintenance"
	icon_state = "maint_engineering"

/area/maintenance/sub/fore
	name = "\improper Fore Sub Deck Maintenance"
	icon_state = "fmaint"

/area/maintenance/sub/aft
	name = "\improper Aft Sub Deck Maintenance"
	icon_state = "amaint"

/area/maintenance/drone
	name = "\improper Maintenance Drone Production"
	icon_state = "maint_engineering"

/area/maintenance/construction
	name = "\improper Construction Room"


//////////////////////////////////////
//			HALLWAYS   				//
//////////////////////////////////////

/area/hallway
	sound_env = LARGE_ENCLOSED

/area/hallway/fore
	icon_state = "hallF"

/area/hallway/aft
	icon_state = "hallA"

//top deck
/area/hallway/fore/first
	name = "\improper Fore First Deck Hallway"

/area/hallway/aft/first
	name = "\improper Aft First Deck Hallway"

//central deck

/area/hallway/fore/second
	name = "\improper Fore Second Deck Hallway"

/area/hallway/central/second
	name = "\improper Central Second Deck Hallway"
	icon_state = "hallC1"

/area/hallway/aft/second
	name = "\improper Aft Second Deck Hallway"

/area/hallway/commandoffices
	name = "\improper Command Offices Hallway"
	icon_state = "hallC1"

/area/hallway/commandport
	name = "\improper Command Port Hallway"
	icon_state = "hallP"

/area/hallway/commandstarboard
	name = "\improper Command Starboard Hallway"
	icon_state = "hallS"

//bottom deck

/area/hallway/centralthird
	name = "\improper Primary Third Deck Hallway"
	icon_state = "hallC1"

//////////////////////////////////////
//			Z-LEVEL 3 / ADMIN		//
//////////////////////////////////////

/area/holodeck
	name = "\improper Holodeck"
	icon_state = "Holodeck"
	dynamic_lighting = 0
	sound_env = LARGE_ENCLOSED

/area/holodeck/source_battle_arena
	name = "\improper Holodeck - Battle Arena"
	sound_env = ARENA

/area/holodeck/source_surgery
	name = "\improper Holodeck - Surgery Simulation"
	requires_power = 0

/area/holodeck/source_beach
	name = "\improper Holodeck - Beach Simulation"

/area/holodeck/source_winter
	name = "\improper Holodeck - Winter Simulation"

/area/holodeck/source_chapel
	name = "\improper Holodeck - Chapel"

/area/holodeck/source_plating
	name = "\improper Holodeck - Off"

/area/drone_test
	name = "\improper Biohazard Simulation Arena"
	requires_power = 0
	dynamic_lighting = 0

/area/wizard
	name = "Wizard's Lair"
	requires_power = 0
	dynamic_lighting = 0

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
