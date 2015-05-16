/mob/living/simple_animal/scom/civ
	name = "Civilian"
	desc = "A defenseless civilian. Better protect them!"
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	icon = 'icons/uristmob/scommobs.dmi'
	icon_state = "necro_s"
	icon_living = "necro_s"
	icon_dead = "necro_d"

/mob/living/simple_animal/hostile/scom/civ
	var/corpse1
	faction = "neutral"

/mob/living/simple_animal/hostile/scom/civ/police
	name = "Police Officer"
	desc = "An officer from a local police force."
	icon_state = "necro_s"
	icon_living = "necro_s"
	icon_dead = "necro_d"

/mob/living/simple_animal/hostile/scom/civ/mil
	name = "Soldier"
	desc = "A soldier from a local military force."
	icon_state = "necro_s"
	icon_living = "necro_s"
	icon_dead = "necro_d"