/obj/item/melee/energy
	var/active = FALSE
	var/damaged = FALSE
	var/disabled
	var/active_force
	var/active_throwforce
	var/active_icon
	var/lighting_color
	var/active_attack_verb
	var/inactive_attack_verb = list()
	armor_penetration = 50
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_BLOOD


/obj/item/melee/energy/can_embed()
	return FALSE


/obj/item/melee/energy/Initialize()
	. = ..()
	if(active)
		active = FALSE
		activate()
	else
		active = TRUE
		deactivate()


/obj/item/melee/energy/on_update_icon()
	if(active)
		icon_state = active_icon
	else
		icon_state = initial(icon_state)


/obj/item/melee/energy/proc/activate(mob/living/user)
	if (active)
		return
	if (damaged)
		if (world.time < disabled)
			if (user)
				user.show_message(SPAN_WARNING("\The [src] sputters. It's not going to work right now!"))
			return
		user.visible_message(SPAN_NOTICE("\The [src] resonates perfectly, once again."))
		damaged = FALSE

	active = TRUE
	force = active_force
	throwforce = active_throwforce
	sharp = TRUE
	edge = TRUE
	slot_flags |= SLOT_DENYPOCKET
	attack_verb = active_attack_verb

	if (user)
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("\The [src] is now energised."))
	set_light(2, 0.8, lighting_color)

	if (istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	update_icon()


/obj/item/melee/energy/proc/deactivate(mob/living/user)
	if (!active)
		return
	active = FALSE
	force = initial(force)
	throwforce = initial(throwforce)
	sharp = initial(sharp)
	edge = initial(edge)
	slot_flags = initial(slot_flags)
	attack_verb = inactive_attack_verb

	if (user)
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("\The [src] deactivates!"))
	set_light(0)

	if (istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	update_icon()


/obj/item/melee/energy/attack_self(mob/living/user as mob)
	if (active)
		if ((MUTATION_CLUMSY in user.mutations) && prob(50))
			var/datum/pronouns/pronouns = user.choose_from_pronouns()
			user.visible_message(SPAN_DANGER("\The [user] accidentally cuts [pronouns.self] with \the [src]."),\
			SPAN_DANGER("You accidentally cut yourself with \the [src]."))
			user.take_organ_damage(5,5)
		deactivate(user)
	else
		activate(user)

	add_fingerprint(user)
	return


/obj/item/melee/energy/emp_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	if (!active)
		return
	if (damaged)
		return
	var/disabletime = 30 SECONDS
	if (severity == EMP_ACT_HEAVY)
		disabletime = 1.5 MINUTES

	visible_message(SPAN_DANGER("\The [src] violently shudders!"))
	new /obj/overlay/emp_pulse (get_turf(src))

	disabled = world.time + disabletime
	var/mob/living/carbon/M = loc
	if (M)
		deactivate(M)
	else
		deactivate()
	update_icon()
	damaged = TRUE
	GLOB.empd_event.raise_event(src, severity)


/obj/item/melee/energy/get_storage_cost()
	if (active)
		return ITEM_SIZE_NO_CONTAINER
	return ..()


/obj/item/melee/energy/IsHeatSource()
	return active ? 3500 : 0


/*
 * Energy Axe
 */
/obj/item/melee/energy/axe
	icon = 'icons/obj/weapons/melee_energy.dmi'
	name = "energy axe"
	desc = "An energised battle axe."
	icon_state = "axe0"
	active_icon = "axe1"
	lighting_color = COLOR_SABER_AXE
	active_force = 60
	active_throwforce = 35
	force = 20
	throwforce = 10
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_BLOOD
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	origin_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 4)
	active_attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	inactive_attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	sharp = TRUE
	edge = TRUE
	melee_accuracy_bonus = 15


/obj/item/melee/energy/axe/deactivate(mob/living/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("\The [src] is de-energised. It's just a regular axe now."))


/*
 * Energy Sword
 */
/obj/item/melee/energy/sword
	icon = 'icons/urist/items/uristweapons.dmi'
	name = "energy sword"
	desc = "May the force be within you."
	icon_state = "sword0"
	item_icons = URIST_ALL_ONMOBS
	active_force = 30
	active_throwforce = 20
	force = 3
	throwforce = 5
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_BLOOD
	origin_tech = list(TECH_MAGNET = 3, TECH_ESOTERIC = 4)
	sharp = TRUE
	edge = TRUE
	base_parry_chance = 50
	active_attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/blade1.ogg'
	var/blade_color


/obj/item/melee/energy/sword/Initialize()
	if(!blade_color)
		blade_color = pick("red","blue","green","purple","black","yellow","orange")

	active_icon = "sword[blade_color]"
	var/color_hex = list("red" = COLOR_SABER_RED,  "blue" = COLOR_SABER_BLUE, "green" = COLOR_SABER_GREEN, "purple" = COLOR_SABER_PURPLE, "orange" = COLOR_SABER_ORANGE, "yellow" = COLOR_SABER_YELLOW, "black" = COLOR_SABER_BLACK)
	lighting_color = color_hex[blade_color]

	. = ..()


/obj/item/melee/energy/sword/green
	blade_color = "green"


/obj/item/melee/energy/sword/red
	blade_color = "red"


/obj/item/melee/energy/sword/red/activated
	active = TRUE


/obj/item/melee/energy/sword/blue
	blade_color = "blue"


/obj/item/melee/energy/sword/purple
	blade_color = "purple"

/obj/item/melee/energy/sword/black
	blade_color = "black"

/obj/item/melee/energy/sword/yellow
	blade_color = "yellow"

/obj/item/melee/energy/sword/orange
	blade_color = "orange"

/obj/item/melee/energy/sword/dropped(mob/user)
	..()
	if(!ismob(loc))
		deactivate(user)


/obj/item/melee/energy/sword/handle_shield(mob/user, damage, atom/damage_source = null, mob/attacker = null, def_zone = null, attack_text = "the attack")
	. = ..()
	if(.)
		var/datum/effect/spark_spread/spark_system = new /datum/effect/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)


/obj/item/melee/energy/sword/get_parry_chance(mob/user, mob/attacker)
	return active ? ..() : 0

/obj/item/melee/energy/sword/dualsaber
	var/base_icon = "dualsaber"
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "dualsaber0"
	name = "double-bladed energy sword"
	desc = "Handle with care."
	var/wielded = 0
	var/force_wielded = 40
	var/force_unwielded = 5
	item_icons = DEF_URIST_INHANDS

/obj/item/melee/energy/sword/dualsaber/Initialize()
	if(!blade_color)
		blade_color = pick("red","blue","green","purple","yellow","orange")

	active_icon = "dualsaber[blade_color]"
	var/color_hex = list("red" = COLOR_SABER_RED,  "blue" = COLOR_SABER_BLUE, "green" = COLOR_SABER_GREEN, "purple" = COLOR_SABER_PURPLE, "yellow" = COLOR_SABER_YELLOW, "orange" = COLOR_SABER_ORANGE)
	lighting_color = color_hex[blade_color]

	. = ..()

/obj/item/melee/energy/sword/dualsaber/activate(mob/living/user)
	..()
	icon_state = "dualsaber[blade_color]"
	update_icon()

/obj/item/melee/energy/sword/dualsaber/deactivate(mob/living/user)
	..()
	icon_state = "dualsaber0"
	update_icon()

/obj/item/melee/energy/sword/dualsaber/on_update_icon()
	if(wielded && active)
		item_state = "dualsaber[blade_color][wielded]"
	else
		item_state = initial(icon_state)

/obj/item/melee/energy/sword/dualsaber/use_before(atom/target, mob/living/user as mob, click_params)
	. = ..()

	if((MUTATION_CLUMSY in user.mutations) && (wielded) &&prob(40))
		to_chat(user, "<span class='warning'> You twirl around a bit before losing your balance and impaling yourself on the [src].</span>")
		user.take_organ_damage(20,25)
		return

	if((wielded) && prob(50))
		spawn(0)
			for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2))
				user.set_dir(i)
				sleep(1)

	return

/obj/item/melee/energy/sword/dualsaber/update_twohanding()
	var/mob/living/M = loc
	if(istype(M) && M.can_wield_item(src) && is_held_twohanded(M))
		wielded = 1
		force = force_wielded
	else
		wielded = 0
		force = force_unwielded
	update_icon()
	..()

/*/obj/item/melee/energy/sword/dualsaber/New()
	blade_color = pick("red","blue","green","purple","yellow","orange")*/

/obj/item/melee/energy/sword/dualsaber/green
	blade_color = "green"

/obj/item/melee/energy/sword/dualsaber/red
	blade_color = "red"

/obj/item/melee/energy/sword/dualsaber/blue
	blade_color = "blue"

/obj/item/melee/energy/sword/dualsaber/purple
	blade_color = "purple"

/obj/item/melee/energy/sword/dualsaber/yellow
	blade_color = "yellow"

/obj/item/melee/energy/sword/dualsaber/orange
	blade_color = "orange"

/obj/item/melee/energy/sword/pirate
	icon = 'icons/obj/weapons/melee_energy.dmi'
	name = "energy cutlass"
	desc = "Arrrr matey."
	icon_state = "cutlass0"
	active_icon = "cutlass1"
	lighting_color = COLOR_SABER_CUTLASS


/obj/item/melee/energy/sword/pirate/activated
	active = TRUE


/*
 *Energy Blade
 */
/obj/item/melee/energy/blade
	icon = 'icons/obj/weapons/melee_energy.dmi'
	name = "energy blade"
	desc = "A concentrated beam of energy in the shape of a blade. Very stylish... and lethal."
	icon_state = "blade"
	active_icon = "blade"	//It's all energy, so it should always be visible.
	lighting_color = COLOR_SABER_GREEN
	active_force = 40 //Normal attacks deal very high damage - about the same as wielded fire axe
	active = 1
	armor_penetration = 100
	sharp = TRUE
	edge = TRUE
	anchored = TRUE    // Never spawned outside of inventory, should be fine.
	canremove = FALSE // You can use it while prone. Still deleted if the arm is destroyed.
	active_throwforce = 1  //Throwing or dropping the item deletes it.
	throw_speed = 1
	throw_range = 1
	w_class = ITEM_SIZE_TINY //technically it's just energy or something, I dunno
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_BLOOD
	active_attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/blade1.ogg'
	var/mob/living/carbon/human/creator
	var/datum/effect/spark_spread/spark_system


/obj/item/melee/energy/blade/New()
	..()
	spark_system = new /datum/effect/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)


/obj/item/melee/energy/blade/Initialize()
	. = ..()
	if(ishuman(loc))
		creator = loc
	START_PROCESSING(SSobj, src)
	playsound(creator, 'sound/weapons/saberon.ogg', 50, 1)


/obj/item/melee/energy/blade/Destroy()
	STOP_PROCESSING(SSobj, src)
	playsound(creator, 'sound/weapons/saberoff.ogg', 50, 1)
	creator = null
	. = ..()


/obj/item/melee/energy/blade/get_storage_cost()
	return ITEM_SIZE_NO_CONTAINER


/obj/item/melee/energy/blade/attack_self(mob/user as mob)
	user.drop_from_inventory(src)


/obj/item/melee/energy/blade/dropped()
	..()
	QDEL_IN(src, 0)


/obj/item/melee/energy/blade/Process()
	if (creator.handcuffed || (creator.stat != CONSCIOUS))
		QDEL_IN(src, 0)

	if (!creator || loc != creator || !creator.IsHolding(src))
		// Tidy up a bit.
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		QDEL_IN(src, 0)


/obj/item/melee/energy/blade/e_armblade
	name = "hardsuit armblade"
	desc = "An extra large, extra sharp laser armblade. Rip and tear."
	icon_state = "e_armblade"
	active_icon = "e_armblade"
	lighting_color = COLOR_SABER_RED
	active_force = 30 // Regular energy sword damage.
	armor_penetration = 40 // Absolutely not 100AP for this one. Thank you.


/obj/item/melee/energy/machete
	icon = 'icons/obj/weapons/melee_energy.dmi'
	name = "energy machete"
	desc = "A machete handle that extends out into a long, purple machete blade. It appears to be Skrellian in origin."
	icon_state = "machete_skrell_x"
	active_icon = "machete_skrell"
	active_force = 25
	active_throwforce = 17.25
	lighting_color = COLOR_SABER_SKRELL
	force = 3
	throwforce = 1
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MAGNET = 3)
	active_attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	hitsound = 'sound/weapons/blade1.ogg'


/obj/item/melee/energy/machete/IsHatchet()
	return TRUE
