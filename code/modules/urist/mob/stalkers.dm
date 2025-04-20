/*
** Fancy 'boss' mobs.
*/


/obj/item/natural_weapon/martial_arts
	name = "\improper martial arts technique"
	attack_verb = list("punched", "kicked", "kneed", "karate-chopped", "jabbed", "elbowed", "slapped", "headbutted")
	show_in_message = FALSE
	force = 15
	attack_cooldown = 2


/obj/item/material/armblade/wrist/stalker/can_embed()
	return FALSE

/obj/item/material/hatchet/machete/steel/stalker/can_embed()
	return FALSE


/datum/ai_holder/simple_animal/urist_humanoid/stalker
	threaten = FALSE //Verbal threats
	can_breakthrough = TRUE //Can break through doors
	violent_breakthrough = TRUE
	speak_chance = 0 //Babble chance
	wander = TRUE //Wander around
	returns_home = FALSE
	home_low_priority = TRUE //Following/helping is more important
	pointblank = FALSE // Use your fancy melee
	dying_threshold = 0.1
	lose_target_timeout = 60 SECONDS

	run_if_this_close = 0
	melee_hitnrun_prob = 5
	melee_slippery = TRUE
	ranged_slippery = TRUE
	aggressive_charge_to = 1
	aggro_healthperc_threshold = 0.35
	prefer_cover_proba = 10


//TOUGH bastard, teleports around to follow a victim (random if none, varedit to set)
/mob/living/simple_animal/hostile/urist/stalker
	name = "psycho"
	desc = "Implacable killer."
	faction = "psychos"
	icon_state = "psycho"
	icon_living = "psycho"
	icon_dead = "psycho_dead"
	environment_smash = 1
	maxHealth = 500
	health = 500
	resistance = 6
	ranged = 0
	move_to_delay = 4
	movement_cooldown = 8
	natural_weapon = /obj/item/material/hatchet/machete/steel/stalker
	attacktext = "slashed"
	attack_sound = 'sound/weapons/rapidslice.ogg'
	attack_same = 1
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES
	)

	// CUSTOM STUFF
	var/caution = 1 //hit and run if low on health

	var/flickerlights = 0 //for more fun - can fuck with lights around the victim to get a TP zone.
	//var/datum/effect/tele_effect = null //something to spawn when teleporting/disappearing, presumably effects
	ai_holder = /datum/ai_holder/simple_animal/urist_humanoid/stalker

	// CUSTOM STUFF:
	// switch natural weapons:
	var/list/natural_weapon_arsenal = list(/obj/item/material/hatchet/machete/steel)
	var/list/natural_weapons_cache = list() // assoc cache of instances for types

	// teleport special...
	var/teleport_revenge = TRUE // special - if TRUE, will return to chase the threat that forced him to TP away
	var/teleport_antiprob = 95 // (100% - probability of teleporting)

	// ...and its metadata
	var/turf/best_jump_loc = null
	var/best_jump_loc_findtime = null
	var/best_jump_loc_timeout = 60 SECONDS

/*
/mob/living/simple_animal/hostile/urist/stalker/New()
	..()
	GetNewStalkee()

/mob/living/simple_animal/hostile/urist/stalker/proc/GetNewStalkee(mindplease = 1)
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

/mob/living/simple_animal/hostile/urist/stalker/Found(atom/A)
	if(A == stalkee)
		return 1
	return 0

/mob/living/simple_animal/hostile/urist/stalker/Life()
	if(..())
		if(stalkee)
			if(stalkee.stat == DEAD)
				GetNewStalkee()
			else if(stance == STANCE_IDLE)
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
	var/list/destinations = list()

	for(var/turf/T in range(5, stalkee))
		if(istype(T,/turf/space)) continue
		if(T.density) continue
		if(T in range(src, 9)) continue //so they don't teleport pointlessly while in range
		if(shadow_check(T, 1))
			destinations += T

	if(length(destinations))
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

/mob/living/simple_animal/hostile/urist/stalker/proc/HandleTeleFX(atom/fxloc)
	if(tele_effect)
		var/datum/effect/fx_instance = new tele_effect()
		fx_instance.set_up(3, 0, fxloc)
		fx_instance.start()

/mob/living/simple_animal/hostile/urist/stalker/UnarmedAttack(atom/A, var/proximity)
	..()
	if(!client && caution) //run awaaaay!
		HuntingTeleport()
*/


/mob/living/simple_animal/hostile/urist/stalker/proc/SwitchNaturalWeapons(probability = 100)
	// Fanciness: will switch natural weapons!
	var/safe_proba = clamp(probability || 25, 0, 100)

	if(prob(safe_proba))
		var/natural_weapon_pick = pick(src.natural_weapon_arsenal)

		if(ispath(natural_weapon_pick))
			var/uncached_weapon = src.natural_weapons_cache[natural_weapon_pick]

			if(isnull(uncached_weapon))
				uncached_weapon = new natural_weapon_pick(src)
				src.natural_weapons_cache[natural_weapon_pick] = uncached_weapon

			src.natural_weapon = uncached_weapon

	return src.natural_weapon


/mob/living/simple_animal/hostile/urist/stalker/proc/FindEscapeLoc(atom/A)
	set waitfor = 0

	. = src.best_jump_loc

	if(!isnull(src.best_jump_loc_findtime))
		var/deltaT = (world.time - src.best_jump_loc_findtime) + rand(-5, 5) // slight fuzzing to be less predictable

		if(deltaT <= (src.best_jump_loc_timeout || deltaT))
			// If the cooldown is below a certain limit, reuse the cached solution
			return .

	// if we got here, we needed to replan
	// this should stop other calls from redoing the ops here
	// (since we hadn't reached the cooldown)
	src.best_jump_loc = null
	src.best_jump_loc_findtime = world.time

	var/turf/threat_loc = get_turf(A)
	var/turf/start_loc = get_turf(src)
	var/awaydir = get_dir(threat_loc, start_loc)

	for(var/stepcount = 0, stepcount < 10, stepcount++)
		// For variety, shift dirs a bit randomly
		// The left- and right-turns are deliberately independent
		// On the net, this should mean they ROUGHLY stick to the original awaydir.

		if(prob(20))
			awaydir = turn(awaydir, -45)

		if(prob(20))
			awaydir = turn(awaydir, 45)

		start_loc = get_step(start_loc, awaydir)

	var/list/candidates = trange(5, start_loc)
	var/list/threat_view = view(threat_loc)

	var/turf/optimal_turf = null
	var/best_turf_score = null
	var/cand_idx = 0

	for(var/turf/Cand in candidates)
		if((++cand_idx % 5) == 0)
			// This might take a while, release the thread every 5 blocks processed.
			// We're generally not relying on the return value here, because DM is dumb with async.
			// The true 'return value' of this proc is updating src.best_jump_loc (and associated metadata).
			sleep(-1)

		if(Cand.density)
			// ignore walls etc.
			continue

		var/cand_score = null

		if(!(Cand in threat_view))
			optimal_turf = Cand
			break

		cand_score = get_dist(Cand, threat_loc)

		if(cand_score > best_turf_score)
			optimal_turf = Cand
			best_turf_score = cand_score

	src.best_jump_loc = optimal_turf

	return optimal_turf


/mob/living/simple_animal/hostile/urist/stalker/should_special_attack(atom/A)
	. = ..()

	var/curr_time = world.time

	if(isnull(src.best_jump_loc) || ((curr_time - (src.best_jump_loc_findtime || curr_time)) > (best_jump_loc_timeout || 60 SECONDS)))
		src.FindEscapeLoc(A)
		return FALSE

	var/healthPerc = (src.health || 0) / max(1, (src.maxHealth || 1))

	if(healthPerc > 0.5)
		return FALSE

	if(prob(clamp(src.teleport_antiprob || 0, 0, 100)))
		return FALSE

	return TRUE


/mob/living/simple_animal/hostile/urist/stalker/do_special_attack(atom/A)
	// Special: can teleport away from danger
	do_teleport(src, src.best_jump_loc)
	src.ai_holder?.home_turf = src.best_jump_loc

	// Will try to return to eliminate the last threat that forced him to TP away
	if(teleport_revenge)
		var/tele_time = rand(120, 300)
		spawn(tele_time SECONDS)
			var/turf/threat_turf = get_turf(A)
			if(!isnull(threat_turf))
				src.ai_holder?.home_turf = threat_turf

	. = ..()
	return TRUE


//Spess Jason Bourne

// Might be too havy to do here
/mob/living/simple_animal/hostile/urist/stalker/hitman/get_natural_weapon()
	src.SwitchNaturalWeapons()
	. = ..()


/obj/item/projectile/bullet/pistol/holdout/silenced
	fire_sound = 'sound/urist/suppshot.ogg'


/mob/living/simple_animal/hostile/urist/stalker/hitman
	// Base class for a ranged stalker. Effectively a boss monster!

	name = "\improper Black Ops specialist"
	desc = "A highly-trained, augmented assassin. You've clearly REALLY pissed *someone* off."

	icon_state = "skrellagent"
	icon_living = "skrellagent"
	icon_dead = "skrellagent_dead"

	ranged = 1
	rapid = 0
	shot_time = 4
	maxHealth = 500
	health = 500
	move_to_delay = 3
	movement_cooldown = 2
	projectilesound = 'sound/urist/suppshot.ogg'
	attacktext = "brutalized"
	attack_sound = 'sound/weapons/punch3.ogg' //overridden in AttackTarget!
	attack_same = 0

	natural_weapon = /obj/item/natural_weapon/martial_arts
	projectiletype = /obj/item/projectile/bullet/pistol/holdout/silenced
	casingtype = null
	projectile_accuracy = 5
	projectile_dispersion  = 0

	// Reloads
	reload_max = 15  // modelled after beretta m9

	// AI spec
	ai_holder = /datum/ai_holder/simple_animal/urist_humanoid/stalker
	say_list_type = /datum/say_list/professional

	// Stalker stuff
	natural_weapon_arsenal = list(/obj/item/natural_weapon/martial_arts)

/* VARIANTS */

/mob/living/simple_animal/hostile/urist/stalker/hitman/ntis
	name = "\improper NTIS Assassin"
	desc = "A spook from the Internal Security department. You suddenly get an unpleasant sensation that you 'know too much'."
	faction = "NTIS"

	icon_state = "agent"
	icon_living = "agent"
	icon_dead = "agent_dead"

	natural_weapon_arsenal = list(/obj/item/material/armblade/wrist/stalker, /obj/item/natural_weapon/martial_arts)



/mob/living/simple_animal/hostile/urist/stalker/hitman/antag
	name = "\improper ANTAG infiltrator"
	desc = "A shifty pro-alien quisling, made into a killing machine using black-market genemods and bionics."
	faction = "alien"

	icon_state = "ANTAG_light"
	icon_living = "ANTAG_light"
	icon_dead = "ANTAG_light_dead"

	natural_weapon_arsenal = list(/obj/item/natural_weapon/martial_arts)



/mob/living/simple_animal/hostile/urist/stalker/hitman/blackops
	icon_state = "blackop_human"
	icon_living = "blackop_human"
	icon_dead = "blackop_human_dead"

	faction = "gunman"
	ranged = 1
	rapid = 2
	shot_time = 1

	natural_weapon = /obj/item/natural_weapon/martial_arts

	projectile_accuracy = -3 // to compensate for rapid-fire
	projectile_dispersion = 2

	// Reloads
	reload_max = 15  // modelled after Steyr TMP

	natural_weapon_arsenal = list(/obj/item/material/hatchet/machete/steel/stalker, /obj/item/natural_weapon/martial_arts)


/mob/living/simple_animal/hostile/urist/stalker/hitman/skrell
	name = "\improper Skrellian specialist"
	desc = "An elite Special Forces operative of Skrellian separatists."
	faction = "skrellt"

	icon_state = "blackop_skrell"
	icon_living = "blackop_skrell"
	icon_dead = "blackop_skrell_dead"

	faction = "skrellt"
	ranged = 1
	rapid = 4
	shot_time = 1

	natural_weapon = /obj/item/natural_weapon/martial_arts

	projectile_accuracy = -4 // to compensate for rapid-fire and b/c Skrellorists are a bit of a meme
	projectile_dispersion = 2

	// Reloads
	reload_max = 25  // OG Uzi; extra capacity to compensate for poor aim

	natural_weapon_arsenal = list(/obj/item/material/hatchet/machete/steel/stalker, /obj/item/natural_weapon/martial_arts)
