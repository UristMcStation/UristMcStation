//Order is as follows Hallways, Command, Civilian, Security, Science, Engineering, Medical, Cargo, Maintenance

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
	icon_state = "blueold"

/area/command/bridge
	name = "\improper Bridge"

/area/command/hop
	name = "\improper Head of Personnel Office"

/area/command/captain
	name = "\improper Captain's Office"

/area/command/meeting
	name = "\improper Meeting Room"

/area/command/ce
	name = "\improper Chief Engineer's Office"

/area/command/aiupload
	name = "\improper AI Upload"

/area/command/aicore
	name = "\improper AI Core"

/area/command/aiuploadfoyer
	name = "\improper AI Upload Foyer"

/area/command/aiatmos
	name = "\improper AI Atmospherics"

/area/command/aicomputer
	name = "\improper AI Data Room" //???

/area/command/eva
	name = "\improper EVA"

//////////////////////////////////////
//			CIVILIAN				//
//////////////////////////////////////

/area/civilian
	icon_state = "green"

/area/civilian/cryo1
	name = "\improper Primary Cryogenic Storage"

/area/civilian/cryo2
	name = "\improper Secondary Cryogenic Storage"

/area/civilian/storage
	name = "\improper Auxiliary Storage"

/area/civilian/bar
	name = "\improper Bar"

/area/civilian/freezer
	name = "\improper Kitchen Freezer"

/area/civilian/hydro
	name = "\improper Hydroponics"

/area/civilian/holodeck
	name = "\improper Holodeck"

/area/civilian/personal
	name = "\improper Personal Storage"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/civilian/dorms
	name = "\improper Dormitory"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/civilian/lounge
	name = "\improper Lounge"
	area_flags = AREA_FLAG_RAD_SHIELDED

//////////////////////////////////////
//			SECURITY				//
//////////////////////////////////////

/area/security
	icon_state = "security"

/area/security/entrance
	name = "\improper Brig Entrance"

/area/security/warden
	name = "\improper Warden's Office"

/area/security/armory
	name = "\improper Armory"

/area/security/locker
	name = "\improper Security Locker Room"

/area/security/forenics
	name = "\improper Forensics Lab"

/area/security/evidence
	name = "\improper Evidence Storage"

//////////////////////////////////////
//			SCIENCE					//
//////////////////////////////////////

/area/science
	icon_state = "research"

/area/science/entrance
	name = "\improper Science Wing Entrance"

/area/science/robotics
	name = "\improper Robotics Lab"

/area/science/rnd
	name = "\improper Research and Development Lab"

/area/science/hallway
	name = "\improper Science Wing Hallway"

/area/science/xenobio
	name = "\improper Xenobiology Wing"

/area/science/xenoarch
	name = "\improper Xenoarcheology Lab"

/area/science/prep
	name = "\improper Research Locker Room"

/area/science/shuttleprep
	name = "\improper Hatchling Preperation Room"

//////////////////////////////////////
//			ENGINEERING				//
//////////////////////////////////////

/area/engineering
	icon_state = "yellow"

/area/engineering/tool
	name = "\improper Public Workshop"

/area/engineering/lobby
	name = "\improper Engineering"

/area/engineering/locker
	name = "\improper Engineering Storage"

/area/engineering/rustmon
	name = "\improper Fusion Core Monitoring Room"

/area/engineering/atmos
	name = "\improper Atmospherics"

/area/engineering/atmosmon
	name = "\improper Atmospherics Monitoring"

/area/engineering/engine
	name = "\improper Engine Core"
	icon_state = "engine"

/area/engineering/externalmaint
	name = "\improper External Engine Maintenance"
	icon_state = "engine"

/area/engineering/smes
	name = "\improper SMES Room"

/area/engineering/subsmes
	name = "\improper Sub Deck SMES Room"

/area/engineering/securestorage
	name = "\improper Secure Storage"

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

//////////////////////////////////////
//			MEDICAL					//
//////////////////////////////////////

/area/medical
	icon_state = "bluenew"

/area/medical/lobby
	name = "\improper Medical Lobby"

/area/medical/treatment
	name = "\improper Medical Treatment Center"

/area/medical/morgue
	name = "\improper Morgue"

/area/medical/storage
	name = "\improper Medical Storage"

/area/medical/chemistry
	name = "\improper Chemistry Lab"

/area/medical/surgery
	name = "\improper Operating Theatre"

/area/medical/virology
	name = "\improper Virology Lab"

//////////////////////////////////////
//			LOGISTICS				//
//////////////////////////////////////

/area/logistics
	icon_state = "yellow"

/area/logistics/desk
	name = "\improper Logistics Office"

/area/logistics/storage
	name = "\improper Logistics Storage"

/area/logistics/loading
	name = "\improper Loading Bay"

/area/supply/dock
	name = "Supply Shuttle"
	icon_state = "shuttle3"
	requires_power = 0

//////////////////////////////////////
//			MAINTENANCE				//
//////////////////////////////////////

/area/maintenance/primary/fs
	name = "\improper Fore Starboard Maintenance"
	icon_state = "fsmaint"

/area/maintenance/primary/fp
	name = "\improper Fore Port Maintenance"
	icon_state = "fpmaint"

/area/maintenance/primary/sec
	name = "\improper Security Maintenance"
	icon_state = "maint_security_starboard"

/area/maintenance/primary/cargo
	name = "\improper Cargo Maintenance"
	icon_state = "maint_cargo"

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

/area/planet/jungle/southruins

/area/planet/jungle/northruins

/area/planet/jungle/southeastruins

/area/planet/jungle/southwild
	dynamic_lighting = FALSE

/area/planet/jungle/northwild
	dynamic_lighting = FALSE

/area/planet/jungle/northeastwild
	dynamic_lighting = FALSE

/area/planet/jungle/southeastwild
	dynamic_lighting = FALSE

/area/planet/jungle/river
	dynamic_lighting = FALSE

/area/planet/jungle/plains
	dynamic_lighting = FALSE

/area/planet/jungle/shack
	name = "\improper Makeshift Building"

/area/planet/jungle/shuttle
