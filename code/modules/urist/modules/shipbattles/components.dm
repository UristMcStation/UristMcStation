//components, weapons, shields and stuff

/datum/shipcomponents
	var/name = "component"
	var/health = 100
	var/mob/living/simple_animal/hostile/overmapship/mastership = null
	var/broken = FALSE

/datum/shipcomponents/proc/BlowUp()
//	qdel(src)
	mastership.health -= 100
	broken = TRUE
	name = "destroyed [initial(name)]"
	return

//shields

/datum/shipcomponents/shield
	var/strength = 0
	var/recharge_rate = 0 //how much do we recharge each recharge_delay
	var/recharging = 0 //are we waiting for the next recharge delay?
	var/recharge_delay = 5 SECONDS //how long do we wait between recharges

/datum/shipcomponents/shield/debug
	strength = 800
	recharge_rate = 400 //super high for testing

/datum/shipcomponents/shield/light
	name = "light shield"
	strength = 800
	health = 200
	recharge_rate = 80
	recharge_delay = 10 SECONDS

/datum/shipcomponents/shield/freighter
	name = "freighter shield"
	strength = 1000
	health = 300
	recharge_rate = 50
	recharge_delay = 10 SECONDS

/datum/shipcomponents/shield/fighter
	name = "light shield"
	strength = 400
	health = 100
	recharge_rate = 50
	recharge_delay = 5 SECONDS

//evasion

/datum/shipcomponents/bridge

/datum/shipcomponents/engines
	var/evasion_chance = 0

/datum/shipcomponents/engines/freighter
	name = "freighter engines"
	evasion_chance = 5

/datum/shipcomponents/engines/standard
	name = "standard engines"
	evasion_chance = 10

/datum/shipcomponents/engines/combat
	name = "high performance combat engines"
	evasion_chance = 20

/datum/shipcomponents/engines/fighter //for really small ships
	name = "small high performance combat engines"
	evasion_chance = 40
