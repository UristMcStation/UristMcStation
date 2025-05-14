/obj/item/clothing/suit/storage/urist/armor/anfor
	name = "anfor armour"
	desc = "dammit admins, stop spawning the parent classes"
	icon_state = "ANFOR-suit"
	armor = list(melee = 50, bullet = 75, laser = 40, energy = 25, bomb = 30, bio = 0, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/storage/urist/armor/anfor/nco
	name = "ANFOR NCO armour"
	desc = "The M3 PPA, standard issue armour for ANFOR marines. This one has the markings of a Non-Commissioned Officer."
	icon_state = "ANFOR-cmdsuit"

/obj/item/clothing/suit/storage/urist/armor/anfor/marine
	name = "ANFOR Marine armour"
	desc = "The M3 PPA, standard issue armour for ANFOR marines. This one has the markings of a standard marine."
	icon_state = "ANFOR-suit"

/obj/item/clothing/suit/storage/urist/armor/anfor/engi
	name = "ANFOR Engineering armour"
	desc = "The M3 PPA, standard issue armour for ANFOR marines. This one has the markings of a marine in the Engineering division."
	icon_state = "ANFOR-engsuit"

/obj/item/clothing/suit/storage/urist/armor/anfor/medic
	name = "ANFOR Medic armour"
	desc = "The M3 PPA, standard issue armour for ANFOR marines. This one has the markings of a field medic."
	icon_state = "ANFOR-medsuit"

/obj/item/clothing/under/urist/anfor
	name = "ANFOR Marine BDU"
	desc = "An olive drab Battle Dress Uniform, standard issue for ANFOR marines."
	icon_state = "ANFOR-jumpsuit"
	item_state = "ANFOR-jumpsuit"

/obj/item/clothing/under/urist/anfor/rollsleeves()

	if(icon_state == "ANFOR-jumpsuit_shirt")
		src.icon_state = "ANFOR-jumpsuit"
		src.item_state = "ANFOR-jumpsuit"
		to_chat(usr, "<span class='notice'>You roll down the sleeves of your BDU.</span>")
		usr.regenerate_icons()

	else
		src.icon_state = "ANFOR-jumpsuit_shirt"
		src.item_state = "ANFOR-jumpsuit_shirt"
		to_chat(usr, "<span class='notice'>You roll up the sleeves of your BDU.</span>")
		usr.regenerate_icons()

/obj/item/clothing/head/helmet/urist/anfor
	name = "ANFOR Marine helmet"
	desc = "An olive drab M10 protective helmet, standard issue for all ANFOR marines. This one has the markings of a standard marine."
	icon_state = "ANFOR-helm"
	armor = list(melee = 40, bullet = 75, laser = 30, energy = 25, bomb = 30, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/urist/anfor/med
	name = "ANFOR Medic helmet"
	desc = "An olive drab M10 protective helmet, standard issue for all ANFOR marines. This one has the markings of a field medic."
	icon_state = "ANFOR-medhelm"

/obj/item/clothing/head/helmet/urist/anfor/eng
	name = "ANFOR Engineering helmet"
	desc = "An olive drab M10 protective helmet, standard issue for all ANFOR marines. This one has the markings of a marine in the Engineering division."
	icon_state = "ANFOR-enghelm"

/obj/item/clothing/head/helmet/urist/anfor/nco
	name = "ANFOR NCO helmet"
	desc = "An olive drab M10 protective helmet, standard issue for all ANFOR marines. This one has the markings of a Non-Commissioned Officer."
	icon_state = "ANFOR-cmdhelm"
//	var/obj/item/storage/fancy/smokable/cigs

/*
/obj/item/clothing/head/helmet/urist/anfor/attack_hand(mob/living/M)
	if(cigs)
		cigs.loc = get_turf(src)
		if(M.put_in_active_hand(cigs))
			to_chat(M, "<span class='notice'>You pull the [cigs] out of the helmet.</span>")
			cigs = 0
			src.icon_state = "m10_pbh"
			M.regenerate_icons()
		return

	..()

/obj/item/clothing/head/helmet/urist/anfor/attackby(obj/item/I, mob/living/M)
	if(istype(I, /obj/item/storage/fancy/smokable))
		if(cigs)	return
		M.drop_item()
		cigs = I
		I.loc = src
		to_chat(M, "<span class='notice'>You slide the [I] into the band of the helmet.</span>")
		src.icon_state = "m10_pbh_cig"
		M.regenerate_icons()
*/

/obj/item/clothing/shoes/urist/anforjackboots
	name = "ANFOR jackboots"
	desc = "Standard issue ANFOR combat jackboots. It has a slot for a combat knife!"
	icon_state = "jackboots"
	item_state = "jackboots"
	force = 3
	armor = list(melee = 40, bullet = 40, laser = 15, energy = 15, bomb = 25, bio = 0, rad = 0)
	siemens_coefficient = 0.7
	var/obj/item/material/knife/combat/knife

/obj/item/clothing/shoes/urist/anforjackboots/attack_hand(mob/living/M)
	if(knife)
		knife.loc = get_turf(src)
		if(M.put_in_active_hand(knife))
			to_chat(M, "<span class='notice'>You pull the [knife] out of the jackboot.</span>")
			knife = 0
			src.icon_state = "jackboots"
			M.regenerate_icons()
		return

	..()

/obj/item/clothing/shoes/urist/anforjackboots/use_tool(obj/item/I, mob/living/M, click_params)
	if(istype(I, /obj/item/material/knife/combat))
		if(knife)
			to_chat(M, SPAN_NOTICE("\The [src] already has a [knife] in it!"))
			return TRUE

		M.drop_item()
		knife = I
		I.loc = src
		to_chat(M, SPAN_NOTICE("You slide the [I] into of the jackboot."))
		src.icon_state = "jackboots-knife"
		M.regenerate_icons()
		return TRUE

	else
		return ..()

/obj/item/clothing/head/urist/anfor
	name = "ANFOR NCO cap"
	desc = "A cap worn by ANFOR NCOs. Doesn't offer all that much protection, but DAMN does it look good. Your corpse will look good for sure."
	icon_state = "anforsoft2"

//voidsuit - might change this to an actual rig

/obj/item/clothing/suit/space/void/anfor
	name = "\improper ANFOR marine voidsuit"
	desc = "A heavily armored suit that protects against moderate damage. Used by ANFOR marines when exposure to the cold dark void of space is likely."
	icon_override = 'icons/uristmob/clothes.dmi'
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_state = "ANFOR-evasuit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	allowed = list(/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/tank)
	armor = list(melee = 60, bullet = 80, laser = 45,energy = 25, bomb = 50, bio = 100, rad = 100)
	flags_inv = HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 0.6

/obj/item/clothing/suit/space/void/anfor/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1

/obj/item/clothing/head/helmet/space/void/anfor
	item_icons = URIST_ALL_ONMOBS
	name = "ANFOR marine voidsuit helmet"
	desc = "A comfortable voidsuit helmet used by ANFOR marines. Features cranial armor and eight-channel surround sound."
	icon = 'icons/urist/items/clothes/head.dmi'
	icon_state = "rig0-anforeva"
	armor = list(melee = 50, bullet = 80, laser = 35, energy = 25, bomb = 50, bio = 100, rad = 100)
	siemens_coefficient = 0.7
	light_overlay = "helmet_light_dual"

//Weapons

/obj/item/gun/projectile/automatic/a22
	item_icons = URIST_ALL_ONMOBS
	name = "\improper A22 Combat Rifle"
	desc = "20 high-powered rounds of 5.56mm. Staple rifle for the ANFOR Marine Corps and the Terran Confederacy Marine Corps, perfect for punching 5.56 millimetre holes in alien scum. Can fire semi automatic or in 3 or 5 round bursts."
	icon = 'icons/urist/guns/anfor.dmi'
	icon_state = "ANFOR-rifle"
	item_state = "ANFOR-rifle"
	w_class = 4
	force = 10
	caliber = CALIBER_RIFLE_MILITARY
	origin_tech = "combat=6;materials=1;syndicate=4"
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/rifle/a22
	allowed_magazines = /obj/item/ammo_magazine/rifle/a22
	one_hand_penalty = 5
	fire_sound = 'sound/weapons/gunshot/gunshot2.ogg'
	wielded_item_state = "ANFOR-rifle-wielded"

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.0, 0.6, 0.6)),
		list(mode_name="short bursts", burst=5, fire_delay=null, move_delay=6, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/projectile/automatic/a22/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "ANFOR-rifle"
	else
		icon_state = "ANFOR-rifle-empty"
	return

/obj/item/ammo_magazine/rifle/a22
	name = "A22 magazine"
	icon = 'icons/urist/guns/ammo_anfor.dmi'
	icon_state = "ANFOR-riflemag"
	mag_type = MAGAZINE
	caliber = CALIBER_RIFLE_MILITARY
	origin_tech = "combat=2"
	matter = list(DEFAULT_WALL_MATERIAL = 3500)
	ammo_type = /obj/item/ammo_casing/rifle
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/rifle/a22/empty
	initial_ammo = 0

/obj/item/gun/projectile/a18
	item_icons = URIST_ALL_ONMOBS
	name = "\improper A18 Marksman's Rifle"
	desc = "30 high-powered rounds of 7.62mm. The standard-issue marksman's rifle for the ANFOR Marine Corps and the Terran Confederacy Marine Corps. Can mount either a scope or a grenade launcher, making it a versatile, accurate semi-automatic rifle perfect for those serving in support roles."
	icon = 'icons/urist/guns/anfor.dmi'
	icon_state = "ANFOR-battlerifle"
	item_state = "ANFOR-battlerifle"
	w_class = 4
	force = 10
	caliber = CALIBER_RIFLE_MILITARY
	origin_tech = "combat=6;materials=1;syndicate=4"
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/rifle/military/a18
	one_hand_penalty = 5
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
//	var/use_launcher = 0
	wielded_item_state = "ANFOR-battlerifle-wielded"
	scoped_accuracy = 2
	scope_zoom = 1
	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, use_launcher = null, move_delay=null, burst_accuracy=null, dispersion=null)
		)

//	var/obj/item/gun/launcher/grenade/underslung/launcher

//	var/gl_attach = 0
//	var/scoped = 0
/*
/obj/item/gun/projectile/a18/scoped
	name = "A18-Scoped"
	scoped = 1
	icon_state = "FALrifle-scope"
*/
/*
/obj/item/gun/projectile/a18/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(usr, 2.0)
*/
/obj/item/gun/projectile/a18/on_update_icon()
	..()
/*
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
*/
	if(ammo_magazine)
		icon_state = "ANFOR-battlerifle"
	else
		icon_state = "ANFOR-battlerifle-empty"

/*
/obj/item/gun/projectile/a18/New()
	..()
	launcher = new(src)
*/
/*
/obj/item/gun/projectile/a18/use_tool(obj/item/I, mob/living/user, list/click_params) //i really need to make a partent class for guns that can be modified, but right now it's only the one so fuck it. //GlloydTODO
	..()

	if(gl_attach)
		if((istype(I, /obj/item/grenade)))
			launcher.load(I, user)
		else if(istype(I, /obj/item/wrench))
			to_chat(user, "<span class='notice'>You remove the underslung grenade launcher from the A18.</span>")
			gl_attach = 0
			firemodes = null
			firemodes = list(
				list(mode_name="semiauto", burst=1, fire_delay=0, use_launcher = null, move_delay=null, burst_accuracy=null, dispersion=null)
				)
			update_icon()
			new /obj/item/gunattachment/grenadelauncher(user.loc)

			for(var/i in 1 to length(firemodes))
				firemodes[i] = new /datum/firemode(src, firemodes[i])

	else if(!gl_attach && !scoped)

		if(istype(I, /obj/item/gunattachment/scope/a18))
			scoped = 1
			update_icon()
			user.remove_from_mob(I)
			qdel(I)

		else if(istype(I, /obj/item/gunattachment/grenadelauncher))
			gl_attach = 1
			firemodes = null
			firemodes = list(
				list(mode_name="semiauto", burst=1,  use_launcher=null, one_hand_penalty = 4, fire_delay=0, move_delay=null, burst_accuracy=null, dispersion=null),
				list(mode_name="fire grenades", one_hand_penalty = 6, burst=null, fire_delay=null, move_delay=null, use_launcher=1, burst_accuracy=null, dispersion=null)
				)
			update_icon()
			user.remove_from_mob(I)
			qdel(I)

			for(var/i in 1 to length(firemodes))
				firemodes[i] = new /datum/firemode(src, firemodes[i])

	else if(scoped)

		if(istype(I, /obj/item/wrench))
			to_chat(user, "<span class='notice'>You remove the scope from the A18</span>")
			scoped = 0
			update_icon()
			new /obj/item/gunattachment/scope/a18(user.loc)

/obj/item/gun/projectile/a18/attack_hand(mob/user)
	if(user.get_inactive_hand() == src && use_launcher && gl_attach)
		launcher.unload(user)
	else
		..()

/obj/item/gun/projectile/a18/gl/Fire(atom/target, mob/living/user, params, pointblank=0, reflex=0)
	if(use_launcher)
		launcher.Fire(target, user, params, pointblank, reflex)
		if(!launcher.chambered)
			switch_firemodes() //switch back automatically
	else
		..()

/obj/item/gun/projectile/a18/gl
	name = "A18-GL"
	icon_state = "FALrifle-GL"
	gl_attach = 1
	firemodes = list(
		list(mode_name="semiauto", burst=1, one_hand_penalty = 4, fire_delay=0,  move_delay=null, use_launcher=null, burst_accuracy=null, dispersion=null),
		list(mode_name="fire grenades", one_hand_penalty = 6, burst=null, fire_delay=null, move_delay=null, use_launcher=1, burst_accuracy=null, dispersion=null)
		)
*/

/obj/item/gunattachment // FIX ME ALEX!!!!
	icon = 'icons/urist/guns/gun_attachments.dmi'
	#WARN - FIX ME YOU FUCK - GUN ATTACHMENTS

/*
/obj/item/gunattachment/grenadelauncher
	name = "A18 attachable grenade launcher"
	desc = "An underslung grenade launcher designed to be attached to an A18 rifle."
	icon_state = "a18grenadelauncher"

/obj/item/gunattachment/scope/a18
	icon_state = "a18scope"
	name = "A18 attachable scope"
	desc = "A marksman's scope designed to be attached to an A18 rifle."
*/

/obj/item/ammo_magazine/rifle/military/a18
	name = "A18 magazine"
	icon = 'icons/urist/guns/ammo_anfor.dmi'
	icon_state = "ANFOR-battleriflemag"
	mag_type = MAGAZINE
	caliber = CALIBER_RIFLE_MILITARY
	origin_tech = "combat=2"
	matter = list(DEFAULT_WALL_MATERIAL = 4500)
	ammo_type = /obj/item/ammo_casing/rifle/military
	max_ammo = 30

/obj/item/ammo_magazine/rifle/military/a18/empty
	initial_ammo = 0

/obj/item/gun/projectile/automatic/asmg
	item_icons = DEF_URIST_INHANDS
	name = "\improper A37 SMG"
	desc = "The standard submachine gun of the ANFOR Marine Corps and the Terran Confederacy Marine Corps. Has 40 rounds of 9mm ammo, and can fire semi automatic or in 3 or 5 round bursts.."
	icon = 'icons/urist/guns/anfor.dmi'
	icon_state = "ANFOR-SMG"
	item_state = "ANFOR-SMG"
	wielded_item_state = "ANFOR-SMG"
	w_class = 3
	force = 10
	caliber = CALIBER_PISTOL_SMALL
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ESOTERIC = 4)
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a9mm
	allowed_magazines = /obj/item/ammo_magazine/a9mm
	ammo_type = /obj/item/ammo_casing/pistol/small
	one_hand_penalty = 1
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, one_hand_penalty = 1, move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, move_delay=6, fire_delay=null, one_hand_penalty = 2, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.0, 0.6, 0.6)),
		list(mode_name="short bursts", 	burst=5, move_delay=6, fire_delay=null, one_hand_penalty = 3, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/projectile/automatic/asmg/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "ANFOR-SMG"
	else
		icon_state = "ANFOR-SMG-empty"

/obj/item/ammo_magazine/a9mm
	name = "A37 magazine"
	icon = 'icons/urist/guns/ammo_anfor.dmi'
	icon_state = "ASMGmag"
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL_SMALL
	origin_tech = list(TECH_COMBAT = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 40
	multiple_sprites = 1

/obj/item/ammo_magazine/a9mm/empty
	initial_ammo = 0

/obj/item/gun/projectile/shotgun/pump/combat/A41
	max_shells = 10
	name = "\improper A41 combat shotgun"
	desc = "The standard issue ANFOR shotgun. Holds 10 rounds (11 with one in the chamber). Pump-action, it's perfect for CQB and tight hallway clearing."
	icon = 'icons/urist/guns/anfor.dmi'
	icon_state = "ANFOR-shotgun"
	item_state = "ANFOR-shotgun"
	wielded_item_state = "ANFOR-shotgun-wielded"
	slot_flags = SLOT_BACK
	item_icons = URIST_ALL_ONMOBS
	one_hand_penalty = 3
	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'

/obj/item/gun/projectile/pistol/colt/a7
	item_icons = DEF_URIST_INHANDS
	name = "\improper A7 pistol"
	desc = "A slightly modified version of the classic Colt M1911, the standard sidearm for ANFOR and Terran Marines. It holds 8 rounds."
	magazine_type = /obj/item/ammo_magazine/pistol/a7
	allowed_magazines = /obj/item/ammo_magazine/pistol/a7
	ammo_type = /obj/item/ammo_casing/pistol
	slot_flags = SLOT_BELT | SLOT_HOLSTER | SLOT_POCKET
	icon_state = "ANFOR-pistol"
	icon = 'icons/urist/guns/anfor.dmi'
	load_method = MAGAZINE

/obj/item/ammo_magazine/pistol/a7
	icon = 'icons/urist/guns/ammo_anfor.dmi'
	name = "A7 magazine"
	icon_state = "ANFOR-pistolmag"
	ammo_type = /obj/item/ammo_casing/pistol
	caliber = CALIBER_PISTOL
	max_ammo = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/pistol/a7/empty
	initial_ammo = 0

/obj/item/gun/projectile/manualcycle/a50
	name = "A50 Heavy Rifle"
	icon = 'icons/urist/guns/anfor_48x.dmi'
	desc = "A bolt action anti-material rifle used by ANFOR support units. Chambered in 13.2x108mm, it is intended to breach the thin hulls of light landing craft, but in a pinch, could be used against the hardened carapaces of xenomorphs. Using state of the art technology, the gun manages to negate the majority of the recoil."
	wielded_item_state = "ANFOR-sniper-wielded"
	icon_state = "ANFOR-sniper"
	item_state = "ANFOR-sniper"
	item_icons = list(
		slot_l_hand_str = 'icons/uristmob/items_lefthand48x32.dmi',
		slot_r_hand_str = 'icons/uristmob/items_righthand48x32.dmi',
		slot_back_str = 'icons/uristmob/back.dmi'
	)
	w_class = ITEM_SIZE_HUGE
	one_hand_penalty = 6
	force = 10
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 2, TECH_ESOTERIC = 8)
	slot_flags = SLOT_BACK
	caliber = CALIBER_ANTIMATERIAL
	load_method = SINGLE_CASING|SPEEDLOADER
	screen_shake = 2
	handle_casings = HOLD_CASINGS
	scoped_accuracy = 18
	scope_zoom = 2
	max_shells = 5
	ammo_type = /obj/item/ammo_casing/a50sniper
	allowed_magazines = /obj/item/ammo_magazine/manualcycle/a50_sniper
	magazine_type = /obj/item/ammo_magazine/manualcycle/a50_sniper
	fire_sound = 'sound/weapons/gunshot/sniper.ogg'
	load_sound = 'sound/weapons/guns/interaction/rifle_boltforward.ogg'


/obj/item/ammo_magazine/manualcycle/a50_sniper
	name = "A50 Magazine"
	desc = "A 14.5mm magazine clip for the A50 anti-material rifle."
	icon = 'icons/urist/guns/ammo_anfor.dmi'
	icon_state = "ANFOR-snipermag"
	max_ammo = 5
	multiple_sprites = 1
	mag_type = SPEEDLOADER
	caliber = CALIBER_ANTIMATERIAL
	matter = list(DEFAULT_WALL_MATERIAL = 1500)
	ammo_type = /obj/item/ammo_casing/a50sniper

/obj/item/ammo_casing/a50sniper
	name = "shell casing"
	desc = "A 14.5mm shell."
	icon = 'icons/urist/guns/ammo.dmi'
	icon_state = "lcasing"
	spent_icon = "lcasing-spent"
	caliber = CALIBER_ANTIMATERIAL
	projectile_type = /obj/item/projectile/bullet/rifle/a50_sniper
	matter = list(DEFAULT_WALL_MATERIAL = 1250)

/obj/item/projectile/bullet/rifle/a50_sniper
	fire_sound = 'sound/weapons/gunshot/sniper.ogg'
	damage = 75
	stun = 3
	weaken = 3
	penetrating = 4
	armor_penetration = 65
	penetration_modifier = 1.2
	distance_falloff = 0.75
