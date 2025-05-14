/* Urist - United States - Vietnam War /////
Contents:
	Firearms
	Firearm Magazines
	Explosives
	Clothing
*/

// United States - Firearms

// Firearms - Rifles & Semi-Automatic

/obj/item/gun/projectile/automatic/m16
	item_icons = DEF_URIST_INHANDS
	name = "\improper M16 Assault Rifle"
	desc = "25 rounds of 5.56mm. Staple rifle for the Nanotrasen Servicemen. A 2557AD spin on the classic rifle."
	icon = 'icons/urist/guns/vietnam_us.dmi'
	icon_state = "M16"
	item_state = "arifle"
	w_class = 4
	force = 10
	caliber = CALIBER_RIFLE_MILITARY
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ESOTERIC = 4)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	allowed_magazines = /obj/item/ammo_magazine/rifle/m16
	magazine_type = /obj/item/ammo_magazine/rifle/m16
	ammo_type = /obj/item/ammo_casing/rifle/military
	one_hand_penalty = 4
	fire_sound = 'sound/weapons/gunshot/gunshot2.ogg'
	wielded_item_state = "genericrifle-wielded"

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, one_hand_penalty = 4, move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, move_delay=6, fire_delay=null, one_hand_penalty = 5, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.0, 0.6, 0.6)),
		list(mode_name="short bursts", 	burst=5, move_delay=6, fire_delay=null, one_hand_penalty = 6, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/projectile/automatic/m16/on_update_icon()
	..()
	if(icon_state == "M16-GL")
		icon_state = (ammo_magazine)? "M16-GL" : "M16-GL-empty"
	else
		icon_state = (ammo_magazine)? "M16" : "M16-empty"

/obj/item/gun/projectile/automatic/m16/gl
	name = "\improper M16-GL Assault Rifle"
	desc = "25 rounds of 5.56mm. Staple rifle for the Nanotrasen Servicemen. A 2557AD spin on the classic rifle, complete with underslung grenade launcher."
	icon_state = "M16-GL"
	var/use_launcher = null

	firemodes = list(
		list(mode_name="semiauto", burst=1, use_launcher=null, fire_delay=0, one_hand_penalty = 4, move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, use_launcher=null, move_delay=6, fire_delay=null, one_hand_penalty = 5, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.0, 0.6, 0.6)),
		list(mode_name="short bursts", burst=5, use_launcher=null, move_delay=6, fire_delay=null, one_hand_penalty = 6, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="fire grenades", burst=null, fire_delay=null, move_delay=null, use_launcher=1,  burst_accuracy=null, dispersion=null)
		)

	var/obj/item/gun/launcher/grenade/underslung/launcher

/obj/item/gun/projectile/automatic/m16/gl/New()
	..()
	launcher = new(src)

/obj/item/gun/projectile/automatic/m16/gl/use_tool(obj/item/I, mob/living/user, list/click_params)
	if((istype(I, /obj/item/grenade)))
		launcher.load(I, user)
	else
		..()

/obj/item/gun/projectile/automatic/m16/gl/attack_hand(mob/user)
	if(user.get_inactive_hand() == src && src.use_launcher)
		launcher.unload(user)
	else
		..()

/obj/item/gun/projectile/automatic/m16/gl/Fire(atom/target, mob/living/user, params, pointblank=0, reflex=0, dual_wield=0)
	if(src.use_launcher)
		launcher.Fire(target, user, params, pointblank, reflex)
		if(!launcher.chambered)
			switch_firemodes() //switch back automatically
	else
		..()

/obj/item/gun/projectile/automatic/m16/gl/examine(mob/user)
	..()
	if(launcher.chambered)
		to_chat(user, "\The [launcher] has \a [launcher.chambered] loaded.")
	else
		to_chat(user, "\The [launcher] is empty.")


/obj/item/gun/projectile/automatic/m14

	name = "\improper M14 Rifle"
	desc = "A selective-fire rifle for when you need more stopping power. Has a 15-round magazine of 7.62mm. Unlike the M16s that have the ability to fire in bursts or semi-auto, the M14 can only fire in either long bursts or semi-auto."
	icon = 'icons/urist/guns/vietnam_us.dmi'
	icon_state = "M14"
	item_state = "woodarifle-wielded"
	wielded_item_state = "woodarifle-wielded"
	item_icons = DEF_URIST_INHANDS
	w_class = ITEM_SIZE_LARGE
	slot_flags = SLOT_BACK
	caliber = CALIBER_RIFLE_MILITARY
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ESOTERIC = 2) // nam tech crazy...
	magazine_type = /obj/item/ammo_magazine/rifle/military/m14
	allowed_magazines = /obj/item/ammo_magazine/rifle/military/m14
	ammo_type = /obj/item/ammo_casing/rifle/military
	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'
	load_method = MAGAZINE
	one_hand_penalty = 4
	force = 10
	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, one_hand_penalty = 4, move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="long bursts",	burst=8, fire_delay=null, move_delay=8, one_hand_penalty = 3, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/projectile/automatic/m14/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "M14"
	else
		icon_state = "M14-empty"
	return

// Firearms - Machineguns

/obj/item/gun/projectile/automatic/l6_saw/m60
	item_icons = DEF_URIST_INHANDS
	name = "M60 Machinegun"
	desc = "The general-purpose machinegun and the main firearm for the Machinegunner. Chambered in 7.62mm , it is fed through a 75-round belt. Fires in short and long bursts, perfect for support and suppresive fire."
	icon = 'icons/urist/guns/vietnam_us.dmi'
	icon_state = "M60closed75"
	item_state = "genericLMG-wielded"
	max_shells = 75
	allowed_magazines = list(/obj/item/ammo_magazine/box/rifle/military/m60)
	magazine_type = /obj/item/ammo_magazine/box/rifle/military/m60
	ammo_type = /obj/item/ammo_casing/rifle/military
	one_hand_penalty = 6
	wielded_item_state = "genericLMG-wielded"
	caliber = CALIBER_RIFLE_MILITARY

/obj/item/gun/projectile/automatic/l6_saw/m60/on_update_icon()
	icon_state = "M60[cover_open ? "open" : "closed"][ammo_magazine ? round(length(ammo_magazine.stored_ammo), 15) : "-empty"]"

// Firearms - Grenade Launcher

/obj/item/gun/launcher/grenade/m79
	item_icons = DEF_URIST_INHANDS
	name = "M79 Grenade Launcher"
	desc = "The M79 Grenade Launcher is a single-shot break action launcher, capable of firing a multitude of grenades. It's iconic sound has given it the nickname 'Bloop Tube'"
	wielded_item_state = ""
	icon_state = ""
	item_state = ""
	w_class = ITEM_SIZE_LARGE
	one_hand_penalty = 3
	force = 5
	slot_flags = SLOT_BACK

// Firearms - Sniper Rifles

/obj/item/gun/projectile/manualcycle/m40
	item_icons = DEF_URIST_INHANDS
	name = "M40 rifle"
	desc = "A bolt-action sniper rifle with an aged wooden stock. Chambered in 7.62mm. It has a magnifying scope to assist in hitting far away targets."
	wielded_item_state = "huntrifle2"
	icon_state = "huntrifle"
	item_state = "huntrifle"
	w_class = ITEM_SIZE_LARGE
	one_hand_penalty = 5
	force = 10
	slot_flags = SLOT_BACK
	caliber = CALIBER_RIFLE
	handle_casings = HOLD_CASINGS
	max_shells = 5
	ammo_type = obj/item/ammo_casing/rifle
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	accuracy_power = 6
	screen_shake = 1

// Firearms - Shotguns

/obj/item/gun/projectile/shotgun/pump/combat/ithaca
	name = "Ithaca 37 combat shotgun"
	desc = "A modernized Ithaca 37 pump-action shotgun, bearing a NT Logo. Capable of loading 7+1 of .12 Gauge. Perfect for clearing tight corridors, or tunnels."
	icon = 'icons/urist/guns/pump_shotgun.dmi'
	icon_state = "ithaca"


// Firearms Magazines -

// Firearms - Automatic Rifles

/obj/item/ammo_magazine/rifle/m16
	name = "M16 magazine"
	icon = 'icons/urist/guns/ammo_vietnam.dmi'
	caliber = CALIBER_RIFLE_MILITARY
	ammo_type = /obj/item/ammo_casing/rifle/military
	icon_state = "M16MAG"
	max_ammo = 25

/obj/item/ammo_magazine/rifle/m16/empty
	initial_ammo = 0

// Firearms - Machineguns

/obj/item/ammo_magazine/box/rifle/military/m60
	name = "M60 magazine box"
	icon = 'icons/urist/guns/ammo_vietnam.dmi'
	icon_state = "M60MAG"
	caliber = CALIBER_RIFLE_MILITARY
	max_ammo = 75
	multiple_sprites = 0

/obj/item/ammo_magazine/box/rifle/military/m60/empty
	initial_ammo = 0

// Firearms - Semi-Automatic

/obj/item/ammo_magazine/rifle/military/m14
	name = "M14 magazine box"
	icon = 'icons/urist/guns/ammo_vietnam.dmi'
	caliber = CALIBER_RIFLE_MILITARY
	icon_state = "M14MAG"
	max_ammo = 15

/obj/item/ammo_magazine/rifle/military/m14/empty
	initial_ammo = 0

// Vietnam - United States - Clothing

// Under

/obj/item/clothing/under/urist/nam
	name = "jungle camo BDU"
	desc = "A BDU styled with jungle camouflage."
	icon_state = "namjumpsuit"
	item_state = "namjumpsuit"

// Suits

/obj/item/clothing/suit/urist/armor/nam
	name = "jungle camo flak jacket"
	desc = "A flak jacket styled with jungle camouflage."
	icon_state = "namflakjacket"
	item_state = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 40, bomb = 20, bio = 0, rad = 0)

// Head

/obj/item/clothing/head/helmet/urist/nam
	name = "jungle camo helmet"
	desc = "A helmet styled with jungle camouflage."
	icon_state = "namhelm"
	item_state = "namhelm"

/obj/item/clothing/head/helmet/urist/nam/officer
	name = "jungle camo officer's helmet"
	desc = "An officer's helmet styled with jungle camouflage."
	icon_state = "officerhelm"
	item_state = "officerhelm"

// Boots

/obj/item/clothing/shoes/urist/nam
	name = "jungle camo boots"
	desc = "A pair of boots styled with jungle camouflage."
	icon_state = "namboots"
	item_state = "namboots"
	permeability_coefficient = 0.05
	item_flags = ITEM_FLAG_NOSLIP
	species_restricted = null
	siemens_coefficient = 0.6
	armor = list(melee = 50, bullet = 0, laser = 5,energy = 0, bomb = 5, bio = 10, rad = 0)
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

// Gloves

/obj/item/clothing/gloves/urist/nam
	name = "jungle camo gloves"
	desc = "A pair of gloves styled with jungle camouflage."
	icon_state = "namgloves"
	item_state = "namgloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 15, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

// Storage

/obj/item/storage/backpack/urist/nam
	name = "jungle camo backpack"
	desc = "A backpack styled with jungle camouflage."
	icon_state = "nambackpack"
	item_state = "nambackpack"

// Belts

/obj/item/storage/belt/holster/urist/nam
	name = "jungle camo belt"
	desc = "A belt with a holster, styled with jungle camouflage. Can hold a plethora of security & general gear, as well as a pistol."
	icon_state = "nambelt"
	item_state = "nambelt"
	overlay_flags = BELT_OVERLAY_ITEMS |BELT_OVERLAY_HOLSTER
	storage_slots = 7
	contents_allowed = list(
		/obj/item/crowbar,
		/obj/item/grenade,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/handcuffs,
		/obj/item/device/flash,
		/obj/item/clothing/glasses,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_magazine,
		/obj/item/reagent_containers/food/snacks/donut,
		/obj/item/melee/baton,
		/obj/item/melee/telebaton,
		/obj/item/gun/energy/taser,
		/obj/item/flame/lighter,
		/obj/item/clothing/glasses/hud/security,
		/obj/item/device/flashlight,
		/obj/item/modular_computer/pda,
		/obj/item/device/radio/headset,
		/obj/item/modular_computer/tablet,
		/obj/item/modular_computer/pda,
		/obj/item/device/hailer,
		/obj/item/device/megaphone,
		/obj/item/melee,
		/obj/item/taperoll,
		/obj/item/device/holowarrant,
		/obj/item/magnetic_ammo,
		/obj/item/device/binoculars,
		/obj/item/clothing/gloves,
		/obj/item/clothing/head/beret,
		/obj/item/material/knife/folding
		)
