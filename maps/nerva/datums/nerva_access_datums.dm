var/global/const/access_fo = "ACCESS_FIRST_OFFICER" //73
/datum/access/fo
	id = access_fo
	desc = "First Officer"
	region = ACCESS_REGION_COMMAND

var/global/const/access_expedition_shuttle_helm = "ACCESS_TRAJAN_HELM" //74
/datum/access/exploration_shuttle_helm
	id = access_expedition_shuttle_helm
	desc = "Trajan Helm"
	region = ACCESS_REGION_GENERAL

var/global/const/access_expedition = "ACCESS_EXPEDITION" //75
/datum/access/expedition_prep
	id = access_expedition
	desc = "Expedition Prep"
	region = ACCESS_REGION_SUPPLY

/datum/access/robotics
	region = ACCESS_REGION_SUPPLY

/datum/access/blueshield
	desc = "Bodyguard Access"

/datum/access/rd
	access_type = ACCESS_TYPE_NONE

/datum/access/gateway
	access_type = ACCESS_TYPE_NONE

/datum/access/hop
	desc = "Personnel Office"

/datum/access/hos
	desc = "Chief of Security"

var/global/const/access_seniornt = "ACCESS_SENIOR_NT_OFFICE" //76
/datum/access/seniornt
	id = access_seniornt
	desc = "Senior Researcher"
	access_type = ACCESS_TYPE_NONE
	region = ACCESS_REGION_RESEARCH

var/global/const/access_gunnery = "ACCESS_GUNNERY"
/datum/access/gunnery
	id = access_gunnery
	desc = "Gunnery"
	region = ACCESS_REGION_COMMAND

/datum/access/chapel_office
	region = ACCESS_REGION_SERVICE

/datum/access/bar
	region = ACCESS_REGION_SERVICE

/datum/access/kitchen
	region = ACCESS_REGION_SERVICE

/datum/access/eva
	region = ACCESS_REGION_GENERAL

/datum/access/crematorium
	region = ACCESS_REGION_MEDBAY

/datum/access/janitor
	region = ACCESS_REGION_SERVICE

/datum/access/cmo
	region = ACCESS_REGION_MEDBAY

/datum/access/tcomsat
	region = ACCESS_REGION_ENGINEERING

/datum/access/pilot
	region = ACCESS_REGION_NONE

var/global/const/access_prim_tool = "ACCESS_GENERAL_STORAGE"
/datum/access/prim_tool
	id = access_prim_tool
	desc = "General Storage"
	region = ACCESS_REGION_GENERAL