//components, weapons, shields and stuff

/datum/shipcomponents
	var/name = "component"
	var/health = 100
	var/mob/living/simple_animal/hostile/overmapship/mastership = null
	var/broken = FALSE
	var/targeted = TRUE
	var/last_activation = null

/datum/shipcomponents/proc/BlowUp()
//	qdel(src)
	mastership.health -= 100
	broken = TRUE
	name = "destroyed [initial(name)]"
	if(mastership.health <= 0)
		mastership.shipdeath()
	return

/datum/shipcomponents/proc/DoActivate()
	return

/datum/shipcomponents/proc/GetInitial(var/initial_thing)
	return initial(initial_thing)

//shields

/datum/shipcomponents/shield
	var/strength = 0
	var/recharge_rate = 0 //how much do we recharge each recharge_delay
	var/recharging = 0 //are we waiting for the next recharge delay?
	var/recharge_delay = 5 SECONDS //how long do we wait between recharges
	var/overcharged = FALSE //only for stations, we stop torpedos from doing hull damage. they can still hurt components though

/datum/shipcomponents/shield/DoActivate()
	if(!broken && !recharging)
		if(mastership.shields <= strength)
			mastership.shields += recharge_rate
			if(mastership.shields >= strength)
				mastership.shields = strength

			recharging = 1
			spawn(recharge_delay)
				recharging = 0

/datum/shipcomponents/shield/BlowUp()
	strength = 0
	recharge_rate = 0
	mastership.shields = src.strength
	..()

/datum/shipcomponents/shield/debug
	strength = 800
	recharge_rate = 400 //super high for testing

/datum/shipcomponents/shield/light
	name = "light shield"
	strength = 800
	health = 200
	recharge_rate = 80
	recharge_delay = 10 SECONDS

/datum/shipcomponents/shield/medium
	name = "medium shield"
	strength = 1200
	health = 400
	recharge_rate = 70
	recharge_delay = 10 SECONDS

/datum/shipcomponents/shield/freighter
	name = "freighter shield"
	strength = 1000
	health = 300
	recharge_rate = 50
	recharge_delay = 10 SECONDS

/datum/shipcomponents/shield/fighter
	name = "high performance ultralight shield"
	strength = 400
	health = 100
	recharge_rate = 50
	recharge_delay = 5 SECONDS

/datum/shipcomponents/shield/alien_light
	name = "light alien shield"
	strength = 200
	health = 200
	recharge_rate = 60
	recharge_delay = 5 SECONDS

/datum/shipcomponents/shield/alien_heavy
	name = "heavy alien shield"
	strength = 500
	health = 200
	recharge_rate = 60
	recharge_delay = 8 SECONDS

/datum/shipcomponents/shield/pirate_station
	name = "overcharged station shield"
	strength = 1500
	health = 500
	recharge_rate = 100
	recharge_delay = 35 SECONDS
	overcharged = TRUE

//evasion

/datum/shipcomponents/bridge

/datum/shipcomponents/engines
	var/evasion_chance = 0

/datum/shipcomponents/engines/BlowUp()
	evasion_chance = 0
	..()

/datum/shipcomponents/engines/freighter
	name = "freighter engines"
	evasion_chance = 5
	health = 200

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

/datum/shipcomponents/engines/fighter //for really small ships
	name = "small high performance combat engines"
	evasion_chance = 40
	health = 50

/datum/shipcomponents/engines/alien_light
	name = "alien engines"
	evasion_chance = 25
	health = 150

/datum/shipcomponents/engines/alien_heavy
	name = "heavy alien engines"
	evasion_chance = 15
	health = 250

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

