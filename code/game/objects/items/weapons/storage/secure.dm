/*
 *	Absorbs /obj/item/weapon/secstorage.
 *	Reimplements it only slightly to use existing storage functionality.
 *
 *	Contains:
 *		Secure Briefcase
 *		Wall Safe
 */

// -----------------------------
//         Generic Item
// -----------------------------
/obj/item/weapon/storage/secure
	name = "secstorage"
	var/icon_locking = "secureb"
	var/icon_sparking = "securespark"
	var/icon_opened = "secure0"
	var/locked = 1
	var/code = ""
	var/l_code = null
	var/l_set = 0
	var/l_setshort = 0
	var/l_hacking = 0
	var/emagged = 0
	var/open = 0
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = DEFAULT_BOX_STORAGE

	examine(mob/user)
		if(..(user, 1))
			to_chat(user, text("The service panel is [src.open ? "open" : "closed"]."))

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(locked)
			if (istype(W, /obj/item/weapon/melee/energy/blade) && emag_act(INFINITY, user, "You slice through the lock of \the [src]"))
				var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
				spark_system.set_up(5, 0, src.loc)
				spark_system.start()
				playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
				playsound(src.loc, "sparks", 50, 1)
				return

			if(isScrewdriver(W))
				if (do_after(user, 20, src))
					src.open =! src.open
					user.show_message(text("<span class='notice'>You [] the service panel.</span>", (src.open ? "open" : "close")))
				return
			if(isMultitool(W) && (src.open == 1)&& (!src.l_hacking))
				user.show_message("<span class='notice'>Now attempting to reset internal memory, please hold.</span>", 1)
				src.l_hacking = 1
				if (do_after(usr, 100, src))
					if (prob(40))
						src.l_setshort = 1
						src.l_set = 0
						user.show_message("<span class='notice'>Internal memory reset. Please give it a few seconds to reinitialize.</span>", 1)
						sleep(80)
						src.l_setshort = 0
						src.l_hacking = 0
					else
						user.show_message("<span class='warning'>Unable to reset internal memory.</span>", 1)
						src.l_hacking = 0
				else	src.l_hacking = 0
				return
			//At this point you have exhausted all the special things to do when locked
			// ... but it's still locked.
			return

		// -> storage/attackby() what with handle insertion, etc
		..()


	MouseDrop(over_object, src_location, over_location)
		if (locked)
			src.add_fingerprint(usr)
			return
		..()


	attack_self(mob/user as mob)
		user.set_machine(src)
		var/dat = text("<TT><B>[]</B><BR>\n\nLock Status: []",src, (src.locked ? "LOCKED" : "UNLOCKED"))
		var/message = "Code"
		if ((src.l_set == 0) && (!src.emagged) && (!src.l_setshort))
			dat += text("<p>\n<b>5-DIGIT PASSCODE NOT SET.<br>ENTER NEW PASSCODE.</b>")
		if (src.emagged)
			dat += text("<p>\n<font color=red><b>LOCKING SYSTEM ERROR - 1701</b></font>")
		if (src.l_setshort)
			dat += text("<p>\n<font color=red><b>ALERT: MEMORY SYSTEM ERROR - 6040 201</b></font>")
		message = text("[]", src.code)
		if (!src.locked)
			message = "*****"
		dat += text("<HR>\n>[]<BR>\n<A href='?src=\ref[];type=1'>1</A>-<A href='?src=\ref[];type=2'>2</A>-<A href='?src=\ref[];type=3'>3</A><BR>\n<A href='?src=\ref[];type=4'>4</A>-<A href='?src=\ref[];type=5'>5</A>-<A href='?src=\ref[];type=6'>6</A><BR>\n<A href='?src=\ref[];type=7'>7</A>-<A href='?src=\ref[];type=8'>8</A>-<A href='?src=\ref[];type=9'>9</A><BR>\n<A href='?src=\ref[];type=R'>R</A>-<A href='?src=\ref[];type=0'>0</A>-<A href='?src=\ref[];type=E'>E</A><BR>\n</TT>", message, src, src, src, src, src, src, src, src, src, src, src, src)
		user << browse(dat, "window=caselock;size=300x280")

	Topic(href, href_list)
		..()
		if ((usr.stat || usr.restrained()) || (get_dist(src, usr) > 1))
			return
		if (href_list["type"])
			if (href_list["type"] == "E")
				if ((src.l_set == 0) && (length(src.code) == 5) && (!src.l_setshort) && (src.code != "ERROR"))
					src.l_code = src.code
					src.l_set = 1
				else if ((src.code == src.l_code) && (src.emagged == 0) && (src.l_set == 1))
					src.locked = 0
					overlays.Cut()
					overlays += image('icons/obj/storage.dmi', icon_opened)
					src.code = null
				else
					src.code = "ERROR"
			else
				if ((href_list["type"] == "R") && (src.emagged == 0) && (!src.l_setshort))
					src.locked = 1
					overlays.Cut()
					src.code = null
					src.close(usr)
				else
					src.code += text("[]", href_list["type"])
					if (length(src.code) > 5)
						src.code = "ERROR"
			for(var/mob/M in viewers(1, src.loc))
				if ((M.client && M.machine == src))
					src.attack_self(M)
				return
		return

/obj/item/weapon/storage/secure/emag_act(var/remaining_charges, var/mob/user, var/feedback)
	if(!emagged)
		emagged = 1
		src.overlays += image('icons/obj/storage.dmi', icon_sparking)
		sleep(6)
		overlays.Cut()
		overlays += image('icons/obj/storage.dmi', icon_locking)
		locked = 0
		to_chat(user, (feedback ? feedback : "You short out the lock of \the [src]."))
		return 1

// -----------------------------
//        Secure Briefcase
// -----------------------------
/obj/item/weapon/storage/secure/briefcase
	name = "secure briefcase"
	icon = 'icons/obj/storage.dmi'
	icon_state = "secure"
	item_state = "sec-case"
	desc = "A large briefcase with a digital locking system."
	force = 8.0
	throw_speed = 1
	throw_range = 4
	w_class = ITEM_SIZE_HUGE
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_BACKPACK_STORAGE
	use_sound = 'sound/effects/storage/briefcase.ogg'

	attack_hand(mob/user as mob)
		if ((src.loc == user) && (src.locked == 1))
			to_chat(usr, "<span class='warning'>[src] is locked and cannot be opened!</span>")
		else if ((src.loc == user) && (!src.locked))
			src.open(usr)
		else
			..()
			for(var/mob/M in range(1))
				if (M.s_active == src)
					src.close(M)
		src.add_fingerprint(user)
		return

// -----------------------------
//        Secure Safe
// -----------------------------

/obj/item/weapon/storage/secure/safe
	name = "secure safe"
	icon = 'icons/obj/storage.dmi'
	icon_state = "safe"
	icon_opened = "safe0"
	icon_locking = "safeb"
	icon_sparking = "safespark"
	force = 8.0
	w_class = ITEM_SIZE_NO_CONTAINER
	max_w_class = ITEM_SIZE_HUGE
	max_storage_space = 56
	anchored = 1.0
	density = 0
	cant_hold = list(/obj/item/weapon/storage/secure/briefcase)

	New()
		..()
		new /obj/item/weapon/paper(src)
		new /obj/item/weapon/pen(src)

	attack_hand(mob/user as mob)
		return attack_self(user)

/obj/item/weapon/storage/secure/safe/HoS/New()
	..()
	//new /obj/item/weapon/storage/lockbox/clusterbang(src) This item is currently broken... and probably shouldnt exist to begin with (even though it's cool)

// -----------------------------
//        Alert Safe
// -----------------------------

//Safe that only unlocks under red alert, and relocks once red alert is removed.

/obj/item/weapon/storage/secure/alert_safe
	name = "personal arms safe"
	max_storage_space = 24
	req_access = list(access_bridge)
	icon = 'icons/obj/storage.dmi'
	icon_state = "safe"
	icon_opened = "safe0"
	icon_locking = "safeb"
	var/icon_armed = "safe_r"
	icon_sparking = "safespark"
	force = 8.0
	w_class = ITEM_SIZE_NO_CONTAINER
	max_w_class = ITEM_SIZE_HUGE
	anchored = 1.0
	density = 0
	cant_hold = list(/obj/item/weapon/storage/secure/briefcase)
	startswith = list(
	/obj/item/weapon/gun/energy/taser = 1,
	/obj/item/weapon/gun/projectile/revolver/hi2521r = 1,
	/obj/item/ammo_magazine/c44 = 2
	)

	var/alert_unlocked = FALSE
	var/secure = TRUE
	var/next_reminder

	//Registered gear. This is gear that -must- be returned to the safe for it to re-lock fully. Also needs to be in startswith
	//Name and number of items is generated on Initialize()
	var/list/registered_gear = list(/obj/item/weapon/gun/energy/taser, /obj/item/weapon/gun/projectile/revolver/hi2521r)

/obj/item/weapon/storage/secure/alert_safe/New()
	..()
	GLOB.alert_locked += src

/obj/item/weapon/storage/secure/alert_safe/Initialize()
	. = ..()
	for(var/obj/item/I in contents)	//Because we cannot grab a name var from a path, we fetch it here and store it for later
		if(I.type in registered_gear)
			if(length(registered_gear[I.type]))
				registered_gear[I.type]["target"]++
				registered_gear[I.type]["current"]++
			else
				registered_gear[I.type] = list("name" = I.name, "target" = 1, "current" = 1)

/obj/item/weapon/storage/secure/alert_safe/Destroy()
	GLOB.alert_locked -= src
	. = ..()

/obj/item/weapon/storage/secure/alert_safe/MouseDrop(over_object, src_location, over_location)
	if(locked || secure)
		src.add_fingerprint(usr)
		return
	..()

/obj/item/weapon/storage/secure/alert_safe/proc/check_arms(var/return_missing = FALSE)
	if(return_missing)
		var/list/wanted = list()
		for(var/R in registered_gear)
			var/current = registered_gear[R]["current"]
			var/target = registered_gear[R]["target"]
			if(current < target)
				wanted.Add(list(list("name" = registered_gear[R]["name"], "amount" = target - current)))
		return wanted
	else
		for(var/R in registered_gear)
			if(registered_gear[R]["current"] < registered_gear[R]["target"])
				return FALSE
		return TRUE

/obj/item/weapon/storage/secure/alert_safe/proc/alert_unlock(var/unlocked)
	alert_unlocked = unlocked
	if(alert_unlocked)
		spawn(2 SECONDS)
			STOP_PROCESSING(SSobj, src)
			if(secure)
				playsound(src,'sound/urist/buzzclick.ogg',100,0)
				visible_message("<span class='info'>\The [src] buzzes and clicks as its automatic locks disengage.</span>")
				secure = FALSE
			overlays.Cut()
			overlays += image(icon, locked ? icon_armed : icon_opened)
			next_reminder = null
	else if(check_arms() && locked)
		secure = TRUE
		overlays.Cut()
		playsound(src,'sound/effects/metal_close.ogg',25,0)
		visible_message("<span class='notice'>\The [src] clicks as its automatic locks engage.</span>")	
	else
		next_reminder = 60
		START_PROCESSING(SSobj, src)

/obj/item/weapon/storage/secure/alert_safe/Process(var/wait)	//Time to bug people until they lock the safe & return the weapons
	if(!secure)
		secure = check_arms() && locked
		if(secure)
			next_reminder = null
			STOP_PROCESSING(SSobj, src)
			overlays.Cut()
			playsound(src,'sound/effects/metal_close.ogg',25,0)
			visible_message("<span class='notice'>\The [src] clicks as its automatic locks engage.</span>")	
		else
			if(next_reminder)
				next_reminder = max(next_reminder - (wait /10),0)
			else
				next_reminder = 60
				playsound(src,'sound/machines/buzz-two.ogg',30,0)
				visible_message("<span class='warning'>\The [src] flashes an error: [locked ? "Registered arms not present." : "User lock not engaged."]</span>")
	else	//Shouldn't be possible, but just in case
		STOP_PROCESSING(SSobj, src)

/obj/item/weapon/storage/secure/alert_safe/attack_hand(mob/user as mob)
	return attack_self(user)

/obj/item/weapon/storage/secure/alert_safe/attack_self(mob/user as mob)
	ui_interact(user)

/obj/item/weapon/storage/secure/alert_safe/emag_act(var/remaining_charges, var/mob/user, var/feedback)
	if(..())
		STOP_PROCESSING(SSobj, src)
		GLOB.alert_locked -= src	//Remove it from the GLOB list so further alert changes have no effect
		secure = 0
		return 1

/obj/item/weapon/storage/secure/alert_safe/handle_item_insertion(var/obj/item/W, var/prevent_warning = 0, var/NoUpdate = 0)
	. = ..()
	if(.)
		if(W.type in registered_gear)
			registered_gear[W.type]["current"]++

/obj/item/weapon/storage/secure/alert_safe/remove_from_storage(obj/item/W as obj, atom/new_location, var/NoUpdate = 0)
	. = ..()
	if(.)
		if(W.type in registered_gear)
			registered_gear[W.type]["current"]--

/obj/item/weapon/storage/secure/alert_safe/ui_interact(mob/user, ui_key="main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/data[0]
	var/a_status

	if(secure)
		a_status = "ENGAGED"
	else
		if(alert_unlocked)
			a_status = "DISENGAGED"
		else
			a_status = "ARMED"
			var/list/missing = check_arms(TRUE)
			if(length(missing))
				data["missing"] = missing

	data["a_status"] = a_status
	data["lock"] = locked
	data["emagged"] = emagged
	data["has_access"] = allowed(user)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "alarm_safe.tmpl", src.name, 400, 200)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/item/weapon/storage/secure/alert_safe/OnTopic(var/mob/user, var/list/href_list, state)
	if(..())
		return 1
	if(!allowed(user))
		return 1
	if(href_list["lock"])
		locked = text2num(href_list["lock"])
		overlays.Cut()
		if(!secure)
			overlays += image(icon, locked ? icon_armed : icon_opened)
	return 1

/obj/item/weapon/storage/secure/alert_safe/so
	name = "second officer's arms safe"
	req_access = list(access_hop)
	startswith = list(
		/obj/item/weapon/gun/energy/gun/secure = 1,
		/obj/item/weapon/gun/projectile/revolver/hi2521r = 1,
		/obj/item/ammo_magazine/c44 = 2
		)

	registered_gear = list(
		/obj/item/weapon/gun/projectile/revolver/hi2521r,
		/obj/item/weapon/gun/energy/gun/secure
		)