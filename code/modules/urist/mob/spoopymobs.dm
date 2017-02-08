/mob/living/simple_animal/hostile/urist/zombie
	name = "zombie"
	desc = "Dead man walking - and hungry for your flesh."
	speak_emote = list("groans")
	icon = 'icons/mob/human.dmi'
	icon_state = "husk_s"
	icon_living = "husk_s"
	icon_dead = ""
	simplify_dead_icon = 1
	health = 40
	maxHealth = 40
	melee_damage_lower = 10
	melee_damage_upper = 15
	attacktext = "bit"
	attack_sound = 'sound/weapons/bite.ogg'
	faction = "undead"
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
	ranged = 0
	universal_speak = 1
	var/plague = 0 //whether biting dead people spawns new zombies
	var/regen = 0 //if true, they won't stay down, but revive after a delay
	var/regen_delay = 900 //delay for regen revive

/mob/living/simple_animal/hostile/urist/zombie/say()
	var/acount = rand(2,6)
	var/astring = "a"
	for(var/i, i<acount, i++)
		astring += "a"
	var/message = "Br[astring]ins!"
	..(message)

/mob/living/simple_animal/hostile/urist/zombie/death()
	. = ..()
	if(regen)
		var/tempnameholder = src.name
		var/tempdescholder = src.desc
		src.name = "corpse"
		src.desc = "It's a corpse. Very dead."

		var/matrix/M = matrix() //shamelessly stolen from human update_icons
		M.Turn(90)
		M.Translate(1,-6)
		src.transform = M

		src << "You begin to regenerate. This will take about [regen_delay/600] minutes."
		spawn(regen_delay)
			var/matrix/N = matrix()
			src.transform = N
			health = maxHealth
			src.name = tempnameholder
			src.desc = tempdescholder
	if(src.contents)
		var/inv_size = contents.len
		for(var/obj/O in src.contents)
			if (!(regen) || prob(100 * (1 / inv_size)))
				drop_from_inventory(O)
		if(inv_size == 0)
			src.desc += "\n \n It seems to have dropped everything it had." //shitty hack for now
		update_icons()

/mob/living/simple_animal/hostile/urist/zombie/Destroy()
	if(src.contents)
		for(var/obj/O in src.contents)
			drop_from_inventory(O)

/mob/living/simple_animal/hostile/urist/zombie/generic
	plague = 0
	regen = 0

/mob/living/simple_animal/hostile/urist/zombie/regen //variant if you want to really fuck players' day up.
	desc = "This zombie SIMPLY. WON'T. STAY. DEAD. Run!"
	health = 60
	maxHealth = 60
	idle_vision_range = 3
	regen = 1
	icon_dead = "zombie_s" //ugly, but effective, workaround to use sprite rotation instead of having a custom death icon

/mob/living/simple_animal/hostile/urist/zombie/regenplague //Because non-infectious unkillable zombies weren't bad enough. Round-ender.
	desc = "A bloodthirsty and brain-hungry corpse revived by an unknown infectious pathogen with extreme regenerative abilities."
	stat_attack = 2
	regen = 1
	plague = 1

/mob/living/simple_animal/hostile/urist/zombie/AttackingTarget()
	if(plague)
		var/infectious = src.plague
		var/regenerative = src.regen
		var/resilience = src.maxHealth
		if(istype(src.target, /mob/living/carbon/human))
			var/mob/living/carbon/human/victim = target
			if(victim.stat == DEAD)
				src.visible_message("<span class = 'warning'> <b>[src]</b> chomps at [victim]'s brain!</span>", "<span class = 'warning'>You munch on [victim]'s brain!</span>")
				victim.Zombify(regenerative, infectious, resilience)
				return
		else if(istype(src.target, /mob/living/simple_animal/hostile/scom/civ))
			var/mob/living/simple_animal/hostile/scom/civ/victim = target
			if(victim.stat == DEAD)
				src.visible_message("<span class = 'warning'> <b>[src]</b> chomps at [victim]'s brain!</span>", "<span class = 'warning'>You munch on [victim]'s brain!</span>")
				victim.Zombify(regenerative, infectious, resilience)
				return
	return ..()

/mob/living/simple_animal/hostile/urist/zombie/verb/EatBrain()

	set name = "Eat Brain"
	set desc = "Eat a target corpse's brain to zombify him."

	if(stat || !(plague))
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
		src.visible_message("<span class = 'warning'><b>[src]</b> chomps at [victim]'s brain!</span>", "<span class = 'warning'>You munch on [victim]'s brain!</span>")
		victim.Zombify(src.regen, src.plague, src.maxHealth)
	else if(istype(T, /mob/living/simple_animal/hostile/scom/civ))
		var/mob/living/simple_animal/hostile/scom/civ/victim = T
		src.visible_message("<span class = 'warning'> <b>[src]</b> chomps at [victim]'s brain!</span>", "<span class = 'warning'>You munch on [victim]'s brain!</span>")
		victim.Zombify(src.regen, src.plague, src.maxHealth)
	return


/mob/living/carbon/human/proc/Zombify(var/regens = 0, var/infects = 0, var/hitpoints = 40) //I swear officer, that Animalize() proc fell out the back of a truck.

	var/mobpath = /mob/living/simple_animal/hostile/urist/zombie
	if(transforming)
		return

	src.mutations.Add(HUSK)
	regenerate_icons()
	transforming = 1
	canmove = 0 //considering they're dead shouldn't be much of a problem, but w/e

	var/old_icon = src.icon
	var/old_icon_state = src.icon_state
	var/old_overlays = src.overlays
	var/old_name = src.name

	icon = null
	invisibility = 101

	for(var/t in organs)
		qdel(t)

	var/mob/living/simple_animal/hostile/urist/zombie/new_mob = new mobpath(src.loc)

	new_mob.key = key
	new_mob.a_intent = "hurt"


	new_mob << "<span class='notice'>You are now a zombie. Eat braaaaains.</span>"
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
			new_mob.regen = regens
			new_mob.plague = infects
			new_mob.maxHealth = hitpoints
			new_mob.health = hitpoints

	for(var/obj/item/W in src)
		if(new_mob)
			W.forceMove(new_mob)
		else
			drop_from_inventory(W)
	new_mob.update_icons()

	spawn()
		qdel(src)
	return

/mob/living/simple_animal/hostile/scom/civ/proc/Zombify(var/regens = 0, var/infects = 0, var/hitpoints = 40)//contrary to the name, does not involve undead Goons
	var/mobpath = /mob/living/simple_animal/hostile/urist/zombie/regenplague

	var/mob/living/simple_animal/hostile/urist/zombie/new_mob = new mobpath(src.loc)

	icon = null
	invisibility = 101

	new_mob.key = key
	new_mob.a_intent = "hurt"
	new_mob.regen = regens
	new_mob.plague = infects
	new_mob.maxHealth = hitpoints
	new_mob.health = hitpoints

	spawn()
		qdel(src)
	return

/mob/living/simple_animal/hostile/urist/vampire
	name = "vampire"
	desc = "A bloodthirsty undead abomination."
	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "vampire_m_s"
	icon_living = "vampire_m_s"
	icon_dead = "vampire_m_d"
	health = 100
	maxHealth = 100
	melee_damage_lower = 15
	melee_damage_upper = 20
	attacktext = "bit"
	attack_sound = 'sound/items/drink.ogg'
	faction = "undead"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	ranged = 0
	simplify_dead_icon = 1

/mob/living/simple_animal/hostile/urist/vampire/New()
	var/danglybits = pick(0, 1) //random gender
	if(danglybits)
		icon_state = "vampire_m_s"
		icon_living = "vampire_m_s"
		icon_dead = "vampire_m_d"
	else
		icon_state = "vampire_f_s"
		icon_living = "vampire_f_s"
		icon_dead = "vampire_f_d"
	..()

/mob/living/simple_animal/hostile/urist/skeleton
	name = "skeleton"
	desc = "Too spooky."
	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "skeltal"
	icon_living = "skeltal"
	faction = "undead"
	health = 40 //not much keeping them in one piece
	resistance = 10 //but not much to hit either unless you use a heavy object
	ranged = 0
	attacktext = "stabbed"
	melee_damage_lower = 10
	melee_damage_upper = 20
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

//a more persistent variant of the shadow wight with a different soundset
/obj/effect/haunter
	name = "wight"
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost-narsie"
	density = 1

/obj/effect/haunter/New()
	processing_objects.Add(src)

/obj/effect/haunter/Destroy()
	processing_objects.Remove(src)
	return ..()

/obj/effect/haunter/process()
	if(src.loc)
		src.loc = get_turf(pick(orange(1,src)))
		var/mob/living/carbon/M = locate() in src.loc
		if(M)
			playsound(src.loc, pick('sound/hallucinations/growl1.ogg',\
			'sound/hallucinations/growl2.ogg',\
			'sound/hallucinations/growl3.ogg',\
			'sound/effects/ghost.ogg',\
			'sound/effects/ghost2.ogg',\
			'sound/hallucinations/wail.ogg',\
			'sound/hallucinations/veryfar_noise.ogg',\
			'sound/effects/wind/wind_2_2.ogg',\
			'sound/effects/wind/wind_3_1.ogg',\
			'sound/hallucinations/far_noise.ogg',\
			), 50, 1, -3)
			//M.sleeping = max(M.sleeping,rand(5,10))
			if(prob(5))
				src.loc = null
	else
		processing_objects.Remove(src)

//not-faceless that split on death into weaker clones
/mob/living/simple_animal/hostile/urist/amorph
	name = "amorph"
	desc = "A shapeless biomass twisted into a mockery of a human shape."
	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "amorphic"
	icon_living = "amorphic"
	faction = "biohorror"
	var/generation = 1
	maxHealth = 200
	health = 200
	ranged = 0
	move_to_delay = 7

/mob/living/simple_animal/hostile/urist/amorph/death() //splits into two
	var/nextgen = (1 + src.generation)
	if(nextgen < 1)
		nextgen = 1
	if(nextgen < 5)
		var/mob/living/simple_animal/hostile/urist/amorph/A1 = new /mob/living/simple_animal/hostile/urist/amorph(src.loc)
		var/mob/living/simple_animal/hostile/urist/amorph/A2 = new /mob/living/simple_animal/hostile/urist/amorph(src.loc)
		A1.generation = nextgen
		A2.generation = nextgen
		A1.maxHealth = round(src.maxHealth / nextgen)
		A2.maxHealth = round(src.maxHealth / nextgen)
	..()
	qdel(src)

//Mutants. oldDoom former humans meets frankensteining.
//TODO: Assemble them from species' bodyparts randomly and the weapon inhand

/mob/living/simple_animal/hostile/urist/mutant
	name = "mutant"
	desc = "A horrifying jumble of organs and homicidal rage."
	faction = "biohorror"
	icon_state = "hybrid"
	icon_living = "hybrid"
	maxHealth = 80
	health = 80
	ranged = 0
	retreat_distance = 0
	melee_damage_lower = 10
	melee_damage_upper = 15
	attacktext = "hacked"
	attack_sound = 'sound/weapons/slice.ogg'

/mob/living/simple_animal/hostile/urist/mutant/Life()
	if(IsInRange(src.health, 1, (maxHealth - 1)))
		if(prob(25))
			health++ //regenerates while alive
	..()

/mob/living/simple_animal/hostile/urist/mutant/ranged
	desc = "Despite physical and mental degradation, he can still operate a shotgun."
	icon_state = "mutant_ranged"
	icon_living = "mutant_ranged"
	ranged = 1
	projectilesound = 'sound/weapons/gunshot/shotgun.ogg'
	projectiletype = /obj/item/projectile/bullet/pellet/shotgun //check balance
	ranged_cooldown_cap = 10
	attacktext = "kicked"
	attack_sound = 'sound/weapons/genhit3.ogg'
	minimum_distance = 2

/mob/living/simple_animal/hostile/urist/mutant/melee
	desc = "Homicidal, tough bastard wielding a heavy axe."
	icon_state = "mutant_melee"
	icon_living = "mutant_melee"
	environment_smash = 2
	ranged = 0
	minimum_distance = 1
	melee_damage_lower = 15
	melee_damage_upper = 25
	resistance = 5
	attacktext = "hacked"
	attack_sound = 'sound/weapons/slice.ogg'

/mob/living/simple_animal/hostile/urist/mutant/hybrid
	name = "Xenohybrid"
	desc = "A fast and terrifyingly persistent hunter."
	move_to_delay = 3
	maxHealth = 120
	health = 120
	ranged = 0
	minimum_distance = 1
	melee_damage_lower = 10
	melee_damage_upper = 15
	vision_range = 12
	aggro_vision_range = 18
	attacktext = "slashed"
	attack_sound = 'sound/weapons/rapidslice.ogg'

//A surreal alien with a massive mouth for a face, sprite by Nienhaus
/mob/living/simple_animal/hostile/urist/devourer
	name = "Devourer"
	desc = "What the hell...?"
	icon_state = "eyelien"
	icon_living = "eyelien"
	icon_dead = "eyelien_dead"
	simplify_dead_icon = 0
	faction = "biohorror"
	attacktext = "chomped"
	attack_sound = 'sound/weapons/bite.ogg'
	maxHealth = 100
	health = 100
	ranged = 1
	ranged_message = "spits"
	projectiletype = /obj/item/projectile/energy/neurotoxin
	projectilesound = 'sound/weapons/bite.ogg'
	minimum_distance = 1

//even more blatant...
/mob/living/simple_animal/hostile/urist/imp
	name = "imp"
	desc = "Party like it's 1993."
	icon_state = "imp"
	icon_living = "imp"
	icon_dead = "imp_dead"
	simplify_dead_icon = 0 //because fancy dead icon
	faction = "cult"
	minimum_distance = 2
	ranged = 1
	maxHealth = 75
	health = 75
	projectiletype = /obj/item/projectile/energy/phoron
	projectilesound = 'sound/effects/squelch1.ogg'
	melee_damage_lower = 5
	melee_damage_upper = 15
	attacktext = "slashed"
	attack_sound = 'sound/weapons/rapidslice.ogg'

//TOUGH bastard, teleports around to follow a victim (random if none, varedit to set)
/mob/living/simple_animal/hostile/urist/stalker
	name = "psycho"
	desc = "Implacable killer."
	icon_state = "psycho"
	icon_living = "psycho"
	environment_smash = 1
	maxHealth = 500
	health = 500
	resistance = 6
	ranged = 0
	move_to_delay = 6
	melee_damage_lower = 10
	melee_damage_upper = 15
	attacktext = "slashed"
	attack_sound = 'sound/weapons/rapidslice.ogg'
	attack_same = 1
	var/caution = 1 //hit and run if low on health
	var/mob/stalkee //who he stalks
	var/flickerlights = 0 //for more fun - can fuck with lights around the victim to get a TP zone.
	var/atom/tele_effect = null //something to spawn when teleporting/disappearing, presumably effects

/mob/living/simple_animal/hostile/urist/stalker/New()
	..()
	GetNewStalkee()

/mob/living/simple_animal/hostile/urist/stalker/proc/GetNewStalkee(var/mindplease = 1)
	var/attempts = 3
	while(!(stalkee))
		stalkee = pick(player_list)
		attempts--
		var/recheck = 0
		if(stalkee)
			if(!(isliving(stalkee))) //for some reason new_players *were* being picked
				recheck = 1
			if((!(stalkee.mind)) && mindplease) //not much fun if they can't fight back
				recheck = 1
		if(recheck) //ugly but prevents trying to read a property of a null without parenthesis cancer
			stalkee = null
		if(attempts <= 0) //infinite loop prevention in case there are no
			break

/mob/living/simple_animal/hostile/urist/stalker/Found(var/atom/A)
	if(A == stalkee)
		return 1
	return 0

/mob/living/simple_animal/hostile/urist/stalker/Life()
	if(..())
		if(stalkee)
			if(stalkee.stat == DEAD)
				GetNewStalkee()
			else if(stance == HOSTILE_STANCE_IDLE)
				if(prob(25))
					HuntingTeleport()
		else
			GetNewStalkee()

/mob/living/simple_animal/hostile/urist/stalker/death()
	if(tele_effect)
		HandleTeleFX(src.loc)
	..(0, "disappears!")
	qdel(src)

/mob/living/simple_animal/hostile/urist/stalker/LostTarget()
	..()
	if(prob(25))
		HuntingTeleport()

/mob/living/simple_animal/hostile/urist/stalker/proc/HuntingTeleport()
	var/list/destinations = new/list()
	for(var/turf/T in range(5, stalkee))
		if(istype(T,/turf/space)) continue
		if(T.density) continue
		if(T in range(src, 9)) continue //so they don't teleport pointlessly while in range
		if(shadow_check(T, 1))
			destinations += T
	if(destinations.len)
		var/turf/picked = pick(destinations)
		if(!picked || !isturf(picked))
			return
		if(tele_effect)
			HandleTeleFX(src.loc)
			HandleTeleFX(picked)
		src.forceMove(picked)
	if(flickerlights)
		if(stalkee)
			if(isturf(stalkee.loc))
				var/turf/stalkeeturf = stalkee.loc
				for(var/datum/light_source/LS in stalkeeturf.affecting_lights)
					if(istype(LS.source_atom, /obj/machinery/light))
						var/obj/machinery/light/FL = LS.source_atom
						if(prob(10))
							FL.flicker(3)
	return

/mob/living/simple_animal/hostile/urist/stalker/proc/HandleTeleFX(var/atom/fxloc)
	if(ispath(tele_effect))
		new tele_effect(fxloc)

/mob/living/simple_animal/hostile/urist/stalker/AttackingTarget()
	..()
	if(caution) //run awaaaay!
		HuntingTeleport()