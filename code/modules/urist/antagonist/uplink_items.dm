// For Urist Specific Antagonist Items. - Y


/obj/item/storage/toolbox/ancienttoolbox // A slightly more damaging toolbox, for advanced shitter tech.
	name = "toolbox"
	desc = "Bright red toolboxes like these are one of the most common sights in maintenance corridors on virtually every ship in the galaxy. This one has had it's edges sharpened, you feel more robust looking at it."
	icon_state = "red"
	item_state = "toolbox_red"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 30
	attack_cooldown = 14
	melee_accuracy_bonus = 0
	base_parry_chance = 25 // Robust...
	w_class = ITEM_SIZE_LARGE
	attack_verb = list("robusts", "robusted", "greytides", "bludgeoned") // shitter tech
	use_sound = 'sound/effects/storage/toolbox.ogg'

/obj/item/reagent_containers/food/drinks/bottle/uristmoonshine
	name = "Urist's Moonshine"
	desc = "A dusty looking bottle of plump helmet moonshine. It has a label stating 'URIST MCDWARFS, DO NOT TOUCH!'"
	icon = 'icons/urist/items/uristfood.dmi'
	icon_state = "uristmoonshine"
	center_of_mass = "x=16;y=8"

/obj/item/reagent_containers/food/drinks/bottle/uristmoonshine/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/uristhomebrew, 100)
	var/namepick = pick("Urist's", "Koganusan", "Armok's", "Urist McDwarf's")
	var/typepick = pick("Moonshine", "Craftdwarf Homebrew", "Vile Force of Distillery", "Forgotten Brew")
	name = "[namepick] [typepick]"

// Augments

/obj/item/organ/internal/augment/active/polytool/surgical/syndicate // An upgraded surgical toolset capable of Organic + Synthetic repairs.
	name = "advanced surgical toolset"
	action_button_name = "Deploy Surgical Tool"
	desc = "A highly advanced surgical toolset common among frontline medics, this device contains an entire surgical suite of tools for organic and synthetic repair."
	icon_state = "multitool_medical"
	augment_flags = AUGMENT_MECHANICAL | AUGMENT_BIOLOGICAL | AUGMENT_INSPECTABLE | AUGMENT_SCANNABLE
	paths = list(
		/obj/item/bonesetter,
		/obj/item/cautery,
		/obj/item/circular_saw,
		/obj/item/hemostat,
		/obj/item/retractor,
		/obj/item/scalpel/laser,
		/obj/item/surgicaldrill,
		/obj/item/bonegel,
		/obj/item/FixOVein,
		/obj/item/device/robotanalyzer,
		/obj/item/stack/medical/advanced/bruise_pack
	// No Nanopaste, but otherwise it's a pretty good deal.
	)

/obj/item/organ/internal/augment/active/polytool/engineer/syndicate
	name = "covert engineering toolset"
	desc = "A lightweight augmentation for the engineer on-the-go, designed with covert operations in mind this is compatible with both synthetic and organ limbs."
	augment_flags = AUGMENT_MECHANICAL | AUGMENT_BIOLOGICAL | AUGMENT_SCANNABLE

// CBMs

/obj/item/device/augment_implanter/engineering_toolset_syndicate
	augment = /obj/item/organ/internal/augment/active/polytool/engineer/syndicate

/obj/item/device/augment_implanter/surgical_toolset_syndicate
	augment = /obj/item/organ/internal/augment/active/polytool/surgical/syndicate
