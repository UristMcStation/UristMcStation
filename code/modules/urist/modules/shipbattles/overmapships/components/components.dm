//components, weapons, shields and stuff

/datum/shipcomponents
	var/name = "component"
	var/health = 100
	var/mob/living/simple_animal/hostile/overmapship/mastership = null
	var/broken = FALSE
	var/targeted = FALSE
	var/last_activation = null

/datum/shipcomponents/proc/BlowUp()
//	qdel(src)
	mastership.health -= 100
	broken = TRUE
	targeted = FALSE
	name = "destroyed [initial(name)]"
	if(mastership.health <= 0)
		mastership.shipdeath()
	return

/datum/shipcomponents/proc/DoActivate()
	return

/datum/shipcomponents/proc/GetInitial(initial_thing)
	return initial(initial_thing)

//shields

/datum/shipcomponents/shield
	var/strength = 0
	var/recharge_rate = 0 //how much do we recharge each recharge_delay
	var/recharging = 0 //are we waiting for the next recharge delay?
	var/recharge_delay = 5 SECONDS //how long do we wait between recharges
	var/overcharged = FALSE //only for stations, we stop torpedos from doing hull damage. they can still hurt components though
	var/recovery_threashold = 0	//The amount of total recharge needed to recover the shields once offline. Ie a value of 100 requires 100 shield strength to be recharged before the shields recover and block attacks
	var/recovery_debt = 0 //Amount of recharge remaining before shields are online

/datum/shipcomponents/shield/DoActivate()
	if(!broken && !recharging)
		if(recovery_debt)
			if(recovery_debt >= recharge_rate)
				recovery_debt -= recharge_rate
			else
				mastership.shields = min(recovery_threashold + (recharge_rate - recovery_debt),strength)	//Amount required to recharge + anything left over
				recovery_debt = 0
		else if(mastership.shields < strength)
			mastership.shields = min(mastership.shields + recharge_rate, strength)

		else
			return
		recharging = 1
		spawn(recharge_delay)
			recharging = 0

/datum/shipcomponents/shield/BlowUp()
	strength = 0
	recharge_rate = 0
	recovery_debt = 0
	mastership.shields = src.strength
	..()

/datum/shipcomponents/shield/debug
	strength = 800
	recharge_rate = 400 //super high for testing

/datum/shipcomponents/shield/light
	name = "light shield"
	strength = 750
	health = 200
	recharge_rate = 75
	recharge_delay = 10 SECONDS
	recovery_threashold = 100

/datum/shipcomponents/shield/medium
	name = "medium shield"
	strength = 1200
	health = 400
	recharge_rate = 70
	recharge_delay = 10 SECONDS
	recovery_threashold = 100

/datum/shipcomponents/shield/freighter
	name = "freighter shield"
	strength = 1000
	health = 300
	recharge_rate = 50
	recharge_delay = 10 SECONDS
	recovery_threashold = 120

/datum/shipcomponents/shield/fighter
	name = "high performance ultralight shield"
	strength = 460
	health = 100
	recharge_rate = 50
	recharge_delay = 5 SECONDS
	recovery_threashold = 60

/datum/shipcomponents/shield/fighter/pirate
	name = "salvaged ultralight shield"
	strength = 520
	health = 100
	recharge_rate = 50
	recharge_delay = 6 SECONDS
	recovery_threashold = 60

/datum/shipcomponents/shield/combat
	name = "high performance combat shield"
	strength = 1000
	health = 300
	recharge_rate = 75
	recharge_delay = 8 SECONDS
	recovery_threashold = 100

/datum/shipcomponents/shield/alien_light
	name = "light alien shield"
	strength = 400
	health = 200
	recharge_rate = 70
	recharge_delay = 5 SECONDS
	recovery_threashold = 80

/datum/shipcomponents/shield/alien_heavy
	name = "heavy alien shield"
	strength = 600
	health = 200
	recharge_rate = 70
	recharge_delay = 8 SECONDS
	recovery_threashold = 80

/datum/shipcomponents/shield/pirate_station
	name = "overcharged station shield"
	strength = 1500
	health = 500
	recharge_rate = 100
	recharge_delay = 35 SECONDS
	recovery_threashold = 150
	overcharged = TRUE

//evasion

/datum/shipcomponents/bridge

/datum/shipcomponents/engines
	var/evasion_chance = 0
	var/turns_per_move = 15 //influences how fast they move on the overmap

/datum/shipcomponents/engines/BlowUp()
	evasion_chance = 0
	..()

/datum/shipcomponents/engines/freighter
	name = "freighter engines"
	evasion_chance = 5
	health = 200
	turns_per_move = 24

/datum/shipcomponents/engines/standard
	name = "standard engines"
	evasion_chance = 10
	health = 100

/datum/shipcomponents/engines/standardlarge
	name = "large standard engines"
	evasion_chance = 8
	health = 125

/datum/shipcomponents/engines/combat
	name = "high performance combat engines"
	evasion_chance = 20
	health = 250
	turns_per_move = 10

/datum/shipcomponents/engines/fighter //for really small ships
	name = "small high performance combat engines"
	evasion_chance = 40
	health = 50
	turns_per_move = 10

/datum/shipcomponents/engines/alien_light
	name = "alien engines"
	evasion_chance = 25
	health = 150
	turns_per_move = 8

/datum/shipcomponents/engines/alien_heavy
	name = "heavy alien engines"
	evasion_chance = 15
	health = 250
	turns_per_move = 8

/datum/shipcomponents/engines/pod // nimble but weak
	name = "escape pod engines"
	evasion_chance = 20
	health = 60

//point defence

/datum/shipcomponents/point_defence
	var/intercept_chance = 0

/datum/shipcomponents/point_defence/basic
	name = "rudimentary point defence"
	intercept_chance = 5
	health = 50

/datum/shipcomponents/point_defence/light
	name = "light point defence"
	intercept_chance = 8
	health = 75

/datum/shipcomponents/point_defence/med
	name = "standard point defence"
	intercept_chance = 10
	health = 100

/datum/shipcomponents/point_defence/advanced
	name = "advanced point defence"
	intercept_chance = 15
	health = 150

/datum/shipcomponents/point_defence/alienlight
	name = "light alien point defence systems"
	intercept_chance = 17
	health = 150

/datum/shipcomponents/point_defence/alienstandard
	name = "standard alien point defence systems"
	intercept_chance = 20
	health = 200

/datum/shipcomponents/point_defence/alienheavy
	name = "advanced alien point defence systems"
	intercept_chance = 25
	health = 250
