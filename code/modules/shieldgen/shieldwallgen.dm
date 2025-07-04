////FIELD GEN START //shameless copypasta from fieldgen, powersink, and grille
/obj/machinery/shieldwallgen
	name = "shield generator"
	desc = "A shield generator."
	icon = 'icons/obj/machines/shield_generator.dmi'
	icon_state = "Shield_Gen"
	anchored = FALSE
	density = TRUE
	req_access = list(list(access_engine_equip,access_research))
	var/active = 0
	var/power = 0
	var/locked = 1
	var/max_range = 8
	var/storedpower = 0
	obj_flags = OBJ_FLAG_CONDUCTIBLE | OBJ_FLAG_ANCHORABLE
	//There have to be at least two posts, so these are effectively doubled
	var/power_draw = 30 KILOWATTS //30 kW. How much power is drawn from powernet. Increase this to allow the generator to sustain longer shields, at the cost of more power draw.
	var/max_stored_power = 50 KILOWATTS //50 kW
	use_power = POWER_USE_OFF	//Draws directly from power net. Does not use APC power.
	active_power_usage = 1200

/obj/machinery/shieldwallgen/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.default_state)
	var/list/data = list()
	data["draw"] = round(power_draw)
	data["power"] = round(storedpower)
	data["maxpower"] = round(max_stored_power)
	data["current_draw"] = clamp(max_stored_power - storedpower, 500, power_draw) + power ? active_power_usage : 0
	data["online"] = active == 2 ? 1 : 0

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "shield.tmpl", "Shielding", 800, 500, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/shieldwallgen/on_update_icon()
//	if(is_broken()) -TODO: Broken icon
	if(!active)
		icon_state = "Shield_Gen"
	else
		icon_state = "Shield_Gen +a"

/obj/machinery/shieldwallgen/OnTopic(mob/user, href_list)
	if(href_list["toggle"])
		if(src.active >= 1)
			src.active = 0
			update_icon()

			user.visible_message("\The [user] turned the shield generator off.", \
				"You turn off the shield generator.", \
				"You hear heavy droning fade out.")
			for(var/dir in list(1,2,4,8)) src.cleanup(dir)
		else
			src.active = 1
			update_icon()
			user.visible_message("\The [user] turned the shield generator on.", \
				"You turn on the shield generator.", \
				"You hear heavy droning.")
		return TOPIC_REFRESH

/obj/machinery/shieldwallgen/ex_act(severity)
	switch(severity)
		if(EX_ACT_DEVASTATING)
			active = 0
			storedpower = 0
		if(EX_ACT_HEAVY)
			storedpower -= rand(min(storedpower,max_stored_power/2), max_stored_power)
		if(EX_ACT_LIGHT)
			storedpower -= rand(0, max_stored_power)

/obj/machinery/shieldwallgen/emp_act(severity)
	switch(severity)
		if(EMP_ACT_HEAVY)
			storedpower = 0
		if(EMP_ACT_LIGHT)
			storedpower -= rand(storedpower/2, storedpower)
	..()

/obj/machinery/shieldwallgen/CanUseTopic(mob/user)
	if(!anchored)
		to_chat(user, SPAN_WARNING("The shield generator needs to be firmly secured to the floor first."))
		return STATUS_CLOSE
	if(src.locked && !istype(user, /mob/living/silicon))
		to_chat(user, SPAN_WARNING("The controls are locked!"))
		return STATUS_CLOSE
	if(power != 1)
		to_chat(user, SPAN_WARNING("The shield generator needs to be powered by wire underneath."))
		return STATUS_CLOSE
	return ..()

/obj/machinery/shieldwallgen/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/shieldwallgen/proc/power()
	if(!anchored)
		power = 0
		return 0
	var/turf/T = src.loc

	var/obj/structure/cable/C = T.get_cable_node()
	var/datum/powernet/PN
	if(C)	PN = C.powernet		// find the powernet of the connected cable

	if(PN)
		var/shieldload = clamp(max_stored_power - storedpower, 500, power_draw)	//what we try to draw
		shieldload = PN.draw_power(shieldload) //what we actually get
		storedpower += shieldload

	//If we're still in the red, then there must not be enough available power to cover our load.
	if(storedpower <= 0)
		power = 0
		return 0

	power = 1	// IVE GOT THE POWER!
	return 1

/obj/machinery/shieldwallgen/Process()
	..()
	power = 0
	if(!MACHINE_IS_BROKEN(src))
		power()

	if(storedpower >= max_stored_power)
		storedpower = max_stored_power
	if(storedpower <= 0)
		storedpower = 0

	if(src.active == 1)
		if(!src.anchored)
			src.active = 0
			return
		spawn(1)
			setup_field(1)
		spawn(2)
			setup_field(2)
		spawn(3)
			setup_field(4)
		spawn(4)
			setup_field(8)
		src.active = 2
	if(src.active >= 1)
		if(src.power == 0)
			src.visible_message(SPAN_WARNING("The [src.name] shuts down due to lack of power!"), \
				"You hear heavy droning fade out")
			src.active = 0
			update_icon()
			for(var/dir in list(1,2,4,8)) src.cleanup(dir)

/obj/machinery/shieldwallgen/proc/setup_field(NSEW = 0)
	var/turf/T = get_turf(src)
	if(!T) return
	var/turf/T2 = T
	var/obj/machinery/shieldwallgen/G
	var/steps = 0
	var/oNSEW = 0

	if(!NSEW)//Make sure its ran right
		return

	if(NSEW == 1)
		oNSEW = 2
	else if(NSEW == 2)
		oNSEW = 1
	else if(NSEW == 4)
		oNSEW = 8
	else if(NSEW == 8)
		oNSEW = 4

	for(var/dist = 0, dist <= (max_range+1), dist += 1) // checks out to 8 tiles away for another generator
		T = get_step(T2, NSEW)
		T2 = T
		steps += 1
		G = (locate(/obj/machinery/shieldwallgen) in T)
		if(G)
			steps -= 1
			if(!G.active)
				return
			G.cleanup(oNSEW)
			break

	if(isnull(G))
		return

	T2 = src.loc

	for(var/dist = 0, dist < steps, dist += 1) // creates each field tile
		var/field_dir = get_dir(T2,get_step(T2, NSEW))
		T = get_step(T2, NSEW)
		T2 = T
		var/obj/machinery/shieldwall/CF = new(T, src, G) //(ref to this gen, ref to connected gen)
		CF.set_dir(field_dir)
		CF.loc = T2

/obj/machinery/shieldwallgen/can_anchor(obj/item/tool, mob/user, silent)
	if (active)
		to_chat(user, SPAN_WARNING("Turn off \the [src] first."))
		return FALSE
	return ..()

/obj/machinery/shieldwallgen/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W, /obj/item/card/id)||istype(W, /obj/item/modular_computer))
		if (allowed(user))
			locked = !locked
			to_chat(user, "Controls are now [src.locked ? "locked." : "unlocked."]")
		else
			to_chat(user, SPAN_WARNING("Access denied."))
		return TRUE

	return ..()

/obj/machinery/shieldwallgen/proc/cleanup(NSEW)
	var/obj/machinery/shieldwall/F
	var/obj/machinery/shieldwallgen/G
	var/turf/T = src.loc
	var/turf/T2 = src.loc

	for(var/dist = 0, dist <= (max_range+1), dist += 1) // checks out to 8 tiles away for fields
		T = get_step(T2, NSEW)
		T2 = T
		if(locate(/obj/machinery/shieldwall) in T)
			F = (locate(/obj/machinery/shieldwall) in T)
			qdel(F)

		if(locate(/obj/machinery/shieldwallgen) in T)
			G = (locate(/obj/machinery/shieldwallgen) in T)
			if(!G.active)
				break

/obj/machinery/shieldwallgen/Destroy()
	src.cleanup(NORTH)
	src.cleanup(SOUTH)
	src.cleanup(EAST)
	src.cleanup(WEST)
	. = ..()


//////////////Containment Field START
/obj/machinery/shieldwall
	name = "shield"
	desc = "An energy shield."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldwall"
	anchored = TRUE
	density = TRUE
	unacidable = TRUE
	light_range = 3
	var/needs_power = 0
	var/active = 1
	var/delay = 5
	var/last_active
	var/mob/U
	var/obj/machinery/shieldwallgen/gen_primary
	var/obj/machinery/shieldwallgen/gen_secondary
	var/power_usage = 800	//how much power it takes to sustain the shield
	var/generate_power_usage = 5000	//how much power it takes to start up the shield

/obj/machinery/shieldwall/Initialize(mapload, obj/machinery/shieldwallgen/A, obj/machinery/shieldwallgen/B)
	. = ..()
	update_nearby_tiles()
	gen_primary = A
	gen_secondary = B
	if(A && B && A.active && B.active)
		needs_power = 1
		strain_power(generate_power_usage)

	else
		return INITIALIZE_HINT_QDEL

/obj/machinery/shieldwall/Destroy()
	update_nearby_tiles()
	..()

/obj/machinery/shieldwall/proc/strain_power(amount)
	if(!gen_primary || !gen_secondary)
		return
	var/d_amount = amount/2
	gen_primary.storedpower -= d_amount
	gen_secondary.storedpower -= d_amount

/obj/machinery/shieldwall/use_weapon(obj/item/I, mob/living/user, list/click_params)
	var/obj/machinery/shieldwallgen/G = prob(50) ? gen_primary : gen_secondary
	G.storedpower -= I.force*2500
	user.visible_message(SPAN_DANGER("\The [user] hits \the [src] with \the [I]!"))
	user.setClickCooldown(user.get_attack_speed(I))
	user.do_attack_animation(src)
	playsound(loc, 'sound/weapons/smash.ogg', 75, 1)
	return TRUE || ..()

/obj/machinery/shieldwall/Process()
	if(needs_power)
		if(isnull(gen_primary)||isnull(gen_secondary))
			qdel(src)
			return

		if(!(gen_primary.active)||!(gen_secondary.active))
			qdel(src)
			return

		strain_power(power_usage)


/obj/machinery/shieldwall/bullet_act(obj/item/projectile/Proj)
	if(needs_power)
		strain_power(400 * Proj.get_structure_damage())
	..()
	return


/obj/machinery/shieldwall/ex_act(severity)
	if(needs_power)
		switch(severity)
			if(EX_ACT_DEVASTATING) //big boom
				strain_power(rand(30000, min(prob(50) ? gen_primary.storedpower : gen_secondary.storedpower, 60000)))

			if(EX_ACT_HEAVY) //medium boom
				strain_power(rand(15000, min(prob(50) ? gen_primary.storedpower : gen_secondary.storedpower, 30000)))

			if(EX_ACT_LIGHT) //lil boom
				strain_power(rand(5000, min(prob(50) ? gen_primary.storedpower : gen_secondary.storedpower, 15000)))
	return


/obj/machinery/shieldwall/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(istype(mover) && mover.checkpass(PASS_FLAG_GLASS))
		return prob(20)
	else
		if (istype(mover, /obj/item/projectile))
			return prob(10)
		else
			return !src.density

/obj/machinery/shieldwallgen/online
	anchored = TRUE
	active = 1

/obj/machinery/shieldwallgen/online/Initialize()
	storedpower = max_stored_power
	. = ..()
