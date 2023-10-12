// Uplink Items specifically made for Urist

// Holdout Dagger/Pen Dagger
/*
/obj/item/pen/dagger
	desc = "It's a normal black ink pen, the nib feels sharp to touch and is harder to click."
	origin_tech = TECH_COMBAT = 1
	var/dagger = FALSE
	w_class = ITEM_SIZE_TINY


*/
// Urist's Homebrew.

/obj/item/reagent_containers/food/drinks/bottle/uristmoonshine
	name = "Urist's Moonshine"
	desc = "A dusty looking bottle of plump helmet moonshine. It has a label stating 'URIST MCDWARFS, DO NOT TOUCH!'"
//	icon_state = "moonshine"
//	center_of_mass = "x=16;y=6"

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

// Greytide Toolbox

/obj/item/storage/toolbox/greytide				// It would be funny if going bald would increase the damage even more... perhaps i should add that, truely we are not bay
	name = "Ancient Toolbox"
	desc = "An ancient dusty red toolbox. It looks very robust. Only a true greytider could use this."
//	icon_state = "fillthisin"
//	icon_state = "red"
//	item_state = "toolbox_red"
	force = 30
	attack_cooldown = 10
	melee_accuracy_bonus = 0
	base_parry_chance = 35
	w_class = ITEM_SIZE_LARGE
	attack_verb = list("robusts", "robusted", "greytides", "bludgeoned") // shitter tech
	use_sound = 'sound/effects/storage/toolbox.ogg'
	matter = list(MATTER_STEEL = 10000)

/obj/item/seeds/maneater
	name = "Maneater Seeds"
	desc = "A pack of maneater seeds. You probably don't want to be around these when they are ready."
	icon_state = "fillthis in"

// New MIU
/obj/item/device/augment_implanter/miu // Changes MIU to a non-obvious mask version.
	name = "Concealed MIU CBM (Eyes)"
	desc = "A CBM that allows you to remotely connect to nearby camera networks for easy access. This implant is undetectable \
	to bodyscanning. Accessing the camera network will require you to roll your eyes up, which will look off-putting to your \
	fellow crew."

// FIREARMS AND WEAPONRY

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

// Tranq Pistol (Like the energy crossbow, but not)
/obj/item/gun/projectile/tranq
	name = "Tranq Pistol"
	desc = "A tranq pistol, commonly used to sedate animals."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "crewpistol" // Replace
	item_state = "crewpistol" // Replace
	w_class = 1
	caliber = "tranq"
	load_method = MAGAZINE
	origin_tech = list(TECH_COMBAT = 1)
	allowed_magazines = /obj/item/ammo_magazine/r22lr/pistol // fix
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg' // fix
	one_hand_penalty = 3 // fix


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

/obj/item/ammo_magazine/r22lr/pistol/hollowpoint
	name = "tranq magazine"
	desc = "A tranq magazine for a tranquilizer pistol."
	icon = 'icons/urist/items/ammo.dmi'
	icon_state = "9mmds" // Replace
	mag_type = MAGAZINE
	ammo_type = /obj/item/projectile/bullet/r22lr
	matter = list(MATERIAL_STEEL = 1200)
	caliber = "tranq"
	max_ammo = 5



/*
// Urist Specific Version of Adrenaline, remove the bay shit below soon
/obj/item/implant/adrenalin
	name = "adrenalin implant"
	desc = "Removes all stuns and knockdowns."
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 2, TECH_ESOTERIC = 2)
	hidden = 1
	var/uses

/obj/item/implant/adrenalin/trigger(emote, mob/source)
	if (emote == "pale")
		activate()

/obj/item/implant/adrenalin/activate()
	if (uses < 1 || malfunction || !imp_in)	return 0
	uses--
	to_chat(imp_in, SPAN_NOTICE("You feel a sudden surge of energy!"))
	imp_in.SetStunned(0)
	imp_in.SetWeakened(0)
	imp_in.SetParalysis(0)

/obj/item/implant/adrenalin/implanted(mob/source)
	source.StoreMemory("A implant can be activated by using the pale emote, <B>say *pale</B> to attempt to activate.", /singleton/memory_options/system)
	to_chat(source, "The implanted freedom implant can be activated by using the pale emote, <B>say *pale</B> to attempt to activate.")
	return TRUE

/obj/item/implanter/adrenalin
	name = "implanter-adrenalin"
	imp = /obj/item/implant/adrenalin

/obj/item/implantcase/adrenalin
	name = "glass case - 'adrenalin'"
	imp = /obj/item/implant/adrenalin

*/
