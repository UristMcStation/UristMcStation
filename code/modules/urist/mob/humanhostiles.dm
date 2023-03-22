/mob/living/simple_animal/hostile/urist
	name = "gunman"
	desc = "Armed and dangerous."
	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "gunman"
	icon_living = "gunman"
	icon_dead = null
	icon_gib = null
	turns_per_move = 5
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 12
	maxHealth = 50
	health = 50
	harm_intent_damage = 5
	natural_weapon = /obj/item/natural_weapon/punch
	attacktext = "punched"
	a_intent = "harm"
	ranged = 1
	min_gas = list("oxygen" = 5)
	max_gas = null
	unsuitable_atmos_damage = 15
	faction = "neutral"
	status_flags = CANPUSH
	projectiletype = /obj/item/projectile/bullet
	projectilesound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	casingtype = /obj/item/ammo_casing/c9mm
	move_to_delay = 4
	attack_sound = 'sound/weapons/punch3.ogg'
	projectiletype = /obj/item/projectile/bullet/pistol
	ai_holder = /datum/ai_holder/simple_animal/humanoid/hostile

/mob/living/simple_animal/hostile/urist/gunman //mostly redundant, for ease of spawning
	faction = "syndicate"

/mob/living/simple_animal/hostile/urist/commando //literally a clone of syndies with my speed tweaks and NT faction, adminfuckery purposes
	faction = "NTIS"
	name = "\improper NTIS Commando"
	desc = "A henchman of the Internal Security department. You suddenly get an unpleasant sensation that you <I>'know too much'</I>."
	ranged = 1
	rapid = 2
	icon = 'icons/mob/simple_animal/animal.dmi'
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
	maxHealth = 150
	health = 150
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
	projectilesound = 'sound/weapons/gunshot/gunshot3.ogg'
	projectiletype = /obj/item/projectile/bullet/rifle

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
	projectilesound = 'sound/weapons/gunshot/gunshot3.ogg'
	projectiletype = /obj/item/projectile/bullet/pistol
	ai_holder = /datum/ai_holder/simple_animal/humanoid/hostile

/mob/living/simple_animal/hostile/urist/riotcop
	icon_state = "riotcop"
	icon_living = "riotcop"
	name = "\improper Riot Response Unit"
	desc = "An officer equipped for dealing with riots."
	ranged = 0
	attacktext = "beat"
	move_to_delay = 9 //this armor is *heavy*
	maxHealth = 200 //but it offers some serious protection
	health = 200
	resistance = 4 //including padding
	faction = "NTIS"
	natural_weapon = /obj/item/melee/baton
	ai_holder = /datum/ai_holder/simple_animal/humanoid/hostile

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
	environment_smash = 2
	faction = "cult"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	natural_weapon = /obj/item/melee/cultblade
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_LEVEL_TWO
	ai_holder = /datum/ai_holder/simple_animal/melee/pirate //they probably shouldnt all be pirates...

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
	maxHealth = 500
	health = 500
	projectilesound = 'sound/urist/suppshot.ogg'
	attacktext = "brutalized"
	attack_sound = 'sound/weapons/punch3.ogg' //overridden in AttackTarget!
	attack_same = 0
	ai_holder = /datum/ai_holder/simple_animal/humanoid/hostile

/mob/living/simple_animal/hostile/urist/stalker/ntis/UnarmedAttack(var/atom/A, var/proximity)
	attack_sound = pick('sound/weapons/bladeslice.ogg','sound/weapons/genhit1.ogg','sound/weapons/genhit2.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/smash.ogg')
	. = ..()

//terran

/mob/living/simple_animal/hostile/urist/terran
	var/corpse = null //i really need to make this a generic var, but that's going to require going through all the old Bay simple mobs too so it'll have to wait for another day
	hiddenfaction = /datum/factions/terran

/mob/living/simple_animal/hostile/urist/terran/death(gibbed, deathmessage, show_dead_message)
	..(gibbed, deathmessage, show_dead_message)
	if(corpse)
		new corpse (src.loc)
	qdel(src)
	return

/mob/living/simple_animal/hostile/urist/terran/marine
	name = "\improper Terran Confederacy Marine"
	desc = "A Terran Confederacy Marine."
	ranged = 1
	rapid = 2
	icon_state = "terran_marine"
	icon_living = "terran_marine"
	icon_dead = "terran_marine_dead"
	icon_gib = "syndicate_gib"
	casingtype = /obj/item/ammo_casing/a556/used
	projectilesound = 'sound/weapons/gunshot/gunshot2.ogg'
	projectiletype = /obj/item/projectile/bullet/rifle/military
	maxHealth = 150
	health = 150
	corpse = /obj/effect/landmark/corpse/terran/marine
	ai_holder = /datum/ai_holder/simple_animal/humanoid/hostile

/mob/living/simple_animal/hostile/urist/terran/marine/event
	faction = "terran"

/mob/living/simple_animal/hostile/urist/terran/marine/ground
	icon_state = "terran_g_marine"
	icon_living = "terran_g_marine"
	icon_dead = "terran_g_marine_dead"
	corpse = /obj/effect/landmark/corpse/terran/marine_ground
	casingtype = /obj/item/ammo_casing/a762/used
	projectilesound = 'sound/weapons/gunshot/gunshot2.ogg'
	projectiletype = /obj/item/projectile/bullet/rifle
	rapid = 0
	desc = "A Terran Confederacy Marine. This one is wearing gear worn by ground assault forces."

/mob/living/simple_animal/hostile/urist/terran/marine/ground/event
	faction = "terran"

/mob/living/simple_animal/hostile/urist/terran/marine_officer
	name = "\improper Terran Confederacy Marine Officer"
	desc = "A Terran Confederacy Marine Officer."
	ranged = 1
	rapid = 2
	icon_state = "terran_officer"
	icon_living = "terran_officer"
	icon_dead = "terran_officer_dead"
	icon_gib = "syndicate_gib"
	casingtype = /obj/item/ammo_casing/c9mm/used
	projectilesound = 'sound/weapons/gunshot/gunshot_smg.ogg'
	projectiletype = /obj/item/projectile/bullet/pistol
	maxHealth = 125
	health = 125
	ai_holder = /datum/ai_holder/simple_animal/humanoid/hostile
	corpse = /obj/effect/landmark/corpse/terran/officer

/mob/living/simple_animal/hostile/urist/terran/marine_officer/event
	faction = "terran"

/mob/living/simple_animal/hostile/urist/terran/marine_officer/ground
	icon_state = "terran_g_officer"
	icon_living = "terran_g_officer"
	icon_dead = "terran_g_officer_dead"
	desc = "A Terran Confederacy Marine Officer. This one is wearing gear worn by ground assault forces."
	corpse = /obj/effect/landmark/corpse/terran/marine_ground_officer

/mob/living/simple_animal/hostile/urist/terran/marine_officer/ground/event
	faction = "terran"

/mob/living/simple_animal/hostile/urist/terran/marine_space
	name = "\improper Terran Confederacy Marine"
	desc = "A Terran Confederacy Marine. This one is wearing a voidsuit."
	ranged = 1
	rapid = 2
	icon_state = "terran_heavy"
	icon_living = "terran_heavy"
	icon_dead = "terran_heavy_dead"
	icon_gib = "syndicate_gib"
	casingtype = /obj/item/ammo_casing/a556/used
	projectilesound = 'sound/weapons/gunshot/gunshot2.ogg'
	projectiletype = /obj/item/projectile/bullet/rifle/military
	maxHealth = 225
	health = 225
	min_gas = null
	max_gas = null
	minbodytemp = 0
	ai_holder = /datum/ai_holder/simple_animal/humanoid/hostile
	corpse = /obj/effect/landmark/corpse/terran/marinespace

/mob/living/simple_animal/hostile/urist/terran/marine_space/event
	faction = "terran"

/mob/living/simple_animal/hostile/urist/terran/marine_space/ground
	desc = "A Terran Confederacy Marine. This one is wearing a voidsuit worn by ground assault forces."
	icon_state = "terran_g_space"
	icon_living = "terran_g_space"
	icon_dead = "terran_g_space_dead"
	corpse = /obj/effect/landmark/corpse/terran/marine_ground_space

/mob/living/simple_animal/hostile/urist/terran/marine_space/ground/event
	faction = "terran"

//rebels

/mob/living/simple_animal/hostile/urist/rebel
	icon_state = "ANTAG"
	icon_living = "ANTAG"
	name = "\improper Rebel"
	desc = "A member of a growing resistance movement to both NanoTrasen and the Terran Confederacy."
	casingtype = /obj/item/ammo_casing/a762/used
	hiddenfaction = /datum/factions/rebel
	rapid = 0
	maxHealth = 130
	health = 130
	ai_holder = /datum/ai_holder/simple_animal/humanoid/hostile
	projectilesound = 'sound/weapons/gunshot/gunshot3.ogg'
	projectiletype = /obj/item/projectile/bullet/rifle

/mob/living/simple_animal/hostile/urist/rebel/event
	faction = "rebels"

//new pirates

/mob/living/simple_animal/hostile/urist/newpirate
	name = "Pirate"
	desc = "Does what they want 'cause a pirate is free."
	icon_state = "newpirate_melee"
	icon_living = "newpirate_melee"
	icon_dead = "newpirate_melee_dead"
	turns_per_move = 5
	response_help = "pushes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 4
	maxHealth = 120
	health = 120
	can_escape = TRUE

	harm_intent_damage = 5
	natural_weapon = /obj/item/melee/energy/sword/pirate/activated
	ai_holder = /datum/ai_holder/simple_animal/melee/pirate

	unsuitable_atmos_damage = 15
	var/corpse = /obj/effect/landmark/corpse/newpirate/melee
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
	corpse = /obj/effect/landmark/corpse/newpirate/laser
	ai_holder = /datum/ai_holder/simple_animal/pirate/ranged

/mob/living/simple_animal/hostile/urist/newpirate/ballistic
	name = "Pirate Gunner"
	icon_state = "newpirate_ballistic"
	icon_living = "newpirate_ballistic"
	icon_dead = "newpirate_ballistic_dead"
	projectilesound = 'sound/weapons/gunshot/gunshot3.ogg'
	ranged = 1
	rapid = 2
	projectiletype = /obj/item/projectile/bullet/rifle
	corpse = /obj/effect/landmark/corpse/newpirate/ballistic
	ai_holder = /datum/ai_holder/simple_animal/pirate/ranged

/mob/living/simple_animal/hostile/urist/newpirate/death(gibbed, deathmessage, show_dead_message)
	..(gibbed, deathmessage, show_dead_message)
	if(corpse)
		new corpse (src.loc)
	qdel(src)
	return

// **  HOLONAUT MOBS ** //
/mob/living/simple_animal/hostile/urist/hololab
	name = "Holo Lab hostile mob"
	desc = "You shouldn't see me, report this to an admin if you do!"
	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_dead = "holonaut_dead"
	faction = "holonaut"
	response_help = "holds tightly"
	response_disarm = "pulls down"
	response_harm = "grasps"
	ai_holder = /datum/ai_holder/simple_animal/hostile/hololab

/datum/ai_holder/simple_animal/hostile/hololab
	speak_chance = 50

/datum/say_list/hololab
	speak = list("...?<>D-d-d-£$D<>Id it()<> work?", "I<> T-<>%$£I'm b-<C-cant feel <>ANYT-thing.</C-cant>", "?:PO$&<S-Someone...", "Three. Nine. ><><Seven-n-n-n.. One..$£% Five Nine.")
	emote_hear = list("gasps suddenly", "garbles something unintelligible", "jitters audibly", "garbles some sort of radio message.")
	emote_see = list("jitters uncontrollably", "stares at their palms")


/mob/living/simple_animal/hostile/urist/hololab/holonautgrunt  // Weakest Holonaut
	name = "\improper flickering figure"
	desc = "A once humanoid figure, flickering uncontrollably in and out of existence."
	icon_state = "holonaut_1"
	icon_dead = "holonaut_dead"
	health = 100 // Less strong, as he isn't wearing anything.
	ranged = 0
	attacktext = "contorts"
	natural_weapon = /obj/item/natural_weapon/punch

/mob/living/simple_animal/hostile/urist/hololab/holonautregular // More dangerous holonaut, with some resistance.
	name = "\improper distorted holonaut"
	desc = "A distorted flickering humanoid, wearing a spacesuit. The limbs inside the suit seem to struggle to move."
	icon_state = "holonaut_2"
	icon_dead = "holonaut_dead"
	health = 150
	resistance = 15 //
	ranged = 0
	attacktext = "tears"
	natural_weapon = /obj/item/natural_weapon/claws

/mob/living/simple_animal/hostile/urist/hololab/holonautsuit
	name = "\improper gesticulating Holonaut"
	desc = "A humanoid gesticulating wildly, wearing a orange spacesuit. The limbs inside seems to animate wildly, as if something were crawling inside it. It looks full of energy!"
	icon_state = "holonaut_3"
	icon_dead = "holonaut_dead"
	health = 50 // Weak, but dangerous up close.
	resistance = 20
	ranged = 0
	natural_weapon = /obj/item/natural_weapon/claws/strong
	attacktext = "rends"
