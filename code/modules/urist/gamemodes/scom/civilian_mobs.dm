/mob/living/simple_animal/hostile/scom/civ
	var/corpse1
	faction = "neutral"

/mob/living/simple_animal/hostile/scom/civ/civvie
	name = "Civilian"
	desc = "A defenseless civilian. Better protect them!"
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	icon = 'icons/uristmob/scommobs.dmi'
	icon_state = "civ1"
	icon_living = "civ1"
	icon_dead = "civ1_d"

/mob/living/simple_animal/hostile/scom/civ/civvie/New()
	..()
	icon_state = "civ[rand(1,10)]"
	icon_living = icon_state
	icon_dead = "[icon_state]_d"

/mob/living/simple_animal/hostile/scom/civ/civvie/GiveTarget(var/new_target)
	target = new_target
	if(target != null)
		if(isliving(target))
			Aggro()
			stance = HOSTILE_STANCE_ATTACK
			visible_message("<span class='danger'>The [src.name] tries to flee from [target.name]!</span>")
			retreat_distance = 10
			minimum_distance = 10
			return

/mob/living/simple_animal/hostile/scom/civ/combat/death()
	..()
	if(weapon1)
		new weapon1 (src.loc)
	return

/mob/living/simple_animal/hostile/scom/civ/combat/police
	name = "Police Officer"
	desc = "An officer from a local police force."
	icon_state = "necro_s"
	icon_living = "necro_s"
	icon_dead = "necro_d"

/mob/living/simple_animal/hostile/scom/civ/combat/mil
	name = "Soldier"
	desc = "A soldier from a local military force."
	icon_state = "necro_s"
	icon_living = "necro_s"
	icon_dead = "necro_d"

/mob/living/simple_animal/hostile/scom/civ/combat/ryclies
	name = "RDF Soldier"
	desc = "A soldier from the Ryclies Defence Force."
	icon_state = "RDF"
	icon_living = "RDF"
	icon_dead = "RDF-d"
	melee_damage_lower = 15
	melee_damage_upper = 15
	ranged = 1
	projectilesound = 'sound/weapons/laser.ogg'
	weapon1 = /obj/item/weapon/gun/projectile/automatic/kh50
	minimum_distance = 5

/mob/living/simple_animal/hostile/scom/civ/combat/anfor
	name = "ANFOR Marine"
	desc = "A marine from the Allied Naval Forces"
	icon_state = "ANFOR"
	icon_living = "ANFOR"
	icon_dead = "ANFOR-d"
	melee_damage_lower = 15
	melee_damage_upper = 15
	ranged = 1
	projectilesound = 'sound/weapons/Gunshot.ogg'
	weapon1 = /obj/item/weapon/gun/energy/laser
	minimum_distance = 5