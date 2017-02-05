/obj/item/clothing/suit/urist/armor/anfor
	name = "anfor armour"
	desc = "dammit admins, stop spawning the parent classes"
	icon_state = "m3_ppa"
	armor = list(melee = 50, bullet = 75, laser = 40, energy = 25, bomb = 30, bio = 0, rad = 0)

/obj/item/clothing/suit/urist/armor/anfor/nco
	name = "ANFOR NCO armour"
	desc = "The M3 PPA, standard issue armour for ANFOR marines. This one has the markings of a Non-Commissioned Officer."
	icon_state = "m3_ppa_nco"

/obj/item/clothing/suit/urist/armor/anfor/marine
	name = "ANFOR Marine armour"
	desc = "The M3 PPA, standard issue armour for ANFOR marines. This one has the markings of a standard marine"
	icon_state = "m3_ppa"

/obj/item/clothing/suit/urist/armor/anfor/engi
	name = "ANFOR Engineering armour"
	desc = "The M3 PPA, standard issue armour for ANFOR marines. This one has the markings of a marine in the Engineering division."
	icon_state = "m3_ppa_enge"

/obj/item/clothing/suit/urist/armor/anfor/medic
	name = "ANFOR Medic armour"
	desc = "The M3 PPA, standard issue armour for ANFOR marines. This one has the markings of a field medic."
	icon_state = "m3_ppa_medic"

/obj/item/clothing/under/urist/anfor
	name = "ANFOR Marine BDU"
	desc = "An olive drab Battle Dress Uniform, standard issue for ANFOR marines."
	icon_state = "bdu_olive"
	item_state = "bdu_olive"

/obj/item/clothing/under/urist/anfor/rollsleeves()

	if(icon_state == "bdu_olive_shirt")
		src.icon_state = "bdu_olive"
		src.item_state = "bdu_olive"
		usr << "<span class='notice'>You roll down the sleeves of your BDU.</span>"
		usr.regenerate_icons()

	else
		src.icon_state = "bdu_olive_shirt"
		src.item_state = "bdu_olive_shirt"
		usr << "<span class='notice'>You roll up the sleeves of your BDU.</span>"
		usr.regenerate_icons()

/obj/item/clothing/head/helmet/urist/anfor
	name = "ANFOR Marine helmet"
	desc = "An olive drab M10 protective helmet, standard issue for all Anfor marines."
	icon_state = "m10_pbh"
	armor = list(melee = 40, bullet = 75, laser = 30, energy = 25, bomb = 30, bio = 0, rad = 0)
	var/obj/item/weapon/storage/fancy/cigarettes/cigs

/obj/item/clothing/head/helmet/urist/anfor/attack_hand(var/mob/living/M)
	if(cigs)
		cigs.loc = get_turf(src)
		if(M.put_in_active_hand(cigs))
			M << "<span class='notice'>You pull the [cigs] out of the helmet.</span>"
			cigs = 0
			src.icon_state = "m10_pbh"
			M.regenerate_icons()
		return

	..()

/obj/item/clothing/head/helmet/urist/anfor/attackby(var/obj/item/I, var/mob/living/M)
	if(istype(I, /obj/item/weapon/storage/fancy/cigarettes))
		if(cigs)	return
		M.drop_item()
		cigs = I
		I.loc = src
		M << "<span class='notice'>You slide the [I] into the band of the helmet.</span>"
		src.icon_state = "m10_pbh_cig"
		M.regenerate_icons()

/obj/item/clothing/shoes/urist/anforjackboots
	name = "ANFOR jackboots"
	desc = "Standard issue ANFOR combat jackboots. It has a slot for a combat knife!"
	icon_state = "jackboots"
	item_state = "jackboots"
	force = 3
	armor = list(melee = 40, bullet = 40, laser = 15, energy = 15, bomb = 25, bio = 0, rad = 0)
	siemens_coefficient = 0.7
	var/obj/item/weapon/material/hatchet/tacknife/knife

/obj/item/clothing/shoes/urist/anforjackboots/attack_hand(var/mob/living/M)
	if(knife)
		knife.loc = get_turf(src)
		if(M.put_in_active_hand(knife))
			M << "<span class='notice'>You pull the [knife] out of the jackboot.</span>"
			knife = 0
			src.icon_state = "jackboots"
			M.regenerate_icons()
		return

	..()

/obj/item/clothing/shoes/urist/anforjackboots/attackby(var/obj/item/I, var/mob/living/M)
	if(istype(I, /obj/item/weapon/material/hatchet/tacknife))
		if(knife)	return
		M.drop_item()
		knife = I
		I.loc = src
		M << "<span class='notice'>You slide the [I] into of the jackboot.</span>"
		src.icon_state = "jackboots-knife"
		M.regenerate_icons()

/obj/item/clothing/head/soft/anfor
	urist_only = 1
	icon_override = 'icons/uristmob/head.dmi'
	name = "ANFOR NCO cap"
	desc = "A cap worn by ANFOR NCOs. Doesn't offer all that much protection, but DAMN does it look good. Hey, you can flip it around too. Your corpse will look good for sure."
	icon = 'icons/urist/items/clothes/head.dmi'
	icon_state = "anforsoft"

//voidsuit - might change this to an actual rig

/obj/item/clothing/suit/space/void/anfor
	name = "\improper ANFOR marine voidsuit"
	desc = "A heavily armored suit that protects against moderate damage. Used by ANFOR marines when exposure to the cold dark void of space is likely."
	icon_override = 'icons/uristmob/clothes.dmi'
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_state = "anforeva"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/tank)
	armor = list(melee = 60, bullet = 80, laser = 45,energy = 25, bomb = 50, bio = 100, rad = 100)
	flags_inv = HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 0.6

/obj/item/clothing/suit/space/void/anfor/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1

/obj/item/clothing/head/helmet/space/void/anfor
	urist_only = 1
	name = "ANFOR marine voidsuit helmet"
	desc = "A comfortable voidsuit helmet used by ANFOR marines. Features cranial armor and eight-channel surround sound."
	icon_override = 'icons/uristmob/head.dmi'
	icon = 'icons/urist/items/clothes/head.dmi'
	icon_state = "rig0-anforeva"
	armor = list(melee = 50, bullet = 80, laser = 35, energy = 25, bomb = 50, bio = 100, rad = 10)
	siemens_coefficient = 0.7
	light_overlay = "helmet_light_dual"

//Weapons

/obj/item/weapon/gun/projectile/automatic/a22
	urist_only = 1
	name = "\improper A22 Combat Rifle"
	desc = "20 high-powered rounds of 5.56mm. Staple rifle for the ANFOR Marine, perfect for punching 5.56 millimetre holes in alien scum. Can fire semi automatic or in 3 or 5 round bursts."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "battlerifle"
	item_state = "battlerifle"
	w_class = 4
	force = 10
	caliber = "a556"
	origin_tech = "combat=6;materials=1;syndicate=4"
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a556/a22
	requires_two_hands = 5
	fire_sound = 'sound/weapons/gunshot/gunshot2.ogg'
	wielded_item_state = "genericrifle-wielded"

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.0, 0.6, 0.6)),
		list(mode_name="short bursts", burst=5, fire_delay=null, move_delay=6, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/projectile/automatic/a22/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "battlerifle"
	else
		icon_state = "battlerifle-empty"
	return

/obj/item/ammo_magazine/a556/a22
	name = "A22 magazine (5.56mm)"
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "brmag"
	mag_type = MAGAZINE
	caliber = "a556"
	origin_tech = "combat=2"
	matter = list(DEFAULT_WALL_MATERIAL = 3500)
	ammo_type = /obj/item/ammo_casing/a556
	max_ammo = 20

/obj/item/ammo_magazine/a556/a22/empty
	initial_ammo = 0

/obj/item/weapon/gun/projectile/a18
	urist_only = 1
	name = "\improper A18 Marksman's Rifle"
	desc = "30 high-powered rounds of 7.62mm. The standard-issue marksman's rifle for the ANFOR Marine Corps. Can mount either a scope or a grenade launcher, making it a versatile, accurate semi-automatic rifle perfect for those serving in support roles."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "FALrifle"
	item_state = "arifle"
	w_class = 4
	force = 10
	caliber = "a762"
	origin_tech = "combat=6;materials=1;syndicate=4"
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a762mm/a18
	requires_two_hands = 5
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	var/use_launcher = 0
	wielded_item_state = "woodarifle-wielded"
	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, use_launcher = null, move_delay=null, burst_accuracy=null, dispersion=null)
		)

	var/obj/item/weapon/gun/launcher/grenade/underslung/launcher

	var/gl_attach = 0
	var/scoped = 0

/obj/item/weapon/gun/projectile/a18/scoped
	name = "A18-Scoped"
	scoped = 1
	icon_state = "FALrifle-scope"

/obj/item/weapon/gun/projectile/a18/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	if(scoped)
		toggle_scope(usr, 2.0)

	else
		return

/obj/item/weapon/gun/projectile/a18/update_icon()
	..()
	if(gl_attach)
		if(ammo_magazine)
			icon_state = "FALrifle-GL"
		else
			icon_state = "FALrifle-GL-empty"
	else if(scoped)
		if(ammo_magazine)
			icon_state = "FALrifle-scope"
		else
			icon_state = "FALrifle-scope-empty"
	else
		if(ammo_magazine)
			icon_state = "FALrifle"
		else
			icon_state = "FALrifle-empty"
	return

/obj/item/weapon/gun/projectile/a18/New()
	..()
	launcher = new(src)

/obj/item/weapon/gun/projectile/a18/attackby(obj/item/I, mob/user) //i really need to make a partent class for guns that can be modified, but right now it's only the one so fuck it. //GlloydTODO
	..()

	if(gl_attach)
		if((istype(I, /obj/item/weapon/grenade)))
			launcher.load(I, user)
		else if(istype(I, /obj/item/weapon/wrench))
			user << "<span class='notice'>You remove the underslung grenade launcher from the A18.</span>"
			gl_attach = 0
			firemodes = null
			firemodes = list(
				list(mode_name="semiauto", burst=1, fire_delay=0, use_launcher = null, move_delay=null, burst_accuracy=null, dispersion=null)
				)
			update_icon()
			new /obj/item/weapon/gunattachment/grenadelauncher(user.loc)

			for(var/i in 1 to firemodes.len)
				firemodes[i] = new /datum/firemode(src, firemodes[i])

	else if(!gl_attach && !scoped)

		if(istype(I, /obj/item/weapon/gunattachment/scope/a18))
			scoped = 1
			update_icon()
			user.remove_from_mob(I)
			qdel(I)

		else if(istype(I, /obj/item/weapon/gunattachment/grenadelauncher))
			gl_attach = 1
			firemodes = null
			firemodes = list(
				list(mode_name="semiauto", burst=1,  use_launcher=null, requires_two_hands = 4, fire_delay=0, move_delay=null, burst_accuracy=null, dispersion=null),
				list(mode_name="fire grenades", requires_two_hands = 6, burst=null, fire_delay=null, move_delay=null, use_launcher=1, burst_accuracy=null, dispersion=null)
				)
			update_icon()
			user.remove_from_mob(I)
			qdel(I)

			for(var/i in 1 to firemodes.len)
				firemodes[i] = new /datum/firemode(src, firemodes[i])

	else if(scoped)

		if(istype(I, /obj/item/weapon/wrench))
			user << "<span class='notice'>You remove the scope from the A18</span>"
			scoped = 0
			update_icon()
			new /obj/item/weapon/gunattachment/scope/a18(user.loc)

/obj/item/weapon/gun/projectile/a18/attack_hand(mob/user)
	if(user.get_inactive_hand() == src && use_launcher && gl_attach)
		launcher.unload(user)
	else
		..()

/obj/item/weapon/gun/projectile/a18/gl/Fire(atom/target, mob/living/user, params, pointblank=0, reflex=0)
	if(use_launcher)
		launcher.Fire(target, user, params, pointblank, reflex)
		if(!launcher.chambered)
			switch_firemodes() //switch back automatically
	else
		..()

/obj/item/weapon/gun/projectile/a18/gl
	name = "A18-GL"
	icon_state = "FALrifle-GL"
	gl_attach = 1
	firemodes = list(
		list(mode_name="semiauto", burst=1, requires_two_hands = 4, fire_delay=0,  move_delay=null, use_launcher=null, burst_accuracy=null, dispersion=null),
		list(mode_name="fire grenades", requires_two_hands = 6, burst=null, fire_delay=null, move_delay=null, use_launcher=1, burst_accuracy=null, dispersion=null)
		)

/obj/item/weapon/gunattachment
	icon = 'icons/urist/items/guns.dmi'

/obj/item/weapon/gunattachment/grenadelauncher
	name = "A18 attachable grenade launcher"
	desc = "An underslung grenade launcher designed to be attached to an A18 rifle."
	icon_state = "a18grenadelauncher"

/obj/item/weapon/gunattachment/scope/a18
	icon_state = "a18scope"
	name = "A18 attachable scope"
	desc = "A marksman's scope designed to be attached to an A18 rifle."

/obj/item/ammo_magazine/a762mm/a18
	name = "A18 magazine (7.62mm)"
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "FALmag"
	mag_type = MAGAZINE
	caliber = "a762"
	origin_tech = "combat=2"
	matter = list(DEFAULT_WALL_MATERIAL = 4500)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 30

/obj/item/ammo_magazine/a762mm/a18/empty
	initial_ammo = 0

/obj/item/weapon/gun/projectile/automatic/asmg
	urist_only = 1
	name = "\improper A37 SMG"
	desc = "The standard submachine gun of the ANFOR Marine Corps. Has 40 rounds of 9mm ammo, and can fire semi automatic or in 3 or 5 round bursts.."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "ASMG"
	item_state = "ASMG"
	w_class = 3
	force = 10
	caliber = "9mm"
	origin_tech = "combat=6;materials=1;syndicate=4"
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a9mm
	requires_two_hands = 1
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, requires_two_hands = 1, move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, move_delay=6, fire_delay=null, requires_two_hands = 2, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.0, 0.6, 0.6)),
		list(mode_name="short bursts", 	burst=5, move_delay=6, fire_delay=null, requires_two_hands = 3, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/projectile/automatic/asmg/update_icon()
	if(ammo_magazine)
		icon_state = "ASMG"
	else
		icon_state = "ASMG"

/obj/item/ammo_magazine/a9mm
	name = "A37 magazine (9mm)"
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "ASMGmag"
	mag_type = MAGAZINE
	caliber = "9mm"
	origin_tech = "combat=2"
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 30
//	multiple_sprites = 1

/obj/item/ammo_magazine/a9mm/empty
	initial_ammo = 0

/obj/item/weapon/gun/projectile/shotgun/pump/combat/A41
	max_shells = 10
	name = "\improper A41 combat shotgun"
	desc = "The standard issue ANFOR shotgun. Holds 10 rounds (11 with one in the chamber). Pump-action, it's perfect for CQB and tight hallway clearing."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "A41"
	item_state = "A41"
	urist_only = 1
	requires_two_hands = 3
	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'

/obj/item/weapon/gun/projectile/colt/a7
	name = "\improper A7 pistol"
	desc = "A slightly modified version of the classic Colt M1911, the standard sidearm for ANFOR Marines. It holds 8 .45 rounds."
	magazine_type = /obj/item/ammo_magazine/c45m/a7
	icon_state = "COLT45"
	icon = 'icons/urist/items/guns.dmi'
	load_method = MAGAZINE

/obj/item/ammo_magazine/c45m/a7
	icon = 'icons/urist/items/guns.dmi'
	name = "A7 magazine (.45)"
	icon_state = "COLT45MAG"
	ammo_type = /obj/item/ammo_casing/c45
	caliber = ".45"
	max_ammo = 8

/obj/item/ammo_magazine/c45m/a7/empty
	initial_ammo = 0

/obj/item/weapon/gun/projectile/manualcycle/a50
	urist_only = 1
	name = "A50 Heavy Rifle"
	icon = 'icons/urist/items/guns.dmi'
	desc = "A bolt action anti-material rifle used by ANFOR support units. Chambered in 13.2x108mm, it is intended to breach the thin hulls of light landing craft, but in a pinch, could be used against the hardened carapaces of xenomorphs. Using state of the art technology, the gun manages to negate the majority of the recoil."
	wielded_item_state = "rifle2" //maybe change this
	icon_state = "a50"
	item_state = "rifle2"
	w_class = 5
	requires_two_hands = 6
	force = 10
	slot_flags = SLOT_BACK
	caliber = "13.2x108mm"
	handle_casings = HOLD_CASINGS
//	load_method = SINGLE_CASING
	max_shells = 5
	ammo_type = /obj/item/ammo_casing/a132x108mm
//	accuracy = -1
//	jam_chance = 5
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'

/obj/item/ammo_casing/a132x108mm
	name = "shell casing"
	desc = "A 13.2x108mm shell."
	icon_state = "lcasing"
	spent_icon = "lcasing-spent"
	caliber = "13.2x108mm"
	projectile_type = /obj/item/projectile/bullet/rifle/a145
	matter = list(DEFAULT_WALL_MATERIAL = 1250)

/obj/item/projectile/bullet/rifle/a132x108mm
	fire_sound = 'sound/weapons/gunshot/sniper.ogg'
	damage = 60
	stun = 1.5
	weaken = 1.5
	penetrating = 5
	armor_penetration = 60

/obj/item/ammo_magazine/a132x108mm/stripper
	name = "stripper clip (13.2x108m)"
	icon_state = "stripper" //change
	icon = 'icons/urist/items/guns.dmi'
	caliber = "13.2x108mm"
	max_ammo = 5
	multiple_sprites = 1
	mag_type = SPEEDLOADER
	ammo_type = /obj/item/ammo_casing/a132x108mm