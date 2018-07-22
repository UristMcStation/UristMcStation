//components, weapons, shields and stuff

/datum/shipcomponents
	var/name = "component"
	var/health = 100

/datum/shipcomponents/shield

/datum/shipcomponents/bridge

/datum/shipcomponents/engines

/datum/shipcomponents/weapons
	var/shielddamage = 0 //how much damage do we do to shields
	var/passshield = 0 //do we go through shields to hit the hull?
	var/hulldamage = 1
	var/firedelay = 0 //how long do we take to fire again

/datum/shipcomponents/weapons/proc/Fire()
	return

/datum/shipcomponents/weapons/ioncannon
	shielddamage = 300 //needs testing