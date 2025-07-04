/obj/item/storage/lockbox
	name = "lockbox"
	desc = "A locked box."
	icon = 'icons/obj/briefcases.dmi'
	icon_state = "lockbox+l"
	item_state = "syringe_kit"
	w_class = ITEM_SIZE_HUGE
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 32
	req_access = list(access_armory)
	var/locked = TRUE
	var/broken = FALSE
	var/icon_locked = "lockbox+l"
	var/icon_closed = "lockbox"
	var/icon_broken = "lockbox+b"


/obj/item/storage/lockbox/use_tool(obj/item/I, mob/living/user, list/click_params)
	if (istype(I, /obj/item/card/id))
		if (broken)
			to_chat(user, SPAN_WARNING("It seems to be broken!"))
		else if (!allowed(user))
			to_chat(user, SPAN_WARNING("Access denied!"))
		else if ((locked = !locked))
			to_chat(user, SPAN_NOTICE("You lock \the [src]!"))
			icon_state = icon_locked
			close_all()
		else
			icon_state = icon_closed
			to_chat(user, SPAN_NOTICE("You unlock \the [src]!"))
		return TRUE

	if (!broken && istype(I, /obj/item/melee/energy/blade))
		var/success = emag_act(INFINITY, user, I, null, "You hear metal being sliced and sparks flying.")
		if (success)
			var/datum/effect/spark_spread/spark_system = new
			spark_system.set_up(5, 0, loc)
			spark_system.start()
			playsound(loc, 'sound/weapons/blade1.ogg', 50, 1)
			playsound(loc, "sparks", 50, 1)
			return TRUE

	if (locked)
		to_chat(user, SPAN_WARNING("It's locked!"))
		return TRUE
	return ..()


/obj/item/storage/lockbox/show_to(mob/user)
	if (locked)
		to_chat(user, SPAN_WARNING("It's locked!"))
	else
		..()


/obj/item/storage/lockbox/emag_act(remaining_charges, mob/user, emag_source, visual_feedback, audible_feedback)
	if (broken)
		return
	broken = TRUE
	locked = FALSE
	desc = "It appears to be broken."
	icon_state = icon_broken
	if (user)
		if (!visual_feedback)
			visual_feedback = "\The [src] has been sliced open by \the [user] with \an [emag_source]!"
		visual_feedback = SPAN_WARNING(visual_feedback)
		if (!audible_feedback)
			audible_feedback = "You hear a faint electrical spark."
		audible_feedback = SPAN_WARNING(audible_feedback)
		visible_message(visual_feedback, audible_feedback)
	return TRUE

/obj/item/storage/lockbox/open()
	if (locked)
		return 0

	. = ..()

/obj/item/storage/lockbox/loyalty
	name = "lockbox of loyalty implants"
	req_access = list(access_security)
	startswith = list(
		/obj/item/implantcase/loyalty = 3,
		/obj/item/implanter/loyalty = 1
	)


/obj/item/storage/lockbox/clusterbang
	name = "lockbox of clusterbangs"
	desc = "You have a bad feeling about opening this."
	req_access = list(access_security)
	startswith = list(
		/obj/item/grenade/flashbang/clusterbang = 1
	)


/obj/item/storage/lockbox/vials
	name = "secure vial storage box"
	desc = "A locked box for keeping things away from children."
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox0"
	item_state = "syringe_kit"
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = null
	storage_slots = 12
	req_access = list(access_virology)

/obj/item/storage/lockbox/vials/New()
	..()
	update_icon()

/obj/item/storage/lockbox/vials/on_update_icon()
	var/total_contents = count_by_type(contents, /obj/item/reagent_containers/glass/beaker/vial)
	src.icon_state = "vialbox[floor(total_contents/2)]"
	ClearOverlays()
	if (!broken)
		AddOverlays(image(icon, src, "led[locked]"))
		if(locked)
			AddOverlays(image(icon, src, "cover"))
	else
		AddOverlays(image(icon, src, "ledb"))
	return

/obj/item/storage/lockbox/vials/use_tool(obj/item/W, mob/living/user, list/click_params)
	. = ..()
	update_icon()
