//tools for carpentry. Hand tools.

/obj/item/weapon/carpentry
	item_icons = DEF_URIST_INHANDS
	icon = 'icons/urist/items/tools.dmi'

/obj/item/weapon/carpentry/saw
	name = "carpenter's saw"
	desc = "A one person crosscut saw, used for sawing logs into reasonable lengths."
	icon_state = "saw"
	item_state = "saw"
	edge = 1
	w_class = 3.0
	force = 8
	throwforce = 2
	attack_verb = list("cut", "sawed")
	matter = list(DEFAULT_WALL_MATERIAL = 1000, "wood" = 500)

/obj/item/weapon/carpentry/axe
	name = "woodsman's axe"
	desc = "A heavy axe designed for chopping down large trees."
	icon_state = "axe"
	item_state = "axe"
	sharp = 1
	edge = 1
	force = 15 //carpenters op plz nerf //this high because carpenters will need to defend themselves too
	throwforce = 5
	attack_verb = list("slashed", "cut", "chopped", "hacked")
	w_class = 3 //changing to 3 because why not
	matter = list(DEFAULT_WALL_MATERIAL = 2000, "wood" = 1000)

//hunter stuff

//huntergun

/obj/item/weapon/gun/projectile/manualcycle/hunterrifle
	item_icons = DEF_URIST_INHANDS
	name = "hunting rifle"
	icon = 'icons/urist/items/guns.dmi'
	desc = "A standard issue Nanotrasen bolt-action rifle for its crew serving on hostile planetary environments."
	wielded_item_state = "huntrifle2"
	icon_state = "huntrifle"
	item_state = "huntrifle"
	w_class = 5
	requires_two_hands = 4
	force = 10
	slot_flags = SLOT_BACK
	caliber = "a762"
	handle_casings = HOLD_CASINGS
//	load_method = SINGLE_CASING
	max_shells = 5
	ammo_type = /obj/item/ammo_casing/a762
//	accuracy = -1
//	jam_chance = 5
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	var/scoped = 0

/obj/item/weapon/gun/projectile/manualcycle/hunterrifle/attackby(obj/item/I, mob/user) //i really need to make a partent class for guns that can be modified, but right now it's only the one so fuck it. //GlloydTODO
	..()

	if(istype(I, /obj/item/weapon/gunattachment/scope/huntrifle) && !scoped)
		to_chat(user, "<span class='notice'>You attach the scope to the rifle.</span>")
		scoped = 1
		icon_state = "scopedhuntrifle"
		item_state = "scopedhuntrifle"
		wielded_item_state = "scopedhuntrifle2"
		update_icon()
		user.remove_from_mob(I)
		qdel(I)

	else if(istype(I, /obj/item/weapon/wrench) && scoped)
		to_chat(user, "<span class='notice'>You remove the scope from the rifle.</span>")
		scoped = 0
		wielded_item_state = "huntrifle2"
		icon_state = "huntrifle"
		item_state = "huntrifle"
		update_icon()
		new /obj/item/weapon/gunattachment/scope/huntrifle(user.loc)

/obj/item/weapon/gun/projectile/manualcycle/hunterrifle/update_icon()
	if(scoped)
		if(bolt_open)
			icon_state = "scopedhuntrifle_alt"
		else
			icon_state = "scopedhuntrifle"

	else if(!scoped)
		if(bolt_open)
			icon_state = "huntrifle_alt"
		else
			icon_state = "huntrifle"

/obj/item/weapon/gun/projectile/manualcycle/hunterrifle/scoped
	name = "scoped hunting rifle"
	scoped = 1
	wielded_item_state = "scopedhuntrifle2"
	icon_state = "scopedhuntrifle"
	item_state = "scopedhuntrifle"

/obj/item/weapon/gun/projectile/manualcycle/hunterrifle/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	if(scoped)
		toggle_scope(usr, 2.0)

	else
		return

/obj/item/weapon/gunattachment/scope/huntrifle
	icon_state = "huntriflescope"
	name = "hunting rifle attachable scope"
	desc = "A marksman's scope designed to be attached to a hunting rifle."
	matter = list(DEFAULT_WALL_MATERIAL = 1000,"glass" = 500)

//hunterknife

/obj/item/weapon/material/knife/hunting
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "huntknife"
	force_divisor = 0.2 // 12 with hardness 60 (steel)
	thrown_force_divisor = 0.15 // 9 when wielded with hardness 60 (steel)
	applies_material_colour = 0
	w_class = 2
	name = "hunting knife"
	desc = "It's a hunting knife. Use it for hunting."
