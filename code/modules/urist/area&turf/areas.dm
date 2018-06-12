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

/area/crew_quarters/heads_dorms //Noble's Quarters, hehehe.
	name = "\improper Heads of Staff Dorms"
	icon_state = "head_quarters"

/area/storage/emergency3
	name = "\improper Escape Emergency Storage" //Because yolo
	icon_state = "emergencystorage"

/area/crew_quarters/party //needs the crewquarters before it because of gamemode code
 	name = "\improper Party Room"
 	icon_state = "yellow"

/area/centcom/scom
	name = "\improper S-COM Headquarters"

/area/centcom/antag
	name = "\improper A.N.T.A.G Base"

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

/area/shuttle/arrivals/centcom
	name = "\improper Arrival Shuttle CentComm"
	icon_state = "shuttle"

/area/engineering/singulo
	name = "\improper Engineering Singularity"
	icon_state = "engineering_workshop"

//Maintenance soundsssss
/area/maintenance
	ambience = list('sound/urist/ambience/ambimaint1.ogg', 'sound/urist/ambience/ambimaint2.ogg', 'sound/urist/ambience/ambimaint3.ogg', 'sound/urist/ambience/ambimaint4.ogg', 'sound/urist/ambience/ambimaint5.ogg')

//awaymap shit

/area/awaymission
	icon_state = "away"
	requires_power = 0
	dynamic_lighting = 0

/area/awaymission/snowventure
	name = "\improper Snowy Plains"

/area/awaymission/acerdemy
	name = "\improper Institutional Acadamy"

/area/awaymission/maze
	name = "\improper Maze"

/area/awaymission/train
	name = "\improper Train Station"

//fixing tcomms

/area/tcommsat/chamber/abandoned
	name = "\improper Abandoned Satellite"
	icon_state = "tcomsatcham"

/area/tcommsat/chamber/server
	name = "\improper Telecoms Server Room"
	icon_state = "tcomsatcham"

//Shuttlessssssss

/area/shuttle/naval1/centcom
	name = "\improper Navy Ship Centcom" //Not a WIP any longer motherfuckers
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
	dynamic_lighting = 0

//don't hate me because I'm beautiful

/area/shuttle/train/stop
	icon_state = "shuttle"

//this is where it all comes crashing down

/area/shuttle/train/go
	icon_state = "shuttle"
	requires_power = 1
	luminosity = 0
	dynamic_lighting = 1

//snow train. the hackyness is off the charts

/area/awaymission/train/snow
	name = "\improper Train"
	icon_state = "away1"
	requires_power = 1
	luminosity = 0
	dynamic_lighting = 1

//centcahm

/area/centcom/transit
	name = "\improper Centcom Transit Area"

//event shuttles

/area/shuttle/event1
	icon_state = "shuttle"
	dynamic_lighting = 0

/area/shuttle/event1/l1
	name = "\improper Event 1 - 1 "

/area/shuttle/event1/l2
	name = "\improper Event 1 - 2 "

/area/shuttle/event1/l3
	name = "\improper Event 1 - 3 "

/area/shuttle/event2
	icon_state = "shuttle"
	dynamic_lighting = 0

/area/shuttle/event2/l1
	name = "\improper Event 2 - 1 "

/area/shuttle/event2/l2
	name = "\improper Event 2 - 2 "

/area/shuttle/event2/l3
	name = "\improper Event 2 - 3 "

//elevators

/area/shuttle/elevator
	dynamic_lighting = 0

/area/shuttle/elevator/mining/surface
	name = "\improper Mining Elevator"
	icon_state = "shuttle"

/area/shuttle/elevator/research/surface
	name = "\improper Research Elevator"
	icon_state = "shuttle"

//security outpost

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

//REMEMBER THIS FOR THE MERGE //I forgot

/area/outpost/abandoned/base_turf = /turf/simulated/floor/asteroid

/area/outpost/mining_main/eva/base_turf = /turf/simulated/floor/asteroid

/area/outpost/research/eva/base_turf = /turf/simulated/floor/asteroid

/area/shuttle/mining/outpost/base_turf = /turf/simulated/floor/planet/jungle/clear

/area/shuttle/elevator/base_turf = /turf/simulated/floor/plating

/area/shuttle/constructionsite/base_turf = /turf/simulated/floor/planet/jungle/clear

/area/shuttle/securityoutpost/base_turf = /turf/simulated/floor/planet/jungle/clear