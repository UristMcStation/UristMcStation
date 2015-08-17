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
	melee_damage_lower = 10
	melee_damage_upper = 15
	attacktext = "bit"
	attack_sound = 'sound/weapons/bite.ogg'
	faction = "zombie"
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
	move_to_delay = 7
	stat_attack = 1

/mob/living/simple_animal/hostile/zombie/say()
	var/message = "Braaaaaaains!"
	..(message)

/mob/living/simple_animal/hostile/zombie/regen //variant if you want to really fuck players' day up.
	desc = "This zombie SIMPLY. WON'T. STAY. DEAD. Run!"
	health = 40
	maxHealth = 40
	idle_vision_range = 3
	icon_dead = "zombie_s" //ugly, but effective, workaround to use sprite rotation instead of having a custom death icon

/mob/living/simple_animal/hostile/zombie/regen/New()
	..()
	src.health = -1 //starts masqueraded as a unknown corpse

/mob/living/simple_animal/hostile/zombie/regen/death()
	..()
	var/tempnameholder = src.name
	var/tempdescholder = src.desc
	src.name = "corpse"
	src.desc = "It's a corpse. Very dead."

	var/matrix/M = matrix() //shamelessly stolen from human update_icons
	M.Turn(90)
	M.Translate(1,-6)
	src.transform = M

	src << "You begin to regenerate. This will take about 1.5 minutes."
	spawn(900)
		var/matrix/N = matrix()
		src.transform = N
		health = maxHealth
		src.name = tempnameholder
		src.desc = tempdescholder


/mob/living/simple_animal/hostile/zombie/regen/plague //Because non-infectious unkillable zombies weren't bad enough. Round-ender.
	desc = "A bloodthirsty and brain-hungry corpse revived by an unknown infectious pathogen with extreme regenerative abilities."
	stat_attack = 2

/mob/living/simple_animal/hostile/zombie/regen/plague/AttackingTarget()
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/victim = target
		if(victim.stat == DEAD)
			src.visible_message("<span class = 'warning'> <b>[src]</b> chomps at [victim]'s brain!</span>", "<span class = 'warning'>You munch on [victim]'s brain!</span>")
			victim.Zombify(src.type)
			return
		else
			..()
	else if(istype(target, /mob/living/simple_animal/hostile/scom/civ))
		var/mob/living/simple_animal/hostile/scom/civ/victim = target
		if(victim.stat == DEAD)
			src.visible_message("<span class = 'warning'> <b>[src]</b> chomps at [victim]'s brain!</span>", "<span class = 'warning'>You munch on [victim]'s brain!</span>")
			victim.SAZombify(src.type)
			return
		else
			..()
	else
		..()

/mob/living/simple_animal/hostile/zombie/regen/plague/verb/EatBrain()

	set name = "Eat Brain"
	set desc = "Eat a target corpse's brain to zombify him."

	if(stat)
		src << "You cannot eat brains in your current state."
		return

	var/list/choices = list()
	for(var/mob/living/carbon/human/target in view(1,src))
		if((target.stat == DEAD) && Adjacent(target))
			choices += target
	for(var/mob/living/simple_animal/hostile/scom/civ/C in view(1,src))
		if((C.stat == DEAD) && Adjacent(C))
			choices += C
	var/mob/living/T = input(src,"Whose brain tissue do you wish to sample?") as null|anything in choices

	if(!T || !src || src.stat) return

	if(istype(T, /mob/living/carbon/human))
		var/mob/living/carbon/human/victim = T
		src.visible_message("<span class = 'warning'>[src]</b> chomps at [victim]'s brain!</span>", "<span class = 'warning'>You munch on [victim]'s brain!</span>")
		victim.Zombify(src.type)
	else if(istype(T, /mob/living/simple_animal/hostile/scom/civ))
		var/mob/living/simple_animal/hostile/scom/civ/victim = T
		src.visible_message("<span class = 'warning'> <b>[src]</b> chomps at [victim]'s brain!</span>", "<span class = 'warning'>You munch on [victim]'s brain!</span>")
		victim.SAZombify(src.type)
	return


/mob/living/carbon/human/proc/Zombify(var/mobpath) //I swear officer, that Animalize() proc fell out the back of a truck.

	if(!(istype(mobpath, /mob/living/simple_animal/hostile/zombie))) //not very elegant, but it prevens abuse for other mobtypes
		mobpath = /mob/living/simple_animal/hostile/zombie/regen/plague

	if(monkeyizing)
		return
	for(var/obj/item/W in src)
		drop_from_inventory(W)

	src.mutations.Add(HUSK)
	regenerate_icons()
	monkeyizing = 1
	canmove = 0 //considering they're dead shouldn't be much of a problem, but w/e

	var/old_icon = src.icon
	var/old_icon_state = src.icon_state
	var/old_overlays = src.overlays
	var/old_name = src.name

	icon = null
	invisibility = 101

	for(var/t in organs)
		del(t)

	var/mob/living/simple_animal/hostile/zombie/new_mob = new mobpath(src.loc)

	new_mob.key = key
	new_mob.a_intent = "hurt"


	new_mob << "<B>You are now a zombie. Eat braaaaains.</B>"
	if(old_icon)
		new_mob.icon = old_icon
	if(old_icon_state)
		new_mob.icon_state = old_icon_state
	if(old_overlays)
		new_mob.overlays = old_overlays
	if(old_name)
		if(!(old_name == "unknown"))
			new_mob.name = "zombified [old_name]"
			new_mob.real_name = new_mob.name

	spawn()
		del(src)
	return

/mob/living/simple_animal/hostile/scom/civ/proc/SAZombify(var/mobpath)//contrary to the name, does not involve undead Goons

	if(!(istype(mobpath, /mob/living/simple_animal/hostile/zombie)))
		mobpath = "/mob/living/simple_animal/hostile/zombie/regen/plague"

	var/mob/living/simple_animal/hostile/zombie/new_mob = new mobpath(src.loc)

	icon = null
	invisibility = 101

	new_mob.key = key
	new_mob.a_intent = "hurt"

	spawn()
		del(src)
	return

/mob/living/simple_animal/hostile/vampire
	name = "vampire"
	desc = "A bloodthirsty undead abomination."
	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "vampire_m_s"
	icon_living = "vampire_m_s"
	icon_dead = "vampire_m_d"
	health = 50
	maxHealth = 50
	melee_damage_lower = 15
	melee_damage_upper = 20
	attacktext = "bit"
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
