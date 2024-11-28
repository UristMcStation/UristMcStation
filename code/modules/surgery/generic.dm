//Procedures in this file: Gneric surgery steps
//////////////////////////////////////////////////////////////////
//						COMMON STEPS							//
//////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////
//	generic surgery step datum
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/generic
	can_infect = TRUE
	shock_level = 10
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL | SURGERY_NO_STUMP

/singleton/surgery_step/generic/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (target_zone == BP_EYES) //there are specific steps for eye surgery
		return FALSE
	return ..()

//////////////////////////////////////////////////////////////////
//	laser scalpel surgery step
//	acts as both cutting and bleeder clamping surgery steps
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/generic/cut_with_laser
	name = "Make laser incision"
	allowed_tools = list(
		/obj/item/scalpel/laser = 100,
		/obj/item/melee/energy/sword = 5
	)
	min_duration = 9 SECONDS
	max_duration = 11 SECONDS

/singleton/surgery_step/generic/cut_with_laser/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if (!affected)
		return FALSE
	if (affected.how_open())
		var/datum/wound/cut/incision = affected.get_incision()
		USE_FEEDBACK_FAILURE("\The [target]'s [affected.name]'s [incision.desc] provides enough access.")
		return FALSE
	return affected

/singleton/surgery_step/generic/cut_with_laser/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts the bloodless incision on [target]'s [affected.name] with \the [tool].", \
	"You start the bloodless incision on [target]'s [affected.name] with \the [tool].")
	target.custom_pain("You feel a horrible, searing pain in your [affected.name]!",50, affecting = affected)
	playsound(target.loc, 'sound/items/cautery.ogg', 50, TRUE)
	..()

/singleton/surgery_step/generic/cut_with_laser/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] has made a bloodless incision on \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You have made a bloodless incision on \the [target]'s [affected.name] with \the [tool].")
	)
	affected.createwound(INJURY_TYPE_CUT, affected.min_broken_damage / 2, 1)
	affected.clamp_organ()
	spread_germs_to_organ(affected, user)

/singleton/surgery_step/generic/cut_with_laser/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user]'s hand slips as the blade sputters, searing a long gash in \the [target]'s [affected.name] with \the [tool]!"),
		SPAN_WARNING("Your hand slips as the blade sputters, searing a long gash in \the [target]'s [affected.name] with \the [tool]!")
	)
	affected.take_external_damage(15, 5, DAMAGE_FLAG_SHARP | DAMAGE_FLAG_EDGE, tool)

//////////////////////////////////////////////////////////////////
//	laser scalpel surgery step
//	acts as the cutting, bleeder clamping, and retractor surgery steps
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/generic/managed
	name = "Make managed incision"
	allowed_tools = list(
		/obj/item/scalpel/ims = 100
	)
	min_duration = 8 SECONDS
	max_duration = 12 SECONDS

/singleton/surgery_step/generic/managed/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if (!affected)
		return FALSE
	if (affected.how_open())
		var/datum/wound/cut/incision = affected.get_incision()
		USE_FEEDBACK_FAILURE("\The [target]'s [affected.name]'s [incision.desc] provides enough access.")
		return FALSE
	return affected

/singleton/surgery_step/generic/managed/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts to construct a prepared incision on and within [target]'s [affected.name] with \the [tool].", \
	"You start to construct a prepared incision on and within [target]'s [affected.name] with \the [tool].")
	target.custom_pain("You feel a horrible, searing pain in your [affected.name] as it is pushed apart!",50, affecting = affected)
	playsound(target.loc, 'sound/items/circularsaw.ogg', 50, TRUE)
	..()

/singleton/surgery_step/generic/managed/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] has constructed a prepared incision on and within \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You have constructed a prepared incision on and within \the [target]'s [affected.name] with \the [tool].")
	)
	affected.createwound(INJURY_TYPE_CUT, affected.min_broken_damage/2, 1) // incision
	affected.clamp_organ() // clamp
	affected.open_incision() // retract

/singleton/surgery_step/generic/managed/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user]'s hand jolts as the system sparks, ripping a gruesome hole in \the [target]'s [affected.name] with \the [tool]!"), \
		SPAN_WARNING("Your hand jolts as the system sparks, ripping a gruesome hole in \the [target]'s [affected.name] with \the [tool]!")
	)
	affected.take_external_damage(20, 15, DAMAGE_FLAG_SHARP | DAMAGE_FLAG_EDGE, tool)

//////////////////////////////////////////////////////////////////
//	 scalpel surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/generic/cut_open
	name = "Make incision"
	allowed_tools = list(
		/obj/item/scalpel/basic = 100,
		/obj/item/material/knife = 75,
		/obj/item/broken_bottle = 50,
		/obj/item/material/shard = 50
	)
	min_duration = 9 SECONDS
	max_duration = 11 SECONDS
	var/fail_string = "slicing open"
	var/access_string = "an incision"

/singleton/surgery_step/generic/cut_open/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if (!affected)
		return FALSE
	if (affected.how_open())
		var/datum/wound/cut/incision = affected.get_incision()
		USE_FEEDBACK_FAILURE("\The [target]'s [affected.name]'s [incision.desc] provides enough access.")
		return FALSE
	return affected

/singleton/surgery_step/generic/cut_open/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts [access_string] on [target]'s [affected.name] with \the [tool].", \
	"You start [access_string] on [target]'s [affected.name] with \the [tool].")
	target.custom_pain("You feel a horrible pain as if from a sharp knife in your [affected.name]!",40, affecting = affected)
	playsound(target.loc, 'sound/items/scalpel.ogg', 50, TRUE)
	..()

/singleton/surgery_step/generic/cut_open/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] has made [access_string] on \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You have made [access_string] on \the [target]'s [affected.name] with \the [tool].")
	)
	affected.createwound(INJURY_TYPE_CUT, affected.min_broken_damage/2, 1)
	playsound(target, 'sound/weapons/bladeslice.ogg', 15, TRUE)

/singleton/surgery_step/generic/cut_open/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user]'s hand slips, [fail_string] \the [target]'s [affected.name] in the wrong place with \the [tool]!"),
		SPAN_WARNING("Your hand slips, [fail_string] \the [target]'s [affected.name] in the wrong place with \the [tool]!")
	)
	affected.take_external_damage(10, 0, DAMAGE_FLAG_SHARP | DAMAGE_FLAG_EDGE, tool)

/singleton/surgery_step/generic/cut_open/success_chance(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	. = ..()
	if(user.skill_check(SKILL_FORENSICS, SKILL_TRAINED))
		. += 40
		if(target.stat == DEAD)
			. += 40

//////////////////////////////////////////////////////////////////
//	 bleeder clamping surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/generic/clamp_bleeders
	name = "Clamp bleeders"
	allowed_tools = list(
		/obj/item/hemostat = 100,
		/obj/item/stack/cable_coil = 75,
		/obj/item/device/assembly/mousetrap = 20
	)
	min_duration = 4 SECONDS
	max_duration = 6 SECONDS
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL | SURGERY_NO_STUMP | SURGERY_NEEDS_INCISION
	strict_access_requirement = FALSE

/singleton/surgery_step/generic/clamp_bleeders/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if (!affected || affected.clamped())
		return FALSE
	return affected

/singleton/surgery_step/generic/clamp_bleeders/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts clamping bleeders in [target]'s [affected.name] with \the [tool].", \
	"You start clamping bleeders in [target]'s [affected.name] with \the [tool].")
	target.custom_pain("The pain in your [affected.name] is maddening!",40, affecting = affected)
	playsound(target.loc, 'sound/items/hemostat.ogg', 50, TRUE)
	..()

/singleton/surgery_step/generic/clamp_bleeders/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] clamps bleeders in \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You clamp bleeders in \the [target]'s [affected.name] with \the [tool].")
	)
	affected.clamp_organ()
	spread_germs_to_organ(affected, user)
	playsound(target, 'sound/items/Welder.ogg', 15, TRUE)

/singleton/surgery_step/generic/clamp_bleeders/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user]'s hand slips, tearing blood vessals and causing massive bleeding in \the [target]'s [affected.name] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, tearing blood vessels and causing massive bleeding in \the [target]'s [affected.name] with \the [tool]!")
	)
	affected.take_external_damage(10, 0, DAMAGE_FLAG_SHARP | DAMAGE_FLAG_EDGE, tool)

//////////////////////////////////////////////////////////////////
//	 retractor surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/generic/retract_skin
	name = "Widen incision"
	allowed_tools = list(
		/obj/item/retractor = 100,
		/obj/item/swapper/jaws_of_life = 80,
		/obj/item/crowbar = 75,
		/obj/item/material/knife = 50,
		/obj/item/material/utensil/fork = 50
	)
	min_duration = 3 SECONDS
	max_duration = 4 SECONDS
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL | SURGERY_NO_STUMP | SURGERY_NEEDS_INCISION


/singleton/surgery_step/generic/retract_skin/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!affected)
		return FALSE

	if (affected.how_open() >= SURGERY_RETRACTED)
		var/datum/wound/cut/incision = affected.get_incision()
		USE_FEEDBACK_FAILURE("The [incision.desc] provides enough access, a larger incision isn't needed.")
		return FALSE

	return TRUE


/singleton/surgery_step/generic/retract_skin/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] starts to pry open the incision on \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You start to pry open the incision on \the [target]'s [affected.name] with \the [tool].")
	)
	target.custom_pain("It feels like the skin on your [affected.name] is on fire!", 40, affecting = affected)
	playsound(target, 'sound/items/retractor.ogg', 50, TRUE)
	..()

/singleton/surgery_step/generic/retract_skin/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] keeps the incision open on \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You keep the incision open on \the [target]'s [affected.name] with \the [tool].")
	)
	affected.open_incision()

/singleton/surgery_step/generic/retract_skin/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user]'s hand slips, tearing the edges of the incision on \the [target]'s [affected.name] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, tearing the edges of the incision on \the [target]'s [affected.name] with \the [tool]!")
	)
	affected.take_external_damage(12, 0, DAMAGE_FLAG_SHARP | DAMAGE_FLAG_EDGE, tool)

//////////////////////////////////////////////////////////////////
//	 skin cauterization surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/generic/cauterize
	name = "Cauterize incision"
	allowed_tools = list(
		/obj/item/cautery = 100,
		/obj/item/clothing/mask/smokable/cigarette = 75,
		/obj/item/flame/lighter = 50,
		/obj/item/weldingtool = 25
	)
	min_duration = 7 SECONDS
	max_duration = 10 SECONDS
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL
	var/cauterize_term = "cauterize"
	var/post_cauterize_term = "cauterized"


/singleton/surgery_step/generic/cauterize/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!affected)
		return FALSE

	if (affected.is_stump())
		if (!HAS_FLAGS(affected.status, ORGAN_ARTERY_CUT))
			USE_FEEDBACK_FAILURE("There is no bleeding to repair within this stump.")
			return FALSE
		return TRUE

	if (!affected.get_incision(1))
		USE_FEEDBACK_FAILURE("There are no incisions on \the [target]'s [affected.name] that can be closed cleanly with \the [tool].")
		return FALSE

	return TRUE


/singleton/surgery_step/generic/cauterize/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if (!affected)
		return FALSE

	if (affected.is_stump())
		if (!HAS_FLAGS(affected.status, ORGAN_ARTERY_CUT))
			return FALSE
		return affected

	if (affected.how_open())
		return affected

	return FALSE

/singleton/surgery_step/generic/cauterize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/datum/wound/W = affected.get_incision()
	user.visible_message(
		SPAN_NOTICE("\The [user] starts to [cauterize_term][W ? " \a [W.desc] on" : ""] \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You start to [cauterize_term][W ? " \a [W.desc] on" : ""] \the [target]'s [affected.name] with \the [tool].")
	)
	target.custom_pain("Your [affected.name] is being burned!", 40, affecting = affected)
	playsound(target, 'sound/items/cautery.ogg', 50, TRUE)
	..()

/singleton/surgery_step/generic/cauterize/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/datum/wound/wound = affected.get_incision()
	user.visible_message(
		SPAN_NOTICE("\The [user] [post_cauterize_term][wound ? " \a [wound.desc] on" : ""] \the [target]'s [affected.name] with \a [tool]."),
		SPAN_NOTICE("You [cauterize_term][wound ? " \a [wound.desc] on" : ""] \the [target]'s [affected.name] with \the [tool].")
	)
	if (istype(wound))
		wound.close()
		affected.update_wounds()
	if (affected.is_stump())
		CLEAR_FLAGS(affected.status, ORGAN_ARTERY_CUT)
	if (affected.clamped())
		affected.remove_clamps()

/singleton/surgery_step/generic/cauterize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user]'s hand slips, damaging \the [target]'s [affected.name] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, damaging \the [target]'s [affected.name] with \the [tool]!")
	)
	affected.take_external_damage(0, 3, used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	 limb amputation surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/generic/amputate
	name = "Amputate limb"
	allowed_tools = list(
		/obj/item/circular_saw = 100,
		/obj/item/material/hatchet = 75
	)
	min_duration = 11 SECONDS
	max_duration = 16 SECONDS
	surgery_candidate_flags = EMPTY_BITFIELD

/singleton/surgery_step/generic/amputate/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if (!affected)
		return FALSE
	if (!HAS_FLAGS(affected.limb_flags, ORGAN_FLAG_CAN_AMPUTATE) || affected.how_open())
		return FALSE
	return affected

/singleton/surgery_step/generic/amputate/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool, target_zone)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (BP_IS_ROBOTIC(affected))
		return SURGERY_SKILLS_ROBOTIC
	return ..()


/singleton/surgery_step/generic/amputate/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_DANGER("\The [user] starts to amputate \the [target]'s [affected.name] with \a [tool]."),
		SPAN_DANGER(FONT_LARGE("You start to cut through \the [target]'s [affected.amputation_point] with \the [tool]."))
	)
	target.custom_pain("Your [affected.amputation_point] is being ripped apart!", 100, affecting = affected)
	playsound(target, 'sound/items/amputation.ogg', 50, TRUE)
	..()

/singleton/surgery_step/generic/amputate/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] amputates \the [target]'s [affected.name] at the [affected.amputation_point] with \a [tool]."),
		SPAN_NOTICE("You amputate \the [target]'s [affected.name] with \the [tool].")
	)
	affected.droplimb(1, DROPLIMB_EDGE)

/singleton/surgery_step/generic/amputate/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user]'s hand slips, sawing through the bone in \the [target]'s [affected.name] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, sawwing through the bone in \the [target]'s [affected.name] with \the [tool]!")
	)
	affected.take_external_damage(30, 0, DAMAGE_FLAG_SHARP | DAMAGE_FLAG_EDGE, tool)
	affected.fracture()
