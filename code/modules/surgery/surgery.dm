/// A list of types that will not attempt to perform surgery if the user is on help intent.
GLOBAL_LIST_INIT(surgery_tool_exceptions, list(
	/obj/item/auto_cpr,
	/obj/item/device/scanner/health,
	/obj/item/shockpaddles,
	/obj/item/reagent_containers/hypospray,
	/obj/item/modular_computer,
	/obj/item/reagent_containers/syringe,
	/obj/item/reagent_containers/borghypo
))


/// A cache of types that have already been checked against `GLOB.surgery_tool_exceptions`.
GLOBAL_LIST_INIT(surgery_tool_exception_cache, new)


/singleton/surgery_step
	/// String. Name of the surgery step, i.e. `"Make incision"`. Used in feedback messages and surgery selection dialogues.
	var/name
	/// List (Subpaths of `/obj/item` => integer). Map of type paths to percentages (`0` - `100`) indicating what tools can perform this surgery and their efficiency at it.
	var/list/allowed_tools = list()
	/// LAZYLIST (String - Any of `SPECIES_*`). List of type paths referencing races that this step applies to. Overrides `disallowed_species`.
	var/list/allowed_species
	/// LAZYLIST (String - Any of `SPECIES_*`). List of type paths referencing races that this step does not apply to. Overridden by `allowed_species`.
	var/list/disallowed_species
	/// Integer. Minimum duration of the step in ticks. Used for randomizing `do_after()` times.
	var/min_duration = 0
	/// Integer. Maximum duration of the step in ticks. Used for randomizing `do_after()` times.
	var/max_duration = 0
	/// Boolean. Whether or not this step can cause infection.
	var/can_infect = FALSE
	/// Integer (One of `src.BLOOD_LEVEL_*`). How much blood this step can get on the surgeon.
	var/blood_level = BLOOD_LEVEL_NONE
	/// Integer. The shock level this surgery will put the patient into.
	var/shock_level = 0
	/// Boolean. If this step NEEDS a stable operation table or can be done on any valid surface with no penalty.
	var/delicate = FALSE
	/// Bitflags (Any of `SURGERY_*`). Various surgery requirements. See `code\modules\surgery\__surgery_setup.dm` for valid options.
	var/surgery_candidate_flags = EMPTY_BITFIELD
	/// Boolean. Whether or not this surgery is strict or fuzzy on size requirements.
	var/strict_access_requirement = TRUE

	/// The surgery step does not cover the surgeon in blood.
	var/const/BLOOD_LEVEL_NONE = 0
	/// The surgery step only covers the surgeon's hands in blood.
	var/const/BLOOD_LEVEL_HANDS = 1
	/// The surgery step covers the surgeon's entire body in blood.
	var/const/BLOOD_LEVEL_FULLBODY = 2


/**
 * Determines whether a tool is suited for this surgery and how efficient it is. References the `allowed_tools` map.
 *
 * **Parameters**
 * - `tool` - The tool to check.
 *
 * Returns a percentage as an integer from `0` to `100`. A value of `0` indicates the tool cannot be used for this surgery.
 */
/singleton/surgery_step/proc/tool_quality(obj/item/tool)
	for (var/allowed_type in allowed_tools)
		if (istype(tool, allowed_type))
			return allowed_tools[allowed_type]
	return 0


/**
 * Actions and checks to be performed before starting the actual surgery.
 *
 * **Parameters**:
 * - `user` - The mob performing the operation.
 * - `target` - The mob the operation is being performed on.
 * - `target_zone` (string) - The targeted body doll zone the operation is being performed on. Valid for
 *       `mob/get_organ(target_zone)`.
 * - `tool` - The item being used to perform the operation.
 *
 * Returns boolean or an instance of a selected organ for certain subtypes. If `FALSE`, the surgery cannot be performed
 *     and the process is halted. A user feedback message may be sent when returning `FALSE`, though bear in mind this
 *     proc may run for multiple surgery steps if those steps consider the used tool valid.
 */
/singleton/surgery_step/proc/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return TRUE


/**
 * Determines whether the target mob is a valid target for this surgery step.
 *
 * **Parameters**:
 * - `target` - The mob being targeted for the operation.
 *
 * Returns boolean.
 */
/singleton/surgery_step/proc/is_valid_target(mob/living/carbon/human/target)
	if (!ishuman(target))
		return FALSE

	if (allowed_species)
		for (var/species in allowed_species)
			if (target.species.get_bodytype(target) == species)
				return TRUE

	if (disallowed_species)
		for (var/species in disallowed_species)
			if (target.species.get_bodytype(target) == species)
				return FALSE

	return TRUE


/**
 * Determines the skill requirements to perform the surgery without potential failures.
 *
 * **Parameters**:
 * - `user` - The mob performing the operation.
 * - `target` - The mob the operation is being performed on.
 * - `tool` - The item being used to perform the operation.
 * - `target_zone` (string) - The targeted body doll zone the operation is being performed on. Valid for
 *       `mob/get_organ(target_zone)`.
 *
 * Returns a list (Map of `SKILL_{CATEGORY} = SKILL_{LEVEL}`). Can also be one of the `SURGERY_SKILLS_*` presets defined
 *     in `code\modules\surgery\__surgery_setup.dm`.
 */
/singleton/surgery_step/proc/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool, target_zone)
	if (delicate)
		return SURGERY_SKILLS_DELICATE
	return SURGERY_SKILLS_GENERIC


/**
 * Whether this step can be applied with the given user and target.
 *
 * By default, checks both `assess_bodypart()` and `assess_surgery_candidate()`.
 *
 * **Parameters**:
 * - `user` - The mob performing the operation.
 * - `target` - The mob being operated on.
 * - `target_zone` - The user's selected target zone.
 * - `tool` - The item being used to perform the operation.
 *
 * Returns boolean.
 */
/singleton/surgery_step/proc/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return assess_bodypart(user, target, target_zone, tool) && assess_surgery_candidate(user, target, target_zone, tool)

/**
 * Checks if a given bodypart in `target_zone` is valid for this surgery.
 *
 * **Parameters**:
 * - `user` - The mob performing the surgery.
 * - `target` - The mob being operated on.
 * - `target_zone` - The zone being targeted and checked.
 * - `tool` - The item being used to perform the surgery.
 *
 * Returns the targeted organ if valid, or `FALSE` is invalid.
 */
/singleton/surgery_step/proc/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!istype(target) || !target_zone)
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!affected)
		return FALSE

	// Check various conditional flags.
	if ((HAS_FLAGS(surgery_candidate_flags, SURGERY_NO_ROBOTIC) && BP_IS_ROBOTIC(affected)) || \
		(HAS_FLAGS(surgery_candidate_flags, SURGERY_NO_CRYSTAL) && BP_IS_CRYSTAL(affected)) || \
		(HAS_FLAGS(surgery_candidate_flags, SURGERY_NO_STUMP) && affected.is_stump())       || \
		(HAS_FLAGS(surgery_candidate_flags, SURGERY_NO_FLESH) && !(BP_IS_ROBOTIC(affected) || BP_IS_CRYSTAL(affected))))
		return FALSE

	// Check if the surgery target is accessible.
	if (BP_IS_ROBOTIC(affected))
		if ((HAS_FLAGS(surgery_candidate_flags, SURGERY_NEEDS_ENCASEMENT) || \
			HAS_FLAGS(surgery_candidate_flags, SURGERY_NEEDS_INCISION)      || \
			HAS_FLAGS(surgery_candidate_flags, SURGERY_NEEDS_RETRACTED))    && \
			affected.hatch_state != HATCH_OPENED)
			return FALSE
	else
		var/open_threshold = SURGERY_CLOSED
		if (HAS_FLAGS(surgery_candidate_flags, SURGERY_NEEDS_INCISION))
			open_threshold = SURGERY_OPEN
		else if (HAS_FLAGS(surgery_candidate_flags, SURGERY_NEEDS_RETRACTED))
			open_threshold = SURGERY_RETRACTED
		else if (HAS_FLAGS(surgery_candidate_flags, SURGERY_NEEDS_ENCASEMENT))
			open_threshold = (affected.encased ? SURGERY_ENCASED : SURGERY_RETRACTED)
		if (open_threshold && ((strict_access_requirement && affected.how_open() != open_threshold) || \
			affected.how_open() < open_threshold))
			return FALSE

	// Check if clothing is blocking access
	var/obj/item/clothing = target.get_covering_equipped_item_by_zone(target_zone)
	if (clothing && HAS_FLAGS(clothing.item_flags, ITEM_FLAG_THICKMATERIAL))
		USE_FEEDBACK_FAILURE("The material covering \the [target]'s [affected.name] is too thick for you to do surgery through.")
		return FALSE

	return affected

/**
 * Determines whether or not `target` is valid for this surgery.
 *
 * **Parameters**:
 * - `user` - The mob performing the surgery.
 * - `target` - The mob being operated on.
 * - `target_zone` - `user`'s target body zone.
 * - `tool` - The item being used to perform the surgery.
 *
 * Returns boolean.
 */
/singleton/surgery_step/proc/assess_surgery_candidate(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ishuman(target)


/**
 * Does stuff to begin the step, usually just printing messages. Moved germs transfering and bloodying here too.
 *
 * This is generally things that occur before the `do_after()` timer.
 *
 * **Parameters**:
 * - `user` - The mob performing the surgery.
 * - `target` - The mob being operated on.
 * - `target_zone` - `user`'s targeted body zone.
 * - `tool` - The item being used to perform the surgery.
 *
 * Has no return value.
 */
/singleton/surgery_step/proc/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	if (can_infect && affected)
		spread_germs_to_organ(affected, user)

	if (ishuman(user) && prob(60))
		var/mob/living/carbon/human/H = user
		if (blood_level >= BLOOD_LEVEL_HANDS)
			H.bloody_hands(target,0)
		if (blood_level >= BLOOD_LEVEL_FULLBODY)
			H.bloody_body(target,0)

	if (shock_level)
		target.shock_stage = max(target.shock_stage, shock_level)

	if (target.stat == UNCONSCIOUS && prob(20))
		to_chat(target, SPAN_NOTICE(SPAN_BOLD("... [pick("bright light", "faraway pain", "something moving in you", "soft beeping")] ...")))


/**
 * Does stuff to end the step, usually just printing messages and logic for whatever the step changes.
 *
 * This is generally things that occur before the `do_after()` timer.
 *
 * **Parameters**:
 * - `user` - The mob performing the surgery.
 * - `target` - The mob being operated on.
 * - `target_zone` - `user`'s targeted body zone.
 * - `tool` - The item being used to perform the surgery.
 *
 * Has no return value.
 */
/singleton/surgery_step/proc/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return


/**
 * Does stuff if the surgery step fails.
 *
 * **Parameters**:
 * - `user` - The mob performing the surgery.
 * - `target` - The ~~victim~~mob being operated on.
 * - `target_zone` - `user`'s targeted body zone when the surgery started.
 * - `tool` - The item being used to perform the surgery.
 *
 * Has no return value.
 */
/singleton/surgery_step/proc/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return null


/**
 * Determines the change the surgery can succeed as a percentile value from `0` to `100`.
 *
 * **Parameters**:
 * - `user` - The mob attempting the surgery.
 * - `target` - The mob being operated on.
 * - `tool` - The item being used to perform the surgery.
 * - `target_zone` - `user`'s targeted body zone when the surgery started.
 *
 * Returns integer value from `0` to `100`. Final value is based on `tool_quality(tool)` alongside several other generalized and surgery specific checks.
 */
/singleton/surgery_step/proc/success_chance(mob/living/user, mob/living/carbon/human/target, obj/item/tool, target_zone)
	. = tool_quality(tool)
	if(user == target)
		. -= 10

	var/list/skill_reqs = get_skill_reqs(user, target, tool, target_zone)
	for(var/skill in skill_reqs)
		var/penalty = delicate ? 40 : 20
		. -= max(0, penalty * (skill_reqs[skill] - user.get_skill_value(skill)))
		if(user.skill_check(skill, SKILL_MASTER))
			. += 20

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		. -= round(H.shock_stage * 0.5)
		if(H.eye_blurry)
			. -= 20
		if(H.eye_blind)
			. -= 60

	if(delicate)
		if(user.slurring)
			. -= 10
		if(!target.lying)
			. -= 30
		var/turf/T = get_turf(target)
		if(locate(/obj/machinery/optable, T))
			. -= 0
		else if(locate(/obj/structure/bed, T))
			. -= 5
		else if(locate(/obj/structure/roller_bed, T))
			. -= 5
		else if(locate(/obj/structure/table, T))
			. -= 10
		else if(locate(/obj/rune, T))
			. -= 10
	. = max(., 0)

/proc/spread_germs_to_organ(obj/item/organ/external/E, mob/living/carbon/human/user)
	if(!istype(user) || !istype(E)) return

	var/germ_level = user.germ_level
	if(user.gloves)
		germ_level = user.gloves.germ_level

	E.germ_level = max(germ_level,E.germ_level) //as funny as scrubbing microbes out with clean gloves is - no.

/obj/item/proc/do_surgery(mob/living/carbon/M, mob/living/user, fuckup_prob)

	// Check for the Hippocratic oath.
	if(!istype(M) || user.a_intent == I_HURT)
		return FALSE

	// Check for multi-surgery drifting.
	var/zone = user.zone_sel.selecting
	if(LAZYACCESS(M.surgeries_in_progress, zone))
		to_chat(user, SPAN_WARNING("You can't operate on this area while surgery is already in progress."))
		return TRUE

	// What surgeries does our tool/target enable?
	var/list/possible_surgeries
	var/list/all_surgeries = GET_SINGLETON_SUBTYPE_MAP(/singleton/surgery_step)
	for(var/singleton in all_surgeries)
		var/singleton/surgery_step/S = all_surgeries[singleton]
		if(S.name && S.tool_quality(src) && S.can_use(user, M, zone, src))
			var/image/radial_button = image(icon = icon, icon_state = icon_state)
			radial_button.name = S.name
			LAZYSET(possible_surgeries, S, radial_button)

	// Which surgery, if any, do we actually want to do?
	var/singleton/surgery_step/S
	if (user.client && length(possible_surgeries))
		if (length(possible_surgeries) == 1 && user.get_preference_value(/datum/client_preference/surgery_skip_radial))
			S = possible_surgeries[1]
		else
			S = show_radial_menu(user, M, possible_surgeries, radius = 42, use_labels = TRUE, require_near = TRUE, check_locs = list(src))
		if (!user.use_sanity_check(M))
			S = null
		if (S && !user.skill_check_multiple(S.get_skill_reqs(user, M, src, zone)))
			S = pick(possible_surgeries)

	var/obj/item/gripper/gripper = user.get_active_hand()
	// We didn't find a surgery, or decided not to perform one.
	if(!istype(S))
		// If we're on an optable, we are protected from some surgery fails. Bypass this for some items (like health analyzers).
		if((locate(/obj/machinery/optable) in get_turf(M)) && user.a_intent == I_HELP)
			// Keep track of which tools we know aren't appropriate for surgery on help intent.
			if(GLOB.surgery_tool_exception_cache[type])
				return FALSE
			for(var/tool in GLOB.surgery_tool_exceptions)
				if(istype(src, tool))
					GLOB.surgery_tool_exception_cache[type] = TRUE
					return FALSE
			to_chat(user, SPAN_WARNING("You aren't sure what you could do to \the [M] with \the [src]."))
			return TRUE

	// Otherwise we can make a start on surgery!
	else if(istype(M) && !QDELETED(M) && user.a_intent != I_HURT && (user.get_active_hand() == src || (istype(gripper) && gripper.wrapped == src)))
		// Double-check this in case it changed between initial check and now.
		if(zone in M.surgeries_in_progress)
			to_chat(user, SPAN_WARNING("You can't operate on this area while surgery is already in progress."))
		else if(S.can_use(user, M, zone, src) && S.is_valid_target(M))
			var/operation_data = S.pre_surgery_step(user, M, zone, src)
			if(operation_data)
				LAZYSET(M.surgeries_in_progress, zone, operation_data)
				S.begin_step(user, M, zone, src)
				var/list/skill_reqs = S.get_skill_reqs(user, M, src, zone)
				var/duration = user.skill_delay_mult(skill_reqs[1]) * rand(S.min_duration, S.max_duration)
				if(prob(S.success_chance(user, M, src, zone)) && do_after(user, duration, M, DO_SURGERY))
					if (S.can_use(user, M, zone, src))
						S.end_step(user, M, zone, src)
						handle_post_surgery()
					else
						to_chat(user, SPAN_WARNING("The patient lost the target organ before you could finish operating!"))

				else if ((src in user.contents) && user.Adjacent(M))
					S.fail_step(user, M, zone, src)
				else
					to_chat(user, SPAN_WARNING("You must remain close to your patient to conduct surgery."))
				if(!QDELETED(M))
					LAZYREMOVE(M.surgeries_in_progress, zone) // Clear the in-progress flag.
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						H.update_surgery()
		return TRUE
	return FALSE

/obj/item/proc/handle_post_surgery()
	return

/obj/item/stack/handle_post_surgery()
	use(1)
