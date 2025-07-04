/**********************Miner Lockers**************************/

/obj/structure/closet/secure_closet/miner
	name = "miner's equipment"
	closet_appearance = /singleton/closet_appearance/secure_closet/mining
	req_access = list(access_mining)

/obj/structure/closet/secure_closet/miner/WillContain()
	return list(
		new /datum/atom_creator/weighted(list(
				/obj/item/storage/backpack/industrial,
				/obj/item/storage/backpack/satchel/eng
			)),
		/obj/item/device/radio/headset/headset_cargo,
		/obj/item/device/radio/headset/headset_cargo/alt,
		/obj/item/clothing/under/rank/miner,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/shoes/black,
		/obj/item/device/scanner/gas,
		/obj/item/storage/ore,
		/obj/item/device/flashlight/lantern,
		/obj/item/shovel,
		/obj/item/pickaxe,
		/obj/item/clothing/glasses/meson
	)

/**********'pickaxes' but theyre drills actually***************/

/obj/item/pickaxe
	name = "mining drill"
	desc = "The most basic of mining drills, for short excavations and small mineral extractions."
	icon = 'icons/obj/tools/mining_drills.dmi'
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = 15.0
	throwforce = 4.0
	icon_state = "drill"
	item_state = "jackhammer"
	w_class = ITEM_SIZE_HUGE
	matter = list(MATERIAL_STEEL = 3750)
	var/digspeed = 40 //moving the delay to an item var so R&D can make improved picks. --NEO
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	attack_verb = list("hit", "pierced", "sliced", "attacked")
	var/drill_sound = 'sound/weapons/Genhit.ogg'
	var/drill_verb = "drilling"

	var/excavation_amount = 200
	var/build_from_parts = FALSE
	var/hardware_color

/obj/item/pickaxe/hammer
	name = "sledgehammer"
	desc = "A mining hammer made of reinforced metal. You feel like smashing your boss in the face with this."
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "sledgehammer"

/obj/item/pickaxe/drill
	name = "advanced mining drill" // Can dig sand as well!
	icon_state = "handdrill"
	item_state = "jackhammer"
	digspeed = 30
	origin_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	desc = "Yours is the drill that will pierce through the rock walls."
	drill_verb = "drilling"

/obj/item/pickaxe/jackhammer
	name = "sonic jackhammer"
	icon_state = "jackhammer"
	item_state = "jackhammer"
	digspeed = 20 //faster than drill, but cannot dig
	origin_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	desc = "Cracks rocks with sonic blasts, perfect for killing cave lizards."
	drill_verb = "hammering"

/obj/item/pickaxe/diamonddrill //When people ask about the badass leader of the mining tools, they are talking about ME!
	name = "diamond mining drill"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	digspeed = 5 //Digs through walls, girders, and can dig up sand
	origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 5)
	desc = "Yours is the drill that will pierce the heavens!"
	drill_verb = "drilling"

/obj/item/pickaxe/borgdrill
	name = "cyborg mining drill"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	digspeed = 15
	desc = ""
	drill_verb = "drilling"

//****************************actual pickaxes***********************

/obj/item/pickaxe/hand
	name = "steel pickaxe"
	desc = "Time-tested miner's tool."
	icon = 'icons/obj/tools/pickaxe.dmi'
	icon_state = "pick_preview"
	item_state = "pickaxe"
	origin_tech = list(TECH_MATERIAL = 1)
	drill_verb = "picking"
	sharp = TRUE
	build_from_parts = TRUE
	hardware_color = COLOR_STEEL

/obj/item/pickaxe/hand/Initialize()
	if(build_from_parts)
		icon_state = "pick_hardware"
		color = hardware_color
		AddOverlays(overlay_image(icon, "pick_handle", flags=RESET_COLOR))
	. = ..()

/obj/item/pickaxe/hand/silver
	name = "silver pickaxe"
	desc = "This makes no metallurgic sense."
	digspeed = 30
	origin_tech = list(TECH_MATERIAL = 3)
	hardware_color = COLOR_SILVER

/obj/item/pickaxe/hand/gold
	name = "golden pickaxe"
	desc = "This makes no metallurgic sense."
	digspeed = 20
	origin_tech = list(TECH_MATERIAL = 4)
	hardware_color = COLOR_GOLD

/obj/item/pickaxe/hand/diamond
	name = "diamond pickaxe"
	desc = "A pickaxe with a diamond pick head."
	digspeed = 10
	origin_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 4)
	hardware_color = COLOR_DIAMOND

/*****************************Shovel********************************/

/obj/item/shovel
	name = "shovel"
	desc = "A large tool for digging and moving dirt."
	icon = 'icons/obj/tools/shovels.dmi'
	icon_state = "shovel"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = 8.0
	throwforce = 4.0
	item_state = "shovel"
	w_class = ITEM_SIZE_HUGE
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 500, "wood" = 600)
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")
	edge = TRUE
	puncture = TRUE

/obj/item/shovel/spade
	name = "spade"
	desc = "A small tool for digging and moving dirt."
	icon_state = "spade"
	item_state = "spade"
	force = 5.0
	throwforce = 7.0
	w_class = ITEM_SIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 300)

// Flags.
/obj/item/stack/flag
	name = "beacon"
	desc = "Some deployable high-visibilty beacons."
	singular_name = "beacon"
	icon_state = "folded"
	amount = 10
	max_amount = 10
	icon = 'icons/obj/marking_beacon.dmi'

	var/upright = 0
	var/fringe = null

/obj/item/stack/flag/red
	light_color = COLOR_RED

/obj/item/stack/flag/yellow
	light_color = COLOR_YELLOW

/obj/item/stack/flag/green
	light_color = COLOR_LIME

/obj/item/stack/flag/blue
	light_color = COLOR_BLUE

/obj/item/stack/flag/teal
	light_color = COLOR_TEAL

/obj/item/stack/flag/Initialize()
	. = ..()
	update_icon()

/obj/item/stack/flag/use_tool(obj/item/tool, mob/living/user, list/click_params)
	if(upright)
		attack_hand(user)
		return TRUE
	return ..()

/obj/item/stack/flag/attack_hand(mob/user)
	if(upright)
		knock_down()
		user.visible_message("\The [user] knocks down \the [singular_name].")
		return
	return ..()

/obj/item/stack/flag/attack_self(mob/user)
	var/turf/T = get_turf(src)

	if(istype(T, /turf/space) || istype(T, /turf/simulated/open))
		to_chat(user, SPAN_WARNING("There's no solid surface to plant \the [singular_name] on."))
		return

	for(var/obj/item/stack/flag/F in T)
		if(F.upright)
			to_chat(user, SPAN_WARNING("\The [F] is already planted here."))
			return

	if(use(1)) // Don't skip use() checks even if you only need one! Stacks with the amount of 0 are possible, e.g. on synthetics!
		var/obj/item/stack/flag/newflag = new src.type(T, 1)
		newflag.set_up()
		if(istype(T, /turf/simulated/floor/asteroid) || istype(T, /turf/simulated/floor/exoplanet))
			user.visible_message("\The [user] plants \the [newflag.singular_name] firmly in the ground.")
		else
			user.visible_message("\The [user] attaches \the [newflag.singular_name] firmly to the ground.")

/obj/item/stack/flag/proc/set_up()
	upright = 1
	anchored = TRUE
	update_icon()

/obj/item/stack/flag/on_update_icon()
	ClearOverlays()
	if(upright)
		pixel_x = 0
		pixel_y = 0
		icon_state = "base"
		var/image/addon = image(icon = icon, icon_state = "glowbit")
		addon.color = light_color
		addon.layer = ABOVE_LIGHTING_LAYER
		addon.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		AddOverlays(addon)
		set_light(3, 0.5)
	else
		pixel_x = rand(-randpixel, randpixel)
		pixel_y = rand(-randpixel, randpixel)
		icon_state = "folded"
		var/image/addon = image(icon = icon, icon_state = "basebit")
		addon.color = light_color
		AddOverlays(addon)
		set_light(0)

/obj/item/stack/flag/proc/knock_down()
	upright = 0
	anchored = FALSE
	update_icon()
