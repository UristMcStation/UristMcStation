#define CARCASS_EMPTY    "empty"
#define CARCASS_FRESH    "fresh"
#define CARCASS_SKINNED  "skinned"
#define CARCASS_JOINTED  "jointed"

/mob/living/var/meat_type =         /obj/item/reagent_containers/food/snacks/meat
/mob/living/var/meat_amount =       3
/mob/living/var/skin_material =     MATERIAL_SKIN_GENERIC
/mob/living/var/skin_amount =       3
/mob/living/var/bone_material =     MATERIAL_BONE_GENERIC
/mob/living/var/bone_amount =       3
/mob/living/var/skull_type
/mob/living/var/butchery_rotation = 90

/mob/living/carbon/human/butchery_rotation = 180

// Harvest an animal's delicious byproducts
/mob/living/proc/harvest_meat()
	. = list()
	var/effective_meat_type = isSynthetic() ? /obj/item/stack/material/steel : meat_type
	if(!effective_meat_type || !meat_amount)
		return
	blood_splatter(get_turf(src), src, large = TRUE)
	var/meat_count = 0
	for(var/i=0;i<meat_amount;i++)
		var/obj/item/reagent_containers/food/snacks/meat/slab = new effective_meat_type(get_turf(src))
		. += slab
		if(istype(slab))
			meat_count++
	if(reagents && meat_count > 0)
		var/reagent_split = round(reagents.total_volume/meat_count,1)
		for(var/obj/item/reagent_containers/food/snacks/meat/slab in .)
			reagents.trans_to_obj(slab, reagent_split)

/mob/living/carbon/human/harvest_meat()
	. = ..()
	for(var/obj/item/organ/internal/I in internal_organs)
		I.removed()
		. += I

/mob/living/proc/harvest_skin()
	. = list()
	if(skin_material && skin_amount)
		var/material/M = SSmaterials.get_material_by_name(skin_material)
		. += new M.stack_type(get_turf(src), skin_amount, skin_material)
		blood_splatter(get_turf(src), src, large = TRUE)

/mob/living/proc/harvest_bones()
	. = list()
	var/turf/T = get_turf(src)
	if(bone_material && bone_amount)
		var/material/M = SSmaterials.get_material_by_name(bone_material)
		. += new M.stack_type(T, bone_amount, bone_material)
		blood_splatter(T, src, large = TRUE)
	if(skull_type)
		. += new skull_type(T)

// Structure for conducting butchery on.
/obj/structure/kitchenspike
	name = "meat hook"
	desc = "It looks pretty sharp."
	anchored = TRUE
	density =  TRUE
	icon = 'icons/obj/structures/butchery.dmi'
	icon_state = "spike"

	var/mob/living/occupant
	var/occupant_state =   CARCASS_EMPTY
	var/secures_occupant = TRUE
	var/busy =             FALSE

/obj/structure/kitchenspike/return_air()
	var/turf/T = get_turf(src)
	if(istype(T))
		return T.return_air()

/obj/structure/kitchenspike/improvised
	name = "truss"
	icon_state = "improvised"
	secures_occupant = FALSE

/obj/structure/kitchenspike/attack_hand(mob/user)

	if(!occupant)
		return ..()

	if(occupant_state == CARCASS_FRESH)
		visible_message(SPAN_NOTICE("\The [user] removes \the [occupant] from \the [src]."))
		occupant.forceMove(get_turf(src))
		occupant = null
		occupant_state = CARCASS_EMPTY
		busy = FALSE
		update_icon()
	else
		to_chat(user, SPAN_WARNING("\The [occupant] is so badly mangled that removing them from \the [src] would be pointless."))
		return

/obj/structure/kitchenspike/MouseDrop_T(mob/target, mob/user)
	try_spike(target, user)

/obj/structure/kitchenspike/proc/try_spike(mob/living/target, mob/living/user)
	if(!istype(target) || !Adjacent(user) || user.incapacitated())
		return

	if(!target.stat)
		to_chat(user, SPAN_WARNING("\The [target] won't stop moving around!"))
		return

	if(occupant)
		to_chat(user, SPAN_WARNING("\The [src] already has a carcass on it."))
		return

	if(suitable_for_butchery(target))

		user.visible_message(SPAN_WARNING("\The [user] begins wrestling \the [target] onto \the [src]."))
		if(!do_after(user, 3 SECONDS, target, DO_PUBLIC_UNIQUE) || occupant || !target || QDELETED(target) || target.stat == CONSCIOUS || !target.Adjacent(user))
			return

		if(secures_occupant)
			user.visible_message(SPAN_DANGER("\The [user] impales \the [target] on \the [src]!"))
			target.adjustBruteLoss(rand(30, 45))
		else
			user.visible_message(SPAN_DANGER("\The [user] hangs \the [target] from \the [src]!"))

		target.forceMove(src)
		occupant = target
		occupant_state = CARCASS_FRESH
		update_icon()
	else
		to_chat(user, SPAN_WARNING("You cannot butcher \the [target]."))

/obj/structure/kitchenspike/proc/suitable_for_butchery(mob/living/victim)
	return istype(victim) && ((victim.meat_type && victim.meat_amount) || (victim.skin_material && victim.skin_amount) || (victim.bone_material && victim.bone_amount))

/obj/structure/kitchenspike/on_update_icon()
	ClearOverlays()
	if(occupant)
		occupant.set_dir(SOUTH)
		var/image/I = image(null)
		I.appearance = occupant
		I.SetTransform(rotation = occupant.butchery_rotation)
		AddOverlays(I)

/obj/structure/kitchenspike/mob_breakout(mob/living/escapee)
	. = ..()
	if(secures_occupant)
		escapee.visible_message(SPAN_WARNING("\The [escapee] begins writhing free of \the [src]!"))
		if(!do_after(escapee, 5 SECONDS, src, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
			return FALSE
	escapee.visible_message(SPAN_DANGER("\The [escapee] escapes from \the [src]!"))
	escapee.dropInto(loc)
	if(escapee == occupant)
		occupant = null
		occupant_state = CARCASS_EMPTY
		update_icon()
	return TRUE

/obj/structure/kitchenspike/proc/set_carcass_state(_state)
	occupant_state = _state
	if(occupant)
		occupant.adjustBruteLoss(rand(50,60))
		if(occupant.stat != DEAD)
			occupant.death()
	if(QDELETED(occupant))
		occupant = null
		occupant_state = CARCASS_EMPTY
	else if(occupant_state == CARCASS_EMPTY)
		for(var/obj/item/W in occupant)
			occupant.drop_from_inventory(W)
		QDEL_NULL(occupant)
	update_icon()

/obj/structure/kitchenspike/proc/do_butchery_step(mob/user, next_state, butchery_string)

	if(QDELETED(occupant))
		return FALSE

	var/last_state = occupant_state
	var/mob/living/last_occupant = occupant

	user.visible_message(SPAN_NOTICE("\The [user] begins [butchery_string] \the [occupant]."))
	occupant.adjustBruteLoss(rand(50,60))
	update_icon()

	if(do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE) && !QDELETED(user) && !QDELETED(last_occupant) && occupant == last_occupant && occupant_state == last_state)
		user.visible_message(SPAN_NOTICE("\The [user] finishes [butchery_string] \the [occupant]."))
		switch(next_state)
			if(CARCASS_SKINNED)
				occupant.harvest_skin()
			if(CARCASS_JOINTED)
				occupant.harvest_bones()
			if(CARCASS_EMPTY)
				occupant.harvest_meat()
		set_carcass_state(next_state)
		return TRUE
	return FALSE


/obj/structure/kitchenspike/use_tool(obj/item/tool, mob/user, list/click_params)
	if (is_sharp(tool))
		if (!occupant)
			USE_FEEDBACK_FAILURE("\The [src] doesn't have anything to butcher.")
			return TRUE
		if (busy)
			USE_FEEDBACK_FAILURE("\The [src] is currently being used by someone else.")
			return TRUE
		busy = TRUE
		switch(occupant_state)
			if(CARCASS_FRESH)
				do_butchery_step(user, CARCASS_SKINNED, "skinning")
			if(CARCASS_SKINNED)
				do_butchery_step(user, CARCASS_JOINTED, "deboning")
			if(CARCASS_JOINTED)
				do_butchery_step(user, CARCASS_EMPTY,   "butchering")
		busy = FALSE
		return TRUE

	return ..()


/obj/structure/kitchenspike/improvised/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(isWrench(W))
		user.visible_message("/The [user] destroys the truss.", "You destroy the truss.")
		qdel(src)
		return TRUE

	return ..()

#undef CARCASS_EMPTY
#undef CARCASS_FRESH
#undef CARCASS_SKINNED
#undef CARCASS_JOINTED
