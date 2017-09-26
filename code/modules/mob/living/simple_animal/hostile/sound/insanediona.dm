/mob/living/simple_animal/hostile/sound/insanediona
	name = "glowing creature"
	desc = "You're not fully sure what this is, but it isn't good."
	speak_emote = list("screeches at")
	icon_state = "fakediona"
	icon_living = "fakediona"
	icon_dead = ""
	health = 200
	maxHealth = 200
	melee_damage_lower = 15
	melee_damage_upper = 20
	attacktext = "mauled"
	attack_sound = 'sound/weapons/slash.ogg'
	faction = "diona"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	move_to_delay = 40
	idle_vision_range = 2
	alert_sound = list('sound/hallucinations/screech.ogg')

/mob/living/simple_animal/hostile/sound/insanediona/death()
	visible_message("\The [src] moans before dissolving into the ground.")
	new /mob/living/carbon/alien/diona(get_turf(src))
	new /mob/living/carbon/alien/diona(get_turf(src))
	new /mob/living/carbon/alien/diona(get_turf(src))
	..()

/mob/living/simple_animal/hostile/sound/insanediona/AttackTarget()
	if(!..())
		return 0
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.resting)
			target = null