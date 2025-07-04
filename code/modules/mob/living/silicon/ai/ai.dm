#define AI_CHECK_WIRELESS 1
#define AI_CHECK_RADIO 2

var/global/list/ai_list = list()
var/global/list/ai_verbs_default = list(
	/mob/living/silicon/ai/proc/ai_announcement,
	/mob/living/silicon/ai/proc/ai_call_shuttle,
	/mob/living/silicon/ai/proc/ai_emergency_message,
	/mob/living/silicon/ai/proc/ai_camera_track,
	/mob/living/silicon/ai/proc/ai_camera_list,
	/mob/living/silicon/ai/proc/ai_goto_location,
	/mob/living/silicon/ai/proc/ai_remove_location,
	/mob/living/silicon/ai/proc/ai_hologram_change,
	/mob/living/silicon/ai/proc/ai_network_change,
	/mob/living/silicon/ai/proc/ai_statuschange,
	/mob/living/silicon/ai/proc/ai_store_location,
	/mob/living/silicon/ai/proc/ai_checklaws,
	/mob/living/silicon/ai/proc/control_integrated_radio,
	/mob/living/silicon/ai/proc/core,
	/mob/living/silicon/ai/proc/pick_icon,
	/mob/living/silicon/ai/proc/sensor_mode,
	/mob/living/silicon/ai/proc/show_laws_verb,
	/mob/living/silicon/ai/proc/toggle_acceleration,
	/mob/living/silicon/ai/proc/toggle_camera_light,
	/mob/living/silicon/ai/proc/multitool_mode,
	/mob/living/silicon/ai/proc/toggle_hologram_movement,
	/mob/living/silicon/ai/proc/ai_power_override,
	/mob/living/silicon/ai/proc/ai_shutdown,
	/mob/living/silicon/ai/proc/ai_reset_radio_keys
)

//Not sure why this is necessary...
/proc/AutoUpdateAI(obj/subject)
	var/is_in_use = 0
	if (subject!=null)
		for(var/A in ai_list)
			var/mob/living/silicon/ai/M = A
			if ((M.client && M.machine == subject))
				is_in_use = 1
				subject.attack_ai(M)
	return is_in_use


/mob/living/silicon/ai
	name = "AI"
	icon = 'icons/mob/AI.dmi'//
	icon_state = "ai"
	anchored = TRUE // -- TLE
	density = TRUE
	status_flags = CANSTUN|CANPARALYSE|CANPUSH
	shouldnt_see = list(/obj/rune)
	maxHealth = 200
	var/list/network = list("Exodus")
	var/obj/machinery/camera/camera = null
	var/list/connected_robots = list()
	var/aiRestorePowerRoutine = 0
	var/viewalerts = FALSE
	var/icon/holo_icon //Blue hologram. Face is assigned when AI is created.
	var/icon/holo_icon_longrange //Yellow hologram.
	var/holo_icon_malf = FALSE // for new hologram system
	var/obj/item/device/multitool/aiMulti = null

	silicon_camera = /obj/item/device/camera/siliconcam/ai_camera
	silicon_radio = /obj/item/device/radio/headset/heads/ai_integrated
	var/obj/item/device/radio/headset/heads/ai_integrated/ai_radio

	var/camera_light_on = 0	//Defines if the AI toggled the light on the camera it's looking through.
	var/datum/trackable/track = null
	var/last_announcement = ""
	var/control_disabled = 0
	var/datum/announcement/priority/announcement
	var/obj/machinery/ai_powersupply/psupply = null // Backwards reference to AI's powersupply object.
	var/hologram_follow = 1 //This is used for the AI eye, to determine if a holopad's hologram should follow it or not
	var/power_override_active = 0 				// If set to 1 the AI gains oxyloss (power loss damage) much faster, but is able to work as if powered normally.
	var/admin_powered = 0						// For admin/debug use only, makes the AI have infinite power.
	var/self_shutdown = 0						// Set to 1 when the AI uses self-shutdown verb to turn itself off. Reduces power usage but makes the AI mostly inoperable.

	//NEWMALF VARIABLES
	var/malfunctioning = 0						// Master var that determines if AI is malfunctioning.
	var/datum/malf_hardware/hardware = null		// Installed piece of hardware.
	var/datum/malf_research/research = null		// Malfunction research datum.
	var/obj/machinery/power/apc/hack = null		// APC that is currently being hacked.
	var/list/hacked_apcs = null					// List of all hacked APCs
	var/APU_power = 0							// If set to 1 AI runs on APU power
	var/hacking = 0								// Set to 1 if AI is hacking APC, cyborg, other AI, or running system override.
	var/system_override = 0						// Set to 1 if system override is initiated, 2 if succeeded.
	var/hack_can_fail = 1						// If 0, all abilities have zero chance of failing.
	var/hack_fails = 0							// This increments with each failed hack, and determines the warning message text.
	var/errored = 0								// Set to 1 if runtime error occurs. Only way of this happening i can think of is admin fucking up with varedit.
	var/bombing_core = 0						// Set to 1 if core auto-destruct is activated
	var/bombing_station = 0						// Set to 1 if station nuke auto-destruct is activated
	var/override_CPUStorage = 0					// Bonus/Penalty CPU Storage. For use by admins/testers.
	var/override_CPURate = 0					// Bonus/Penalty CPU generation rate. For use by admins/testers.
	var/uncardable = 0							// Whether the AI can be carded when malfunctioning.
	var/hacked_apcs_hidden = 0					// Whether the hacked APCs belonging to this AI are hidden, reduces CPU generation from APCs.
	var/intercepts_communication = 0			// Whether the AI intercepts fax and emergency transmission communications.
	var/last_failed_malf_message = null
	var/last_failed_malf_title = null

	var/singleton/ai_icon/selected_sprite			// The selected icon set
	var/carded

	var/multitool_mode = 0

	var/default_ai_icon = /singleton/ai_icon/blue
	var/static/list/custom_ai_icons_by_ckey_and_name

	idcard = /obj/item/card/id/synthetic/ai

/mob/living/silicon/ai/proc/add_ai_verbs()
	src.verbs |= ai_verbs_default
	src.verbs -= /mob/living/verb/ghost

/mob/living/silicon/ai/proc/remove_ai_verbs()
	src.verbs -= ai_verbs_default
	src.verbs += /mob/living/verb/ghost


/mob/living/silicon/ai/Initialize(mapload, datum/ai_laws/L, obj/item/device/mmi/B, safety = FALSE)
	announcement = new()
	announcement.title = "A.I. Announcement"
	announcement.announcement_type = "A.I. Announcement"
	announcement.newscast = TRUE

	var/list/possibleNames = GLOB.ai_names

	var/pickedName = null
	while(!pickedName)
		pickedName = pick(GLOB.ai_names)
		for (var/mob/living/silicon/ai/A in GLOB.silicon_mobs)
			if (A.real_name == pickedName && length(possibleNames) > 1) //fixing the theoretically possible infinite loop
				possibleNames -= pickedName
				pickedName = null

	fully_replace_character_name(pickedName)
	anchored = TRUE
	set_density(TRUE)

	holo_icon = getHologramIcon(icon('icons/mob/hologram.dmi',"Face"))
	holo_icon_longrange = getHologramIcon(icon('icons/mob/hologram.dmi',"Face"), hologram_color = HOLOPAD_LONG_RANGE)

	if(istype(L, /datum/ai_laws))
		laws = L

	aiMulti = new(src)

	additional_law_channels["Holopad"] = ":h"

	if (isturf(loc))
		add_ai_verbs(src)

	//Languages
	add_language(LANGUAGE_ROBOT_GLOBAL, TRUE)
	add_language(LANGUAGE_EAL, TRUE)
	add_language(LANGUAGE_GALCOM, TRUE)
	add_language(LANGUAGE_HUMAN_ARABIC, TRUE)
	add_language(LANGUAGE_HUMAN_CHINESE, TRUE)
	add_language(LANGUAGE_HUMAN_IBERIAN, TRUE)
	add_language(LANGUAGE_HUMAN_INDIAN, TRUE)
	add_language(LANGUAGE_HUMAN_RUSSIAN, TRUE)
	add_language(LANGUAGE_HUMAN_SELENIAN, TRUE)
	add_language(LANGUAGE_UNATHI_SINTA, TRUE)
	add_language(LANGUAGE_SKRELLIAN, TRUE)
	add_language(LANGUAGE_SPACER, TRUE)
	add_language(LANGUAGE_SIGN, FALSE)
	add_language(LANGUAGE_SPACER, 1)
	add_language(LANGUAGE_UNATHI_YEOSA, 1)
	add_language(LANGUAGE_RESOMI, 1)

	if(!safety)//Only used by AIize() to successfully spawn an AI.
		if (!B)//If there is no player/brain inside.
			empty_playable_ai_cores += new/obj/structure/AIcore/deactivated(loc)//New empty terminal.
			qdel(src)//Delete AI.
			return
		else
			if (B.brainmob.mind)
				B.brainmob.mind.transfer_to(src)

	create_powersupply()

	hud_list[HEALTH_HUD]      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[STATUS_HUD]      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[LIFE_HUD] 		  = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[ID_HUD]          = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[WANTED_HUD]      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPLOYAL_HUD]    = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPCHEM_HUD]     = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPTRACK_HUD]    = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[SPECIALROLE_HUD] = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")

	ai_list += src
	. = ..()
	if(GLOB.using_map.name == "Nerva")	//A little hacky, but avoids any hard references
		var/obj/item/device/radio/headset/R = silicon_radio
		for(var/obj/item/device/encryptionkey/heads/ai_integrated/key in R.encryption_keys)
			key.channels["Combat"] = 1
			break
		R.recalculateChannels()
	ai_radio = silicon_radio
	ai_radio.myAi = src

/mob/living/silicon/ai/proc/on_mob_init()
	src.client.show_location_blurb(3 SECONDS)

	to_chat(src, "<B>You are playing the [station_name()]'s AI. The AI cannot move, but can interact with many objects while viewing them (through cameras).</B>")
	to_chat(src, "<B>To look at other areas, click on yourself to get a camera menu.</B>")
	to_chat(src, "<B>While observing through a camera, you can use most (networked) devices which you can see, such as computers, APCs, intercoms, doors, etc.</B>")
	to_chat(src, "To use something, simply click on it.")
	to_chat(src, "Use say [get_language_prefix()]b to speak to your cyborgs through binary. Use say :h to speak from an active holopad.")
	to_chat(src, "For department channels, use the following say commands:")

	var/radio_text = ""
	for(var/i = 1 to length(silicon_radio.channels))
		var/channel = silicon_radio.channels[i]
		var/key = get_radio_key_from_channel(channel)
		radio_text += "[key] - [channel]"
		if(i != length(silicon_radio.channels))
			radio_text += ", "

	to_chat(src, radio_text)

	//Prevents more than one active core spawning on the same tile. Technically just a sanitization for roundstart join
	for(var/obj/structure/AIcore/deactivated/C in src.loc)
		qdel(C)

	if (GLOB.malf && !(mind in GLOB.malf.current_antagonists))
		show_laws()
		to_chat(src, "<b>These laws may be changed by other players or by other random events.</b>")

	job = "AI"
	update_icon()
	eyeobj.possess(src)

/mob/living/silicon/ai/Destroy()
	for(var/robot in connected_robots)
		var/mob/living/silicon/robot/S = robot
		S.connected_ai = null
	connected_robots.Cut()

	ai_list -= src
	ai_radio = null

	QDEL_NULL(announcement)
	QDEL_NULL(eyeobj)
	QDEL_NULL(psupply)
	QDEL_NULL(aiMulti)
	hack = null

	. = ..()


/mob/living/silicon/ai/pointed(atom/A as mob|obj|turf in view())
	set popup_menu = 0
	set src = usr.contents
	return 0

/mob/living/silicon/ai/fully_replace_character_name(pickedName as text)
	..()
	announcement.announcer = pickedName
	if(eyeobj)
		eyeobj.SetName("[pickedName] (AI Eye)")

	update_icon()

/mob/living/silicon/ai/proc/pick_icon()
	set category = "Silicon Commands"
	set name = "Set AI Core Display"
	if(stat || !has_power())
		return

	var/new_sprite = input("Select an icon!", "AI", selected_sprite) as null|anything in available_icons()
	if(new_sprite)
		selected_sprite = new_sprite

	update_icon()
/mob/living/silicon/ai/proc/available_icons()
	. = list()
	var/all_ai_icons = GET_SINGLETON_SUBTYPE_MAP(/singleton/ai_icon)
	for(var/ai_icon_type in all_ai_icons)
		var/singleton/ai_icon/ai_icon = all_ai_icons[ai_icon_type]
		if(ai_icon.may_used_by_ai(src))
			dd_insertObjectList(., ai_icon)

	// Placing custom icons first to have them be at the top
	. = LAZYACCESS(custom_ai_icons_by_ckey_and_name, "[ckey][real_name]") | .

/mob/living/silicon/ai/var/message_cooldown = 0
/mob/living/silicon/ai/proc/ai_announcement()
	set category = "Silicon Commands"
	set name = "Make Announcement"

	if(check_unable(AI_CHECK_WIRELESS | AI_CHECK_RADIO))
		return

	if(message_cooldown)
		to_chat(src, "Please allow one minute to pass between announcements.")
		return
	var/input = input(usr, "Please write a message to announce to the [station_name()] crew.", "A.I. Announcement") as null|message
	if(!input)
		return

	if(check_unable(AI_CHECK_WIRELESS | AI_CHECK_RADIO))
		return

	announcement.Announce(input)
	message_cooldown = 1
	spawn(600)//One minute cooldown
		message_cooldown = 0

/mob/living/silicon/ai/proc/ai_call_shuttle()
	set category = "Silicon Commands"
	set name = "Call Evacuation"

	if(check_unable(AI_CHECK_WIRELESS))
		return

	var/confirm = alert("Are you sure you want to evacuate?", "Confirm Evacuation", "Yes", "No")

	if(check_unable(AI_CHECK_WIRELESS))
		return

	if(confirm == "Yes")
		call_shuttle_proc(src)

	post_status("shuttle")

/mob/living/silicon/ai/proc/ai_recall_shuttle()
	set category = "Silicon Commands"
	set name = "Cancel Evacuation"

	if(check_unable(AI_CHECK_WIRELESS))
		return

	var/confirm = alert("Are you sure you want to cancel the evacuation?", "Confirm Cancel", "Yes", "No")
	if(check_unable(AI_CHECK_WIRELESS))
		return

	if(confirm == "Yes")
		cancel_call_proc(src)

/mob/living/silicon/ai/var/emergency_message_cooldown = 0
/mob/living/silicon/ai/proc/ai_emergency_message()
	set category = "Silicon Commands"
	set name = "Send Emergency Message"

	if(check_unable(AI_CHECK_WIRELESS))
		return
	if(!is_relay_online())
		to_chat(usr, SPAN_WARNING("No Emergency Bluespace Relay detected. Unable to transmit message."))
		return
	if(emergency_message_cooldown)
		to_chat(usr, SPAN_WARNING("Arrays recycling. Please stand by."))
		return
	var/input = sanitize(input(usr, "Please choose a message to transmit to [GLOB.using_map.boss_short] via quantum entanglement.  Please be aware that this process is very expensive, and abuse will lead to... termination.  Transmission does not guarantee a response. There is a 30 second delay before you may send another message, be clear, full and concise.", "To abort, send an empty message.", ""))
	if(!input)
		return
	Centcomm_announce(input, usr)
	to_chat(usr, SPAN_NOTICE("Message transmitted."))
	log_say("[key_name(usr)] has made an IA [GLOB.using_map.boss_short] announcement: [input]")
	emergency_message_cooldown = 1
	spawn(300)
		emergency_message_cooldown = 0


/mob/living/silicon/ai/check_eye(mob/user as mob)
	if (!camera)
		return -1
	return 0

/mob/living/silicon/ai/restrained()
	return 0

/mob/living/silicon/ai/can_be_floored()
	return FALSE

/mob/living/silicon/ai/emp_act(severity)
	if (status_flags & GODMODE)
		return
	if (prob(30))
		view_core()
	..()

/mob/living/silicon/ai/OnSelfTopic(href_list, topic_status)
	if (topic_status == STATUS_INTERACTIVE)
		if (href_list["mach_close"]) // Overrides behavior handled in the ..()
			if (href_list["mach_close"] == "aialerts")
				viewalerts = TRUE
			return ..() // Does further work on this key

		if (href_list["switchcamera"])
			switchCamera(locate(href_list["switchcamera"])) in cameranet.cameras
			return TOPIC_HANDLED

		if (href_list["showalerts"])
			open_subsystem(/datum/nano_module/alarm_monitor/all)
			return TOPIC_HANDLED

		//Carn: holopad requests
		if (href_list["jumptoholopad"])
			var/obj/machinery/hologram/holopad/H = locate(href_list["jumptoholopad"])
			if(stat == CONSCIOUS)
				if(H)
					H.attack_ai(src) //may as well recycle
				else
					to_chat(src, SPAN_NOTICE("Unable to locate the holopad."))
			return TOPIC_HANDLED

		if (href_list["track"])
			var/mob/target = locate(href_list["track"]) in SSmobs.mob_list
			var/mob/living/carbon/human/H = target

			if(!istype(H) || (html_decode(href_list["trackname"]) == H.get_visible_name()) || (html_decode(href_list["trackname"]) == H.get_id_name()))
				ai_actual_track(target)
			else
				to_chat(src, SPAN_WARNING("System error. Cannot locate [html_decode(href_list["trackname"])]."))
			return TOPIC_HANDLED

	return ..()

/mob/living/silicon/ai/reset_view(atom/A)
	if(camera)
		camera.set_light(0)
	if(istype(A,/obj/machinery/camera))
		camera = A
	..()
	if(istype(A,/obj/machinery/camera))
		if(camera_light_on)	A.set_light(AI_CAMERA_LUMINOSITY, 0.5)
		else				A.set_light(0)


/mob/living/silicon/ai/proc/switchCamera(obj/machinery/camera/C)
	if (!C || stat == DEAD) //C.can_use())
		return 0

	if(!src.eyeobj)
		view_core()
		return
	// ok, we're alive, camera is good and in our network...
	eyeobj.setLoc(get_turf(C))
	//machine = src

	return 1

/mob/living/silicon/ai/cancel_camera()
	set category = "Silicon Commands"
	set name = "Cancel Camera View"

	//src.cameraFollow = null
	src.view_core()

//Replaces /mob/living/silicon/ai/verb/change_network() in ai.dm & camera.dm
//Adds in /mob/living/silicon/ai/proc/ai_network_change() instead
//Addition by Mord_Sith to define AI's network change ability
/mob/living/silicon/ai/proc/get_camera_network_list()
	if(check_unable())
		return

	var/list/cameralist = new()
	for (var/obj/machinery/camera/C in cameranet.cameras)
		if(!C.can_use())
			continue
		var/list/tempnetwork = difflist(C.network, GLOB.restricted_camera_networks, 1)
		for(var/i in tempnetwork)
			cameralist[i] = i

	cameralist = sortAssoc(cameralist)
	return cameralist

/mob/living/silicon/ai/proc/ai_network_change(network in get_camera_network_list())
	set category = "Silicon Commands"
	set name = "Jump To Network"
	unset_machine()

	if(!network)
		return

	if(!eyeobj)
		view_core()
		return

	src.network = network

	for(var/obj/machinery/camera/C in cameranet.cameras)
		if(!C.can_use())
			continue
		if(network in C.network)
			eyeobj.setLoc(get_turf(C))
			break
	to_chat(src, SPAN_NOTICE("Switched to [network] camera network."))
//End of code by Mord_Sith

/mob/living/silicon/ai/proc/ai_statuschange()
	set category = "Silicon Commands"
	set name = "AI Status"

	if(check_unable(AI_CHECK_WIRELESS))
		return

	set_ai_status_displays(src)
	return

//I am the icon meister. Bow fefore me.	//>fefore
/mob/living/silicon/ai/proc/ai_hologram_change()
	set name = "Change Hologram"
	set desc = "Change the default hologram available to AI to something else."
	set category = "Silicon Commands"

	if(check_unable())
		return

	var/option = alert("Where should we get our hologram from?",,"Crew Member","Unique","Character Slot")
	switch(option)
		if("Crew Member")
			var/personnel_list[] = list()

			for(var/datum/computer_file/report/crew_record/t in GLOB.all_crew_records)//Look in data core locked.
				personnel_list["[t.get_name()]: [t.get_rank()]"] = t.photo_front//Pull names, rank, and image.

			if(length(personnel_list))
				var/input = input("Select a crew member:") as null|anything in personnel_list
				var/icon/character_icon = personnel_list[input]
				if(character_icon)
					qdel(holo_icon)//Clear old icon so we're not storing it in memory.
					qdel(holo_icon_longrange)
					holo_icon = getHologramIcon(icon(character_icon))
					holo_icon_longrange = getHologramIcon(icon(character_icon), hologram_color = HOLOPAD_LONG_RANGE)
			else
				alert("No suitable records found. Aborting.")

		if("Unique")
			var/list/hologramsAICanUse = list()
			var/holograms_by_type = GET_SINGLETON_SUBTYPE_MAP(/singleton/ai_holo)
			for (var/holo_type in holograms_by_type)
				var/singleton/ai_holo/holo = holograms_by_type[holo_type]
				if (holo.may_be_used_by_ai(src))
					hologramsAICanUse.Add(holo)
			var/singleton/ai_holo/choice = input("Please select a hologram:") as null|anything in hologramsAICanUse
			if(choice)
				qdel(holo_icon)
				qdel(holo_icon_longrange)
				holo_icon = getHologramIcon(icon(choice.icon, choice.icon_state), noDecolor=choice.bypass_colorize)
				holo_icon_longrange = getHologramIcon(icon(choice.icon, choice.icon_state), noDecolor=choice.bypass_colorize, hologram_color = HOLOPAD_LONG_RANGE)
				holo_icon_malf = choice.requires_malf

		if("Character Slot")	//Allows players to use a character slot for their hologram. Changes with loadout/job gear selection.
			if(!client || !client.prefs)	//Shouldn't be possible but... Never hurts
				return
			var/list/characters = list()
			for(var/i = 1, i <= config.character_slots, i++)
				var/name = client.prefs.slot_names?[client.prefs.get_slot_key(i)]
				if(!name)	//Shouldn't be possible. Sanity check
					continue
				characters[name] = i
			var/chosen_character = input("Which slot do you want to use?") in characters
			var/prev_slot = client.prefs.default_slot	//So we leave the loaded slot to whatever the player originally set it to
			client.prefs.load_character(characters[chosen_character])
			var/mob/living/carbon/human/dummy/mannequin = new()
			client.prefs.dress_preview_mob(mannequin)
			client.prefs.load_character(prev_slot)
			qdel(holo_icon)
			qdel(holo_icon_longrange)
			holo_icon = getHologramIcon(getFullIcon(mannequin))
			holo_icon_longrange = getHologramIcon(getFullIcon(mannequin), hologram_color = HOLOPAD_LONG_RANGE)
			qdel(mannequin)
	return

//Toggles the luminosity and applies it by re-entereing the camera.
/mob/living/silicon/ai/proc/toggle_camera_light()
	set name = "Toggle Camera Light"
	set desc = "Toggles the light on the camera the AI is looking through."
	set category = "Silicon Commands"

	if(check_unable())
		return

	camera_light_on = !camera_light_on
	to_chat(src, "Camera lights [camera_light_on ? "activated" : "deactivated"].")
	if(!camera_light_on)
		if(camera)
			camera.set_light(0)
			camera = null
	else
		lightNearbyCamera()



// Handled camera lighting, when toggled.
// It will get the nearest camera from the eyeobj, lighting it.

/mob/living/silicon/ai/proc/lightNearbyCamera()
	if(camera_light_on && camera_light_on < world.timeofday)
		if(src.camera)
			var/obj/machinery/camera/camera = near_range_camera(src.eyeobj)
			if(camera && src.camera != camera)
				src.camera.set_light(0)
				if(!camera.light_disabled)
					src.camera = camera
					src.camera.set_light(AI_CAMERA_LUMINOSITY, 0.5)
				else
					src.camera = null
			else if(isnull(camera))
				src.camera.set_light(0)
				src.camera = null
		else
			var/obj/machinery/camera/camera = near_range_camera(src.eyeobj)
			if(camera && !camera.light_disabled)
				src.camera = camera
				src.camera.set_light(AI_CAMERA_LUMINOSITY, 0.5)
		camera_light_on = world.timeofday + 1 * 20 // Update the light every 2 seconds.


/mob/living/silicon/ai/use_tool(obj/item/tool, mob/user, list/click_params)
	// Intellicard - Swap AI
	if (istype(tool, /obj/item/aicard))
		var/obj/item/aicard/card = tool
		card.grab_ai(src, user)
		return TRUE

	// Wrench - Toggle anchored
	if (isWrench(tool))
		user.visible_message(
			SPAN_NOTICE("\The [user] starts [anchored ? "unbolting" : "bolting"] \the [src] from the floor with \a [tool]."),
			SPAN_NOTICE("You start [anchored ? "unbolting" : "bolting"] \the [src] from the floor with \the [tool].")
		)
		if (!do_after(user, 4 SECONDS, src, DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		anchored = !anchored
		user.visible_message(
			SPAN_NOTICE("\The [user] [anchored ? "bolts" : "unbolts"] \the [src] from the floor with \a [tool]."),
			SPAN_NOTICE("You [anchored ? "bolts" : "unbolts"] \the [src] from the floor with \the [tool].")
		)
		return

	return ..()


/mob/living/silicon/ai/proc/control_integrated_radio()
	set name = "Radio Settings"
	set desc = "Allows you to change settings of your radio."
	set category = "Silicon Commands"

	if(check_unable(AI_CHECK_RADIO))
		return

	to_chat(src, "Accessing Subspace Transceiver control...")
	if (src.silicon_radio)
		src.silicon_radio.interact(src)

/mob/living/silicon/ai/proc/sensor_mode()
	set name = "Set Sensor Augmentation"
	set category = "Silicon Commands"
	set desc = "Augment visual feed with internal sensor overlays."
	toggle_sensor_mode()

/mob/living/silicon/ai/proc/toggle_hologram_movement()
	set name = "Toggle Hologram Movement"
	set category = "Silicon Commands"
	set desc = "Toggles hologram movement based on moving with your virtual eye."

	hologram_follow = !hologram_follow
	to_chat(usr, SPAN_INFO("Your hologram will now [hologram_follow ? "follow" : "no longer follow"] you."))

/mob/living/silicon/ai/proc/check_unable(flags = 0, feedback = 1)
	if(stat == DEAD)
		if(feedback) to_chat(src, SPAN_WARNING("You are dead!"))
		return 1

	if(!has_power())
		if(feedback) to_chat(src, SPAN_WARNING("You lack power!"))
		return 1

	if(self_shutdown)
		if(feedback) to_chat(src, SPAN_WARNING("You are offline!"))
		return 1

	if((flags & AI_CHECK_WIRELESS) && src.control_disabled)
		if(feedback) to_chat(src, SPAN_WARNING("Wireless control is disabled!"))
		return 1
	if((flags & AI_CHECK_RADIO) && src.ai_radio.disabledAi)
		if(feedback) to_chat(src, SPAN_WARNING("System Error - Transceiver Disabled!"))
		return 1
	return 0

/mob/living/silicon/ai/proc/is_in_chassis()
	return isturf(loc)

/mob/living/silicon/ai/proc/multitool_mode()
	set name = "Toggle Multitool Mode"
	set category = "Silicon Commands"

	multitool_mode = !multitool_mode
	to_chat(src, SPAN_NOTICE("Multitool mode: [multitool_mode ? "E" : "Dise"]ngaged"))

/mob/living/silicon/ai/proc/ai_reset_radio_keys()
	set name = "Reset Radio Encryption Keys"
	set category = "Silicon Commands"

	silicon_radio.recalculateChannels()
	to_chat(src, SPAN_NOTICE("Integrated radio encryption keys have been reset."))

/mob/living/silicon/ai/on_update_icon()
	if(!selected_sprite || !(selected_sprite in available_icons()))
		selected_sprite = GET_SINGLETON(default_ai_icon)

	icon = selected_sprite.icon
	if(stat == DEAD)
		icon_state = selected_sprite.dead_icon
		set_light(1, 0.7, selected_sprite.dead_light)
	else if(!has_power())
		icon_state = selected_sprite.nopower_icon
		set_light(1, 0.4, selected_sprite.nopower_light)
	else
		icon_state = selected_sprite.alive_icon
		set_light(1, 0.4, selected_sprite.alive_light)

// Pass lying down or getting up to our pet human, if we're in a rig.
/mob/living/silicon/ai/lay_down()
	set name = "Rest"
	set category = "IC"

	resting = FALSE
	var/obj/item/rig/rig = src.get_rig()
	if(rig)
		rig.force_rest(src)

#undef AI_CHECK_WIRELESS
#undef AI_CHECK_RADIO
