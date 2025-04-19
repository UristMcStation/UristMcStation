//tools for carpentry. Hand tools.

/obj/item/carpentry
	item_icons = DEF_URIST_INHANDS
	icon = 'icons/urist/items/tools.dmi'

/obj/item/carpentry/saw
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

/obj/item/carpentry/axe
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

/obj/item/carpentry/axe/IsHatchet() //without this we can't cut down exoplanet trees
	return TRUE

//hunter stuff

//huntergun

/obj/item/gun/projectile/manualcycle/hunterrifle
	item_icons = DEF_URIST_INHANDS
	name = "hunting rifle"
	icon = 'icons/urist/items/guns.dmi'
	desc = "A standard issue Nanotrasen bolt-action rifle for its crew serving on hostile planetary environments."
	wielded_item_state = "huntrifle2"
	icon_state = "huntrifle"
	item_state = "huntrifle"
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
	accuracy_power = 6
	screen_shake = 1

	var/scoped = 0

/obj/item/gun/projectile/manualcycle/hunterrifle/use_tool(obj/item/I, mob/living/user, list/click_params) //i really need to make a parent class for guns that can be modified, but right now it's only the one so fuck it. //GlloydTODO
	..()

	if(istype(I, /obj/item/gunattachment/scope/huntrifle) && !scoped)
		to_chat(user, "<span class='notice'>You attach the scope to the rifle.</span>")
		scoped = 1
		scoped_accuracy = 9
		scope_zoom = 2
		verbs += /obj/item/gun/proc/scope
		icon_state = "scopedhuntrifle"
		item_state = "scopedhuntrifle"
		wielded_item_state = "scopedhuntrifle2"
		update_icon()
		user.remove_from_mob(I)
		qdel(I)

	else if(istype(I, /obj/item/wrench) && scoped)
		to_chat(user, "<span class='notice'>You remove the scope from the rifle.</span>")
		scoped = 0
		scoped_accuracy = 0
		scope_zoom = 0
		verbs -= /obj/item/gun/proc/scope
		wielded_item_state = "huntrifle2"
		icon_state = "huntrifle"
		item_state = "huntrifle"
		update_icon()
		new /obj/item/gunattachment/scope/huntrifle(user.loc)

/obj/item/gun/projectile/manualcycle/hunterrifle/on_update_icon()
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

/obj/item/gun/projectile/manualcycle/hunterrifle/scoped
	name = "scoped hunting rifle"
	scoped = 1
	wielded_item_state = "scopedhuntrifle2"
	icon_state = "scopedhuntrifle"
	item_state = "scopedhuntrifle"
	scoped_accuracy = 15
	scope_zoom = 2

/obj/item/gunattachment/scope/huntrifle
	icon_state = "huntriflescope"
	name = "hunting rifle attachable scope"
	desc = "A marksman's scope designed to be attached to a hunting rifle."
	matter = list(DEFAULT_WALL_MATERIAL = 1000,"glass" = 500)

//hunterknife

/obj/item/material/knife/hunting
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "huntknife"
	force_multiplier = 0.2 // 12 with hardness 60 (steel)
	thrown_force_multiplier = 0.15 // 9 when wielded with hardness 60 (steel)
	applies_material_colour = 0
	w_class = 2
	name = "hunting knife"
	desc = "It's a hunting knife. Use it for hunting."

// Survival Box Equipment

/obj/item/material/knife/survivalknife
	name = "survival knife"
	desc = "A serrated survival knife, used for hunting, gutting, prying, skewering and just about everything else a traditional knife does."
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "survivalknife"
	force_multiplier = 0.2
	thrown_force_multiplier = 0.10
	sharp = 1
	edge = 1
	w_class = 2
	attack_verb = list("stabbed", "shanked", "cut", "sliced", "gutted", "carved")
