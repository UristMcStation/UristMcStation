/mob/living/simple_animal/hostile/scom/civ
	var/corpse1
	faction = "neutral"

/mob/living/simple_animal/hostile/scom/civ/civvie
	name = "civilian"
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

/mob/living/simple_animal/hostile/scom/civ/police
	name = "police officer"
	desc = "An officer from a local police force."
	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "gunman"
	icon_living = "gunman"
	icon_dead = "gunman_dead"

/mob/living/simple_animal/hostile/scom/civ/mil
	name = "soldier"
	desc = "A soldier from a local military force."
	icon_state = "necro_s"
	icon_living = "necro_s"
	icon_dead = "necro_d"