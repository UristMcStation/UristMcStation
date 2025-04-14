//ported from aurora! this item makes life harder for AIs and people with headsets.

/obj/proc/ai_can_interact(mob/user)
	if(!Adjacent(user) && within_jamming_range(src, FALSE)) // if not adjacent to it, it uses wireless signal
		to_chat(user, SPAN_WARNING("Something in the area of \the [src] is blocking the remote signal!"))
		return FALSE
	return TRUE

//Global list for housing active radio_jammers:
var/global/list/active_radio_jammers = list()

// tests if an object is near a radio jammer
// if need_all_blocked is false, the jammer only needs to be on JAMMER_SYNTHETIC to work
/proc/within_jamming_range(atom/test, need_all_blocked = TRUE)
	if(length(active_radio_jammers))
		var/turf/our_turf = get_turf(test)
		for(var/obj/item/device/radio_jammer_urist/J in active_radio_jammers)
			var/turf/jammer_turf = get_turf(J)
			if(our_turf.z != jammer_turf.z)
				continue
			if(get_dist(our_turf, jammer_turf) <= J.radius)
				if(need_all_blocked && J.active != JAMMER_ALL)
					continue
				return TRUE
	return FALSE

/obj/item/device/radio_jammer_urist
	name = "radio jammer"
	desc = "A small, inconspicious looking item with an 'ON/OFF' toggle. Right-click to toggle whether it blocks all wireless signals, or just stationbound wireless interfacing."
	icon = 'icons/urist/obj/device.dmi'
	icon_state = "shield0"
	w_class = ITEM_SIZE_SMALL
	var/active = JAMMER_OFF
	var/radius = 7
	var/icon_state_active = "shield1"
	var/icon_state_inactive = "shield0"

/obj/item/device/radio_jammer_urist/active
	active = JAMMER_ALL

/obj/item/device/radio_jammer_urist/Initialize()
	. = ..()
	update_icon()

/obj/item/device/radio_jammer_urist/Destroy()
	active_radio_jammers -= src
	return ..()

/obj/item/device/radio_jammer_urist/verb/toggle_jammer()
	set name = "Change Jammer Blocking"
	set category = "Object"
	set src in usr
	set_jammer(usr)

/obj/item/device/radio_jammer_urist/attack_self(mob/user)
	toggle(user)

/obj/item/device/radio_jammer_urist/proc/set_jammer(mob/user)
	var/response = alert(user, "What would you like to block?", "Jammer Settings", "Nothing", "Synthetics", "All")
	if(response == "Nothing")
		active = JAMMER_OFF
	if(response == "Synthetics")
		active = JAMMER_SYNTHETIC
	if(response == "All")
		active = JAMMER_ALL
	update_icon()

/obj/item/device/radio_jammer_urist/emp_act(severity)
	. = ..()

	toggle()

/obj/item/device/radio_jammer_urist/proc/toggle(mob/user)
	if(active)
		if(user)
			to_chat(user, SPAN_NOTICE("You deactivate \the [src]."))
		active = JAMMER_OFF
	else
		if(user)
			to_chat(user, SPAN_NOTICE("You activate \the [src], setting it to block all signals."))
		active = JAMMER_ALL
	update_icon()

/obj/item/device/radio_jammer_urist/on_update_icon()
	if(active > 0)
		active_radio_jammers += src
		icon_state = icon_state_active
	else
		active_radio_jammers -= src
		icon_state = icon_state_inactive


/obj/item/device/radio_jammer_urist/improvised
	name = "improvised radio jammer"
	desc = "An awkward bundle of wires, batteries, and radio transmitters, with an 'ON/OFF' toggle. Right-click to toggle whether it blocks all wireless signals, or just stationbound wireless interfacing."
	var/obj/item/cell/cell
	var/obj/item/device/assembly_holder/assembly_holder
	// 25 seconds of operation on a standard cell. 100 on a super cap.
	var/power_drain_per_second = 20
	var/last_updated = null
	radius = 5
	icon = 'icons/urist/obj/device.dmi'
	icon_state = "improvised_jammer_inactive"
	icon_state_active = "improvised_jammer_active"


/obj/item/device/radio_jammer_urist/improvised/New(obj/item/device/assembly_holder/incoming_holder, obj/item/cell/incoming_cell, mob/user)
	..()
	cell = incoming_cell
	assembly_holder = incoming_holder

	// Spawn() required to properly move the assembly. Why? No clue!
	// This does not make any sense, but sure.
	spawn(0)
		incoming_holder.forceMove(src, 1)
		incoming_cell.forceMove(src, 1)

	user.put_in_active_hand(src)

/obj/item/device/radio_jammer_urist/improvised/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/device/radio_jammer_urist/improvised/examine(mob/user)
	. = ..()
	if(cell)
		to_chat(user, SPAN_NOTICE("Its display shows: [cell.percent()]%."))

/obj/item/device/radio_jammer_urist/improvised/Process()
	var/current = world.time // current tick
	var/delta = (current - last_updated) / 10.0 // delta in seconds
	last_updated = current
	if (!cell.use(delta * power_drain_per_second))
		active = JAMMER_OFF
		cell.charge = 0 // drain the last of the battery
		update_icon()


/obj/item/device/radio_jammer_urist/improvised/use_tool(obj/item/I, mob/user, click_params)
	if (I.IsScrewdriver())
		to_chat(user, "<span class='notice'>You disassemble the improvised signal jammer.</span>")
		user.put_in_hands(assembly_holder)
		assembly_holder.detached()
		user.put_in_hands(cell)
		qdel(src)
		return TRUE

/obj/item/device/radio_jammer_urist/improvised/toggle(mob/user)
	if(!active)
		if(!cell)
			if(user)
				to_chat(user, SPAN_WARNING("\The [src] has no cell!"))
			return
		if(!cell.charge)
			if(user)
				to_chat(user, SPAN_WARNING("\The [src]'s battery is completely empty!"))
			return
	return ..()

/obj/item/device/radio_jammer_urist/improvised/on_update_icon()
	if(active > 0)
		active_radio_jammers += src
		icon_state = icon_state_active
		START_PROCESSING(SSprocessing, src)
		last_updated = world.time
	else
		active_radio_jammers -= src
		icon_state = initial(icon_state)
		STOP_PROCESSING(SSprocessing, src)
