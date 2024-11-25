//Procedures in this file: internal organ surgery, removal, transplants
//////////////////////////////////////////////////////////////////
//						INTERNAL ORGANS							//
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/internal
	can_infect = TRUE
	blood_level = BLOOD_LEVEL_HANDS
	shock_level = 40
	delicate = TRUE
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT

//////////////////////////////////////////////////////////////////
//	Organ mending surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/internal/fix_organ
	name = "Repair internal organ"
	allowed_tools = list(
		/obj/item/stack/medical/advanced/bruise_pack = 100,
		/obj/item/stack/medical/bruise_pack = 40,
		/obj/item/tape_roll = 20
	)
	min_duration = 7 SECONDS
	max_duration = 9 SECONDS
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP

/singleton/surgery_step/internal/fix_organ/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if (!affected)
		return FALSE
	for (var/obj/item/organ/internal/organ in affected.internal_organs)
		if (organ.damage <= 0)
			return FALSE
		if (!organ.surface_accessible && (affected.how_open() < (affected.encased ? SURGERY_ENCASED : SURGERY_RETRACTED)))
			return FALSE
	return affected

/singleton/surgery_step/internal/fix_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/tool_name = tool.name
	if (istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
		tool_name = "regenerative membrane"
	else if (istype(tool, /obj/item/stack/medical/bruise_pack))
		tool_name = "bandaid"

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		"\The [user] starts treating damage within \the [target]'s [affected.name] with \a [tool_name].",
		"You start treating damage within \the [target]'s [affected.name] with \the [tool_name]."
	)

	for (var/obj/item/organ/internal/internal in affected.internal_organs)
		if (BP_IS_ROBOTIC(internal))
			continue
		if (internal.damage > 0 && (!HAS_FLAGS(internal.status, ORGAN_DEAD) || internal.can_recover()) && (internal.surface_accessible || affected.how_open() >= (affected.encased ? SURGERY_ENCASED : SURGERY_RETRACTED)))
			user.visible_message(
				SPAN_NOTICE("\The [user] starts treating damage to \the [target]'s [internal.name] with \a [tool_name]."),
				SPAN_NOTICE("You start treating damage to \the [target]'s [internal.name] with \the [tool_name].")
			)
		else if (!(internal.status & ORGAN_CUT_AWAY) && HAS_FLAGS(internal.status, ORGAN_DEAD) && internal.parent_organ == affected.organ_tag)
			if (!internal.can_recover())
				to_chat(user, SPAN_WARNING("\The [target]'s [internal.name] is fully necrotic; \the [tool_name] won't help here."))
			else
				to_chat(user, SPAN_WARNING("\The [target]'s [internal.name] is decaying; you'll need more than just \the [tool_name] here."))

	target.custom_pain("The pain in your [affected.name] is living hell!", 100, affecting = affected)
	playsound(target, 'sound/items/bonegel.ogg', 50, TRUE)
	..()

/singleton/surgery_step/internal/fix_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/tool_name = "\the [tool]"
	if (istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
		tool_name = "regenerative membrane"
	if (istype(tool, /obj/item/stack/medical/bruise_pack))
		tool_name = "the bandaid"
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I && I.damage > 0 && !BP_IS_ROBOTIC(I) && (I.surface_accessible || affected.how_open() >= (affected.encased ? SURGERY_ENCASED : SURGERY_RETRACTED)))
			if(I.status & ORGAN_DEAD && I.can_recover())
				user.visible_message(SPAN_NOTICE("\The [user] treats damage to [target]'s [I.name] with [tool_name], though it needs to be recovered further."), \
				SPAN_NOTICE("You treat damage to [target]'s [I.name] with [tool_name], though it needs to be recovered further.") )
			else
				user.visible_message(SPAN_NOTICE("[user] treats damage to [target]'s [I.name] with [tool_name]."), \
				SPAN_NOTICE("You treat damage to [target]'s [I.name] with [tool_name].") )
			I.surgical_fix(user)
	user.visible_message("\The [user] finishes treating damage within \the [target]'s [affected.name] with [tool_name].", \
	"You finish treating damage within \the [target]'s [affected.name] with [tool_name]." )

/singleton/surgery_step/internal/fix_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, getting mess and tearing the inside of [target]'s [affected.name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, getting mess and tearing the inside of [target]'s [affected.name] with \the [tool]!"))
	var/dam_amt = 2
	if(istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
		target.adjustToxLoss(5)
	else
		dam_amt = 5
		target.adjustToxLoss(10)
		affected.take_external_damage(dam_amt, 0, (DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE), used_weapon = tool)
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I && I.damage > 0 && !BP_IS_ROBOTIC(I) && (I.surface_accessible || affected.how_open() >= (affected.encased ? SURGERY_ENCASED : SURGERY_RETRACTED)))
			I.take_internal_damage(dam_amt)

//////////////////////////////////////////////////////////////////
//	 Organ detatchment surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/internal/detatch_organ
	name = "Detach organ"
	allowed_tools = list(
		/obj/item/scalpel = 100,
		/obj/item/material/shard = 50
	)
	min_duration = 9 SECONDS
	max_duration = 11 SECONDS
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT


/singleton/surgery_step/internal/detatch_organ/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
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
		if (organ.parent_organ != target_zone)
			continue
		var/image/radial_button = image(icon = organ.icon, icon_state = organ.icon_state)
		radial_button.name = "Detach \the [organ]"
		attached_organs[organ] = radial_button

	if (!length(attached_organs))
		USE_FEEDBACK_FAILURE("\The [target]'s [affected.name] has nothing to detatch.")
		return FALSE

	var/choice
	if (length(attached_organs) == 1 && user.get_preference_value(/datum/client_preference/surgery_skip_radial))
		choice = attached_organs[1]
	else
		choice = show_radial_menu(user, tool, attached_organs, radius = 42, require_near = TRUE, use_labels = TRUE, check_locs = list(tool))
		if (!choice || !user.use_sanity_check(target, tool))
			return FALSE

	return choice


/singleton/surgery_step/internal/detatch_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/detaching = LAZYACCESS(target.surgeries_in_progress, target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] starts to separate \the [target]'s [detaching.name] with \a [tool]."),
		SPAN_NOTICE("You start to separate \the [target]'s [detaching.name] with \the [tool].")
	)
	target.custom_pain("Someone's ripping out your [detaching.name]!",100)
	playsound(target, 'sound/items/scalpel.ogg', 50, TRUE)
	..()

/singleton/surgery_step/internal/detatch_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/I = LAZYACCESS(target.surgeries_in_progress, target_zone)
	user.visible_message(SPAN_NOTICE("[user] has separated [target]'s [I.name] with \the [tool].") , \
	SPAN_NOTICE("You have separated [target]'s [I.name] with \the [tool]."))
	if(I && istype(I))
		I.cut_away(user)

/singleton/surgery_step/internal/detatch_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!"))
	affected.take_external_damage(rand(30,50), 0, (DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE), used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	 Organ removal surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/internal/remove_organ
	name = "Remove internal organ"
	allowed_tools = list(
		/obj/item/hemostat = 100,
		/obj/item/wirecutters = 75,
		/obj/item/material/knife = 75,
		/obj/item/swapper/jaws_of_life = 50,
		/obj/item/material/utensil/fork = 20
	)
	min_duration = 6 SECONDS
	max_duration = 8 SECONDS


/singleton/surgery_step/internal/remove_organ/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!affected)
		return FALSE

	var/list/removable_organs = list()
	for (var/obj/item/organ/internal/internal_organ in affected.implants)
		if (!HAS_FLAGS(internal_organ.status, ORGAN_CUT_AWAY))
			continue
		var/image/radial_button = image(icon = internal_organ.icon, icon_state = internal_organ.icon_state)
		radial_button.name = "Remove \the [internal_organ.name]"
		removable_organs[internal_organ] = radial_button

	if (!length(removable_organs))
		to_chat(user, SPAN_WARNING("\The [target]'s [affected.name] has nothing to remove."))
		return FALSE

	var/choice
	if (length(removable_organs) == 1 && user.get_preference_value(/datum/client_preference/surgery_skip_radial))
		choice = removable_organs[1]
	else
		choice = show_radial_menu(
			user,
			tool,
			removable_organs,
			radius = 42,
			require_near = TRUE,
			use_labels = TRUE,
			check_locs = list(tool)
		)
		if (!choice || !user.use_sanity_check(target, tool))
			return FALSE

	return choice


/singleton/surgery_step/internal/remove_organ/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool, target_zone)
	var/obj/item/organ/internal/organ_to_remove = LAZYACCESS(target.surgeries_in_progress, target_zone)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!BP_IS_ROBOTIC(organ_to_remove))
		return ..()
	if (BP_IS_ROBOTIC(affected))
		return SURGERY_SKILLS_ROBOTIC
	return SURGERY_SKILLS_ROBOTIC_ON_MEAT


/singleton/surgery_step/internal/remove_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/removing = LAZYACCESS(target.surgeries_in_progress, target_zone)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] starts removing \the [target]'s [removing.name] with \a [tool]."),
		SPAN_NOTICE("You start removing \the [target]'s [removing.name] with \the [tool].")
	)
	target.custom_pain("The pain in your [affected.name] is living hell!", 100, affecting = affected)
	playsound(target, 'sound/items/hemostat.ogg', 50, TRUE)
	..()

/singleton/surgery_step/internal/remove_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/O = LAZYACCESS(target.surgeries_in_progress, target_zone)
	user.visible_message(SPAN_NOTICE("\The [user] has removed \the [target]'s [O.name] with \the [tool]."), \
	SPAN_NOTICE("You have removed \the [target]'s [O.name] with \the [tool]."))

	// Extract the organ!
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(istype(O) && istype(affected))
		affected.implants -= O
		O.dropInto(target.loc)
		if(!BP_IS_ROBOTIC(affected))
			playsound(target.loc, 'sound/effects/squelch1.ogg', 15, 1)
		else
			playsound(target.loc, 'sound/items/Ratchet.ogg', 50, 1)
	if(istype(O, /obj/item/organ/internal/mmi_holder))
		var/obj/item/organ/internal/mmi_holder/brain = O
		brain.transfer_and_delete()

	// Just in case somehow the organ we're extracting from an organic is an MMI
	if(istype(O, /obj/item/organ/internal/mmi_holder))
		var/obj/item/organ/internal/mmi_holder/brain = O
		brain.transfer_and_delete()

/singleton/surgery_step/internal/remove_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging [target]'s [affected.name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, damaging [target]'s [affected.name] with \the [tool]!"))
	affected.take_external_damage(20, used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	 Organ inserting surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/internal/replace_organ
	name = "Replace internal organ"
	allowed_tools = list(
		/obj/item/organ/internal = 100
	)
	min_duration = 6 SECONDS
	max_duration = 8 SECONDS
	var/robotic_surgery = FALSE


/singleton/surgery_step/internal/replace_organ/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool, target_zone)
	var/obj/item/organ/internal/organ_to_attach = tool
	var/obj/item/organ/external/affected = target.get_organ(user.zone_sel.selecting)
	if (!BP_IS_ROBOTIC(organ_to_attach) && !istype(organ_to_attach, /obj/item/organ/internal/augment))
		return ..()
	if (BP_IS_ROBOTIC(affected))
		return SURGERY_SKILLS_ROBOTIC
	return SURGERY_SKILLS_ROBOTIC_ON_MEAT


/singleton/surgery_step/internal/replace_organ/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!affected)
		return FALSE

	var/obj/item/organ/internal/organ_to_install = tool
	if (!istype(organ_to_install) || (HAS_FLAGS(organ_to_install.status, ORGAN_CONFIGURE) && organ_to_install.surgery_configure(user, target, affected, tool, src)))
		return FALSE

	if (BP_IS_CRYSTAL(organ_to_install) && !BP_IS_CRYSTAL(affected))
		USE_FEEDBACK_FAILURE("\The [organ_to_install] is crystalline but \the [target]'s [affected.name] is not. You cannot install it.")
		return FALSE

	if (BP_IS_ROBOTIC(affected) && !BP_IS_ROBOTIC(organ_to_install))
		USE_FEEDBACK_FAILURE("\The [target]'s [affected.name] is robotic but \the [organ_to_install] is not. You cannot install it.")
		return FALSE

	if (organ_to_install.organ_tag == BP_POSIBRAIN && !target.species.has_organ[BP_POSIBRAIN])
		USE_FEEDBACK_FAILURE("\The [target]'s body cannot hold \the [organ_to_install].")
		return FALSE

	var/o_is = (organ_to_install.gender == PLURAL) ? "are" : "is"
	var/o_a = (organ_to_install.gender == PLURAL) ? "" : "a "

	if (organ_to_install.damage > (organ_to_install.max_damage * 0.75))
		USE_FEEDBACK_FAILURE("\The [organ_to_install] [o_is] too damaged to install.")
		return FALSE

	if (organ_to_install.w_class > affected.cavity_max_w_class)
		USE_FEEDBACK_FAILURE("\The [organ_to_install] [o_is] too large for \the [target]'s [affected.cavity_name] cavity.")
		return FALSE

	var/obj/item/organ/internal/existing_organ = target.internal_organs_by_name[organ_to_install.organ_tag]
	if (existing_organ && (existing_organ.parent_organ == affected.organ_tag))
		USE_FEEDBACK_FAILURE("\The [target] already has [o_a][existing_organ.name]. You can't install \the [organ_to_install].")
		return FALSE

	return TRUE


/singleton/surgery_step/internal/replace_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] starts [robotic_surgery ? "installing" : "transplanting"] \a [tool] into \the [target]'s [affected.name]."),
		SPAN_NOTICE("You start [robotic_surgery ? "installing" : "transplanting"] \the [tool] into \the [target]'s [affected.name].")
	)
	target.custom_pain("Someone's rooting around in your [affected.name]!", 100, affecting = affected)
	playsound(target, 'sound/items/scalpel.ogg', 50, TRUE)
	..()

/singleton/surgery_step/internal/replace_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("\The [user] has [robotic_surgery ? "installed" : "transplanted"] \the [tool] into [target]'s [affected.name]."), \
	SPAN_NOTICE("You have [robotic_surgery ? "installed" : "transplanted"] \the [tool] into [target]'s [affected.name]."))
	var/obj/item/organ/O = tool
	if(istype(O) && user.unEquip(O, target))
		affected.implants |= O //move the organ into the patient. The organ is properly reattached in the next step
		if(!(O.status & ORGAN_CUT_AWAY))
			log_debug("[user] ([user.ckey]) replaced organ [O], which didn't have ORGAN_CUT_AWAY set, in [target] ([target.ckey])")
			O.status |= ORGAN_CUT_AWAY

		playsound(target.loc, 'sound/effects/squelch1.ogg', 15, 1)

/singleton/surgery_step/internal/replace_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging \the [tool]!"), \
	SPAN_WARNING("Your hand slips, damaging \the [tool]!"))
	var/obj/item/organ/internal/I = tool
	if(istype(I))
		I.take_internal_damage(rand(3,5))

//////////////////////////////////////////////////////////////////
//	 Organ attachment surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/internal/attach_organ
	name = "Attach internal organ"
	allowed_tools = list(
		/obj/item/FixOVein = 100,
		/obj/item/stack/cable_coil = 75,
		/obj/item/tape_roll = 50
	)
	min_duration = 10 SECONDS
	max_duration = 12 SECONDS
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT


/singleton/surgery_step/internal/attach_organ/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool, target_zone)
	var/obj/item/organ/internal/organ_to_attach = LAZYACCESS(target.surgeries_in_progress, target_zone)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!BP_IS_ROBOTIC(organ_to_attach))
		return ..()
	if (BP_IS_ROBOTIC(affected))
		return SURGERY_SKILLS_ROBOTIC
	return SURGERY_SKILLS_ROBOTIC_ON_MEAT


/singleton/surgery_step/internal/attach_organ/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!affected)
		return FALSE

	var/list/attachable_organs = list()

	for (var/obj/item/organ/organ in affected.implants)
		if (!organ)
			continue
		if (!HAS_FLAGS(organ.status, ORGAN_CUT_AWAY))
			continue
		var/image/radial_button = image(icon = organ.icon, icon_state = organ.icon_state)
		radial_button.name = "Attach \the [organ.name]"
		attachable_organs[organ] = radial_button

	if (!length(attachable_organs))
		return FALSE

	var/obj/item/organ/organ_to_replace
	if (length(attachable_organs) == 1 && user.get_preference_value(/datum/client_preference/surgery_skip_radial))
		organ_to_replace = attachable_organs[1]
	else
		organ_to_replace = show_radial_menu(
			user,
			tool,
			attachable_organs,
			radius = 42,
			require_near = TRUE,
			use_labels = TRUE,
			check_locs = list(tool)
		)

	if (!organ_to_replace || !user.use_sanity_check(target, tool))
		return FALSE

	if (organ_to_replace.parent_organ != affected.organ_tag)
		USE_FEEDBACK_FAILURE("\The [organ_to_replace] can't be attached to \the [target]'s [affected.name].")
		return FALSE

	if (istype(organ_to_replace, /obj/item/organ/internal/augment))
		var/obj/item/organ/internal/augment/augment = organ_to_replace
		if (!HAS_FLAGS(augment.augment_flags, AUGMENT_BIOLOGICAL))
			USE_FEEDBACK_FAILURE("\The [augment] can only function in a robotic limb and cannot be installed in \the [target]'s [affected.name].")
			return FALSE

	if (BP_IS_ROBOTIC(organ_to_replace) && HAS_FLAGS(target.species.spawn_flags, SPECIES_NO_ROBOTIC_INTERNAL_ORGANS))
		USE_FEEDBACK_FAILURE("\The [target]'s body cannot accept robotic organs.")
		return FALSE

	var/obj/item/organ/internal/internal_organ = target.internal_organs_by_name[organ_to_replace.organ_tag]
	if (internal_organ && internal_organ.parent_organ == affected.organ_tag)
		USE_FEEDBACK_FAILURE("\The [target] already has \a [internal_organ] where you would attach \the [organ_to_replace].")
		return FALSE

	return organ_to_replace


/singleton/surgery_step/internal/attach_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/attaching = LAZYACCESS(target.surgeries_in_progress, target_zone)
	user.visible_message(
		"\The [user] begins attaching \the [target]'s [attaching.name] with \a [tool].",
		"You start attaching \the target]'s [attaching.name] with \the [tool]."
	)
	target.custom_pain("Someone's digging needles into your [attaching.name]!", 100)
	playsound(target, 'sound/items/fixovein.ogg', 50, TRUE)
	..()

/singleton/surgery_step/internal/attach_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/I = LAZYACCESS(target.surgeries_in_progress, target_zone)

	user.visible_message(SPAN_NOTICE("[user] has attached [target]'s [I.name] with \the [tool].") , \
	SPAN_NOTICE("You have attached [target]'s [I.name] with \the [tool]."))

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(istype(I) && I.parent_organ == target_zone && affected && (I in affected.implants))
		I.status &= ~ORGAN_CUT_AWAY //apply fixovein
		affected.implants -= I
		I.replaced(target, affected)

	if(istype(I, /obj/item/organ/internal/eyes))
		var/obj/item/organ/internal/eyes/E = I
		if(!E.is_broken())
			I.owner.eye_blind = 0
			target.disabilities &= ~BLINDED
		if(!E.is_bruised())
			I.owner.eye_blurry = 0

/singleton/surgery_step/internal/attach_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging the flesh in [target]'s [affected.name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, damaging the flesh in [target]'s [affected.name] with \the [tool]!"))
	affected.take_external_damage(20, used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	 Peridaxon necrosis treatment surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/internal/treat_necrosis
	name = "Treat necrosis"
	allowed_tools = list(
		/obj/item/reagent_containers/dropper = 100,
		/obj/item/reagent_containers/glass/bottle = 75,
		/obj/item/reagent_containers/glass/beaker = 75,
		/obj/item/reagent_containers/spray = 50,
		/obj/item/reagent_containers/glass/bucket = 50,
	)

	can_infect = FALSE
	blood_level = BLOOD_LEVEL_NONE

	min_duration = 5 SECONDS
	max_duration = 6 SECONDS


/singleton/surgery_step/internal/treat_necrosis/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/reagent_containers/container = tool
	if (!istype(container) || !container.reagents.has_reagent(/datum/reagent/peridaxon) || !..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!affected)
		return FALSE

	var/list/obj/item/organ/internal/dead_organs = list()
	for (var/obj/item/organ/internal/internal_organ in target.internal_organs)
		if (!internal_organ)
			continue
		if (HAS_FLAGS(internal_organ.status, ORGAN_CUT_AWAY))
			continue
		if (!HAS_FLAGS(internal_organ.status, ORGAN_DEAD))
			continue
		if (internal_organ.parent_organ != affected.organ_tag)
			continue
		if (BP_IS_ROBOTIC(internal_organ))
			continue
		var/image/radial_button = image(icon = internal_organ.icon, icon_state = internal_organ.icon_state)
		radial_button.name = "Regenerate \the [internal_organ.name]"
		dead_organs[internal_organ] = radial_button

	if (!length(dead_organs))
		USE_FEEDBACK_FAILURE("There are no decaying organs in \the [target]'s [affected.name].")
		return FALSE

	var/obj/item/organ/internal/organ_to_fix

	if (length(dead_organs) == 1 && user.get_preference_value(/datum/client_preference/surgery_skip_radial))
		organ_to_fix = dead_organs[1]
	else
		organ_to_fix = show_radial_menu(
			user,
			tool,
			dead_organs,
			radius = 42,
			require_near = TRUE,
			use_labels = TRUE,
			check_locs = list(tool)
		)
		if (!organ_to_fix || !user.use_sanity_check(target, tool))
			return FALSE

	if (!organ_to_fix.can_recover())
		USE_FEEDBACK_FAILURE("\The [target]'s [organ_to_fix.name] is necrotic and can't be saved. It will need to be replaced.")
		return FALSE

	if (organ_to_fix.damage >= organ_to_fix.max_damage)
		to_chat(user, SPAN_WARNING("\The [target]'s [organ_to_fix.name] damage needs to be repaired before it is regenerated."))
		return FALSE

	return organ_to_fix


/singleton/surgery_step/internal/treat_necrosis/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		"\The [user] starts applying medication to the affected tissue in \the [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \a [tool].",
		"You start applying medication to the affected tissue in \the [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool]."
	)
	target.custom_pain("Something in your [LAZYACCESS(target.surgeries_in_progress, target_zone)] is causing you a lot of pain!", 50, affecting = LAZYACCESS(target.surgeries_in_progress, target_zone))
	playsound(target, 'sound/items/fixovein.ogg', 50, TRUE)
	..()

/singleton/surgery_step/internal/treat_necrosis/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/internal/affected = LAZYACCESS(target.surgeries_in_progress, target_zone)
	var/obj/item/reagent_containers/container = tool

	var/amount = container.amount_per_transfer_from_this
	var/datum/reagents/temp_reagents = new(amount, GLOB.temp_reagents_holder)
	container.reagents.trans_to_holder(temp_reagents, amount)

	var/rejuvenate = temp_reagents.has_reagent(/datum/reagent/peridaxon)

	var/trans = temp_reagents.trans_to_mob(target, temp_reagents.total_volume, CHEM_BLOOD) //technically it's contact, but the reagents are being applied to internal tissue
	if (trans > 0)

		if(rejuvenate)
			affected.status &= ~ORGAN_DEAD
			affected.owner.update_body(1)

		user.visible_message("[SPAN_NOTICE("[user] applies [trans] unit\s of the solution to affected tissue in [target]'s [affected.name]")].", \
			SPAN_NOTICE("You apply [trans] unit\s of the solution to affected tissue in [target]'s [affected.name] with \the [tool]."))
	qdel(temp_reagents)

/singleton/surgery_step/internal/treat_necrosis/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	if (!istype(tool, /obj/item/reagent_containers))
		return

	var/obj/item/reagent_containers/container = tool

	var/trans = container.reagents.trans_to_mob(target, container.amount_per_transfer_from_this, CHEM_BLOOD)

	user.visible_message(SPAN_WARNING("[user]'s hand slips, applying [trans] units of the solution to the wrong place in [target]'s [affected.name] with the [tool]!") , \
	SPAN_WARNING("Your hand slips, applying [trans] units of the solution to the wrong place in [target]'s [affected.name] with the [tool]!"))

	//no damage or anything, just wastes medicine
