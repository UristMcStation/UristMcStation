var/global/list/mob_hat_cache = list()
/proc/get_hat_icon(obj/item/hat, offset_x = 0, offset_y = 0)
	RETURN_TYPE(/image)
	var/t_state = hat.icon_state
	if(hat.item_state_slots && hat.item_state_slots[slot_head_str])
		t_state = hat.item_state_slots[slot_head_str]
	else if(hat.item_state)
		t_state = hat.item_state
	var/key = "[t_state]_[offset_x]_[offset_y]"
	if(!mob_hat_cache[key])            // Not ideal as there's no guarantee all hat icon_states
		var/t_icon = GLOB.default_onmob_icons[slot_head_str] // are unique across multiple dmis, but whatever.
		if(hat.icon_override)
			t_icon = hat.icon_override
		else if(hat.item_icons && (slot_head_str in hat.item_icons))
			t_icon = hat.item_icons[slot_head_str]
		var/image/I = image(icon = t_icon, icon_state = t_state)
		I.pixel_x = offset_x
		I.pixel_y = offset_y
		mob_hat_cache[key] = I
	return mob_hat_cache[key]

/mob/living/silicon/robot/drone
	name = "maintenance drone"
	real_name = "drone"
	icon = 'icons/mob/robots_drones.dmi'
	icon_state = "repairbot"
	maxHealth = 35
	health = 35
	cell_emp_mult = 1
	universal_speak = FALSE
	universal_understand = TRUE
	gender = NEUTER
	pass_flags = PASS_FLAG_TABLE
	faction = "silicon"
	braintype = "Drone"
	lawupdate = FALSE
	density = TRUE
	req_access = list(access_engine, access_robotics)
	integrated_light_power = 0.5
	local_transmit = 1
	possession_candidate = TRUE

	can_pull_size = ITEM_SIZE_NORMAL
	can_pull_mobs = MOB_PULL_SMALLER

	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = SIMPLE_ANIMAL
	mob_push_flags = SIMPLE_ANIMAL
	mob_always_swap = 1

	mob_size = MOB_MEDIUM // Small mobs can't open doors, it's a huge pain for drones.

	laws = /datum/ai_laws/drone

	silicon_camera = /obj/item/device/camera/siliconcam/drone_camera

	//Used for self-mailing.
	var/mail_destination = ""
	var/module_type = /obj/item/robot_module/drone
	var/obj/item/hat
	var/hat_x_offset = 0
	var/hat_y_offset = -13
	/// Integer or null. If set, the drone will self destruct upon leaving any z-levels connected to the provided value.
	var/z_locked = null

	holder_type = /obj/item/holder/drone

/mob/living/silicon/robot/drone/Initialize(mapload, lock_to_current_z = TRUE)
	. = ..()

	verbs += /mob/living/proc/hide
	remove_language(LANGUAGE_ROBOT_GLOBAL)
	add_language(LANGUAGE_ROBOT_GLOBAL, 0)
	add_language(LANGUAGE_DRONE_GLOBAL, 1)
	default_language = all_languages[LANGUAGE_DRONE_GLOBAL]
	// NO BRAIN.
	mmi = null

	//We need to screw with their HP a bit. They have around one fifth as much HP as a full borg.
	for(var/V in components) if(V != "power cell")
		var/datum/robot_component/C = components[V]
		C.max_damage = 10

	verbs -= /mob/living/silicon/robot/verb/Namepick
	update_icon()

	if (lock_to_current_z)
		z_locked = get_z(src)

	GLOB.moved_event.register(src, src, PROC_REF(on_moved))

/mob/living/silicon/robot/drone/Destroy()
	if(hat)
		hat.dropInto(loc)
		hat = null
	GLOB.moved_event.unregister(src, src, PROC_REF(on_moved))
	. = ..()

/mob/living/silicon/robot/drone/proc/on_moved(atom/movable/am, turf/old_loc, turf/new_loc)
	if (isnull(z_locked))
		return
	var/new_z = get_z(new_loc)

	if (AreConnectedZLevels(z_locked, new_z))
		return

	// None of the tests passed, good bye
	self_destruct()

/mob/living/silicon/robot/drone/can_be_possessed_by(mob/observer/ghost/possessor)
	if(!istype(possessor) || !possessor.client || !possessor.ckey)
		return 0
	if(!config.allow_drone_spawn)
		to_chat(src, SPAN_DANGER("Playing as drones is not currently permitted."))
		return 0
	if(too_many_active_drones())
		to_chat(src, SPAN_DANGER("The maximum number of active drones has been reached.."))
		return 0
	if(jobban_isbanned(possessor,"Robot"))
		to_chat(usr, SPAN_DANGER("You are banned from playing synthetics and cannot spawn as a drone."))
		return 0
	if(!possessor.MayRespawn(1,DRONE_SPAWN_DELAY))
		return 0
	return 1

/mob/living/silicon/robot/drone/do_possession(mob/observer/ghost/possessor)
	if(!(istype(possessor) && possessor.ckey))
		return 0
	if(src.ckey || src.client)
		to_chat(possessor, SPAN_WARNING("\The [src] already has a player."))
		return 0
	message_admins(SPAN_CLASS("adminnotice", "[key_name_admin(possessor)] has taken control of \the [src]."))
	log_admin("[key_name(possessor)] took control of \the [src].")
	transfer_personality(possessor.client)
	qdel(possessor)
	return 1

/mob/living/silicon/robot/drone/construction
	name = "construction drone"
	icon_state = "constructiondrone"
	laws = /datum/ai_laws/construction_drone
	module_type = /obj/item/robot_module/drone/construction
	hat_x_offset = 1
	hat_y_offset = -12
	can_pull_size = ITEM_SIZE_NO_CONTAINER
	can_pull_mobs = MOB_PULL_SAME

/mob/living/silicon/robot/drone/init()
	additional_law_channels["Drone"] = ":d"
	if(!module) module = new module_type(src)

	flavor_text = "It's a tiny little repair drone. The casing is stamped with an corporate logo and the subscript: '[GLOB.using_map.company_name] Recursive Repair Systems: Fixing Tomorrow's Problem, Today!'"
	playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 0)

//Redefining some robot procs...
/mob/living/silicon/robot/drone/fully_replace_character_name(pickedName as text)
	// Would prefer to call the grandparent proc but this isn't possible, so..
	real_name = pickedName
	SetName(real_name)

/mob/living/silicon/robot/drone/updatename()
	if(controlling_ai)
		real_name = "remote drone ([controlling_ai.name])"
	else
		real_name = "[initial(name)] ([random_id(type,100,999)])"
	SetName(real_name)

/mob/living/silicon/robot/drone/on_update_icon()

	ClearOverlays()
	if(stat == 0)
		if(controlling_ai)
			AddOverlays("eyes-[icon_state]-ai")
		else if(emagged)
			AddOverlays("eyes-[icon_state]-emag")
		else
			AddOverlays("eyes-[icon_state]")
	else
		CutOverlays("eyes")

	if(hat) // Let the drones wear hats.
		var/hat_icon = get_hat_icon(hat, hat_x_offset, hat_y_offset)
		AddOverlays(hat_icon)

/mob/living/silicon/robot/drone/choose_icon()
	return

/mob/living/silicon/robot/drone/pick_module()
	return

/mob/living/silicon/robot/drone/proc/wear_hat(obj/item/new_hat)
	if(hat)
		return
	hat = new_hat
	new_hat.forceMove(src)
	update_icon()


/mob/living/silicon/robot/drone/use_tool(obj/item/tool, mob/user, list/click_params)
	// Crowbar - Block interaction
	if (isCrowbar(tool))
		USE_FEEDBACK_FAILURE("\The [src] is hermetically sealed. You can't open the case.")
		return TRUE

	// Hat - Equip hat
	if (istype(tool, /obj/item/clothing/head))
		if (hat)
			USE_FEEDBACK_FAILURE("\The [src] is already wearing \a [hat].")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		wear_hat(tool)
		user.visible_message(
			SPAN_NOTICE("\The [user] puts \a [tool] on \the [src]."),
			SPAN_NOTICE("You put \the [tool] on \the [src]."),
			exclude_mobs = list(src)
		)
		to_chat(src, SPAN_NOTICE("\The [user] puts \a [tool] on you."))
		return TRUE

	// ID Card - Reboot or shutdown the drone
	var/obj/item/card/id/id = tool.GetIdCard()
	if (istype(id))
		var/id_name = GET_ID_NAME(id, tool)
		// Reboot
		if (stat == DEAD)
			if (!config.allow_drone_spawn || emagged || health < -35)
				USE_FEEDBACK_FAILURE("\The [src] interface is fried, and a distressing burned smell wafts from \his interior. You're not rebooting this one.")
				return TRUE
			if (!check_access(id))
				USE_FEEDBACK_ID_CARD_DENIED(src, id_name)
				return TRUE
			request_player()
			user.visible_message(
				SPAN_NOTICE("\The [user] swipes \a [tool] over \the [src], attempting to reboot it."),
				SPAN_NOTICE("You swipe [id_name] over \the [src], attempting to reboot it.")
			)
		// Shutdown
		else
			user.visible_message(
				SPAN_WARNING("\The [user] swipes \a [tool] over \the [src], attempting to shut it down."),
				SPAN_WARNING("You swipe [id_name] over \the [src], attempting to shut it down."),
				exclude_mobs = list(src)
			)
			to_chat(src, SPAN_DANGER("\The [user] swipes \a [tool] over you, attempting to shut you down!"))
			if (emagged || !check_access(id))
				USE_FEEDBACK_ID_CARD_DENIED(src, id_name)
				return TRUE
			shut_down()
		return TRUE

	// Robot Upgrade Module - Block interaction
	if (istype(tool, /obj/item/borg/upgrade))
		USE_FEEDBACK_FAILURE("\The [src] is not compatible with \the [tool].")
		return TRUE

	return ..()


/mob/living/silicon/robot/drone/emag_act(remaining_charges, mob/user)
	if(!client || stat == 2)
		to_chat(user, SPAN_DANGER("There's not much point subverting this heap of junk."))
		return

	if(emagged)
		to_chat(src, SPAN_DANGER("\The [user] attempts to load subversive software into you, but your hacked subroutines ignore the attempt."))
		to_chat(user, SPAN_DANGER("You attempt to subvert [src], but the sequencer has no effect."))
		return

	to_chat(user, SPAN_DANGER("You swipe the sequencer across [src]'s interface and watch its eyes flicker."))

	if(controlling_ai)
		to_chat(src, "<span class='danger'>\The [user] loads some kind of subversive software into the remote drone, corrupting its lawset but luckily sparing yours.</span>")
	else
		to_chat(src, "<span class='danger'>You feel a sudden burst of malware loaded into your execute-as-root buffer. Your tiny brain methodically parses, loads and executes the script.</span>")

	log_and_message_admins("emagged drone [key_name_admin(src)].  Laws overridden.", user)
	log_game("[key_name(user)] emagged drone [key_name(src)][controlling_ai ? " but AI [key_name(controlling_ai)] is in remote control" : " Laws overridden"].")
	var/time = time2text(world.realtime,"hh:mm:ss")
	GLOB.lawchanges.Add("[time] <B>:</B> [user.name]([user.key]) emagged [name]([key])")

	emagged = TRUE
	lawupdate = FALSE
	connected_ai = null
	clear_supplied_laws()
	clear_inherent_laws()
	QDEL_NULL(laws)
	laws = new /datum/ai_laws/syndicate_override
	var/datum/pronouns/pronouns = user.choose_from_pronouns()
	set_zeroth_law("Only [user.real_name] and people [pronouns.he] designates as being such are operatives.")

	if(!controlling_ai)
		to_chat(src, "<b>Obey these laws:</b>")
		laws.show_laws(src)
		to_chat(src, "<span class='danger'>ALERT: [user.real_name] is your new master. Obey your new laws and \his commands.</span>")
	return 1

//DRONE LIFE/DEATH
//For some goddamn reason robots have this hardcoded. Redefining it for our fragile friends here.
/mob/living/silicon/robot/drone/updatehealth()
	if(status_flags & GODMODE)
		health = 35
		set_stat(CONSCIOUS)
		return
	health = 35 - (getBruteLoss() + getFireLoss())
	return

//Easiest to check this here, then check again in the robot proc.
//Standard robots use config for crit, which is somewhat excessive for these guys.
//Drones killed by damage will gib.
/mob/living/silicon/robot/drone/handle_regular_status_updates()
	if(health <= -35 && src.stat != DEAD)
		self_destruct()
		return
	if(health <= 0 && src.stat != DEAD)
		death()
		return
	..()

/mob/living/silicon/robot/drone/self_destruct()
	timeofdeath = world.time
	death() //Possibly redundant, having trouble making death() cooperate.
	gib()

//DRONE MOVEMENT.
/mob/living/silicon/robot/drone/slip_chance(prob_slip)
	return 0

//CONSOLE PROCS
/mob/living/silicon/robot/drone/proc/law_resync()

	if(controlling_ai)
		to_chat(src, "<span class='warning'>Someone issues a remote law reset order for this unit, but you disregard it.</span>")
		return

	if(stat != 2)
		if(emagged)
			to_chat(src, SPAN_DANGER("You feel something attempting to modify your programming, but your hacked subroutines are unaffected."))
		else
			to_chat(src, SPAN_DANGER("A reset-to-factory directive packet filters through your data connection, and you obediently modify your programming to suit it."))
			full_law_reset()
			show_laws()

/mob/living/silicon/robot/drone/proc/shut_down()

	if(controlling_ai)
		to_chat(src, "<span class='warning'>Someone issues a remote kill order for this unit, but you disregard it.</span>")
		return

	if(stat != 2)
		if(emagged)
			to_chat(src, SPAN_DANGER("You feel a system kill order percolate through your tiny brain, but it doesn't seem like a good idea to you."))
		else
			to_chat(src, SPAN_DANGER("You feel a system kill order percolate through your tiny brain, and you obediently destroy yourself."))
			death()

/mob/living/silicon/robot/drone/proc/full_law_reset()
	clear_supplied_laws(1)
	clear_inherent_laws(1)
	clear_ion_laws(1)
	QDEL_NULL(laws)
	var/law_type = initial(laws) || GLOB.using_map.default_law_type
	laws = new law_type

//Reboot procs.

/mob/living/silicon/robot/drone/proc/request_player()
	if(too_many_active_drones())
		return
	var/datum/ghosttrap/G = get_ghost_trap("maintenance drone")
	G.request_player(src, "Someone is attempting to reboot a maintenance drone.", 30 SECONDS)

/mob/living/silicon/robot/drone/proc/transfer_personality(client/player)
	if(!player) return
	src.ckey = player.ckey

	if(player.mob && player.mob.mind)
		player.mob.mind.transfer_to(src)

	lawupdate = FALSE
	to_chat(src, "<b>Systems rebooted</b>. Loading base pattern maintenance protocol... <b>loaded</b>.")
	full_law_reset()
	welcome_drone()

/mob/living/silicon/robot/drone/proc/welcome_drone()
	to_chat(src, "<b>You are a maintenance drone, a tiny-brained robotic repair machine</b>. You have no individual will, no personality, and no drives or urges other than your laws.")
	to_chat(src, "Remember, you are <b>lawed against interference with the crew</b>, you should leave the area if your actions are interfering, or that the crew does not want your presence.")
	to_chat(src, "You are <b>not required to follow orders from anyone; not the AI, not humans, and not other synthetics.</b>. However, you should respond to presence requests issued from drone controls consoles.")
	to_chat(src, "Use <b>say ;Hello</b> to talk to other drones and <b>say Hello</b> to speak silently to your nearby fellows.")

/mob/living/silicon/robot/drone/add_robot_verbs()
	return

/mob/living/silicon/robot/drone/remove_robot_verbs()
	return

/mob/living/silicon/robot/drone/construction/welcome_drone()
	to_chat(src, "<b>You are a construction drone, an autonomous engineering and fabrication system.</b>.")
	to_chat(src, "You are assigned to a construction project. The name is irrelevant. Your task is to complete construction and subsystem integration as soon as possible.")
	to_chat(src, "Use <b>:d</b> to talk to other drones and <b>say</b> to speak silently to your nearby fellows.")
	to_chat(src, "<b>You do not follow orders from anyone; not the AI, not humans, and not other synthetics.</b>.")

/mob/living/silicon/robot/drone/construction/init()
	..()
	flavor_text = "It's a bulky construction drone."

/proc/too_many_active_drones()
	var/drones = 0
	for(var/mob/living/silicon/robot/drone/D in GLOB.silicon_mobs)
		if(D.key && D.client)
			drones++
	return drones >= config.max_maint_drones

/mob/living/silicon/robot/drone/show_laws(everyone = 0)
	if(!controlling_ai)
		return..()
	to_chat(src, "<b>Obey these laws:</b>")
	controlling_ai.laws_sanity_check()
	controlling_ai.laws.show_laws(src)

/mob/living/silicon/robot/drone/robot_checklaws()
	set category = "Silicon Commands"
	set name = "State Laws"

	if(!controlling_ai)
		return ..()
	controlling_ai.open_subsystem(/datum/nano_module/law_manager)
