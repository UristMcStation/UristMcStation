#define SOLAR_MAX_DIST 40

var/global/solar_gen_rate = 1500

/obj/machinery/power/solar
	name = "solar panel"
	desc = "A solar electrical generator."
	icon = 'icons/obj/machines/power/solar_panels.dmi'
	icon_state = "sp_base"
	anchored = TRUE
	density = TRUE
	idle_power_usage = 0
	active_power_usage = 0
	health_max = 10
	var/id = 0
	var/obscured = 0
	var/sunfrac = 0
	var/efficiency = 1
	var/adir = SOUTH // actual dir
	var/ndir = SOUTH // target dir
	var/turn_angle = 0
	var/obj/machinery/power/solar_control/control = null

/obj/machinery/power/solar/improved
	name = "improved solar panel"
	efficiency = 2

/obj/machinery/power/solar/drain_power()
	return -1

/obj/machinery/power/solar/New(turf/loc, obj/item/solar_assembly/S)
	..(loc)
	Make(S)
	connect_to_network()

/obj/machinery/power/solar/Destroy()
	unset_control() //remove from control computer
	..()

//set the control of the panel to a given computer if closer than SOLAR_MAX_DIST
/obj/machinery/power/solar/proc/set_control(obj/machinery/power/solar_control/SC)
	if(SC && (get_dist(src, SC) > SOLAR_MAX_DIST))
		return 0
	control = SC
	return 1

//set the control of the panel to null and removes it from the control list of the previous control computer if needed
/obj/machinery/power/solar/proc/unset_control()
	if(control)
		control.connected_panels.Remove(src)
	control = null

/obj/machinery/power/solar/proc/Make(obj/item/solar_assembly/S)
	if(!S)
		S = new /obj/item/solar_assembly(src)
		S.glass_type = /obj/item/stack/material/glass
		S.anchored = TRUE
	S.forceMove(src)
	if(S.glass_type == /obj/item/stack/material/glass/reinforced) //if the panel is in reinforced glass
		set_max_health(health_max * 2)
	update_icon()



/obj/machinery/power/solar/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(isCrowbar(W))
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		user.visible_message(SPAN_NOTICE("[user] begins to take the glass off the solar panel."))
		if(do_after(user, (W.toolspeed * 5) SECONDS, src, DO_REPAIR_CONSTRUCT))
			var/obj/item/solar_assembly/S = locate() in src
			if(S)
				S.dropInto(loc)
				S.give_glass()
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			user.visible_message(SPAN_NOTICE("[user] takes the glass off the solar panel."))
			qdel(src)
		return TRUE

	return ..()

/obj/machinery/power/solar/on_update_icon()
	..()
	ClearOverlays()
	if(MACHINE_IS_BROKEN(src))
		AddOverlays(image('icons/obj/machines/power/solar_panels.dmi', icon_state = "solar_panel-b", layer = ABOVE_HUMAN_LAYER))
	else
		AddOverlays(image('icons/obj/machines/power/solar_panels.dmi', icon_state = "solar_panel", layer = ABOVE_HUMAN_LAYER))
		src.set_dir(angle2dir(adir))
	return

//calculates the fraction of the sunlight that the panel receives
/obj/machinery/power/solar/proc/update_solar_exposure()
	if(obscured)
		sunfrac = 0
		return

	//find the smaller angle between the direction the panel is facing and the direction of the sun (the sign is not important here)
	var/p_angle = min(abs(adir - GLOB.sun_angle), 360 - abs(adir - GLOB.sun_angle))

	if(p_angle > 90)			// if facing more than 90deg from sun, zero output
		sunfrac = 0
		return

	sunfrac = cos(p_angle) ** 2
	//isn't the power received from the incoming light proportional to cos(p_angle) (Lambert's cosine law) rather than cos(p_angle)^2 ?

/obj/machinery/power/solar/Process()
	if(MACHINE_IS_BROKEN(src))
		return
	if(!control) //if there's no sun or the panel is not linked to a solar control computer, no need to proceed
		return

	if(powernet)
		if(powernet == control.powernet)//check if the panel is still connected to the computer
			if(obscured) //get no light from the sun, so don't generate power
				return
			var/sgen = solar_gen_rate * sunfrac * efficiency
			add_avail(sgen)
			control.gen += sgen
		else //if we're no longer on the same powernet, remove from control computer
			unset_control()

/obj/machinery/power/solar/set_broken(new_state)
	. = ..()
	if(. && new_state && !health_dead())
		kill_health()

/obj/machinery/power/solar/on_death()
	new /obj/item/material/shard(src.loc)
	new /obj/item/material/shard(src.loc)
	var/obj/item/solar_assembly/S = locate() in src
	S.glass_type = null
	unset_control()
	..()

/obj/machinery/power/solar/ex_act(severity)
	switch(severity)
		if(EX_ACT_DEVASTATING)
			if(prob(15))
				new /obj/item/material/shard( src.loc )
			qdel(src)
			return

		if(EX_ACT_HEAVY)
			if (prob(25))
				new /obj/item/material/shard( src.loc )
				qdel(src)
				return

			if (prob(50))
				set_broken(TRUE)

		if(EX_ACT_LIGHT)
			if (prob(25))
				set_broken(TRUE)
	return


/obj/machinery/power/solar/fake/New(turf/loc, obj/item/solar_assembly/S)
	..(loc, S, 0)

/obj/machinery/power/solar/fake/Process()
	return PROCESS_KILL

//trace towards sun to see if we're in shadow
/obj/machinery/power/solar/proc/occlusion()

	var/steps = 20	// 20 steps is enough
	var/ax = x		// start at the solar panel
	var/ay = y
	var/turf/T = null

	// On planets, we take fewer steps because the light is mostly up
	// Also, many planets barely have any spots with enough clear space around
	if(GLOB.using_map.use_overmap)
		var/obj/overmap/visitable/sector/exoplanet/E = map_sectors["[z]"]
		if(istype(E) && E.is_planet)
			steps = 5

	for(var/i = 1 to steps)
		ax += GLOB.sun_dx
		ay += GLOB.sun_dy

		T = locate( round(ax,0.5),round(ay,0.5),z)

		if(!T || T.x == 1 || T.x==world.maxx || T.y==1 || T.y==world.maxy)		// not obscured if we reach the edge
			break

		if(T.opacity)			// if we hit a solid turf, panel is obscured
			obscured = 1
			return

	obscured = 0		// if hit the edge or stepped max times, not obscured
	update_solar_exposure()


//
// Solar Assembly - For construction of solar arrays.
//

/obj/item/solar_assembly
	name = "solar panel assembly"
	desc = "A solar panel assembly kit, allows constructions of a solar panel, or with a tracking circuit board, a solar tracker."
	icon = 'icons/obj/machines/power/solar_panels.dmi'
	icon_state = "sp_base"
	item_state = "electropack"
	w_class = ITEM_SIZE_HUGE // Pretty big!
	anchored = FALSE
	var/tracker = 0
	var/glass_type = null

/obj/item/solar_assembly/attack_hand(mob/user)
	if(!anchored && isturf(loc)) // You can't pick it up
		..()

// Give back the glass type we were supplied with
/obj/item/solar_assembly/proc/give_glass()
	if(glass_type)
		var/obj/item/stack/material/S = new glass_type(src.loc)
		S.amount = 2
		glass_type = null


/obj/item/solar_assembly/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(!anchored && isturf(loc))
		if(isWrench(W))
			anchored = TRUE
			pixel_x = 0
			pixel_y = 0
			pixel_z = 0
			user.visible_message(SPAN_NOTICE("\The [user] wrenches \the [src] into place."))
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			return TRUE
	else
		if(isWrench(W))
			anchored = FALSE
			user.visible_message(SPAN_NOTICE("\The [user] unwrenches \the [src] from it's place."))
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			return TRUE

		if(istype(W, /obj/item/stack/material) && W.get_material_name() == MATERIAL_GLASS)
			var/obj/item/stack/material/S = W
			if(S.use(2))
				glass_type = W.type
				playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
				user.visible_message(SPAN_NOTICE("\The [user] places the glass on \the [src]."))
				if(tracker)
					new /obj/machinery/power/tracker(get_turf(src), src)
				else
					new /obj/machinery/power/solar(get_turf(src), src)
			else
				to_chat(user, SPAN_WARNING("You need two sheets of glass to put them into a solar panel."))
			return TRUE

	if(!tracker)
		if(istype(W, /obj/item/tracker_electronics))
			tracker = 1
			qdel(W)
			user.visible_message(SPAN_NOTICE("\The [user] inserts the electronics into \the [src]."))
			return TRUE
	else
		if(isCrowbar(W))
			new /obj/item/tracker_electronics(loc)
			tracker = 0
			user.visible_message(SPAN_NOTICE("\The [user] takes out the electronics from \the [src]."))
			return TRUE
	return ..()

//
// Solar Control Computer
//

/obj/machinery/power/solar_control
	name = "solar panel control"
	desc = "A controller for solar panel arrays."
	icon = 'icons/obj/machines/computer.dmi'
	icon_state = "computer"
	anchored = TRUE
	density = TRUE
	use_power = POWER_USE_IDLE
	idle_power_usage = 250
	construct_state = /singleton/machine_construction/default/panel_closed/computer
	base_type = /obj/machinery/power/solar_control
	frame_type = /obj/machinery/constructable_frame/computerframe
	machine_name = "solar control console"
	machine_desc = "Tracks all solar devices connected on the same powernet, and allows the user to rotate them to track the sun."
	var/id = 0
	var/cdir = 0
	var/targetdir = 0		// target angle in manual tracking (since it updates every game minute)
	var/gen = 0
	var/lastgen = 0
	var/track = 0			// 0= off  1=timed  2=auto (tracker)
	var/trackrate = 600		// 300-900 seconds
	var/nexttime = 0		// time for a panel to rotate of 1° in manual tracking
	var/obj/machinery/power/tracker/connected_tracker = null
	var/list/connected_panels = list()

/obj/machinery/power/solar_control/drain_power()
	return -1

/obj/machinery/power/solar_control/Destroy()
	for(var/obj/machinery/power/solar/M in connected_panels)
		M.unset_control()
	if(connected_tracker)
		connected_tracker.unset_control()
	..()

/obj/machinery/power/solar_control/disconnect_from_network()
	..()
	GLOB.solar_controllers -= src

/obj/machinery/power/solar_control/connect_to_network()
	var/to_return = ..()
	if(powernet) //if connected and not already in solar_list...
		GLOB.solar_controllers |= src
	return to_return

//search for unconnected panels and trackers in the computer powernet and connect them
/obj/machinery/power/solar_control/proc/search_for_connected()
	if(powernet)
		for(var/obj/machinery/power/M in powernet.nodes)
			if(istype(M, /obj/machinery/power/solar))
				var/obj/machinery/power/solar/S = M
				if(!S.control) //i.e unconnected
					if(S.set_control(src))
						connected_panels |= S
			else if(istype(M, /obj/machinery/power/tracker))
				if(!connected_tracker) //if there's already a tracker connected to the computer don't add another
					var/obj/machinery/power/tracker/T = M
					if(!T.control) //i.e unconnected
						if(T.set_control(src))
							connected_tracker = T

//called by the sun controller, update the facing angle (either manually or via tracking) and rotates the panels accordingly
/obj/machinery/power/solar_control/proc/update()
	if(inoperable())
		return

	switch(track)
		if(1)
			if(trackrate) //we're manual tracking. If we set a rotation speed...
				cdir = targetdir //...the current direction is the targetted one (and rotates panels to it)
		if(2) // auto-tracking
			if(connected_tracker)
				connected_tracker.set_angle(GLOB.sun_angle)

	set_panels(cdir)
	updateDialog()

/obj/machinery/power/solar_control/Initialize()
	. = ..()
	if(!connect_to_network()) return
	set_panels(cdir)

/obj/machinery/power/solar_control/on_update_icon()
	if(MACHINE_IS_BROKEN(src))
		icon_state = "broken"
		ClearOverlays()
		return
	if(!is_powered())
		icon_state = "computer"
		ClearOverlays()
		return
	icon_state = "solar"
	ClearOverlays()
	if(cdir > -1)
		AddOverlays(image('icons/obj/machines/computer.dmi', "solcon-o", angle2dir(cdir)))
	return

/obj/machinery/power/solar_control/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/power/solar_control/interact(mob/user)

	var/t = "<B>[SPAN_CLASS("highlight", "Generated power")]</B> : [round(lastgen)] W<BR>"
	t += "<B>[SPAN_CLASS("highlight", "Star Orientation")]</B>: [GLOB.sun_angle]&deg ([angle2text(GLOB.sun_angle)])<BR>"
	t += "<B>[SPAN_CLASS("highlight", "Array Orientation")]</B>: [rate_control(src,"cdir","[cdir]&deg",1,15)] ([angle2text(cdir)])<BR>"
	t += "<B>[SPAN_CLASS("highlight", "Tracking:")]</B><div class='statusDisplay'>"
	switch(track)
		if(0)
			t += "[SPAN_CLASS("linkOn", "Off")] <A href='byond://?src=\ref[src];track=1'>Timed</A> <A href='byond://?src=\ref[src];track=2'>Auto</A><BR>"
		if(1)
			t += "<A href='byond://?src=\ref[src];track=0'>Off</A> [SPAN_CLASS("linkOn", "Timed")] <A href='byond://?src=\ref[src];track=2'>Auto</A><BR>"
		if(2)
			t += "<A href='byond://?src=\ref[src];track=0'>Off</A> <A href='byond://?src=\ref[src];track=1'>Timed</A> [SPAN_CLASS("linkOn", "Auto")]<BR>"

	t += "Tracking Rate: [rate_control(src,"tdir","[trackrate] deg/h ([trackrate<0 ? "CCW" : "CW"])",1,30,180)]</div><BR>"

	t += "<B>[SPAN_CLASS("highlight", "Connected devices:")]</B><div class='statusDisplay'>"

	t += "<A href='byond://?src=\ref[src];search_connected=1'>Search for devices</A><BR>"
	t += "Solar panels : [length(connected_panels)] connected<BR>"
	t += "Solar tracker : [connected_tracker ? SPAN_GOOD("Found") : SPAN_BAD("Not found")]</div><BR>"

	t += "<A href='byond://?src=\ref[src];close=1'>Close</A>"

	var/datum/browser/popup = new(user, "solar", name)
	popup.set_content(t)
	popup.open()

/obj/machinery/power/solar_control/Process()
	lastgen = gen
	gen = 0

	if(inoperable())
		return

	if(connected_tracker) //NOTE : handled here so that we don't add trackers to the processing list
		if(connected_tracker.powernet != powernet)
			connected_tracker.unset_control()

	if(track==1 && trackrate) //manual tracking and set a rotation speed
		if(nexttime <= world.time) //every time we need to increase/decrease the angle by 1°...
			targetdir = (targetdir + trackrate/abs(trackrate) + 360) % 360 	//... do it
			nexttime += 36000/abs(trackrate) //reset the counter for the next 1°

	updateDialog()

/obj/machinery/power/solar_control/Topic(href, href_list)
	if(..())
		close_browser(usr, "window=solcon")
		usr.unset_machine()
		return 0
	if(href_list["close"] )
		close_browser(usr, "window=solcon")
		usr.unset_machine()
		return 0

	if(href_list["rate control"])
		if(href_list["cdir"])
			src.cdir = clamp((360+src.cdir+text2num(href_list["cdir"]))%360, 0, 359)
			src.targetdir = src.cdir
			if(track == 2) //manual update, so losing auto-tracking
				track = 0
			spawn(1)
				set_panels(cdir)
		if(href_list["tdir"])
			src.trackrate = clamp(src.trackrate+text2num(href_list["tdir"]), -7200, 7200)
			if(src.trackrate) nexttime = world.time + 36000/abs(trackrate)

	if(href_list["track"])
		track = text2num(href_list["track"])
		if(track == 2)
			if(connected_tracker)
				connected_tracker.set_angle(GLOB.sun_angle)
				set_panels(cdir)
		else if (track == 1) //begin manual tracking
			src.targetdir = src.cdir
			if(src.trackrate) nexttime = world.time + 36000/abs(trackrate)
			set_panels(targetdir)

	if(href_list["search_connected"])
		src.search_for_connected()
		if(connected_tracker && track == 2)
			connected_tracker.set_angle(GLOB.sun_angle)
		src.set_panels(cdir)

	interact(usr)
	return 1

//rotates the panel to the passed angle
/obj/machinery/power/solar_control/proc/set_panels(cdir)
	for(var/obj/machinery/power/solar/S in connected_panels)
		S.adir = cdir //instantly rotates the panel
		S.occlusion()//and
		S.update_icon() //update it
	update_icon()

/obj/machinery/power/solar_control/ex_act(severity)
	switch(severity)
		if(1.0)
			//SN src = null
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				set_broken(TRUE)
		if(3.0)
			if (prob(25))
				set_broken(TRUE)

// Used for mapping in solar array which automatically starts itself (telecomms, for example)
/obj/machinery/power/solar_control/autostart
	track = 2 // Auto tracking mode

/obj/machinery/power/solar_control/autostart/Initialize()
	search_for_connected()
	if(connected_tracker && track == 2)
		connected_tracker.set_angle(GLOB.sun_angle)
		set_panels(cdir)
	. = ..()

//
// MISC
//

/obj/item/paper/solar
	name = "paper- 'Going green! Setup your own solar array instructions.'"
	info = "<h1>Welcome</h1><p>At greencorps we love the environment, and space. With this package you are able to help mother nature and produce energy without any usage of fossil fuel or phoron! Singularity energy is dangerous while solar energy is safe, which is why it's better. Now here is how you setup your own solar array.</p><p>You can make a solar panel by wrenching the solar assembly onto a cable node. Adding a glass panel, reinforced or regular glass will do, will finish the construction of your solar panel. It is that easy!</p><p>Now after setting up 19 more of these solar panels you will want to create a solar tracker to keep track of our mother nature's gift, the sun. These are the same steps as before except you insert the tracker equipment circuit into the assembly before performing the final step of adding the glass. You now have a tracker! Now the last step is to add a computer to calculate the sun's movements and to send commands to the solar panels to change direction with the sun. Setting up the solar computer is the same as setting up any computer, so you should have no trouble in doing that. You do need to put a wire node under the computer, and the wire needs to be connected to the tracker.</p><p>Congratulations, you should have a working solar array. If you are having trouble, here are some tips. Make sure all solar equipment are on a cable node, even the computer. You can always deconstruct your creations if you make a mistake.</p><p>That's all to it, be safe, be green!</p>"

/proc/rate_control(S, V, C, Min=1, Max=5, Limit=null) //How not to name vars
	var/href = "<A href='byond://?src=\ref[S];rate control=1;[V]"
	var/rate = "[href]=-[Max]'>-</A>[href]=-[Min]'>-</A> [(C?C : 0)] [href]=[Min]'>+</A>[href]=[Max]'>+</A>"
	if(Limit) return "[href]=-[Limit]'>-</A>"+rate+"[href]=[Limit]'>+</A>"
	return rate
