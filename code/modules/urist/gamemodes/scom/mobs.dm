//TODO: move mobs to a human damage system, add "crazy" mob, add "caller" mob. //one day
//see civilian_mobs.dm for friendly NPCs

/*/mob/living/simple_animal/hostile/proc/HealBitches()
	stop_automated_movement = 1
//	log_debug("IM BEING CALLED")
	if(!target_mob)
		stance = STANCE_IDLE
//		log_debug("FOUND YOUR ERROR")
	if(target_mob in ListTargets(10))
		walk_to(src, target_mob, 1, move_to_delay)
//		log_debug("MOVING SMOOTHLY")
	if(get_dist(src, target_mob) <= 1)	//heal bitches
		target_mob.health = target_mob.health + 15
		stance = STANCE_IDLE
//		log_debug("HEALING BITCHES")
		return 1

/mob/living/simple_animal/hostile/proc/GetTheFuckOut()
	for(var/mob/living/simple_animal/hostile/M in oview(5, src))
		if(will_help && M.faction == faction)
			M.target_mob = src.target_mob

	stance = STANCE_ATTACK

	step_away(src, target_mob)

	spawn(20)

	stance = STANCE_IDLE*/


/mob/living/simple_animal/hostile/scom
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	icon = 'icons/uristmob/scommobs.dmi'
	min_gas = null
	max_gas = null
	minbodytemp = 0
	faction = "alien" //luv u corai. scom 5eva	//rip in peace corai
	var/weapon1
	var/diesnormally = 0
	icon_state = "necro_s"
	icon_living = "necro_s"
	icon_dead = "necro_d"
	can_escape = TRUE

/*/mob/living/simple_animal/hostile/scom/death(gibbed, deathmessage, show_dead_message)
	if(diesnormally)
		..()
	else
		LoseAggro()
		mouse_opacity = 1
		walk(src, 0)*/

/mob/living/simple_animal/hostile/scom/husk
	name = "Husk"
	desc = "What's left of a human after a harvester has its way with them."
	maxHealth = 75
	health = 75
	harm_intent_damage = 5
	natural_weapon = /obj/item/natural_weapon/claws/medium //stay away
	diesnormally = 1
	ai_holder = /datum/ai_holder/simple_animal/melee/meat

/obj/item/natural_weapon/claws/medium
	force = 20

/*/mob/living/simple_animal/hostile/scom/GiveTarget(new_target)
	target = new_target
	if(target != null)
		if(isliving(target))
			Aggro()
			stance = STANCE_ATTACK

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
			return*/

/mob/living/simple_animal/hostile/scom/lactera
	natural_weapon = /obj/item/natural_weapon/claws
	ranged = 1
	projectilesound = 'sound/weapons/laser.ogg'
	weapon1 = /obj/item/scom/aliengun/a1
	ai_holder = /datum/ai_holder/simple_animal/humanoid/hostile/lactera
	attack_delay = 1.5 SECONDS
	ranged_attack_delay = 1.5 SECONDS
	see_in_dark = 7
/datum/ai_holder/simple_animal/humanoid/hostile/lactera
	speak_chance = 0

/mob/living/simple_animal/hostile/scom/lactera/light
	maxHealth = 60
	health = 60
	icon_state = "xeno-troop"
	name = "Lactera Light Trooper"
	projectiletype = /obj/item/projectile/beam/scom/alien1
	icon_living = "xeno-troop"
	icon_dead = "xeno-troop_dead"

/mob/living/simple_animal/hostile/scom/lactera/medium
	icon_state = "liz2"
	maxHealth = 100
	health = 100
	name = "Lactera Trooper"
	projectiletype = /obj/item/projectile/beam/scom/alien2
	icon_state = "xeno-midtroop"
	icon_living = "xeno-midtroop"
	icon_dead = "xeno-midtroop_dead"
	weapon1 = /obj/item/scom/aliengun/a2

/mob/living/simple_animal/hostile/scom/lactera/heavy
	icon_state = "liz3"
	name = "Lactera Assault Trooper"
	rapid = 1
	projectiletype = /obj/item/projectile/beam/scom/alien2
	maxHealth = 150
	health = 150
	icon_state = "xeno-bigtroop"
	icon_living = "xeno-bigtroop"
	icon_dead = "xeno-bigtroop_dead"
	weapon1 = /obj/item/scom/aliengun/a3

/mob/living/simple_animal/hostile/scom/lactera/heaviest
	icon_state = "liz4"
	name = "Lactera Heavy Trooper"
	projectiletype = /obj/item/projectile/beam/scom/alien3
	maxHealth = 250
	health = 250
	icon_state = "xeno-maxtroop"
	icon_living = "xeno-maxtroop"
	icon_dead = "xeno-maxtroop_dead"
	weapon1 = /obj/item/scom/aliengun/a4
	rapid = 1

/mob/living/simple_animal/hostile/scom/lactera/leader
	icon_state = "liz4"
	name = "Lactera Officer"
	projectiletype = /obj/item/projectile/beam/scom/alien3
	maxHealth = 250
	health = 250
	icon_state = "xeno-commander"
	icon_living = "xeno-commander"
	icon_dead = "xeno-commander_dead"
	weapon1 = /obj/item/scom/aliengun/a3
	rapid = 1

/mob/living/simple_animal/hostile/scom/lactera/medic
	icon_state = "xeno-medic"
	name = "Lactera Medic"
	projectiletype = /obj/item/projectile/beam/scom/alien1
	maxHealth = 60
	health = 60
	icon_living = "xeno-medic"
	icon_dead = "xeno-medic_dead"

/mob/living/simple_animal/hostile/scom/allophylus
	icon_state = "allophylus"
	name = "Allophylus"
	ranged = 1
	projectiletype = /obj/item/projectile/energy/scom/allophylus
	maxHealth = 600
	health = 600
	icon_living = "allophylus"
	see_in_dark = 10

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
	natural_weapon = /obj/item/natural_weapon/harvester
	see_in_dark = 10

/obj/item/natural_weapon/harvester
	force = 35

/mob/living/simple_animal/hostile/scom/harvester/death()
	..()
	qdel(src)
	return

/mob/living/simple_animal/hostile/scom/forgotten
	name = "Forgotten"
	desc = "The souls of those who have been left to die to the alien menace, corrupted and twisted into a form that serves their masters."
	response_help = "tries to poke"
	response_disarm = "tries to shove"
	response_harm = "tries to hit"
	attacktext = "sucked the life out of"
	icon_state = "forgotten"
	icon_living = "forgotten"
	icon_dead = ""
	maxHealth = 250
	health = 250
	harm_intent_damage = 0
	natural_weapon = /obj/item/natural_weapon/bite/strong
	projectiletype = /obj/item/projectile/energy/scom/forgotten
	ai_holder = /datum/ai_holder/simple_animal/ranged/aggressive/forgotten
	//attack_delay = 2 SECONDS
	needs_reload = TRUE
	reload_time = 2 SECONDS
	reload_sound = null
	see_in_dark = 7

/datum/ai_holder/simple_animal/ranged/aggressive/forgotten
	pointblank = FALSE
	aggro_sound = 'sound/hallucinations/screech.ogg'

/datum/ai_holder/simple_animal/ranged/aggressive/forgotten/closest_distance()
	return 1

/mob/living/simple_animal/hostile/scom/forgotten/death()
	..()
	visible_message("<span class='danger'>The [src.name] wails and disappears!</span>")
	playsound(src.loc, 'sound/hallucinations/wail.ogg', 50, 1)
	flick("forgotten_die", src)
	//sleep(4)
	qdel(src)
	return

/mob/living/simple_animal/hostile/scom/forgotten/awaymap //slightly less brtual
	projectiletype = /obj/item/projectile/energy/scom/forgotten/awaymap
	maxHealth = 225
	health = 225
	reload_time = 6 SECONDS

/mob/living/simple_animal/hostile/alien/ravager
	name = "alien ravager"
	desc = "This one's not like the others..."
	icon = 'icons/uristmob/scommobs.dmi'
	icon_state = "ravager"
	icon_living = "ravager"
	icon_dead = "ravager_dead"
	maxHealth = 75
	health = 75
	natural_weapon = /obj/item/natural_weapon/giant
	speed = -3
	move_to_delay = 1
	natural_armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet	= ARMOR_BALLISTIC_PISTOL,
		energy = ARMOR_ENERGY_SHIELDED,
		laser = ARMOR_LASER_HEAVY,
		bomb = ARMOR_BOMB_SHIELDED
	)

/obj/item/projectile/beam/scom
	icon = 'icons/urist/items/guns.dmi'
	muzzle_type = /obj/effect/projectile/laser/xray/muzzle
	tracer_type = /obj/effect/projectile/laser/xray/tracer
	impact_type = /obj/effect/projectile/laser/xray/impact

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

/obj/item/projectile/energy/scom/allophylus //only ever encounter 1, so it's op
	name = "mind blast"
	icon_state = "" //INVISIBUL
	damage = 30
	stun = 5
	weaken = 5
	stutter = 5
	irradiate = 10
	damage_type = DAMAGE_BURN

/obj/item/projectile/energy/scom/forgotten
	name = "dark energy"
	icon_state = "dblast"
	damage = 15
	stun = 5
	weaken = 5
	stutter = 5
	damage_type = DAMAGE_BURN

/obj/item/projectile/energy/scom/forgotten/awaymap
	name = "dark energy"
	icon_state = "dblast"
	damage = 15
	stun = 1
	weaken = 1
	stutter = 1
	damage_type = DAMAGE_BURN

/obj/item/projectile/beam/scom/alien6//for the fighters
	name = "alien beam"
	icon_state = "alienprojectile"
	damage = 30

/mob/living/simple_animal/hostile/scom/lactera/death()
	..()
	if(weapon1)
		new weapon1 (src.loc)
	flick("fire", src)
	//sleep(5)
	qdel(src)
	return

/mob/living/simple_animal/hostile/scom/allophylus/death()
	..()
	visible_message("<span class='danger'>The [src.name] bursts into a ball of psionic energy!</span>")
	flick("emfield_s1", src)
	empulse(src, 2, 5)
	//sleep(6)
	qdel(src)
	return
