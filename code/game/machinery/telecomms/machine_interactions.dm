//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32


/*

	All telecommunications interactions:

*/

#define STATION_Z 1
#define TELECOMM_Z 3

/obj/machinery/telecomms
	var/temp = "" // output message
	construct_state = /singleton/machine_construction/tcomms/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	maximum_component_parts = list(/obj/item/stock_parts = 15)

/obj/machinery/telecomms/use_tool(obj/item/P, mob/living/user, list/click_params)
	// Using a multitool lets you access the receiver's interface
	if(isMultitool(P))
		interface_interact(user)
		return TRUE

	// REPAIRING: Use Nanopaste to repair 10-20 integrity points.
	if(istype(P, /obj/item/stack/nanopaste))
		var/obj/item/stack/nanopaste/T = P
		if (integrity < 100)
			if (T.use(1))
				integrity = clamp(integrity + rand(10, 20), 0, 100)
				to_chat(usr, "You apply the Nanopaste to [src], repairing some of the damage.")
		else
			to_chat(usr, "This machine is already in perfect condition.")
		return TRUE

	return ..()

/obj/machinery/telecomms/cannot_transition_to(state_path, mob/user)
	. = ..()
	if(. != MCS_CHANGE)
		return

	if(state_path == /singleton/machine_construction/default/deconstructed)
		to_chat(user, "You begin prying out the circuit board other components...")
		playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
		if(do_after(user, 6 SECONDS, src, DO_REPAIR_CONSTRUCT))
			to_chat(user, "You finish prying out the components.")
			return
		return MCS_BLOCK

/obj/machinery/telecomms/dismantle()
	for(var/obj/x in (contents - component_parts))
		x.dropInto(loc)
	. = ..()

// This should all be a multitool extension, but outside the scope of current rework.
/obj/machinery/telecomms/CanUseTopic(mob/user)
	// You need a multitool to use this, or be silicon
	if(!issilicon(user))
		// istype returns false if the value is null
		if(!istype(user.get_active_hand(), /obj/item/device/multitool))
			return STATUS_CLOSE
	return ..()

/obj/machinery/telecomms/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/telecomms/interact(mob/user)
	var/obj/item/device/multitool/P = get_multitool(user)

	user.set_machine(src)
	var/list/dat = list()
	dat += "<span style='font-family: Courier'><HEAD><TITLE>[src.name]</TITLE></HEAD><center><H3>[src.name] Access</H3></center>"
	dat += "<br>[temp]<br>"
	dat += "<br>Power Status: <a href='byond://?src=\ref[src];input=toggle'>[src.toggled ? "On" : "Off"]</a>"
	if(overloaded_for)
		dat += "<br><br>WARNING: Ion interference detected. System will automatically recover in [overloaded_for*2] seconds. <a href='byond://?src=\ref[src];input=resetoverload'>Reset manually</a><br>"
	if(on && toggled)
		if(id != "" && id)
			dat += "<br>Identification String: <a href='byond://?src=\ref[src];input=id'>[id]</a>"
		else
			dat += "<br>Identification String: <a href='byond://?src=\ref[src];input=id'>NULL</a>"
		dat += "<br>Network: <a href='byond://?src=\ref[src];input=network'>[network]</a>"
		dat += "<br>Prefabrication: [length(autolinkers) ? "TRUE" : "FALSE"]"
		if(hide) dat += "<br>Shadow Link: ACTIVE</a>"

		//Show additional options for certain machines.
		dat += Options_Menu()

		dat += "<br>Linked Network Entities: <ol>"

		var/i = 0
		for(var/obj/machinery/telecomms/T in links)
			i++
			if(T.hide && !src.hide)
				continue
			dat += "<li>\ref[T] [T.name] ([T.id])  <a href='byond://?src=\ref[src];unlink=[i]'>\[X\]</a></li>"
		dat += "</ol>"

		dat += "<br>Filtering Frequencies: "

		i = 0
		if(length(freq_listening))
			for(var/x in freq_listening)
				i++
				if(i < length(freq_listening))
					dat += "[format_frequency(x)] GHz<a href='byond://?src=\ref[src];delete=[x]'>\[X\]</a>; "
				else
					dat += "[format_frequency(x)] GHz<a href='byond://?src=\ref[src];delete=[x]'>\[X\]</a>"
		else
			dat += "NONE"

		dat += "<br>  <a href='byond://?src=\ref[src];input=freq'>\[Add Filter\]</a>"

		dat += "<br><br>Channel Tagging Rules: <ol>"

		if(length(channel_tags))
			for(var/list/rule in channel_tags)
				dat +="<li>[format_frequency(rule[1])] -> [rule[2]] ([rule[3]]) <a href='byond://?src=\ref[src];deletetagrule=[rule[1]]'>\[X\]</a></li>"

		dat += "</ol>"
		dat += "<a href='byond://?src=\ref[src];input=tagrule'>\[Add Rule\]</a>"

		dat += "<hr>"

		if(P)
			var/obj/machinery/telecomms/device = P.get_buffer()
			if(istype(device))
				dat += "<br><br>MULTITOOL BUFFER: [device] ([device.id]) <a href='byond://?src=\ref[src];link=1'>\[Link\]</a> <a href='byond://?src=\ref[src];flush=1'>\[Flush\]"
			else
				dat += "<br><br>MULTITOOL BUFFER: <a href='byond://?src=\ref[src];buffer=1'>\[Add Machine\]</a>"

	dat += "</span>"
	temp = ""

	var/datum/browser/popup = new(user, "tcommmachine", "Telecommunications Machine Configuration Panel", 520, 600)
	popup.set_content(jointext(dat, null))
	popup.open()

// Returns a multitool from a user depending on their mobtype.

/obj/machinery/telecomms/proc/get_multitool(mob/user as mob)

	var/obj/item/device/multitool/P = null
	// Let's double check
	if(!issilicon(user) && istype(user.get_active_hand(), /obj/item/device/multitool))
		P = user.get_active_hand()
	else if(isAI(user))
		var/mob/living/silicon/ai/U = user
		P = U.aiMulti
	else if(isrobot(user) && in_range(user, src))
		if(istype(user.get_active_hand(), /obj/item/device/multitool))
			P = user.get_active_hand()
	return P

// Additional Options for certain machines. Use this when you want to add an option to a specific machine.
// Example of how to use below.

/obj/machinery/telecomms/proc/Options_Menu()
	return ""

/*
// Add an option to the processor to switch processing mode. (COMPRESS -> UNCOMPRESS or UNCOMPRESS -> COMPRESS)
/obj/machinery/telecomms/processor/Options_Menu()
	var/dat = "<br>Processing Mode: <A href='byond://?src=\ref[src];process=1'>[process_mode ? "UNCOMPRESS" : "COMPRESS"]</a>"
	return dat
*/
// The topic for Additional Options. Use this for checking href links for your specific option.
// Example of how to use below.
/obj/machinery/telecomms/proc/Options_Topic(href, href_list)
	return

/*
/obj/machinery/telecomms/processor/Options_Topic(href, href_list)

	if(href_list["process"])
		temp = SPAN_COLOR("#666633", "-% Processing mode changed. %-")
		src.process_mode = !src.process_mode
*/

// BUS

/obj/machinery/telecomms/bus/Options_Menu()
	var/dat = "<br>Change Signal Frequency: <A href='byond://?src=\ref[src];change_freq=1'>[change_frequency ? "YES ([change_frequency])" : "NO"]</a>"
	return dat

/obj/machinery/telecomms/bus/Options_Topic(href, href_list)

	if(href_list["change_freq"])

		var/newfreq = input(usr, "Specify a new frequency for new signals to change to. Enter null to turn off frequency changing. Decimals assigned automatically.", src, network) as null|num
		if(canAccess(usr))
			if(newfreq)
				if(findtext(num2text(newfreq), "."))
					newfreq *= 10 // shift the decimal one place
				if(newfreq < 10000)
					change_frequency = newfreq
					temp = SPAN_COLOR("#666633", "-% New frequency to change to assigned: \"[newfreq] GHz\" %-")
			else
				change_frequency = 0
				temp = SPAN_COLOR("#666633", "-% Frequency changing deactivated %-")


/obj/machinery/telecomms/Topic(href, href_list)
	if(..())
		return 1
	if(!issilicon(usr))
		if(!istype(usr.get_active_hand(), /obj/item/device/multitool))
			return

	if(inoperable())
		return

	var/obj/item/device/multitool/P = get_multitool(usr)

	if(href_list["input"])
		switch(href_list["input"])

			if("resetoverload")
				overloaded_for = 0
				temp = SPAN_COLOR("#666633", "-% Manual override accepted. \The [src] has been reset.")

			if("toggle")

				src.toggled = !src.toggled
				temp = SPAN_COLOR("#666633", "-% [src] has been [src.toggled ? "activated" : "deactivated"].")
				update_power()

			/*
			if("hide")
				src.hide = !hide
				temp = SPAN_COLOR("#666633", "-% Shadow Link has been [src.hide ? "activated" : "deactivated"].")
			*/

			if("id")
				var/newid = copytext(reject_bad_text(input(usr, "Specify the new ID for this machine", src, id) as null|text),1,MAX_MESSAGE_LEN)
				if(newid && canAccess(usr))
					id = newid
					temp = SPAN_COLOR("#666633", "-% New ID assigned: \"[id]\" %-")

			if("network")
				var/newnet = input(usr, "Specify the new network for this machine. This will break all current links.", src, network) as null|text
				if(newnet && canAccess(usr))

					if(length(newnet) > 15)
						temp = SPAN_COLOR("#666633", "-% Too many characters in new network tag %-")

					else
						for(var/obj/machinery/telecomms/T in links)
							T.links.Remove(src)

						network = newnet
						links = list()
						temp = SPAN_COLOR("#666633", "-% New network tag assigned: \"[network]\" %-")


			if("freq")
				var/newfreq = input(usr, "Specify a new frequency to filter (GHz). Decimals assigned automatically.", src, network) as null|num
				if(newfreq && canAccess(usr))
					if(findtext(num2text(newfreq), "."))
						newfreq *= 10 // shift the decimal one place
					if(!(newfreq in freq_listening) && newfreq < 10000)
						freq_listening.Add(newfreq)
						temp = SPAN_COLOR("#666633", "-% New frequency filter assigned: \"[newfreq] GHz\" %-")

			if("tagrule")
				var/freq = input(usr, "Specify frequency to tag (GHz). Decimals assigned automatically.", src, network) as null|num
				if(freq && canAccess(usr))
					if(findtext(num2text(freq), "."))
						freq *= 10

					if(!(freq in freq_listening))
						temp = SPAN_COLOR("#660000", "-% Not filtering specified frequency %-")
						updateUsrDialog()
						return

					for(var/list/rule in channel_tags)
						if(rule[1] == freq)
							temp = SPAN_COLOR("#660000", "-% Tagging rule already defined %-")
							updateUsrDialog()
							return

					var/tag = input(usr, "Specify tag.", src, "") as null|text
					var/color = input(usr, "Select color.", src, "") as null|anything in (channel_color_presets + "Custom color")

					if(color == "Custom color")
						color = input("Select color.", src, rgb(0, 128, 0)) as null|color
					else
						color = channel_color_presets[color]

					if(freq < 10000)
						channel_tags.Add(list(list(freq, tag, color)))
						temp = SPAN_COLOR("#666633", "-% New tagging rule assigned:[freq] GHz -> \"[tag]\" ([color]) %-")

	if(href_list["delete"])

		// changed the layout about to workaround a pesky runtime -- Doohl

		var/x = text2num(href_list["delete"])
		temp = SPAN_COLOR("#666633", "-% Removed frequency filter [x] %-")
		freq_listening.Remove(x)

	if(href_list["deletetagrule"])

		var/freq = text2num(href_list["deletetagrule"])
		var/rule_delete
		for(var/list/rule in channel_tags)
			if(rule[1] == freq)
				rule_delete = rule
		temp = SPAN_COLOR("#666633", "-% Removed tagging rule: [rule_delete[1]] -> [rule_delete[2]] %-")
		channel_tags.Remove(list(rule_delete))

	if(href_list["unlink"])

		if(text2num(href_list["unlink"]) <= length(links))
			var/obj/machinery/telecomms/T = links[text2num(href_list["unlink"])]
			temp = SPAN_COLOR("#666633", "-% Removed \ref[T] [T.name] from linked entities. %-")

			// Remove link entries from both T and src.

			if(src in T.links)
				T.links.Remove(src)
			links.Remove(T)

	if(href_list["link"])

		if(P)
			var/obj/machinery/telecomms/device = P.get_buffer()
			if(istype(device) && device != src)
				if(!(src in device.links))
					device.links.Add(src)

				if(!(device in src.links))
					src.links.Add(device)

				temp = SPAN_COLOR("#666633", "-% Successfully linked with \ref[device] [device.name] %-")

			else
				temp = SPAN_COLOR("#666633", "-% Unable to acquire buffer %-")

	if(href_list["buffer"])

		P.set_buffer(src)
		var/atom/buffer = P.get_buffer()
		temp = SPAN_COLOR("#666633", "-% Successfully stored \ref[buffer] [buffer.name] in buffer %-")


	if(href_list["flush"])

		temp = SPAN_COLOR("#666633", "-% Buffer successfully flushed. %-")
		P.set_buffer(null)

	src.Options_Topic(href, href_list)

	usr.set_machine(src)

	updateUsrDialog()

/obj/machinery/telecomms/proc/canAccess(mob/user)
	if(issilicon(user) || in_range(user, src))
		return 1
	return 0

// Off-Site Relays
//
// You are able to send/receive signals from the station's z level (changeable in the STATION_Z #define) if
// the relay is on the telecomm satellite (changable in the TELECOMM_Z #define)


/obj/machinery/telecomms/relay/proc/toggle_level()

	var/turf/position = get_turf(src)

	// Toggle on/off getting signals from the station or the current Z level
	if(src.listening_levels == GLOB.using_map.contact_levels) // equals the station
		src.listening_levels = GetConnectedZlevels(position.z)
		return 1
	else
		src.listening_levels = GLOB.using_map.contact_levels
		return 1

// RELAY

/obj/machinery/telecomms/relay/Options_Menu()
	var/dat = ""
	if(src.z == TELECOMM_Z)
		dat += "<br>Signal Locked to the [station_name()]: <A href='byond://?src=\ref[src];change_listening=1'>[listening_levels == GLOB.using_map.contact_levels ? "TRUE" : "FALSE"]</a>"
	dat += "<br>Broadcasting: <A href='byond://?src=\ref[src];broadcast=1'>[broadcasting ? "YES" : "NO"]</a>"
	dat += "<br>Receiving:    <A href='byond://?src=\ref[src];receive=1'>[receiving ? "YES" : "NO"]</a>"
	return dat

/obj/machinery/telecomms/relay/Options_Topic(href, href_list)

	if(href_list["receive"])
		receiving = !receiving
		temp = "<font color = #666633>-% Receiving mode changed. %-</font>"
	if(href_list["broadcast"])
		broadcasting = !broadcasting
		temp = "<font color = #666633>-% Broadcasting mode changed. %-</font>"
	if(href_list["change_listening"])
		//Lock to the station OR lock to the current position!
		//You need at least two receivers and two broadcasters for this to work, this includes the machine.
		var/result = toggle_level()
		if(result)
			temp = "<font color = #666633>-% [src]'s signal has been successfully changed.</font>"
		else
			temp = "<font color = #666633>-% [src] could not lock it's signal onto the [station_name()]. Two broadcasters or receivers required.</font>"
