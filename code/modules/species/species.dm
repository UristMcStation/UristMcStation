GLOBAL_LIST_EMPTY(species_by_name)

GLOBAL_LIST_AS(playable_species, list(
	SPECIES_HUMAN
))

GLOBAL_LIST_EMPTY(mob_ref_to_species_name)

/hook/startup/proc/CreateSpeciesLists()
	var/race_key = 1
	for (var/singleton/species/species as anything in GET_SINGLETON_SUBTYPE_LIST(/singleton/species))
		GLOB.species_by_name[species.name] = species
		if (~species.spawn_flags & SPECIES_IS_RESTRICTED)
			GLOB.playable_species += species.name
		species.race_key = race_key++
	return TRUE

/singleton/species

	// Descriptors and strings.
	var/name
	var/name_plural                                      // Pluralized name (since "[name]s" is not always valid)
	var/description
	var/codex_description
	var/ooc_codex_information
	var/cyborg_noun = "Cyborg"
	var/hidden_from_codex = TRUE

	// Icon/appearance vars.
	var/icobase =      'icons/mob/human_races/species/human/body.dmi'          // Normal icon set.
	var/deform =       'icons/mob/human_races/species/human/deformed_body.dmi' // Mutated icon set.
	var/preview_icon = 'icons/mob/human_races/species/human/preview.dmi'
	var/husk_icon =    'icons/mob/human_races/species/default_husk.dmi'
	var/bandages_icon

	/// The width of this species' icons.
	var/icon_width = 32

	/// The height of this species' icons.
	var/icon_height = 32

	// Damage overlay and masks.
	var/damage_overlays = 'icons/mob/human_races/species/human/damage_overlay.dmi'
	var/damage_mask =     'icons/mob/human_races/species/human/damage_mask.dmi'
	var/blood_mask =      'icons/mob/human_races/species/human/blood_mask.dmi'

	var/blood_color = COLOR_BLOOD_HUMAN               // Red.
	var/flesh_color = "#ffc896"               // Pink.
	var/blood_oxy = 1
	var/base_color                            // Used by changelings. Should also be used for icon previes..
	var/limb_blend = ICON_ADD
	var/tail                                  // Name of tail state in species effects icon file.
	var/tail_animation                        // If set, the icon to obtain tail animation states from.
	var/tail_blend = ICON_ADD
	var/tail_hair

	var/list/hair_styles
	var/list/facial_hair_styles

	var/organs_icon		//species specific internal organs icons

	var/default_head_hair_style = "Bald"
	var/default_facial_hair_style = "Shaved"

	var/race_key = 0                          // Used for mob icon cache string.
	var/icon_template = 'icons/mob/human_races/species/template.dmi' // Used for mob icon generation for non-32x32 species.
	var/pixel_offset_x = 0                    // Used for offsetting large icons.
	var/pixel_offset_y = 0                    // Used for offsetting large icons.
	var/pixel_offset_z = 0                    // Used for offsetting large icons.
	var/antaghud_offset_x = 0                 // As above, but specifically for the antagHUD indicator.
	var/antaghud_offset_y = 0                 // As above, but specifically for the antagHUD indicator.

	var/mob_size	= MOB_MEDIUM
	var/strength    = STR_MEDIUM
	var/show_ssd = "fast asleep"
	var/show_coma = "completely comatose"
	var/short_sighted                         // Permanent weldervision.
	var/light_sensitive                       // Ditto, but requires sunglasses to fix
	var/blood_volume = SPECIES_BLOOD_DEFAULT  // Initial blood volume.
	var/hunger_factor = DEFAULT_HUNGER_FACTOR // Multiplier for hunger.
	var/thirst_factor = DEFAULT_THIRST_FACTOR // Multiplier for thirst.
	var/taste_sensitivity = TASTE_NORMAL      // How sensitive the species is to minute tastes.
	var/silent_steps

	var/min_age = 17
	var/max_age = 70

	// Speech vars.
	var/assisted_langs = list()               // The languages the species can't speak without an assisted organ.
	var/list/speech_sounds                    // A list of sounds to potentially play when speaking.
	var/list/speech_chance                    // The likelihood of a speech sound playing.

	// Combat vars.
	var/total_health = 200                   // Point at which the mob will enter crit.
	var/list/unarmed_types = list(           // Possible unarmed attacks that the mob will use in combat,
		/datum/unarmed_attack,
		/datum/unarmed_attack/bite
		)
	var/list/unarmed_attacks = null           // For empty hand harm-intent attack

	var/list/natural_armour_values            // Armour values used if naked.
	var/brute_mod =      1                    // Physical damage multiplier.
	var/burn_mod =       1                    // Burn damage multiplier.
	var/toxins_mod =     1                    // Toxloss modifier
	var/radiation_mod =  1                    // Radiation modifier

	var/oxy_mod =        1                    // Oxyloss modifier
	var/flash_mod =      1                    // Stun from blindness modifier.
	var/metabolism_mod = 1                    // Reagent metabolism modifier
	var/stun_mod =       1                    // Stun period modifier.
	var/paralysis_mod =  1                    // Paralysis period modifier.
	var/weaken_mod =     1                    // Weaken period modifier.

	var/vision_flags = SEE_SELF               // Same flags as glasses.

	// Death vars.
	var/meat_type =     /obj/item/reagent_containers/food/snacks/meat/human
	var/meat_amount =   3
	var/skin_material = MATERIAL_SKIN_GENERIC
	var/skin_amount =   3
	var/bone_material = MATERIAL_BONE_GENERIC
	var/bone_amount =   3
	var/remains_type =  /obj/item/remains/xeno
	var/gibbed_anim =   "gibbed-h"
	var/dusted_anim =   "dust-h"

	var/death_sound
	var/death_message = "seizes up and falls limp, their eyes dead and lifeless..."
	var/knockout_message = "collapses, having been knocked unconscious."
	var/halloss_message = "slumps over, too weak to continue fighting..."
	var/halloss_message_self = "The pain is too severe for you to keep going..."

	var/limbs_are_nonsolid
	var/spawns_with_stack = 0
	// Environment tolerance/life processes vars.
	var/breath_pressure = 16                                    // Minimum partial pressure safe for breathing, kPa
	var/breath_type = GAS_OXYGEN                                  // Non-oxygen gas breathed, if any.
	var/poison_types = list(GAS_PHORON = TRUE, GAS_CHLORINE = TRUE) // Noticeably poisonous air - ie. updates the toxins indicator on the HUD.
	var/exhale_type = GAS_CO2                          // Exhaled gas type.
	var/max_pressure_diff = 60                                  // Maximum pressure difference that is safe for lungs
	var/cold_level_1 = 243                                      // Cold damage level 1 below this point. -30 Celsium degrees
	var/cold_level_2 = 200                                      // Cold damage level 2 below this point.
	var/cold_level_3 = 120                                      // Cold damage level 3 below this point.
	var/heat_level_1 = 360                                      // Heat damage level 1 above this point.
	var/heat_level_2 = 400                                      // Heat damage level 2 above this point.
	var/heat_level_3 = 1000                                     // Heat damage level 3 above this point.
	var/passive_temp_gain = 0		                            // Species will gain this much temperature every second
	var/hazard_high_pressure = HAZARD_HIGH_PRESSURE             // Dangerously high pressure.
	var/warning_high_pressure = WARNING_HIGH_PRESSURE           // High pressure warning.
	var/warning_low_pressure = WARNING_LOW_PRESSURE             // Low pressure warning.
	var/hazard_low_pressure = HAZARD_LOW_PRESSURE               // Dangerously low pressure.
	var/body_temperature = 310.15	                            // Species will try to stabilize at this temperature.
	                                                            // (also affects temperature processing)
	var/heat_discomfort_level = 315                             // Aesthetic messages about feeling warm.
	var/cold_discomfort_level = 285                             // Aesthetic messages about feeling chilly.
	var/list/heat_discomfort_strings = list(
		"You feel sweat drip down your neck.",
		"You feel uncomfortably warm.",
		"Your skin prickles in the heat."
		)
	var/list/cold_discomfort_strings = list(
		"You feel chilly.",
		"You shiver suddenly.",
		"Your chilly flesh stands out in goosebumps."
		)

	var/water_soothe_amount

	// HUD data vars.
	var/datum/hud_data/hud
	var/hud_type
	var/health_hud_intensity = 1

	var/grab_type = GRAB_NORMAL		// The species' default grab type.

	// Body/form vars.
	var/list/inherent_verbs 	  // Species-specific verbs.
	var/has_fine_manipulation = 1 // Can use small items.
	var/siemens_coefficient = 1   // The lower, the thicker the skin and better the insulation.
	var/darksight_range = 2       // Native darksight distance.
	var/darksight_tint = DARKTINT_NONE // How shadows are tinted.
	var/species_flags = 0         // Various specific features.
	var/appearance_flags = 0      // Appearance/display related features.
	var/spawn_flags = 0           // Flags that specify who can spawn as this species
	var/slowdown = 0              // Passive movement speed malus (or boost, if negative)
	// Move intents. Earlier in list == default for that type of movement.
	var/list/move_intents = list(/singleton/move_intent/run,
	/singleton/move_intent/walk,
	/singleton/move_intent/creep)

	var/primitive_form            // Lesser form, if any (ie. monkey for humans)
	var/greater_form              // Greater form, if any, ie. human for monkeys.
	var/holder_type
	var/gluttonous = 0            // Can eat some mobs. Values can be GLUT_TINY, GLUT_SMALLER, GLUT_ANYTHING, GLUT_ITEM_TINY, GLUT_ITEM_NORMAL, GLUT_ITEM_ANYTHING, GLUT_PROJECTILE_VOMIT
	var/stomach_capacity = 5      // How much stuff they can stick in their stomach
	var/rarity_value = 1          // Relative rarity/collector value for this species.
	                              // Determines the organs that the species spawns with and
	var/list/has_organ = list(    // which required-organ checks are conducted.
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_STOMACH =  /obj/item/organ/internal/stomach,
		BP_LUNGS =    /obj/item/organ/internal/lungs,
		BP_LIVER =    /obj/item/organ/internal/liver,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_APPENDIX = /obj/item/organ/internal/appendix,
		BP_EYES =     /obj/item/organ/internal/eyes
		)
	var/vision_organ              // If set, this organ is required for vision. Defaults to "eyes" if the species has them.
	var/breathing_organ           // If set, this organ is required for breathing. Defaults to "lungs" if the species has them.

	var/list/override_organ_types // Used for species that only need to change one or two entries in has_organ.

	var/obj/decal/cleanable/blood/tracks/move_trail = /obj/decal/cleanable/blood/tracks/footprints // What marks are left when walking

	var/list/skin_overlays = list()

	var/list/has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

	var/list/override_limb_types // Used for species that only need to change one or two entries in has_limbs.

	// The basic skin colours this species uses
	var/list/base_skin_colours

	var/list/genders = list(MALE, FEMALE, PLURAL)
	var/list/pronouns = PRONOUNS_ALL

	// Bump vars
	var/bump_flag = HUMAN	// What are we considered to be when bumped?
	var/push_flags = ~HEAVY	// What can we push?
	var/swap_flags = ~HEAVY	// What can we swap place with?

	var/pass_flags = 0
	var/breathing_sound = 'sound/voice/monkey.ogg'
	var/bodyfall_sound = 'sound/effects/bodyfall.ogg'
	var/list/equip_adjust = list()
	var/list/equip_overlays = list()

	var/list/base_auras

	var/sexybits_location	//organ tag where they are located if they can be kicked for increased pain

	var/list/descriptors = list(
		/datum/mob_descriptor/height = 0,
		/datum/mob_descriptor/build = 0
	)

	var/standing_jump_range = 2
	var/list/maneuvers = list(
		/singleton/maneuver/leap,
		/singleton/maneuver/leap/quick
	)

	var/list/available_cultural_info = list(
		TAG_CULTURE =   list(CULTURE_OTHER),
		TAG_HOMEWORLD = list(HOME_SYSTEM_STATELESS),
		TAG_FACTION =   list(FACTION_OTHER),
		TAG_RELIGION =  list(RELIGION_OTHER, RELIGION_ATHEISM, RELIGION_AGNOSTICISM, RELIGION_UNSTATED)
	)
	var/list/force_cultural_info =                list()
	var/list/default_cultural_info =              list()
	var/list/additional_available_cultural_info = list()
	var/max_players

	var/list/default_emotes = list()

	// Order matters, higher pain level should be higher up
	var/list/pain_emotes_with_pain_level = list(
		list(/singleton/emote/audible/scream, /singleton/emote/audible/whimper, /singleton/emote/audible/moan, /singleton/emote/audible/cry) = 70,
		list(/singleton/emote/audible/grunt, /singleton/emote/audible/groan, /singleton/emote/audible/moan) = 40,
		list(/singleton/emote/audible/grunt, /singleton/emote/audible/groan) = 10,
	)


	var/exertion_effect_chance = 0
	var/exertion_hydration_scale = 0
	var/exertion_nutrition_scale = 0
	var/exertion_charge_scale = 0
	var/exertion_reagent_scale = 0
	var/exertion_reagent_path = null
	var/list/exertion_emotes_biological = null
	var/list/exertion_emotes_synthetic = null

	/// When being fed a reagent item, the amount this species eats per bite on help intent.
	var/ingest_amount = 10

	/// An associative list of /singleton/trait and trait level a species starts with by default - See individual traits for valid levels
	var/list/traits = list()

	/**
	* Allows a species to override footprints on worn clothing. Used by get_move_trail.
	* Uses istype() so child objects should be first in the list relative to parent objects.
	* For universally overriding footprints on all footwear, use obj/item/clothing instead of /obj/item/clothing/shoes since suit layer clothing that covers the feet (space suits) are a thing.
	*/
	var/list/footwear_trail_overrides
/*
These are all the things that can be adjusted for equipping stuff and
each one can be in the NORTH, SOUTH, EAST, and WEST direction. Specify
the direction to shift the thing and what direction.

example:
	equip_adjust = list(
		slot_back_str = list(NORTH = list(SOUTH = 12, EAST = 7), EAST = list(SOUTH = 2, WEST = 12))
			)

This would shift back items (backpacks, axes, etc.) when the mob
is facing either north or east.
When the mob faces north the back item icon is shifted 12 pixes down and 7 pixels to the right.
When the mob faces east the back item icon is shifted 2 pixels down and 12 pixels to the left.

The slots that you can use are found in items_clothing.dm and are the inventory slot string ones, so make sure
	you use the _str version of the slot.
*/

/singleton/species/New()

	if(!codex_description)
		codex_description = description

	for(var/token in ALL_CULTURAL_TAGS)

		var/force_val = force_cultural_info[token]
		if(force_val)
			default_cultural_info[token] = force_val
			available_cultural_info[token] = list(force_val)

		else if(additional_available_cultural_info[token])
			if(!available_cultural_info[token])
				available_cultural_info[token] = list()
			available_cultural_info[token] |= additional_available_cultural_info[token]

		else if(!available_cultural_info || !LAZYLEN(available_cultural_info[token]))
			var/list/map_systems = GLOB.using_map.available_cultural_info[token]
			available_cultural_info[token] = map_systems.Copy()

		if(LAZYLEN(available_cultural_info[token]) && !default_cultural_info[token])
			var/list/avail_systems = available_cultural_info[token]
			default_cultural_info[token] = avail_systems[1]

		if(!default_cultural_info[token])
			default_cultural_info[token] = GLOB.using_map.default_cultural_info[token]

	if(hud_type)
		hud = new hud_type()
	else
		hud = new()

	if(LAZYLEN(descriptors))
		var/list/descriptor_datums = list()
		for(var/desctype in descriptors)
			var/datum/mob_descriptor/descriptor = new desctype
			descriptor.comparison_offset = descriptors[desctype]
			descriptor_datums[descriptor.name] = descriptor
		descriptors = descriptor_datums

	//If the species has eyes, they are the default vision organ
	if(!vision_organ && has_organ[BP_EYES])
		vision_organ = BP_EYES
	//If the species has lungs, they are the default breathing organ
	if(!breathing_organ && has_organ[BP_LUNGS])
		breathing_organ = BP_LUNGS

	unarmed_attacks = list()
	for(var/u_type in unarmed_types)
		unarmed_attacks += new u_type()

	// Modify organ lists if necessary.
	if(islist(override_organ_types))
		for(var/ltag in override_organ_types)
			has_organ[ltag] = override_organ_types[ltag]

	if(islist(override_limb_types))
		for(var/ltag in override_limb_types)
			has_limbs[ltag] = list("path" = override_limb_types[ltag])

	//Build organ descriptors
	for(var/limb_type in has_limbs)
		var/list/organ_data = has_limbs[limb_type]
		var/obj/item/organ/limb_path = organ_data["path"]
		organ_data["descriptor"] = initial(limb_path.name)

/singleton/species/proc/equip_survival_gear(mob/living/carbon/human/H,extendedtank = 1)
	if(istype(H.get_equipped_item(slot_back), /obj/item/storage/backpack))
		if (extendedtank)	H.equip_to_slot_or_del(new /obj/item/storage/box/engineer(H.back), slot_in_backpack)
		else	H.equip_to_slot_or_del(new /obj/item/storage/box/survival(H.back), slot_in_backpack)
	else
		if (extendedtank)	H.equip_to_slot_or_del(new /obj/item/storage/box/engineer(H), slot_r_hand)
		else	H.equip_to_slot_or_del(new /obj/item/storage/box/survival(H), slot_r_hand)

/singleton/species/proc/create_organs(mob/living/carbon/human/H) //Handles creation of mob organs.

	H.mob_size = mob_size
	for(var/obj/item/organ/organ in H.contents)
		if((organ in H.organs) || (organ in H.internal_organs))
			qdel(organ)

	if(H.organs)                  H.organs.Cut()
	if(H.internal_organs)         H.internal_organs.Cut()
	if(H.organs_by_name)          H.organs_by_name.Cut()
	if(H.internal_organs_by_name) H.internal_organs_by_name.Cut()

	H.organs = list()
	H.internal_organs = list()
	H.organs_by_name = list()
	H.internal_organs_by_name = list()

	for(var/limb_type in has_limbs)
		var/list/organ_data = has_limbs[limb_type]
		var/limb_path = organ_data["path"]
		new limb_path(H)

	for(var/organ_tag in has_organ)
		var/organ_type = has_organ[organ_tag]
		var/obj/item/organ/O = new organ_type(H)
		if(organ_tag != O.organ_tag)
			warning("[O.type] has a default organ tag \"[O.organ_tag]\" that differs from the species' organ tag \"[organ_tag]\". Updating organ_tag to match.")
			O.organ_tag = organ_tag
		H.internal_organs_by_name[organ_tag] = O
	for(var/name in H.organs_by_name)
		H.organs |= H.organs_by_name[name]

	for(var/name in H.internal_organs_by_name)
		H.internal_organs |= H.internal_organs_by_name[name]

	for(var/obj/item/organ/O in (H.organs|H.internal_organs))
		O.owner = H
		post_organ_rejuvenate(O, H)
	H.sync_organ_dna()

/singleton/species/proc/hug(mob/living/carbon/human/H, mob/living/target)

	var/datum/pronouns/P = target.choose_from_pronouns()

	// If aiming for the head, try a headpat
	var/target_zone = check_zone(H.zone_sel.selecting)
	var/mob/living/carbon/human/h_target
	if (ishuman(target))
		h_target = target
		H.transfer_bloody_hands(h_target, target_zone)

	if (target_zone == BP_HEAD)
		if(h_target)
			if(h_target.get_organ(target_zone))
				H.visible_message(SPAN_NOTICE("[H] pats [h_target]'s head to make [P.him] feel better!"), SPAN_NOTICE("You pat [h_target]'s head to make [P.him] feel better!"))
				return
		else
			H.visible_message(SPAN_NOTICE("[H] pats [target] on the head."), SPAN_NOTICE("You pat [target] on the head to make [P.him] feel better!"))
			return

	else if(target_zone == BP_R_HAND || target_zone == BP_L_HAND)
		if(h_target)
			if(h_target.get_organ(target_zone))
				H.visible_message(SPAN_NOTICE("[H] shakes [h_target]'s hand."), \
				SPAN_NOTICE("You shake [h_target]'s hand."))
				return
		else
			H.visible_message(SPAN_NOTICE("[H] shakes [target]'s hand."), \
			SPAN_NOTICE("You shake [target]'s hand."))
			return

	else
		if(h_target)
			H.transfer_bloody_body(h_target, BP_CHEST)
		H.visible_message(SPAN_NOTICE("[H] hugs [target] to make [P.him] feel better!"), SPAN_NOTICE("You hug [target] to make [P.him] feel better!"))

	if(H != target)
		H.update_personal_goal(/datum/goal/achievement/givehug, TRUE)
		target.update_personal_goal(/datum/goal/achievement/gethug, TRUE)

/singleton/species/proc/add_base_auras(mob/living/carbon/human/H)
	if(base_auras)
		for(var/type in base_auras)
			H.add_aura(new type(H))

/singleton/species/proc/remove_base_auras(mob/living/carbon/human/H)
	if(base_auras)
		var/list/bcopy = base_auras.Copy()
		for(var/a in H.auras)
			var/obj/aura/A = a
			if(is_type_in_list(a, bcopy))
				bcopy -= A.type
				H.remove_aura(A)
				qdel(A)

/singleton/species/proc/remove_inherent_verbs(mob/living/carbon/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			H.verbs -= verb_path
	return

/singleton/species/proc/add_inherent_verbs(mob/living/carbon/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			H.verbs |= verb_path
	return

/singleton/species/proc/handle_post_spawn(mob/living/carbon/human/H) //Handles anything not already covered by basic species assignment.
	H.icon_width = icon_width
	H.icon_height = icon_height
	add_inherent_verbs(H)
	add_base_auras(H)
	H.mob_bump_flag = bump_flag
	H.mob_swap_flags = swap_flags
	H.mob_push_flags = push_flags
	H.pass_flags = pass_flags
	handle_limbs_setup(H)

/singleton/species/proc/handle_pre_spawn(mob/living/carbon/human/H)
	// Changing species can change NPC behaviour, so delete the holder if there is one
	if (H.ai_holder && istype(H.ai_holder, /datum))
		GLOB.stat_set_event.unregister(H, H.ai_holder, TYPE_PROC_REF(/datum/ai_holder, holder_stat_change))
		QDEL_NULL(H.ai_holder)

/singleton/species/proc/handle_death(mob/living/carbon/human/H) //Handles any species-specific death events (such as dionaea nymph spawns).
	return

/singleton/species/proc/handle_new_grab(mob/living/carbon/human/H, obj/item/grab/G)
	return

/singleton/species/proc/handle_sleeping(mob/living/carbon/human/H)
	if(prob(2) && !H.failed_last_breath && !H.isSynthetic())
		if(!H.paralysis)
			H.emote("snore")
		else
			H.emote("groan")

// Only used for alien plasma weeds atm, but could be used for Dionaea later.
/singleton/species/proc/handle_environment_special(mob/living/carbon/human/H)
	return

/singleton/species/proc/handle_movement_delay_special(mob/living/carbon/human/H)
	return 0

// Used to update alien icons for aliens.
/singleton/species/proc/handle_login_special(mob/living/carbon/human/H)
	return

// As above.
/singleton/species/proc/handle_logout_special(mob/living/carbon/human/H)
	return

// Builds the HUD using species-specific icons and usable slots.
/singleton/species/proc/build_hud(mob/living/carbon/human/H)
	return

//Used by xenos understanding larvae and dionaea understanding nymphs.
/singleton/species/proc/can_understand(mob/other)
	return

/singleton/species/proc/can_overcome_gravity(mob/living/carbon/human/H)
	return FALSE

// Used for any extra behaviour when falling and to see if a species will fall at all.
/singleton/species/proc/can_fall(mob/living/carbon/human/H)
	return TRUE

//Used for swimming
/singleton/species/proc/can_float(mob/living/carbon/human/H)
	if(!H.is_physically_disabled())
		if(H.encumbrance() < 1)
			return TRUE //Is not possible to swim while pulling big things
	return FALSE

// Used to override normal fall behaviour. Use only when the species does fall down a level.
/singleton/species/proc/handle_fall_special(mob/living/carbon/human/H, turf/landing)
	return FALSE

// Called when using the shredding behavior.
/singleton/species/proc/can_shred(mob/living/carbon/human/H, ignore_intent, ignore_antag)

	if((!ignore_intent && H.a_intent != I_HURT) || H.pulling_punches)
		return 0

	if(!ignore_antag && H.mind && !player_is_antag(H.mind))
		return 0

	for(var/datum/unarmed_attack/attack in unarmed_attacks)
		if(!attack.is_usable(H))
			continue
		if(attack.shredding)
			return 1

	return 0

/singleton/species/proc/handle_vision(mob/living/carbon/human/H)
	var/list/vision = H.get_accumulated_vision_handlers()
	H.update_sight()
	H.set_sight(H.sight|get_vision_flags(H)|H.equipment_vision_flags|vision[1])
	H.change_light_colour(H.getDarkvisionTint())

	if(H.stat == DEAD)
		return 1

	if(!H.druggy)
		H.set_see_in_dark((H.sight == (SEE_TURFS|SEE_MOBS|SEE_OBJS)) ? 8 : min(H.getDarkvisionRange() + H.equipment_darkness_modifier, 8))
		if(H.equipment_see_invis)
			H.set_see_invisible(max(min(H.see_invisible, H.equipment_see_invis), vision[2]))

	if(H.equipment_tint_total >= TINT_BLIND)
		H.eye_blind = max(H.eye_blind, 1)

	if(!H.client)//no client, no screen to update
		return 1

	H.set_fullscreen(H.eye_blind && !H.equipment_prescription, "blind", /obj/screen/fullscreen/blind)
	H.set_fullscreen(H.stat == UNCONSCIOUS, "bliind", /obj/screen/fullscreen/blind)


	if(config.welder_vision)
		H.set_fullscreen(H.equipment_tint_total, "welder", /obj/screen/fullscreen/impaired, H.equipment_tint_total)
	var/how_nearsighted = get_how_nearsighted(H)
	H.set_fullscreen(how_nearsighted, "nearsighted", /obj/screen/fullscreen/oxy, how_nearsighted)
	H.set_fullscreen(H.eye_blurry, "blurry", /obj/screen/fullscreen/blurry)
	H.set_fullscreen(H.druggy, "high", /obj/screen/fullscreen/high)

	for(var/overlay in H.equipment_overlays)
		H.client.screen |= overlay

	return 1

/singleton/species/proc/get_how_nearsighted(mob/living/carbon/human/H)
	var/prescriptions = short_sighted
	if(H.disabilities & NEARSIGHTED)
		prescriptions += 7
	if(H.equipment_prescription)
		prescriptions -= H.equipment_prescription

	var/light = light_sensitive
	if(light)
		if(H.eyecheck() > FLASH_PROTECTION_NONE)
			light = 0
		else
			var/turf_brightness = 1
			var/turf/T = get_turf(H)
			if(T && T.lighting_overlay)
				turf_brightness = min(1, T.get_lumcount())
			if(turf_brightness < 0.33)
				light = 0
			else
				light = round(light * turf_brightness)
				if(H.equipment_light_protection)
					light -= H.equipment_light_protection
	return clamp(max(prescriptions, light), 0, 7)

/singleton/species/proc/set_default_hair(mob/living/carbon/human/H)
	H.head_hair_style = H.species.default_head_hair_style
	H.facial_hair_style = H.species.default_facial_hair_style
	H.update_hair()

/singleton/species/proc/get_blood_name()
	return "blood"

/singleton/species/proc/handle_death_check(mob/living/carbon/human/H)
	return FALSE

//Mostly for toasters
/singleton/species/proc/handle_limbs_setup(mob/living/carbon/human/H)
	for(var/thing in H.organs)
		post_organ_rejuvenate(thing, H)

// Impliments different trails for species depending on if they're wearing shoes.
/singleton/species/proc/get_move_trail(mob/living/carbon/human/H)
	if(H.lying)
		return /obj/decal/cleanable/blood/tracks/body
	if(H.shoes || (H.wear_suit && (H.wear_suit.body_parts_covered & FEET)))
		var/obj/item/clothing/shoes = (H.wear_suit && (H.wear_suit.body_parts_covered & FEET)) ? H.wear_suit : H.shoes // suits take priority over shoes
		if(footwear_trail_overrides)
			for (var/key in footwear_trail_overrides)
				if (istype(shoes, key))
					return footwear_trail_overrides[key]
		return shoes.move_trail
	else
		return move_trail

/singleton/species/proc/update_skin(mob/living/carbon/human/H)
	return

/singleton/species/proc/disarm_attackhand(mob/living/carbon/human/attacker, mob/living/carbon/human/target)
	attacker.do_attack_animation(target)

	if(target.w_uniform)
		target.w_uniform.add_fingerprint(attacker)
	var/obj/item/organ/external/affecting = target.get_organ(ran_zone(attacker.zone_sel.selecting))

	var/list/holding = list(target.get_active_hand() = 60, target.get_inactive_hand() = 30)

	var/state_mod = attacker.melee_accuracy_mods() - target.melee_accuracy_mods()
	var/stim_mod = target.chem_effects[CE_STIMULANT]
	var/push_threshold = 12 + (1 - stim_mod)
	var/disarm_threshold = 24 + ((1 - stim_mod) * 2)

	if(target.a_intent == I_HELP)
		state_mod -= 30
	//Handle unintended consequences
	for(var/obj/item/I in holding)
		var/hurt_prob = max(holding[I] + state_mod, 0)
		if(prob(hurt_prob) && I.on_disarm_attempt(target, attacker))
			return

	var/randn = rand(1, 100) + state_mod
	if(!(check_no_slip(target)) && randn <= push_threshold)
		var/armor_check = 100 * target.get_blocked_ratio(affecting, DAMAGE_BRUTE, damage = 20)
		target.apply_effect(2, EFFECT_WEAKEN, armor_check)
		playsound(target.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		if(armor_check < 100)
			target.visible_message(SPAN_DANGER("[attacker] has pushed [target]!"))
		else
			target.visible_message(SPAN_WARNING("[attacker] attempted to push [target]!"))
		return

	if(randn <= disarm_threshold)
		//See about breaking grips or pulls
		if(target.break_all_grabs(attacker))
			playsound(target.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			return

		//Actually disarm them
		for(var/obj/item/I in holding)
			if(I && target.unEquip(I))
				target.visible_message(SPAN_DANGER("[attacker] has disarmed [target]!"))
				playsound(target.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				return

	playsound(target.loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
	target.visible_message(SPAN_DANGER("[attacker] attempted to disarm \the [target]!"))

/singleton/species/proc/disfigure_msg(mob/living/carbon/human/H) //Used for determining the message a disfigured face has on examine. To add a unique message, just add this onto a specific species and change the "return" message.
	var/datum/pronouns/P = H.choose_from_pronouns()
	return "[SPAN_DANGER("[P.His] face is horribly mangled!")]\n"

/singleton/species/proc/max_skin_tone()
	if(appearance_flags & SPECIES_APPEARANCE_HAS_SKIN_TONE_GRAV)
		return 100
	if(appearance_flags & SPECIES_APPEARANCE_HAS_SKIN_TONE_SPCR)
		return 165
	if(appearance_flags & SPECIES_APPEARANCE_HAS_SKIN_TONE_TRITON)
		return 80
	return 220

/singleton/species/proc/get_hair_styles()
	var/list/L = LAZYACCESS(hair_styles, type)
	if(!L)
		L = list()
		LAZYSET(hair_styles, type, L)
		for(var/hairstyle in GLOB.hair_styles_list)
			var/datum/sprite_accessory/S = GLOB.hair_styles_list[hairstyle]
			if(S.species_allowed && !(get_bodytype() in S.species_allowed))
				continue
			if(S.subspecies_allowed && !(name in S.subspecies_allowed))
				continue
			ADD_SORTED(L, hairstyle, GLOBAL_PROC_REF(cmp_text_asc))
			L[hairstyle] = S
	return L

/singleton/species/proc/get_facial_hair_styles(gender)
	var/list/facial_hair_styles_by_species = LAZYACCESS(facial_hair_styles, type)
	if(!facial_hair_styles_by_species)
		facial_hair_styles_by_species = list()
		LAZYSET(facial_hair_styles, type, facial_hair_styles_by_species)

	var/list/facial_hair_style_by_gender = facial_hair_styles_by_species[gender]
	if(!facial_hair_style_by_gender)
		facial_hair_style_by_gender = list()
		LAZYSET(facial_hair_styles_by_species, gender, facial_hair_style_by_gender)

		for(var/facialhairstyle in GLOB.facial_hair_styles_list)
			var/datum/sprite_accessory/S = GLOB.facial_hair_styles_list[facialhairstyle]
			if(gender == MALE && S.gender == FEMALE)
				continue
			if(gender == FEMALE && S.gender == MALE)
				continue
			if(S.species_allowed && !(get_bodytype() in S.species_allowed))
				continue
			if(S.subspecies_allowed && !(name in S.subspecies_allowed))
				continue
			ADD_SORTED(facial_hair_style_by_gender, facialhairstyle, GLOBAL_PROC_REF(cmp_text_asc))
			facial_hair_style_by_gender[facialhairstyle] = S

	return facial_hair_style_by_gender

/singleton/species/proc/get_selectable_traits()
	var/list/allowed_traits = list()
	var/list/trait_list = GET_SINGLETON_SUBTYPE_LIST(/singleton/trait)
	for (var/singleton/trait/allowed_trait in trait_list)
		if (!allowed_trait.selectable)
			continue
		if (LAZYISIN(traits, allowed_trait.type))
			continue
		if (LAZYISIN(allowed_trait.forbidden_species, name))
			continue
		if (!allowed_trait.name)
			continue
		LAZYSET(allowed_traits, allowed_trait.name, allowed_trait)

	return allowed_traits

/singleton/species/proc/get_description(header, append, verbose = TRUE, skip_detail, skip_photo)
	var/list/damage_types = list(
		"physical trauma" = brute_mod,
		"burns" = burn_mod,
		"lack of air" = oxy_mod,
		"poison" = toxins_mod
	)
	var/name_clean = replace_characters(name,list("'"=""))
	if(!header)
		header = "<center><h2>[name]</h2></center><hr/>"
	var/dat = list()
	dat += "[header]"
	dat += "<table padding='8px'>"
	dat += "<tr>"
	dat += "<td width = 400>"
	if(verbose || length(description) <= MAX_DESC_LEN)
		dat += "[description]"
	else
		dat += "[copytext(description, 1, MAX_DESC_LEN)] \[...\]"
	if(append)
		dat += "<br>[append]"
	dat += "</td>"
	if((!skip_photo && preview_icon) || !skip_detail)
		dat += "<td width = 200 align='center'>"
		if(!skip_photo && preview_icon)
			send_rsc(usr, icon(icon = preview_icon, icon_state = ""), "species_preview_[name_clean].png")
			dat += "<img src='species_preview_[name_clean].png'>"
		if(!skip_detail)
			dat += "<small>"
			if(spawn_flags & SPECIES_CAN_JOIN)
				dat += "</br><b>Often present among humans.</b>"
			if(spawn_flags & SPECIES_IS_WHITELISTED)
				dat += "</br><b>Whitelist restricted.</b>"
			if(!has_organ[BP_HEART])
				dat += "</br><b>Does not have blood.</b>"
			if(!has_organ[breathing_organ])
				dat += "</br><b>Does not breathe.</b>"
			if(species_flags & SPECIES_FLAG_NO_SCAN)
				dat += "</br><b>Does not have DNA.</b>"
			if(species_flags & SPECIES_FLAG_NO_PAIN)
				dat += "</br><b>Does not feel pain.</b>"
			if(species_flags & SPECIES_FLAG_NO_MINOR_CUT)
				dat += "</br><b>Has thick skin/scales.</b>"
			if(species_flags & SPECIES_FLAG_NO_SLIP)
				dat += "</br><b>Has excellent traction.</b>"
			if(species_flags & SPECIES_FLAG_NO_POISON)
				dat += "</br><b>Immune to most poisons.</b>"
			if(appearance_flags & SPECIES_APPEARANCE_HAS_A_SKIN_TONE)
				dat += "</br><b>Has a variety of skin tones.</b>"
			if(appearance_flags & SPECIES_APPEARANCE_HAS_SKIN_COLOR)
				dat += "</br><b>Has a variety of skin colours.</b>"
			if(appearance_flags & SPECIES_APPEARANCE_HAS_EYE_COLOR)
				dat += "</br><b>Has a variety of eye colours.</b>"
			if(species_flags & SPECIES_FLAG_IS_PLANT)
				dat += "</br><b>Has a plantlike physiology.</b>"
			if(slowdown)
				dat += "</br><b>Moves [slowdown > 0 ? "slower" : "faster"] than most.</b>"
			for(var/kind in damage_types)
				if(damage_types[kind] > 1)
					dat += "</br><b>Vulnerable to [kind].</b>"
				else if(damage_types[kind] < 1)
					dat += "</br><b>Resistant to [kind].</b>"
			if(has_organ[breathing_organ])
				dat += "</br><b>They breathe [gas_data.name[breath_type]].</b>"
				dat += "</br><b>They exhale [gas_data.name[exhale_type]].</b>"
			if(LAZYLEN(poison_types))
				dat += "</br><b>[capitalize(english_list(poison_types))] [LAZYLEN(poison_types) == 1 ? "is" : "are"] poisonous to them.</b>"
			dat += "</small>"
		dat += "</td>"
	dat += "</tr>"
	dat += "</table><hr/>"
	return jointext(dat, null)

/mob/living/carbon/human/verb/check_species()
	set name = "Check Species Information"
	set category = "IC"
	set src = usr

	show_browser(src, species.get_description(), "window=species;size=700x400")

/singleton/species/proc/post_organ_rejuvenate(obj/item/organ/org, mob/living/carbon/human/H)
	return

/singleton/species/proc/check_no_slip(mob/living/carbon/human/H)
	if(can_overcome_gravity(H))
		return TRUE
	return (species_flags & SPECIES_FLAG_NO_SLIP)

/singleton/species/proc/get_pain_emote(mob/living/carbon/human/H, pain_power)
	if(!(species_flags & SPECIES_FLAG_NO_PAIN))
		return
	for(var/pain_emotes in pain_emotes_with_pain_level)
		var/pain_level = pain_emotes_with_pain_level[pain_emotes]
		if(pain_level >= pain_power)
			// This assumes that if a pain-level has been defined it also has a list of emotes to go with it
			var/singleton/emote/E = GET_SINGLETON(pick(pain_emotes))
			return E.key

/singleton/species/proc/handle_exertion(mob/living/carbon/human/H)
	if (!exertion_effect_chance)
		return
	var/chance = exertion_effect_chance * H.encumbrance()
	if (chance && prob(H.skill_fail_chance(SKILL_HAULING, chance)))
		var/synthetic = H.isSynthetic()
		if (synthetic)
			if (exertion_charge_scale)
				var/obj/item/organ/internal/cell/cell = locate() in H.internal_organs
				if (cell)
					cell.use(cell.get_power_drain() * exertion_charge_scale)
		if (exertion_hydration_scale)
			H.adjust_hydration(-DEFAULT_THIRST_FACTOR * exertion_hydration_scale)
		if (exertion_nutrition_scale)
			H.adjust_nutrition(-DEFAULT_HUNGER_FACTOR * exertion_nutrition_scale)
		if (exertion_reagent_scale && !isnull(exertion_reagent_path))
			H.make_reagent(REM * exertion_reagent_scale, exertion_reagent_path)
		if (prob(10))
			var/list/active_emotes = synthetic ? exertion_emotes_synthetic : exertion_emotes_biological
			var/singleton/emote/exertion_emote = GET_SINGLETON(pick(active_emotes))
			if (exertion_emote)
				exertion_emote.do_emote(H)
