/mob/living/simple_animal/hostile/urist
	name = "gunman"
	desc = "Armed and dangerous."
	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "gunman"
	icon_living = "gunman"
	icon_dead = null
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
	min_gas = list("oxygen" = 5)
	max_gas = null
	unsuitable_atmos_damage = 15
	faction = "neutral"
	status_flags = CANPUSH
	stat_attack = 1
	projectiletype = /obj/item/projectile/bullet
	projectilesound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	casingtype = /obj/item/ammo_casing/c9mm
	move_to_delay = 4
	attack_sound = 'sound/weapons/punch3.ogg'
	projectiletype = /obj/item/projectile/bullet/pistol

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
	projectiletype = /obj/item/projectile/bullet/pistol
	maxHealth = 100
	health = 100

/mob/living/simple_animal/hostile/urist/ntagent
	icon_state = "agent"
	icon_living = "agent"
	icon_dead = "agentdead"
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
	icon_dead = "skrelloristdead"
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
	var/datum/effect/effect/system/smoke_spread/bad/deathsmoke = new
	deathsmoke.set_up(5,0,src.loc,null)
	deathsmoke.start()
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

/mob/living/simple_animal/hostile/urist/stalker/ntis/UnarmedAttack(var/atom/A, var/proximity)
	attack_sound = pick('sound/weapons/bladeslice.ogg','sound/weapons/genhit1.ogg','sound/weapons/genhit2.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/smash.ogg')
	. = ..()

//terran

/mob/living/simple_animal/hostile/urist/terran/marine
	faction = "terran"
	name = "\improper Terran Confederacy Marine"
	desc = "A Terran Confederacy Marine."
	ranged = 1
	ranged_cooldown_cap = 5
	rapid = 2
	icon_state = "terran_marine"
	icon_living = "terran_marine"
	icon_dead = "terran_marine_dead"
	icon_gib = "syndicate_gib"
	casingtype = /obj/item/ammo_casing/a556
	projectilesound = 'sound/weapons/gunshot/gunshot2.ogg'
	projectiletype = /obj/item/projectile/bullet/rifle/a556
	maxHealth = 150
	health = 150
	minimum_distance = 4
	retreat_distance = 2

/mob/living/simple_animal/hostile/urist/terran/marine/event
	faction = "neutral"

/mob/living/simple_animal/hostile/urist/terran/marine_officer
	faction = "terran"
	name = "\improper Terran Confederacy Marine Officer"
	desc = "A Terran Confederacy Marine Officer."
	ranged = 1
	ranged_cooldown_cap = 5
	rapid = 2
	icon_state = "terran_officer"
	icon_living = "terran_officer"
	icon_dead = "terran_officer_dead"
	icon_gib = "syndicate_gib"
	casingtype = /obj/item/ammo_casing/c9mm
	projectilesound = 'sound/weapons/gunshot/gunshot_smg.ogg'
	projectiletype = /obj/item/projectile/bullet/pistol
	maxHealth = 120
	health = 120
	minimum_distance = 4
	retreat_distance = 2

/mob/living/simple_animal/hostile/urist/terran/marine_officer/event
	faction = "neutral"

/mob/living/simple_animal/hostile/urist/terran/marine_space
	faction = "terran"
	name = "\improper Terran Confederacy Marine"
	desc = "A Terran Confederacy Marine. This one is wearing a voidsuit."
	ranged = 1
	ranged_cooldown_cap = 5
	rapid = 2
	icon_state = "terran_heavy"
	icon_living = "terran_heavy"
	icon_dead = "terran_heavy_dead"
	icon_gib = "syndicate_gib"
	casingtype = /obj/item/ammo_casing/a556
	projectilesound = 'sound/weapons/gunshot/gunshot2.ogg'
	projectiletype = /obj/item/projectile/bullet/rifle/a556
	maxHealth = 200
	health = 200
	min_gas = null
	max_gas = null
	minbodytemp = 0
	minimum_distance = 4
	retreat_distance = 2

/mob/living/simple_animal/hostile/urist/terran/marine_space/event
	faction = "neutral"


/mob/living/simple_animal/hostile/urist/rebel
	icon_state = "ANTAG"
	icon_living = "ANTAG"
	name = "\improper Rebel"
	desc = "A member of a growing resistance movement to both NanoTrasen and the Terran Confederacy."
	casingtype = /obj/item/ammo_casing/a762
	faction = "rebels"
	rapid = 0
	maxHealth = 130
	health = 130
	minimum_distance = 4
	retreat_distance = 2
	ranged_cooldown_cap = 2
	projectilesound = 'sound/weapons/gunshot/gunshot3.ogg'
	projectiletype = /obj/item/projectile/bullet/rifle/a762

/mob/living/simple_animal/hostile/urist/rebel/event
	faction = "neutral"

//new pirates

/mob/living/simple_animal/hostile/urist/newpirate
	name = "Pirate"
	desc = "Does what they want 'cause a pirate is free."
	icon_state = "newpirate_melee"
	icon_living = "newpirate_melee"
	icon_dead = "newpirate_melee_dead"
	speak_chance = 0
	turns_per_move = 5
	response_help = "pushes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 4
	stop_automated_movement_when_pulled = 0
	maxHealth = 100
	health = 100
	can_escape = 1

	harm_intent_damage = 5
	melee_damage_lower = 30
	melee_damage_upper = 30
	attacktext = "slashed"
	attack_sound = 'sound/weapons/bladeslice.ogg'

	unsuitable_atmos_damage = 5
	var/corpse = /obj/effect/landmark/corpse/pirate
	var/weapon1 = /obj/item/weapon/melee/energy/sword/pirate
	hiddenfaction = /datum/factions/pirate
	faction = "pirate"

/mob/living/simple_animal/hostile/urist/newpirate/laser
	name = "Pirate Gunner"
	icon_state = "newpirate_laser"
	icon_living = "newpirate_laser"
	icon_dead = "newpirate_laser_dead"
	projectilesound = 'sound/weapons/laser.ogg'
	ranged = 1
	rapid = 0
	projectiletype = /obj/item/projectile/beam
	corpse = /obj/effect/landmark/corpse/pirate/ranged
	weapon1 = /obj/item/weapon/gun/energy/laser
	minimum_distance = 4
	retreat_distance = 2

/mob/living/simple_animal/hostile/urist/newpirate/ballistic
	name = "Pirate Gunner"
	icon_state = "newpirate_ballistic"
	icon_living = "newpirate_ballistic"
	icon_dead = "newpirate_ballistic_dead"
	projectilesound = 'sound/weapons/gunshot/gunshot3.ogg'
	ranged = 1
	rapid = 2
	projectiletype = /obj/item/projectile/bullet/rifle/a762
	corpse = /obj/effect/landmark/corpse/pirate/ranged
	weapon1 = /obj/item/weapon/gun/energy/laser
	minimum_distance = 4
	retreat_distance = 2

/mob/living/simple_animal/hostile/urist/newpirate/death(gibbed, deathmessage, show_dead_message)
	..(gibbed, deathmessage, show_dead_message)
	if(corpse)
		new corpse (src.loc)
	if(weapon1)
		new weapon1 (src.loc)
	qdel(src)
	return