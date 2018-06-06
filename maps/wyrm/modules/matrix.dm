/*
So, this is a shadowrun-y matrix system where the maps are generated in runtime, and the only thing that can't be changed in the matrix is loaded programs.
It also happens to be in a single file since chances are I'll be the only one to ever read this.
If for some insane reason you want to port this or wonder what all these undocumented functions are feel free to ask me what the hell I was thinking on discord Naxodile#3411
*/
#define MTRX_ATK 1
#define MTRX_SLZ 2
#define MTRX_PROC 3
#define MTRX_FRW 4

/obj/item/modular_computer/cyberdeck
	name = "cyberdeck"
	desc = "A portable computer used to access the matrix."
//	icon = 'icons/obj/modular_cyberdeck.dmi'
//	icon_state = "cyberdeck"
//	icon_state_unpowered = "cyberdeck-dead"
	icon_state_menu = "menu"
	hardware_flag = PROGRAM_CONSOLE
	max_hardware_size = 3
	w_class = ITEM_SIZE_HUGE
	light_strength = 2
	slot_flags = SLOT_BACK

	var/mob/living/matrix_user
	var/list/matrix_stats[4] //Sorted according to defines
	var/list/matrix_sorted //Sorted highest to lowest
	var/list/loaded_programs = list()

//config settings
	var/matrix_name
	var/matrix_icon

/obj/item/modular_computer/cyberdeck/New()
	..()
	refresh_stats()


/obj/item/modular_computer/cyberdeck/preset/New()
	processor_unit = new/obj/item/weapon/computer_hardware/processor_unit(src)
	tesla_link = new/obj/item/weapon/computer_hardware/tesla_link(src)
	hard_drive = new/obj/item/weapon/computer_hardware/hard_drive/advanced(src)
	network_card = new/obj/item/weapon/computer_hardware/network_card/advanced(src)
	nano_printer = new/obj/item/weapon/computer_hardware/nano_printer(src)
	card_slot = new/obj/item/weapon/computer_hardware/card_slot(src)
	battery_module = new/obj/item/weapon/computer_hardware/battery_module/advanced(src)
	battery_module.charge_to_full()

	new/obj/item/weapon/computer_hardware/proxy(src)
	new/obj/item/weapon/computer_hardware/firewall(src)
	refresh_stats()

	hard_drive.store_file(new/datum/computer_file/program/matrix(src))
	hard_drive.store_file(new/datum/computer_file/matrix_software/junk(src))

/obj/item/modular_computer/cyberdeck/attack
/obj/item/modular_computer/cyberdeck/defense
/obj/item/modular_computer/cyberdeck/support

/obj/item/modular_computer/cyberdeck/try_install_component(var/mob/living/user, var/obj/item/weapon/computer_hardware/H, var/found = 0)
	if(!..())	return
	if(!H.matrix_stat)	return

	refresh_stats()

/obj/item/modular_computer/cyberdeck/proc/refresh_stats()
	for(var/obj/item/weapon/computer_hardware/H in contents)
		if(H.matrix_stat)
			matrix_stats[H.matrix_stat] = H.origin_tech[TECH_DATA]
	matrix_sorted = sortTim(matrix_stats)


/obj/item/modular_computer/cyberdeck/proc/get_max_programs()
	return matrix_stats[MTRX_PROC] * 2 //Possibly remove the multiplier

/obj/item/modular_computer/cyberdeck/proc/get_corruption()
	. = 0
	for(var/obj/item/weapon/computer_hardware/H in contents)
		if(!H.matrix_stat)
			continue
		. += H.damage

/obj/item/modular_computer/cyberdeck/proc/attempt_connect(mob/user)
	var/area/A = get_area(src)
	if(!A.node)
		return
	to_chat(user, "<span class='notice'>Now entering [A.node]</span>")
//	new /mob/matrix/player(A.node.gateway, src, user)

/obj/item/modular_computer/cyberdeck/proc/switch_program(var/prog)
	if(loaded_programs.len + 1 < get_max_programs())
		if(prog in loaded_programs) //I'm sure there's bitwise magic for this, but it gets used pretty rarely
			loaded_programs -= prog
		else
			loaded_programs += prog
			return TRUE

/datum/computer_file/program/matrix
	filetype = "MTRX"
	filename = "M_Ctrl_Diag"
	filedesc = "Matrix Control and Diagnostics"
	size = 32
	available_on_ntnet = FALSE

	nanomodule_path = /datum/nano_module/program/matrix_control

/datum/nano_module/program/matrix_control
	name = "Matrix Control"
	var/obj/item/modular_computer/cyberdeck/C

/datum/nano_module/program/matrix_control/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	..()
	var/list/data = host.initial_data()

	var/area/A = get_area(user)
	if(A.node)
		data["node"] = A.node.name
		data["sec_level"] = A.node.security_rating
	if(istype(host, /obj/item/modular_computer/cyberdeck))
		C = host
		var/list/progs = list()
		for(var/datum/computer_file/matrix_software/S in C.hard_drive.stored_files)
			if(S in C.loaded_programs)
				progs += list(list("filename" = S.filename,"loaded" = TRUE))
			else
				progs += list(list("filename" = S.filename,"loaded" = FALSE))
		data["programs"] = progs
		data["loaded_programs"] = C.loaded_programs.len
		data["max_programs"] = C.get_max_programs()
		data["corruption"] = C.get_corruption()
		data["config_name"] = C.matrix_name
		data["config_icon"] = C.matrix_icon
	else //Somehow?
		data["loaded_programs"] = 0
		data["max_programs"] = 0
	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "matrixportal.tmpl", "Matrix Control", 940, 260, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/matrix_control/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["switch_prog"])
		C.switch_program(C.hard_drive.find_file_by_name(href_list["switch_prog"]))
		return 1
	if(href_list["connect"])
		C.attempt_connect(usr)
		return 1
	if(href_list["config_name"])
		C.matrix_name = input(usr, "Input a new matrix name.","Matrix name","") as text|null
		return 1
	if(href_list["config_icon"]) //I'm not actually sure how to check for 32x32, but I highly doubt anyone on my server would attempt it
		to_chat(usr, "Please input a .dmi file with only one icon that's 32x32")
		var/I = input(usr, "Upload a matrix icon.","Matrix icon") as icon|null
		if(!isicon(I))
			return 1
		C.matrix_icon = I
		return 1

/mob/matrix
	var/obj/item/modular_computer/cyberdeck/cyberdeck
	var/matrix_stats[4]
	var/matrix_effects

/mob/matrix/proc/shatter()
//	flick('maps/wyrm/icons/matrix_shatter.dmi',src) //todo: image of triangles shattering

/mob/matrix/proc/get_matrix_effect(var/datum/matrix_effect/M)
	for(var/E in matrix_effects)
		if(istype(E,M))
			return E

/datum/matrix_effect/link_lock

/mob/matrix/player
		name = "Matrix Icon" //Get the name from the cyberdeck config
		desc = "A matrix persona representing an entity."

		var/mob/owner_mob

		var/forced_logoff = -1 //not the best place

/mob/matrix/player/Destroy()
	GLOB.matrix_mob_list -= src
	jack_out()
	shatter()
	..()

/mob/matrix/player/New(var/obj/item/modular_computer/cyberdeck/C, var/mob/owner)
	if(!istype(C))
		qdel(src)

	cyberdeck = C
	var/list/stats = C.matrix_stats
	for(var/i = 1; i<stats.len, i++)
		matrix_stats[i] = stats[i]

	if(owner)
		initialize_matrix(owner)
	..()

/mob/matrix/player/Life()
	..()

/mob/matrix/player/proc/initialize_matrix(var/mob/owner)
	owner_mob = owner
	ckey = owner.ckey
	owner.ckey = "@[ckey]"
	GLOB.matrix_mob_list += src

	if(!cyberdeck.matrix_name)
		name = owner_mob.name
	else
		name = cyberdeck.matrix_name

	if(cyberdeck.matrix_icon)
		icon = cyberdeck.matrix_icon
	else
		getHologramIcon()


/mob/matrix/player/proc/attempt_jack_out()
	if(forced_logoff)
		to_chat(src, "<span class = 'danger' Attempting emergency log off.</span>")
		jack_out(TRUE)

	if(!do_after(src,5 SECONDS))
		to_chat(src, "<span class = 'notice'Stand still during log off procedures.</span>")
		forced_logoff++
		return

	if(get_matrix_effect(/datum/matrix_effect/link_lock))
		to_chat(src, "<span class = 'danger'>WARNING: Link-Lock Detected, possible dangerous side effects may occur. Please re-activate within 5 seconds to confirm.</span>")
		forced_logoff = 1
		spawn(5 SECONDS)
			forced_logoff = -1
		return
	jack_out()

/mob/matrix/player/proc/jack_out(var/forced)
	if(!owner_mob)
		to_chat(src, "There's nothing to come back to. <span class = 'danger'You're here <b>forever.</b></span>")
		return
	if(forced)
		if(ishuman(owner_mob))
			var/mob/living/carbon/human/H = owner_mob
			H.AdjustStunned(10)
			H.AdjustWeakened(20)
	owner_mob.ckey = ckey
	qdel(src)

/mob/living/simple_animal/hostile/matrix/ice
	name = "\improper Intrusion Countermeasure"
	desc = "It's either your best friend or is about to kill you."
	wander = FALSE

	var/datum/matrix_node/N
	var/obj/item/modular_computer/cyberdeck/cyberdeck

//Just make these different projectiles
/mob/living/simple_animal/hostile/matrix/ice/grey

/mob/living/simple_animal/hostile/matrix/ice/black

/mob/living/simple_animal/hostile/matrix/ice/Initialize()
	var/area/A = get_area(src)
	N = A.node
	var/strength
	if(istype(N))
		N.init_ice(src)
		strength = N.security_rating * 2
	else
		strength = 1
	for(var/i = 1; i<4, i++)
		cyberdeck.matrix_stats[i] = strength
	. = ..()

/mob/living/simple_animal/hostile/matrix/ice/Destroy()
	N.ice_death(src)
	..()

//Determines number of response ICE

#define ALERT_INVESTIGATE 1 //Go see what's going on
#define ALERT_HOSTILE 2 //Shoot on sight
#define ALERT_EMERGENCY 3 //Extra security for the node

//Areas are essentially nodes for the matrix

/area
	var/datum/matrix_node/node //A sort of "does this have connectivity"

/datum/matrix_node
	var/name = "Matrix Node"
	var/security_rating = LOW_SEC
	var/matrix_alert

	var/list/ice_spawns
	var/ice_list
	var/dead_ice

	var/list/ice_classes
	var/next_ice_class

/datum/matrix_node/New()
	..()
	ice_classes = list(/obj/item/modular_computer/cyberdeck/attack,/obj/item/modular_computer/cyberdeck/attack, \
										/obj/item/modular_computer/cyberdeck/defense,/obj/item/modular_computer/cyberdeck/support)

/datum/matrix_node/med
	security_rating = MED_SEC

/datum/matrix_node/high
	security_rating = HIGH_SEC

/datum/matrix_node/proc/init_ice(var/mob/living/simple_animal/hostile/matrix/ice/I)
	ice_list += I
	I.cyberdeck = new ice_classes[next_ice_class](src) //I'm not even sure
	next_ice_class++
	if(next_ice_class >= ice_classes.len)
		next_ice_class = 1

/datum/matrix_node/proc/ice_death(var/mob/living/simple_animal/hostile/matrix/ice/I)
	ice_list -= I
	dead_ice++
	death_response(get_turf(I), determine_alert_response())

/datum/matrix_node/proc/determine_alert_response()
	return (round(dead_ice*security_rating/2,1))

/datum/matrix_node/proc/death_response(var/turf/T, var/response_level)
	var/list/aval_ice = ice_list
	if(aval_ice.len >= 2)
		matrix_lockdown()
	for(var/i=1;i<response_level,i++)
		var/mob/living/simple_animal/hostile/matrix/ice/I = pick(aval_ice)
		I.Goto(T)
		aval_ice -= I

/datum/matrix_node/proc/matrix_lockdown()
	matrix_alert = ALERT_EMERGENCY

	for(var/obj/structure/matrix/datastore/D in SSmatrix.datastores)
		D.lockdown()

	var/mob/living/simple_animal/hostile/matrix/ice/response_team
	switch(security_rating)
		if(MED_SEC)
			response_team = /mob/living/simple_animal/hostile/matrix/ice/grey
		if(HIGH_SEC)
			response_team = /mob/living/simple_animal/hostile/matrix/ice/black

	for(var/obj/ice_spawn in ice_spawns)
		new response_team(get_turf(ice_spawn))

/datum/computer_file/matrix_software
	var/stat_type = MTRX_PROC //Remember to change this per software

//Just for testing really
/datum/computer_file/matrix_software/junk/New()
	..()
	filename = "[pick("financial report","mineral data scan","soil fertility page","401k record","administrative morality report","corporate employee satisfaction estimate")]  #[rand(1,999)]"

/obj/structure/matrix/portal

/obj/structure/matrix/datastore
	name = "data storage"
	icon_state = "datastore"

	var/locked

/obj/structure/matrix/datastore/Initialize()
	. = ..()
	SSmatrix.datastores += src

/obj/structure/matrix/datastore/proc/lockdown()
	locked = TRUE
