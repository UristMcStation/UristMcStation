//Procedures in this file: Gneric surgery steps
//////////////////////////////////////////////////////////////////
//						COMMON STEPS							//
//////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////
//	generic surgery step datum
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/generic
	can_infect = 1
	shock_level = 10
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL | SURGERY_NO_STUMP

/singleton/surgery_step/generic/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(target_zone != BP_EYES) //there are specific steps for eye surgery
		. = ..()

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
	min_duration = 90
	max_duration = 110

/singleton/surgery_step/generic/cut_with_laser/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = ..()
	if(.)
		var/obj/item/organ/external/affected = .
		if(affected.how_open())
			var/datum/wound/cut/incision = affected.get_incision()
			to_chat(user, SPAN_NOTICE("The [incision.desc] provides enough access."))
			return FALSE

/singleton/surgery_step/generic/cut_with_laser/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts the bloodless incision on [target]'s [affected.name] with \the [tool].", \
	"You start the bloodless incision on [target]'s [affected.name] with \the [tool].")
	target.custom_pain("You feel a horrible, searing pain in your [affected.name]!",50, affecting = affected)
	playsound(target.loc, 'sound/items/cautery.ogg', 50, TRUE)
	..()

/singleton/surgery_step/generic/cut_with_laser/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] has made a bloodless incision on [target]'s [affected.name] with \the [tool]."), \
	SPAN_NOTICE("You have made a bloodless incision on [target]'s [affected.name] with \the [tool]."),)
	affected.createwound(INJURY_TYPE_CUT, affected.min_broken_damage/2, 1)
	affected.clamp_organ()
	spread_germs_to_organ(affected, user)

/singleton/surgery_step/generic/cut_with_laser/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips as the blade sputters, searing a long gash in [target]'s [affected.name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips as the blade sputters, searing a long gash in [target]'s [affected.name] with \the [tool]!"))
	affected.take_external_damage(15, 5, (DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE), used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	laser scalpel surgery step
//	acts as the cutting, bleeder clamping, and retractor surgery steps
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/generic/managed
	name = "Make managed incision"
	allowed_tools = list(
		/obj/item/scalpel/ims = 100
	)
	min_duration = 80
	max_duration = 120

/singleton/surgery_step/generic/managed/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = ..()
	if(.)
		var/obj/item/organ/external/affected = .
		if(affected.how_open())
			var/datum/wound/cut/incision = affected.get_incision()
			to_chat(user, SPAN_NOTICE("The [incision.desc] provides enough access."))
			return FALSE

/singleton/surgery_step/generic/managed/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts to construct a prepared incision on and within [target]'s [affected.name] with \the [tool].", \
	"You start to construct a prepared incision on and within [target]'s [affected.name] with \the [tool].")
	target.custom_pain("You feel a horrible, searing pain in your [affected.name] as it is pushed apart!",50, affecting = affected)
	playsound(target.loc, 'sound/items/circularsaw.ogg', 50, TRUE)
	..()

/singleton/surgery_step/generic/managed/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] has constructed a prepared incision on and within [target]'s [affected.name] with \the [tool]."), \
	SPAN_NOTICE("You have constructed a prepared incision on and within [target]'s [affected.name] with \the [tool]."),)
	var/datum/wound/W = affected.createwound(INJURY_TYPE_CUT, affected.min_broken_damage/2, 1) // incision
	affected.clamp_organ() // clamp
	affected.open_incision() // retract
	W.desc = "clean surgical incision"

/singleton/surgery_step/generic/managed/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand jolts as the system sparks, ripping a gruesome hole in [target]'s [affected.name] with \the [tool]!"), \
	SPAN_WARNING("Your hand jolts as the system sparks, ripping a gruesome hole in [target]'s [affected.name] with \the [tool]!"))
	affected.take_external_damage(20, 15, (DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE), used_weapon = tool)

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
	min_duration = 90
	max_duration = 110
	var/fail_string = "slicing open"
	var/access_string = "an incision"

/singleton/surgery_step/generic/cut_open/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = ..()
	if(.)
		var/obj/item/organ/external/affected = .
		if(affected.how_open())
			var/datum/wound/cut/incision = affected.get_incision()
			to_chat(user, SPAN_NOTICE("The [incision.desc] provides enough access."))
			return FALSE

/singleton/surgery_step/generic/cut_open/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts [access_string] on [target]'s [affected.name] with \the [tool].", \
	"You start [access_string] on [target]'s [affected.name] with \the [tool].")
	target.custom_pain("You feel a horrible pain as if from a sharp knife in your [affected.name]!",40, affecting = affected)
	playsound(target.loc, 'sound/items/scalpel.ogg', 50, TRUE)
	..()

/singleton/surgery_step/generic/cut_open/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] has made [access_string] on [target]'s [affected.name] with \the [tool]."), \
	SPAN_NOTICE("You have made [access_string] on [target]'s [affected.name] with \the [tool]."),)
	affected.createwound(INJURY_TYPE_CUT, affected.min_broken_damage/2, 1)
	playsound(target.loc, 'sound/weapons/bladeslice.ogg', 15, 1)

/singleton/surgery_step/generic/cut_open/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, [fail_string] \the [target]'s [affected.name] in the wrong place with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, [fail_string] \the [target]'s [affected.name] in the wrong place with \the [tool]!"))
	affected.take_external_damage(10, 0, (DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE), used_weapon = tool)

/singleton/surgery_step/generic/cut_open/success_chance(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	. = ..()
	. += 40
	if(target.stat == DEAD)
		. += 40

//////////////////////////////////////////////////////////////////
//	 bleeder clamping surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/generic/clamp_bleeders
	name = "clamp bleeders"
	allowed_tools = list(
		/obj/item/hemostat = 100,
		/obj/item/stack/cable_coil = 75,
		/obj/item/device/assembly/mousetrap = 20
	)
	min_duration = 40
	max_duration = 60
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL | SURGERY_NO_STUMP | SURGERY_NEEDS_INCISION
	strict_access_requirement = FALSE

/singleton/surgery_step/generic/clamp_bleeders/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && !affected.clamped())
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
	user.visible_message(SPAN_NOTICE("[user] clamps bleeders in [target]'s [affected.name] with \the [tool]."),	\
	SPAN_NOTICE("You clamp bleeders in [target]'s [affected.name] with \the [tool]."))
	affected.clamp_organ()
	spread_germs_to_organ(affected, user)
	playsound(target.loc, 'sound/items/Welder.ogg', 15, 1)

/singleton/surgery_step/generic/clamp_bleeders/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, tearing blood vessals and causing massive bleeding in [target]'s [affected.name] with \the [tool]!"),	\
	SPAN_WARNING("Your hand slips, tearing blood vessels and causing massive bleeding in [target]'s [affected.name] with \the [tool]!"),)
	affected.take_external_damage(10, 0, (DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE), used_weapon = tool)

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
	min_duration = 30
	max_duration = 40
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL | SURGERY_NO_STUMP | SURGERY_NEEDS_INCISION
	strict_access_requirement = TRUE

/singleton/surgery_step/generic/retract_skin/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected)
		if(affected.how_open() >= SURGERY_RETRACTED)
			var/datum/wound/cut/incision = affected.get_incision()
			to_chat(user, SPAN_NOTICE("The [incision.desc] provides enough access, a larger incision isn't needed."))
		else
			. = TRUE

/singleton/surgery_step/generic/retract_skin/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts to pry open the incision on [target]'s [affected.name] with \the [tool].",	\
	"You start to pry open the incision on [target]'s [affected.name] with \the [tool].")
	target.custom_pain("It feels like the skin on your [affected.name] is on fire!",40,affecting = affected)
	playsound(target.loc, 'sound/items/retractor.ogg', 50, TRUE)
	..()

/singleton/surgery_step/generic/retract_skin/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] keeps the incision open on [target]'s [affected.name] with \the [tool]."),	\
	SPAN_NOTICE("You keep the incision open on [target]'s [affected.name] with \the [tool]."))
	affected.open_incision()

/singleton/surgery_step/generic/retract_skin/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!"),	\
	SPAN_WARNING("Your hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!"))
	affected.take_external_damage(12, 0, (DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE), used_weapon = tool)

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
	min_duration = 70
	max_duration = 100
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL
	var/cauterize_term = "cauterize"
	var/post_cauterize_term = "cauterized"

/singleton/surgery_step/generic/cauterize/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected)
		if(affected.is_stump())
			if(affected.status & ORGAN_ARTERY_CUT)
				. = TRUE
			else
				to_chat(user, SPAN_WARNING("There is no bleeding to repair within this stump."))
		else if(!affected.get_incision(1))
			to_chat(user, SPAN_WARNING("There are no incisions on [target]'s [affected.name] that can be closed cleanly with \the [tool]!"))
		else
			. = TRUE

/singleton/surgery_step/generic/cauterize/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected)
		if(affected.is_stump())
			if(affected.status & ORGAN_ARTERY_CUT)
				return affected
		else if(affected.how_open())
			return affected

/singleton/surgery_step/generic/cauterize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/datum/wound/W = affected.get_incision()
	user.visible_message("[user] is beginning to [cauterize_term][W ? " \a [W.desc] on" : ""] \the [target]'s [affected.name] with \the [tool]." , \
	"You are beginning to [cauterize_term][W ? " \a [W.desc] on" : ""] \the [target]'s [affected.name] with \the [tool].")
	target.custom_pain("Your [affected.name] is being burned!",40,affecting = affected)
	playsound(target.loc, 'sound/items/cautery.ogg', 50, TRUE)
	..()

/singleton/surgery_step/generic/cauterize/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/datum/wound/W = affected.get_incision()
	user.visible_message(SPAN_NOTICE("[user] [post_cauterize_term][W ? " \a [W.desc] on" : ""] \the [target]'s [affected.name] with \the [tool]."), \
	SPAN_NOTICE("You [cauterize_term][W ? " \a [W.desc] on" : ""] \the [target]'s [affected.name] with \the [tool]."))
	if(istype(W))
		W.close()
		affected.update_wounds()
	if(affected.is_stump())
		affected.status &= ~ORGAN_ARTERY_CUT
	if(affected.clamped())
		affected.remove_clamps()

/singleton/surgery_step/generic/cauterize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging [target]'s [affected.name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, damaging [target]'s [affected.name] with \the [tool]!"))
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
	min_duration = 110
	max_duration = 160
	surgery_candidate_flags = 0

/singleton/surgery_step/generic/amputate/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && (affected.limb_flags & ORGAN_FLAG_CAN_AMPUTATE) && !affected.how_open())
		return affected

/singleton/surgery_step/generic/amputate/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] is beginning to amputate [target]'s [affected.name] with \the [tool]." , \
	FONT_LARGE("You are beginning to cut through [target]'s [affected.amputation_point] with \the [tool]."))
	target.custom_pain("Your [affected.amputation_point] is being ripped apart!",100,affecting = affected)
	playsound(target.loc, 'sound/items/amputation.ogg', 50, TRUE)
	..()

/singleton/surgery_step/generic/amputate/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] amputates [target]'s [affected.name] at the [affected.amputation_point] with \the [tool]."), \
	SPAN_NOTICE("You amputate [target]'s [affected.name] with \the [tool]."))
	affected.droplimb(1,DROPLIMB_EDGE)

/singleton/surgery_step/generic/amputate/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, sawing through the bone in [target]'s [affected.name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, sawwing through the bone in [target]'s [affected.name] with \the [tool]!"))
	affected.take_external_damage(30, 0, (DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE), used_weapon = tool)
	affected.fracture()
