#define STATE_DEFAULT	1
#define STATE_MESSAGELIST	2
#define STATE_VIEWMESSAGE	3
#define STATE_STATUSDISPLAY	4
#define STATE_ALERT_LEVEL	5
/datum/computer_file/program/comm
	filename = "comm"
	filedesc = "Command and Communications Program"
	program_icon_state = "comm"
	program_key_state = "med_key"
	program_menu_icon = "flag"
	nanomodule_path = /datum/nano_module/program/comm
	extended_desc = "Used to command and control. Can relay long-range communications. This program can not be run on tablet computers."
	requires_ntnet = TRUE
	size = 12
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP
	network_destination = "long-range communication array"
	category = PROG_COMMAND
	var/datum/comm_message_listener/message_core = new

/datum/computer_file/program/comm/clone()
	var/datum/computer_file/program/comm/temp = ..()
	temp.message_core.messages = null
	temp.message_core.messages = message_core.messages.Copy()
	return temp

/datum/nano_module/program/comm
	name = "Command and Communications Program"
	available_to_ai = TRUE
	var/current_status = STATE_DEFAULT
	var/msg_line1 = ""
	var/msg_line2 = ""
	var/centcomm_message_cooldown = 0
	var/announcment_cooldown = 0
	var/datum/announcement/priority/crew_announcement = new
	var/current_viewing_message_id = 0
	var/current_viewing_message = null
	var/admin_access = list(access_bridge)

/datum/nano_module/program/comm/New()
	..()
	crew_announcement.newscast = 1

/datum/nano_module/program/comm/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.default_state)

	var/list/data = host.initial_data()
	var/authenticated = check_access(user, admin_access)

	if(program && program.computer)
		data["net_comms"] = program.computer.get_ntnet_capability(NTNET_COMMUNICATION)
		data["net_syscont"] = program.computer.get_ntnet_capability(NTNET_SYSTEMCONTROL)
		if(program.computer)
			data["emagged"] = program.computer.emagged()
			data["have_printer"] =  program.computer.has_component(PART_PRINTER)
		else
			data["have_printer"] = 0
	else
		data["emagged"] = 0
		data["net_comms"] = 1
		data["net_syscont"] = 1
		data["have_printer"] = 0

	data["message_line1"] = msg_line1
	data["message_line2"] = msg_line2
	data["state"] = current_status
	data["isAI"] = issilicon(usr)
	data["boss_short"] = GLOB.using_map.boss_short
	data["authenticated"] = authenticated

	var/singleton/security_state/security_state = GET_SINGLETON(GLOB.using_map.security_state)
	data["current_security_level_ref"] = any2ref(security_state.current_security_level)
	data["current_security_level_title"] = security_state.current_security_level.name

	data["cannot_change_security_level"] = !security_state.can_change_security_level()
	data["current_security_level_is_high_security_level"] = security_state.current_security_level == security_state.high_security_level
	var/list/security_levels = list()
	for(var/singleton/security_level/security_level in security_state.comm_console_security_levels)
		var/list/security_setup = list()
		security_setup["title"] = security_level.name
		security_setup["ref"] = any2ref(security_level)
		security_levels[LIST_PRE_INC(security_levels)] = security_setup
	data["security_levels"] = security_levels

	var/datum/comm_message_listener/l = obtain_message_listener()
	data["messages"] = l.messages
	data["message_deletion_allowed"] = l != global_message_listener
	data["message_current_id"] = current_viewing_message_id
	if(current_viewing_message)
		data["message_current"] = current_viewing_message

	data["has_central_command"] = GLOB.using_map.has_central_command

	var/list/processed_evac_options = list()
	if(!isnull(evacuation_controller))
		for (var/datum/evacuation_option/EO in evacuation_controller.available_evac_options())
			if(EO.abandon_ship && security_state.current_security_level_is_lower_than(security_state.high_security_level))
				continue
			var/list/option = list()
			option["option_text"] = EO.option_text
			option["option_target"] = EO.option_target
			option["needs_syscontrol"] = EO.needs_syscontrol
			option["silicon_allowed"] = EO.silicon_allowed
			processed_evac_options[LIST_PRE_INC(processed_evac_options)] = option
	data["evac_options"] = processed_evac_options

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "communication.tmpl", name, 550, 420, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/comm/proc/is_authenticated(authenticated, mob/user)
	if(program)
		return program.can_run(user)
	return TRUE

/datum/nano_module/program/comm/proc/obtain_message_listener()
	if(program)
		var/datum/computer_file/program/comm/P = program
		return P.message_core
	return global_message_listener

/datum/nano_module/program/comm/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED
	var/mob/user = usr
	var/ntn_comm = (program && program.computer) ? program.computer.get_ntnet_capability(NTNET_COMMUNICATION) : TRUE
	var/ntn_cont = (program && program.computer) ? program.computer.get_ntnet_capability(NTNET_SYSTEMCONTROL) : TRUE
	var/datum/comm_message_listener/l = obtain_message_listener()
	switch(href_list["action"])
		if("sw_menu")
			. = TOPIC_HANDLED
			current_status = text2num(href_list["target"])
		if("announce")
			. = TOPIC_HANDLED
			if(is_authenticated(user) && !issilicon(usr) && ntn_comm)
				if(user)
					var/obj/item/card/id/id_card = user.GetIdCard()
					crew_announcement.announcer = GetNameAndAssignmentFromId(id_card)
				else
					crew_announcement.announcer = "Unknown"
				if(announcment_cooldown)
					to_chat(usr, "Please allow at least one minute to pass between announcements")
					return
				var/input = sanitize(input(usr, "Please write a message to announce to the [station_name()].", "Priority Announcement") as null|message, extra = FALSE)
				if(!input || !can_still_topic())
					return
				var/affected_zlevels = GetConnectedZlevels(get_host_z())
				crew_announcement.Announce(input, msg_sanitized = TRUE, zlevels = affected_zlevels)
				announcment_cooldown = 1
				spawn(600)//One minute cooldown
					announcment_cooldown = 0
		if("message")
			. = TOPIC_HANDLED
			if(href_list["target"] == "emagged")
				if(program)
					if(is_authenticated(user) && program.computer.emagged() && !issilicon(usr) && ntn_comm)
						if(centcomm_message_cooldown)
							to_chat(usr, SPAN_WARNING("Arrays recycling. Please stand by."))
							SSnano.update_uis(src)
							return
						var/input = sanitize(input(usr, "Please choose a message to transmit to \[ABNORMAL ROUTING CORDINATES\] via quantum entanglement.  Please be aware that this process is very expensive, and abuse will lead to... termination. Transmission does not guarantee a response. There is a 30 second delay before you may send another message, be clear, full and concise.", "To abort, send an empty message.", "") as null|text)
						if(!input || !can_still_topic())
							return
						Syndicate_announce(input, usr)
						to_chat(usr, SPAN_NOTICE("Message transmitted."))
						log_say("[key_name(usr)] has made an illegal announcement: [input]")
						centcomm_message_cooldown = 1
						spawn(300)//30 second cooldown
							centcomm_message_cooldown = 0
			else if(href_list["target"] == "regular")
				if(is_authenticated(user) && !issilicon(usr) && ntn_comm)
					if(centcomm_message_cooldown)
						to_chat(usr, SPAN_WARNING("Arrays recycling. Please stand by."))
						SSnano.update_uis(src)
						return
					if(!is_relay_online())//Contact Centcom has a check, Syndie doesn't to allow for Traitor funs.
						to_chat(usr, SPAN_WARNING("No Emergency Bluespace Relay detected. Unable to transmit message."))
						return
					var/input = sanitize(input("Please choose a message to transmit to [GLOB.using_map.boss_short] via quantum entanglement.  Please be aware that this process is very expensive, and abuse will lead to... termination.  Transmission does not guarantee a response. There is a 30 second delay before you may send another message, be clear, full and concise.", "To abort, send an empty message.", "") as null|text)
					if(!input || !can_still_topic())
						return
					Centcomm_announce(input, usr)
					to_chat(usr, SPAN_NOTICE("Message transmitted."))
					log_say("[key_name(usr)] has made an IA [GLOB.using_map.boss_short] announcement: [input]")
					centcomm_message_cooldown = 1
					spawn(300) //30 second cooldown
						centcomm_message_cooldown = 0
		if("evac")
			. = TOPIC_HANDLED
			if(is_authenticated(user))
				var/datum/evacuation_option/selected_evac_option = evacuation_controller.evacuation_options[href_list["target"]]
				if (isnull(selected_evac_option) || !istype(selected_evac_option))
					return
				if (!selected_evac_option.silicon_allowed && issilicon(user))
					return
				if (selected_evac_option.needs_syscontrol && !ntn_cont)
					return
				var/confirm = alert("Are you sure you want to [selected_evac_option.option_desc]?", name, "No", "Yes")
				if (confirm == "Yes" && can_still_topic())
					evacuation_controller.handle_evac_option(selected_evac_option.option_target, user)
		if("setstatus")
			. = TOPIC_HANDLED
			if(is_authenticated(user) && ntn_cont)
				switch(href_list["target"])
					if("line1")
						var/linput = reject_bad_text(sanitize(input("Line 1", "Enter Message Text", msg_line1) as text|null, 40), 40)
						if(can_still_topic())
							msg_line1 = linput
					if("line2")
						var/linput = reject_bad_text(sanitize(input("Line 2", "Enter Message Text", msg_line2) as text|null, 40), 40)
						if(can_still_topic())
							msg_line2 = linput
					if("message")
						post_status("message", msg_line1, msg_line2)
					if("image")
						post_status("image", href_list["image"])
					else
						post_status(href_list["target"])
		if("setalert")
			. = TOPIC_HANDLED
			if(is_authenticated(user) && !issilicon(usr) && ntn_cont && ntn_comm)
				var/singleton/security_state/security_state = GET_SINGLETON(GLOB.using_map.security_state)
				var/singleton/security_level/target_level = locate(href_list["target"]) in security_state.comm_console_security_levels
				if(target_level && security_state.can_switch_to(target_level))
					var/confirm = alert("Are you sure you want to change the alert level to [target_level.name]?", name, "No", "Yes")
					if(confirm == "Yes" && can_still_topic())
						security_state.set_security_level(target_level)
			else
				to_chat(usr, "You press the button, but a red light flashes and nothing happens.") //This should never happen

			current_status = STATE_DEFAULT
		if("viewmessage")
			. = TOPIC_HANDLED
			if(is_authenticated(user) && ntn_comm)
				current_viewing_message_id = text2num(href_list["target"])
				for(var/list/m in l.messages)
					if(m["id"] == current_viewing_message_id)
						current_viewing_message = m
				current_status = STATE_VIEWMESSAGE
		if("delmessage")
			. = TOPIC_HANDLED
			if(is_authenticated(user) && ntn_comm && l != global_message_listener)
				l.Remove(current_viewing_message)
			current_status = STATE_MESSAGELIST
		if("printmessage")
			. = TOPIC_HANDLED
			if(is_authenticated(user) && ntn_comm)
				if(!program.computer.print_paper(current_viewing_message["contents"],current_viewing_message["title"]))
					to_chat(usr, SPAN_NOTICE("Hardware Error: Printer was unable to print the selected file."))
		if("unbolt_doors")
			GLOB.using_map.unbolt_saferooms()
			to_chat(usr, SPAN_NOTICE("The console beeps, confirming the signal was sent to have the saferooms unbolted."))
		if("bolt_doors")
			GLOB.using_map.bolt_saferooms()
			to_chat(usr, SPAN_NOTICE("The console beeps, confirming the signal was sent to have the saferooms bolted."))
		if("toggle_alert_border")
			. = TOPIC_HANDLED
			if(is_authenticated(user) && ntn_comm)
				post_status("toggle_alert_border")

#undef STATE_DEFAULT
#undef STATE_MESSAGELIST
#undef STATE_VIEWMESSAGE
#undef STATE_STATUSDISPLAY
#undef STATE_ALERT_LEVEL

/*
General message handling stuff
*/
var/global/list/comm_message_listeners = list() //We first have to initialize list then we can use it.
var/global/datum/comm_message_listener/global_message_listener = new //May be used by admins
var/global/last_message_id = 0

/proc/get_comm_message_id()
	last_message_id = last_message_id + 1
	return last_message_id

/proc/post_comm_message(message_title, message_text)
	var/list/message = list()
	message["id"] = get_comm_message_id()
	message["title"] = message_title
	message["contents"] = message_text

	for (var/datum/comm_message_listener/l in comm_message_listeners)
		l.Add(message)

/datum/comm_message_listener
	var/list/messages

/datum/comm_message_listener/New()
	..()
	messages = list()
	comm_message_listeners.Add(src)

/datum/comm_message_listener/proc/Add(list/message)
	messages[LIST_PRE_INC(messages)] = message

/datum/comm_message_listener/proc/Remove(list/message)
	messages -= list(message)

/proc/post_status(command, data1, data2)

	var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435)

	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	switch(command)
		if("message")
			status_signal.data["msg1"] = data1
			status_signal.data["msg2"] = data2
			log_admin("STATUS: [key_name(usr)] set status screen message with: [data1] [data2]")
		if("image")
			status_signal.data["picture_state"] = data1
		if("toggle_alert_border")
			status_signal.data["toggle_alert_border"] = TRUE
	frequency.post_signal(signal = status_signal)

/proc/cancel_call_proc(mob/user)
	if (!evacuation_controller)
		return

	if(evacuation_controller.cancel_evacuation())
		log_and_message_admins("has cancelled the evacuation.", user)

	return


/proc/is_relay_online()
	for(var/obj/machinery/bluespacerelay/M in SSmachines.machinery)
		if(M.stat == FLAGS_OFF)
			return 1
	return 0

/proc/call_shuttle_proc(mob/user, emergency)
	if (!evacuation_controller)
		return

	if(isnull(emergency))
		emergency = 1

	if(!GLOB.universe.OnShuttleCall(usr))
		to_chat(user, SPAN_NOTICE("Cannot establish a bluespace connection."))
		return

	if(GLOB.deathsquad.deployed)
		to_chat(user, "[GLOB.using_map.boss_short] will not allow an evacuation to take place. Consider all contracts terminated.")
		return

	if(evacuation_controller.deny)
		to_chat(user, "An evacuation cannot be called at this time. Please try again later.")
		return

	if(evacuation_controller.is_on_cooldown()) // Ten minute grace period to let the game get going without lolmetagaming. -- TLE
		to_chat(user, evacuation_controller.get_cooldown_message())

	if(evacuation_controller.is_evacuating())
		to_chat(user, "An evacuation is already underway.")
		return

	if(evacuation_controller.call_evacuation(user, _emergency_evac = emergency))
		log_and_message_admins("has called the shuttle.", user)

/proc/init_autotransfer()

	if (!evacuation_controller)
		return

	. = evacuation_controller.call_evacuation(null, _emergency_evac = FALSE, autotransfer = TRUE)
	if(.)
		//delay events in case of an autotransfer
		var/delay = evacuation_controller.evac_arrival_time - world.time + (2 MINUTES)
		SSevent.delay_events(EVENT_LEVEL_MODERATE, delay)
		SSevent.delay_events(EVENT_LEVEL_MAJOR, delay)
