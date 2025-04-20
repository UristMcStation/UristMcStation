/singleton/species/teshari
	name = SPECIES_RESOMI
	name_plural = "Teshari"
	description = "A race of feathered raptors who developed alongside the Skrell, inhabiting \
	the polar tundral regions outside of Skrell territory. Extremely fragile, they developed \
	hunting skills that emphasized taking out their prey without themselves getting hit. They \
	are only recently becoming known on human stations after reaching space with Skrell assistance."
	min_age = 15
	max_age = 45
	health_hud_intensity = 3

	blood_color = "#d514f7"
	flesh_color = "#5f7bb0"
	base_color = "#001144"
	tail = "resomitail"
	tail_hair = "feathers"


	icobase = 'icons/mob/human_races/species/teshari/body.dmi'
	preview_icon = 'icons/mob/human_races/species/teshari/preview.dmi'
	deform = 'icons/mob/human_races/r_resomi.dmi'
	damage_overlays = 'icons/mob/human_races/masks/dam_resomi.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_resomi.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_resomi.dmi'

	darksight_range = 6
	darksight_tint = DARKTINT_GOOD
	slowdown = -0.1
	total_health = 150
	brute_mod = 1.25
	burn_mod =  1.25
	metabolism_mod = 2.0
	mob_size = MOB_SMALL
	strength = STR_HIGH
	holder_type = /obj/item/holder/human
	light_sensitive = 6
	gluttonous = GLUT_TINY
	blood_volume = 400
	hunger_factor = 0.2

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	appearance_flags = SPECIES_APPEARANCE_HAS_HAIR_COLOR | SPECIES_APPEARANCE_HAS_SKIN_COLOR | SPECIES_APPEARANCE_HAS_EYE_COLOR
	bump_flag = MONKEY
	swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags = MONKEY|SLIME|SIMPLE_ANIMAL|ALIEN

	cold_level_1 = 180
	cold_level_2 = 130
	cold_level_3 = 70
	heat_level_1 = 320
	heat_level_2 = 370
	heat_level_3 = 600
	heat_discomfort_level = 292
	heat_discomfort_strings = list(
		"Your feathers prickle in the heat.",
		"You feel uncomfortably warm.",
		)
	cold_discomfort_level = 180

	available_cultural_info = list(
		TAG_CULTURE = list(
			CULTURE_TESHARI
		),
		TAG_HOMEWORLD = list(
			HOME_SYSTEM_QERRBALAK,
			HOME_SYSTEM_OTHER
		),
		TAG_FACTION = list(
			FACTION_TESHARI_SPACEBORN,
			FACTION_TESHARI_QERRBALAK
		),
		TAG_RELIGION =  list(
			RELIGION_OTHER,
			RELIGION_ATHEISM,
			RELIGION_AGNOSTICISM
		)
	)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/teshari),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/teshari),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/teshari),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/teshari)
		)

	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_STOMACH =  /obj/item/organ/internal/stomach,
		BP_LUNGS =    /obj/item/organ/internal/lungs,
		BP_LIVER =    /obj/item/organ/internal/liver/teshari,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys/teshari,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_EYES =     /obj/item/organ/internal/eyes/teshari
		)

	unarmed_types = list(
		/datum/unarmed_attack/bite/sharp,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/stomp/weak
		)

	inherent_verbs = list(/mob/living/carbon/human/proc/sonar_ping)

	descriptors = list(
		/datum/mob_descriptor/height = -4,
		/datum/mob_descriptor/build = -4
		)
