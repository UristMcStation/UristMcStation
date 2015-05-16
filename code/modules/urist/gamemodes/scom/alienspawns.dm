/obj/effect/landmark/scom/enemyspawn
	var/mission = 0
	var/spawntype = 0
	var/difflevel = 0
//	invisibility = 101

/obj/effect/landmark/scom/enemyspawn/New()
	invisibility = 101
	return

/obj/effect/landmark/scom/enemyspawn/proc/spawnmobs() //we call this when the shuttle does the thing with the stuff
	if(difflevel <= missiondiff)
		if(spawntype == 0)
			new /mob/living/simple_animal/hostile/alien/drone(src.loc)
			new /mob/living/simple_animal/hostile/alien/drone(src.loc)
		else if(spawntype == 1)
			new /mob/living/simple_animal/hostile/alien/drone(src.loc)
			new /mob/living/simple_animal/hostile/alien(src.loc)
		else if(spawntype == 2)
			new /mob/living/simple_animal/hostile/alien/drone(src.loc)
			new /mob/living/simple_animal/hostile/alien/sentinel(src.loc)
		else if(spawntype == 3)
			new /mob/living/simple_animal/hostile/alien/drone(src.loc)
			new /mob/living/simple_animal/hostile/alien/queen(src.loc)
		else if(spawntype == 4)
			new /mob/living/simple_animal/hostile/alien/queen(src.loc)
			new /mob/living/simple_animal/hostile/alien/queen/large(src.loc)
		else if(spawntype == 5)
			new	/mob/living/simple_animal/hostile/necromorph(src.loc)
			new	/mob/living/simple_animal/hostile/necromorph(src.loc)
		else if(spawntype == 6)
			new	/mob/living/simple_animal/hostile/scom/lactera/light(src.loc)
			new	/mob/living/simple_animal/hostile/scom/lactera/light(src.loc)
		else if(spawntype == 7)
			new	/mob/living/simple_animal/hostile/scom/lactera/medium(src.loc)
			new	/mob/living/simple_animal/hostile/scom/lactera/medium(src.loc)
		else if(spawntype == 8)
			new	/mob/living/simple_animal/hostile/scom/lactera/heavy(src.loc)
			new	/mob/living/simple_animal/hostile/scom/lactera/heavy(src.loc)
		else if(spawntype == 9)
			new	/mob/living/simple_animal/hostile/scom/lactera/leader(src.loc)
			new	/mob/living/simple_animal/hostile/scom/lactera/medic(src.loc)
		else if(spawntype == 10)
			new	/mob/living/simple_animal/hostile/scom/lactera/medic(src.loc)
			new	/mob/living/simple_animal/hostile/scom/lactera/light(src.loc)
		else if(spawntype == 11)
			new	/mob/living/simple_animal/hostile/scom/lactera/medic(src.loc)
			new	/mob/living/simple_animal/hostile/scom/lactera/medic(src.loc)
		else if(spawntype == 12)
			new	/mob/living/simple_animal/hostile/faithless(src.loc)
			new	/mob/living/simple_animal/hostile/faithless(src.loc)
		//else if(spawntype == 100) //civs temporarily removed
//		world << "SPAWNED"
		del(src)


/obj/effect/landmark/scom/enemyspawn/easy
	difflevel = 1

/obj/effect/landmark/scom/enemyspawn/norm
	icon_state = "x3"
	difflevel = 2

/obj/effect/landmark/scom/enemyspawn/hard
	icon_state = "x"
	difflevel = 3

/obj/effect/landmark/scom/enemyspawn/harder
	icon_state = "x"
	difflevel = 4

/obj/effect/landmark/scom/enemyspawn/easy/m1
	mission = 1

/obj/effect/landmark/scom/enemyspawn/easy/m2
	mission = 2

/obj/effect/landmark/scom/enemyspawn/easy/m3
	mission = 3

/obj/effect/landmark/scom/enemyspawn/easy/m4
	mission = 4

/obj/effect/landmark/scom/enemyspawn/easy/m5
	mission = 5

/obj/effect/landmark/scom/enemyspawn/easy/m6
	mission = 6

/obj/effect/landmark/scom/enemyspawn/easy/m7
	mission = 7

/obj/effect/landmark/scom/enemyspawn/easy/m8
	mission = 8

/obj/effect/landmark/scom/enemyspawn/norm/m1
	mission = 1

/obj/effect/landmark/scom/enemyspawn/norm/m2
	mission = 2

/obj/effect/landmark/scom/enemyspawn/norm/m3
	mission = 3

/obj/effect/landmark/scom/enemyspawn/norm/m4
	mission = 4

/obj/effect/landmark/scom/enemyspawn/norm/m5
	mission = 5

/obj/effect/landmark/scom/enemyspawn/norm/m6
	mission = 6

/obj/effect/landmark/scom/enemyspawn/norm/m7
	mission = 7

/obj/effect/landmark/scom/enemyspawn/norm/m8
	mission = 8

/obj/effect/landmark/scom/enemyspawn/hard/m1
	mission = 1

/obj/effect/landmark/scom/enemyspawn/hard/m2
	mission = 2

/obj/effect/landmark/scom/enemyspawn/hard/m3
	mission = 3

/obj/effect/landmark/scom/enemyspawn/hard/m4
	mission = 4

/obj/effect/landmark/scom/enemyspawn/hard/m5
	mission = 5

/obj/effect/landmark/scom/enemyspawn/hard/m6
	mission = 6

/obj/effect/landmark/scom/enemyspawn/hard/m7
	mission = 7

/obj/effect/landmark/scom/enemyspawn/hard/m8
	mission = 8

/obj/effect/landmark/scom/enemyspawn/harder/m1
	mission = 1

/obj/effect/landmark/scom/enemyspawn/harder/m2
	mission = 2

/obj/effect/landmark/scom/enemyspawn/harder/m3
	mission = 3

/obj/effect/landmark/scom/enemyspawn/harder/m4
	mission = 4

/obj/effect/landmark/scom/enemyspawn/harder/m5
	mission = 5

/obj/effect/landmark/scom/enemyspawn/harder/m6
	mission = 6

/obj/effect/landmark/scom/enemyspawn/harder/m7
	mission = 7

/obj/effect/landmark/scom/enemyspawn/harder/m8
	mission = 8