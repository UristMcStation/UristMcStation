/mob/living/simple_animal/hostile/alien
	name = "alien hunter"
	desc = "Hiss!"
	icon = 'icons/mob/alien.dmi'
	icon_state = "alienh_running"
	icon_living = "alienh_running"
	icon_dead = "alienh_dead"
	icon_gib = "syndicate_gib"
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = -1
	meat_type = /obj/item/reagent_containers/food/snacks/xenomeat
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	natural_weapon = /obj/item/natural_weapon/claws
	bleed_colour = COLOR_LIME
	attacktext = "slashed"
	a_intent = I_HURT
	attack_sound = 'sound/weapons/bladeslice.ogg'
	min_gas = null
	max_gas = null
	unsuitable_atmos_damage = 15
	faction = "alien"
	environment_smash = 2
	status_flags = CANPUSH
	minbodytemp = 0
	heat_damage_per_tick = 20
	can_escape = TRUE
	see_in_dark = 10
	move_to_delay = 1
	pry_time = 6 SECONDS
	ai_holder = /datum/ai_holder/simple_animal/urist_humanoid/alien/hunter
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES
		)

/mob/living/simple_animal/hostile/alien/drone
	name = "alien drone"
	icon_state = "aliend_running"
	icon_living = "aliend_running"
	icon_dead = "aliend_dead"
	health = 60
	natural_weapon = /obj/item/natural_weapon/claws
	move_to_delay = 2
	ai_holder = /datum/ai_holder/simple_animal/urist_humanoid/alien/drone

/mob/living/simple_animal/hostile/alien/sentinel
	name = "alien sentinel"
	icon_state = "aliens_running"
	icon_living = "aliens_running"
	icon_dead = "aliens_dead"
	health = 120
	natural_weapon = /obj/item/natural_weapon/claws
	ranged = 1
	projectiletype = /obj/item/projectile/neurotox
	projectilesound = 'sound/weapons/pierce.ogg'
	move_to_delay = 2
	ai_holder = /datum/ai_holder/simple_animal/urist_humanoid/alien/sentinel
	base_attack_cooldown = 20

/mob/living/simple_animal/hostile/alien/queen
	name = "alien queen"
	icon_state = "alienq_running"
	icon_living = "alienq_running"
	icon_dead = "alienq_dead"
	health = 250
	maxHealth = 250
	natural_weapon = /obj/item/natural_weapon/claws/strong
	ranged = 1
	move_to_delay = 3
	projectiletype = /obj/item/projectile/neurotox
	projectilesound = 'sound/weapons/pierce.ogg'
	rapid = 1
	base_attack_cooldown = 16
	ai_holder = /datum/ai_holder/simple_animal/urist_humanoid/alien/queen
	status_flags = 0
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES,
		laser	= ARMOR_LASER_SMALL,
		energy	= ARMOR_ENERGY_SMALL
		)

/mob/living/simple_animal/hostile/alien/queen/large
	name = "alien empress"
	icon = 'icons/uristmob/alienqueen.dmi'
	icon_state = "queen_s"
	icon_living = "queen_s"
	icon_dead = "queen_dead"
	move_to_delay = 4
	maxHealth = 400
	health = 400
	base_attack_cooldown = 12
	ai_holder = /datum/ai_holder/simple_animal/urist_humanoid/alien/queen/empress
	natural_armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		laser	= ARMOR_LASER_HANDGUNS,
		energy	= ARMOR_ENERGY_SMALL,
		ballistic = ARMOR_BALLISTIC_MINOR
		)

/obj/item/projectile/neurotox
	damage = 25
	damage_type = DAMAGE_BURN
	icon_state = "toxin"

/mob/living/simple_animal/hostile/alien/death(gibbed, deathmessage, show_dead_message)
	..(gibbed, "lets out a waning guttural screech, green blood bubbling from its maw...", show_dead_message)
	playsound(src, 'sound/voice/hiss6.ogg', 100, 1)

// AI Holders

/datum/ai_holder/simple_animal/urist_humanoid/alien/hunter // Melee Based, can leap.
	speak_chance = 0
	aggro_sound = 'sound/voice/hiss1.ogg'
	threaten = FALSE
	can_breakthrough = TRUE
	violent_breakthrough = TRUE
	wander = TRUE
	returns_home = FALSE
	home_low_priority = TRUE
	pointblank = FALSE
	dying_threshold = 0.1
	lose_target_timeout = 20 SECONDS
	run_if_this_close = 0
	melee_hitnrun_prob = 5
	melee_slippery = FALSE
	prefer_cover_proba = 0
	prying = TRUE

/datum/ai_holder/simple_animal/urist_humanoid/alien/drone // Melee Based, cannot leap, more likely to hit and run.
	speak_chance = 0
	aggro_sound = 'sound/voice/hiss2.ogg'
	threaten = FALSE
	can_breakthrough = TRUE
	violent_breakthrough = TRUE
	wander = TRUE
	returns_home = FALSE
	home_low_priority = TRUE
	pointblank = FALSE
	dying_threshold = 0.1
	lose_target_timeout = 15 SECONDS
	run_if_this_close = 0
	melee_hitnrun_prob = 50
	melee_slippery = TRUE
	prefer_cover_proba = 0
	prying = TRUE

/datum/ai_holder/simple_animal/urist_humanoid/alien/sentinel // Swaps between Melee and Ranged, Kites if too close.
	speak_chance = 0
	aggro_sound = 'sound/voice/hiss3.ogg'
	firing_lanes = FALSE
	conserve_ammo = FALSE //Don't shoot when it can't hit target
	can_breakthrough = TRUE //Can break through doors
	violent_breakthrough = TRUE
	speak_chance = 0 //Babble chance
	cooperative = TRUE //Assist each other
	wander = TRUE //Wander around
	returns_home = FALSE
	home_low_priority = TRUE //Following/helping is more important
	pointblank = FALSE // Use your fancy melee
	can_flee = FALSE
	dying_threshold = 0.1
	lose_target_timeout = 20 SECONDS
	run_if_this_close = 2
	melee_hitnrun_prob = 5  // probability of hit-and-run; null <=> 0 <=> disabled
	melee_slippery = FALSE  // robust sideways dodging on melee
	ranged_slippery = TRUE  // robust random dodging on ranged
	prefer_cover_proba = 0
	prying = TRUE

/datum/ai_holder/simple_animal/urist_humanoid/alien/queen // Primairly ranged, but will attack with Melee if close.
	speak_chance = 0
	aggro_sound = 'sound/voice/hiss4.ogg'
	cooperative = TRUE
	firing_lanes = FALSE
	conserve_ammo = FALSE
	can_breakthrough = TRUE
	violent_breakthrough = TRUE
	speak_chance = 0
	wander = TRUE
	returns_home = FALSE
	home_low_priority = TRUE //Following/helping is more important
	pointblank = FALSE // Use your fancy melee
	can_flee = FALSE
	dying_threshold = 0.1
	lose_target_timeout = 20 SECONDS
	run_if_this_close = 0
	melee_hitnrun_prob = 5  // probability of hit-and-run; null <=> 0 <=> disabled
	melee_slippery = FALSE  // robust sideways dodging on melee
	ranged_slippery = FALSE
	prefer_cover_proba = 0
	prying = TRUE


/datum/ai_holder/simple_animal/urist_humanoid/alien/queen/empress // Queen but stronger
	aggro_sound = 'sound/voice/hiss5.ogg'
	dying_threshold = 0.1
	lose_target_timeout = 30 SECONDS
