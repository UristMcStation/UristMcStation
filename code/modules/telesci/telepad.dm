///SCI TELEPAD///
/obj/machinery/telepad
	name = "telepad"
	desc = "A bluespace telepad used for teleporting objects to and from a location."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "pad-idle"
	anchored = TRUE
	use_power = 1
	idle_power_usage = 200
	active_power_usage = 5000

//CARGO TELEPAD//
/obj/machinery/telepad_cargo
	name = "cargo telepad"
	desc = "A telepad used by the Rapid Crate Sender."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "pad-idle"
	anchored = TRUE
	use_power = 1
	idle_power_usage = 20
	active_power_usage = 500
	var/stage = 0

/obj/machinery/telepad_cargo/use_tool(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/wrench))
		anchored = FALSE
		playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
		if(anchored)
			anchored = FALSE
			to_chat(user, "<span class = 'caution'> The [src] can now be moved.</span>")
		else if(!anchored)
			anchored = TRUE
			to_chat(user, "<span class = 'caution'> The [src] is now secured.</span>")
		return TRUE

	if(istype(W, /obj/item/screwdriver))
		if(stage == 0)
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			to_chat(user, "<span class = 'caution'> You unscrew the telepad's tracking beacon.</span>")
			stage = 1
		else if(stage == 1)
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			to_chat(user, "<span class = 'caution'> You screw in the telepad's tracking beacon.</span>")
			stage = 0
		return TRUE

	if(istype(W, /obj/item/weldingtool) && stage == 1)
		playsound(src, 'sound/items/Welder.ogg', 50, 1)
		to_chat(user, "<span class = 'caution'> You disassemble the telepad.</span>")
		new /obj/item/stack/material/steel(get_turf(src))
		new /obj/item/stack/material/glass(get_turf(src))
		qdel(src)
		return TRUE

	. = ..()

///TELEPAD CALLER///
/obj/item/device/telepad_beacon
	name = "telepad beacon"
	desc = "Use to warp in a cargo telepad."
	icon = 'icons/obj/machines/beacon.dmi'
	icon_state = "beacon"
	item_state = "signaler"
	origin_tech = "bluespace=3"

/obj/item/device/telepad_beacon/attack_self(mob/user as mob)
	if(user)
		to_chat(user, "<span class = 'caution'> Locked In</span>")
		new /obj/machinery/telepad_cargo(user.loc)
		playsound(src, 'sound/effects/pop.ogg', 100, 1, 1)
		qdel(src)
	return

///HANDHELD TELEPAD USER///
/obj/item/rcs
	name = "rapid-crate-sender (RCS)"
	desc = "Use this to send crates and closets to cargo telepads."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "rcs"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 10.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	var/rcharges = 10
	var/obj/machinery/pad = null
	var/last_charge = 30
	var/mode = 0
	var/rand_x = 0
	var/rand_y = 0
	var/emagged = FALSE
	var/teleporting = 0

/obj/item/rcs/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/item/rcs/examine()
	desc = "Use this to send crates and closets to cargo telepads. There are [rcharges] charges left."
	..()

/obj/item/rcs/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/item/rcs/Process()
	if(rcharges > 10)
		rcharges = 10
	if(last_charge == 0)
		rcharges++
		last_charge = 30
	else
		last_charge--

/obj/item/rcs/attack_self(mob/user)
	if(emagged)
		if(mode == 0)
			mode = 1
			playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, "<span class = 'caution'> The telepad locator has become uncalibrated.</span>")
		else
			mode = 0
			playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, "<span class = 'caution'> You calibrate the telepad locator.</span>")

/obj/item/rcs/emag_act(remaining_charges, mob/user)
	if(!emagged)
		emagged = TRUE
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		to_chat(user, "<span class = 'caution'> You emag the RCS. Click on it to toggle between modes.</span>")
	else
		return
