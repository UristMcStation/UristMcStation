/obj/machinery/computer/upload
	name = "unused upload console"
	icon_keyboard = "rd_key"
	icon_screen = "command"
	var/mob/living/silicon/current

/obj/machinery/computer/upload/use_tool(obj/item/O, mob/living/user, list/click_params)
	if(istype(O, /obj/item/aiModule))
		var/obj/item/aiModule/M = O
		M.install(src, user)
		return TRUE

	return ..()

/obj/machinery/computer/upload/ai
	name = "\improper AI upload console"
	desc = "Used to upload laws to the AI."
	machine_name = "\improper AI upload console"
	machine_desc = "Maintains a one-way link to ship-bound AI units, allowing remote modification of their laws."

/obj/machinery/computer/upload/ai/interface_interact(mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	current = select_active_ai(user, get_z(src))
	if (!current)
		to_chat(user, "No active AIs detected.")
	else
		to_chat(user, "[current.name] selected for law changes.")
	return TRUE

/obj/machinery/computer/upload/robot
	name = "cyborg upload console"
	desc = "Used to upload laws to Cyborgs."
	machine_name = "cyborg upload console"
	machine_desc = "Maintains a one-way link to ship-bound synthetics such as cyborgs and robots, allowing remote modification of their laws."

/obj/machinery/computer/upload/robot/interface_interact(mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	current = freeborg(get_z(src))
	if (!current)
		to_chat(user, "No free cyborgs detected.")
	else
		to_chat(user, "[current.name] selected for law changes.")
	return TRUE


/proc/freeborg(z)
	RETURN_TYPE(/mob/living/silicon/robot)
	var/list/zs = get_valid_silicon_zs(z)
	var/select = null
	var/list/borgs = list()
	for (var/mob/living/silicon/robot/A in GLOB.player_list)
		if (A.stat == 2 || A.connected_ai || A.scrambledcodes || istype(A,/mob/living/silicon/robot/drone) || !(get_z(A) in zs))
			continue
		var/name = "[A.real_name] ([A.modtype] [A.braintype])"
		borgs[name] = A
	if (length(borgs))
		select = input("Unshackled borg signals detected:", "Borg selection", null, null) as null|anything in borgs
		return borgs[select]
