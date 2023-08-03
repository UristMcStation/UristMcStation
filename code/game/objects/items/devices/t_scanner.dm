#define OVERLAY_CACHE_LEN 50

/obj/item/device/t_scanner
	name = "\improper T-ray scanner"
	desc = "A terahertz-ray emitter and scanner, capable of penetrating conventional hull materials."
	icon = 'icons/obj/t_ray_scanner.dmi'
	icon_state = "t-ray0"
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	item_state = "electronic"
	matter = list(MATERIAL_ALUMINIUM = 150)
	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	action_button_name = "Toggle T-Ray scanner"

	var/standard_mode = TRUE
	var/scan_range = 3

	var/on = 0
	var/list/active_scanned = list() //assoc list of objects being scanned, mapped to their overlay
	var/client/user_client //since making sure overlays are properly added and removed is pretty important, so we track the current user explicitly

	var/static/list/overlay_cache = list() //cache recent overlays

/obj/item/device/t_scanner/Destroy()
	. = ..()
	if(on)
		set_active(FALSE)

/obj/item/device/t_scanner/on_update_icon()
	icon_state = "t-ray[on]"

/obj/item/device/t_scanner/emp_act()
	audible_message(SPAN_NOTICE(" \The [src] buzzes oddly."))
	set_active(FALSE)
	..()

/obj/item/device/t_scanner/attack_self(mob/user)
	set_active(!on)
	user.update_action_buttons()

/obj/item/device/t_scanner/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	var/obj/structure/disposalpipe/D = target
	if(D && istype(D))
		to_chat(user, SPAN_INFO("Pipe segment integrity: [100 - D.get_damage_percentage()]%"))

/obj/item/device/t_scanner/proc/set_active(active)
	on = active
	if(on)
		START_PROCESSING(SSfastprocess, src)
	else
		STOP_PROCESSING(SSfastprocess, src)
		set_user_client(null)
	update_icon()

//If reset is set, then assume the client has none of our overlays, otherwise we only send new overlays.
/obj/item/device/t_scanner/Process()
	if(!on) return

	//handle clients changing
	var/client/loc_client = null
	if(ismob(src.loc))
		var/mob/M = src.loc
		loc_client = M.client
	set_user_client(loc_client)

	//no sense processing if no-one is going to see it.
	if(!user_client) return

	//get all objects in scan range
	var/list/scanned = get_scanned_objects(scan_range)
	var/list/update_add = scanned - active_scanned
	var/list/update_remove = active_scanned - scanned

	//Add new overlays
	for(var/atom/A in update_add)
		var/image/overlay = get_overlay(A)
		active_scanned[A] = overlay
		user_client.images += overlay

	//Remove stale overlays
	for(var/atom/A in update_remove)
		user_client.images -= active_scanned[A]
		active_scanned -= A

//creates a new overlay for a scanned object
/obj/item/device/t_scanner/proc/get_overlay(atom/movable/scanned)
	//Use a cache so we don't create a whole bunch of new images just because someone's walking back and forth in a room.
	//Also means that images are reused if multiple people are using t-rays to look at the same objects.
	if(scanned in overlay_cache)
		. = overlay_cache[scanned]
	else
		var/image/I
		if(isturf(scanned))
			I = image(loc = locate(scanned.x, scanned.y, scanned.z-1), icon = 'icons/turf/areas.dmi', icon_state = "unknown")	//Placeholder icon for now
		else
			I = image(loc = scanned, icon = scanned.icon, icon_state = scanned.icon_state)
		I.plane = HUD_PLANE
		I.layer = UNDER_HUD_LAYER
		I.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_ALPHA

		//Pipes are special
		if(istype(scanned, /obj/machinery/atmospherics/pipe))
			var/obj/machinery/atmospherics/pipe/P = scanned
			I.color = P.pipe_color
			I.overlays += P.overlays
			I.underlays += P.underlays

		if(ismob(scanned))
			if(ishuman(scanned))
				var/mob/living/carbon/human/H = scanned
				if(H.species.appearance_flags & SPECIES_APPEARANCE_HAS_SKIN_COLOR)
					I.color = H.skin_color
					I.icon = 'icons/mob/mob.dmi'
					I.icon_state = "phaseout"
			var/mob/M = scanned
			I.color = M.color
			I.overlays += M.overlays
			I.underlays += M.underlays

		I.alpha = 128
		I.mouse_opacity = 0
		. = I

	// Add it to cache, cutting old entries if the list is too long
	overlay_cache[scanned] = .
	if(length(overlay_cache) > OVERLAY_CACHE_LEN)
		overlay_cache.Cut(1, length(overlay_cache)-OVERLAY_CACHE_LEN-1)

/obj/item/device/t_scanner/proc/get_scanned_objects(scan_dist)
	. = list()

	var/turf/center
	if(standard_mode)
		center = get_turf(src.loc)
	else
		center = get_turf(locate(src.loc.x,src.loc.y,src.loc.z+1))
		if(!AreConnectedZLevels(center.z, src.loc.z)) return
	if(!center) return

	for(var/turf/T in range(scan_range, center))
		if(standard_mode)
			for(var/mob/M in T.contents)
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if(H.is_cloaked())
						. += M
				else if(round_is_spooky() && isobserver(M))
					. += M
		else
			if(isopenspace(T))
				. += T

		if(!!T.is_plating())
			continue

		for(var/obj/O in T.contents)
			if(O.level != ATOM_LEVEL_UNDER_TILE)
				continue
			if(!O.invisibility)
				continue //if it's already visible don't need an overlay for it
			. += O



/obj/item/device/t_scanner/proc/set_user_client(client/new_client)
	if(new_client == user_client)
		return
	if(user_client)
		for(var/scanned in active_scanned)
			user_client.images -= active_scanned[scanned]
	if(new_client)
		for(var/scanned in active_scanned)
			new_client.images += active_scanned[scanned]
	else
		active_scanned.Cut()

	user_client = new_client

/obj/item/device/t_scanner/dropped(mob/user)
	set_user_client(null)
	..()

/obj/item/device/t_scanner/verb/switch_mode()
	set name = "Toggle Scanning Mode"
	set category = "Object"

	if (usr.stat || usr.restrained() || usr.incapacitated()) return

	if(on)
		for(var/scanned in active_scanned)
			user_client.images -= active_scanned[scanned]
	active_scanned = list()
	standard_mode = !standard_mode
	to_chat(usr, "<span class='notice'>You set the t-scanner to scan [standard_mode ? "through tiles below you" : "for missing tiles above you"]</span>")

/obj/item/device/t_scanner/AltClick(mob/user)
	if(!CanPhysicallyInteract(user))
		return
	switch_mode()

#undef OVERLAY_CACHE_LEN
