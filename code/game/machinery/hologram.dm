/* Holograms!
 * Contains:
 *		Holopad
 *		Hologram
 *		Other stuff
 */

/*
Revised. Original based on space ninja hologram code. Which is also mine. /N
How it works:
AI clicks on holopad in camera view. View centers on holopad.
AI clicks again on the holopad to display a hologram. Hologram stays as long as AI is looking at the pad and it (the hologram) is in range of the pad.
AI can use the directional keys to move the hologram around, provided the above conditions are met and the AI in question is the holopad's master.
Only one AI may project from a holopad at any given time.
AI may cancel the hologram at any time by clicking on the holopad once more.

Possible to do for anyone motivated enough:
	Give an AI variable for different hologram icons.
	Itegrate EMP effect to disable the unit.
*/

/*
Revised by CPU_Blanc.
-Multiple hologram users at the same time added (conference calls)
-Power usage reworked to scale with additional holograms
-Languages are now preserved
-Both holopads must be within range of eachother's max range to connect
-Visible emotes now only pass through the pad if the source is visible to the user (Either as a hologram, or if the player's eye is in that location)
*/

/*
 * Holopad
 */

#define RANGE_BASED 4
#define AREA_BASED 6

var/global/const/HOLOPAD_MODE = RANGE_BASED

/obj/machinery/hologram/holopad
	name = "\improper holopad"
	desc = "It's a floor-mounted device for projecting holographic images."
	icon_state = "holopad-B0"

	layer = ABOVE_TILE_LAYER

	var/power_per_hologram = 500 //per usage per hologram
	idle_power_usage = 5
	active_power_usage = 50

	var/conference = FALSE
	var/scan_range = 2	//Range of mobs to capture for conference calls
	var/list/masters = new() //List of mobs that are projecting on the holopad	var/last_request = 0 //to prevent request spam. ~Carn
	var/last_request = 0 //to prevent request spam. ~Carn
	var/holo_range = 5 // Change to change how far the AI can move away from the holopad before deactivating.

	var/incoming_connection = FALSE
	var/mob/living/caller_id
	var/obj/machinery/hologram/holopad/connected
	var/list/tracked = list()

	var/list/recent_calls = list()

	var/holopadType = HOLOPAD_SHORT_RANGE //Whether the holopad is short-range or long-range.
	var/base_icon = "holopad-B"

	var/allow_ai = TRUE

	construct_state = /singleton/machine_construction/default/panel_closed

	var/list/linked_pdas

/obj/machinery/hologram/holopad/New()
	..()
	desc = "It's a floor-mounted device for projecting holographic images. Its ID is '[loc.loc]'"

/obj/machinery/hologram/holopad/examine(mob/user)
	. = ..()
	if (connected)
		to_chat(user, SPAN_NOTICE("There is currently an incoming call from [get_area(connected)]!"))
	var/callstring = "Recent incoming calls:"
	for (var/id in recent_calls)
		callstring += "\n[id]"
	callstring = SPAN_NOTICE(callstring)
	to_chat(user, callstring)

/obj/machinery/hologram/holopad/interface_interact(mob/living/carbon/human/user) //Carn: Hologram requests.
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	if(stat)
		return FALSE
	if(incoming_connection)
		if(QDELETED(connected)) // If the sourcepad was deleted, most likely.
			end_call()
			return FALSE
		visible_message("The pad hums quietly as it establishes a connection.")
		if(caller_id && caller_id.loc != connected.loc)
			visible_message("The pad flashes an error message. The caller has left their holopad.")
			return FALSE
		take_call()
		return TRUE
	else if(connected && !incoming_connection)
		visible_message("Severing connection to distant holopad.")
		end_call()
		return FALSE

	. = TRUE
	var/handle_type = "Holocomms"
	var/ai_exists = FALSE

	for(var/mob/living/silicon/ai/AI in GLOB.alive_mobs)
		if(!AI.client)	continue
		ai_exists = TRUE
		break

	if(allow_ai && ai_exists)
		handle_type = alert(user,"Would you like to request an AI's presence or establish communications with another pad?", "Holopad","AI","Holocomms","Cancel")

	switch(handle_type)
		if("AI")
			if(last_request + 200 < world.time) //don't spam the AI with requests you jerk!
				last_request = world.time
				to_chat(user, SPAN_NOTICE("You request an AI's presence."))
				var/area/area = get_area(src)
				for(var/mob/living/silicon/ai/AI in GLOB.alive_mobs)
					if(!AI.client)	continue
					if (holopadType != HOLOPAD_LONG_RANGE && !AreConnectedZLevels(AI.z, src.z))
						continue
					to_chat(AI, SPAN_INFO("Your presence is requested at <a href='?src=\ref[AI];jumptoholopad=\ref[src]'>\the [area]</a>."))
			else
				to_chat(user, SPAN_NOTICE("A request for AI presence was already sent recently."))
		if("Holocomms")
			var/call_type = alert(user, "Would you like to make it a conference call?", "Holopad", "Yes", "No")
			if(call_type == "Yes")
				conference = TRUE
			if(user.loc != src.loc && !conference)
				to_chat(user, SPAN_INFO("Please step onto the holopad."))
				return
			if(last_request + 200 < world.time) //don't spam other people with requests either, you jerk!
				var/list/holopadlist = list()
				var/zlevels = GetConnectedZlevels(z)
				var/zlevels_long = list()
				if(GLOB.using_map.use_overmap && holopadType == HOLOPAD_LONG_RANGE)
					for(var/zlevel in map_sectors)
						var/obj/effect/overmap/visitable/O = map_sectors["[zlevel]"]
						if(!isnull(O))
							zlevels_long |= O.map_z
				for(var/obj/machinery/hologram/holopad/H in SSmachines.machinery)
					if (H.operable())
						if(H.z in zlevels)
							holopadlist["[H.loc.loc.name]"] = H	//Define a list and fill it with the area of every holopad in the world
						if (H.holopadType == HOLOPAD_LONG_RANGE && (H.z in zlevels_long))
							holopadlist["[H.loc.loc.name]"] = H
				holopadlist = sortAssoc(holopadlist)
				var/temppad = input(user, "Which holopad would you like to contact?", "holopad list") as null|anything in holopadlist
				var/obj/machinery/hologram/holopad/targetpad = holopadlist["[temppad]"]
				if(!targetpad)
					return
				if(targetpad == src)
					to_chat(user, SPAN_INFO("Using such sophisticated technology, just to talk to yourself seems a bit silly."))
					targetpad = null //Clean up the mess after an unsuccessful call
					return
				if(targetpad.connected)
					to_chat(user, SPAN_INFO("The pad flashes a busy sign. Maybe you should try again later.."))
					targetpad = null //Clean up the mess after an unsuccessful call
					return
				last_request = world.time
				make_call(targetpad, conference ? null : user)
			else
				to_chat(user, SPAN_NOTICE("A request for holographic communication was already sent recently."))


/obj/machinery/hologram/holopad/proc/make_call(obj/machinery/hologram/holopad/targetpad, mob/living/carbon/user)
	connected = targetpad
	set_pad_effects()
	targetpad.connected = src //This marks the holopad you are making the call from
	targetpad.incoming_connection = TRUE
	targetpad.last_request = world.time
	targetpad.conference = conference
	playsound(targetpad.loc, 'sound/machines/chime.ogg', 25, 5)
	targetpad.addrecentcall(get_area(src))
	targetpad.set_pad_effects()
	if(user)
		targetpad.caller_id = user //This marks you as the caller
		targetpad.audible_message("<b>\The [connected]</b> announces, \"Incoming communications request from [connected.connected.loc.loc].\"")
		to_chat(user, SPAN_NOTICE("Trying to establish a connection to the holopad in [connected.loc.loc]... Please await confirmation from recipient."))
	// Notify any linked PDAs
	if (LAZYLEN(targetpad.linked_pdas))
		for (var/obj/item/modular_computer/pda/pda as anything in targetpad.linked_pdas)
			if (!AreConnectedZLevels(get_z(targetpad), get_z(pda)))
				continue
			pda.receive_notification("Call at [targetpad.loc.loc] holopad.")
	else
		targetpad.audible_message("<b>\The [connected]</b> announces, \"Incoming holo-conference request from [connected.connected.loc.loc].\"")
		visible_message(user, SPAN_NOTICE("Trying to establish a connection to the holopad in [connected.loc.loc]... Please await confirmation from recipient."))

/obj/machinery/hologram/holopad/proc/take_call()
	incoming_connection = FALSE
	if(caller_id)
		caller_id.machine = connected
		caller_id.reset_view(src)
		if(!masters[caller_id])//If there is no hologram, possibly make one.
			add_hologram(caller_id)
		log_admin("[key_name(caller_id)] just established a holopad connection from [connected.loc.loc] to [src.loc.loc]")

/obj/machinery/hologram/holopad/proc/end_call(ended = TRUE)
	if(ended && connected)
		connected.end_call(FALSE)
	else
		visible_message("<span class='notice'>The holocall has been terminated</span>")
	connected = null
	incoming_connection = FALSE
	if(caller_id)
		caller_id.unset_machine()
		caller_id.reset_view() //Send the caller back to his body
		remove_holo(caller_id) // destroy the hologram
		caller_id = null
	if(conference)
		conference = FALSE
		for(var/mob/M in masters)
			if(isAI(M))
				continue
			remove_holo(M)
		tracked = list()
	if(!length(masters))
		set_pad_effects(FALSE)

/obj/machinery/hologram/holopad/proc/addrecentcall(id)
	recent_calls += id
	if (length(recent_calls) > 5)
		recent_calls -= recent_calls[1]

/obj/machinery/hologram/holopad/check_eye(mob/user)
	return 0

/obj/machinery/hologram/holopad/attack_ai(mob/living/silicon/ai/user)
	if (!istype(user))
		return
	if(!ai_can_interact(user))
		return
	/*There are pretty much only three ways to interact here.
	I don't need to check for client since they're clicking on an object.
	This may change in the future but for now will suffice.*/
	if(user.eyeobj && (user.eyeobj.loc != src.loc))//Set client eye on the object if it's not already.
		user.eyeobj.setLoc(get_turf(src))
	else if (!allow_ai)
		to_chat(user, SPAN_WARNING("Access denied."))
	else if (holopadType != HOLOPAD_LONG_RANGE && !AreConnectedZLevels(user.z, src.z))
		to_chat(user, SPAN_WARNING("Out of range."))
	else if(!masters[user])//If there is no hologram, possibly make one.
		add_hologram(user)
	else//If there is a hologram, remove it.
		remove_holo(user)
	return

/obj/machinery/hologram/holopad/proc/activate_holocall(mob/living/carbon/caller_id)
	if(caller_id)
		src.visible_message("A holographic image of [caller_id] flicks to life right before your eyes!")
		create_holo(0,caller_id)//Create one.
	else
		to_chat(caller_id, "[SPAN_DANGER("ERROR:")] Unable to project hologram.")
	return
/obj/machinery/hologram/holopad/proc/add_hologram(mob/living/user)
	if(isAI(user))
		var/mob/living/silicon/ai/AI = user
		if(!(stat) && AI.eyeobj && AI.eyeobj.loc == src.loc)
			if(AI.holo)
				to_chat(AI, "<span class='danger'>ERROR:</span> Image feed in progress.")
				return
			create_holo(AI, TRUE)//Create one.
		else
			to_chat(user, "<span class='danger'>ERROR:</span> Unable to project hologram.")
	else if(isliving(user))
		create_holo(user)

/obj/machinery/hologram/holopad/use_tool(obj/item/O, mob/user)
	if (istype(O, /obj/item/modular_computer/pda))
		if (LAZYISIN(linked_pdas, O))
			unlink_pda(O)
			to_chat(user, SPAN_NOTICE("You remove \the [O] from \the [src]'s notifications list."))
			return TRUE
		link_pda(O)
		to_chat(user, SPAN_NOTICE("You add \the [O] to \the [src]'s notifications list. It will now be pinged whenever a call is received."))
		return TRUE

	..()

/**
 * Proc to link/unlink PDAs
 */

/obj/machinery/hologram/holopad/proc/link_pda(obj/item/modular_computer/pda/pda)
	if (!istype(pda))
		return
	LAZYADD(linked_pdas, pda)
	GLOB.destroyed_event.register(pda, src, .proc/unlink_pda)


/obj/machinery/hologram/holopad/proc/unlink_pda(obj/item/modular_computer/pda/pda)
	LAZYREMOVE(linked_pdas, pda)
	GLOB.destroyed_event.unregister(pda, src, .proc/unlink_pda)

/obj/machinery/hologram/holopad/proc/create_holo(mob/living/user, isAI = FALSE, turf/T = loc)
	var/obj/effect/overlay/hologram = new(T)//Spawn a blank effect at the location.
	if(isAI)
		var/mob/living/silicon/ai/AI = user
		hologram.overlays += holopadType == HOLOPAD_LONG_RANGE ? AI.holo_icon_longrange : AI.holo_icon
		if(AI.holo_icon_malf == TRUE)
			hologram.overlays += icon("icons/effects/effects.dmi", "malf-scanline")
		AI.holo = src
		set_pad_effects()
	else
		hologram.overlays += getHologramIcon(getFullIcon(user), hologram_color = holopadType) // Add the callers image as an overlay to keep coloration!
		hologram.forceMove(get_step(src,1))

	hologram.mouse_opacity = 0//So you can't click on it.
	hologram.layer = ABOVE_HUMAN_LAYER //Above all the other objects/mobs. Or the vast majority of them.
	hologram.anchored = TRUE//So space wind cannot drag it.
	hologram.SetName("[user.name] (Hologram)")
	masters[user] = hologram
	hologram.set_light(1, 0.1, 2)	//hologram lighting
	hologram.color = color //painted holopad gives coloured holograms
	visible_message("A holographic image of [user] flicks to life right before your eyes!")
	change_power_consumption(active_power_usage + power_per_hologram, POWER_USE_ACTIVE)
	return 1

/obj/machinery/hologram/holopad/proc/remove_holo(mob/living/user)
	if(user)
		qdel(masters[user])//Get rid of user's hologram
		masters -= user //Remove the user from the list of masters
		change_power_consumption(max(active_power_usage - power_per_hologram, initial(active_power_usage)), POWER_USE_ACTIVE)
		if(isAI(user))
			var/mob/living/silicon/ai/AI = user
			AI.holo = null

	if(!length(masters))	//If no users left
		set_pad_effects(FALSE)
		if(connected && !incoming_connection)
			end_call()
	return 1

/obj/machinery/hologram/holopad/proc/move_hologram(mob/living/user, x, var/y, var/dir)
	if(masters[user])
		if(isAI(user))
			step_to(masters[user], user.eyeobj) // So it turns.
			var/obj/effect/overlay/H = masters[user]
			H.dropInto(user.eyeobj)
			masters[user] = H

			if(!(H in view(src)))
				remove_holo(user)
				return 0

			if((HOLOPAD_MODE == RANGE_BASED && (get_dist(user.eyeobj, src) > holo_range)))
				remove_holo(user)

			if(HOLOPAD_MODE == AREA_BASED)
				var/area/holo_area = get_area(src)
				var/area/hologram_area = get_area(H)
				if(hologram_area != holo_area)
					remove_holo(user)
			return 1

		else
			var/obj/effect/overlay/H = masters[user]
			var/dest = locate(src.x + x, src.y + y, src.z)
			step_to(H, dest)
			H.dropInto(dest)
			H.dir = dir
			return 1

/obj/machinery/hologram/holopad/proc/set_dir_hologram(new_dir, mob/living/user)
	if(masters[user])
		var/obj/effect/overlay/hologram = masters[user]
		hologram.dir = new_dir

/obj/machinery/hologram/holopad/proc/set_pad_effects(on = TRUE)
	if(on)
		set_light(1, 0.1, 2)
		update_use_power(POWER_USE_ACTIVE)
		icon_state = "[base_icon]1"
	else
		set_light(0)
		update_use_power(POWER_USE_IDLE)
		icon_state = "[base_icon]0"


//PROCESS STUFF//

/obj/machinery/hologram/holopad/Process()
	for(var/mob/living/silicon/ai/master in masters)
		var/active_ai = (master && !master.incapacitated() && master.client && master.eyeobj)//If there is an AI with an eye attached, it's not incapacitated, and it has a client
		if(!is_powered() || !active_ai)
			remove_holo(master)
			continue

		if(!(masters[master] in view(src)))
			remove_holo(master)
			continue

		if(last_request + 200 < world.time && incoming_connection == TRUE)
			if(connected)
				connected.visible_message("<i><span class='game say'>The holopad connection timed out.</span></i>")
				connected.end_call()
			incoming_connection = FALSE

	if(caller_id && connected)
		if(caller_id.loc != connected.loc)
			connected.visible_message("<span class='notice'>Severing connection to distant holopad.</span>")
			connected.end_call()

	if(conference && connected)
		process_mobs()

	return TRUE

/obj/machinery/hologram/holopad/proc/process_mobs()
	if(!connected)
		return
	if(incoming_connection || connected.incoming_connection)
		return

	var/list/scanned = view(scan_range, src)

	for(var/mob/living/M in tracked)
		if(isAI(M))
			continue
		if(M in scanned)
			if(tracked[M]["x"] != M.x || tracked[M]["y"] != M.y)
				connected.move_hologram(M, M.x - src.x, M.y - src.y, M.dir)
				tracked[M]["x"] = M.x
				tracked[M]["y"] = M.y
				tracked[M]["dir"] = M.dir
			else if(tracked[M]["dir"] != M.dir)
				connected.set_dir_hologram(M.dir, M)
				tracked[M]["dir"] = M.dir
		else
			connected.remove_holo(M)
			tracked -= M

	var/list/new_targets = tracked ^ scanned

	for(var/mob/living/M in new_targets)
		connected.add_hologram(M)
		connected.move_hologram(M, M.x - src.x, M.y - src.y, M.dir)
		tracked[M] = list("x" = M.x, "y" = M.y, "dir" = M.dir)



//EMOTES & SPEECH STUFF//

/obj/machinery/hologram/holopad/hear_talk(mob/living/M, text, verb, datum/language/speaking)
	var/used_voice = M.GetVoice()
	for(var/mob/living/silicon/ai/AI in masters)
		var/message = text
		if(!AI.say_understands(M, speaking))
			message = speaking ? speaking.scramble(text) : stars(text)
		AI.show_message(get_hear_message(used_voice, message, verb, speaking), 2)
	if(connected && !incoming_connection)
		if(!connected.connected)
			end_call()
			return
		connected.broadcast_message(M, text, verb, speaking)

//Leaving this here, but as far as I can see, nowhere actually calls this proc???
/obj/machinery/hologram/holopad/see_emote(mob/living/M, text)
	for(var/mob/living/silicon/ai/AI in masters)
		var/rendered = "<i><span class='game say'>Holopad received, <span class='message'>[text]</span></span></i>"
		AI.show_message(rendered, 2)
	if(connected && !incoming_connection)
		if(!connected.connected)	//Fallback for wonky behaviour
			end_call()
			return
		connected.visible_message("<i><span class='message'>[text]</span></i>")

/obj/machinery/hologram/holopad/show_message(msg, type, alt, alt_type)
	for(var/mob/living/spectator in masters)
		if(spectator == caller_id || isAI(spectator))
			spectator.show_message(msg, type)	//Anyone with their view set over to the holopad sees everything as normal
	if(connected && !incoming_connection)
		if(!connected.connected)
			end_call()
			return
		var/rendered
		for(var/mob/M in connected.masters)
			if(findtext(msg, M.name))
				rendered = "<i><span class='game say'>The holographic image of <span class='message'>[msg]</span></span></i>"
				break
		if(type == AUDIBLE_MESSAGE && !rendered)	//Or what the holopad can hear
			rendered = "<i><span class='game say'>Holopad received, <span class='message'>[msg]</span></span></i>"
		if(rendered)
			for(var/mob/living/mobs in view(connected))
				if(mobs == caller_id)
					continue
				mobs.show_message(rendered, type)

/obj/machinery/hologram/holopad/proc/get_hear_message(name_used, text, verb, datum/language/speaking)
	if(speaking)
		return "<i><span class='game say'>Holopad received, <span class='name'>[name_used]</span> [speaking.format_message(text, verb)]</span></i>"
	return "<i><span class='game say'>Holopad received, <span class='name'>[name_used]</span> [verb], <span class='message'>\"[text]\"</span></span></i>"

//Because the holopads can't 'speak', this is used to preserve languages on the other side.
//This is essentially atom.audible_message() except with language taken into account
/obj/machinery/hologram/holopad/proc/broadcast_message(mob/living/M, text, verb, datum/language/speaking)
	var/turf/T = get_turf(src)
	var/list/mobs = list()
	var/list/objs = list()
	get_mobs_and_objs_in_view_fast(T, world.view, mobs, objs)

	var/used_name = M.GetVoice()
	var/understood = get_hear_message(used_name, text, verb, speaking)
	var/gibberish = get_hear_message(used_name, speaking ? speaking.scramble(text) : stars(text), verb, speaking)

	for(var/mob/hearer in mobs)
		hearer.show_message(hearer.say_understands(M, speaking) ? understood : gibberish,2,null,1)

	for(var/obj/O in objs)
		if(O != src)	//Prevents echoes
			O.show_message(understood,2,null,1)



/*
 * Hologram
 */

/obj/machinery/hologram
	anchored = TRUE
	idle_power_usage = 5
	active_power_usage = 100

//Destruction procs.
/obj/machinery/hologram/ex_act(severity)
	switch(severity)
		if(EX_ACT_DEVASTATING)
			qdel(src)
		if(EX_ACT_HEAVY)
			if (prob(50))
				qdel(src)
		if(EX_ACT_LIGHT)
			if (prob(5))
				qdel(src)
	return

/obj/machinery/hologram/holopad/Destroy()
	for(var/mob/living/master in masters)
		remove_holo(master)
	end_call()
	if (LAZYLEN(linked_pdas))
		for (var/obj/item/modular_computer/pda/pda as anything in linked_pdas)
			unlink_pda(pda)
		linked_pdas = null

	return ..()

/*
Holographic project of everything else.

/mob/verb/hologram_test()
	set name = "Hologram Debug New"
	set category = "CURRENT DEBUG"

	var/obj/effect/overlay/hologram = new(loc)//Spawn a blank effect at the location.
	var/icon/flat_icon = icon(getFlatIcon(src,0))//Need to make sure it's a new icon so the old one is not reused.
	flat_icon.ColorTone(rgb(125,180,225))//Let's make it bluish.
	flat_icon.ChangeOpacity(0.5)//Make it half transparent.
	var/input = input("Select what icon state to use in effect.",,"")
	if(input)
		var/icon/alpha_mask = new('icons/effects/effects.dmi', "[input]")
		flat_icon.AddAlphaMask(alpha_mask)//Finally, let's mix in a distortion effect.
		hologram.icon = flat_icon

		log_debug("Your icon should appear now.")

	return
*/

/*
 * Other Stuff: Is this even used?
 */
/obj/machinery/hologram/projector
	name = "hologram projector"
	desc = "It makes a hologram appear...with magnets or something..."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "hologram0"

/obj/machinery/hologram/holopad/longrange
	name = "long range holopad"
	desc = "It's a floor-mounted device for projecting holographic images. This one utilizes a bluespace transmitter to communicate with far away locations."
	icon_state = "holopad-Y0"
	power_per_hologram = 1000 //per usage per hologram
	holopadType = HOLOPAD_LONG_RANGE
	base_icon = "holopad-Y"

// Used for overmap capable ships that should have communications, but not be AI accessible
/obj/machinery/hologram/holopad/longrange/remoteship
	allow_ai = FALSE
	construct_state = null

#undef RANGE_BASED
#undef AREA_BASED
