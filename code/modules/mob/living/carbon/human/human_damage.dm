//Updates the mob's health from organs and mob damage variables
/mob/living/carbon/human/updatehealth()

	if(status_flags & GODMODE)
		health = maxHealth
		set_stat(CONSCIOUS)
		return

	health = maxHealth - getBrainLoss()

	//TODO: fix husking
	if(((maxHealth - getFireLoss()) < config.health_threshold_dead) && stat == DEAD)
		ChangeToHusk()
	return

/mob/living/carbon/human/adjustBrainLoss(amount)
	if(status_flags & GODMODE)	return 0	//godmode
	if(should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/brain/sponge = internal_organs_by_name[BP_BRAIN]
		if(sponge)
			sponge.take_internal_damage(amount)

/mob/living/carbon/human/setBrainLoss(amount)
	if(status_flags & GODMODE)	return 0	//godmode
	if(should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/brain/sponge = internal_organs_by_name[BP_BRAIN]
		if(sponge)
			sponge.damage = min(max(amount, 0),sponge.species.total_health)
			updatehealth()

/mob/living/carbon/human/getBrainLoss()
	if(status_flags & GODMODE)	return 0	//godmode
	if(should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/brain/sponge = internal_organs_by_name[BP_BRAIN]
		if(sponge)
			if(sponge.status & ORGAN_DEAD)
				return sponge.species.total_health
			else
				return sponge.damage
		else
			return species.total_health
	return 0

//Straight pain values, not affected by painkillers etc
/mob/living/carbon/human/getHalLoss()
	var/amount = 0
	for(var/obj/item/organ/external/E in organs)
		amount += E.get_pain()
	return amount

/mob/living/carbon/human/setHalLoss(amount)
	adjustHalLoss(getHalLoss()-amount)

/mob/living/carbon/human/adjustHalLoss(amount)
	var/heal = (amount < 0)
	amount = abs(amount)
	var/list/pick_organs = organs.Copy()
	while(amount > 0 && length(pick_organs))
		var/obj/item/organ/external/E = pick(pick_organs)
		pick_organs -= E
		if(!istype(E))
			continue

		if(heal)
			amount -= E.remove_pain(amount)
		else
			amount -= E.add_pain(amount)
	SET_BIT(hud_updateflag, HEALTH_HUD)

//These procs fetch a cumulative total damage from all organs
/mob/living/carbon/human/getBruteLoss()
	var/amount = 0
	for(var/obj/item/organ/external/O in organs)
		if(BP_IS_ROBOTIC(O) && !O.vital)
			continue //robot limbs don't count towards shock and crit
		amount += O.brute_dam
	return amount

/mob/living/carbon/human/getFireLoss()
	var/amount = 0
	for(var/obj/item/organ/external/O in organs)
		if(BP_IS_ROBOTIC(O) && !O.vital)
			continue //robot limbs don't count towards shock and crit
		amount += O.burn_dam
	return amount

/mob/living/carbon/human/adjustBruteLoss(amount)
	if(amount > 0)
		take_overall_damage(amount, 0)
	else
		heal_overall_damage(-amount, 0)
	SET_BIT(hud_updateflag, HEALTH_HUD)

/mob/living/carbon/human/adjustFireLoss(amount)
	if(amount > 0)
		take_overall_damage(0, amount)
	else
		heal_overall_damage(0, -amount)
	SET_BIT(hud_updateflag, HEALTH_HUD)

/mob/living/carbon/human/Stun(amount)
	amount *= species.stun_mod
	if(amount <= 0) return
	..()

/mob/living/carbon/human/Weaken(amount)
	amount *= species.weaken_mod
	if(amount <= 0) return
	if (!lying && species?.bodyfall_sound)
		playsound(loc, species.bodyfall_sound, 50, TRUE, -1)
	if (!lying && species?.bodyfall_sound)
		playsound(loc, species.bodyfall_sound, 50, TRUE, -1)
	..(amount)

/mob/living/carbon/human/Paralyse(amount)
	amount *= species.paralysis_mod
	if(amount <= 0) return
	// Notify our AI if they can now control the suit.
	if(wearing_rig && !stat && paralysis < amount) //We are passing out right this second.
		wearing_rig.notify_ai(SPAN_DANGER("Warning: user consciousness failure. Mobility control passed to integrated intelligence system."))
	..(amount)

/mob/living/carbon/human/getCloneLoss()
	var/amount = 0
	for(var/obj/item/organ/external/E in organs)
		amount += E.get_genetic_damage()
	return amount

/mob/living/carbon/human/setCloneLoss(amount)
	adjustCloneLoss(getCloneLoss()-amount)

/mob/living/carbon/human/adjustCloneLoss(amount)
	var/heal = amount < 0
	amount = abs(amount)

	var/list/pick_organs = organs.Copy()
	while(amount > 0 && length(pick_organs))
		var/obj/item/organ/external/E = pick(pick_organs)
		pick_organs -= E
		if(heal)
			amount -= E.remove_genetic_damage(amount)
		else
			amount -= E.add_genetic_damage(amount)
	SET_BIT(hud_updateflag, HEALTH_HUD)

// Defined here solely to take species flags into account without having to recast at mob/living level.
/mob/living/carbon/human/getOxyLoss()
	if (!need_breathe())
		return 0
	var/obj/item/organ/internal/lungs/lungs = internal_organs_by_name[species.breathing_organ]
	if (!lungs)
		return 100
	return lungs.get_oxygen_deprivation()

/mob/living/carbon/human/setOxyLoss(amount)
	if (!need_breathe())
		return
	amount = (clamp(amount, 0, 100) - getOxyLoss()) / 100
	adjustOxyLoss(amount * species.total_health)

/mob/living/carbon/human/adjustOxyLoss(amount)
	if(!need_breathe())
		return
	var/heal = amount < 0
	var/obj/item/organ/internal/lungs/breathe_organ = internal_organs_by_name[species.breathing_organ]
	if(breathe_organ)
		if(heal)
			breathe_organ.remove_oxygen_deprivation(abs(amount))
		else
			breathe_organ.add_oxygen_deprivation(abs(amount*species.oxy_mod))
	SET_BIT(hud_updateflag, HEALTH_HUD)

/mob/living/carbon/human/getToxLoss()
	if((species.species_flags & SPECIES_FLAG_NO_POISON) || isSynthetic())
		return 0
	var/amount = 0
	for(var/obj/item/organ/internal/I in internal_organs)
		amount += I.getToxLoss()
	return amount

/mob/living/carbon/human/setToxLoss(amount)
	if(!(species.species_flags & SPECIES_FLAG_NO_POISON) && !isSynthetic())
		adjustToxLoss(getToxLoss()-amount)

// TODO: better internal organ damage procs.
/mob/living/carbon/human/adjustToxLoss(amount)

	if((species.species_flags & SPECIES_FLAG_NO_POISON) || isSynthetic())
		return

	var/heal = amount < 0
	amount = abs(amount)

	if (!heal)
		amount = amount * species.get_toxins_mod(src)
		if (CE_ANTITOX in chem_effects)
			amount *= 1 - (chem_effects[CE_ANTITOX] * 0.25)

	var/list/pick_organs = shuffle(internal_organs.Copy())

	// Prioritize damaging our filtration organs first.
	var/obj/item/organ/internal/kidneys/kidneys = internal_organs_by_name[BP_KIDNEYS]
	if(kidneys)
		pick_organs -= kidneys
		pick_organs.Insert(1, kidneys)
	var/obj/item/organ/internal/liver/liver = internal_organs_by_name[BP_LIVER]
	if(liver)
		pick_organs -= liver
		pick_organs.Insert(1, liver)

	// Move the brain to the very end since damage to it is vastly more dangerous
	// (and isn't technically counted as toxloss) than general organ damage.
	var/obj/item/organ/internal/brain/brain = internal_organs_by_name[BP_BRAIN]
	if(brain)
		pick_organs -= brain
		pick_organs += brain

	for(var/obj/item/organ/internal/I in pick_organs)
		if(amount <= 0)
			break
		if(heal)
			if(I.damage < amount)
				amount -= I.damage
				I.damage = 0
			else
				I.damage -= amount
				amount = 0
		else
			var/cap_dam = I.max_damage - I.damage
			if(amount >= cap_dam)
				I.take_internal_damage(cap_dam, silent=TRUE)
				amount -= cap_dam
			else
				I.take_internal_damage(amount, silent=TRUE)
				amount = 0

/mob/living/carbon/human/proc/can_autoheal(dam_type)
	if(!species || !dam_type) return FALSE

	if (dam_type == DAMAGE_BRUTE)
		return(getBruteLoss() < species.total_health / 2)
	else if (dam_type == DAMAGE_BURN)
		return(getFireLoss() < species.total_health / 2)
	return FALSE

////////////////////////////////////////////

//Returns a list of damaged organs
/mob/living/carbon/human/proc/get_damaged_organs(brute, burn)
	var/list/obj/item/organ/external/parts = list()
	for(var/obj/item/organ/external/O in organs)
		if((brute && O.brute_dam) || (burn && O.burn_dam))
			parts += O
	return parts

//Returns a list of damageable organs
/mob/living/carbon/human/proc/get_damageable_organs()
	var/list/obj/item/organ/external/parts = list()
	for(var/obj/item/organ/external/O in organs)
		if(O.is_damageable())
			parts += O
	return parts

//Heals ONE external organ, organ gets randomly selected from damaged ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/heal_organ_damage(brute, burn, affect_robo = 0)
	var/list/obj/item/organ/external/parts = get_damaged_organs(brute,burn)
	if(!length(parts))	return
	var/obj/item/organ/external/picked = pick(parts)
	if(picked.heal_damage(brute,burn,robo_repair = affect_robo))
		SET_BIT(hud_updateflag, HEALTH_HUD)
	updatehealth()


//TODO reorganize damage procs so that there is a clean API for damaging living mobs

/*
In most cases it makes more sense to use apply_damage() instead! And make sure to check armour if applicable.
*/
//Damages ONE external organ, organ gets randomly selected from damagable ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status


/mob/living/carbon/human/take_organ_damage(brute = 0, burn = 0, flags = 0)
	if (!brute && !burn)
		return

	var/list/obj/item/organ/external/organs = get_damageable_organs()

	if (flags & ORGAN_DAMAGE_FLESH_ONLY)
		var/index = length(organs)
		while (index > 0)
			if (BP_IS_ROBOTIC(organs[index]))
				organs.Cut(index, index + 1)
			--index

	if (flags & ORGAN_DAMAGE_ROBOT_ONLY)
		var/index = length(organs)
		while (index > 0)
			if (!BP_IS_ROBOTIC(organs[index]))
				organs.Cut(index, index + 1)
			--index

	if (!length(organs))
		return

	var/damage_flags = 0
	if (flags & ORGAN_DAMAGE_SHARP)
		damage_flags |= DAMAGE_FLAG_SHARP
	if (flags & ORGAN_DAMAGE_EDGE)
		damage_flags |= DAMAGE_FLAG_EDGE

	var/obj/item/organ/external/organ = pick(organs)
	if (organ.take_external_damage(brute, burn, damage_flags))
		SET_BIT(hud_updateflag, HEALTH_HUD)
	updatehealth()


//Heal MANY external organs, in random order
/mob/living/carbon/human/heal_overall_damage(brute, burn)
	var/list/obj/item/organ/external/parts = get_damaged_organs(brute,burn)

	while(length(parts) && (brute>0 || burn>0) )
		var/obj/item/organ/external/picked = pick(parts)

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam

		picked.heal_damage(brute,burn)

		brute -= (brute_was-picked.brute_dam)
		burn -= (burn_was-picked.burn_dam)

		parts -= picked
	updatehealth()
	SET_BIT(hud_updateflag, HEALTH_HUD)

// damage MANY external organs, in random order
/mob/living/carbon/human/take_overall_damage(brute, burn, sharp = FALSE, edge = FALSE, used_weapon = null)
	if(status_flags & GODMODE)	return	//godmode
	var/list/obj/item/organ/external/parts = get_damageable_organs()
	if(!length(parts)) return

	var/dam_flags = (sharp? DAMAGE_FLAG_SHARP : 0)|(edge? DAMAGE_FLAG_EDGE : 0)
	var/brute_avg = brute / length(parts)
	var/burn_avg = burn / length(parts)
	for(var/obj/item/organ/external/E in parts)
		if(QDELETED(E))
			continue
		if(E.owner != src)
			continue // The code below may affect the children of an organ.

		if(brute_avg)
			apply_damage(damage = brute_avg, damagetype = DAMAGE_BRUTE, damage_flags = dam_flags, used_weapon = used_weapon, silent = TRUE, given_organ = E)
		if(burn_avg)
			apply_damage(damage = burn_avg, damagetype = DAMAGE_BURN, damage_flags = dam_flags, used_weapon = used_weapon, silent = TRUE, given_organ = E)

	updatehealth()
	SET_BIT(hud_updateflag, HEALTH_HUD)


////////////////////////////////////////////

/*
This function restores the subjects blood to max.
*/
/mob/living/carbon/human/proc/restore_blood()
	if(!should_have_organ(BP_HEART))
		return
	if(vessel.total_volume < species.blood_volume)
		vessel.add_reagent(/datum/reagent/blood, species.blood_volume - vessel.total_volume)

/*
This function restores all organs.
*/
/mob/living/carbon/human/restore_all_organs(ignore_prosthetic_prefs)
	for(var/bodypart in BP_BY_DEPTH)
		var/obj/item/organ/external/current_organ = organs_by_name[bodypart]
		if(istype(current_organ))
			current_organ.rejuvenate(ignore_prosthetic_prefs)
	verbs -= /mob/living/carbon/human/proc/undislocate

/mob/living/carbon/human/proc/HealDamage(zone, brute, burn)
	var/obj/item/organ/external/E = get_organ(zone)
	if(istype(E, /obj/item/organ/external))
		if (E.heal_damage(brute, burn))
			SET_BIT(hud_updateflag, HEALTH_HUD)
	else
		return 0
	return


/mob/living/carbon/human/proc/get_organ(zone)
	return organs_by_name[check_zone(zone)]

/mob/living/carbon/human/apply_damage(damage = 0, damagetype = DAMAGE_BRUTE, def_zone, damage_flags = FLAGS_OFF, obj/used_weapon, armor_pen, silent = FALSE, obj/item/organ/external/given_organ)

	var/obj/item/organ/external/organ = given_organ
	if(!organ)
		if(isorgan(def_zone))
			organ = def_zone
		else
			if(!def_zone)
				if(damage_flags & DAMAGE_FLAG_DISPERSED)
					var/old_damage = damage
					var/tally
					silent = TRUE // Will damage a lot of organs, probably, so avoid spam.
					for(var/zone in organ_rel_size)
						tally += organ_rel_size[zone]
					for(var/zone in organ_rel_size)
						damage = old_damage * organ_rel_size[zone]/tally
						def_zone = zone
						. = .() || .
					return
				def_zone = ran_zone(def_zone)
			organ = get_organ(check_zone(def_zone))

	//Handle other types of damage
	if (!(damagetype in list(DAMAGE_BRUTE, DAMAGE_BURN, DAMAGE_PAIN, DAMAGE_GENETIC)))
		return ..()
	if(!istype(organ))
		return 0 // This is reasonable and means the organ is missing.

	handle_suit_punctures(damagetype, damage, def_zone)

	var/list/after_armor = modify_damage_by_armor(def_zone, damage, damagetype, damage_flags, src, armor_pen, silent)
	damage = after_armor[1]
	damagetype = after_armor[2]
	damage_flags = after_armor[3]
	if(!damage)
		return 0

	if(damage > 15 && prob(damage*4) && organ.can_feel_pain())
		make_reagent(round(damage/10), /datum/reagent/adrenaline)
	var/datum/wound/created_wound
	damageoverlaytemp = 20
	switch(damagetype)
		if (DAMAGE_BRUTE)
			created_wound = organ.take_external_damage(damage, 0, damage_flags, used_weapon)
		if (DAMAGE_BURN)
			created_wound = organ.take_external_damage(0, damage, damage_flags, used_weapon)
		if (DAMAGE_PAIN)
			organ.add_pain(damage)
		if (DAMAGE_GENETIC)
			organ.add_genetic_damage(damage)

	// Will set our damageoverlay icon to the next level, which will then be set back to the normal level the next mob.Life().
	updatehealth()
	SET_BIT(hud_updateflag, HEALTH_HUD)
	return created_wound

// Find out in how much pain the mob is at the moment.
/mob/living/carbon/human/proc/get_shock()

	if (!can_feel_pain())
		return 0

	var/traumatic_shock = getHalLoss()                 // Pain.
	traumatic_shock -= chem_effects[CE_PAINKILLER] // TODO: check what is actually stored here.

	if(stat == UNCONSCIOUS)
		traumatic_shock *= 0.6
	return max(0,traumatic_shock)
