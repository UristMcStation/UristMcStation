//we're using pre-existing stuff for the most part, but here's some stuff to complete the three tiers

/obj/item/weapon/gun/energy/sniperrifle/pulse
	name = "\improper pulse sniper rifle"
	desc = "A pulse rifle constructed of lightweight materials, fitted with a SMART aiming-system scope."
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "gun" //temp
	fire_sound = 'sound/weapons/marauder.ogg'
	origin_tech = "combat=6;materials=5;powerstorage=4"
	projectile_type = /obj/item/projectile/beam/sniper/pulse
	slot_flags = SLOT_BACK
	charge_cost = 250
	fire_delay = 35
	w_class = 3.0

/obj/item/weapon/gun/energy/pulse_rifle/pistol
	name = "pulse rifle"
	desc = "A heavy-duty, pulse-based energy pistol, preferred as a sidearm by front-line combat personnel."
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "pulsepist"
	item_state = "gun"	//temp
	force = 7
	fire_sound = 'sound/weapons/pulse.ogg'
	charge_cost = 150
	projectile_type = /obj/item/projectile/beam/pulse/light
	cell_type = "/obj/item/weapon/cell/super"
	w_class = 2.0

/obj/item/weapon/gun/energy/pulse_rifle/cannon
	name = "pulse rifle"
	desc = "A heavy-duty, pulse-based energy cannon, preferred by front-line heavy infantry."
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "pulsecannon"
	item_state = "gun"	//temp
	force = 12
	fire_sound = 'sound/weapons/marauder.ogg'
	charge_cost = 250
	projectile_type = /obj/item/projectile/beam/pulse/heavy/h2
	cell_type = "/obj/item/weapon/cell/super"
	w_class = 4.0

/obj/item/weapon/gun/energy/laser/pistol
	name = "laser carbine"
	desc = "A basic pistol designed to kill with concentrated energy bolts."
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "laser"
	item_state = "gun" //temp
	w_class = 2.0
	projectile_type = /obj/item/projectile/beam/light

/obj/item/weapon/gun/energy/laser/rifle
	name = "laser rifle"
	desc = "A basic weapon designed to kill with concentrated energy bolts."
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "lrifle"
	item_state = "laser" //temp
	w_class = 3.0
	projectile_type = /obj/item/projectile/beam //maybe change this

/obj/item/weapon/gun/projectile/sniper
	urist_only = 1
	name = "semi automatic sniper"
	desc = "A power semi automatic sniper, perfect for long-range warfare."
	icon_state = "SVD"
	item_state = "SVD"
	icon = 'icons/urist/items/uristweapons.dmi'
	force = 14
	max_shells = 10
	caliber = "7.62mm"
	ammo_type ="/obj/item/ammo_casing/a762mm"
	load_method = 2
	zoomdevicename = "scope"
	scommoney = 100

	New()
		..()
		empty_mag = new /obj/item/ammo_magazine/a50/empty(src)
		update_icon()
		return


	afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
		..()
		if(!loaded.len && empty_mag)
			empty_mag.loc = get_turf(src.loc)
			empty_mag = null
			playsound(user, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
			update_icon()
		return

/obj/item/weapon/gun/projectile/sniper/update_icon()
	..()
	if(empty_mag)
		icon_state = "SVD"
	else
		icon_state = "SVD-empty"
	return

/obj/item/ammo_magazine/a762mm
	name = "magazine (7.62mm)"
	icon_state = "7.62mm"
	icon = 'icons/urist/items/uristweapons.dmi'
	origin_tech = "combat=2"
	ammo_type = "/obj/item/ammo_casing/a762mm"
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/a12mm/empty
	name = "magazine (7.62mm)"
	icon_state = "7.62mm"
	icon = 'icons/urist/items/uristweapons.dmi'
	ammo_type = "/obj/item/ammo_casing/a762mm"
	max_ammo = 0

/obj/item/ammo_casing/a762mm
	desc = "A 7.62mm bullet casing."
	caliber = "7.62mm"
	projectile_type = "/obj/item/projectile/bullet/sniper"

/obj/item/projectile/bullet/sniper
	damage = 35

/obj/item/projectile/beam/sniper/pulse
	icon_state = "u_laser"
	damage = 70

/obj/item/projectile/beam/pulse/heavy/h2
	damage = 70

/obj/item/projectile/beam/light
	damage = 30

/obj/item/projectile/beam/pulse/light
	damage = 40

//ammo

/obj/item/weapon/storage/box/c20ammo
	name = "box of c20r"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."

	New()
		..()
		new /obj/item/ammo_magazine/a12mm(src)
		new /obj/item/ammo_magazine/a12mm(src)
		new /obj/item/ammo_magazine/a12mm(src)

/obj/item/weapon/storage/box/sniperammo
	name = "box of sniper ammo"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."

	New()
		..()
		new /obj/item/ammo_magazine/a762mm(src)
		new /obj/item/ammo_magazine/a762mm(src)
		new /obj/item/ammo_magazine/a762mm(src)

/obj/item/weapon/storage/box/lmgammo
	name = "box of l6 saw ammo"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."

	New()
		..()
		new /obj/item/ammo_magazine/a762(src)
		new /obj/item/ammo_magazine/a762(src)
		new /obj/item/ammo_magazine/a762(src)

/obj/item/weapon/storage/box/knightammo
	name = "box of Knight ammo"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."

	New()
		..()
		new /obj/item/ammo_magazine/c45m(src)
		new /obj/item/ammo_magazine/c45m(src)
		new /obj/item/ammo_magazine/c45m(src)
		new /obj/item/ammo_magazine/c45m(src)

//armour (first heavy tier and first medic tier. possibly 2nd/3rd sniper tier.

/obj/item/weapon/rig/ert/medical/scom
	name = "Combat Medic suit control module"
	desc = "A suit worn by the medical division of a NanoTrasen Emergency Response Team. Has white highlights. Armoured and space ready."
	suit_type = "ERT medic"
	icon_state = "ert_medical_rig"

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/chem_dispenser/injector
		)

/obj/item/weapon/rig/ert/security/scom
	name = "Assault suit control module"
	desc = "A suit worn by the security division of a NanoTrasen Emergency Response Team. Has red highlights. Armoured and space ready."
	suit_type = "ERT security"
	icon_state = "ert_security_rig"

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/egun,
		)

/obj/item/clothing/suit/urist/armor
	name = "armor"
	desc = "An armored vest that protects against some damage."
	flags = ONESIZEFITSALL
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/urist/armor/heavy
	icon_state = "heavy"

/obj/item/clothing/suit/urist/armor/medic
	icon_state = "ltvest"

/obj/item/weapon/rig/scomsniper
	name = "cybersuit control module"
	suit_type = "cyber"
	desc = "An advanced powered armour suit with many cyberwarfare enhancements."
	icon_state = "hacker_rig"

	helm_type = /obj/item/clothing/head/helmet/space/rig/mask
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 30)
	initial_modules = list(
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/stealth_field,
		/obj/item/rig_module/mounted/energy_blade,
		/obj/item/rig_module/mounted/egun
		)

/obj/item/weapon/rig/light/scomsniper
	name = "stealth suit control module"
	suit_type = "stealth"
	desc = "A highly advanced and expensive suit designed for covert operations."
	icon_state = "ninja_rig"

	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 30)
	initial_modules = list(
		/obj/item/rig_module/mounted/energy_blade,
		/obj/item/rig_module/stealth_field
		)

/obj/item/clothing/under/urist/scom
	name = "S-COM operative's outfit."
	desc = "The outfit of an S-COM Operative."
	icon_state = "scom"
	item_color = "scom"