
/****************************************************
					WOUNDS
****************************************************/
/datum/wound
	var/current_stage = 0      // number representing the current stage
	var/desc = "wound"         // description of the wound. default in case something borks
	var/damage = 0             // amount of damage this wound causes
	var/bleed_timer = 0        // ticks of bleeding left.
	var/bleed_threshold = 30   // Above this amount wounds you will need to treat the wound to stop bleeding, regardless of bleed_timer
	var/min_damage = 0         // amount of damage the current wound type requires(less means we need to apply the next healing stage)
	var/bandaged = 0           // is the wound bandaged?
	var/clamped = 0            // Similar to bandaged, but works differently
	var/salved = 0             // is the wound salved?
	var/disinfected = 0        // is the wound disinfected?
	var/created = 0
	var/amount = 1             // number of wounds of this type
	var/germ_level = 0         // amount of germs in the wound
	var/obj/item/organ/external/parent_organ	// the organ the wound is on, if on an organ

	/*  These are defined by the wound type and should not be changed */
	var/list/stages            // stages such as "cut", "deep cut", etc.
	var/max_bleeding_stage = 0 // maximum stage at which bleeding should still happen. Beyond this stage bleeding is prevented.
	/// String (One of `DAMAGE_TYPE_*`). The wound's injury type.
	var/damage_type = INJURY_TYPE_CUT
	var/autoheal_cutoff = 15   // the maximum amount of damage that this wound can have and still autoheal

	// helper lists
	var/list/embedded_objects
	var/list/desc_list = list()
	var/list/damage_list = list()

/datum/wound/New(damage, obj/item/organ/external/organ = null)

	created = world.time

	// reading from a list("stage" = damage) is pretty difficult, so build two separate
	// lists from them instead
	for(var/V in stages)
		desc_list += V
		damage_list += stages[V]

	src.damage = damage

	// initialize with the appropriate stage
	src.init_stage(damage)

	bleed_timer += damage

	if(istype(organ))
		parent_organ = organ

/datum/wound/Destroy()
	if(parent_organ)
		LAZYREMOVE(parent_organ.wounds, src)
		parent_organ = null
	LAZYCLEARLIST(embedded_objects)
	. = ..()

// returns 1 if there's a next stage, 0 otherwise
/datum/wound/proc/init_stage(initial_damage)
	current_stage = length(stages)

	while(src.current_stage > 1 && src.damage_list[current_stage-1] <= initial_damage / src.amount)
		src.current_stage--

	src.min_damage = damage_list[current_stage]
	src.desc = desc_list[current_stage]

// the amount of damage per wound
/datum/wound/proc/wound_damage()
	return src.damage / src.amount

/datum/wound/proc/can_autoheal()
	if(LAZYLEN(embedded_objects))
		return 0
	return (wound_damage() <= autoheal_cutoff) ? 1 : is_treated()

// checks whether the wound has been appropriately treated
/datum/wound/proc/is_treated()
	if(!LAZYLEN(embedded_objects))
		switch(damage_type)
			if (INJURY_TYPE_BRUISE, INJURY_TYPE_CUT, INJURY_TYPE_PIERCE)
				return bandaged
			if (INJURY_TYPE_BURN)
				return salved

	// Checks whether other other can be merged into src.
/datum/wound/proc/can_merge(datum/wound/other)
	if (other.type != src.type) return 0
	if (other.current_stage != src.current_stage) return 0
	if (other.damage_type != src.damage_type) return 0
	if (!(other.can_autoheal()) != !(src.can_autoheal())) return 0
	if (other.is_surgical() != src.is_surgical()) return 0
	if (!(other.bandaged) != !(src.bandaged)) return 0
	if (!(other.clamped) != !(src.clamped)) return 0
	if (!(other.salved) != !(src.salved)) return 0
	if (!(other.disinfected) != !(src.disinfected)) return 0
	return 1

/datum/wound/proc/merge_wound(datum/wound/other)
	if(LAZYLEN(other.embedded_objects))
		LAZYDISTINCTADD(src.embedded_objects, other.embedded_objects)
	src.damage += other.damage
	src.amount += other.amount
	src.bleed_timer += other.bleed_timer
	src.germ_level = max(src.germ_level, other.germ_level)
	src.created = max(src.created, other.created)	//take the newer created time
	qdel(other)

// checks if wound is considered open for external infections
// untreated cuts (and bleeding bruises) and burns are possibly infectable, chance higher if wound is bigger
/datum/wound/proc/infection_check()
	if (damage < 10)	//small cuts, tiny bruises, and moderate burns shouldn't be infectable.
		return 0
	if (is_treated() && damage < 25)	//anything less than a flesh wound (or equivalent) isn't infectable if treated properly
		return 0
	if (disinfected)
		germ_level = 0	//reset this, just in case
		return 0

	if (damage_type == INJURY_TYPE_BRUISE && !bleeding()) //bruises only infectable if bleeding
		return 0

	var/dam_coef = round(damage/10)
	switch (damage_type)
		if (INJURY_TYPE_BRUISE)
			return prob(dam_coef*5)
		if (INJURY_TYPE_BURN)
			return prob(dam_coef*25)
		if (INJURY_TYPE_CUT)
			return prob(dam_coef*10)

	return 0

/datum/wound/proc/bandage()
	bandaged = 1

/datum/wound/proc/salve()
	salved = 1

/datum/wound/proc/disinfect()
	disinfected = 1

// heal the given amount of damage, and if the given amount of damage was more
// than what needed to be healed, return how much heal was left
/datum/wound/proc/heal_damage(amount)
	if(LAZYLEN(embedded_objects))
		return amount // heal nothing
	if(parent_organ)
		if (damage_type == INJURY_TYPE_BURN && !(parent_organ.burn_ratio < 100 || (parent_organ.limb_flags & ORGAN_FLAG_HEALS_OVERKILL)))
			return amount	//We don't want to heal wounds on irreparable organs.
		else if(!(parent_organ.brute_ratio < 100 || (parent_organ.limb_flags & ORGAN_FLAG_HEALS_OVERKILL)))
			return amount

	var/healed_damage = min(src.damage, amount)
	amount -= healed_damage
	src.damage -= healed_damage

	while(src.wound_damage() < damage_list[current_stage] && current_stage < length(src.desc_list))
		current_stage++
	desc = desc_list[current_stage]
	src.min_damage = damage_list[current_stage]

	// return amount of healing still leftover, can be used for other wounds
	return amount

// opens the wound again
/datum/wound/proc/open_wound(damage)
	src.damage += damage
	bleed_timer += damage

	while(src.current_stage > 1 && src.damage_list[current_stage-1] <= src.damage / src.amount)
		src.current_stage--

	src.desc = desc_list[current_stage]
	src.min_damage = damage_list[current_stage]

// returns whether this wound can absorb the given amount of damage.
// this will prevent large amounts of damage being trapped in less severe wound types
/datum/wound/proc/can_worsen(damage_type, damage)
	if (src.damage_type != damage_type)
		return 0	//incompatible damage types

	if (src.amount > 1)
		return 0	//merged wounds cannot be worsened.

	//with 1.5*, a shallow cut will be able to carry at most 30 damage,
	//37.5 for a deep cut
	//52.5 for a flesh wound, etc.
	var/max_wound_damage = 1.5*src.damage_list[1]
	if (src.damage + damage > max_wound_damage)
		return 0
	return 1

/datum/wound/proc/bleeding()
	for(var/obj/item/thing in embedded_objects)
		if(thing.w_class > ITEM_SIZE_SMALL)
			return FALSE
	if(bandaged || clamped)
		return FALSE
	return ((bleed_timer > 0 || wound_damage() > bleed_threshold) && current_stage <= max_bleeding_stage)

/datum/wound/proc/is_surgical()
	return 0
