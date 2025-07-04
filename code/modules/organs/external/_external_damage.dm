/****************************************************
			   DAMAGE PROCS
****************************************************/

/obj/item/organ/external/proc/is_damageable(additional_damage = 0)
	//Continued damage to vital organs can kill you, and robot organs don't count towards total damage so no need to cap them.
	return (BP_IS_ROBOTIC(src) || brute_dam + burn_dam + additional_damage < max_damage * 4)

/obj/item/organ/external/take_general_damage(amount, silent = FALSE)
	take_external_damage(amount)

/obj/item/organ/external/proc/take_external_damage(brute, burn, damage_flags, used_weapon = null)

	brute = round(brute * get_brute_mod(damage_flags), 0.1)
	burn = round(burn * get_burn_mod(damage_flags), 0.1)

	if((brute <= 0) && (burn <= 0))
		return 0

	var/sharp = (damage_flags & DAMAGE_FLAG_SHARP)
	var/edge  = (damage_flags & DAMAGE_FLAG_EDGE)
	var/laser = (damage_flags & DAMAGE_FLAG_LASER)
	var/blunt = !!(brute && !sharp && !edge)

	// Handle some status-based damage multipliers.
	if(BP_IS_CRYSTAL(src) && burn && laser)
		brute += burn // Stress fracturing from heat!
		owner.bodytemperature += burn
		burn = 0
		if(prob(25))
			owner.visible_message(SPAN_WARNING("\The [owner]'s crystalline [name] shines with absorbed energy!"))

	if(used_weapon)
		add_autopsy_data("[used_weapon]", brute + burn)

	var/spillover = 0
	var/pure_brute = brute
	if(!is_damageable(brute + burn))
		spillover =  brute_dam + burn_dam + brute - max_damage
		if(spillover > 0)
			brute -= spillover
		else
			spillover = brute_dam + burn_dam + brute + burn - max_damage
			if(spillover > 0)
				burn = max(burn - spillover, 0)
	//If limb took enough damage, try to cut or tear it off
	if(owner && loc == owner)
		owner.updatehealth() //droplimb will call updatehealth() again if it does end up being called
		if(!is_stump() && (limb_flags & ORGAN_FLAG_CAN_AMPUTATE) && config.limbs_can_break)
			var/total_damage = brute_dam + burn_dam + brute + burn + spillover
			var/threshold = max_damage * config.organ_health_multiplier
			if(total_damage > threshold)
				if(attempt_dismemberment(pure_brute, burn, sharp, edge, used_weapon, spillover, total_damage > threshold*6))
					return

	//blunt damage is gud at fracturing
	if(brute_dam + brute > min_broken_damage && prob(brute_dam + brute * (1+blunt)) )
		fracture()

	// High brute damage or sharp objects may damage internal organs
	if(LAZYLEN(internal_organs))
		if(damage_internal_organs(brute, burn, damage_flags))
			brute /= 2
			burn /= 2

	if (owner && (status & ORGAN_BROKEN) && brute)
		jostle_bone(brute)
		if(can_feel_pain() && prob(40))
			owner.emote("scream")	//getting hit on broken hand hurts

	// If the limbs can break, make sure we don't exceed the maximum damage a limb can take before breaking
	var/datum/wound/created_wound
	var/block_cut = (species.species_flags & SPECIES_FLAG_NO_MINOR_CUT) && brute <= 15
	var/can_cut = !block_cut && !BP_IS_ROBOTIC(src) && (sharp || prob(brute))

	if(brute)
		var/to_create = INJURY_TYPE_BRUISE
		if(can_cut)
			to_create = INJURY_TYPE_CUT
			//need to check sharp again here so that blunt damage that was strong enough to break skin doesn't give puncture wounds
			if(sharp && !edge)
				to_create = INJURY_TYPE_PIERCE
		created_wound = createwound(to_create, brute)

	if(burn)
		if(laser)
			createwound(INJURY_TYPE_LASER, burn)
			if(owner && prob(40))
				owner.IgniteMob()
		else
			createwound(INJURY_TYPE_BURN, burn)

	//Initial pain spike
	add_pain(0.6*burn + 0.4*brute)

	//Disturb treated burns
	if(brute > 5)
		var/disturbed = 0
		for(var/datum/wound/burn/W in wounds)
			if((W.disinfected || W.salved) && prob(brute + W.damage))
				W.disinfected = 0
				W.salved = 0
				disturbed += W.damage
		if(owner && disturbed)
			to_chat(owner,SPAN_WARNING("Ow! Your burns were disturbed."))
			add_pain(0.5*disturbed)

	//If there are still hurties to dispense
	if (owner && spillover)
		owner.shock_stage += spillover * config.organ_damage_spillover_multiplier

	// sync the organ's damage with its wounds
	update_damages()
	if (owner)
		owner.updatehealth()
		if(status & ORGAN_BLEEDING)
			owner.update_bandages()

		if(update_damstate())
			owner.UpdateDamageIcon()

	if(created_wound && isobj(used_weapon))
		var/obj/O = used_weapon
		O.after_wounding(src, created_wound)

	return created_wound

/obj/item/organ/external/proc/damage_internal_organs(brute, burn, damage_flags)
	if(!LAZYLEN(internal_organs))
		return FALSE

	var/laser = (damage_flags & DAMAGE_FLAG_LASER)

	var/damage_amt = brute
	var/cur_damage = brute_dam
	if(laser || BP_IS_ROBOTIC(src))
		damage_amt += burn
		cur_damage += burn_dam

	if(!damage_amt)
		return FALSE

	var/organ_damage_threshold = 10
	if(damage_flags & DAMAGE_FLAG_SHARP)
		organ_damage_threshold *= 0.75
	if(laser)
		organ_damage_threshold *= 1.5

	if(!(cur_damage + damage_amt >= max_damage) && !(damage_amt >= organ_damage_threshold))
		return FALSE

	var/list/victims = list()
	var/organ_hit_chance = 0
	for(var/obj/item/organ/internal/I in internal_organs)
		if(I.damage < I.max_damage)
			victims[I] = I.relative_size

	//No damageable organs
	if(!length(victims))
		return FALSE

	organ_hit_chance += 10 * (damage_amt/organ_damage_threshold) * (cur_damage/max_damage)

	if(encased && !(status & ORGAN_BROKEN)) //ribs protect
		organ_hit_chance *= 0.6

	organ_hit_chance = min(organ_hit_chance, 100)
	if(prob(organ_hit_chance))
		var/obj/item/organ/internal/victim = pickweight(victims)
		damage_amt -= max(damage_amt*victim.damage_reduction, 0)
		victim.take_internal_damage(damage_amt)
		return TRUE

/obj/item/organ/external/heal_damage(brute, burn, internal = 0, robo_repair = 0)
	if(BP_IS_ROBOTIC(src) && !robo_repair)
		return

	//Heal damage on the individual wounds
	for(var/datum/wound/W in wounds)
		if(brute == 0 && burn == 0)
			break

		// heal brute damage
		if (W.damage_type == INJURY_TYPE_BURN)
			burn = W.heal_damage(burn)
		else
			brute = W.heal_damage(brute)

	if(internal)
		status &= ~ORGAN_BROKEN

	//Sync the organ's damage with its wounds
	src.update_damages()
	owner.updatehealth()

	return update_damstate()

// Brute/burn
/obj/item/organ/external/proc/get_brute_damage()
	return brute_dam

/obj/item/organ/external/proc/get_burn_damage()
	return burn_dam

// Geneloss/cloneloss.
/obj/item/organ/external/proc/get_genetic_damage()
	return ((species && (species.species_flags & SPECIES_FLAG_NO_SCAN)) || BP_IS_ROBOTIC(src)) ? 0 : genetic_degradation

/obj/item/organ/external/proc/remove_genetic_damage(amount)
	if((species.species_flags & SPECIES_FLAG_NO_SCAN) || BP_IS_ROBOTIC(src))
		genetic_degradation = 0
		status &= ~ORGAN_MUTATED
		return
	var/last_gene_dam = genetic_degradation
	genetic_degradation = min(100,max(0,genetic_degradation - amount))
	if(genetic_degradation <= 30)
		if(status & ORGAN_MUTATED)
			unmutate()
			to_chat(src, SPAN_NOTICE("Your [name] is shaped normally again."))
	return -(genetic_degradation - last_gene_dam)

/obj/item/organ/external/proc/add_genetic_damage(amount)
	if((species.species_flags & SPECIES_FLAG_NO_SCAN) || BP_IS_ROBOTIC(src))
		genetic_degradation = 0
		status &= ~ORGAN_MUTATED
		return
	var/last_gene_dam = genetic_degradation
	genetic_degradation = min(100,max(0,genetic_degradation + amount))
	if(genetic_degradation > 30)
		if(!(status & ORGAN_MUTATED) && prob(genetic_degradation))
			mutate()
			to_chat(owner, SPAN_NOTICE("Something is not right with your [name]..."))
	return (genetic_degradation - last_gene_dam)

/obj/item/organ/external/proc/mutate()
	if(BP_IS_ROBOTIC(src))
		return
	src.status |= ORGAN_MUTATED
	if(owner) owner.update_body()

/obj/item/organ/external/proc/unmutate()
	if(!BP_IS_DEFORMED(src) && !BP_IS_ROBOTIC(src))
		src.status &= ~ORGAN_MUTATED
		if(owner) owner.update_body()

// Pain/halloss
/obj/item/organ/external/proc/get_pain()
	if(!can_feel_pain() || BP_IS_ROBOTIC(src))
		return 0
	var/lasting_pain = 0
	if(is_broken())
		lasting_pain += 10
	else if(is_dislocated())
		lasting_pain += 5
	var/tox_dam = 0
	for(var/obj/item/organ/internal/I in internal_organs)
		tox_dam += I.getToxLoss()
	return pain + lasting_pain + 0.7 * brute_dam + 0.8 * burn_dam + 0.3 * tox_dam + 0.5 * get_genetic_damage()

/obj/item/organ/external/proc/remove_pain(amount)
	if(!can_feel_pain())
		pain = 0
		return
	var/last_pain = pain
	pain = max(0,min(max_damage,pain-amount))
	return -(pain-last_pain)

/obj/item/organ/external/proc/add_pain(amount)
	if(!can_feel_pain())
		pain = 0
		return
	var/last_pain = pain
	if(owner)
		amount -= (owner.chem_effects[CE_PAINKILLER]/3)
		if(amount <= 0)
			return
	pain = max(0,min(max_damage,pain+amount))
	if(owner && ((amount > 30 && prob(20)) || (amount > 60 && prob(40))))
		owner.emote("scream")
	return pain-last_pain

/obj/item/organ/external/proc/stun_act(stun_amount, agony_amount)
	if(agony_amount && owner && can_feel_pain())
		agony_amount -= (owner.chem_effects[CE_PAINKILLER]/2)//painkillers does wonders!
		agony_amount += get_pain()
		if(agony_amount < 5) return

		if(limb_flags & ORGAN_FLAG_CAN_GRASP)
			if(prob((agony_amount/max_damage)*100))
				owner.grasp_damage_disarm(src)
				return 1

		else if((limb_flags & ORGAN_FLAG_CAN_STAND))
			if(prob((agony_amount/max_damage)*100))
				owner.stance_damage_prone(src)
				return 1

		else if(agony_amount > 0.5 * max_damage)
			owner.visible_message(SPAN_WARNING("[owner] reels in pain!"))
			if(agony_amount > max_damage)
				owner.Weaken(4)
			else
				owner.Stun(4)
				owner.drop_l_hand()
				owner.drop_r_hand()
			return 1

/obj/item/organ/external/proc/get_agony_multiplier()
	return has_genitals() ? 1.5 : 1

/obj/item/organ/external/proc/sever_artery()
	if(species && species.has_organ[BP_HEART])
		var/obj/item/organ/internal/heart/O = species.has_organ[BP_HEART]
		if(!BP_IS_ROBOTIC(src) && !(status & ORGAN_ARTERY_CUT) && !initial(O.open) && !(encased && !(status & ORGAN_BROKEN)))
			status |= ORGAN_ARTERY_CUT
			return TRUE
	return FALSE

/obj/item/organ/external/proc/sever_tendon()
	if((limb_flags & ORGAN_FLAG_HAS_TENDON) && !BP_IS_ROBOTIC(src) && !(status & ORGAN_TENDON_CUT))
		status |= ORGAN_TENDON_CUT
		return TRUE
	return FALSE

/obj/item/organ/external/proc/get_brute_mod(damage_flags)
	var/reduction = 1
	for(var/obj/item/organ/internal/augment/armor/armor_aug in owner.internal_organs)
		reduction = reduction * armor_aug.brute_mult
	var/base_armor = 1
	if(reduction != 1)
		base_armor = reduction
	if(!BP_IS_ROBOTIC(src))
		base_armor *= species.get_brute_mod(owner)
	var/blunt = !(damage_flags & DAMAGE_FLAG_EDGE|DAMAGE_FLAG_SHARP)
	if(blunt && BP_IS_BRITTLE(src))
		base_armor *= 1.5
	if(BP_IS_CRYSTAL(src))
		base_armor *= 0.8
	return base_armor + (0.2 * burn_dam/max_damage) //burns make you take more brute damage

/obj/item/organ/external/proc/get_burn_mod(damage_flags)
	var/reduction = 1
	for(var/obj/item/organ/internal/augment/armor/armor_aug in owner.internal_organs)
		reduction = reduction * armor_aug.burn_mult
	var/base_armor = 1
	if(reduction != 1)
		base_armor = reduction
	if(!BP_IS_ROBOTIC(src))
		base_armor *= species.get_burn_mod(owner)
	if(BP_IS_CRYSTAL(src))
		base_armor *= 0.1
	return base_armor

//organs can come off in three cases
//1. If the damage source is edge_eligible and the brute damage dealt exceeds the edge threshold, then the organ is cut off.
//2. If the damage amount dealt exceeds the disintegrate threshold, the organ is completely obliterated.
//3. If the organ has already reached or would be put over it's max damage amount (currently redundant),
//   and the brute damage dealt exceeds the tearoff threshold, the organ is torn off.
/obj/item/organ/external/proc/attempt_dismemberment(brute, burn, sharp, edge, used_weapon, spillover, force_droplimb)
	//Check edge eligibility
	var/edge_eligible = 0
	if(edge)
		if(istype(used_weapon,/obj/item))
			var/obj/item/W = used_weapon
			if(W.w_class >= w_class)
				edge_eligible = 1
		else
			edge_eligible = 1
	else if(sharp)
		brute = 0.5 * brute
	if(force_droplimb)
		if(burn)
			droplimb(0, DROPLIMB_BURN)
		else if(brute)
			droplimb(0, edge_eligible ? DROPLIMB_EDGE : DROPLIMB_BLUNT)
		return TRUE

	if(edge_eligible && brute >= max_damage / DROPLIMB_THRESHOLD_EDGE)
		if(prob(brute))
			droplimb(0, DROPLIMB_EDGE)
			return TRUE
	else if(burn >= max_damage / DROPLIMB_THRESHOLD_DESTROY)
		if(prob(burn/3))
			droplimb(0, DROPLIMB_BURN)
			return TRUE
	else if(brute >= max_damage / DROPLIMB_THRESHOLD_DESTROY)
		if(prob(brute))
			droplimb(0, DROPLIMB_BLUNT)
			return TRUE
	else if(brute >= max_damage / DROPLIMB_THRESHOLD_TEAROFF)
		if(prob(brute/3))
			droplimb(0, DROPLIMB_EDGE)
			return TRUE
