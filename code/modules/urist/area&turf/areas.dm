// This file is for areas that are either shared across all maps, or for runtime loaded event maps.

//Maintenance soundsssss
/area/maintenance
	ambience = list('sound/urist/ambience/ambimaint1.ogg', 'sound/urist/ambience/ambimaint2.ogg', 'sound/urist/ambience/ambimaint3.ogg', 'sound/urist/ambience/ambimaint4.ogg', 'sound/urist/ambience/ambimaint5.ogg')

//awaymap shit

/area/awaymission
	icon_state = "away"
	requires_power = 0
	dynamic_lighting = 0

//Currently unused code. Uncomment if/when needed
/*
/area/awaymission/snowventure
	name = "\improper Snowy Plains"

/area/awaymission/acerdemy
	name = "\improper Institutional Acadamy"
*/

/area/awaymission/maze
	name = "\improper Maze"

/area/awaymission/train
	name = "\improper Train Station"

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
