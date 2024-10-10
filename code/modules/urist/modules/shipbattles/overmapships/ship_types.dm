
//ships

/mob/living/simple_animal/hostile/overmapship/debug
//	shipdatum = /datum/ships/debug
	shields = 800
	maxHealth = 800
	health = 800
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


/mob/living/simple_animal/hostile/overmapship/debug/missile
//	shipdatum = /datum/ships/debug
	shields = 800
	maxHealth = 800
	health = 800
	aggressive = 1

/mob/living/simple_animal/hostile/overmapship/debug/missile/New() //light shield for now to mess with some debug stuff
	components = list(
		new /datum/shipcomponents/shield/light,
		new /datum/shipcomponents/weapons/smallmissile/battery,
		new /datum/shipcomponents/weapons/bigmissile,
		new /datum/shipcomponents/weapons/heavy_cannon,
		new /datum/shipcomponents/weapons/mininuke,
		new /datum/shipcomponents/weapons/smallmissile/battery,
		new /datum/shipcomponents/engines/standard
	)

	..()

//nanotrasen

/mob/living/simple_animal/hostile/overmapship/nanotrasen
	color = "#4286f4"
	hiddenfaction = /datum/factions/nanotrasen

/mob/living/simple_animal/hostile/overmapship/nanotrasen/ntmerchant
//	shipdatum = /datum/ships/nanotrasen/ntmerchant
	name = "NanoTrasen merchant ship"
	shields = 1000
	health = 1000
	maxHealth = 1000
	ship_category = "NanoTrasen merchant ship"
	can_board = TRUE

/mob/living/simple_animal/hostile/overmapship/nanotrasen/ntmerchant/New()
	components = list(
		new /datum/shipcomponents/shield/freighter,
		new /datum/shipcomponents/weapons/lightlaser,
		new /datum/shipcomponents/engines/freighter
	)

	..()

/*
/mob/living/simple_animal/hostile/overmapship/nanotrasen/patrol
	name = "NanoTrasen patrol ship"
	shields = 3000
	health = 1600
	maxHealth = 1600
	ship_category = "NanoTrasen patrol ship"
*/

/mob/living/simple_animal/hostile/overmapship/nanotrasen/fast_attack
	name = "NanoTrasen fast attack craft"
	shields = 3000
	health = 1200
	maxHealth = 1200
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

//terran

/mob/living/simple_animal/hostile/overmapship/terran
	color = "#9932cc"
//	wander = 1 //temporary
	hiddenfaction = /datum/factions/terran

/mob/living/simple_animal/hostile/overmapship/terran/tcmerchant
//	shipdatum = /datum/ships/nanotrasen/ntmerchant
	name = "Terran Confederacy merchant ship"
	shields = 1000
	health = 1000
	maxHealth = 1000
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

/*
/mob/living/simple_animal/hostile/overmapship/terran/patrol
	name = "Terran Confederacy patrol ship"
	shields = 3000
	health = 1600
	maxHealth = 1600
	ship_category = "Terran Confederacy patrol ship"
*/

/mob/living/simple_animal/hostile/overmapship/terran/fast_attack
	name = "Terran Confederacy fast attack craft"
	health = 1200
	maxHealth = 1200
	ship_category = "Terran Confederacy fast attack craft"
	boardingmap = "maps/shipmaps/ship_fastattackcraft_terran.dmm"
	can_board = TRUE

/mob/living/simple_animal/hostile/overmapship/terran/fast_attack/New()
	components = list(
		new /datum/shipcomponents/shield/fighter,
		new /datum/shipcomponents/weapons/lightlaser/dual,
		new /datum/shipcomponents/weapons/lightlaser/dual,
		new /datum/shipcomponents/weapons/heavylaser,
		new /datum/shipcomponents/engines/fighter,
		new /datum/shipcomponents/weapons/smallmissile/battery,
		new /datum/shipcomponents/point_defence/light,
		new /datum/shipcomponents/shield_disruptor,
		new /datum/shipcomponents/teleporter/terran
	)

	..()

/mob/living/simple_animal/hostile/overmapship/terran/frigate
	name = "Terran Confederacy frigate"
	health = 1600
	maxHealth = 1600
	ship_category = "Terran Confederacy frigate"
//	boardingmap = "maps/shipmaps/ship_frigate_terran.dmm"
	can_board = FALSE

/mob/living/simple_animal/hostile/overmapship/terran/frigate/New()
	components = list(
		new /datum/shipcomponents/shield/combat,
		new /datum/shipcomponents/weapons/heavylaser/dual,
		new /datum/shipcomponents/weapons/heavylaser/dual,
		new /datum/shipcomponents/weapons/pulse/heavy,
		new /datum/shipcomponents/engines/combat,
		new /datum/shipcomponents/weapons/smallmissile/battery,
		new /datum/shipcomponents/weapons/smallmissile/battery,
		new /datum/shipcomponents/point_defence/med,
		new /datum/shipcomponents/weapons/bigtorpedo,
		new /datum/shipcomponents/shield_disruptor/heavy,
		new /datum/shipcomponents/teleporter/terran/large
	)

	..()

//rebels

/mob/living/simple_animal/hostile/overmapship/rebel
	color = "#cd0000" //Boston University Red, also known as the red on the flag of the USSR
	hiddenfaction = /datum/factions/rebel

/mob/living/simple_animal/hostile/overmapship/rebel/fast_attack
	name = "rebel fast attack craft"
	shields = 3000
	health = 1000
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
