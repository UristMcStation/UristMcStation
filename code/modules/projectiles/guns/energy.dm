GLOBAL_LIST_INIT(registered_weapons, list())
GLOBAL_LIST_INIT(registered_cyborg_weapons, list())

/obj/item/weapon/gun/energy
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon = 'icons/obj/guns/basic_energy.dmi'
	icon_state = "energy"
	fire_sound = 'sound/weapons/Taser.ogg'
	fire_sound_text = "laser blast"
	accuracy = 1

	var/obj/item/weapon/cell/power_supply //What type of power cell this uses
	var/charge_cost = 20 //How much energy is needed to fire.
	var/max_shots = 10 //Determines the capacity of the weapon's power cell. Specifying a cell_type overrides this value.
	var/cell_type = null
	var/projectile_type = /obj/item/projectile/beam/practice
	var/modifystate
	var/charge_meter = 1	//if set, the icon state will be chosen based on the current charge

	//self-recharging
	var/self_recharge = 0	//if set, the weapon will recharge itself
	var/use_external_power = 0 //if set, the weapon will look for an external power source to draw from, otherwise it recharges magically
	var/recharge_time = 4
	var/charge_tick = 0

	var/hatch_open = 0 //determines if you can insert a cell in/detach a cell

	var/reload_time = 5 SECONDS

	var/mag_insert_sound = 'sound/weapons/guns/interaction/pistol_magin.ogg'
	var/mag_remove_sound = 'sound/weapons/guns/interaction/pistol_magout.ogg'

/obj/item/weapon/gun/energy/switch_firemodes()
	. = ..()
	if(.)
		update_icon()

/obj/item/weapon/gun/energy/emp_act(severity)
	..()
	update_icon()

/obj/item/weapon/gun/energy/Initialize()
	. = ..()
	if(cell_type)
		power_supply = new cell_type(src)
	else
		power_supply = new /obj/item/weapon/cell/device/variable(src, max_shots*charge_cost)
	if(self_recharge)
		START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/weapon/gun/energy/Destroy()
	if(self_recharge)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/weapon/gun/energy/get_cell()
	return power_supply

/obj/item/weapon/gun/energy/Process()
	if(self_recharge) //Every [recharge_time] ticks, recharge a shot for the cyborg
		charge_tick++
		if(charge_tick < recharge_time) return 0
		charge_tick = 0

		if(!power_supply || power_supply.charge >= power_supply.maxcharge)
			return 0 // check if we actually need to recharge

		if(use_external_power)
			var/obj/item/weapon/cell/external = get_external_power_supply()
			if(!external || !external.use(charge_cost)) //Take power from the borg...
				return 0

		power_supply.give(charge_cost) //... to recharge the shot
		update_icon()
	return 1

/obj/item/weapon/gun/energy/consume_next_projectile()
	if(!power_supply) return null
	if(!ispath(projectile_type)) return null
	if(!power_supply.checked_use(charge_cost)) return null
	return new projectile_type(src)

/obj/item/weapon/gun/energy/proc/get_external_power_supply()
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return R.cell
	if(istype(src.loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = src.loc
		if(module.holder && module.holder.wearer)
			var/mob/living/carbon/human/H = module.holder.wearer
			if(istype(H) && H.back)
				var/obj/item/weapon/rig/suit = H.back
				if(istype(suit))
					return suit.cell
	return null

/obj/item/weapon/gun/energy/special_check(var/mob/user)

	if(!..())
		return
	
	if(hatch_open)
		to_chat(user, "<span class='warning'>[src] has its cell cover still open!</span>")
		return 0
	return 1

//To load a new power cell into the energy gun, if item A is a cell type and the gun is not self-recharging
/obj/item/weapon/gun/energy/proc/load_ammo(var/obj/item/A, mob/user)
	if(self_recharge)
		return
	//only let's you load in power cells
	if(istype(A, /obj/item/weapon/cell))
		. = TRUE
		var/obj/item/weapon/cell/AM = A

		if(hatch_open)
			if(power_supply)
				to_chat(user, "<span class='warning'>[src] already has a power cell loaded.</span>") //already a power cell here
				return
			if(AM.maxcharge <= (max_shots*charge_cost))
				user.visible_message("[user] begins to reconfigure the wires and insert the cell into [src].","<span class='notice'>You begin to reconfigure the wires and insert the cell into [src].</span>")
				
				if(!do_after(user, reload_time, src))
					user.visible_message("[usr] stops reconfiguring the wires in [src].","<span class='warning'>You stop reconfiguring the wires in [src].</span>")
					return
				if(!user.unEquip(AM, src))
					return
				power_supply = AM
				user.visible_message("[user] inserts [AM] into [src].", "<span class='notice'>You insert [AM] and hot wire it into [src].</span>")
				playsound(loc, mag_insert_sound, 50, 1)
			else
				to_chat(user,"<span class='warning'>The cell size is too big for the [src]. It must be [max_shots*charge_cost] Wh or smaller.</span>")
				return
		else
			to_chat(user,"<span class='warning'>The cell cover is closed. Use a screwdriver to open it.</span>")
			return
		update_icon()

//To unload the existing power cell, if the cell cover is open and the gun is not self recharging
/obj/item/weapon/gun/energy/proc/unload_ammo(mob/user)
	if(self_recharge)
		return
	if(hatch_open)
		if(power_supply)
			user.put_in_hands(power_supply)
			user.visible_message("[user] removes [power_supply] from [src].", "<span class='notice'>You disconnect the wires and remove [power_supply] from [src].</span>")
			playsound(loc, mag_remove_sound, 50, 1)
			power_supply.update_icon()
			power_supply = null
			if(modifystate)
				icon_state = "[modifystate][0]"
			else
				icon_state = "[initial(icon_state)][0]"
		else
			to_chat(user, "<span class='warning'>[src] is empty.</span>")
	else
		user.visible_message("<span class='warning'>The cell cover is closed. Use a screwdriver to open it.</span>")
		return
	update_icon()

//to trigger loading cell
/obj/item/weapon/gun/energy/attackby(var/obj/item/A as obj, mob/user as mob)
	if(isScrewdriver(A) && (!self_recharge))
		if(!hatch_open)
			hatch_open = 1
			user.visible_message("[user] opens the cell cover of [src].", "<span class='notice'>You open the cell cover of [src].</span>")
			return
		else
			hatch_open = 0 
			user.visible_message("[user] closes the cell cover of [src].", "<span class='notice'>You close the cell cover of [src].</span>")
			return
	if(!load_ammo(A, user))
		return ..()

//to trigger unloading the cell
/obj/item/weapon/gun/energy/attack_self(mob/user as mob)
	if(firemodes.len > 1)
		..()
	else
		unload_ammo(user)

/obj/item/weapon/gun/energy/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		unload_ammo(user)
	else
		return ..()

/obj/item/weapon/gun/energy/examine(mob/user)
	. = ..(user)
	if(!power_supply)
		to_chat(user, "There is no power cell loaded.")
	else
		var/shots_remaining = round(power_supply.charge / charge_cost)
		to_chat(user, "Has [shots_remaining] shot\s remaining.")
	if(!hatch_open)
		to_chat(user, "The cell cover is closed.")
	if(hatch_open)
		to_chat(user, "The cell cover is open.")
	return

/obj/item/weapon/gun/energy/on_update_icon()
	..()
	if(charge_meter && power_supply)
		var/ratio = power_supply.percent()

		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		if(power_supply.charge < charge_cost)
			ratio = 0
		else
			ratio = max(round(ratio, 25), 25)

		if(modifystate)
			icon_state = "[modifystate][ratio]"
		else
			icon_state = "[initial(icon_state)][ratio]"
