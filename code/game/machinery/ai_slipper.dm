/obj/machinery/ai_slipper
	name = "\improper AI Liquid Dispenser"
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "prox"
	anchored = TRUE
	idle_power_usage = 10
	var/uses = 20
	var/disabled = 1
	var/lethal = 0
	var/locked = 1
	var/cooldown_time = 0
	var/cooldown_timeleft = 0
	var/cooldown_on = 0
	req_access = list(access_ai_upload)


/obj/machinery/ai_slipper/New()
	..()
	update_icon()

/obj/machinery/ai_slipper/on_update_icon()
	if (stat & MACHINE_STAT_NOPOWER || stat & MACHINE_STAT_EMPED)
		overlays += "prox_timing"
	else
		overlays = null

/obj/machinery/ai_slipper/proc/setState(enabled, var/uses)
	src.disabled = disabled
	src.uses = uses
	src.power_change()

/obj/machinery/ai_slipper/use_tool(obj/item/W, mob/user)
	if(stat & (MACHINE_STAT_NOPOWER|MACHINE_STAT_EMPED))
		return
	if(!ai_can_interact(user))
		return
	if (istype(user, /mob/living/silicon))
		return attack_ai(user)
	else // trying to unlock the interface
		if(allowed(user))
			locked = !locked
			to_chat(user, "You [ locked ? "lock" : "unlock"] the device.")
			if (locked)
				if (user.machine==src)
					user.unset_machine()
					close_browser(user, "window=ai_slipper")
			else
				if (user.machine==src)
					interact(user)
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
	..()

/obj/machinery/ai_slipper/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/ai_slipper/interact(mob/user)
	var/area/area = get_area(src)

	var/t = "<TT><B>AI Liquid Dispenser</B> ([area.name])<HR>"

	if(src.locked && (!istype(user, /mob/living/silicon)))
		t += "<I>(Swipe ID card to unlock control panel.)</I><BR>"
	else
		t += text("Uses Left: [uses]. <A href='?src=\ref[src];toggleUse=1'>Activate the dispenser?</A><br>\n")

	show_browser(user, t, "window=computer;size=575x450")
	onclose(user, "computer")

/obj/machinery/ai_slipper/CanUseTopic(user)
	if(locked && !issilicon(user))
		to_chat(user, "<span class='warning'>The control panel is locked!</span>")
		return min(..(), STATUS_UPDATE)
	return ..()

/obj/machinery/ai_slipper/OnTopic(user, href_list)
	if (href_list["toggleUse"])
		if(!(cooldown_on || disabled))
			new /obj/effect/effect/foam(src.loc)
			src.uses--
			cooldown_on = 1
			cooldown_time = world.timeofday + 100
			slip_process()
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		attack_hand(user)

/obj/machinery/ai_slipper/proc/slip_process()
	while(cooldown_time - world.timeofday > 0)
		var/ticksleft = cooldown_time - world.timeofday

		if(ticksleft > 1e5)
			cooldown_time = world.timeofday + 10	// midnight rollover


		cooldown_timeleft = (ticksleft / 10)
		sleep(5)
	if (uses <= 0)
		return
	if (uses >= 0)
		cooldown_on = 0
	src.power_change()
	return
