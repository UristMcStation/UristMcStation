/*Urist McStation Areas!

Basically, if you need to add areas for UMcS, use this file -Glloyd */

//UMcS unique Areas

/area/hallway/secondary/entry
	name = "\improper Arrival Shuttle Hallway"
	icon_state = "entry_1"

/area/tcommsat/pirate
	name = "\improper Pirate Server Room"
	icon_state = "tcomsatcham"

/area/crew_quarters/pool
	name = "\improper Pool"
	icon_state = "bluenew"

/area/crew_quarters/lounge
	name = "\improper Lounge"
	icon_state = "lounge"

/area/bridge/meeting_hall
	name = "\improper Meeting Hall"
	icon_state = "bridge"
	music = null

/area/crew_quarters/heads_dorms //Noble's Quarters, hehehe.
	name = "\improper Heads of Staff Dorms"
	icon_state = "head_quarters"

/area/storage/emergency3
	name = "\improper Escape Emergency Storage" //Because yolo
	icon_state = "emergencystorage"

/area/construction/assemblyline
	name = "\improper Abandoned Assembly Line"
	icon_state = "ass_line"

/area/crew_quarters/party //needs the crewquarters before it because of gamemode code
 	name = "\improper Party Room"
 	icon_state = "yellow"

/area/security/gaschamber //someday...
	name = "\improper Gas Chamber"
	icon_state = "brig"

/area/centcom/scom
	name = "\improper S-COM Headquarters"

/area/centcom/antag
	name = "\improper A.N.T.A.G Base"

/area/derelict/satellite
	name = "\improper Abandoned Satellite"
	icon_state = "yellow"

/area/medical/lounge
	name = "\improper Medbay Lounge"
	icon_state = "medbay2"

/area/medical/psychoffice
	name = "\improper Psychologist's Office"
	icon_state = "medbay3"

/area/crew_quarters/sleep/sci
	name = "\improper Research Dormitories"
	icon_state = "Sleep"

/area/crew_quarters/sleep/med
	name = "\improper Medbay Dormitories"
	icon_state = "Sleep"

/area/crew_quarters/sleep/engi
	name = "\improper Engineering Dormitories"
	icon_state = "Sleep"

/area/crew_quarters/sleep/sec
	name = "\improper Security Dormitories"
	icon_state = "Sleep"

/area/bridge/blueshield
	name = "\improper Blueshield's Office"

/area/quartermaster/carpenter
	name = "\improper Carpenter's Workshop"
	icon_state = "dark128"

/area/quartermaster/hunter
	name = "\improper Hunter's Workshop"
	icon_state = "dark160"

/area/shuttle/arrivals/station
	icon_state = "shuttle"
	name = "\improper Arrival Shuttle Station"

/area/shuttle/arrivals/centcom
	name = "\improper Arrival Shuttle CentComm"
	icon_state = "shuttle"

/area/shuttle/arrivals/transit
	name = "\improper Arrival Shuttle Transit"
	icon_state = "shuttle"

/area/engineering/singulo
	name = "\improper Engineering Singularity"
	icon_state = "engineering_workshop"

//Maintenance soundsssss
/area/maintenance
	ambience = list('sound/urist/ambience/ambimaint1.ogg', 'sound/urist/ambience/ambimaint2.ogg', 'sound/urist/ambience/ambimaint3.ogg', 'sound/urist/ambience/ambimaint4.ogg', 'sound/urist/ambience/ambimaint5.ogg')

//awaymap shit

/area/awaymission/snowventure
	name = "\improper Snowy Plains"
	icon_state = "away"
	requires_power = 0
	lighting_use_dynamic = 0

/area/awaymission/acerdemy
	name = "\improper Institutional Acadamy"
	icon_state = "away"
	requires_power = 0
	lighting_use_dynamic = 0

/area/awaymission/maze
	name = "\improper Maze"
	icon_state = "away"
	requires_power = 0
	lighting_use_dynamic = 0

/area/awaymission/train
	name = "\improper Train Station"
	icon_state = "away"
	requires_power = 0
	lighting_use_dynamic = 0

//fixing tcomms

/area/tcommsat/chamber/abandoned
	name = "\improper Abandoned Satellite"
	icon_state = "tcomsatcham"

/area/tcommsat/chamber/server
	name = "\improper Telecoms Server Room"
	icon_state = "tcomsatcham"

//Shuttlessssssss

/area/shuttle/pirate1/centcom
	name = "\improper Pirate Ship Centcom" //WIP
	icon_state = "shuttle"

/area/shuttle/pirate1/station
	name = "\improper Pirate Ship"
	icon_state = "shuttle"

/area/shuttle/naval1/centcom
	name = "\improper Navy Ship Centcom" //Not a WIP any longer motherfuckers
	icon_state = "shuttle"

/area/shuttle/naval1/station
	name = "\improper Navy Ship"
	icon_state = "shuttle"

/area/shuttle/naval1/event1
	name = "\improper Navy Ship1"
	icon_state = "shuttle"

/area/shuttle/naval1/event2
	name = "\improper Navy Ship2"
	icon_state = "shuttle"

/area/shuttle/naval1/event3
	name = "\improper Navy Ship3"
	icon_state = "shuttle"

/area/shuttle/naval1
	lighting_use_dynamic = 0

//don't hate me because I'm beautiful

/area/shuttle/train/stop
	icon_state = "shuttle"

//this is where it all comes crashing down

/area/shuttle/train/go
	icon_state = "shuttle"
	requires_power = 1
	luminosity = 0
	lighting_use_dynamic = 1

//snow train. the hackyness is off the charts

/area/awaymission/train/snow
	name = "\improper Train"
	icon_state = "away1"
	requires_power = 1
	lighting_use_dynamic = 1
	luminosity = 0

//centcahm

/area/centcom/transit
	name = "\improper Centcom Transit Area"

//event shuttles

/area/shuttle/event1
	icon_state = "shuttle"
	lighting_use_dynamic = 0

/area/shuttle/event1/l1
	name = "\improper Event 1 - 1 "

/area/shuttle/event1/l2
	name = "\improper Event 1 - 2 "

/area/shuttle/event1/l3
	name = "\improper Event 1 - 3 "

/area/shuttle/event2
	icon_state = "shuttle"
	lighting_use_dynamic = 0

/area/shuttle/event2/l1
	name = "\improper Event 2 - 1 "

/area/shuttle/event2/l2
	name = "\improper Event 2 - 2 "

/area/shuttle/event2/l3
	name = "\improper Event 2 - 3 "

//elevators

/area/shuttle/elevator
	lighting_use_dynamic = 0

/area/shuttle/elevator/mining/surface
	name = "\improper Mining Elevator"
	icon_state = "shuttle"

/area/shuttle/elevator/mining/underground
	name = "\improper Mining Elevator"
	icon_state = "shuttle"

/area/shuttle/elevator/research/surface
	name = "\improper Research Elevator"
	icon_state = "shuttle"

/area/shuttle/elevator/research/underground
	name = "\improper Research Elevator"
	icon_state = "shuttle"

//security outpost

/area/shuttle/securityoutpost/station
	name = "\improper Security Outpost Shuttle Station"
	icon_state = "shuttle"
	lighting_use_dynamic = 0
	base_turf = /turf/space

/area/shuttle/securityoutpost/outpost
	name = "\improper Security Outpost Shuttle Outpost"
	icon_state = "shuttle"
	lighting_use_dynamic = 0
	base_turf = /turf/simulated/jungle/clear

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

//REMEMBER THIS FOR THE MERGE

/area/outpost/base_turf = /turf/simulated/jungle/clear

/area/outpost/abandoned/base_turf = /turf/simulated/floor/plating/airless/asteroid

/area/outpost/mining_main/eva/base_turf = /turf/simulated/floor/plating/airless/asteroid

/area/outpost/research/eva/base_turf = /turf/simulated/floor/plating/airless/asteroid

/area/shuttle/mining/outpost/base_turf = /turf/simulated/jungle/clear

/area/shuttle/research/outpost/base_turf = /turf/simulated/jungle/clear

/area/shuttle/elevator/base_turf = /turf/simulated/floor/plating

/area/shuttle/constructionsite/base_turf = /turf/simulated/jungle/clear

/area/shuttle/securityoutpost/base_turf = /turf/simulated/jungle/clear