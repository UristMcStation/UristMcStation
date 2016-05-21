/mob/living/carbon/human/lactera/New(var/new_loc)
	h_style = "Bald"
	..(new_loc, "Lactera")

/mob/living/carbon/human/lactera/bullet_act(var/obj/item/projectile/Proj)
	Proj.embed = 0

	..()

/obj/item/organ/external/chest/lactera
	cannot_break = 1
	dislocated = -1
	cannot_amputate = 1

/obj/item/organ/external/groin/lactera
	cannot_break = 1
	dislocated = -1
	cannot_amputate = 1

/obj/item/organ/external/arm/lactera
	cannot_break = 1
	dislocated = -1
	cannot_amputate = 1

/obj/item/organ/external/arm/right/lactera
	cannot_break = 1
	dislocated = -1
	cannot_amputate = 1

/obj/item/organ/external/leg/lactera
	cannot_break = 1
	dislocated = -1
	cannot_amputate = 1

/obj/item/organ/external/leg/right/lactera
	cannot_break = 1
	dislocated = -1
	cannot_amputate = 1

/obj/item/organ/external/foot/lactera
	cannot_break = 1
	dislocated = -1
	cannot_amputate = 1

/obj/item/organ/external/foot/right/lactera
	cannot_break = 1
	dislocated = -1
	cannot_amputate = 1

/obj/item/organ/external/hand/lactera
	cannot_break = 1
	dislocated = -1
	cannot_amputate = 1

/obj/item/organ/external/hand/right/lactera
	cannot_break = 1
	dislocated = -1
	cannot_amputate = 1

/obj/item/organ/external/head/lactera
	cannot_break = 1
	dislocated = -1
//	cannot_amputate = 1

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

	icobase = 'icons/uristmob/r_lactera.dmi'

	unarmed_types = list(/datum/unarmed_attack/claws)
	hud_type = null

	has_fine_manipulation = 1
	gluttonous = 1

	eyes = "blank_eyes"

	brute_mod = 1.5
	burn_mod = 1

	flags = IS_RESTRICTED | NO_BREATHE | NO_SCAN | NO_PAIN | NO_POISON

	reagent_tag = IS_XENOS

	blood_color = "#05EE05"
	flesh_color = "null"
	gibbed_anim = "blank"
	dusted_anim = "blank"
	death_message = "bursts into flames and disappears."
	death_sound = 'sound/voice/hiss6.ogg'

	speech_sounds = list('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
	speech_chance = 100

	vision_flags = SEE_SELF

	has_organ = list(
		"heart" =           /obj/item/organ/heart,
		"brain" =           /obj/item/organ/brain/xeno,
		"hive node" =       /obj/item/organ/xenos/hivenode,
		)

	caste_name = "lactera" // Used to update alien name.

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/lactera),
		"groin" =  list("path" = /obj/item/organ/external/groin/lactera),
		"head" =   list("path" = /obj/item/organ/external/head/lactera),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/lactera),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/lactera),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/lactera),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/lactera),
		"l_hand" = list("path" = /obj/item/organ/external/hand/lactera),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/lactera),
		"l_foot" = list("path" = /obj/item/organ/external/foot/lactera),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/lactera)
		)

/datum/species/xenos/lactera/handle_death(var/mob/living/carbon/human/H) //Handles any species-specific death events (such as dionaea nymph spawns).
	var/image/flicker = image('icons/uristmob/scommobs.dmi',"fire")
	flick(flicker, H)
	sleep(5)
	qdel(H)
	return