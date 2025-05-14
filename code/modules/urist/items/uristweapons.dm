/*										*****New space to put all UristMcStation Weapons*****

Please keep it tidy, by which I mean put comments describing the item before the entry.  -Glloyd */


//Welder machete, icons by ShoesandHats, object by Cozarctan

/obj/item/material/sword/machete
	item_icons = DEF_URIST_INHANDS
	name = "machete"
	desc = "a large blade beloved by sugar farmers and mass murderers"
	icon = 'icons/urist/weapons/melee_physical.dmi'
	icon_state = "machete"
	item_state = "machete"
	sharp = 1
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT | SLOT_BACK
	force_multiplier = 0.34 // 20-ish when wielded with hardness 60 (steel), same as before
	thrown_force_multiplier = 0.5 // 10 when thrown with weight 20 (steel)
	w_class = 3
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("cleaved", "slashed", "sliced", "torn", "ripped", "diced", "cut")

//dual saber proc

/obj/item/melee/energy/sword/use_tool(obj/item/tool, mob/living/user, list/click_params)
	if(!istype(tool, /obj/item/melee/energy/sword))
		return ..()

	if(tool == src)
		to_chat(user, SPAN_NOTICE("You try to attach the end of the energy sword to... itself. You're not very smart, are you?"))
		if(ishuman(user))
			user.adjustBrainLoss(10)
		return TRUE

	to_chat(user, SPAN_NOTICE("You attach the ends of the two energy swords, making a single double-bladed weapon! You're cool."))

	// This is straight-up spaghetti from hell.
	if(src.blade_color == "red")
		if(istype(tool, /obj/item/melee/energy/sword/blue))
			new /obj/item/melee/energy/sword/dualsaber/purple(user.loc)
		else if(istype(tool, /obj/item/melee/energy/sword/yellow))
			new /obj/item/melee/energy/sword/dualsaber/orange(user.loc)
		else
			new /obj/item/melee/energy/sword/dualsaber/red(user.loc)

	if(src.blade_color == "blue")
		if(istype(tool, /obj/item/melee/energy/sword/red))
			new /obj/item/melee/energy/sword/dualsaber/purple(user.loc)
		else if(istype(tool, /obj/item/melee/energy/sword/yellow))
			new /obj/item/melee/energy/sword/dualsaber/green(user.loc)
		else
			new /obj/item/melee/energy/sword/dualsaber/blue(user.loc)

	if(src.blade_color == "yellow")
		if(istype(tool, /obj/item/melee/energy/sword/red))
			new /obj/item/melee/energy/sword/dualsaber/orange(user.loc)
		else if(istype(tool, /obj/item/melee/energy/sword/blue))
			new /obj/item/melee/energy/sword/dualsaber/green(user.loc)
		else
			new /obj/item/melee/energy/sword/dualsaber/yellow(user.loc)

	if(src.blade_color == "green")
		new /obj/item/melee/energy/sword/dualsaber/green(user.loc)

	if(src.blade_color == "purple")
		new /obj/item/melee/energy/sword/dualsaber/purple(user.loc)

	if(src.blade_color == "orange")
		new /obj/item/melee/energy/sword/dualsaber/orange(user.loc)

	if(src.blade_color == "black")
		new /obj/item/melee/energy/sword/dualsaber(user.loc)

	user.remove_from_mob(tool)
	user.remove_from_mob(src)
	qdel(tool)
	qdel(src)

//misc melee weapons

/obj/item/material/knife/hook
	name = "meat hook"
	desc = "A sharp, metal hook what sticks into things."
	icon = 'icons/urist/weapons/melee_physical.dmi'
	icon_state = "hook_knife"
	item_state = "hook_knife"

/obj/item/material/sword/urist
	icon = 'icons/urist/weapons/melee_physical.dmi'

/obj/item/material/sword/urist/basic
	name = "sword"
	icon_state = "longsword"

/obj/item/material/sword/urist/gladius
	name = "gladius"
	desc = "Are you not entertained!?"
	icon_state = "gladius"

/obj/item/material/sword/urist/khopesh
	name = "khopesh"
	icon_state = "khopesh"
	item_state = "katana"

/obj/item/material/sword/urist/sabre
	name = "sabre"
	icon_state = "sabre"
	item_state = "katana"

/obj/item/material/sword/urist/dao
	name = "dao"
	icon_state = "dao"
	item_state = "katana"

/obj/item/material/sword/urist/rapier
	name = "rapier"
	desc = "En guarde!"
	icon_state = "rapier"
	item_state = "katana"

/obj/item/material/sword/urist/trench
	name = "trench knife"
	icon_state = "trench"
	item_state = "katana"

//bow and arrow shit

/obj/item/arrow/improv
	name = "improvised arrow"
	desc = "It's a shitty improvised arrow. It has a wooden shaft and a makeshift glass arrowhead."
	icon = 'icons/urist/guns/ammo.dmi'
	icon_state = "improvarrow"
	item_state = "bolt"
	throwforce = 7
	w_class = 3.0
	sharp = 1
	edge = 0
	lock_picking_level = 1

/obj/item/arrow/woodarrow
	name = "arrow"
	desc = "It's a regular arrow, wooden shaft, metal arrowhead. You get the deal."
	icon = 'icons/urist/guns/ammo.dmi'
	icon_state = "arrow"
	item_state = "bolt"
	throwforce = 8
	w_class = 3.0
	sharp = 1
	edge = 0
	lock_picking_level = 2

/obj/item/gun/launcher/crossbow/bow
	name = "wooden bow"
	desc = "The age old design for when you don't want to get hit."
	icon = 'icons/urist/guns/bow.dmi'
	icon_state = "bow"
	item_icons = DEF_URIST_INHANDS
	draw_time = 1 SECOND

/obj/item/gun/launcher/crossbow/bow/use_tool(obj/item/tool, mob/user, list/click_params)
	// Full override of crossbow to disallow creating heated arrows or RXDs.
	// Arrow - Load ammo
	if (istype(tool, /obj/item/arrow))
		if (bolt)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [bolt] loaded.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		bolt = tool
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] slides \a [bolt] into \a [src]."),
			SPAN_NOTICE("You slide \the [bolt] into \the [src].")
		)
		return TRUE
	if (istype(tool, /obj/item/stack/material/rods) || istype(tool, /obj/item/rcd) || istype(tool, /obj/item/cell))
		return TRUE

	return ..()

//RS Weapons

/obj/item/urist/blade
	sharp = 1
	edge = 1
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/urist/blade/bronzedagger
	name = "Bronze Dagger"
	desc = "Short but pointy."
	icon = 'icons/urist/weapons/melee_physical.dmi'
	icon_state = "bronze_dagger"
	item_state = "knife"
	force = 12
	throwforce = 5
	w_class = 2.0


/obj/item/urist/blade/addydagger
	name = "Adamantite Dagger"
	desc = "Short but pointy."
	icon = 'icons/urist/weapons/melee_physical.dmi'
	icon_state = "green_dagger"
	item_state = "knife"
	force = 20
	throwforce = 9
	w_class = 2.0


/obj/item/urist/blade/runedagger
	name = "Runite Dagger"
	desc = "Short but pointy."
	icon = 'icons/urist/weapons/melee_physical.dmi'
	icon_state = "blue_dagger"
	item_state = "knife"
	force = 27
	throwforce = 15
	w_class = 2.0

/obj/item/urist/blade/bronzesword
	name = "Bronze Sword"
	desc = "A razor sharp sword."
	icon = 'icons/urist/weapons/melee_physical.dmi'
	icon_state = "bronze_sword"
	item_state = "claymore"
	force = 15
	throwforce = 9
	w_class = 4.0
	slot_flags = SLOT_BELT|SLOT_BACK

/obj/item/urist/blade/addysword
	name = "Adamantite  Sword"
	desc = "A razor sharp sword."
	icon = 'icons/urist/weapons/melee_physical.dmi'
	icon_state = "green_sword"
	item_state = "claymore"
	force = 30
	throwforce = 15
	w_class = 4.0
	slot_flags = SLOT_BELT|SLOT_BACK


/obj/item/urist/blade/runesword
	name = "Runeite Sword"
	desc = "A razor sharp sword."
	icon = 'icons/urist/weapons/melee_physical.dmi'
	icon_state = "blue_sword"
	item_state = "claymore"
	force = 50
	throwforce = 20
	w_class = 4.0
	slot_flags = SLOT_BELT|SLOT_BACK

//a simple crutch, with a more medical look then the gentleman's cane

/obj/item/cane/crutch
	name ="crutch"
	desc = "A long stick with a crosspiece at the top, used to help with walking."
	icon = 'icons/urist/weapons/melee_physical.dmi'
	item_icons = list(
			slot_l_hand_str = 'icons/uristmob/items_lefthand.dmi',
			slot_r_hand_str = 'icons/uristmob/items_righthand.dmi',
		)
	icon_state = "crutch"
	item_state = "crutch"

//a white cane for the blind or visually impared

/obj/item/cane/white
	name = "white cane"
	desc = "A white cane. They are commonly used by the blind or visually impaired as a mobility tool or as a courtesy to others."
	icon = 'icons/urist/weapons/melee_physical.dmi'
	item_icons = list(
			slot_l_hand_str = 'icons/uristmob/items_lefthand.dmi',
			slot_r_hand_str = 'icons/uristmob/items_righthand.dmi',
		)
	icon_state = "whitecane"
	item_state = "whitecane"

//the code for tapping someone with the cane

/obj/item/cane/white/use_before(atom/target, mob/user, click_params)
	var/mob/M = target
	if(istype(M) && user.a_intent == I_HELP)
		user.visible_message("<span class='notice'>\The [user] has lightly tapped [M] on the ankle with their white cane!</span>")
		return TRUE


//a telescopic white cane, click on it in hand to extend and retract it
//Code for Telescopic White Cane writen by Gozulio

/obj/item/cane/white/collapsible
	name = "telescopic white cane"
	desc = "A telescopic white cane. They are commonly used by the blind or visually impaired as a mobility tool or as a courtesy to others."
	icon = 'icons/urist/weapons/melee_physical.dmi'
	icon_state = "whitecane1in"
	item_state = "whitecanein"
	item_icons = list(
			slot_l_hand_str = 'icons/uristmob/items_lefthand.dmi',
			slot_r_hand_str = 'icons/uristmob/items_righthand.dmi',
		)
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	force = 3
	var/on = 0

//the code to make the cane extend and retract

/obj/item/cane/white/collapsible/attack_self(mob/user as mob)
	on = !on
	if(on)
		user.visible_message("<span class='notice'>\The [user] extends the white cane.</span>",\
				"<span class='warning'>You extend the white cane.</span>",\
				"You hear an ominous click.")
		icon = 'icons/urist/weapons/melee_physical.dmi'
		icon_state = "whitecane1out"
		item_state_slots = list(slot_r_hand_str = "whitecane", slot_l_hand_str = "whitecane")
		w_class = ITEM_SIZE_NORMAL
		force = 5
		attack_verb = list("smacked", "struck", "cracked", "beaten")
	else
		user.visible_message("<span class='notice'>\The [user] collapses the white cane.</span>",\
		"<span class='notice'>You collapse the white cane.</span>",\
		"You hear a click.")
		icon_state = "whitecane1in"
		item_state_slots = list(slot_r_hand_str = "whitecanein", slot_l_hand_str = "whitecanein")
		w_class = ITEM_SIZE_SMALL
		force = 3
		attack_verb = list("hit", "poked", "prodded")

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
	add_fingerprint(user)
	return TRUE

//nerva knife needed to not be called master at arms
/obj/item/material/knife/folding/swiss/sec/nerva
	name = "security officer's combi-knife"
