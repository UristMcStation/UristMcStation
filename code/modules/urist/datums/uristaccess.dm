//dammit Bay
var/global/const/access_court = "ACCESS_COURT" //51
/datum/access/court
	id = access_court
	desc = "Courtroom"
	region = ACCESS_REGION_SECURITY

var/global/const/access_clown = "ACCESS_CLOWN" //43
/datum/access/clown
	id = access_clown
	desc = "HONK! Access"

var/global/const/access_mime = "ACCESS_MIME" //44
/datum/access/mime
	id = access_mime
	desc = "Silent Access"

var/global/const/access_theatre = "ACCESS_THEATRE" //46
/datum/access/theatre
	id = access_theatre
	desc = "Theatre"
	region = ACCESS_REGION_GENERAL

var/global/const/access_blueshield = "ACCESS_BLUESHIELD" //52
/datum/access/blueshield
	id = access_blueshield
	desc = "Blueshield Access"
	region = ACCESS_REGION_COMMAND
