/mob/living/simple_animal/passive/scom/civ
	var/corpse1
	faction = "neutral"

/mob/living/simple_animal/passive/scom/civ/civvie
	name = "civilian"
	desc = "A defenseless civilian. Better protect them!"
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	icon = 'icons/uristmob/scommobs.dmi'
	icon_state = "civ1"
	icon_living = "civ1"
	icon_dead = "civ1_d"
	simplify_dead_icon = 1
	ai_holder = /datum/ai_holder/simple_animal/passive


/mob/living/simple_animal/passive/scom/civ/civvie/New()
	..()
	icon_state = "civ[rand(1,10)]"
	icon_living = icon_state
	icon_dead = "[icon_state]_d"

/*/mob/living/simple_animal/passive/scom/civ/civvie/GiveTarget(new_target)
	target = new_target
	if(target != null)
		if(isliving(target))
			Aggro()
			stance = STANCE_ATTACK
			visible_message("<span class='danger'>The [src.name] tries to flee from [target.name]!</span>")
			retreat_distance = 10
			minimum_distance = 10
			return*/

/mob/living/simple_animal/hostile/scom/civ/combat/death()
	..()
	if(weapon1)
		new weapon1 (src.loc)
	return
/mob/living/simple_animal/hostile/scom/civ/combat/police
	name = "police officer"
	desc = "An officer from a local police force."
	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "gunman"
	icon_living = "gunman"
	icon_dead = "gunman_dead"
	ai_holder = /datum/ai_holder/simple_animal/humanoid/police
	faction = "nanotrasen"
	ranged = 1
	maxHealth = 50
	attack_delay = 1.5 SECONDS
	projectiletype = /obj/item/projectile/bullet/pistol
	weapon1 = /obj/item/gun/projectile/pistol/sec/lethal
	say_list_type = /datum/say_list/police

/datum/ai_holder/simple_animal/humanoid/police
	hostile = FALSE
	retaliate = TRUE
	pointblank = TRUE

/datum/say_list/police
	say_escalate = list("Hands up!")
	say_threaten = list("You're banned from the premises.")
	say_stand_down = list("Good.")
	speak = list()

/mob/living/simple_animal/hostile/scom/civ/combat/mil
	name = "soldier"
	desc = "A soldier from a local military force."
	icon_state = "gunman"
	icon_living = "gunman"
	icon_dead = "gunman_dead"
	ai_holder = /datum/ai_holder/simple_animal/humanoid/hostile

/mob/living/simple_animal/hostile/scom/civ/combat/ryclies
	name = "\improper RDF Soldier"
	desc = "A soldier from the Ryclies Defence Force."
	icon_state = "RDF"
	icon_living = "RDF"
	icon_dead = "RDF-d"
	projectiletype = /obj/item/projectile/beam
	ranged = 1
	projectilesound = 'sound/weapons/gunshot/gunshot3.ogg'
	weapon1 = /obj/item/gun/projectile/automatic/kh50
	ai_holder = /datum/ai_holder/simple_animal/humanoid/hostile

/mob/living/simple_animal/hostile/scom/civ/combat/anfor
	name = "\improper ANFOR Marine"
	desc = "A marine from the Allied Naval Forces"
	icon_state = "ANFOR"
	icon_living = "ANFOR"
	icon_dead = "ANFOR-d"
	projectiletype = /obj/item/projectile/beam
	ranged = 1
	projectilesound = 'sound/weapons/laser.ogg'
	weapon1 = /obj/item/gun/energy/laser
	ai_holder = /datum/ai_holder/simple_animal/humanoid/hostile
