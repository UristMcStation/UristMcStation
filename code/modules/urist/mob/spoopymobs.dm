/mob/living/simple_animal/hostile/zombie
	name = "zombie"
	desc = "Dead man walking - and hungry for your flesh."
	speak_emote = list("groans")
	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "zombie_s"
	icon_living = "zombie_s"
	icon_dead = "zombie_d"
	health = 20
	maxHealth = 20
	melee_damage_lower = 4
	melee_damage_upper = 7
	attacktext = "bites"
	attack_sound = 'sound/weapons/bite.ogg'
	faction = "alien"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	idle_vision_range = 3
	aggro_vision_range = 15 //fairly easy to evade a single one, but DO NOT PISS THEM OFF
	move_to_delay = 6
	stat_attack = 2

/mob/living/simple_animal/hostile/zombie/regen //variant if you want to really fuck players' day up.
	desc = "This zombie SIMPLY. WON'T. STAY. DEAD. Run!"
	health = 40
	maxHealth = 40
	idle_vision_range = 3

/mob/living/simple_animal/hostile/zombie/regen/death()
	..()
	spawn(900)
		health = maxHealth


/mob/living/simple_animal/hostile/vampire
	name = "vampire"
	desc = "A bloodthirsty undead abomination."
	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "vampire_m_s"
	icon_living = "vampire_m_s"
	icon_dead = "vampire_m_d"
	health = 50
	maxHealth = 50
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = "bites"
	attack_sound = 'sound/items/drink.ogg'
	faction = "vampire"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

/mob/living/simple_animal/hostile/vampire/female
	icon_state = "vampire_f_s"
	icon_living = "vampire_f_s"
	icon_dead = "vampire_f_d"