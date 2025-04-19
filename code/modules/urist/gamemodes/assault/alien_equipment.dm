//alien

/obj/machinery/computer/shuttle_control/assault
	var/readytogo = 0
	density = FALSE

/obj/machinery/computer/shuttle_control/assault/attack_hand(mob/user)
	if(!readytogo)
		to_chat(user, "<span class='warning'>The shuttles will be ready to launch shortly.</span>")
		return
	else
		..()

/obj/machinery/computer/shuttle_control/assault/alien1
	name = "alien shuttle console (Shuttle 1)"
	shuttle_tag = "Assault 1"
	icon = 'icons/obj/machines/medical/cryogenic_legacy.dmi'
	icon_state = "cellconsoleold"

/obj/machinery/computer/shuttle_control/assault/alien2
	name = "alien shuttle console (Shuttle 2)"
	shuttle_tag = "Assault 2"
	icon = 'icons/obj/machines/medical/cryogenic_legacy.dmi'
	icon_state = "cellconsoleold"

/obj/item/gun/energy/lactera
	item_icons = DEF_URIST_INHANDS
	name = "alien gun"
	desc = "A weapon of unknown origin, carried by the Lactera soldiers."
	icon_state = "alienrifle"
	item_state = "alienrifle"
	fire_sound = 'sound/weapons/laser3.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = 3
	icon = 'icons/urist/items/guns.dmi'
	force = 10
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	origin_tech = "combat=7;magnets=5;materials=4;engineering=2;powerstorage=4;"
	projectile_type = /obj/item/projectile/beam
	fire_delay = 1 //rapid fire
	max_shots = 8
	self_recharge = 1
	var/inertstate = /obj/item/scom/aliengun

/obj/item/gun/energy/lactera/on_update_icon()
	..()
	item_state = initial(item_state)
	icon_state = initial(icon_state)

/obj/item/gun/energy/lactera/a1
	name = "alien pistol"
	icon_state = "xeno-pistol"
	item_state = "xeno-pistol"
	projectile_type = /obj/item/projectile/beam/scom/alien2
	max_shots = 4
	origin_tech = "combat=6;magnets=4;materials=3;engineering=1;powerstorage=3;"
	inertstate = /obj/item/scom/aliengun/a1
	w_class = 2

/obj/item/gun/energy/lactera/a2
	name = "alien carbine"
	icon_state = "xeno-carbine"
	item_state = "xeno-carbine"
	wielded_item_state = "xeno-carbine-wielded"
	slot_flags = SLOT_BACK
	projectile_type = /obj/item/projectile/beam/scom/alien6
	inertstate = /obj/item/scom/aliengun/a2
	max_shots = 16
	one_hand_penalty = 1

/obj/item/gun/energy/lactera/a3
	name = "alien rifle"
	item_state = "xeno-rifle"
	icon_state = "xeno-rifle"
	wielded_item_state = "xeno-rifle-wielded"
	slot_flags = SLOT_BACK
	projectile_type = /obj/item/projectile/beam/scom/alien2
	origin_tech = "combat=8;magnets=6;materials=5;engineering=3;powerstorage=5;"
	inertstate = /obj/item/scom/aliengun/a3
	one_hand_penalty = 2
	max_shots = 12

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, move_delay=null, burst_accuracy=null, dispersion=null, one_hand_penalty = 2),
		list(mode_name="3-round bursts", burst=3, move_delay=6, fire_delay=null, one_hand_penalty = 3, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.0, 0.6, 0.6)),
		list(mode_name="short bursts", 	burst=5, move_delay=6, fire_delay=null, one_hand_penalty = 4, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/energy/lactera/a4
	name = "alien LMG"
	item_state = "xeno-hmg"
	icon_state = "xeno-hmg"
	wielded_item_state = "xeno-hmg-wielded"
	slot_flags = SLOT_BACK
	projectile_type = /obj/item/projectile/beam/scom/alien1
	origin_tech = "combat=9;magnets=7;materials=6;engineering=4;powerstorage=6;"
	inertstate = /obj/item/scom/aliengun/a4
	max_shots = 20
	one_hand_penalty = 6
	w_class = 4

	firemodes = list(
		list(mode_name="short bursts",	burst=8, fire_delay=null, move_delay=8, one_hand_penalty = 8, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(0.6, 1.0, 1.2, 1.4, 1.4)),
		list(mode_name="long bursts",	burst=16, fire_delay=null, move_delay=10, one_hand_penalty = 9, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.2, 1.2, 1.2, 1.4, 1.4)),
		)

/obj/item/gun/energy/lactera/attack_hand(mob/user)
	var/mob/living/carbon/human/M = user
	if(!istype(M, /mob/living/carbon/human/lactera))
//	if(M.species != "Xenomorph")
		to_chat(M, "<span class='warning'>The alien gun turns inert when you touch it.</span>")
		new inertstate(src.loc)
		qdel(src)

	else
		..()

/obj/item/gun/energy/lactera/verb_pickup()
	var/mob/living/carbon/human/M = usr
	if(!istype(M, /mob/living/carbon/human/lactera))
//	if(M.species != /singleton/species/xenos/lactera)
		to_chat(M, "<span class='warning'>The alien gun turns inert when you touch it.</span>")
		new inertstate(src.loc)
		qdel(src)

	else
		..()

/obj/item/grenade/aliengrenade
	desc = "An explosive of unknown origin used by Lactera soldiers to sow destruction and chaos."
	name = "alien grenade"
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "aliengrenade"
	item_state = "flashbang"
	origin_tech = "materials=5;magnets=5"

/obj/item/grenade/aliengrenade/detonate()
	explosion(src.loc, 0, 0, 3, 3)
	qdel(src)

/obj/item/plastique/alienexplosive
	name = "alien explosives"
	desc = "Used by Lactera soldiers to put holes in specific areas without too much extra hole."
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "plastic-explosive0"
	item_state = "device"

/obj/item/plastique/alienexplosive/explode(location)
	if(!target)
		target = get_atom_on_turf(src)
	if(!target)
		target = src
	if(location)
		explosion(location, -1, -1, 2, 3)

	if(target)
		if (istype(target, /turf/simulated/wall))
			var/turf/simulated/wall/W = target
			W.dismantle_wall(1)
		else if (istype(target, /turf/simulated/floor))
			target.ex_act(3) //no destroying floors for the shitter aliums
		else if(istype(target, /mob/living))
			target.ex_act(2) // c4 can't gib mobs anymore.
		else
			target.ex_act(1)
	if(target)
		target.overlays -= image_overlay
	qdel(src)

/obj/item/plastique/alienexplosive/use_tool(obj/item/I, mob/user, click_params)
	if(isScrewdriver(I))
		return TRUE
	if (isWirecutter(I) || isMultitool(I) || istype(I, /obj/item/device/assembly/signaler ))
		return TRUE
	else
		return ..()

/obj/item/clothing/under/lactera
	name = "lactera hide"
	desc = "the hide of the lactera soldiers, genetically modified to be resistent to any threats."
	icon = 'icons/uristmob/scommobs.dmi'
	icon_state = "lactera_under"
	icon_override = 'icons/uristmob/scommobs.dmi'
	item_state = "lactera_under"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS
	armor = list(melee = 5, bullet = 0, laser = 0, energy = 0, bomb = 5, bio = 80, rad = 60)
	species_restricted = list("Lactera")

/obj/item/clothing/under/lactera/MouseDrop(obj/over_object as obj)
	return

/obj/item/clothing/shoes/magboots/lactera
	name = "lactera mag claws"
	desc = "the claws of the lactera soldiers, implanted with a mag traction locking system."
	icon = 'icons/uristmob/r_lactera.dmi'
	icon_state = "lactera_shoes"
	icon_override = 'icons/uristmob/scommobs.dmi'
	item_state = "lactera_shoes"
	armor = list(melee = 5, bullet = 0, laser = 0, energy = 0, bomb = 5, bio = 80, rad = 60)
	species_restricted = list("Lactera")

/obj/item/clothing/shoes/magboots/lactera/attack_hand(mob/user as mob)
	return

/obj/item/clothing/suit/lactera
	icon = 'icons/urist/items/clothes/lactera.dmi'
	icon_override = 'icons/uristmob/r_lactera.dmi'
	species_restricted = list("Lactera")
	allowed = list(/obj/item/gun/energy,/obj/item/reagent_containers/spray/pepper,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/grenade,/obj/item/plastique)
	item_flags = ITEM_FLAG_THICKMATERIAL
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	cold_protection = UPPER_TORSO|LOWER_TORSO
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO
	siemens_coefficient = 0.6

/obj/item/clothing/suit/lactera/light
	name = "lactera light armoured vest"
	desc = "A light armoured vest worn by lactera soldiers, made out of unknown materials. Fairly resistant, but doesn't give good coverage."
	icon_state = "xeno-lightsuit"
	body_parts_covered = UPPER_TORSO
	armor = list(melee = 30, bullet = 20, laser = 20, energy = 20, bomb = 15, bio = 0, rad = 0)

/obj/item/clothing/suit/lactera/regular
	name = "lactera armoured vest"
	desc = "An armoured vest worn by lactera soldiers, made out of unknown materials. Fairly resistant, but doesn't give good coverage."
	icon_state = "xeno-suit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 35, bullet = 25, laser = 25, energy = 20, bomb = 20, bio = 0, rad = 0)

/obj/item/clothing/suit/lactera/mid
	name = "lactera full armoured vest"
	desc = "An armoured vest worn by lactera soldiers, made out of unknown materials. Fairly resistant, and gives decent coverage."
	icon_state = "xeno-midsuit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 25, bomb = 30, bio = 0, rad = 0)

/obj/item/clothing/suit/lactera/big
	name = "lactera heavy armoured vest"
	desc = "An armoured vest worn by lactera soldiers, made out of unknown materials. Fairly resistant, and gives good coverage."
	icon_state = "xeno-bigsuit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 45, bullet = 35, laser = 35, energy = 25, bomb = 30, bio = 0, rad = 0)

/obj/item/clothing/suit/lactera/max
	name = "lactera heavy armoured suit"
	desc = "An armoured vest worn by lactera soldiers, made out of unknown materials. Fairly resistant, and gives full coverage."
	icon_state = "xeno-maxsuit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	armor = list(melee = 55, bullet = 45, laser = 45, energy = 30, bomb = 40, bio = 0, rad = 0)

/obj/item/clothing/suit/lactera/officer
	name = "lactera officer's armour"
	desc = "An armoured suit worn by lactera officers, made out of unknown materials. Fairly resistant, and gives full coverage."
	icon_state = "xeno-cmdsuit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	armor = list(melee = 65, bullet = 55, laser = 55, energy = 35, bomb = 50, bio = 0, rad = 0)

/obj/item/clothing/head/lactera
	icon = 'icons/urist/items/clothes/lactera.dmi'
	icon_override = 'icons/uristmob/r_lactera.dmi'
	species_restricted = list("Lactera")
	item_flags = ITEM_FLAG_THICKMATERIAL
	body_parts_covered = HEAD
	flags_inv = HIDEEARS|BLOCKHEADHAIR
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	w_class = ITEM_SIZE_NORMAL

/obj/item/clothing/head/lactera/regular
	name = "lactera helmet"
	desc = "An armoured helmet worn by lactera soldiers, made out of unknown materials. It's fairly reistant."
	icon_state = "xeno-helm"
	armor = list(melee = 35, bullet = 25, laser = 25, energy = 20, bomb = 20, bio = 0, rad = 0)

/obj/item/clothing/head/lactera/mid
	name = "lactera reinforced helmet"
	desc = "An armoured helmet worn by lactera soldiers, made out of unknown materials. It's fairly reistant."
	icon_state = "xeno-midhelm"
	armor = list(melee = 45, bullet = 35, laser = 35, energy = 25, bomb = 30, bio = 0, rad = 0)

/obj/item/clothing/head/lactera/max
	name = "lactera full helmet"
	desc = "An armoured helmet worn by lactera soldiers, made out of unknown materials. It's fairly reistant and gives full coverage."
	icon_state = "xeno-maxhelm"
	body_parts_covered = HEAD|FACE|EYES
	armor = list(melee = 55, bullet = 45, laser = 45, energy = 30, bomb = 40, bio = 0, rad = 0)

/obj/item/clothing/head/lactera/cmd
	name = "lactera officer's helmet"
	desc = "An armoured helmet worn by lactera officers, made out of unknown materials. It's fairly reistant and gives full coverage."
	icon_state = "xeno-cmdhelm"
	body_parts_covered = HEAD|FACE|EYES
	armor = list(melee = 65, bullet = 55, laser = 55, energy = 35, bomb = 50, bio = 0, rad = 0)
