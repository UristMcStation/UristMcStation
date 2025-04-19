//Energy pistol, Energy gun with less shots. Can be put in player's pockets.

/obj/item/gun/energy/gun/tiny
	item_icons = DEF_URIST_INHANDS
	name = "energy pistol"
	desc = "An energy pistol with a wooden handle."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "senergy"
	item_state = "gun"
	fire_sound = 'sound/weapons/Taser.ogg'
	w_class = 1
	charge_cost = 10 //How much energy is needed to fire.
	projectile_type = /obj/item/projectile/energy/electrode
	origin_tech = "combat=2;magnets=2"
	modifystate = "senergystun"
	cell_type = /obj/item/cell/device/standard

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="senergystun", fire_sound='sound/weapons/Taser.ogg', fire_delay=null, charge_cost=null),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="senergykill", fire_sound='sound/weapons/Laser.ogg', fire_delay=null, charge_cost=null),
		)

	/*suicide_act(mob/user)
		viewers(user)to_target(, "<span class='danger'>[user] is unloading the [src.name] into their head!</span>")
		return(BRUTELOSS)*/

//umbrella gun

/obj/item/gun/projectile/umbrellagun
	item_icons = DEF_URIST_INHANDS
	name = "Umbrella"
	desc = "An umbrella with a small hole at the end, doesn't seem to open."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "umbrellagun"
	item_state = "umbrellagun"
	w_class = 2
	max_shells = 2
	caliber = CALIBER_PISTOL_SMALL
	silenced = 1
	origin_tech = "combat=2;materials=2"
	ammo_type = /obj/item/ammo_casing/pistol/small
	load_method = 2

//BANG BANG BANG, BANG BANG

/obj/item/gag/BANG
	item_icons = DEF_URIST_INHANDS
	icon = 'icons/urist/items/guns.dmi'
	name = "BANG gun"
	desc = "Shoots out a BANG"
	icon_state = "gun"
	item_state = "gun"
	var/on = 0
	w_class = 2

/obj/item/gag/BANG/attack_self(mob/user as mob)
	item_icons = DEF_URIST_INHANDS
	icon = 'icons/urist/items/guns.dmi'
	on = !on
	if(on)
		user.visible_message("<span class='warning'> [user] fires the gun, BANG.</span>",\
		"<span class='warning'> You fire the gun.</span>",\
		"You hear a BANG.")
		icon_state = "gunbang"
		item_state = "gunbang"
		w_class = 2
		force = 3
		attack_verb = list("smacked", "struck", "slapped")
	else
		user.visible_message("<span class='notice'> [user] pushes the BANG back into the barrel.</span>",\
		"<span class='notice'> You push the BANG back into the barrel.</span>",\
		"You hear a click.")
		icon_state = "gun"
		item_state = "gun"
		w_class = 2
		force = 3
		attack_verb = list("smacked", "struck", "slapped")

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

/*plasma pistol. does toxic damage. I want to add this to research soonish. icons by Susan from BS12, editing and projectile by Glloyd
--Okay, they implemented this on BS12, and I dislike how they did it. The top is green, and shoots a green pulse. It also has different values then the one I coded.
The point is that theirs is closer to the X-COM plasma pistol, despite the fact that all depictions of plasma in SS13 are purple, thus my choice to edit
the sprite and make my own projectile -Glloyd*/

/obj/item/gun/energy/plasmapistol
	item_icons = DEF_URIST_INHANDS
	name = "phoron pistol"
	desc = "An experimental weapon that works by ionizing phoron and firing it in a particular direction, poisoning someone."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "plasmapistol"
	item_state = "gun"
	fire_sound = 'sound/weapons/Genhit.ogg'
	w_class = 1
	charge_cost = 20 //How much energy is needed to fire.
	projectile_type = /obj/item/projectile/energy/plasma2
	origin_tech = "combat=3;magnets=2"
	modifystate = "plasmapistol"
	cell_type = /obj/item/cell/device/premium

/*	suicide_act(mob/user)
		viewers(user)to_target(, "<span class='danger'>[user] is unloading the [src.name] into their head! Their skin turns purple and starts to melt!</span>")
		return(BRUTELOSS)*/

/obj/item/projectile/energy/plasma2
	name = "ionized phoron"
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "plasma"
	damage = 20
	damage_type = DAMAGE_TOXIN
	irradiate = 20

//Knight .45 - suppressed PDW

/obj/item/gun/projectile/silenced/knight
	name = "Knight-45"
	desc = "A lightweight, suppressed weapon. Intended for operations where subtlety is preferred, if only for a little while."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "knight45"
	item_state = "knight45"
	item_icons = URIST_ALL_ONMOBS
	wielded_item_state = "knight45"
	fire_sound = 'sound/urist/suppshot.ogg'
	w_class = 2
	max_shells = 7
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	caliber = CALIBER_PISTOL
	ammo_type = /obj/item/ammo_casing/pistol
	magazine_type = /obj/item/ammo_magazine/pistol
	auto_eject = 1

/obj/item/gun/projectile/silenced/knight/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "knight45"
	else
		icon_state = "knight45-empty"

///// Deckard .44 - old Bay custom item rip for UMcS Blueshields
/obj/item/gun/projectile/revolver/detective/deckard
	icon = 'icons/urist/items/revolvers.dmi'
	item_icons = DEF_URIST_INHANDS
	name = "Deckard .38" //changed from .44 for internal consistency - it takes .38 bullets
	desc = "A custom autorevolver chambered in .38 Special issued to high-ranking specialists, based on the obsoleted Detective Special forensics issue models. For some reason, the caliber feels like it should be bigger..."
	//what do you know, it was restored-ish in revolver.dm
	icon_state = "deckard-empty"

/obj/item/gun/projectile/revolver/detective/deckard/on_update_icon()
	..()
	if(length(loaded))
		icon_state = "deckard-loaded"
	else
		icon_state = "deckard-empty"

/obj/item/gun/projectile/revolver/detective/deckard/load_ammo(obj/item/A, mob/user)
	if(istype(A, /obj/item/ammo_magazine))
		flick("deckard-reloading",src)
	..()

//NamERT

/obj/item/ammo_magazine/box/rifle/military
	caliber = CALIBER_RIFLE_MILITARY
	ammo_type = /obj/item/ammo_casing/rifle/military
	mag_type = MAGAZINE

/obj/item/ammo_magazine/rifle
	caliber = CALIBER_RIFLE
	ammo_type = /obj/item/ammo_casing/rifle
	mag_type = MAGAZINE

/obj/item/gun/projectile/automatic/l6_saw/m60
	item_icons = DEF_URIST_INHANDS
	name = "M60 Machinegun"
	desc = "The general-purpose machinegun and the main firearm for the Machinegunner. Chambered in 7.62mm , it is fed through a 75-round belt. Fires in short and long bursts, perfect for support and suppresive fire."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "M60closed75"
	item_state = "l6closedmag"
	max_shells = 75
	allowed_magazines = list(/obj/item/ammo_magazine/box/rifle/military/m60)
	magazine_type = /obj/item/ammo_magazine/box/rifle/military/m60
	ammo_type = /obj/item/ammo_casing/rifle/military
	one_hand_penalty = 6
	wielded_item_state = "genericLMG-wielded"
	caliber = CALIBER_RIFLE_MILITARY

/obj/item/gun/projectile/automatic/l6_saw/m60/on_update_icon()
	icon_state = "M60[cover_open ? "open" : "closed"][ammo_magazine ? round(length(ammo_magazine.stored_ammo), 15) : "-empty"]"

/obj/item/ammo_magazine/box/rifle/military/m60
	name = "M60 magazine box"
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "M60MAG"
	max_ammo = 75
	multiple_sprites = 0

/obj/item/ammo_magazine/box/rifle/military/m60/empty
	initial_ammo = 0

/obj/item/gun/projectile/automatic/m14
	item_icons = DEF_URIST_INHANDS
	name = "\improper M14 Rifle"
	desc = "A selective-fire rifle for when you need more stopping power. Has a 15-round magazine of 7.62mm. Unlike the M16s that have the ability to fire in bursts or semi-auto, the M14 can only fire in either long bursts or semi-auto."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "M14"
	item_state = "arifle"
	w_class = 4
	force = 10
	caliber = CALIBER_RIFLE_MILITARY
	origin_tech = "combat=6;materials=1;syndicate=2"
	slot_flags = SLOT_BACK
	ammo_type = /obj/item/ammo_casing/rifle/military
	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/rifle/military/m14
	one_hand_penalty = 4
	wielded_item_state = "woodarifle-wielded"

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

/obj/item/ammo_magazine/rifle/military/m14
	name = "M14 magazine box"
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "M14MAG"
	max_ammo = 15

/obj/item/ammo_magazine/rifle/military/m14/empty
	initial_ammo = 0

/obj/item/gun/projectile/automatic/m16
	item_icons = DEF_URIST_INHANDS
	name = "\improper M16 Assault Rifle"
	desc = "25 rounds of 5.56mm. Staple rifle for the Nanotrasen Servicemen. A 2557AD spin on the classic rifle."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "M16"
	item_state = "arifle"
	w_class = 4
	force = 10
	caliber = CALIBER_RIFLE
	origin_tech = "combat=6;materials=1;syndicate=4"
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	allowed_magazines = list(/obj/item/ammo_magazine/rifle/m16)
	magazine_type = /obj/item/ammo_magazine/rifle/m16
	ammo_type = /obj/item/ammo_casing/rifle
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

/obj/item/ammo_magazine/rifle/m16
	name = "M16 magazine"
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "M16MAG"
	max_ammo = 25

/obj/item/ammo_magazine/rifle/m16/empty
	initial_ammo = 0

/obj/item/gun/projectile/shotgun/pump/combat/ithaca
	name = "Ithaca 37 combat shotgun"
	desc = "A standard Nanotrasen combat shotgun. Holds 7 rounds (8 with one in the chamber). Pump-action, it's perfect for CQB and tight hallway clearing."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "ithaca"

/obj/item/gun/projectile/automatic/m3
	item_icons = DEF_URIST_INHANDS
	name = "M3 Grease Gun"
	desc = "The submachine gun for medical personnel and infantrymen. Only fires in short and long bursts. Takes magazines of 32 rounds."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "M3"
	item_state = "mpistolen"
	wielded_item_state = "mpistolen"
	w_class = 3
	force = 10
	caliber = CALIBER_PISTOL
	origin_tech = "combat=6;materials=1;syndicate=4"
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/pistol/m3
	one_hand_penalty = 1
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	firemodes = list(
		list(mode_name="short bursts",	burst=4, fire_delay=null, move_delay=6, one_hand_penalty = 2, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="long bursts",	burst=8, fire_delay=null, move_delay=8, one_hand_penalty = 3, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/projectile/automatic/m3/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "M3"
	else
		icon_state = "M3-empty"
	return

/obj/item/ammo_magazine/pistol/m3
	name = "M3 magazine"
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "M3MAG"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/pistol
	matter = list(DEFAULT_WALL_MATERIAL = 525) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = CALIBER_PISTOL
	max_ammo = 32

/obj/item/ammo_magazine/pistol/m3/empty
	initial_ammo = 0

/obj/item/gun/projectile/bhp9mm
	name = "\improper Browning HP pistol"
	desc = "The NCO's sidearm. 15 rounds, almost double the usual capacity. May be issued to medical units as well."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "brownhp"
	item_state = "pistol"
	w_class = 2
	caliber = CALIBER_PISTOL_SMALL
	origin_tech = "combat=2;materials=2;syndicate=2"
	fire_sound = 'sound/weapons/gunshot/Gunshot_pistol.ogg'
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/pistol/bhp

/obj/item/gun/projectile/bhp9mm/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "brownhp"
	else
		icon_state = "brownhp-empty"
	return

/obj/item/ammo_magazine/pistol/bhp
	icon = 'icons/urist/items/guns.dmi'
	name = "Browning HP magazine"
	icon_state = "BROWNHPMAG"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 15

/obj/item/ammo_magazine/pistol/bhp/empty
	initial_ammo = 0

//adminfuckery gun slash proof of concept
/obj/item/gun/projectile/automatic/shotmachinegun
	item_icons = DEF_URIST_INHANDS
	name = "Shotmachinegun"
	desc = "A product of a warped imagination, a fully automatic machine-shotgun."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "M60closed75"
	item_state = "M60closed"
	caliber = CALIBER_SHOTGUN
	max_shells = 75
	allowed_magazines = list(/obj/item/ammo_magazine/shotmachinegun)
	magazine_type = /obj/item/ammo_magazine/shotmachinegun
	one_hand_penalty = 6
	wielded_item_state = "genericLMG-wielded"
	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'
	load_method = MAGAZINE
	firemodes = list(
		list(mode_name="short bursts",	burst=5, move_delay=12, one_hand_penalty=8, burst_accuracy = list(0,-1,-1,-2,-2),          dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="long bursts",	burst=8, move_delay=15, one_hand_penalty=9, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/ammo_magazine/shotmachinegun
	caliber = CALIBER_SHOTGUN
	ammo_type = /obj/item/ammo_casing/shotgun
	initial_ammo = 75
	matter = list(DEFAULT_WALL_MATERIAL = 1200)
	mag_type = MAGAZINE
	multiple_sprites = 0

/obj/item/gun/projectile/manualcycle
	var/bolt_open = 0

/obj/item/gun/projectile/manualcycle/on_update_icon()
	..()
	if(bolt_open)
		icon_state = "[initial(icon_state)]_alt"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/gun/projectile/manualcycle/attack_self(mob/user as mob)
	playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
	bolt_open = !bolt_open
	if(bolt_open)
		if(chambered)
			to_chat(user, "<span class='notice'>You work the bolt open, ejecting [chambered]!</span>")
			chambered.loc = get_turf(src)
			loaded -= chambered
			chambered = null
		else
			to_chat(user, "<span class='notice'>You work the bolt open.</span>")
	else
		to_chat(user, "<span class='notice'>You work the bolt closed.</span>")
		bolt_open = 0
	add_fingerprint(user)
	update_icon()

/obj/item/gun/projectile/manualcycle/special_check(mob/user)
	if(bolt_open)
		to_chat(user, "<span class='warning'>You can't fire [src] while the bolt is open!</span>")
		return 0
	return ..()

/obj/item/gun/projectile/manualcycle/load_ammo(obj/item/A, mob/user)
	if(!bolt_open)
		return
	..()

/obj/item/gun/projectile/manualcycle/unload_ammo(mob/user, allow_dump=1)
	if(!bolt_open)
		return
	..()

/obj/item/gun/projectile/manualcycle/imprifle
	item_icons = URIST_ALL_ONMOBS
	name = "improvised rifle"
	icon = 'icons/urist/items/guns.dmi'
	desc = "A shoddy 7.62 improvised rifle."
	wielded_item_state = "woodarifle-wielded"
	icon_state = "308bolt"
	item_state = "dshotgun" //placeholder
	w_class = 5
	one_hand_penalty = 4
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = "combat=2;materials=1"
	caliber = CALIBER_RIFLE_MILITARY
	//fire_sound = 'sound/weapons/sniper.ogg'
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 3
	ammo_type = /obj/item/ammo_casing/rifle/military
	accuracy = -1


/obj/item/gun/projectile/manualcycle/imprifle/impriflesawn
	item_icons = URIST_ALL_ONMOBS
	name = "improvised short rifle"
	icon = 'icons/urist/items/guns.dmi'
	desc = "A crudely cut down 7.62 improvised rifle."
	icon_state = "308boltsawed"
	item_state = "sawnshotgun" //placeholder
	w_class = 4
	one_hand_penalty = 0
	force = 4
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	origin_tech = "combat=1"
	caliber = CALIBER_RIFLE_MILITARY
	//fire_sound = 'sound/weapons/sniper.ogg'
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 3
	ammo_type = /obj/item/ammo_casing/rifle/military
	accuracy = -2

//rifle construction

/obj/item/imprifleframe/imprifleframesawn
	name = "unfinished improvised short rifle"
	desc = "An almost-complete improvised short rifle."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "308boltsawed"
	item_state = "sawnshotgun"

/obj/item/imprifleframe
	name = "improvised rifle stock"
	desc = "A half-finished improvised rifle."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "308boltframe0"
	item_state = "sawnshotgun"
	var/buildstate = 0

/obj/item/imprifleframe/on_update_icon()
	icon_state = "308boltframe[buildstate]"

/obj/item/imprifleframe/examine(mob/user)
	..(user)
	switch(buildstate)
		if(1) to_chat(user, "It has an unfinished pipe barrel in place on the wooden furniture.")
		if(2) to_chat(user, "It has an unfinished pipe barrel wired in place.")
		if(3) to_chat(user, "It has an unfinished reinforced pipe barrel wired in place.")
		if(4) to_chat(user, "It has a reinforced pipe barrel secured on the wooden furniture.")
		if(5) to_chat(user, "It has an unsecured reciever in place.")
		if(6) to_chat(user, "It has a secured reciever in place.")
		if(7) to_chat(user, "It has an unfinished pipe bolt in place.")
		if(8) to_chat(user, "It has a finished unsecured pipe bolt in place.")
		if(9) to_chat(user, "It has a finished secured bolt in place.")

/obj/item/imprifleframe/use_tool(obj/item/W, mob/living/user, list/click_params)
	switch(buildstate)
		if(0)
			if(istype(W,/obj/item/gunsmith/barrel/long))
				var/obj/item/gunsmith/gun2/long/I = new()
				I.forceMove(get_turf(src))
				to_chat(user, "You put the barrel onto the stock.")
				qdel(W)
				qdel(src)
			if(istype(W,/obj/item/gunsmith/barrel/short))
				var/obj/item/gunsmith/gun2/short/I = new()
				I.forceMove(get_turf(src))
				to_chat(user, "You put the barrel onto the stock.")
				qdel(W)
				qdel(src)
			if(istype(W,/obj/item/pipe))
				user.drop_from_inventory(W)
				qdel(W)
				to_chat(user, "<span class='notice'>You place the piping on the stock.</span>")
				buildstate++
				update_icon()
			return TRUE
		if(1)
			if(istype(W,/obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = W
				if(C.use(10))
					to_chat(user, "<span class='notice'>You secure the barrel to the wooden furniture with wire.</span>")
					buildstate++
					update_icon()
				else
					to_chat(user, "<span class='notice'>You need at least ten segments of cable coil to complete this task.</span>")
			return TRUE
		if(2)
			if(istype(W,/obj/item/screwdriver))
				to_chat(user, "<span class='notice'>You further secure the barrel to the wooden furniture.</span>")
				buildstate++
				playsound(src.loc, 'sound/items/Screwdriver2.ogg', 100, 1)
			return TRUE
		if(3)
			if(istype(W,/obj/item/stack/material) && W.get_material_name() == "plasteel")
				var/obj/item/stack/material/P = W
				if(P.use(5))
					to_chat(user, "<span class='notice'>You reinforce the barrel with plasteel.</span>")
					buildstate++
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 100, 1)
				else
					to_chat(user, "<span class='notice'>You need at least five plasteel sheets to complete this task.</span>")
			return TRUE
		if(4)
			if(istype(W,/obj/item/wrench))
				to_chat(user, "<span class='notice'>You secure the reinforced barrel.</span>")
				buildstate++
				playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			return TRUE
		if(5)
			if(istype(W,/obj/item/stack/material) && W.get_material_name() == DEFAULT_WALL_MATERIAL)
				var/obj/item/stack/material/P = W
				if(P.use(10))
					to_chat(user, "<span class='notice'>You assemble and install a metal reciever onto the frame</span>")
					buildstate++
					update_icon()
					playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
			else
				to_chat(user, "<span class='notice'>You need at least ten steel sheets to complete this task.</span>")
			return TRUE
		if(6)
			if(istype(W,/obj/item/screwdriver))
				to_chat(user, "<span class='notice'>You secure the metal reciever.</span>")
				buildstate++
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
			return TRUE
		if(7)
			if(istype(W,/obj/item/pipe))
				user.drop_from_inventory(W)
				qdel(W)
				to_chat(user, "<span class='notice'>You install a bolt on the frame.</span>")
				buildstate++
				playsound(src.loc, 'sound/items/syringeproj.ogg', 100, 1)
				update_icon()
			return TRUE
		if(8)
			if(istype(W,/obj/item/stack/material/rods))
				var/obj/item/stack/material/rods/R = W
				if(R.use(3))
					to_chat(user, "<span class='notice'>You attach the rods to the bolt.</span>")
					buildstate++
					playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
				else
					to_chat(user, "<span class='notice'>You need at least 3 rods to complete this task.</span>")
			return TRUE
		if(9)
			if(istype(W,/obj/item/weldingtool))
				var/obj/item/weldingtool/T = W
				if(T.remove_fuel(5,user))
					if(!src || !T.isOn()) return
					playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
				to_chat(user, "<span class='notice'>You secure the improvised rifle's various parts.</span>")
				var/obj/item/gun/projectile/manualcycle/imprifle/emptymag = new /obj/item/gun/projectile/manualcycle/imprifle(get_turf(src))
				emptymag.loaded = list()
				qdel(src)
				return TRUE
			if(istype(W,/obj/item/circular_saw))
				to_chat(user, "<span class='notice'>You saw the barrel on the unfinished improvised rifle down.</span>")
				new /obj/item/imprifleframe/imprifleframesawn(get_turf(src))
				playsound(src.loc, 'sound/weapons/circsawhit.ogg', 100, 1)
				qdel(src)
			return TRUE
	return ..()

/obj/item/imprifleframe/imprifleframesawn/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W,/obj/item/weldingtool))
		if(buildstate == 0)
			var/obj/item/weldingtool/T = W
			if(T.remove_fuel(5,user))
				if(!src || !T.isOn()) return
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
			to_chat(user, "<span class='notice'>You secure the improvised rifle's various parts.</span>")
			var/obj/item/gun/projectile/manualcycle/imprifle/impriflesawn/emptymag = new /obj/item/gun/projectile/manualcycle/imprifle/impriflesawn(get_turf(src))
			emptymag.loaded = list()
			qdel(src)
		return TRUE
	return ..()
/*
/obj/item/gun/projectile/revolver/shotrevolver
	name = "shot revolver"
	desc = "The Lumoco Arms HE Colt is a choice revolver for when you absolutely, positively need to put a hole in the other guy. Uses .357 ammo."
	icon_state = "revolver"
	item_state = "revolver"
	caliber = "shotgun"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 1)
	handle_casings = CYCLE_CASINGS
	max_shells = 4
	ammo_type = /obj/item/ammo_casing/shotgun


/obj/item/gun/projectile/revolver/shotrevolver/consume_next_projectile()
	if(chamber_offset)
		chamber_offset--
		return
	return ..()

/obj/item/gun/projectile/revolver/shotrevolver/load_ammo(obj/item/A, mob/user)
	chamber_offset = 0
	return ..()
*/

/obj/item/gun/projectile/manualcycle/mosinnagant
	item_icons = DEF_URIST_INHANDS
	name = "Mosin-Nagant"
	icon = 'icons/urist/items/guns.dmi'
	desc = "The standard bolt action rifle of the Red Army. The glorious Soviet Moist Nugget is chambered in 7.62 and holds 5 rounds, fed by a stripper clip."
	wielded_item_state = "rifle2"
	icon_state = "huntrifle"
	item_state = "rifle2" //maybe change this
	w_class = 5
	one_hand_penalty = 4
	force = 10
	slot_flags = SLOT_BACK
	caliber = CALIBER_RIFLE_MILITARY
	handle_casings = HOLD_CASINGS
//	load_method = SINGLE_CASING
	max_shells = 5
	ammo_type = /obj/item/ammo_casing/rifle/military
//	accuracy = -1
//	jam_chance = 5
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
/*
/obj/item/gun/projectile
	name = ""
	desc = ""
	icon = 'icons/urist/items/guns.dmi'
	icon_state = ""
	caliber = "pistol"
	ammo_type = /obj/item/ammo_casing/pistol
*/


//nerva guns

/obj/item/gun/projectile/automatic/spaceak
	item_icons = DEF_URIST_INHANDS
	name = "\improper U2442 Assault Rifle"
	desc = "A bullpup assault rifle loosely based on the AK-47. Originally manufactured by the USSSR, the design has since become popular among pirates and traders for its affordability, reliability and ease of use."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "sexyrifle"
	item_state = "sexyrifle"
	w_class = 4
	force = 10
	caliber = CALIBER_RIFLE_MILITARY
	origin_tech = "combat=4;materials=1;syndicate=1"
	slot_flags = SLOT_BACK
	ammo_type = /obj/item/ammo_casing/rifle/military
	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/rifle/military/spaceak
	allowed_magazines = list(/obj/item/ammo_magazine/rifle/military/spaceak)
	one_hand_penalty = 6
	wielded_item_state = "sexyrifle-wielded"

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, one_hand_penalty = 4, move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="short bursts", 	burst=5, move_delay=6, fire_delay=null, one_hand_penalty = 3, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="long bursts",	burst=8, fire_delay=null, move_delay=8, one_hand_penalty = 3, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/projectile/automatic/spaceak/on_update_icon()
	..()
	if(ammo_magazine && length(ammo_magazine.stored_ammo))
		icon_state = "sexyrifle"
	else
		icon_state = "sexyrifle_empty"
	return

/obj/item/ammo_magazine/rifle/military/spaceak
	name = "U2442 magazine box"
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "sexyrifle-mag"
	max_ammo = 30

/obj/item/gun/projectile/automatic/spaceak/gold
	item_icons = DEF_URIST_INHANDS
	name = "\improper Gold Plated U2442 Assault Rifle"
	desc = "A bullpup assault rifle loosely based on the AK-47. Originally manufactured by the USSSR, the design has since become popular among pirates and traders for its affordability, reliability and ease of use. This one has been in the hands of someone with incredibly tacky tastes."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "goldspaceak"
	item_state = "goldspaceak"
	wielded_item_state = "goldspaceak-wielded"

/obj/item/gun/projectile/automatic/spaceak/gold/on_update_icon()
	if(ammo_magazine?.stored_ammo.len)
		icon_state = "goldspaceak"
	else
		icon_state = "goldspaceak-empty"

/obj/item/gun/projectile/automatic/hi2521smg
	item_icons = DEF_URIST_INHANDS
	name = "\improper HI-2521-SMG"
	desc = "A light, compact bullpup SMG chambered in 9mm with a sleek design. Manufactured by Hephaestus Industries as part of the 2521 series, this model is a relatively recent design, popular among wealthier spacers."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "combatSMG"
	item_state = "combatSMG"
	wielded_item_state = "combatSMG"
	w_class = 3
	force = 10
	caliber = CALIBER_PISTOL_SMALL
	origin_tech = "combat=4;materials=1;syndicate=1"
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/hi2521smg9mm/rubber
	allowed_magazines = /obj/item/ammo_magazine/hi2521smg9mm
	one_hand_penalty = 3
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	jam_chance = 0

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, one_hand_penalty = 1, move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, move_delay=6, fire_delay=null, one_hand_penalty = 2, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.0, 0.6, 0.6)),
		list(mode_name="short bursts", 	burst=5, move_delay=6, fire_delay=null, one_hand_penalty = 3, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/projectile/automatic/hi2521smg/on_update_icon()
	..()
	if(ammo_magazine && length(ammo_magazine.stored_ammo))
		icon_state = "combatSMG"
	else
		icon_state = "combatSMG_empty"

/obj/item/ammo_magazine/hi2521smg9mm
	name = "HI-2521-SMG magazine"
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "combatSMG-mag"
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL_SMALL
	origin_tech = "combat=2"
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 15
	multiple_sprites = 1

/obj/item/ammo_magazine/hi2521smg9mm/empty
	initial_ammo = 0

/obj/item/gun/projectile/revolver/coltsaa
	icon = 'icons/urist/items/guns.dmi'
	item_icons = DEF_URIST_INHANDS
	name = "Colt Single Action Army"
	desc = "An antique Colt Single Action Army revolver dating from the late 19th century. Sometimes referred to as 'the gun that won the west,' this piece is the pride and joy of any 26th century gun collector."
	icon_state = "antiquerevolver"
	item_state = "antiquerevolver"
	wielded_item_state = "antiquerevolver"
	max_shells = 6
	caliber = CALIBER_PISTOL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	ammo_type = /obj/item/ammo_casing/pistol

/obj/item/gun/projectile/revolver/coltsaa/on_update_icon()
	..()
	if(length(loaded))
		icon_state = "antiquerevolver"
	else
		icon_state = "antiquerevolver_empty"

/obj/item/ammo_magazine/a45r
	name = "speed loader"
	desc = "A speed loader for revolvers."
	icon = 'icons/urist/items/ammo.dmi'
	icon_state = "38"
	ammo_type = /obj/item/ammo_casing/pistol
	matter = list(DEFAULT_WALL_MATERIAL = 450)
	caliber = CALIBER_PISTOL
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/a45r/rubber
	name = "speed loader (rubber)"
	icon_state = "R38"
	ammo_type = /obj/item/ammo_casing/pistol/rubber

/obj/item/gun/projectile/revolver/hi2521r
	icon = 'icons/urist/items/guns.dmi'
	item_icons = DEF_URIST_INHANDS
	name = "HI-2521-R revolver"
	desc = "A sleek modern revolver manufactured by Hephaestus Industries as part of the 2521 series."
	icon_state = "combatrevolver"
	item_state = "combatrevolver"
	wielded_item_state = "combatrevolver"
	max_shells = 6
	caliber = CALIBER_PISTOL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	ammo_type = /obj/item/ammo_casing/pistol

/obj/item/gun/projectile/revolver/hi2521r/on_update_icon()
	..()
	if(length(loaded))
		icon_state = "combatrevolver"
	else
		icon_state = "combatrevolver_empty"

/obj/item/gun/projectile/hi2521pistol
	item_icons = URIST_ALL_ONMOBS
	name = "\improper HI-2521-P pistol"
	desc = "A light, compact pistol chambered in 9mm with a sleek design. Manufactured by Hephaestus Industries as part of the 2521 series, this model is a relatively recent design, popular among wealthier spacers."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "crewpistol"
	item_state = "crewpistol"
	wielded_item_state = "crewpistol"
	w_class = 2
	caliber = CALIBER_PISTOL_SMALL
	origin_tech = "combat=2;materials=2;syndicate=1"
	slot_flags = SLOT_BELT | SLOT_HOLSTER
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/hi2521pistol9mm
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'

/obj/item/gun/projectile/hi2521pistol/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "crewpistol-[round(length(ammo_magazine.stored_ammo), 2)]"
		item_state = "crewpistol-[round(length(ammo_magazine.stored_ammo), 2)]"
		wielded_item_state = "crewpistol-[round(length(ammo_magazine.stored_ammo), 2)]"
	else
		icon_state = "crewpistol-empty"
		item_state = "crewpistol-0"
		wielded_item_state = "crewpistol-0"

/obj/item/ammo_magazine/hi2521pistol9mm
	name = "HI-2521-P pistol magazine"
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "crewpistol-mag"
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL_SMALL
	origin_tech = "combat=2"
	matter = list(DEFAULT_WALL_MATERIAL = 600)
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 10
	multiple_sprites = 1

/obj/item/gun/energy/taser/old
	name = "antique taser"
	desc = "An old model taser. They don't make 'em like they used to"
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "taser"
	max_shots = 8

/obj/item/gun/energy/laser/old
	name = "vintage laser carbine"
	desc = "a pre-Crisis model laser carbine formerly deployed broadly by human forces."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "oldlaser"

/obj/item/ammo_magazine/speedloader/broomstick
	name = "broomstick stripper clip"
	desc = "A stripper clip for antique broomstick pistols."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "broomclip"
	caliber = CALIBER_PISTOL_SMALL
	ammo_type = /obj/item/ammo_casing/pistol/small
	matter = list(MATERIAL_STEEL = 1300)
	max_ammo = 10
	multiple_sprites = 1
