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
