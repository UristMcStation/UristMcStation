/mob/living/simple_animal/hostile/human/pirate
	name = "Pirate"
	desc = "Does what he wants cause a pirate is free."
	icon_state = "piratemelee"
	icon_living = "piratemelee"
	icon_dead = "piratemelee_dead"
	turns_per_move = 5
	response_help = "pushes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 4
	maxHealth = 50
	health = 50
	can_escape = TRUE

	harm_intent_damage = 5

	natural_weapon = /obj/item/melee/energy/sword/pirate/activated
	unsuitable_atmos_damage = 15
	var/corpse = /obj/landmark/corpse/pirate
	var/weapon1 = /obj/item/melee/energy/sword/pirate

	faction = "pirate"

	ai_holder = /datum/ai_holder/simple_animal/melee/pirate

/mob/living/simple_animal/hostile/human/pirate/ranged
	name = "Pirate Gunner"
	icon_state = "pirateranged"
	icon_living = "pirateranged"
	icon_dead = "piratemelee_dead"
	projectilesound = 'sound/weapons/Laser.ogg'
	ranged = 1
	attack_delay = 1.5 SECONDS
	projectiletype = /obj/item/projectile/beam
	corpse = /obj/landmark/corpse/pirate/ranged
	weapon1 = /obj/item/gun/energy/laser

	ai_holder = /datum/ai_holder/simple_animal/pirate/ranged

/mob/living/simple_animal/hostile/human/pirate/death(gibbed, deathmessage, show_dead_message)
	..(gibbed, deathmessage, show_dead_message)
	if(corpse)
		new corpse (src.loc)
	if(weapon1)
		new weapon1 (src.loc)
	qdel(src)
	return

/datum/ai_holder/simple_animal/pirate/ranged
	pointblank = TRUE		// They get close? Just shoot 'em!
	firing_lanes = TRUE		// But not your buddies!
	// conserve_ammo = TRUE	// And don't go wasting bullets!

/datum/ai_holder/simple_animal/melee/pirate
	speak_chance = 0
