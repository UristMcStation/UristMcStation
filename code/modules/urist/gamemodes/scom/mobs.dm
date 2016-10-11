//TODO: move mobs to a human damage system, add "crazy" mob, add "caller" mob. //one day
//see civilian_mobs.dm for friendly NPCs

/*/mob/living/simple_animal/hostile/proc/HealBitches()
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

	stance = HOSTILE_STANCE_IDLE*/

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
	var/will_help = 0
	var/can_heal = 0
	var/will_flee = 0
	search_objects = 1

/mob/living/simple_animal/hostile/scom/husk
	name = "Husk"
	desc = "What's left of a human after a harvester has its way with them."
	maxHealth = 75
	health = 75
	harm_intent_damage = 5
	melee_damage_lower = 20 //stay away
	melee_damage_upper = 20

/mob/living/simple_animal/hostile/scom/GiveTarget(var/new_target)
	target = new_target
	if(target != null)
		if(isliving(target))
			Aggro()
			stance = HOSTILE_STANCE_ATTACK

			if(health <= 15 && will_flee)
				visible_message("<span class='danger'>The [src.name] tries to flee from [target.name]!</span>")
				retreat_distance = 10
				minimum_distance = 10
			if(health > 16 && will_flee)
				retreat_distance = null
				minimum_distance = initial(minimum_distance)
			if(will_help)
				for(var/mob/living/simple_animal/hostile/M in oview(5, src))
					if(M.faction == faction && M.health <= 15)
						if(can_heal)
							walk_to(src, M, 1)
							if(get_dist(src, M) == 1)
								M.health = M.health + 30
								return
						M.target = target
			return

/mob/living/simple_animal/hostile/scom/lactera
	will_help = 1
	melee_damage_lower = 15
	melee_damage_upper = 15
	ranged = 1
	projectilesound = 'sound/weapons/laser.ogg'
	weapon1 = /obj/item/scom/aliengun/a1
	minimum_distance = 5

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
	health = 150
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
	maxHealth = 600
	health = 600
	icon_living = "allophylus"

/mob/living/simple_animal/hostile/scom/harvester
	name = "Harvester"
	desc = "What the fuck is that thing?"
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	attacktext = "sucked the life out of"
	icon_state = "harvester"
	icon_living = "harvester"
	icon_dead = ""
	maxHealth = 150
	health = 150
	harm_intent_damage = 0
	melee_damage_lower = 35 //stay away
	melee_damage_upper = 35

/mob/living/simple_animal/hostile/scom/harvester/death()
	..()
	qdel(src)
	return

/mob/living/simple_animal/hostile/scom/forgotten
	name = "Forgotten"
	desc = "The souls of those who have been left to die by the alien menace, corrupted and twisted into a form that serves their masters."
	response_help = "tries to poke"
	response_disarm = "tries to shove"
	response_harm = "tries to hit"
	attacktext = "sucked the life out of"
	icon_state = "forgotten"
	icon_living = "forgotten"
	icon_dead = ""
	maxHealth = 250
	health = 250
	ranged = 1 //ranged, but we rush like the old mobs.
	harm_intent_damage = 0
	melee_damage_lower = 25
	melee_damage_upper = 25
	projectiletype = /obj/item/projectile/beam/scom/alien1

/mob/living/simple_animal/hostile/scom/forgotten/death()
	..()
	visible_message("<span class='danger'>The [src.name] wails and disappears!</span>")
	playsound(src.loc, 'sound/hallucinations/wail.ogg', 50, 1)
	flick("forgotten_die", src)
	sleep(4)
	qdel(src)
	return

/mob/living/simple_animal/hostile/alien/ravager
	name = "alien ravager"
	desc = "This one's not like the others..."
	icon = 'icons/uristmob/scommobs.dmi'
	icon_state = "ravager"
	icon_living = "ravager"
	icon_dead = "ravager_dead"
	maxHealth = 70
	health = 70
	melee_damage_lower = 30
	melee_damage_upper = 30

/obj/item/projectile/beam/scom
	icon = 'icons/urist/items/guns.dmi'
	muzzle_type = /obj/effect/projectile/xray/muzzle
	tracer_type = /obj/effect/projectile/xray/tracer
	impact_type = /obj/effect/projectile/xray/impact

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

/obj/item/projectile/beam/scom/alien4 //only ever encounter 1, so it's op
	name = "mind blast"
	icon_state = "" //INVISIBUL
	damage = 30
	stun = 5
	weaken = 5
	stutter = 5

/obj/item/projectile/beam/scom/alien5
	name = "dark energy"
	icon_state = "dblast"
	damage = 15
	stun = 5
	weaken = 5
	stutter = 5

/obj/item/projectile/beam/scom/alien6//for the fighters
	name = "alien beam"
	icon_state = "alienprojectile"
	damage = 30

/mob/living/simple_animal/hostile/scom/lactera/death()
	..()
	if(weapon1)
		new weapon1 (src.loc)
	flick("fire", src)
	sleep(5)
	qdel(src)
	return

/mob/living/simple_animal/hostile/scom/allophylus/death()
	..()
	visible_message("<span class='danger'>The [src.name] bursts into a ball of psionic energy!</span>")
	flick("emfield_s1", src)
	sleep(6)
	qdel(src)
	return

