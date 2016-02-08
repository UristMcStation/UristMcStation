/area/scom/mission
	name = "\improper Mission"
	requires_power = 0
	icon_state = "away"

/area/scom/mission/lighting
	lighting_use_dynamic = 1
	icon_state = "away1"
	luminosity = 0

/area/scom/mission/lighting/New() //wtf
	..()
	lighting_use_dynamic = 1
	luminosity = 0

/area/scom/mission/nolighting
	lighting_use_dynamic = 0
	icon_state = "away2"

/turf/unsimulated/wall/urist/other
	icon = 'icons/urist/turf/scomturfs.dmi'

/turf/unsimulated/wall/urist/other/border
	icon_state = "border"
	name = ""
	desc = ""

/turf/unsimulated/wall/urist/other/see
	icon = 'icons/urist/turf/scomturfs.dmi'
	opacity = 0
	name = "alien ship"

/turf/unsimulated/floor/uristturf/other
	icon = 'icons/urist/turf/floors+.dmi'

/turf/unsimulated/floor/uristturf/other/scom
	icon = 'icons/urist/turf/scomturfs.dmi'

/turf/unsimulated/wall/urist/shuttle
	icon = 'icons/urist/turf/marine.dmi'

/turf/unsimulated/wall/urist/shuttle/see
	opacity = 0

/turf/unsimulated/floor/uristturf/shuttle
	icon = 'icons/urist/turf/marine.dmi'

//shuttle areas

/area/shuttle/scom
	name = "\improper S-COM shuttle"
	icon_state = "shuttle"
	requires_power = 0
	lighting_use_dynamic = 0

/area/shuttle/scom/s1/base //todo, maybe make a mission var here to reduce this path spam

/area/shuttle/scom/s1/mission

/area/shuttle/scom/s1/mission0

/area/shuttle/scom/s1/mission1

/area/shuttle/scom/s1/mission2

/area/shuttle/scom/s1/mission3

/area/shuttle/scom/s1/mission4

/area/shuttle/scom/s1/mission5

/area/shuttle/scom/s1/mission6

/area/shuttle/scom/s1/mission7


/area/shuttle/scom/s1/mission11

/area/shuttle/scom/s1/mission12

/area/shuttle/scom/s1/mission13

/area/shuttle/scom/s1/mission14

/area/shuttle/scom/s1/mission15

//ftfg

/area/shuttle/scom/s2/base

/area/shuttle/scom/s2/mission

/area/shuttle/scom/s2/mission0

/area/shuttle/scom/s2/mission1

/area/shuttle/scom/s2/mission2

/area/shuttle/scom/s2/mission3

/area/shuttle/scom/s2/mission4

/area/shuttle/scom/s2/mission5

/area/shuttle/scom/s2/mission6

/area/shuttle/scom/s2/mission7


/area/shuttle/scom/s2/mission11

/area/shuttle/scom/s2/mission12

/area/shuttle/scom/s2/mission13

/area/shuttle/scom/s2/mission14

/area/shuttle/scom/s2/mission15

