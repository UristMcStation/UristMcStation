
//ships

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
	hiddenfaction = "pirate"
	aggressive = 1

/mob/living/simple_animal/hostile/overmapship/pirate/small
//	shipdatum = /datum/ships/piratesmall
	shields = 800
	health = 800
	maxHealth = 800
	name = "small pirate ship"
	ship_category = "small pirate ship"
	boardingmap = "maps/shipmaps/ship_pirate_small1.dmm"
	can_board = TRUE

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
	boardingmap = "maps/shipmaps/ship_pirate_small1.dmm"
	can_board = TRUE

/mob/living/simple_animal/hostile/overmapship/pirate/med/New()
	components = list(
		new /datum/shipcomponents/shield/medium,
		new /datum/shipcomponents/engines/standard,
		new /datum/shipcomponents/weapons/smallmissile/battery,
		new /datum/shipcomponents/weapons/heavylaser,
		new /datum/shipcomponents/weapons/autocannon,
		new /datum/shipcomponents/point_defence/basic
	)

/mob/living/simple_animal/hostile/overmapship/nanotrasen
	color = "#4286f4"
	wander = 1 //temporary
	hiddenfaction = "nanotrasen"

/mob/living/simple_animal/hostile/overmapship/nanotrasen/ntmerchant
//	shipdatum = /datum/ships/nanotrasen/ntmerchant
	name = "NanoTrasen merchant ship"
	shields = 1000
	health = 800
	maxHealth = 800
	ship_category = "NanoTrasen merchant ship"
	can_board = TRUE

/mob/living/simple_animal/hostile/overmapship/nanotrasen/ntmerchant/New()
	components = list(
		new /datum/shipcomponents/shield/freighter,
		new /datum/shipcomponents/weapons/lightlaser,
		new /datum/shipcomponents/engines/freighter
	)

	..()

/mob/living/simple_animal/hostile/overmapship/nanotrasen/patrol
	name = "NanoTrasen patrol ship"
	shields = 3000
	health = 1600
	maxHealth = 1600
	ship_category = "NanoTrasen patrol ship"


/mob/living/simple_animal/hostile/overmapship/nanotrasen/fast_attack
	name = "NanoTrasen fast attack craft"
	shields = 3000
	health = 500
	maxHealth = 1000
	ship_category = "NanoTrasen fast attack craft"

/mob/living/simple_animal/hostile/overmapship/nanotrasen/fast_attack/New()
	components = list(
		new /datum/shipcomponents/shield/fighter,
		new /datum/shipcomponents/weapons/lightlaser/dual,
		new /datum/shipcomponents/weapons/lightlaser/dual,
		new /datum/shipcomponents/engines/fighter,
		new /datum/shipcomponents/weapons/smallmissile/battery,
		new /datum/shipcomponents/weapons/autocannon,
		new /datum/shipcomponents/point_defence/light
	)

	..()

/mob/living/simple_animal/hostile/overmapship/alien
	wander = 1
	color = "#660000"
	hiddenfaction = "alien"
	aggressive = 1
	name = "Unknown"
	designation = ""

/mob/living/simple_animal/hostile/overmapship/alien/small
	shields = 200 //really weak, but fast charging shields
	health = 1200 //and beefy hulls
	maxHealth = 1200
	ship_category = "Lactera fast attack craft"
	boardingmap = "maps/shipmaps/ship_lactera_small.dmm"
	can_board = TRUE

/mob/living/simple_animal/hostile/overmapship/alien/small/New() //we'll see
	components = list(
		new /datum/shipcomponents/shield/alien_light,
		new /datum/shipcomponents/engines/alien_light,
		new /datum/shipcomponents/weapons/alien/light,
		new /datum/shipcomponents/weapons/alien/light,
		new /datum/shipcomponents/weapons/alien/heavy,
		new /datum/shipcomponents/weapons/smallalienmissile,
		new /datum/shipcomponents/weapons/smallalienmissile,
		new /datum/shipcomponents/point_defence/alienlight
	)

	..()

/mob/living/simple_animal/hostile/overmapship/alien/heavy //you have to board this motherfucker
	shields = 500 //really weak, but fast charging shields
	health = 2200 //and beefy hulls
	maxHealth = 2200
	ship_category = "Lactera frigate"
	boardingmap = "maps/shipmaps/ship_lactera_large.dmm"
	can_board = TRUE

/mob/living/simple_animal/hostile/overmapship/alien/heavy/New() //only for admemes. this will fuck your day up.
	components = list(
		new /datum/shipcomponents/shield/alien_heavy,
		new /datum/shipcomponents/engines/alien_heavy,
		new /datum/shipcomponents/weapons/alien/light,
		new /datum/shipcomponents/weapons/alien/heavy/burst,
		new /datum/shipcomponents/weapons/alien/heavy/burst,
		new /datum/shipcomponents/weapons/bigalienmissile,
		new /datum/shipcomponents/weapons/bigalienmissile,
		new /datum/shipcomponents/weapons/smallalienmissile/battery,
		new /datum/shipcomponents/weapons/alientorpedo,
		new /datum/shipcomponents/point_defence/alienstandard
	)

	..()

//terran

/mob/living/simple_animal/hostile/overmapship/terran
	color = "#9932cc"
//	wander = 1 //temporary
	hiddenfaction = "terran"

/mob/living/simple_animal/hostile/overmapship/terran/tcmerchant
//	shipdatum = /datum/ships/nanotrasen/ntmerchant
	name = "Terran Confederacy merchant ship"
	shields = 1000
	health = 800
	maxHealth = 800
	ship_category = "Terran Confederacy merchant ship"
	boardingmap = "maps/shipmaps/ship_light_freighter.dmm"
	can_board = TRUE

/mob/living/simple_animal/hostile/overmapship/terran/tcmerchant/New()
	components = list(
		new /datum/shipcomponents/shield/freighter,
		new /datum/shipcomponents/weapons/lightlaser,
		new /datum/shipcomponents/engines/freighter
	)

	..()

/mob/living/simple_animal/hostile/overmapship/terran/patrol
	name = "Terran Confederacy patrol ship"
	shields = 3000
	health = 1600
	maxHealth = 1600
	ship_category = "Terran Confederacy patrol ship"

/mob/living/simple_animal/hostile/overmapship/terran/fast_attack
	name = "Terran Confederacy fast attack craft"
	shields = 3000
	health = 500
	maxHealth = 1000
	ship_category = "Terran Confederacy fast attack craft"
	boardingmap = "maps/shipmaps/ship_fastattackcraft_terran.dmm"
	can_board = TRUE

/mob/living/simple_animal/hostile/overmapship/terran/fast_attack/New()
	components = list(
		new /datum/shipcomponents/shield/fighter,
		new /datum/shipcomponents/weapons/lightlaser/dual,
		new /datum/shipcomponents/weapons/lightlaser/dual,
		new /datum/shipcomponents/engines/fighter,
		new /datum/shipcomponents/weapons/smallmissile/battery,
		new /datum/shipcomponents/point_defence/light
	)

	..()

//rebels

/mob/living/simple_animal/hostile/overmapship/rebel
	color = "#cd0000" //Boston University Red, also known as the red on the flag of the USSR
	hiddenfaction = "rebel"

/mob/living/simple_animal/hostile/overmapship/rebel/fast_attack
	name = "rebel fast attack craft"
	shields = 3000
	health = 500
	maxHealth = 1000
	ship_category = "rebel fast attack craft"
	boardingmap = "maps/shipmaps/ship_rebel_small1.dmm"
	can_board = TRUE

/mob/living/simple_animal/hostile/overmapship/rebel/fast_attack/New()
	components = list(
		new /datum/shipcomponents/shield/fighter,
		new /datum/shipcomponents/weapons/lightlaser/dual,
		new /datum/shipcomponents/weapons/lightlaser/dual,
		new /datum/shipcomponents/engines/fighter,
		new /datum/shipcomponents/weapons/smalltorpedo
	)

	..()