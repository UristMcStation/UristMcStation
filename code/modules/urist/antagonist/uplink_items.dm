// Uplink Items specifically made for Urist

// Holdout Dagger/Pen Dagger

/obj/item/pen/dagger
	name = "pen"
	desc = "It's a normal black ink pen. The pen nib feels sharp to touch and is harder to click."
	icon = 'icons/obj/bureaucracy.dmi' // adjust this for urist antag gear
	icon_state = "pen" // adjust this....
	item_state = "pen"
	var/dagger = 0
	w_class = ITEM_SIZE_TINY

/obj/item/pen/dagger/attack_self(mob/user as mob)
	dagger = !dagger
	if(dagger)
		user.visible_message(SPAN_WARNING("[user] clicks their pen, revealing a sharp dagger."),\
		SPAN_WARNING("You activate the hidden dagger."),\
		"You hear a pen click.")
		force = 13 // Not as strong as a knife, but it fits in your PDA!
		sharp = TRUE
		edge = TRUE
		attack_verb = list("slashed", "stabs", "jabs", "sticks", "clips")
	else
		user.visible_message(SPAN_WARNING("[user] clicks their pen twice, concealing the dagger."),\
		SPAN_WARNING("You conceal the hidden dagger."),\
		"You hear a pen click twice.")
		force = 0 //
		sharp = FALSE
		edge = FALSE
	add_fingerprint(user)
// why the fuck does this stab instead of attack, time to codedive...

/obj/item/reagent_containers/food/drinks/bottle/uristmoonshine
	name = "Urist's Moonshine"
	desc = "A dusty looking bottle of plump helmet moonshine. It has a label stating 'URIST MCDWARFS, DO NOT TOUCH!'"
	icon = 'icons/urist/items/uristfood.dmi'
	icon_state = "uristmoonshine" // Placeholder Icon for now.
	center_of_mass = "x=16;y=8"

/obj/item/reagent_containers/food/drinks/bottle/uristmoonshine/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/uristhomebrew, 100)
	var/namepick = pick("Urist's", "Koganusan", "Armok's", "Urist McDwarf's")
	var/typepick = pick("Moonshine", "Craftdwarf Homebrew", "Vile Force of Distillery", "Forgotten Brew")
	name = "[namepick] [typepick]"

// Bluespace Shotglass.

/obj/item/reagent_containers/food/drinks/glass2/shot/bluespace
	name = "shot glass"
	desc = "A small glass, designed so that its contents can be consumed in one gulp. It looks bigger from the inside."
	base_name = "shot"
	base_icon = "shot"
	icon = 'icons/obj/drink_glasses/shot.dmi'
	filling_states = "33;66;100"
	volume = 80
	matter = list(MATERIAL_GLASS = 15)
	possible_transfer_amounts = "1;5;30"
	rim_pos = "y=17;x_left=13;x_right=21"
//	var/drinkall

// Ancient Toolbox

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


/obj/item/seeds/maneater
	name = "Maneater Seeds"
	desc = "A pack of maneater seeds. You probably don't want to be around these when they are ready."
	icon_state = "fillthis in"


// FIREARMS AND WEAPONRY
/*
// Hush-22 Special
/obj/item/weapon/gun/projectile/hush22
	item_icons = DEF_URIST_INHANDS
	name = "Hush .22 Special"
	desc = "An integrally surpressed covert pistol, chambered in .22 hollow point. The logo and identifying markers have been manually filed away."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "crewpistol" // Replace
	item_state = "crewpistol" // Replace
	w_class = 1
	caliber = "22HR"
	load_method = MAGAZINE
	origin_tech = list(TECH_COMBAT = 3, TECH_ILLEGAL = 2)
	magazine_type = /obj/item/ammo_magazine/r22lr/pistol/hollowpoint
	allowed_magazines = /obj/item/ammo_magazine/r22lr/pistol
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'

// Flare Gun
/obj/item/gun/projectile/flaregun // now all we need is a admin only hand-mortar
	name = "Flare Gun"
	desc = "A flare gun, often used to signal for rescue, or to fire directly at someone."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "crewpistol" // Replace
	item_state = "crewpistol" // Replace
	w_class = 1
	caliber = "flare"
	load_method = MAGAZINE //fix
	origin_tech = list(TECH_COMBAT = 1)
	allowed_magazines = /obj/item/ammo_magazine/r22lr/pistol //fix
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg' //fix
	one_hand_penalty = 3

*/
// MAGAZINES & AMMO

/obj/item/ammo_magazine/r22lr/pistol/hollowpoint
	name = "pistol magazine (.22HP)"
	desc = "A .22HP magazine for a pistol."
	icon = 'icons/urist/items/ammo.dmi'
	icon_state = "9mmds" // Replace
	mag_type = MAGAZINE
	ammo_type = /obj/item/projectile/bullet/r22lr
	matter = list(MATERIAL_STEEL = 900)
	caliber = "22HP"
	max_ammo = 10


/obj/item/storage/box/syndie_kit/urist_adrenaline
	startswith = list(
		/obj/item/implanter/uristadrenaline,
		/obj/item/implantpad
		)

obj/item/implant/urist_adrenaline // Adjusted adrenaline implant for Urist.    unfuck weird pathed types, fix reagent adding, etc. Need to test a decent balanced combo of chems, why didn't I play more Med?
	name = "adrenaline implant"
	desc = "A cocktail of combat stimulants for remote dispensing into the body, high risk of OD."
	hidden = 1
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 2, TECH_ESOTERIC = 2)
	var/uses = 1
	var/activation_emote
	var/list/starts_with = list()

obj/item/implant/urist_adrenaline/New()
		for(var/T in starts_with)
		reagents.add_reagent(T, starts_with[T])
		create_reagents(15)
		starts_with = list(/datum/reagent/adrenaline = 5, /datum/reagent/hyperzine = 2, /datum/reagent/coagulant = 3, /datum/reagent/tramadol = 5)
				..()
		return

/obj/item/implant/urist_adrenaline/trigger(emote, mob/living/carbon/source as mob)
	if (emote == activation_emote)
		activate()

/obj/item/implant/urist_adrenaline/activate()
	if (uses < 1 || malfunction || !imp_in)	return 0
	uses--
	to_chat(imp_in, SPAN_NOTICE("You feel an intense surge of energy!"))
	reagents.trans_to_mob(R, amount, CHEM_BLOOD)

/obj/item/implanter/uristadrenaline
	name = "implanter (A)"
	imp = /obj/item/implant/urist_adrenaline

/obj/item/implantcase/uristadrenaline
	name = "glass case - 'adrenaline'"
	imp = /obj/item/implant/urist_adrenaline
