/obj/item/material/folder
	name = "folder"
	desc = "A folder."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "folder"
	item_state = "clipboard"
	default_material = MATERIAL_CARDBOARD
	applies_material_name = FALSE
	applies_material_colour = FALSE
	unbreakable = TRUE
	matter = list(MATERIAL_CARDBOARD = 70)
	w_class = ITEM_SIZE_SMALL

	/// The window name to use for folder UIs
	var/window_name = "gray folder"


/obj/item/material/folder/Destroy()
	QDEL_CONTENTS
	return ..()


/obj/item/material/folder/Initialize()
	. = ..()
	update_icon()


/obj/item/material/folder/on_update_icon()
	ClearOverlays()
	if (length(contents))
		AddOverlays("folder_paper")


/obj/item/material/folder/use_tool(obj/item/item, mob/living/user, list/click_params)
	if (is_type_in_list(item, list(/obj/item/paper, /obj/item/photo, /obj/item/paper_bundle)))
		if (!user.unEquip(item, src))
			FEEDBACK_UNEQUIP_FAILURE(user, item)
			return TRUE
		user.visible_message(
			SPAN_ITALIC("\The [user] adds \a [item] to \a [src]."),
			SPAN_ITALIC("You add \the [item] to \the [src]."),
			range = 5
		)
		update_icon()
		return TRUE
	if (istype(item, /obj/item/pen))
		var/response = input(user, null, "Label \the [src]") as null | text
		response = sanitize(response, MAX_LNAME_LEN)
		if (!response)
			return TRUE
		if (user.stat || !user.IsHolding(item) || !Adjacent(user))
			to_chat(user, SPAN_WARNING("You're no longer able to do that."))
			return TRUE
		AddLabel(response, user)
		return TRUE
	return ..()


/obj/item/material/folder/use_after(atom/target, mob/living/user, click_parameters)
	if (is_type_in_list(target, list(/obj/item/paper, /obj/item/photo, /obj/item/paper_bundle)))
		if (istype(src, /obj/item/material/folder/envelope))
			var/obj/item/material/folder/envelope/envelope = src
			if (envelope.sealed)
				to_chat(user, SPAN_WARNING("\The [src] is sealed."))
				return TRUE
		user.visible_message(
			SPAN_ITALIC("\The [user] adds \a [target] to \a [src]."),
			SPAN_ITALIC("You add \the [target] to \the [src]."),
			range = 5
		)
		var/obj/obj = target
		obj.forceMove(src)
		if (istype(target, /obj/item/paper))
			var/obj/item/material/folder/clipboard/clipboard = src
			if (istype(clipboard))
				clipboard.top_paper = target
		update_icon()
		return TRUE
	return ..()


/obj/item/material/folder/attack_self(mob/living/user)
	var/list/document = list("<title>Folder</title>")
	for (var/obj/item/item as anything in contents)
		if (!istype(item, /obj/item/paper) && !istype(item, /obj/item/photo) && !istype(item, /obj/item/paper_bundle))
			continue
		var/ref = any2ref(item)
		document += "[aref(item.name, "view=[ref]")] [aref("Remove", "remove=[ref]")]<br>"
	show_browser(user, jointext(document, ""), "window=[window_name]")
	onclose(user, window_name)
	add_fingerprint(usr)


/obj/item/material/folder/MouseDrop(atom/over_atom)
	if (!ishuman(usr))
		return
	if (!istype(over_atom, /obj/screen))
		return ..()
	if (!CanPhysicallyInteractWith(usr, src))
		return
	var/obj/screen/screen = over_atom
	switch (screen.name)
		if ("r_hand")
			if (usr.unEquip(src))
				usr.put_in_r_hand(src)
		if ("l_hand")
			if (usr.unEquip(src))
				usr.put_in_l_hand(src)
	add_fingerprint(usr)


/obj/item/material/folder/Topic(href_text, list/href_list, datum/topic_state/state)
	if (!CanPhysicallyInteractWith(usr, src))
		to_chat(usr, SPAN_WARNING("You're no longer able to do that!"))
		return
	if (href_list["view"])
		var/obj/item/item = locate(href_list["view"]) in contents
		if (!item)
			to_chat(usr, SPAN_WARNING("That's no longer held by \the [src]."))
			return
		examinate(usr, item)
		return
	if (href_list["remove"])
		var/obj/item/item = locate(href_list["remove"]) in contents
		if (!item)
			to_chat(usr, SPAN_WARNING("That's no longer held by \the [src]."))
			return
		usr.put_in_hands(item)
		attack_hand(usr)
		update_icon()
		return


/obj/item/material/folder/shatter()
	DROP_CONTENTS
	..()


/obj/item/material/folder/blue
	desc = "A blue folder."
	icon_state = "folder_blue"
	window_name = "blue folder"


/obj/item/material/folder/red
	desc = "A red folder."
	icon_state = "folder_red"
	window_name = "red folder"


/obj/item/material/folder/yellow
	desc = "A yellow folder."
	icon_state = "folder_yellow"
	window_name = "yellow folder"


/obj/item/material/folder/white
	desc = "A white folder."
	icon_state = "folder_white"
	window_name = "white folder"


/obj/item/material/folder/nt
	desc = "A corporate folder."
	icon_state = "folder_nt"
	window_name = "corporate folder"


/obj/item/material/folder/envelope
	name = "envelope"
	desc = "A thick envelope."
	icon_state = "envelope0"
	window_name = "envelope"

	/// Whether the envelope has been opened or not
	var/sealed = FALSE

	/// If this envelope was sealed with a stamp, the stamp name
	var/seal_stamp


/obj/item/material/folder/envelope/preset
	icon_state = "envelope_sealed"
	sealed = TRUE
	seal_stamp = "\improper SCG Expeditionary Command rubber stamp"


/obj/item/material/folder/envelope/on_update_icon()
	if (sealed)
		icon_state = "envelope_sealed"
	else
		icon_state = "envelope[length(contents) > 0]"


/obj/item/material/folder/envelope/examine(mob/user, distance, is_adjacent)
	. = ..()
	if (distance > 3 && !isobserver(user))
		return
	var/message = "The seal is [sealed ? "intact" : "broken"]."
	if (seal_stamp)
		message = "It has a seal from \a [seal_stamp]. [message]"
	to_chat(user, message)


/obj/item/material/folder/envelope/proc/Unseal(mob/living/user)
	if (user)
		var/response = alert(user, "Break the seal on \the [src]?", null, "Yes", "No")
		if (response != "Yes")
			return FALSE
		if (user.stat || !Adjacent(user))
			to_chat(user, SPAN_WARNING("You're no longer able to do that."))
			return FALSE
		user.visible_message(
			SPAN_ITALIC("\The [user] breaks the seal on \a [src]."),
			SPAN_ITALIC("You break the seal on \the [src]."),
			range = 5
		)
	sealed = FALSE
	update_icon()
	return TRUE


/obj/item/material/folder/envelope/attack_self(mob/living/user)
	if (sealed && !Unseal(user))
		return
	return ..()


/obj/item/material/folder/envelope/use_tool(obj/item/item, mob/living/user, list/click_params)
	if (sealed)
		Unseal(user)
		return TRUE
	else if (is_type_in_list(item, list(/obj/item/stamp, /obj/item/clothing/ring/seal)))
		sealed = TRUE
		seal_stamp = item.name
		user.visible_message(
			SPAN_ITALIC("\The [user] seals \a [src] with \a [item]."),
			SPAN_ITALIC("You seal \the [src] with \the [item]."),
			range = 5
		)
		playsound(src, 'sound/effects/stamp.ogg', 50, TRUE)
		update_icon()
		return TRUE
	return ..()


/obj/item/material/folder/clipboard
	name = "clipboard"
	desc = "It's a board with a clip used to organise papers."
	icon_state = "clipboard"
	force = 2
	throwforce = 3
	throw_speed = 3
	throw_range = 10
	slot_flags = SLOT_BELT
	applies_material_colour = TRUE
	default_material = MATERIAL_WOOD
	matter = list(MATERIAL_WOOD = 70)
	window_name = "wood clipboard"

	var/obj/item/pen/stored_pen

	var/obj/item/paper/top_paper


/obj/item/material/folder/clipboard/Destroy()
	stored_pen = null
	top_paper = null
	return ..()


/obj/item/material/folder/clipboard/Initialize()
	. = ..()
	desc += " It's made of [material.use_name]."


/obj/item/material/folder/clipboard/on_update_icon()
	ClearOverlays()
	color = material.icon_colour
	alpha = 100 + material.opacity * 255
	if (top_paper)
		AddOverlays(overlay_image(top_paper.icon, top_paper.icon_state, flags = RESET_COLOR))
		CopyOverlays(top_paper)
	if (stored_pen)
		AddOverlays(overlay_image(icon, "clipboard_pen", flags = RESET_COLOR))
	AddOverlays(overlay_image(icon, "clipboard_over", flags = RESET_COLOR))


/obj/item/material/folder/clipboard/use_after(atom/target, mob/living/user, click_parameters)
	if (istype(target, /obj/item/pen))
		if (stored_pen)
			to_chat(user, SPAN_WARNING("\The [src] already has \a [stored_pen] attached."))
			return
		var/obj/item/pen/pen = target
		pen.forceMove(src)
		user.visible_message(
			SPAN_ITALIC("\The [user] adds \a [pen] to \a [src]."),
			SPAN_ITALIC("You add \the [pen] to \the [src]."),
			range = 5
		)
		stored_pen = pen
		update_icon()
		return TRUE
	return ..()


/obj/item/material/folder/clipboard/use_tool(obj/item/item, mob/living/user, list/click_params)
	if (is_type_in_list(item, list(/obj/item/pen, /obj/item/stamp, /obj/item/clothing/ring/seal)))
		if (top_paper)
			top_paper.use_tool(item, user)
			return TRUE
		if (!istype(item, /obj/item/pen))
			return TRUE
		if (stored_pen)
			to_chat(usr, SPAN_WARNING("\A [stored_pen] is already held by \the [src]."))
			return TRUE
		if (!user.unEquip(item, src))
			FEEDBACK_UNEQUIP_FAILURE(user, item)
		else
			user.visible_message(
				SPAN_ITALIC("\The [user] adds \a [item] to \a [src]."),
				SPAN_ITALIC("You add \the [item] to \the [src]."),
				range = 5
			)
			stored_pen = item
			update_icon()
		return TRUE
	. = ..()
	if (istype(item, /obj/item/paper) && (item in contents))
		top_paper = item
		update_icon()


/obj/item/material/folder/clipboard/attack_self(mob/living/user)
	var/list/document = list("<title>Clipboard</title><center>")
	if (stored_pen)
		document += aref("Take [stored_pen.name]", "getpen=1")
	else
		var/obj/item/pen/pen = usr.IsHolding(/obj/item/pen)
		if (pen)
			document += aref("Store [pen.name]", "putpen=1")
		else
			document += "-"
	document += "</center><br><hr>"
	for (var/i = length(contents) to 1 step -1)
		var/obj/item/item = contents[i]
		if (!is_type_in_list(item, list(/obj/item/paper, /obj/item/photo, /obj/item/paper_bundle)))
			continue
		var/ref = any2ref(item)
		document += "[aref(item.name, "view=[ref]")] [aref("Write", "write=[ref]")] \
			[aref("Rename", "rename=[ref]")] [aref("Remove", "remove=[ref]")]<br>"
	show_browser(user, jointext(document, ""), "window=[window_name]")
	onclose(user, window_name)
	add_fingerprint(usr)


/obj/item/material/folder/clipboard/Topic(href_text, list/href_list, datum/topic_state/state)
	if (!CanPhysicallyInteractWith(usr, src))
		to_chat(usr, SPAN_WARNING("You're no longer able to do that!"))
		return
	if (href_list["write"])
		var/obj/item/item = locate(href_list["write"]) in contents
		if (!item)
			to_chat(usr, SPAN_WARNING("That's no longer held by \the [src]."))
			return
		var/obj/item/pen/pen = usr.IsHolding(/obj/item/pen)
		if (!pen && istype(usr.back, /obj/item/rig))
			var/obj/item/rig/rig = usr.back
			if (rig.offline)
				return
			var/obj/item/rig_module/device/pen/module = locate() in rig.installed_modules
			pen = module?.device
		if (!pen)
			pen = stored_pen
			if (!pen)
				to_chat(usr, SPAN_WARNING("You have no pen to write with."))
				return
		item.use_tool(pen, usr)
		update_icon()
		return
	if (href_list["rename"])
		var/obj/item/item = locate(href_list["rename"]) in contents
		if (!item)
			to_chat(usr, SPAN_WARNING("That's no longer held by \the [src]."))
			return
		if (istype(item, /obj/item/paper))
			var/obj/item/paper/paper = item
			paper.rename()
			attack_self(usr)
		else if (istype(item, /obj/item/photo))
			var/obj/item/photo/photo = item
			photo.rename()
			attack_self(usr)
		return
	if (href_list["getpen"])
		if (!istype(stored_pen))
			to_chat(usr, SPAN_WARNING("\The [src] does not hold any pen."))
			return
		usr.visible_message(
			SPAN_ITALIC("\The [usr] removes \a [stored_pen] from \a [src]."),
			SPAN_ITALIC("You remove \the [stored_pen] from \the [src]."),
			range = 5
		)
		usr.put_in_hands(stored_pen)
		stored_pen = null
		attack_self(usr)
		update_icon()
		return
	if (href_list["putpen"])
		if (stored_pen)
			to_chat(usr, SPAN_WARNING("\A [stored_pen] is already held by \the [src]."))
			return
		var/obj/item/pen/pen = usr.IsHolding(/obj/item/pen)
		if (!pen)
			to_chat(usr, SPAN_WARNING("You have no pen to store in \the [src]."))
			return
		if (!usr.unEquip(pen, src))
			return
		usr.visible_message(
			SPAN_ITALIC("\The [usr] stores \a [pen] in \a [src]."),
			SPAN_ITALIC("You store \the [pen] in \the [src]."),
			range = 5
		)
		stored_pen = pen
		attack_self(usr)
		update_icon()
		return
	..()


/obj/item/material/folder/clipboard/ebony
	default_material = MATERIAL_EBONY
	matter = list(MATERIAL_EBONY = 70)
	window_name = "ebony clipboard"


/obj/item/material/folder/clipboard/steel
	default_material = MATERIAL_STEEL
	matter = list(MATERIAL_STEEL = 70)
	window_name = "steel clipboard"


/obj/item/material/folder/clipboard/aluminium
	default_material = MATERIAL_ALUMINIUM
	matter = list(MATERIAL_ALUMINIUM = 70)
	window_name = "aluminium clipboard"


/obj/item/material/folder/clipboard/glass
	default_material = MATERIAL_GLASS
	matter = list(MATERIAL_GLASS = 70)
	window_name = "glass clipboard"
	unbreakable = FALSE


/obj/item/material/folder/clipboard/plastic
	default_material = MATERIAL_PLASTIC
	matter = list(MATERIAL_PLASTIC = 70)
	window_name = "plastic clipboard"
