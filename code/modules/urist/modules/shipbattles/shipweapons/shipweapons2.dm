#define WEAPON_STATUS_RECHARGING 1 //weapon recharging
#define WEAPON_STATUS_RELOADING 2 //weapon is chambering a round from internal magazine
#define WEAPON_STATUS_REQUIRES_RELOAD 3 //weapon requires manual reload.
#define WEAPON_STATUS_OFFLINE 4 //weapon is offline
#define WEAPON_STATUS_READY 5 //weapon is ready to fire
#define WEAPON_STATUS_FIRING 6 //weapon is firing

#define WEAPON_FIREMODE_SINGLE 7 //fires one round.
#define WEAPON_FIREMODE_SALVO 8 //fires rounds one after the other, cycles from magazine.
#define WEAPON_FIREMODE_BURST 9 //fires *all* chambered rounds at once.

/obj/machinery/shipweapons/shipweapons2
	icon = 'icons/urist/structures&machinery/railgun.dmi'
	name = "shipweapontwo"
	desc = "You shouldn't see this. Someone messed up."

	var/obj/item/shipweapons/ammo/chambered //chambered munition, if only firing one at a time.

	var/chamber_sound = 'sound/effects/extout.ogg'
	var/firing_state //animation for firing

	var/accepted_ammo_type = /obj/item/shipweapons/ammo //accepted ammo type.

	var/cooldown = 1 SECOND //cooldown, functionally used in Fire()
	var/magazine_capacity = 0 //internal mag capacity
	var/chamber_delay = 5 SECONDS //delay between firing and loading another round.
	var/chamber_capacity = 1 //if firing multiple munitions, how many?
	var/salvo_rounds = 0 //used in WEAPON_FIREMODE_SALVO to determine how many shots are fired.
	var/salvo_rounds_left = 0 //used in WEAPON_FIREMODE_SALVO

	var/fires_multiple_rounds = FALSE //do we fire more than one round
	var/has_magazine = FALSE //do we have a magazine?
	var/supports_custom_poweruse = FALSE //do we support our rounds using a custom amount of power and recharge time?
	var/automatic_reload = FALSE //requires manual cycling
	var/supports_multiple_fire_modes = FALSE //do we support on-the-fly switching of firemodes?
	var/has_ammo_states = FALSE //icon state changes on ammo status

	var/firemode = WEAPON_FIREMODE_SINGLE //weapon fire mode

	var/list/magazine = list() //internal magazine.
	var/list/chambered_munitions = list() //in case we have weapons that fire more than one round at once.



/obj/machinery/shipweapons/shipweapons2/Charging() //completely redoing this as well to integrate things.
	if(stat & (BROKEN|NOPOWER)) //we're broken, no charging for us.
		return

	if(supports_custom_poweruse)
		if(chambered && chambered.custom_power_draw == TRUE)
			UpdateStatus(WEAPON_STATUS_RECHARGING) //update our status
			active_power_usage = chambered.power_draw
			update_use_power(2)
			recharging = 1
			spawn(chambered.charge_delay)
				active_power_usage = initial(active_power_usage)
				charged = 1
				canfire = 1
				update_use_power(1)
				recharging = 0
				update_icon()
				UpdateStatus(WEAPON_STATUS_READY)
		else //if the round doesn't have special power requirements, do default.
			UpdateStatus(WEAPON_STATUS_RECHARGING)
			update_use_power(2)
			recharging = 1
			update_icon()
			spawn(rechargerate)
				charged = 1
				canfire = 1
				update_use_power(1)
				recharging = 0
				update_icon()
				UpdateStatus(WEAPON_STATUS_READY)

	else if(!supports_custom_poweruse)  //don't bother with checking ammo if we don't even support it.
		UpdateStatus(WEAPON_STATUS_RECHARGING)
		update_use_power(2)
		recharging = 1
		update_icon()
		spawn(rechargerate)
			charged = 1
			canfire = 1
			update_use_power(1)
			recharging = 0
			update_icon()
			UpdateStatus(WEAPON_STATUS_READY)

/obj/machinery/shipweapons/shipweapons2/Fire() //completely redoing this
	if(stat & (BROKEN|NOPOWER)) //we're broken, no firing for us.
		return

	if(!target)
		return

	if(shipid && !linkedcomputer)
		ConnectWeapons()
		return

	if(firemode != WEAPON_FIREMODE_SALVO || WEAPON_FIREMODE_BURST)
		if(!chambered)
			return

	if(cooldown >= world.time)
		return

	if(firemode == WEAPON_FIREMODE_BURST)
		if(chambered_munitions.len == 0)
			return

	else
		if(!firing)
			firing = TRUE
			UpdateStatus(WEAPON_STATUS_FIRING) //and now things get funky.
			switch(firemode)
				if(WEAPON_FIREMODE_SINGLE)
					UpdateStatus(WEAPON_STATUS_FIRING)
					playsound(src, fire_sound, 40, 1)
					flick(firing_state, src)
					handle_firing(chambered.hull_damage, chambered.shield_damage, chambered.shield_pen_chance, chambered.module_damage_chance)
					cooldown = chambered.cooldown
					for(var/mob/M in viewers(5, src))
						shake_camera(M, chambered.camera_shake_amount, 1)
					if(chambered.consumed)
						QDEL_NULL(chambered)
						chambered = null
					else
						eject(chambered)
						chambered = null
					cycle(FALSE, FALSE)

				if(WEAPON_FIREMODE_SALVO)
					UpdateStatus(WEAPON_STATUS_FIRING)
					for(var/I = 0 to salvo_rounds)
						spawn(chambered.cooldown)
						playsound(src, fire_sound, 40, 1)
						flick(firing_state, src)
						handle_firing(chambered.hull_damage, chambered.shield_damage, chambered.shield_pen_chance, chambered.module_damage_chance)
						cooldown = chambered.cooldown
						for(var/mob/M in viewers(5, src))
							shake_camera(M, chambered.camera_shake_amount, 1)
						if(chambered.consumed)
							QDEL_NULL(chambered)
							chambered = null
						else
							eject(chambered)
							chambered = null
						cycle(FALSE, FALSE)

				if(WEAPON_FIREMODE_BURST)
					UpdateStatus(WEAPON_STATUS_FIRING)
					playsound(src, fire_sound, 40, 1)
					flick(firing_state, src)
					var/burst_hulldam
					var/burst_shielddam
					var/burst_shieldpenchance
					var/burst_moduledamchance
					var/shake_amount
					for(var/obj/item/shipweapons/ammo/C in chambered_munitions)
						burst_hulldam += C.hull_damage
						burst_shielddam += C.shield_damage
						burst_shieldpenchance += C.shield_pen_chance
						burst_moduledamchance += C.module_damage_chance
						shake_amount += C.camera_shake_amount
						if(C.consumed)
							QDEL_NULL(C)
						else
							eject(C)
						chambered_munitions -= C
					handle_firing(burst_hulldam, burst_shielddam, burst_shieldpenchance, burst_moduledamchance)
					cycle(FALSE, FALSE)
					for(var/mob/M in viewers(5, src))
						shake_camera(M, shake_amount, 1)

/obj/machinery/shipweapons/shipweapons2/UpdateStatus(var/weapon_status)
	switch(weapon_status)
		if(WEAPON_STATUS_RECHARGING)
			status = "Weapon Recharging"
		if(WEAPON_STATUS_RELOADING)
			status = "Weapom Reloading"
		if(WEAPON_STATUS_REQUIRES_RELOAD)
			status = "Manual weapon reload required"
		if(WEAPON_STATUS_OFFLINE)
			status = "Weapon Offline"
		if(WEAPON_STATUS_READY)
			status = "Weapon Ready"
		if(WEAPON_STATUS_FIRING)
			status = "Weapon Firing"

/obj/machinery/shipweapons/shipweapons2/update_icon()
	return //not used for the moment

/obj/machinery/shipweapons/shipweapons2/proc/ammo_change() //used when the weapon is loaded
	if(has_ammo_states)
		update_icon() //update icons on loading, if we need to.
	if(has_magazine)
		ping("[magazine.len] out of [magazine_capacity] rounds loaded in internal magazine.")

	if(!has_magazine)
		ping("Round loaded directly into chamber.")

	if(!has_magazine && fires_multiple_rounds)
		ping("Round loaded directly into chamber. [chambered_munitions.len] out of [chamber_capacity] rounds loaded.")

/obj/machinery/shipweapons/shipweapons2/proc/cycle(var/firing = FALSE, var/manual = FALSE) //used when cycling rounds from internal mag to chamber, supports auto/nonautomatic reloading
	UpdateStatus(WEAPON_STATUS_RELOADING)
	if(automatic_reload)
		if(fires_multiple_rounds) //do this if we fire multiple rounds
			if(has_magazine) //if we have a magazine
				if(chambered_munitions.len == chamber_capacity)
					ping("Chamber full.")
					return
				ping("Cycling rounds from magazine into chamber.")
				chamber(chamber_capacity)
			else
				ping("Manual loading required.")
				UpdateStatus(WEAPON_STATUS_REQUIRES_RELOAD)
				return
		else
			if(chambered)
				ping("Chamber full.")
				return

			if(!has_magazine)
				ping("Manual reload required.")
				UpdateStatus(WEAPON_STATUS_REQUIRES_RELOAD)
				return

			if(!firing)
				ping("Attempting to cycle round from magazine into chamber.")
				chamber(1)

			else if(firing)
				ping("Cycling round.")
				chamber(1)

	if(manual)
		if(fires_multiple_rounds)
			if(chambered_munitions.len == chamber_capacity)
				ping("Chamber full.")
				return
			chamber(1, TRUE)
		else
			if(chambered)
				ping("Chamber full.")
				return
			chamber(1, TRUE)

/obj/machinery/shipweapons/shipweapons2/proc/chamber(var/chamber_amount = 0, var/manual = FALSE) //used when chambering round(s) from internal mag to chamber.
	var/chambered_count = 0
	//check if we have enough ammo in the magazine, first! Continue normally, if so.
	if(magazine.len == 0)
		ping("Magazine empty!")
		return

	if(magazine.len <= chamber_amount)
		chamber_amount = Clamp(chamber_amount, 0, magazine.len)

	if(fires_multiple_rounds)
		if(chambered_munitions.len == chamber_capacity)
			ping("Chamber full!")
			return
		for(var/I = 0 to chamber_amount)
			ping("Loading [chamber_amount] rounds into chamber.")
			spawn(chamber_delay)
				for(var/obj/item/shipweapons/ammo/C in contents)
					chambered_munitions += next_in_list(C, magazine)
					magazine -= next_in_list(C, magazine)
					playsound(src, chamber_sound, 40, 1)
					ping("Round cycled into chamber from internal magazine. [chambered_munitions.len] rounds loaded, [chambered_count] rounds left to load.")
					chambered_count += 1
					break //do it once, wait for the delay.
	else
		if(chambered)
			ping("Chamber full!")
			return
		for(var/obj/item/shipweapons/ammo/C in contents)
			chambered = next_in_list(C, magazine)
			magazine -= next_in_list(C, magazine)
			playsound(src, chamber_sound, 40, 1)
			ping("Round cycled into chamber from internal magazine.")
			break //only want to do it once

/obj/machinery/shipweapons/shipweapons2/proc/handle_firing(var/hull_damage = 0, var/shield_damage = 0, var/shield_pen_chance = 0, var/module_damage_chance = 0) //called in Fire()
	return

/obj/machinery/shipweapons/shipweapons2/proc/try_load(var/mob/user, var/obj/item/shipweapons/ammo/ammo)
	if(!istype(ammo, accepted_ammo_type))
		to_chat(user, "<span class='danger'>This isn't the right ammo for this weapon!</span>")
		return
	if(!has_magazine)
		if(fires_multiple_rounds)
			if(chambered_munitions.len == chamber_capacity)
				to_chat(user, "<span class='danger'>The chamber is full.</span>")
				return
			ammo.forceMove(src)
			ammo.parentweapon = src
			chambered_munitions += ammo
			playsound(src, chamber_sound, 40, 1)
			visible_message("<span class='notice'>[user] attempts to load [src]'s chamber.</span>")
		else
			if(chambered)
				to_chat(user, "<span class='danger'>The chamber is full.</span>")
				return
			ammo.forceMove(src)
			chambered = ammo
			ammo.parentweapon = src
			playsound(src, chamber_sound, 40, 1)
			visible_message("<span class='notice'>[user] attempts to load [src]'s chamber.</span>")
	else
		if(magazine.len == magazine_capacity)
			to_chat(user, "<span class='danger'>The magazine is full.</span>")
			return
		ammo.forceMove(src)
		magazine += ammo
		ammo.parentweapon = src
		playsound(src, chamber_sound, 40, 1)
		visible_message("<span class='notice'>[user] attempts to load [src]'s magazine..</span>")

/obj/machinery/shipweapons/shipweapons2/proc/eject(var/obj/item/shipweapons/ammo/ammo)
	visible_message("<span class='danger'>[src] ejects [ammo.name]!</span>")
	ammo.forceMove(get_turf(src))

/obj/machinery/shipweapons/shipweapons2/attack_hand(var/mob/user)
	visible_message("<span class='notice'>[user] attempts to cycle [src].</span>")
	cycle(FALSE, TRUE)

/obj/item/shipweapons/ammo
	icon = 'icons/urist/items/munitions.dmi'
	name = "shipweapontwoammo"
	desc = "You shouldn't see this. Someone messed up."

	var/obj/machinery/shipweapons/shipweapons2/parentweapon //our parent weapon, just in case we need this for ... some reason.

	var/shield_damage = 0 //how much shield damage do we do
	var/hull_damage = 0 //how much hull damage we do
	var/shield_pen_chance = 0 //chance of penetrating shields
	var/module_damage_chance = 0 //chance of damaging modules
	var/charges = 1 // how many charges do we have?
	var/cooldown = 1 SECOND //how long does firing us make our parent weapon cool down?
	var/power_draw = 0 KILOWATTS //power draw if we have a custom power requirement
	var/charge_delay = 10 SECONDS //how long does our gun need to charge to fire us?
	var/camera_shake_amount = 0 //how much do we shake the camera when fired?
	var/load_delay = 3 SECONDS //how long do we take to load into a weapons chamber/magazine?

	var/consumed = FALSE //are we deleted after firing? maybe used for some kind of canister based weapon later on.
	var/depleted = FALSE //if not consumed, are we depleted?
	var/custom_power_draw = FALSE //some ammo might make the firing weapon consume more power.
	var/camera_shake = FALSE //Do we make the camera shake when we're fired?
	var/volatile = FALSE //if true, when ex_act'd, bad things happen.

	var/list/special_effects = list() //Do we do anything special? Reserved for future use.
	var/list/volatile_boom = list(1, 1, 1, 1) //size of the explosion, if volatile is TRUE and the munition has ex_act called on it.

/obj/item/shipweapons/ammo/MouseDrop(over_object, src_location, over_location)
	if(istype(over_object, /obj/machinery/shipweapons/shipweapons2))
		var/obj/machinery/shipweapons/shipweapons2/W = over_object
		W.try_load(usr, src)
		return

/obj/machinery/shipweapons/shipweapons2/railgun
	name = "Railgun"
	desc = "The Hephaestus Industries XCM-HAVOK is a high caliber, ship-to-ship combat weapon intended to fire metal sabots from an internal magazine. Extremely dangerous, extremely expensive."
	icon_state = "Railgun"
	firing_state = "Railgun_firing"
	has_magazine = TRUE
	magazine_capacity = 5
	accepted_ammo_type = /obj/item/shipweapons/ammo/railgun_sabot

/obj/item/shipweapons/ammo/railgun_sabot
	name = "railgun sabot"
	desc = "A hunk of metal intended to go inside of a railgun. Velocitas Eradico."
	icon_state = "railgun_ammo"
	hull_damage = 100
	shield_damage = 250
	module_damage_chance = 20
	cooldown = 5 SECONDS
	consumed = TRUE
	camera_shake = TRUE
	camera_shake_amount = 3



