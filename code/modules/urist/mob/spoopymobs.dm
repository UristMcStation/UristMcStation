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
	natural_weapon = /obj/item/natural_weapon/bite
	attacktext = "bit"
	attack_sound = 'sound/weapons/bite.ogg'
	faction = "undead"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	move_to_delay = 7
	ranged = 0
	environment_smash = 1
	var/plague = 0 //whether biting dead people spawns new zombies
	var/regen = 0 //if true, they won't stay down, but revive after a delay
	var/regen_delay = 90 //delay for regen revive
	ai_holder = /datum/ai_holder/simple_animal/melee/zombie
	say_list_type = /datum/say_list/monster_generic

/datum/ai_holder/simple_animal/melee/zombie
	vision_range = 3 // fairly easy to evade a single one
	can_breakthrough = TRUE
	violent_breakthrough = TRUE
	destructive = TRUE

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

/datum/reagent/xenomicrobes/uristzombie/affect_touch(mob/living/carbon/M, alien, removed)
	affect_blood(M, alien, removed * 0.5)

/datum/reagent/xenomicrobes/uristzombie/affect_blood(mob/living/carbon/M, alien, removed)
	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/true_dose = H.chem_doses[type] + volume
		var/idlemsg_proba = 10

		if(true_dose > 10 && prob(clamp(50*(true_dose-10)/(true_dose+15), 0, 100)))
			if(prob(1))
				// psych!
				to_chat(H, "<span class='warning'>[pick(transformation_msgs)]</span>")

			else if(prob(clamp(true_dose+0.1*H.getBrainLoss(), 0, 25)))
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

				if(prob(clamp(100-100*(undecayed_ctr/length(organs)), 0, 100)))
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
		if(prob(clamp(idlemsg_proba, 0, 100)))
			to_chat(H, "<span class='warning'>[pick(symptom_msgs)]</span>")

		if(prob(clamp(true_dose, 0, 100)))
			H.reagents.add_reagent(src.type, rand(removed, 0.1*true_dose))

		H.add_chemical_effect(CE_PAINKILLER, 40)

		// transforming sanics the victim's metabolism:
		H.add_chemical_effect(CE_PULSE, 4)
		H.nutrition -= min(H.nutrition, true_dose)
		H.bodytemperature = max(H.bodytemperature, H.species.heat_discomfort_level + rand(5, 15))
		if(prob(clamp(5+true_dose, 0, 20)))
			H.make_jittery(5)

/mob/living/simple_animal/hostile/urist/zombie/proc/Aggro()
	if(prob(35))
		playsound(src.loc, pick('sound/hallucinations/wail.ogg', 'sound/hallucinations/screech.ogg', 'sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg', 'sound/hallucinations/growl3.ogg'))

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
		addtimer(new Callback(src, TYPE_PROC_REF(/mob/living/simple_animal/hostile/urist/zombie, deathregen)), regen_delay SECONDS, TIMER_STOPPABLE)

	if(src.contents)
		var/inv_size = length(contents)
		for(var/obj/O in src.contents)
			if (!(regen) || prob(100 * (1 / inv_size)))
				drop_from_inventory(O)
		if(inv_size == 0)
			src.desc += "\n \n It seems to have dropped everything it had." //shitty hack for now
		update_icons()

/mob/living/simple_animal/hostile/urist/zombie/ghostize(can_reenter_corpse=1)
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
	regen = 1
	icon_dead = "zombie_s" //ugly, but effective, workaround to use sprite rotation instead of having a custom death icon

/mob/living/simple_animal/hostile/urist/zombie/plague //Because non-infectious unkillable zombies weren't bad enough. Round-ender.
	desc = "A bloodthirsty and brain-hungry corpse revived by an unknown infectious pathogen with extreme regenerative abilities."
	regen = 1
	plague = 1

/mob/living/simple_animal/hostile/urist/zombie/UnarmedAttack(atom/A, proximity)
	. = ..()

	if(plague)
		if(ishuman(A))
			var/mob/living/carbon/human/victim = A

			if(victim.reagents)
				var/biosafety = victim.get_armors_by_zone(null, "bio")
				if(!prob(clamp(biosafety, 0, 100)))
					victim.reagents.add_reagent(/datum/reagent/xenomicrobes/uristzombie, rand(5, 10))

			uZombieInfect(victim)

		else if(istype(A, /mob/living/simple_animal/hostile/scom/civ))
			var/mob/living/simple_animal/hostile/scom/civ/victim = A
			uZombieInfect(victim)

	return

// do excuse the weird naming convention, but Bay *already* broke this proc once so I'm not taking chances.
/mob/living/simple_animal/hostile/urist/zombie/proc/uZombieInfect(mob/living/infectee)
	if(!src || src.stat)
		return

	if(!infectee || infectee.stat != DEAD)
		return

	var/munch_msg_ext = SPAN_WARNING("[src] chomps at [infectee]'s brain!")
	var/munch_msg_self = SPAN_WARNING("You chomp at [infectee]'s brain!")

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


/mob/living/carbon/human/proc/uZombify(regens=0, infects=0, transformation_msgs, time=60, hitpoints=40)
	if(!src)
		return

	if(HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		return

	// unless the odds are messing with you, as soon as you get the message your only hope is a *good* death
	to_chat(src, "<span class='warning'>[pick(transformation_msgs)]</span>")
	addtimer(new Callback(src, TYPE_PROC_REF(/mob/living/carbon/human, uZombifyInstant), regens, infects, hitpoints), time SECONDS, TIMER_STOPPABLE)


/mob/living/carbon/human/proc/uZombifyInstant(regens = 0, infects = 0, hitpoints = 40) //I swear officer, that Animalize() proc fell out the back of a truck.
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
		new_mob.SetOverlays(old_overlays)
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


/mob/living/simple_animal/hostile/scom/civ/proc/uZombify(regens = 0, infects = 0, hitpoints = 40)
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
	natural_weapon = /obj/item/natural_weapon/bite
	attacktext = "bit"
	attack_sound = 'sound/items/drink.ogg'
	faction = "undead"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	ranged = 0
	simplify_dead_icon = 1
	ai_holder = /datum/ai_holder/simple_animal/urist_humanoid/melee_slippery

	natural_armor = list(
		melee = ARMOR_MELEE_RESISTANT
	)


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
	natural_weapon = /obj/item/material/twohanded/spear
	min_gas = null
	max_gas = null
	minbodytemp = 0
	ai_holder = /datum/ai_holder/simple_animal/urist_humanoid/melee_generic
	say_list_type = /datum/say_list/monster_generic

	natural_armor = list(
		bullet = ARMOR_BALLISTIC_RESISTANT,
		melee = ARMOR_MELEE_SMALL
	)

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
	ai_holder = /datum/ai_holder/simple_animal/urist_humanoid/melee_generic
	say_list_type = /datum/say_list/monster_generic

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
	icon_dead = "hybrid_dead"
	maxHealth = 80
	health = 80
	ranged = 0
	natural_weapon = /obj/item/natural_weapon/claws
	attacktext = "hacked"
	attack_sound = 'sound/weapons/slice.ogg'
	ai_holder = /datum/ai_holder/simple_animal/urist_humanoid/melee_generic
	say_list_type = /datum/say_list/monster_generic

/mob/living/simple_animal/hostile/urist/mutant/Life()
	if(IsInRange(src.health, 1, (maxHealth - 1)))
		if(prob(25))
			health++ //regenerates while alive
	..()

/mob/living/simple_animal/hostile/urist/mutant/ranged
	desc = "Despite physical and mental degradation, he can still operate a shotgun."
	icon_state = "mutant_ranged"
	icon_living = "mutant_ranged"
	icon_dead = "mutant_dead"
	ranged = 1
	projectilesound = 'sound/weapons/gunshot/shotgun.ogg'
	projectiletype = /obj/item/projectile/bullet/pellet/shotgun //check balance
	attacktext = "kicked"
	attack_sound = 'sound/weapons/genhit3.ogg'
	ai_holder = /datum/ai_holder/simple_animal/urist_humanoid/ranged_generic


/mob/living/simple_animal/hostile/urist/mutant/melee
	desc = "Homicidal, tough bastard wielding a heavy axe."
	icon_state = "mutant_melee"
	icon_living = "mutant_melee"
	icon_dead = "mutant_dead"
	environment_smash = 2
	ranged = 0
	natural_weapon = /obj/item/material/hatchet
	resistance = 5
	attacktext = "hacked"
	attack_sound = 'sound/weapons/slice.ogg'
	ai_holder = /datum/ai_holder/simple_animal/urist_humanoid/melee_generic

/mob/living/simple_animal/hostile/urist/mutant/hybrid
	name = "Xenohybrid"
	desc = "A fast and terrifyingly persistent hunter."
	move_to_delay = 3
	maxHealth = 120
	health = 120
	ranged = 0
	movement_cooldown = 2
	natural_weapon = /obj/item/natural_weapon/claws
	attacktext = "slashed"
	attack_sound = 'sound/weapons/rapidslice.ogg'
	ai_holder = /datum/ai_holder/simple_animal/urist_humanoid/melee_slippery
	say_list_type = /datum/say_list/monster_generic

//A surreal alien with a massive mouth for a face, sprite by Nienhaus
/mob/living/simple_animal/hostile/urist/devourer
	name = "Devourer"
	desc = "What the hell...?"
	icon_state = "eyelien"
	icon_living = "eyelien"
	icon_dead = "eyelien_dead"
	faction = "biohorror"
	attacktext = "chomped"
	attack_sound = 'sound/weapons/bite.ogg'
	maxHealth = 100
	health = 100
	ranged = 1
	fire_desc = "spits"
	projectiletype = /obj/item/projectile/energy/neurotoxin
	projectilesound = 'sound/weapons/bite.ogg'
	ai_holder = /datum/ai_holder/simple_animal/urist_humanoid/melee_slippery
	say_list_type = /datum/say_list/monster_generic


/obj/item/projectile/energy/fireball
	name = "fireball"
	icon_state = "fireball"
	fire_sound = 'sound/effects/squelch1.ogg'
	damage_type = DAMAGE_BURN
	damage = 20
	agony = 10


//even more blatant...
/mob/living/simple_animal/hostile/urist/imp
	name = "imp"
	desc = "Party like it's 1993."
	icon_state = "imp"
	icon_living = "imp"
	icon_dead = "imp_dead"
	faction = "cult"
	ranged = 1
	maxHealth = 75
	health = 75
	projectiletype = /obj/item/projectile/energy/fireball

	natural_weapon = /obj/item/natural_weapon/bite
	attacktext = "slashed"
	attack_sound = 'sound/weapons/rapidslice.ogg'
	ai_holder = /datum/ai_holder/simple_animal/urist_humanoid/ranged_generic
	say_list_type = /datum/say_list/monster_generic

//Angels, old testament style

/mob/living/simple_animal/hostile/urist/angel
	name = "\improper angel"
	desc = "A supposedly divine being known to bring the wrath of their deity."
	response_help = "tries to poke"
	response_disarm = "tries to shove"
	response_harm = "tries to hit"
	attacktext = "smites down"
	icon= 'icons/uristmob/simpleanimals.dmi'
	icon_state = "bluespace-angel"
	icon_living = "bluespace-angel"
	icon_dead = ""
	faction = "divine"
	maxHealth = 50
	health = 50
	natural_weapon = /obj/item/natural_weapon/angel
	projectiletype = /obj/item/projectile/energy/holy
	projectilesound = 'sound/magic/fireball.ogg'
	harm_intent_damage = 0
	needs_reload = TRUE
	reload_time = 2.5 SECONDS
	reload_sound = null


/obj/item/natural_weapon/angel
	name = "holy aura"
	hitsound = 'sound/weapons/slash.ogg'
	attack_verb = list("smited")
	damtype = DAMAGE_BURN
	force = 15

/mob/living/simple_animal/hostile/urist/angel/death()
	..()
	visible_message("<span class='danger'>The [src.name] wails and disappears!</span>")
	playsound(src.loc, 'sound/effects/angel-reveal.ogg', 50, 1)
	flick("forgotten_die", src)
	//sleep(4)
	qdel(src)
	return

/obj/item/projectile/energy/holy
	name = "holy fire"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "fireball"
	fire_sound = 'sound/magic/fireball.ogg'
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GLASS | PASS_FLAG_GRILLE
	damage = 15
	damage_type = DAMAGE_BURN

/obj/item/projectile/energy/holy/strong
	damage = 25

/mob/living/simple_animal/hostile/urist/angel/angry
	name = "\improper angel"
	icon_state = "angel-angry"
	icon_living = "angel-angry"
	maxHealth = 75
	health = 75
	projectiletype = /obj/item/projectile/energy/holy/strong


/mob/living/simple_animal/hostile/urist/angel/bronze
	name = "\improper angel"
	icon_state = "bronze-angel"
	icon_living = "bronze-angel"
	maxHealth = 200
	health = 200
	projectiletype = /obj/item/projectile/energy/holy/strong

//skeletons

/mob/living/simple_animal/hostile/urist/skeleton/ancient
	name = "ancient skeleton"
	desc = "an ancient risen corpse."
	icon= 'icons/uristmob/simpleanimals.dmi'
	icon_state = "draugr1"
	icon_living = "draugr1"
	icon_dead = "skeleton_dead"
	var/body_color

/mob/living/simple_animal/hostile/urist/skeleton/ancient/New()
	..()
	if(!body_color)
		body_color = pick( list("1","2","3","4","5","6") )
	icon_state = "draugr[body_color]"
	icon_living = "draugr[body_color]"

/mob/living/simple_animal/hostile/urist/skeleton/ancient/ranged
	projectiletype = /obj/item/projectile/energy/dart
	projectilesound = 'sound/urist/gotabone.ogg'
	harm_intent_damage = 0
	needs_reload = TRUE
	reload_time = 2.5 SECONDS
	reload_sound = null
