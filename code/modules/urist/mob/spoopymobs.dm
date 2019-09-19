/mob/living/simple_animal/hostile/urist/zombie
	name = "zombie"
	desc = "Dead man walking - and hungry for your flesh."
	speak_emote = list("groans")
	icon_state = "zombie_s"
	icon_living = "zombie_s"
	icon_dead = "zombie_d"
	simplify_dead_icon = 1
	health = 40
	maxHealth = 40
	melee_damage_lower = 5
	melee_damage_upper = 10
	attacktext = "bit"
	attack_sound = 'sound/weapons/bite.ogg'
	faction = "undead"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	idle_vision_range = 3
	aggro_vision_range = 15 //fairly easy to evade a single one, but DO NOT PISS THEM OFF
	move_to_delay = 7
	stat_attack = 1
	ranged = 0
	environment_smash = 1
	var/plague = 0 //whether biting dead people spawns new zombies
	var/regen = 0 //if true, they won't stay down, but revive after a delay
	var/regen_delay = 90 //delay for regen revive

/datum/reagent/xenomicrobes/uristzombie
	metabolism = REM
	var/target_organ = BP_BRAIN

	var/symptom_msgs = list(
		"Your teeth feel loose.",
		"Your eyes are rheumy.",
		"Your blood feels scratchy.",
		"You joints feel stiff.",
		"Bumps stand out on your skin.",
		"Your intestines roil.",
		"You feel light-headed.",
		"Your throat hurts.",
		"You feel fluid sloshing inside you.",
		"Your chest feels tight.",
		"You hear a crackling noise from inside of you.",
		"Pus seeps from your eyes.",
		"Your skin comes out in lesions.",
		"The flesh at the back of your throat sloughs off.",
		"Your joints ache.",
		"Your fingernail falls off, the skin underneath blistered.",
		"You taste iron."
	)
	var/transformation_msgs = list(
		"Steel wool is scrubbing against your brain.",
		"Greasy sand seems to fill your blood vessels.",
		"Grey oil oozes out of your ears.",
		"You smell spoiling meat. You drool at the thought.",
		"Your tongue swells up and turns black."
	)

/datum/reagent/xenomicrobes/uristzombie/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	affect_blood(M, alien, removed * 0.5)

/datum/reagent/xenomicrobes/uristzombie/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/true_dose = H.chem_doses[type] + volume
		var/idlemsg_proba = 10

		if(true_dose > 10 && prob(Clamp(50*(true_dose-10)/(true_dose+15), 0, 100)))
			if(prob(1))
				// psych!
				to_chat(H, "<span class='warning'>[pick(transformation_msgs)]</span>")

			else if(prob(Clamp(true_dose+0.1*H.getBrainLoss(), 0, 25)))
				idlemsg_proba = 5 // symptom spam avoidance
				var/organs = list(BP_R_ARM,BP_L_LEG,BP_L_ARM,BP_R_LEG,BP_GROIN,BP_CHEST)
				var/undecayed_ctr = length(organs) // make your own immature joke here

				for(var/organ_tag in organs)
					var/obj/item/organ/external/E = H.organs_by_name[organ_tag]
					if (E && !(E.status & ORGAN_DEAD) && !(BP_IS_ROBOTIC(E) || BP_IS_CRYSTAL(E)))
						if(prob(10))
							continue

						var/decay_msg = pick(
							"Your [E.name] feels stiff.",
							"You smell something foul.",
							"Flesh on your [E.name] turns black.",
							"You can't feel the skin on your [E.name].",
							"You can feel blood clotting in your [E.name].")
						E.status |= ORGAN_DEAD
						to_chat(H, "<span class='warning'>[decay_msg]</span>")

						for (var/obj/item/organ/external/C in E.children)
							if (C && !(C.status & ORGAN_DEAD) && !(BP_IS_ROBOTIC(C) || BP_IS_CRYSTAL(C)))
								C.status |= ORGAN_DEAD
						break
					else
						undecayed_ctr--

				H.update_body(1)

				if(prob(Clamp(100-100*(undecayed_ctr/length(organs)), 0, 100)))
					// NOTE: this *deliberately* does not care if the mob lost the limb.
					// So, reverse necromorph - less limbs => less tissue to infect.
					var/obj/item/organ/external/Head = H.organs_by_name[BP_HEAD]
					if (Head)
						if(!(Head.status & ORGAN_DEAD))
							Head.status |= ORGAN_DEAD
							for (var/obj/item/organ/external/C in Head.children)
								C.status |= ORGAN_DEAD
						else
							H.uZombify(1, 1, transformation_msgs)
		else
			// almost straight copy of plain reagent/toxin/affect_blood()
			if(alien != IS_DIONA)
				M.add_chemical_effect(CE_TOXIN, 5)
				var/dam = 0.05 * rand(1, 20)
				if(target_organ)
					var/obj/item/organ/internal/I = H.internal_organs_by_name[target_organ]
					if(I)
						var/can_damage = I.max_damage - I.damage
						if(can_damage > 0)
							if(dam > can_damage)
								I.take_internal_damage(can_damage, silent=TRUE)
								dam -= can_damage
							else
								I.take_internal_damage(dam, silent=TRUE)
								dam = 0
				if(dam)
					// nerfed damage w/ target_organ here -scr
					M.adjustToxLoss(target_organ ? (dam * 0.25) : dam)
			// endcopy

		// custom sadism
		if(prob(Clamp(idlemsg_proba, 0, 100)))
			to_chat(H, "<span class='warning'>[pick(symptom_msgs)]</span>")

		if(prob(Clamp(true_dose, 0, 100)))
			H.reagents.add_reagent(src.type, rand(removed, 0.1*true_dose))

		H.add_chemical_effect(CE_PAINKILLER, 40)

		// transforming sanics the victim's metabolism:
		H.add_chemical_effect(CE_PULSE, 4)
		H.nutrition -= min(H.nutrition, true_dose)
		H.bodytemperature = max(H.bodytemperature, H.species.heat_discomfort_level + rand(5, 15))
		if(prob(Clamp(5+true_dose, 0, 20)))
			H.make_jittery(5)

/mob/living/simple_animal/hostile/urist/zombie/Aggro()
	if(prob(35))
		playsound(src.loc, pick('sound/hallucinations/wail.ogg', 'sound/hallucinations/screech.ogg', 'sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg', 'sound/hallucinations/growl3.ogg'))
	..()

/mob/living/simple_animal/hostile/urist/zombie/say()
	var/acount = rand(2,8)
	var/astring = "a"
	for(var/i, i<acount, i++)
		astring += "a"
	var/message = "Br[astring]ins!"
	..(message)

/mob/living/simple_animal/hostile/urist/zombie/death()
	. = ..()

	src.transform = null
	var/matrix/N = matrix()
	N.Turn(90)
	src.transform = N

	if(regen)
		to_chat(src, "You begin to regenerate. This will take about [regen_delay/60] minutes.")
		to_chat(src, "If you ghost, you can re-enter the mob assuming it still exists.")
		addtimer(CALLBACK(src, /mob/living/simple_animal/hostile/urist/zombie/proc/deathregen), regen_delay SECONDS, TIMER_STOPPABLE)

	if(src.contents)
		var/inv_size = contents.len
		for(var/obj/O in src.contents)
			if (!(regen) || prob(100 * (1 / inv_size)))
				drop_from_inventory(O)
		if(inv_size == 0)
			src.desc += "\n \n It seems to have dropped everything it had." //shitty hack for now
		update_icons()

/mob/living/simple_animal/hostile/urist/zombie/ghostize(var/can_reenter_corpse=1)
	return ..(max(1, can_reenter_corpse)) // always re-enterable

/mob/living/simple_animal/hostile/urist/zombie/proc/deathregen()
	src.transform = null
	rejuvenate()
	return

/mob/living/simple_animal/hostile/urist/zombie/Destroy()
	if(src.contents)
		for(var/obj/O in src.contents)
			drop_from_inventory(O)
	. = ..()

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

/mob/living/simple_animal/hostile/urist/zombie/plague //Because non-infectious unkillable zombies weren't bad enough. Round-ender.
	desc = "A bloodthirsty and brain-hungry corpse revived by an unknown infectious pathogen with extreme regenerative abilities."
	stat_attack = 2
	regen = 1
	plague = 1

/mob/living/simple_animal/hostile/urist/zombie/UnarmedAttack(var/atom/A, var/proximity)
	. = ..()

	if(plague)
		if(ishuman(A))
			var/mob/living/carbon/human/victim = A

			if(victim.reagents)
				var/biosafety = victim.getarmor(null, "bio")
				if(!prob(Clamp(biosafety, 0, 100)))
					victim.reagents.add_reagent(/datum/reagent/xenomicrobes/uristzombie, rand(5, 10))

			uZombieInfect(victim)

		else if(istype(A, /mob/living/simple_animal/hostile/scom/civ))
			var/mob/living/simple_animal/hostile/scom/civ/victim = A
			uZombieInfect(victim)

	return

// do excuse the weird naming convention, but Bay *already* broke this proc once so I'm not taking chances.
/mob/living/simple_animal/hostile/urist/zombie/proc/uZombieInfect(var/mob/living/infectee)
	if(!src || src.stat)
		return

	if(!infectee || infectee.stat != DEAD)
		return

	var/munch_msg_ext = "<span class = 'warning'> <b>[src]</b> chomps at [infectee]'s brain!</span>",
	var/munch_msg_self = "<span class = 'warning'>You chomps at [infectee]'s brain!</span>"

	if(ishuman(infectee))
		var/mob/living/carbon/human/victim = infectee
		if(victim)
			src.visible_message(munch_msg_ext, munch_msg_self)
			victim.uZombifyInstant(src.regen, src.plague, src.maxHealth)

	else if(istype(infectee, /mob/living/simple_animal/hostile/scom/civ))
		var/mob/living/simple_animal/hostile/scom/civ/victim = infectee
		if(victim)
			src.visible_message(munch_msg_ext, munch_msg_self)
			victim.uZombify(src.regen, src.plague, src.maxHealth)


/mob/living/carbon/human/proc/uZombify(var/regens=0, var/infects=0, var/transformation_msgs, var/time=60, var/hitpoints=40)
	if(!src)
		return

	if(HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		return

	// unless the odds are messing with you, as soon as you get the message your only hope is a *good* death
	to_chat(src, "<span class='warning'>[pick(transformation_msgs)]</span>")
	addtimer(CALLBACK(src, /mob/living/carbon/human/proc/uZombifyInstant, regens, infects, hitpoints), time SECONDS, TIMER_STOPPABLE)


/mob/living/carbon/human/proc/uZombifyInstant(var/regens = 0, var/infects = 0, var/hitpoints = 40) //I swear officer, that Animalize() proc fell out the back of a truck.
	if(!src)
		return

	if(HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		// we have it handled by someone else already
		return
	else
		ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)

	var/obj/item/organ/internal/brain/thinkmeats = src.internal_organs_by_name[BP_BRAIN]
	if(!thinkmeats)
		// remove the head or destroy the brain!
		return

	var/mobpath = /mob/living/simple_animal/hostile/urist/zombie

	src.mutations.Add(MUTATION_HUSK)
	for(var/organ in list(BP_R_ARM,BP_L_ARM,BP_R_LEG,BP_L_LEG,BP_GROIN,BP_CHEST,BP_HEAD))
		var/obj/item/organ/external/E = src.organs_by_name[organ]
		if(E)
			E.status |= ORGAN_DEAD
			for (var/obj/item/organ/external/C in E.children)
				C.status |= ORGAN_DEAD
	src.update_body(1)
	src.update_icons()

	var/old_icon = src.icon
	var/old_icon_state = src.icon_state
	var/old_overlays = src.overlays
	var/old_name = src.real_name

	icon = null
	invisibility = 101

	var/mob/living/simple_animal/hostile/urist/zombie/new_mob = new mobpath(src.loc)

	new_mob.a_intent = I_HURT

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

	if(src.mind)
		src.mind.transfer_to(new_mob)

	death()
	for(var/t in organs)
		qdel(t)

	to_chat(new_mob, "<span class='notice'>You are now a zombie. Eat braaaaains.</span>")

	for(var/obj/item/W in src)
		if(new_mob)
			W.forceMove(new_mob)
		else
			drop_from_inventory(W)
	new_mob.update_icons()

	playsound(src.loc, pick(
		'sound/hallucinations/wail.ogg',
		'sound/hallucinations/screech.ogg',
		'sound/hallucinations/growl1.ogg',
		'sound/hallucinations/growl2.ogg',
		'sound/hallucinations/growl3.ogg')
	)

	spawn()
		qdel(src)
	return


/mob/living/simple_animal/hostile/scom/civ/proc/uZombify(var/regens = 0, var/infects = 0, var/hitpoints = 40)
	var/mobpath = /mob/living/simple_animal/hostile/urist/zombie/plague
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
	min_gas = null
	max_gas = null
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
	icon_dead = "skeltal_d"
	faction = "undead"
	health = 40 //not much keeping them in one piece
	resistance = 10 //but not much to hit either unless you use a heavy object
	ranged = 0
	attacktext = "stabbed"
	melee_damage_lower = 10
	melee_damage_upper = 20
	min_gas = null
	max_gas = null
	minbodytemp = 0

//a more persistent variant of the shadow wight with a different soundset
/obj/effect/haunter
	name = "wight"
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost-narsie"
	density = 1

/obj/effect/haunter/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/haunter/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/effect/haunter/Process()
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
		STOP_PROCESSING(SSobj, src)

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
	var/datum/effect/effect/system/tele_effect = null //something to spawn when teleporting/disappearing, presumably effects

/mob/living/simple_animal/hostile/urist/stalker/New()
	..()
	GetNewStalkee()

/mob/living/simple_animal/hostile/urist/stalker/proc/GetNewStalkee(var/mindplease = 1)
	var/attempts = 3
	while(!(stalkee))
		stalkee = pick(GLOB.player_list)
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
				if(!client && prob(25))
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
	if(!client)
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
	if(tele_effect)
		var/datum/effect/effect/system/fx_instance = new tele_effect()
		fx_instance.set_up(3, 0, fxloc)
		fx_instance.start()

/mob/living/simple_animal/hostile/urist/stalker/UnarmedAttack(var/atom/A, var/proximity)
	..()
	if(!client && caution) //run awaaaay!
		HuntingTeleport()