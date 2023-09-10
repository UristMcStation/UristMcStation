/area/spacestations
	icon_state = "blueold"

/area/spacestations/nanotrasenspace
	name = "NanoTrasen Space Station"

//nt station shuttle area

/area/spacestations/ntminingshuttle
	name = "Nanotrasen Mining Shuttle"
	icon_state = "shuttle"
	requires_power = 0
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/spacestations/ntminingshuttle/start
	name = "\improper Mining Shuttle"
	icon_state = "shuttle"

//access

var/global/const/access_away_trading_station = "ACCESS_AWAY_TRADING_STATION"
/datum/access/away_trading_station
	id = access_away_trading_station
	desc = "Trading Station"
	access_type = ACCESS_TYPE_NONE
	region = ACCESS_REGION_NONE
