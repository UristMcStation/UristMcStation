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

/area/civilian/bar
	name = "\improper Bar"

/area/civilian/freezer
	name = "\improper Kitchen Freezer"

/area/civilian/hydro
	name = "\improper Hydroponics"

/area/civilian/holodeck
	name = "\improper Holodeck"

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

/area/engineering/tcomms
	name = "\improper Telecommunications Server"

/area/engineering/tcommsmon
	name = "\improper Telecommunication Monitoring Room"

/area/engineering/extsubmaint
	name = "\improper External Sub Deck Engine Maintenance"

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