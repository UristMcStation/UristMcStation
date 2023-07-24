//Necromorphs. Meant to do this a while ago, icons by Nien.

//Basic Necromorph

/mob/living/simple_animal/hostile/necromorph
	name = "necromorph"
	desc = "Reanimated corpses of the dead, reshaped into horrific new forms by a recombinant extraterrestrial infection."
	speak_emote = list("screeches")
	//icon = 'icons/urist/uristicons.dmi'
	icon = 'icons/mob/simple_animal/nightmaremonsters.dmi'
	icon_state = "horror_alt"
	icon_living = "horror_alt"
	icon_dead = "horror_alt_dead"
	health = 40
	maxHealth = 40
	attacktext = "slashes"
	attack_sound = 'sound/weapons/slash.ogg'
	faction = "alien" //luv u corai. scom 5eva
	min_gas = null
	max_gas = null
	minbodytemp = 0
	bleed_colour = "#5c0606"
	break_stuff_probability = 25
	pry_time = 8 SECONDS
	pry_desc = "clawing"
	see_in_dark = 10
	minbodytemp = 0
	movement_cooldown = 8
	move_to_delay = 3
	speed = 0.5
	natural_weapon = /obj/item/natural_weapon/meatbits
	ai_holder = /datum/ai_holder/simple_animal/melee/meat
	say_list = /datum/say_list/meat/human

//Baby Necromorph

/mob/living/simple_animal/hostile/necromorph/baby
	name = "baby necromorph"
	ranged = 1
	//icon = 'icons/urist/uristicons.dmi'
	icon = 'icons/mob/simple_animal/nightmaremonsters.dmi'
	icon_state = "lesser_ling"
	icon_dead = ""
	health = 20
	maxHealth = 20
	//projectilesound = 'sound/weapons/Gunshot_light.ogg' //if this was supposed to be ranged, it wasn't anyway
	//projectiletype = /obj/item/projectile/bullet/weakbullet
