/mob/living/simple_animal/hostile/overmapship //maybe do components as objects instead of datums
//	var/shipdatum = /datum/ships
	var/shields = 0
	var/firedelay = 100
	var/designation = "FFS"
	var/ship_category = "debug ship"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "ship"
	icon_living = "ship"
	icon_dead = "ship"
	var/boardingmap = "ship_blank.dmm"
	var/list/components = list()
	var/incombat = 0
	var/aggressive = 0 //will always attack
	var/obj/effect/overmap/ship/combat/target_ship

/mob/living/simple_animal/hostile/overmapship/New()
	..()

	for(var/datum/shipcomponents/C in src.components)
		C.mastership = src

	for(var/datum/shipcomponents/shield/S in src.components)
		shields = S.strength
		return

//	var/datum/ships/SD = shipdatum

//	src.shields = SD.shields
//	src.health = SD.health
//	src.faction = SD.faction
//	src.name = SD.name

/mob/living/simple_animal/hostile/overmapship/Crossed(O as obj)
	..()

	if(istype(O, /obj/effect/overmap/ship/combat))
		var/obj/effect/overmap/ship/combat/L = O
		if(!L.incombat && !L.crossed)
			L.Contact(src)

		else
			return


/mob/living/simple_animal/hostile/overmapship/Life() //here we do the attacking stuff. i hate that this is life, but fuck.
	if(incombat)
		shipfire()

	for(var/datum/shipcomponents/shield/S in src.components)
		if(!S.broken && !S.recharging)
			if(shields <= S.strength)
				shields += S.recharge_rate
				if(shields >= S.strength)
					shields = S.strength

				S.recharging = 1
				spawn(S.recharge_delay)
					S.recharging = 0

	..()


/mob/living/simple_animal/hostile/overmapship/proc/spawnmap()
	for(var/obj/effect/template_loader/ships/S in GLOB.trigger_landmarks) //there can only ever be one of these atm
		S.mapfile = src.boardingmap
		S.Load()
	return

/mob/living/simple_animal/hostile/overmapship/proc/despawnmap()
	for(var/obj/effect/template_loader/ships/S in GLOB.trigger_landmarks) //there can only ever be one of these atm
		S.mapfile = "ship_blank.dmm"
		S.Load()
	return

/mob/living/simple_animal/hostile/overmapship/death()
	despawnmap()
	adjustBruteLoss(maxHealth)
	target_ship.leave_combat()
	qdel(src)

/mob/living/simple_animal/hostile/overmapship/proc/shipfire()
	for(var/datum/shipcomponents/weapons/W in src.components)
		if(W.ready && !W.broken)
			W.Fire()

/mob/living/simple_animal/hostile/overmapship/debug
//	shipdatum = /datum/ships/debug
	shields = 800
	maxHealth = 800
	health = 800
	wander = 1
	aggressive = 1

/mob/living/simple_animal/hostile/overmapship/debug/New() //light shield for now to mess with some debug stuff
	components = list(
		new /datum/shipcomponents/shield/light,
		new /datum/shipcomponents/weapons/ioncannon,
		new /datum/shipcomponents/weapons/autocannon,
		new /datum/shipcomponents/weapons/lightlaser,
		new /datum/shipcomponents/weapons/smallmissile/battery,
		new /datum/shipcomponents/engines/standard
	)

	..()

/mob/living/simple_animal/hostile/overmapship/pirate
	wander = 1 //temporary
	color = "#660000"
	hiddenfaction = "pirates"
	aggressive = 1

/mob/living/simple_animal/hostile/overmapship/pirate/small
//	shipdatum = /datum/ships/piratesmall
	shields = 800
	health = 800
	maxHealth = 800
	name = "small pirate ship"
	ship_category = "small pirate ship"

/mob/living/simple_animal/hostile/overmapship/pirate/small/New()
	components = list(
		new /datum/shipcomponents/shield/light,
		new /datum/shipcomponents/engines/standard,
		new /datum/shipcomponents/weapons/smallmissile
	)

	if(prob(50))
		components += new /datum/shipcomponents/weapons/autocannon

	else
		components += new /datum/shipcomponents/weapons/lightlaser/auto

	..()

/mob/living/simple_animal/hostile/overmapship/pirate/med
//	shipdatum = /datum/ships/piratesmall
	shields = 2000
	health = 1000
	maxHealth = 1000
	name = "pirate vessel"
	ship_category = "medium pirate vessel"

/mob/living/simple_animal/hostile/overmapship/pirate/med/New()
	components = list(
		new /datum/shipcomponents/shield/medium,
		new /datum/shipcomponents/engines/standard,
		new /datum/shipcomponents/weapons/smallmissile/battery,
		new /datum/shipcomponents/weapons/heavylaser,
		new /datum/shipcomponents/weapons/autocannon
	)

/mob/living/simple_animal/hostile/overmapship/nanotrasen
	color = "#4286f4"
	wander = 1 //temporary
	hiddenfaction = "nanotrasen"

/mob/living/simple_animal/hostile/overmapship/nanotrasen/ntmerchant
//	shipdatum = /datum/ships/nanotrasen/ntmerchant
	name = "Nanotrasen merchant ship"
	shields = 1000
	health = 800
	maxHealth = 800
	ship_category = "NanoTrasen merchant ship"

/mob/living/simple_animal/hostile/overmapship/nanotrasen/ntmerchant/New()
	components = list(
		new /datum/shipcomponents/shield/freighter,
		new /datum/shipcomponents/weapons/lightlaser,
		new /datum/shipcomponents/engines/freighter
	)

	..()

/mob/living/simple_animal/hostile/overmapship/nanotrasen/patrol
	name = "Nanotrasen patrol ship"
	shields = 3000
	health = 1600
	maxHealth = 1600
	ship_category = "NanoTrasen patrol ship"
