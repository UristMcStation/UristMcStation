//we're using pre-existing stuff for the most part, but here's some stuff to complete the three tiers

/obj/item/gun/energy/sniperrifle/pulse
	item_icons = DEF_URIST_INHANDS
	name = "\improper pulse sniper rifle"
	desc = "A pulse rifle constructed of lightweight materials, fitted with a SMART aiming-system scope."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "psniper"
	item_state = "psniper"
	fire_sound = 'sound/weapons/marauder.ogg'
	projectile_type = /obj/item/projectile/beam/sniper/pulse
	slot_flags = SLOT_BACK
	charge_cost = 250
	fire_delay = 35
	w_class = 3.0
	one_hand_penalty = 8

/obj/item/gun/energy/pulse_rifle/pistol
	item_icons = DEF_URIST_INHANDS
	name = "pulse pistol"
	desc = "A heavy-duty, pulse-based energy pistol, preferred as a sidearm by front-line combat personnel."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "pulse_pistol"
	item_state = "pulse_pistol"
	force = 7
	fire_sound = 'sound/weapons/pulse.ogg'
	charge_cost = 150
	projectile_type = /obj/item/projectile/beam/pulse/light
	cell_type = /obj/item/cell/super
	w_class = 2.0

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, fire_sound='sound/weapons/Taser.ogg', fire_delay=null, charge_cost=null),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam/light, fire_sound='sound/weapons/Laser.ogg', fire_delay=null, charge_cost=null),
		list(mode_name="DESTROY", projectile_type=/obj/item/projectile/beam/pulse/light, fire_sound='sound/weapons/pulse.ogg', fire_delay=25, charge_cost=400),
		)


/obj/item/gun/energy/pulse_rifle/cannon
	item_icons = DEF_URIST_INHANDS
	name = "pulse cannon"
	desc = "A heavy-duty, pulse-based energy cannon, preferred by front-line heavy infantry."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "pulse_cannon"
	item_state = "pulse_cannon"
	force = 12
	fire_sound = 'sound/weapons/marauder.ogg'
	charge_cost = 250
	projectile_type = /obj/item/projectile/beam/pulse/heavy/h2
	cell_type = /obj/item/cell/super
	w_class = 4.0
	one_hand_penalty = 8

/obj/item/gun/energy/pulse_rifle/cannon/attack_self(mob/living/user as mob)
	to_chat(user, "<span class='warning'>[src.name] only has one setting.</span>")

/obj/item/gun/energy/laser/pistol
	item_icons = DEF_URIST_INHANDS
	name = "laser pistol"
	desc = "A basic pistol designed to kill with concentrated energy bolts."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "lpistol"
	item_state = "lpistol"
	w_class = 2.0
	projectile_type = /obj/item/projectile/beam/light

/obj/item/gun/energy/laser/rifle
	item_icons = DEF_URIST_INHANDS
	name = "laser rifle"
	desc = "A basic weapon designed to kill with concentrated energy bolts."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "lrifle"
	item_state = "lrifle"
	w_class = 3.0
	projectile_type = /obj/item/projectile/beam //maybe change this
	one_hand_penalty = 4

/obj/item/gun/projectile/svd
	item_icons = DEF_URIST_INHANDS
	name = "semi automatic sniper"
	desc = "A powerful semi automatic sniper, perfect for long-range warfare."
	icon_state = "SVD"
	item_state = "SVD"
	icon = 'icons/urist/items/guns.dmi'
	force = 10
	caliber = CALIBER_RIFLE_MILITARY
	ammo_type = /obj/item/ammo_casing/rifle/military/sniper
	magazine_type = /obj/item/ammo_magazine/rifle/military/sniper
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	zoomdevicename = "scope"
	scommoney = 100
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	accuracy = -3 //shooting at the hip
	handle_casings = EJECT_CASINGS
	one_hand_penalty = 8
	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'
	wielded_item_state = "woodarifle-wielded"
	scoped_accuracy = 4 //increased accuracy over the LWAP because only one shot
	scope_zoom = 2

/obj/item/gun/projectile/svd/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "SVD"
	else
		icon_state = "SVD-empty"

/obj/item/ammo_magazine/rifle/military
	name = "rifle magazine"
	icon_state = "7.62mm"
	icon = 'icons/urist/items/guns.dmi'
	origin_tech = "combat=2"
	ammo_type = /obj/item/ammo_casing/rifle/military
	mag_type = MAGAZINE
	caliber = CALIBER_RIFLE_MILITARY

/obj/item/ammo_magazine/rifle/military/sniper
	name = "ten-round rifle magazine"
	ammo_type = /obj/item/ammo_casing/rifle/military
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/rifle/military/sniper/empty
	initial_ammo = 0

/obj/item/ammo_casing/rifle/military/sniper
	desc = "A military rifle bullet casing."
	caliber = CALIBER_RIFLE_MILITARY
	projectile_type = /obj/item/projectile/bullet/rifle/sniper

/obj/item/projectile/bullet/rifle/sniper
	damage = 35
	hitscan = 1

/obj/item/projectile/beam/sniper/pulse
	icon_state = "u_laser"
	damage = 70
	muzzle_type = /obj/projectile/laser/pulse/muzzle
	tracer_type = /obj/projectile/laser/pulse/tracer
	impact_type = /obj/projectile/laser/pulse/impact

/obj/item/projectile/beam/pulse/heavy/h2
	damage = 70

/obj/item/projectile/beam/light
	damage = 30

/obj/item/projectile/beam/pulse/light
	damage = 40

//ammo

/obj/item/storage/box/c20ammo
	name = "box of smg ammo"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."

/obj/item/storage/box/c20ammo/New()
	..()
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)

/obj/item/storage/box/sniperammo
	name = "box of sniper ammo"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."

/obj/item/storage/box/sniperammo/New()
	..()
	new /obj/item/ammo_magazine/rifle/military(src)
	new /obj/item/ammo_magazine/rifle/military(src)
	new /obj/item/ammo_magazine/rifle/military(src)

/obj/item/storage/box/large/lmgammo
	name = "box of l6 saw ammo"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."

/obj/item/storage/box/large/lmgammo/New()
	..()
	new /obj/item/ammo_magazine/box/rifle/military(src)
	new /obj/item/ammo_magazine/box/rifle/military(src)
	new /obj/item/ammo_magazine/box/rifle/military(src)

/obj/item/storage/box/knightammo
	name = "box of Knight ammo"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."

/obj/item/storage/box/knightammo/New()
	..()
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)

//armour (first heavy tier and first medic tier. possibly 2nd/3rd sniper tier.

/obj/item/rig/ert/medical/scom
	name = "Combat Medic suit control module"
	desc = "A suit worn by the medical division of a NanoTrasen Emergency Response Team. Has white highlights. Armoured and space ready."
	suit_type = "ERT medic"
	icon_state = "ert_medical_rig"

	req_access = null

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/chem_dispenser/injector
		)

/obj/item/rig/ert/security/scom
	name = "Assault suit control module"
	desc = "A suit worn by the security division of a NanoTrasen Emergency Response Team. Has red highlights. Armoured and space ready."
	suit_type = "ERT security"
	icon_state = "ert_security_rig"

	req_access = null

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/energy/egun,
		)

/obj/item/rig/ert/scomlead
	req_access = null
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/mounted/energy/egun,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/mounted/energy/energy_blade
		)

/obj/item/clothing/suit/urist/armor
	name = "armor"
	desc = "An armored vest that protects against some damage."
	//flags =
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/urist/armor/heavy
	icon_state = "heavyscom"

/obj/item/clothing/suit/urist/armor/medic
	icon_state = "ltvest"

/obj/item/rig/scomsniper
	name = "cybersuit control module"
	suit_type = "cyber"
	desc = "An advanced powered armour suit with many cyberwarfare enhancements."
	icon_state = "hacker_rig"

	helm_type = /obj/item/clothing/head/lightrig
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 30)
	initial_modules = list(
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/stealth_field,
		/obj/item/rig_module/mounted/energy/energy_blade,
		/obj/item/rig_module/mounted/energy/egun
		)

	allowed = list(/obj/item/storage/backpack,/obj/item/device/flashlight, /obj/item/tank, /obj/item/device/t_scanner, /obj/item/rcd, /obj/item/crowbar, \
	/obj/item/screwdriver, /obj/item/weldingtool, /obj/item/wirecutters, /obj/item/wrench, /obj/item/device/multitool, \
	/obj/item/device/radio, /obj/item/device/scanner/gas, /obj/item/gun/energy/laser, /obj/item/gun/energy/pulse_rifle, \
	/obj/item/gun/energy/taser, /obj/item/melee/baton, /obj/item/gun, /obj/item/storage/firstaid, /obj/item/reagent_containers/hypospray, /obj/structure/roller_bed)


/obj/item/rig/light/scomsniper
	name = "stealth suit control module"
	suit_type = "stealth"
	desc = "A highly advanced and expensive suit designed for covert operations."
	icon_state = "ninja_rig"

	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 30)
	initial_modules = list(
		/obj/item/rig_module/mounted/energy/energy_blade,
		/obj/item/rig_module/stealth_field
		)

/obj/item/clothing/under/urist/scom
	name = "S-COM operative's outfit"
	desc = "The outfit of an S-COM Operative."
	icon_state = "scom"
	//item_color = "scom"
	canremove = 1

/obj/item/clothing/under/urist/scom/s1
	name = "S-COM Squad 1 outfit"
	desc = "The outfit of an S-COM Operative from Squad 1."
	icon_state = "scom1"
	//item_color = "scom1"

/obj/item/clothing/under/urist/scom/s2
	name = "S-COM Squad 2 outfit"
	desc = "The outfit of an S-COM Operative from Squad 2."
	icon_state = "scom2"
	//item_color = "scom2"

/obj/item/clothing/under/urist/scom/s3
	name = "S-COM Squad 3 outfit"
	desc = "The outfit of an S-COM Operative from Squad 3."
	icon_state = "scom3"
	//item_color = "scom3"

/obj/item/clothing/under/urist/scom/s4
	name = "S-COM Squad 4 outfit"
	desc = "The outfit of an S-COM Operative from Squad 4."
	icon_state = "scom4"
	//item_color = "scom4"

/obj/item/clothing/under/urist/scom/s1l
	name = "S-COM Squad 1 Leader outfit"
	desc = "The outfit of an S-COM Squad 1 Leader."
	icon_state = "scom1l"
	//item_color = "scom1l"

/obj/item/clothing/under/urist/scom/s2l
	name = "S-COM Squad 2 Leader outfit"
	desc = "The outfit of an S-COM Squad 2 Leader."
	icon_state = "scom2l"
	//item_color = "scom2l"

/obj/item/clothing/under/urist/scom/s3l
	name = "S-COM Squad 3 Leader outfit"
	desc = "The outfit of an S-COM Squad 3 Leader."
	icon_state = "scom3l"
	//item_color = "scom3l"

/obj/item/clothing/under/urist/scom/s4l
	name = "S-COM Squad 4 Leader outfit"
	desc = "The outfit of an S-COM Squad 4 Leader."
	icon_state = "scom4l"
	//item_color = "scom4l"

#undef RANK_SUPPORT
#undef RANK_SOLDIER
#undef RANK_OFFICER
#undef RANK_COMMAND
