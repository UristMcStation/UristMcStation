//TODO: move mobs to a human damage system, add "crazy" mob, add "caller" mob.
//see civilian_mobs.dm for friendly NPCs //removed temporarily because runtimes

/mob/living/simple_animal/hostile/proc/HealBitches()
	stop_automated_movement = 1
//	world << "IM BEING CALLED"
	if(!target_mob)
		stance = HOSTILE_STANCE_IDLE
//		world << "FOUND YOUR ERROR"
	if(target_mob in ListTargets(10))
		walk_to(src, target_mob, 1, move_to_delay)
//		world << "MOVING SMOOTHLY"
	if(get_dist(src, target_mob) <= 1)	//heal bitches
		target_mob.health = target_mob.health + 15
		stance = HOSTILE_STANCE_IDLE
//		world << "HEALING BITCHES"
		return 1

/mob/living/simple_animal/hostile/proc/GetTheFuckOut()
	for(var/mob/living/simple_animal/hostile/M in oview(5, src))
		if(will_help && M.faction == faction)
			M.target_mob = src.target_mob

	stance = HOSTILE_STANCE_ATTACK

	step_away(src, target_mob)

	spawn(20)

	stance = HOSTILE_STANCE_IDLE

/mob/living/simple_animal/hostile/scom
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	icon = 'icons/uristmob/scommobs.dmi'
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	faction = "alien" //luv u corai. scom 5eva	//rip in peace corai
	var/weapon1
	icon_state = "necro_s"
	icon_living = "necro_s"
	icon_dead = "necro_d"
//	will_help = 0
//	can_heal = 0
//	will_flee = 0

/*/mob/living/simple_animal/hostile/scom/GiveTarget(var/new_target)
	target = new_target
	if(target != null)
		if(isliving(target))
			Aggro()
			stance = HOSTILE_STANCE_ATTACK

			if(health <= 10 && will_flee)
				visible_message("<span class='danger'>The [src.name] tries to flee from [target.name]!</span>")
				retreat_distance = 10
				minimum_distance = 10
			if(health > 11 && will_flee)
				retreat_distance = initial.retreat_distance
				minimum_distance = initial.minimum_distance
			if(will_help)
				for(var/mob/living/simple_animal/hostile/M in oview(5, src))
					if(M.faction == faction && M.health <= 10)
						if(can_heal)
							step_to(M)
							if(get_dist(M) = 1)
								M.health + 20
								return
						M.target = target
			return*/


/mob/living/simple_animal/hostile/scom/lactera
	will_help = 1
	melee_damage_lower = 15
	melee_damage_upper = 15
	ranged = 1
	projectilesound = 'sound/weapons/laser.ogg'
	weapon1 = /obj/item/scom/aliengun/a1


/mob/living/simple_animal/hostile/scom/lactera/light
	will_flee = 1
	maxHealth = 60
	health = 60
	icon_state = "liz1"
	name = "Lactera Light Trooper"
	projectiletype = /obj/item/projectile/beam/scom/alien1
	icon_living = "liz1"
	icon_dead = "liz1_dead"

/mob/living/simple_animal/hostile/scom/lactera/medium
	icon_state = "liz2"
	maxHealth = 100
	health = 100
	name = "Lactera Trooper"
	projectiletype = /obj/item/projectile/beam/scom/alien2
	icon_living = "liz2"
	icon_dead = "liz2_dead"
	weapon1 = /obj/item/scom/aliengun/a2

/mob/living/simple_animal/hostile/scom/lactera/heavy
	icon_state = "liz3"
	name = "Lactera Heavy Trooper"
	rapid = 1
	projectiletype = /obj/item/projectile/beam/scom/alien2
	maxHealth = 150
	health = 120
	icon_living = "liz3"
	icon_dead = "liz3_dead"
	weapon1 = /obj/item/scom/aliengun/a3

/mob/living/simple_animal/hostile/scom/lactera/leader
	icon_state = "liz4"
	name = "Lactera Officer"
	projectiletype = /obj/item/projectile/beam/scom/alien3
	maxHealth = 200
	health = 200
	icon_living = "liz4"
	icon_dead = "liz4_dead"
	weapon1 = /obj/item/scom/aliengun/a4

/mob/living/simple_animal/hostile/scom/lactera/medic
	can_heal = 1
	icon_state = "lizm"
	name = "Lactera Medic"
	projectiletype = /obj/item/projectile/beam/scom/alien1
	maxHealth = 60
	health = 60
	icon_living = "lizm"
	icon_dead = "lizm_dead"

/mob/living/simple_animal/hostile/scom/allophylus
	icon_state = "allophylus"
	name = "Allophylus"
	ranged = 1
	projectiletype = /obj/item/projectile/beam/scom/alien4
	maxHealth = 500
	health = 500
	icon_living = "allophylus"

/obj/item/projectile/beam/scom
	icon = 'icons/urist/items/uristweapons.dmi'

/obj/item/projectile/beam/scom/alien1
	name = "alien beam"
	icon_state = "alienprojectile"
	damage = 15

/obj/item/projectile/beam/scom/alien2
	name = "alien beam"
	icon_state = "alienprojectile"
	damage = 20

/obj/item/projectile/beam/scom/alien3
	name = "alien beam"
	icon_state = "alienprojectile"
	damage = 25

obj/item/projectile/beam/scom/alien4 //only ever encounter 1, so it's op
	name = "mind blast"
	icon_state = "" //INVISIBUL
	damage = 30
	stun = 5
	weaken = 5
	stutter = 5

/mob/living/simple_animal/hostile/scom/lactera/death()
	..()
	if(weapon1)
		new weapon1 (src.loc)
	flick("fire", src)
	del(src)
	return