//////////////////////////////////////////////////////////////
//															//
//					Galactic		Crisis					//
//															//
//////////////////////////////////////////////////////////////

//nah, jk

/datum/ships
	var/name = "NMV Glloyd"
	var/health = 1000
	var/shields = 1000
	var/list/components = list()
//	var/weapon2
	var/boardingmap = null
	var/faction = "neutral"
//	var/salvagemap = null
//	var/playership = 0

//debug ship
/datum/ships/debug
	name = "debug ship"
	components = list(
		new /datum/shipcomponents/shield,
		new /datum/shipcomponents/weapons/ioncannon
	)
	boardingmap = "test.dmm"
	faction = "hostile"

/datum/ships/piratesmall
	name = "small pirate vessel"
	components = list()
	boardingmap = "piratesmall.dmm"
	faction = "pirate"