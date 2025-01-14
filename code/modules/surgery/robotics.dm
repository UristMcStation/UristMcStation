//Procedures in this file: Robotic surgery steps, organ removal, replacement. MMI insertion, synthetic organ repair, robone repair
//////////////////////////////////////////////////////////////////
//						ROBOTIC SURGERY							//
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//	generic robotic surgery step datum
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_FLESH | SURGERY_NO_STUMP


/singleton/surgery_step/robotics/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	return SURGERY_SKILLS_ROBOTIC


/singleton/surgery_step/robotics/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if (!affected || HAS_FLAGS(affected.status, ORGAN_CUT_AWAY))
		return FALSE
	return affected

/singleton/surgery_step/robotics/success_chance(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	. = ..()
	if(!user.skill_check(SKILL_DEVICES, SKILL_TRAINED))
		. -= 30
	if(!user.skill_check(SKILL_DEVICES, SKILL_EXPERIENCED))
		. -= 20
	if(user.skill_check(SKILL_DEVICES, SKILL_EXPERIENCED))
		. += 35
	if(user.skill_check(SKILL_DEVICES, SKILL_MASTER))
		. += 30

//////////////////////////////////////////////////////////////////
//	 unscrew robotic limb hatch surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/unscrew_hatch
	name = "Unscrew maintenance hatch"
	allowed_tools = list(
		/obj/item/screwdriver = 60,
		/obj/item/swapper/power_drill = 100,
		/obj/item/material/coin = 30,
		/obj/item/material/knife = 40
	)
	min_duration = 5 SECONDS
	max_duration = 9 SECONDS

/singleton/surgery_step/robotics/unscrew_hatch/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if (!affected || affected.hatch_state != HATCH_CLOSED)
		return FALSE
	return affected

/singleton/surgery_step/robotics/unscrew_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] starts to unscrew the maintenance hatch on \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You start to unscrew the maintenance hatch on \the [target]'s [affected.name] with \the [tool].")
	)
	playsound(target, 'sound/items/Screwdriver.ogg', 15, TRUE)
	..()

/singleton/surgery_step/robotics/unscrew_hatch/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] has opened the maintenance hatch on \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You have opened the maintenance hatch on \the [target]'s [affected.name] with \the [tool].")
	)
	affected.hatch_state = HATCH_UNSCREWED

/singleton/surgery_step/robotics/unscrew_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user]'s [tool.name] slips, failing to unscrew \the [target]'s [affected.name]."),
		SPAN_WARNING("Your [tool.name] slips, failing to unscrew \the [target]'s [affected.name].")
	)

//////////////////////////////////////////////////////////////////
//	 screw robotic limb hatch surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/screw_hatch
	name = "Secure maintenance hatch"
	allowed_tools = list(
		/obj/item/screwdriver = 60,
		/obj/item/swapper/power_drill = 100,
		/obj/item/material/coin = 30,
		/obj/item/material/knife = 40
	)
	min_duration = 5 SECONDS
	max_duration = 9 SECONDS

/singleton/surgery_step/robotics/screw_hatch/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if (!affected || affected.hatch_state != HATCH_UNSCREWED)
		return FALSE
	return affected

/singleton/surgery_step/robotics/screw_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] starts to screw down the maintenance hatch on \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You start to screw down the maintenance hatch on \the [target]'s [affected.name] with \the [tool].")
	)
	playsound(target, 'sound/items/Screwdriver.ogg', 15, TRUE)
	..()

/singleton/surgery_step/robotics/screw_hatch/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] has screwed down the maintenance hatch on \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You have screwed down the maintenance hatch on \the [target]'s [affected.name] with \the [tool].")
	)
	affected.hatch_state = HATCH_CLOSED

/singleton/surgery_step/robotics/screw_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user]'s [tool.name] slips, failing to screw down \the [target]'s [affected.name]."),
		SPAN_WARNING("Your [tool.name] slips, failing to screw down \the [target]'s [affected.name].")
	)

//////////////////////////////////////////////////////////////////
//	open robotic limb surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/open_hatch
	name = "Open maintenance hatch"
	allowed_tools = list(
		/obj/item/retractor = 40,
		/obj/item/crowbar = 60,
		/obj/item/swapper/jaws_of_life = 80,
		/obj/item/material/utensil = 30
	)

	min_duration = 3 SECONDS
	max_duration = 4 SECONDS

/singleton/surgery_step/robotics/open_hatch/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if (!affected || affected.hatch_state != HATCH_UNSCREWED)
		return FALSE
	return affected

/singleton/surgery_step/robotics/open_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] starts to pry open the maintenance hatch on \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You start to pry open the maintenance hatch on \the [target]'s [affected.name] with \the [tool].")
	)
	playsound(target, 'sound/items/Crowbar.ogg', 15, TRUE)
	..()

/singleton/surgery_step/robotics/open_hatch/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] opens the maintenance hatch on \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You open the maintenance hatch on \the [target]'s [affected.name] with \the [tool].")
	)
	affected.hatch_state = HATCH_OPENED

/singleton/surgery_step/robotics/open_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user]'s [tool.name] slips, failing to open the hatch on \the [target]'s [affected.name]."),
		SPAN_WARNING("Your [tool.name] slips, failing to open the hatch on \the [target]'s [affected.name].")
	)

//////////////////////////////////////////////////////////////////
//	close robotic limb surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/close_hatch
	name = "Close maintenance hatch"
	allowed_tools = list(
		/obj/item/retractor = 40,
		/obj/item/crowbar = 60,
		/obj/item/swapper/jaws_of_life = 80,
		/obj/item/material/utensil = 30
	)

	min_duration = 7 SECONDS
	max_duration = 10 SECONDS

/singleton/surgery_step/robotics/close_hatch/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if (!affected || affected.hatch_state != HATCH_OPENED)
		return FALSE
	return affected

/singleton/surgery_step/robotics/close_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] begins to close the hatch on \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You begin to close the hatch on \the [target]'s [affected.name] with \the [tool].")
	)
	playsound(target, 'sound/items/Crowbar.ogg', 15, TRUE)
	..()

/singleton/surgery_step/robotics/close_hatch/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] closes the hatch on \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You close the hatch on \the [target]'s [affected.name] with \the [tool].")
	)
	affected.hatch_state = HATCH_UNSCREWED
	affected.germ_level = 0

/singleton/surgery_step/robotics/close_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user]'s [tool.name] slips, failing to close the hatch on \the [target]'s [affected.name]."),
		SPAN_WARNING("Your [tool.name] slips, failing to close the hatch on \the [target]'s [affected.name].")
	)

//////////////////////////////////////////////////////////////////
//	robotic limb brute damage repair surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/repair_brute
	name = "Repair damage to prosthetic"
	allowed_tools = list(
		/obj/item/weldingtool = 35,
		/obj/item/weldingtool/electric = 50,
		/obj/item/gun/energy/plasmacutter = 25,
		/obj/item/psychic_power/psiblade/master = 100
	)

	min_duration = 7 SECONDS
	max_duration = 9 SECONDS

/singleton/surgery_step/robotics/repair_brute/success_chance(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	. = ..()
	if(user.skill_check(SKILL_CONSTRUCTION, SKILL_BASIC))
		. += 5
	if(user.skill_check(SKILL_CONSTRUCTION, SKILL_TRAINED))
		. += 10
	if(!user.skill_check(SKILL_DEVICES, SKILL_EXPERIENCED))
		. -= 10


/singleton/surgery_step/robotics/repair_brute/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!affected)
		return FALSE

	if (!affected.brute_dam)
		USE_FEEDBACK_FAILURE("\The [target]'s [affected.name] has no physical damage to repair.")
		return FALSE

	if (BP_IS_BRITTLE(affected))
		USE_FEEDBACK_FAILURE("\The [target]'s [affected.name] is too brittal to be repaired normally.")
		return FALSE

	if (isWelder(tool))
		var/obj/item/weldingtool/welder = tool
		if (!welder.remove_fuel(1, user))
			return FALSE

	if (istype(tool, /obj/item/gun/energy/plasmacutter))
		var/obj/item/gun/energy/plasmacutter/cutter = tool
		if (!cutter.slice(user))
			return FALSE

	return TRUE


/singleton/surgery_step/robotics/repair_brute/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if (!affected || affected.hatch_state != HATCH_OPENED || (!HAS_FLAGS(affected.status, ORGAN_DISFIGURED) && affected.brute_dam <= 0))
		return FALSE
	return affected

/singleton/surgery_step/robotics/repair_brute/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] begins to patch damage to \the [target]'s [affected.name]'s support structure with \a [tool]."),
		SPAN_NOTICE("You begin to patch damage to \the [target]'s [affected.name]'s support structure with \the [tool].")
	)
	playsound(target, 'sound/items/Welder.ogg', 15, TRUE)
	..()

/singleton/surgery_step/robotics/repair_brute/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] finishes patching damage to \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You finish patching damage to \the [target]'s [affected.name] with \the [tool].")
	)
	affected.heal_damage(rand(30,50), 0, 1, 1)
	CLEAR_FLAGS(affected.status, ORGAN_DISFIGURED)

/singleton/surgery_step/robotics/repair_brute/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user]'s [tool.name] slips, damaging the internal structure of \the [target]'s [affected.name]."),
		SPAN_WARNING("Your [tool.name] slips, damaging the internal structure of \the [target]'s [affected.name].")
	)
	target.apply_damage(rand(5, 10), DAMAGE_BURN, affected)

//////////////////////////////////////////////////////////////////
//	robotic limb brittleness repair surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/repair_brittle
	name = "Reinforce prosthetic"
	allowed_tools = list(/obj/item/stack/nanopaste = 50)
	min_duration = 5 SECONDS
	max_duration = 6 SECONDS

/singleton/surgery_step/robotics/repair_brittle/success_chance(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	. = ..()
	if(user.skill_check(SKILL_ELECTRICAL, SKILL_TRAINED))
		. += 10
	if(user.skill_check(SKILL_CONSTRUCTION, SKILL_TRAINED))
		. += 10
	if(!user.skill_check(SKILL_DEVICES, SKILL_EXPERIENCED))
		. -= 15

/singleton/surgery_step/robotics/repair_brittle/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if (!affected || !BP_IS_BRITTLE(affected) || affected.hatch_state != HATCH_OPENED)
		return FALSE
	return affected

/singleton/surgery_step/robotics/repair_brittle/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] begins to repair the brittle metal inside \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You begin to repair the brittle metal inside \the [target]'s [affected.name] with \the [tool].")
	)
	playsound(target, 'sound/items/bonegel.ogg', 50, TRUE)
	..()

/singleton/surgery_step/robotics/repair_brittle/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] finishes repairing the brittle interior of \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You finish repairing the brittle interior of \the [target]'s [affected.name] with \the [tool].")
	)
	CLEAR_FLAGS(affected.status, ORGAN_BRITTLE)

/singleton/surgery_step/robotics/repair_brittle/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user] causes some of \the [target]'s [affected.name] to crumble with \the [tool]!"),
		SPAN_WARNING("You cause some of \the [target]'s [affected.name] to crumble with \the [tool]!")
	)
	target.apply_damage(rand(5, 10), DAMAGE_BRUTE, affected)

//////////////////////////////////////////////////////////////////
//	robotic limb burn damage repair surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/repair_burn
	name = "Repair burns on prosthetic"
	allowed_tools = list(
		/obj/item/stack/cable_coil = 50
	)
	min_duration = 7 SECONDS
	max_duration = 9 SECONDS

/singleton/surgery_step/robotics/repair_burn/success_chance(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	. = ..()

	if(user.skill_check(SKILL_ELECTRICAL, SKILL_BASIC))
		. += 5
	if(user.skill_check(SKILL_ELECTRICAL, SKILL_TRAINED))
		. += 10
	if(!user.skill_check(SKILL_DEVICES, SKILL_EXPERIENCED))
		. -= 10


/singleton/surgery_step/robotics/repair_burn/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!affected)
		return FALSE

	if (!affected.burn_dam)
		USE_FEEDBACK_FAILURE("\The [target]'s [affected.name] has no burns to repair.")
		return FALSE

	if (BP_IS_BRITTLE(affected))
		USE_FEEDBACK_FAILURE("\The [target]'s [affected.name] is too brittle for this kind of repair.")
		return FALSE

	var/obj/item/stack/cable_coil/cable = tool
	if (!cable.use(3))
		USE_FEEDBACK_STACK_NOT_ENOUGH(cable, 3, "to repair the burns in \the [target]'s [affected.name].")
		return FALSE

	return TRUE


/singleton/surgery_step/robotics/repair_burn/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if (!affected || affected.hatch_state != HATCH_OPENED || (!HAS_FLAGS(affected.status, ORGAN_DISFIGURED) && affected.burn_dam <= 0))
		return FALSE
	return affected

/singleton/surgery_step/robotics/repair_burn/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] begins to splice new cabling into \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You begin to splice new cabling into \the [target]'s [affected.name] with \the [tool].")
	)
	playsound(target, 'sound/items/Deconstruct.ogg', 15, TRUE)
	..()

/singleton/surgery_step/robotics/repair_burn/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] finishes splicing cable into \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You finishes splicing new cable into \the [target]'s [affected.name] with \the [tool].")
	)
	affected.heal_damage(0, rand(30, 50), 1, 1)
	CLEAR_FLAGS(affected.status, ORGAN_DISFIGURED)

/singleton/surgery_step/robotics/repair_burn/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user] causes a short circuit in \the [target]'s [affected.name] with \the [tool]!"),
		SPAN_WARNING("You cause a short circuit in \the [target]'s [affected.name] with \the [tool]!")
	)
	target.apply_damage(rand(5, 10), DAMAGE_BURN, affected)

//////////////////////////////////////////////////////////////////
//	 artificial organ repair surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/fix_organ_robotic //For artificial organs
	name = "Repair prosthetic organ"
	allowed_tools = list(
		/obj/item/stack/nanopaste = 60,
		/obj/item/bonegel = 20,
		/obj/item/screwdriver = 30,
		/obj/item/swapper/power_drill = 50,
	)
	min_duration = 8 SECONDS
	max_duration = 11 SECONDS
	surgery_candidate_flags = SURGERY_NO_STUMP


/singleton/surgery_step/robotics/fix_organ_robotic/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	if (target.isSynthetic())
		return SURGERY_SKILLS_ROBOTIC
	return SURGERY_SKILLS_ROBOTIC_ON_MEAT


/singleton/surgery_step/robotics/fix_organ_robotic/success_chance(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	. = ..()
	if(!target.isSynthetic())
		if(user.skill_check(SKILL_ANATOMY, SKILL_EXPERIENCED))
			. += 30
		if(user.skill_check(SKILL_MEDICAL, SKILL_EXPERIENCED))
			. += 30

/singleton/surgery_step/robotics/fix_organ_robotic/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if (!affected)
		return FALSE
	for (var/obj/item/organ/internal/organ in affected.internal_organs)
		if (!BP_IS_ROBOTIC(organ) || BP_IS_CRYSTAL(organ) || organ.damage <= 0)
			return FALSE
		if (!organ.surface_accessible)
			return FALSE
	if (affected.how_open() < (affected.encased ? SURGERY_ENCASED : SURGERY_RETRACTED) && affected.hatch_state != HATCH_OPENED)
		return FALSE
	return affected

/singleton/surgery_step/robotics/fix_organ_robotic/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for (var/obj/item/organ/internal in affected.internal_organs)
		if (internal.damage <= 0)
			continue
		if (!BP_IS_ROBOTIC(internal))
			continue
		user.visible_message(
			SPAN_NOTICE("\The [user] starts mending the damage to \the [target]'s [internal.name]'s mechanisms with \a [tool]."),
			SPAN_NOTICE("You start mending the damage to \the [target]'s [internal.name]'s mechanisms with \the [tool].")
		)
	playsound(target, 'sound/items/bonegel.ogg', 50, TRUE)
	..()

/singleton/surgery_step/robotics/fix_organ_robotic/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for (var/obj/item/organ/internal in affected.internal_organs)
		if (internal.damage <= 0)
			continue
		if (!BP_IS_ROBOTIC(internal))
			continue
		user.visible_message(
			SPAN_NOTICE("\The [user] repairs \the [target]'s [internal.name] with \a [tool]."),
			SPAN_NOTICE("You repair \the [target]'s [internal.name] with \the [tool].")
		)
		internal.damage = 0

/singleton/surgery_step/robotics/fix_organ_robotic/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user]'s hand slips, gumming up the mechanisms inside of \the [target]'s [affected.name] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, gumming up the mechanisms inside of \the [target]'s [affected.name] with \the [tool]!")
	)
	target.adjustToxLoss(5)
	affected.createwound(INJURY_TYPE_CUT, 5)
	for (var/obj/item/organ/internal/internal in affected.internal_organs)
		internal.take_internal_damage(rand(3, 5))

//////////////////////////////////////////////////////////////////
//	robotic organ detachment surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/detatch_organ_robotic
	name = "Decouple prosthetic organ"
	allowed_tools = list(
		/obj/item/device/multitool = 70
	)
	min_duration = 9 SECONDS
	max_duration = 11 SECONDS
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_FLESH | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT


/singleton/surgery_step/robotics/detatch_organ_robotic/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!affected)
		return FALSE

	var/list/attached_organs = list()
	for (var/organ_key in target.internal_organs_by_name)
		var/obj/item/organ/organ = target.internal_organs_by_name[organ_key]
		if (!organ)
			continue
		if (HAS_FLAGS(organ.status, ORGAN_CUT_AWAY))
			continue
		if (BP_IS_CRYSTAL(organ))
			continue
		if (organ.parent_organ != target_zone)
			continue
		var/image/radial_button = image(icon = organ.icon, icon_state = organ.icon_state)
		radial_button.name = "Detach \the [organ.name]"
		attached_organs[organ.organ_tag] = radial_button

	if (!LAZYLEN(attached_organs))
		USE_FEEDBACK_FAILURE("\The [target]'s [affected.name] has nothing to detatch.")
		return FALSE

	var/organ_to_remove
	if (length(attached_organs) == 1 && user.get_preference_value(/datum/client_preference/surgery_skip_radial))
		organ_to_remove = attached_organs[1]
	else
		organ_to_remove = show_radial_menu(user, tool, attached_organs, radius = 42, require_near = TRUE, use_labels = TRUE, check_locs = list(tool))
		if (!organ_to_remove || !user.use_sanity_check(target, tool))
			return FALSE

	return TRUE


/singleton/surgery_step/robotics/detatch_organ_robotic/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/affected = target.get_organ(target_zone)
	var/obj/removing = target.internal_organs_by_name[LAZYACCESS(target.surgeries_in_progress, target_zone)]
	user.visible_message(
		SPAN_NOTICE("\The [user] starts to decouple \a [removing] from \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You start to decouple \the [removing] from \the [target]'s [affected.name] with \the [tool].")
	)
	playsound(target, 'sound/items/Deconstruct.ogg', 15, TRUE)
	..()

/singleton/surgery_step/robotics/detatch_organ_robotic/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/affected = target.get_organ(target_zone)
	var/obj/removing = LAZYACCESS(target.surgeries_in_progress, target_zone)
	user.visible_message(
		SPAN_NOTICE("[user] has decoupled \a [removing] from \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You have decoupled \the [removing] from \the [target]'s [affected.name] with \the [tool].")
	)

	var/obj/item/organ/internal/internal = target.internal_organs_by_name[LAZYACCESS(target.surgeries_in_progress, target_zone)]
	if (!istype(internal))
		return
	internal.cut_away(user)

/singleton/surgery_step/robotics/detatch_organ_robotic/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, disconnecting \the [tool] from \the [target]."),
		SPAN_WARNING("Your hand slips, disconnecting \the [tool] from \the [target].")
	)

//////////////////////////////////////////////////////////////////
//	robotic organ transplant finalization surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/attach_organ_robotic
	name = "Attach prosthetic organ"
	allowed_tools = list(
		/obj/item/screwdriver = 50,
		/obj/item/swapper/power_drill = 70,
	)
	min_duration = 10 SECONDS
	max_duration = 12 SECONDS
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_FLESH | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT


/singleton/surgery_step/robotics/attach_organ_robotic/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!affected)
		return FALSE

	var/list/obj/item/organ/candidates = list()
	for (var/obj/item/organ/organ in affected.implants)
		if (!HAS_FLAGS(organ.status, ORGAN_CUT_AWAY))
			continue
		if (!HAS_FLAGS(organ.status, ORGAN_ROBOTIC))
			continue
		if (HAS_FLAGS(organ.status, ORGAN_CRYSTAL))
			continue
		if (organ.parent_organ != target_zone)
			continue
		if (organ.organ_tag in target.internal_organs_by_name)
			continue
		var/image/radial_button = image(icon = organ.icon, icon_state = organ.icon_state)
		radial_button.name = "Attach \the [organ]"
		candidates[organ] = radial_button

	var/obj/item/organ/selected
	if (length(candidates) == 1 && user.get_preference_value(/datum/client_preference/surgery_skip_radial))
		selected = candidates[1]
	else
		selected = show_radial_menu(user, tool, candidates, radius = 42, require_near = TRUE, use_labels = TRUE, check_locs = list(tool))
		if (!selected || !user.use_sanity_check(target, tool))
			return FALSE

	if (istype(selected, /obj/item/organ/internal/augment))
		var/obj/item/organ/internal/augment/augment = selected
		if (!HAS_FLAGS(augment.augment_flags, AUGMENT_MECHANICAL))
			USE_FEEDBACK_FAILURE("\The [target]'s [affected.name] is robotic but \the [augment] cannot be installed into a robotic part.")
			return FALSE

	return selected


/singleton/surgery_step/robotics/attach_organ_robotic/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/affected = target.get_organ(target_zone)
	var/obj/attaching = LAZYACCESS(target.surgeries_in_progress, target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] begins attaching \a [attaching] to \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You start attaching \the [attaching] to \the [target]'s [affected.name] with \the [tool].")
	)
	playsound(target, 'sound/items/Screwdriver.ogg', 15, TRUE)
	..()

/singleton/surgery_step/robotics/attach_organ_robotic/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/attaching = target.surgeries_in_progress?[target_zone]
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	affected.implants -= attaching
	CLEAR_FLAGS(attaching.status, ORGAN_CUT_AWAY)
	attaching.replaced(target, affected)
	user.visible_message(
		SPAN_NOTICE("\The [user] has attached \the [target]'s [attaching.name] with \a [tool]."),
		SPAN_NOTICE("You have attached \the [target]'s [attaching.name] with \the [tool].")
	)


/singleton/surgery_step/robotics/attach_organ_robotic/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("\The [user]'s hand slips, disconnecting \the [tool] from \the [target]."),
		SPAN_WARNING("Your hand slips, disconnecting \the [tool] from \the [target].")
	)

//////////////////////////////////////////////////////////////////
//	mmi installation surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/install_mmi
	name = "Install MMI"
	allowed_tools = list(
		/obj/item/device/mmi = 100
	)
	min_duration = 6 SECONDS
	max_duration = 8 SECONDS
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_FLESH | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT


/singleton/surgery_step/robotics/install_mmi/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!affected)
		return FALSE

	var/obj/item/device/mmi/mmi = tool
	if (!istype(mmi))
		return FALSE

	if (!mmi.brainmob || !mmi.brainmob.client || !mmi.brainmob.ckey || mmi.brainmob.stat >= DEAD)
		USE_FEEDBACK_FAILURE("\The [mmi] has no brain or the brain is dead or unusable.")
		return FALSE

	if (!target.isSynthetic())
		USE_FEEDBACK_FAILURE("\The [mmi] can only be installed in robotic bodies.")
		return FALSE

	if (BP_IS_CRYSTAL(affected))
		USE_FEEDBACK_FAILURE("The crystalline interior of \the [target]'s [affected.name] is incompatible with \the [mmi].")
		return FALSE

	if (!target.should_have_organ(BP_BRAIN))
		USE_FEEDBACK_FAILURE("\The [target] doesn't have a space for a brain.")
		return FALSE

	var/obj/item/brain = target.internal_organs[BP_BRAIN]
	if (brain)
		USE_FEEDBACK_FAILURE("\The [target]'s [affected.name] already has \a [brain].")
		return FALSE

	return TRUE


/singleton/surgery_step/robotics/install_mmi/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (target_zone != BP_HEAD)
		return FALSE
	return ..()

/singleton/surgery_step/robotics/install_mmi/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] starts installing \a [tool] into [target]'s [affected.name]."),
		SPAN_NOTICE("You start installing \the [tool] into [target]'s [affected.name].")
	)
	playsound(target, 'sound/items/bonesetter.ogg', 50, TRUE)
	..()

/singleton/surgery_step/robotics/install_mmi/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!user.unEquip(tool))
		FEEDBACK_UNEQUIP_FAILURE(user, tool)
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] has installed \a [tool] into \the [target]'s [affected.name]."),
		SPAN_NOTICE("You have installed \the [tool] into \the [target]'s [affected.name].")
	)

	var/obj/item/device/mmi/mmi = tool
	var/obj/item/organ/internal/mmi_holder/holder = new(target, 1)
	target.internal_organs_by_name[BP_BRAIN] = holder
	tool.forceMove(holder)
	holder.stored_mmi = tool
	holder.update_from_mmi()

	if (mmi.brainmob?.mind)
		mmi.brainmob.mind.transfer_to(target)

/singleton/surgery_step/robotics/install_mmi/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("\The [user]'s hand slips while trying to install \the [tool] in \the [target]."),
		SPAN_WARNING("Your hand slips while trying to install \the [tool] in \the [target].")
	)

/singleton/surgery_step/internal/remove_organ/robotic
	name = "Remove robotic component"
	can_infect = FALSE
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_FLESH | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT

/singleton/surgery_step/internal/replace_organ/robotic
	name = "Replace robotic component"
	can_infect = FALSE
	robotic_surgery = TRUE
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_FLESH | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT

/singleton/surgery_step/remove_mmi
	name = "Remove MMI"
	min_duration = 6 SECONDS
	max_duration = 8 SECONDS
	allowed_tools = list(
		/obj/item/hemostat = 100,
		/obj/item/wirecutters = 75,
		/obj/item/material/utensil/fork = 20
	)
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_FLESH | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT


/singleton/surgery_step/remove_mmi/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	return SURGERY_SKILLS_ROBOTIC


/singleton/surgery_step/remove_mmi/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if (!affected || !((locate(/obj/item/device/mmi) in affected.implants)))
		return FALSE
	return affected

/singleton/surgery_step/remove_mmi/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] starts poking around inside [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You start poking around inside [target]'s [affected.name] with \the [tool].")
	)
	target.custom_pain("The pain in your [affected.name] is living hell!", 1, affecting = affected)
	playsound(target, 'sound/items/bonesetter.ogg', 50, TRUE)
	..()

/singleton/surgery_step/remove_mmi/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!affected)
		return
	var/obj/item/device/mmi/mmi = locate() in affected.implants
	if (mmi)
		user.visible_message(
			SPAN_NOTICE("\The [user] removes \a [mmi] from \the [target]'s [affected.name] with \a [tool]."),
			SPAN_NOTICE("You  remove \the [mmi] from \the [target]'s [affected.name] with \the [tool].")
		)
		target.remove_implant(mmi, TRUE, affected)
	else
		user.visible_message(
			SPAN_NOTICE("\The [user] could not find anything inside \the [target]'s [affected.name]."),
			SPAN_NOTICE("You could not find anything inside \the [target]'s [affected.name].")
		)

/singleton/surgery_step/remove_mmi/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message( \
	SPAN_WARNING("\The [user]'s hand slips, damaging \the [target]'s [affected.name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, damaging \the [target]'s [affected.name] with \the [tool]!"))
	affected.take_external_damage(3, 0, used_weapon = tool)

//////////////////////////////////////////////////////////////////
//					BROKEN PROSTHETIC SURGERY					//
//////////////////////////////////////////////////////////////////

/singleton/surgery_step/robotics/robone
	surgery_candidate_flags = SURGERY_NO_FLESH | SURGERY_NO_CRYSTAL | SURGERY_NEEDS_ENCASEMENT
	var/required_stage = 0

/singleton/surgery_step/robotics/robone/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if (!affected || !HAS_FLAGS(affected.status, ORGAN_BROKEN) || affected.stage != required_stage)
		return FALSE
	return affected


/singleton/surgery_step/robotics/robone/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	if (target.isSynthetic())
		return SURGERY_SKILLS_ROBOTIC
	return SURGERY_SKILLS_ROBOTIC_ON_MEAT


//////////////////////////////////////////////////////////////////
//	welding surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/robone/weld
	name = "Begin structural support repair"
	allowed_tools = list(
		/obj/item/weldingtool = 50,
		/obj/item/tape_roll = 30,
		/obj/item/bonegel = 30
	)
	min_duration = 5 SECONDS
	max_duration = 6 SECONDS

/singleton/surgery_step/robotics/robone/weld/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/prosthetic = affected.encased ? "\the [target]'s [affected.encased]" : "structural support in \the [target]'s [affected.name]"
	if (affected.stage == 0)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts mending \the [prosthetic] with \a [tool]."),
			SPAN_NOTICE("You start mending \the [prosthetic] with \the [tool].")
		)
	playsound(target, 'sound/items/Welder.ogg', 15, TRUE)
	..()

/singleton/surgery_step/robotics/robone/weld/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/prosthetic = affected.encased ? "\the [target]'s [affected.encased]" : "structural support in \the [target]'s [affected.name]"
	user.visible_message(
		SPAN_INFO("\The [user] finishes mending \the [prosthetic] with \a [tool]"),
		SPAN_INFO("You finish mending \the [prosthetic] with \the [tool].")
	)
	if (affected.stage == 0)
		affected.stage = 1
	CLEAR_FLAGS(affected.status, ORGAN_BRITTLE)

/singleton/surgery_step/robotics/robone/weld/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user]'s hand slips, causing damage with \the [tool] in the open panel on \the [target]'s [affected.name]!"),
		SPAN_WARNING("Your hand slips, causing damage with \the [tool] in the open panel on \the [target]'s [affected.name]!")
	)
	affected.take_external_damage(5, 0, used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	prosthetic realignment surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/robone/realign_support
	name = "Realign support"
	allowed_tools = list(
		/obj/item/swapper/power_drill = 100,
		/obj/item/wrench = 70,
		/obj/item/bonesetter = 50
	)
	min_duration = 6 SECONDS
	max_duration = 7 SECONDS
	shock_level = 40
	delicate = TRUE
	surgery_candidate_flags = SURGERY_NO_FLESH | SURGERY_NEEDS_ENCASEMENT
	required_stage = 1

/singleton/surgery_step/robotics/robone/realign_support/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/prosthetic = affected.encased ? "\the [target]'s [affected.encased]" : "structural support in \the [target]'s [affected.name]"
	if(affected.encased == "skull")
		user.visible_message(
			SPAN_NOTICE("\The [user] begins to piece \the [prosthetic] back together with \a [tool]."),
			SPAN_NOTICE("You begin to piece \the [prosthetic] back together with \the [tool].")
		)
	else
		user.visible_message(
			SPAN_NOTICE("\The [user] is beginning to twist \the [prosthetic] in place with \a [tool]."),
			SPAN_NOTICE("You are beginning to twist \the [prosthetic] in place with \the [tool].")
		)
	playsound(target, 'sound/items/bonesetter.ogg', 50, TRUE)
	..()

/singleton/surgery_step/robotics/robone/realign_support/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/prosthetic = affected.encased ? "\the [target]'s [affected.encased]" : "structural support in \the [target]'s [affected.name]"
	if (HAS_FLAGS(affected.status, ORGAN_BROKEN))
		if (affected.encased == "skull")
			user.visible_message(
				SPAN_INFO("\The [user] pieces \the [prosthetic] back together with \a [tool]."),
				SPAN_INFO("You piece \the [prosthetic] back together with \the [tool].")
			)
		else
			user.visible_message(
				SPAN_INFO("\The [user] twists \the [prosthetic] in place with \a [tool]."),
				SPAN_INFO("You twist \the [prosthetic] in place with \the [tool].")
			)
		affected.stage = 2
	else
		user.visible_message(
			SPAN_WARNING("\The [user] twists \the [prosthetic] in the WRONG place with \a [tool]!."),
			SPAN_WARNING("You twist \the [prosthetic] in the WRONG place with \the [tool]!.")
		)
		affected.fracture()

/singleton/surgery_step/robotics/robone/realign_support/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user]'s hand slips, damaging the [affected.encased ? affected.encased : "structural support"] in \the [target]'s [affected.name] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, damaging the [affected.encased ? affected.encased : "structural support"] in \the [target]'s [affected.name] with \the [tool]!")
	)
	affected.fracture()
	affected.take_external_damage(5, used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	post realignment surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/robone/finish
	name = "Finish structural support repair"
	allowed_tools = list(
		/obj/item/weldingtool = 50,
		/obj/item/tape_roll = 30,
		/obj/item/bonegel = 30
	)
	min_duration = 5 SECONDS
	max_duration = 6 SECONDS
	required_stage = 2

/singleton/surgery_step/robotics/robone/finish/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/prosthetic = affected.encased ? "\the [target]'s damaged [affected.encased]" : "structural support in \the [target]'s [affected.name]"
	user.visible_message(
		SPAN_NOTICE("\the [user] starts to finish mending [prosthetic] with \a [tool]."),
		SPAN_NOTICE("You start to finish mending [prosthetic] with \the [tool].")
	)
	playsound(target, 'sound/items/Welder.ogg', 15, TRUE)
	..()

/singleton/surgery_step/robotics/robone/finish/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/prosthetic = affected.encased ? "\the [target]'s damaged [affected.encased]" : "structural support in \the [target]'s [affected.name]"
	user.visible_message(
		SPAN_INFO("\The [user] has finished mending [prosthetic] with \a [tool]."),
		SPAN_INFO("You have finished mending [prosthetic] with \the [tool]." )
	)
	CLEAR_FLAGS(affected.status, ORGAN_BROKEN)
	affected.stage = 0
	affected.update_wounds()

/singleton/surgery_step/robotics/robone/finish/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user]'s hand slips, causing damage with \the [tool] in the open panel in \the [target]'s [affected.name]!"),
		SPAN_WARNING("Your hand slips, causing damage with \the [tool] in the open panel in \the [target]'s [affected.name]!")
	)
	affected.take_external_damage(5, 0, used_weapon = tool)
