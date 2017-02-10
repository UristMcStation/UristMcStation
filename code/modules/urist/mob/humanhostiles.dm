/mob/living/simple_animal/hostile/urist
	name = "gunman"
	desc = "Armed and dangerous."
	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "gunman"
	icon_living = "gunman"
	icon_dead = ""
	icon_gib = null
	speak_chance = 0
	turns_per_move = 5
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 12
	stop_automated_movement_when_pulled = 0
	maxHealth = 50
	health = 50
	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 5
	attacktext = "punched"
	a_intent = "harm"
	ranged = 1
	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 15
	faction = "neutral"
	status_flags = CANPUSH
	stat_attack = 1
	projectiletype = /obj/item/projectile/bullet
	projectilesound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	casingtype = /obj/item/ammo_casing/c9mm
	move_to_delay = 4
	attack_sound = 'sound/weapons/punch3.ogg'
	projectiletype = /obj/item/projectile/bullet/pistol
	simplify_dead_icon = 1 //set to 0 if you want a custom dead icon

/mob/living/simple_animal/hostile/urist/gunman //mostly redundant, for ease of spawning
	minimum_distance = 4
	retreat_distance = 2
	faction = "syndicate"

/mob/living/simple_animal/hostile/urist/commando //literally a clone of syndies with my speed tweaks and NT faction, adminfuckery purposes
	faction = "NTIS"
	name = "\improper NTIS Commando"
	desc = "A henchman of the Internal Security department. You suddenly get an unpleasant sensation that you <I>'know too much'</I>."
	ranged = 1
	ranged_cooldown_cap = 5
	rapid = 2
	icon = 'icons/mob/animal.dmi'
	icon_state = "syndicateranged"
	icon_living = "syndicateranged"
	icon_gib = "syndicate_gib"
	casingtype = /obj/item/ammo_casing/a10mm
	projectilesound = 'sound/weapons/gunshot/gunshot_smg.ogg'
	projectiletype = /obj/item/projectile/bullet/pistol/medium/smg
	maxHealth = 100
	health = 100

/mob/living/simple_animal/hostile/urist/ntagent
	icon_state = "agent"
	icon_living = "agent"
	name = "\improper NTIS Agent"
	desc = "A spook from the Internal Security department. You suddenly get an unpleasant sensation that you <I>'know too much'</I>."
	faction = "NTIS" //NTIS is intended as NT Deathsquad affiliation
	rapid = 2
	ranged_cooldown_cap = 5
	maxHealth = 150
	health = 150
	minimum_distance = 4
	retreat_distance = 2
	projectilesound = 'sound/urist/suppshot.ogg'

/mob/living/simple_animal/hostile/urist/ANTAG
	icon_state = "ANTAG"
	icon_living = "ANTAG"
	name = "\improper ANTAG Operative"
	desc = "A member of a covert cell of a terrorist paramilitary collaborating with aliens to further their own goals, and a snappy dresser."
	casingtype = /obj/item/ammo_casing/a762
	faction = "alien"
	rapid = 0
	maxHealth = 130
	health = 130
	minimum_distance = 4
	retreat_distance = 2
	ranged_cooldown_cap = 2
	projectilesound = 'sound/weapons/gunshot/gunshot3.ogg'
	projectiletype = /obj/item/projectile/bullet/rifle/a762

/mob/living/simple_animal/hostile/urist/skrellterrorist
	icon_state = "skrellorist"
	icon_living = "skrellorist"
	name = "\improper Skrellian terrorist"
	desc = "An anti-human, Skrell-isolationist insurgent."
	casingtype = /obj/item/ammo_casing/a10mm
	faction = "skrellt"
	rapid = 2
	maxHealth = 100
	health = 100
	minimum_distance = 8
	projectilesound = 'sound/weapons/gunshot/gunshot3.ogg'
	projectiletype = /obj/item/projectile/bullet/pistol/medium/smg

/mob/living/simple_animal/hostile/urist/riotcop
	icon_state = "riotcop"
	icon_living = "riotcop"
	name = "\improper Riot Response Unit"
	desc = "An officer equipped for dealing with riots."
	ranged = 0
	stat_attack = 0
	attacktext = "beat"
	move_to_delay = 9 //this armor is *heavy*
	maxHealth = 200 //but it offers some serious protection
	health = 200
	resistance = 4 //including padding
	minimum_distance = 1
	faction = "NTIS"
	attack_sound = 'sound/weapons/genhit3.ogg'
	melee_damage_lower = 10
	melee_damage_upper = 15

/mob/living/simple_animal/hostile/urist/cultist
	icon_state = "cultist"
	icon_living = "cultist"
	name = "cult assassin"
	desc = "An assassin empowered by eldritch forces from beyond."
	ranged = 0
	attacktext = "stabbed"
	maxHealth = 75
	health = 75
	move_to_delay = 2 //gotta go fast!
	alpha = 200
	minimum_distance = 1
	environment_smash = 2
	faction = "cult"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	melee_damage_lower = 15
	melee_damage_upper = 20
	aggro_vision_range = 18
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_LEVEL_TWO

/mob/living/simple_animal/hostile/urist/cultist/death()
	..()
	new /obj/effect/effect/smoke/bad(loc)
	qdel(src)

//Spess Jason Bourne
/mob/living/simple_animal/hostile/urist/stalker/ntis
	icon_state = "agent"
	icon_living = "agent"
	name = "\improper NTIS Assassin"
	desc = "A spook from the Internal Security department. You suddenly get an unpleasant sensation that you 'know too much'."
	faction = "NTIS"
	ranged = 1
	rapid = 2
	ranged_cooldown_cap = 2
	maxHealth = 500
	health = 500
	minimum_distance = 4
	retreat_distance = 2
	projectilesound = 'sound/urist/suppshot.ogg'
	attacktext = "brutalized"
	attack_sound = 'sound/weapons/punch3.ogg' //overridden in AttackTarget!
	attack_same = 0
	tele_effect = /obj/effect/sparks

/mob/living/simple_animal/hostile/urist/stalker/ntis/AttackingTarget()
	attack_sound = pick('sound/weapons/bladeslice.ogg','sound/weapons/genhit1.ogg','sound/weapons/genhit2.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/smash.ogg')
	..()