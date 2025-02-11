//Vox spectators for an away mission
/mob/living/simple_animal/hostile/retaliate/vox
	desc = "A tall bird-like creature with three eyes trained on you, waiting for your failure."
	faction = "vox"
	harm_intent_damage = 3
	health = 200
	icon_dead = "vox_dead"
	icon_gib = "vox_dead"
	icon_living = "vox"
	icon_state = "vox"
	l_move_time = 1
	maxHealth = 200
	natural_weapon = /obj/item/natural_weapon/claws/strong
	name = "Vox Primalis"
	real_name = "Vox Primalis"
	response_help = "pets"
	turns_per_move = 10
	voice_name = "unidentifiable shriek"

/datum/say_list/vox
	speak = list("SHRIEKS")
