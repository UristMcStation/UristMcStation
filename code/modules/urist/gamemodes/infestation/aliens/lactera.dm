/mob/living/carbon/human/lactera/New(new_loc)
	head_hair_style = "Bald"
	..(new_loc, "Lactera")

	faction = "alien"

/mob/living/carbon/human/lactera/bullet_act(obj/item/projectile/Proj)
	Proj.embed = 0

	..()

/mob/living/carbon/human/lactera/handle_strip()
	return //can't strip lactera

/obj/item/organ/external/chest/lactera
	limb_flags = null
	dislocated = -1
	arterial_bleed_severity = 0

/obj/item/organ/external/groin/lactera
	limb_flags = null
	dislocated = -1
	arterial_bleed_severity = 0

/obj/item/organ/external/arm/lactera
	limb_flags = null
	dislocated = -1
	arterial_bleed_severity = 0

/obj/item/organ/external/arm/right/lactera
	limb_flags = null
	dislocated = -1
	arterial_bleed_severity = 0

/obj/item/organ/external/leg/lactera
	limb_flags = null
	dislocated = -1
	arterial_bleed_severity = 0

/obj/item/organ/external/leg/right/lactera
	limb_flags = null
	dislocated = -1
	arterial_bleed_severity = 0

/obj/item/organ/external/foot/lactera
	limb_flags = null
	dislocated = -1
	arterial_bleed_severity = 0

/obj/item/organ/external/foot/right/lactera
	limb_flags = null
	dislocated = -1
	arterial_bleed_severity = 0

/obj/item/organ/external/hand/lactera
	limb_flags = null
	dislocated = -1
	arterial_bleed_severity = 0

/obj/item/organ/external/hand/right/lactera
	limb_flags = null
	dislocated = -1
	arterial_bleed_severity = 0

/obj/item/organ/external/head/lactera
	limb_flags = null
	dislocated = -1
	arterial_bleed_severity = 0
	draw_eyes = 'icons/uristmob/species/lactera/eyes.dmi'

/*/datum/hud_data/lactera //work on this //just make the lactera clothing unremovable, delete this
	has_internals = 0

	gear = list(
		"o_clothing" =   list("loc" = ui_iclothing, "name" = "Suit",     	 "slot" = slot_wear_suit, "state" = "center", "toggle" = 1, "dir" = SOUTH),
		"shoes" =  		 list("loc" = ui_shoes,     "name" = "Shoes",        "slot" = slot_shoes,"state" = "equip",  "toggle" = 1, "dir" = SOUTH),
		"gloves" =       list("loc" = ui_gloves,    "name" = "Gloves",       "slot" = slot_gloves,    "state" = "ears",   "toggle" = 1),
		"eyes" =         list("loc" = ui_oclothing, "name" = "Eyes",         "slot" = slot_glasses,   "state" = "eyes",   "toggle" = 1),
		"suit storage" = list("loc" = ui_sstore1,   "name" = "Suit Storage", "slot" = slot_s_store,   "state" = "belt",   "dir" = 8),
		"back" =         list("loc" = ui_back,      "name" = "Back",         "slot" = slot_back,      "state" = "back",   "dir" = NORTH),
		"id" =           list("loc" = ui_id,        "name" = "ID",           "slot" = slot_wear_id,   "state" = "id",     "dir" = NORTH),
		"storage1" =     list("loc" = ui_storage1,  "name" = "Left Pocket",  "slot" = slot_l_store,   "state" = "pocket"),
		"storage2" =     list("loc" = ui_storage2,  "name" = "Right Pocket", "slot" = slot_r_store,   "state" = "pocket"),
		"belt" =         list("loc" = ui_belt,      "name" = "Belt",         "slot" = slot_belt,      "state" = "belt")
		)

	gear = list(
		"i_clothing" =   list("loc" = ui_iclothing, "name" = "Uniform",      "slot" = slot_w_uniform, "state" = "center", "toggle" = 1, "dir" = SOUTH),
		"o_clothing" =   list("loc" = ui_shoes,     "name" = "Suit",         "slot" = slot_wear_suit, "state" = "equip",  "toggle" = 1, "dir" = SOUTH),
		"l_ear" =        list("loc" = ui_gloves,    "name" = "Ear",          "slot" = slot_l_ear,     "state" = "ears",   "toggle" = 1),
		"head" =         list("loc" = ui_oclothing, "name" = "Hat",          "slot" = slot_head,      "state" = "hair",   "toggle" = 1),
		"suit storage" = list("loc" = ui_sstore1,   "name" = "Suit Storage", "slot" = slot_s_store,   "state" = "belt",   "dir" = 8),
		"back" =         list("loc" = ui_back,      "name" = "Back",         "slot" = slot_back,      "state" = "back",   "dir" = NORTH),
		"id" =           list("loc" = ui_id,        "name" = "ID",           "slot" = slot_wear_id,   "state" = "id",     "dir" = NORTH),
		"storage1" =     list("loc" = ui_storage1,  "name" = "Left Pocket",  "slot" = slot_l_store,   "state" = "pocket"),
		"storage2" =     list("loc" = ui_storage2,  "name" = "Right Pocket", "slot" = slot_r_store,   "state" = "pocket"),
		"belt" =         list("loc" = ui_belt,      "name" = "Belt",         "slot" = slot_belt,      "state" = "belt")
		)*/

/datum/species/xenos/lactera
	name = "Lactera"
	name_plural = "Lactera"

	icon_template = 'icons/mob/human_races/species/template.dmi'
	icobase = 'icons/uristmob/species/lactera/body.dmi'
	preview_icon = 'icons/uristmob/species/lactera/preview.dmi'
	deform = 'icons/uristmob/species/lactera/deform.dmi'

	natural_armour_values = list(melee = 0, bullet = 0, laser = 0, energy = 10, bomb = 10, bio = 100, rad = 100)

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws/strong)

	hud_type = null

	has_fine_manipulation = 1
	gluttonous = GLUT_SMALLER
	spawns_with_stack = 0

	brute_mod = 1.6
	burn_mod = 1.1
	radiation_mod = 0    // No feasible way of curing radiation.
	flash_mod =     0    // Denied.
	stun_mod =      0.5  // Halved stun times.
	paralysis_mod = 0.25 // Quartered paralysis times.

	species_flags	 = SPECIES_FLAG_NO_SCAN | SPECIES_FLAG_NO_PAIN | SPECIES_FLAG_NO_POISON | SPECIES_FLAG_NO_EMBED | SPECIES_FLAG_NO_TANGLE | SPECIES_FLAG_NO_MINOR_CUT
	spawn_flags = SPECIES_IS_RESTRICTED

	traits = list(
	/singleton/trait/general/metabolically_inert = TRAIT_LEVEL_MAJOR,
	)

	blood_color = "#a10808"

	blood_color = "#05ee05"
	flesh_color = "null"
	gibbed_anim = "blank"
	dusted_anim = "blank"
	death_message = "bursts into flames and disappears."
	death_sound = 'sound/voice/hiss6.ogg'

	pixel_offset_x = 0
//	default_language = "Xenomorph"
//	language = "Hivemind"

	speech_sounds = list('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
	speech_chance = 100

	vision_flags = SEE_SELF

	genders = list(NEUTER)

	force_cultural_info = list(
		TAG_CULTURE =   CULTURE_LACTERA,
		TAG_HOMEWORLD = HOME_SYSTEM_GALACTIC_CRISIS,
		TAG_FACTION =   FACTION_GALACTIC_CRISIS,
		TAG_RELIGION =  RELIGION_UNSTATED
	)

	has_organ = list(
		BP_HEART =           /obj/item/organ/internal/heart,
		BP_BRAIN =           /obj/item/organ/internal/brain/xeno,
		BP_HIVE =       /obj/item/organ/internal/xeno/hivenode,
		BP_EYES =     /obj/item/organ/internal/eyes
		)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/lactera),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/lactera),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/lactera),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/lactera),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/lactera),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/lactera),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/lactera),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/lactera),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/lactera),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/lactera),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/lactera)
		)

/datum/species/xenos/lactera/handle_death(mob/living/carbon/human/H) //Handles any species-specific death events (such as dionaea nymph spawns).
	var/image/flicker = image('icons/uristmob/scommobs.dmi',"fire")
	flick(flicker, H)
	spawn(5)
		qdel(H)
	return

/datum/species/xenos/lactera/get_bodytype(mob/living/carbon/human/H)
	return name
