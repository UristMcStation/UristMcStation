#define MTRX_ATK 1
#define MTRX_SLZ 2
#define MTRX_PROC 3
#define MTRX_FRW 4

/obj/item/modular_computer/cyberdeck
	name = "cyberdeck"
	desc = "A portable computer used to access the matrix."
	icon = 'icons/obj/modular_cyberdeck.dmi'
	icon_state = "cyberdeck"
	icon_state_unpowered = "cyberdeck-dead"
	icon_state_menu = "menu"
	max_hardware_size = 3
	w_class = ITEM_SIZE_LARGE
	light_strength = 2
	slot_flags = SLOT_BACK

	var/matrix_stats[4]

//config settings
	var/matrix_name
	var/matrix_icon = "person"

/obj/item/modular_computer/cyberdeck/try_install_component(var/mob/living/user, var/obj/item/weapon/computer_hardware/H, var/found = 0)
	if(!..())	return
	if(!H.matrix_stat)	return

	matrix_stats[H.matrix_stat] = H.origin_tech[TECH_DATA]

/mob/matrix
	var/obj/item/device/cyberdeck/cyberdeck
	var/matrix_stats[4]
	var/matrix_effects

/mob/matrix/proc/shatter()
	flick('maps/wyrm/icons/matrix_shatter.dmi',src)
	qdel(src)

/mob/matrix/proc/get_matrix_effect(var/datum/matrix_effect/M)
	for(M in matrix_effects)
		return M

/datum/matrix_effect/link_lock

/mob/matrix/player
		name = "Matrix Icon" //Get the name from the cyberdeck config
		desc = "A matrix persona representing an enitity."

		var/mob/owner_mob

		var/forced_logoff = -1 //not the best place

/mob/matrix/player/Destroy()
	jack_out()
	shatter()
	..()

/mob/matrix/player/New(var/obj/item/device/cyberdeck/C, var/mob/owner)
	if(!istype(C))
		qdel(src)

	cyberdeck = C
	var/stats = C.matrix_stats
	for(var/i=1;i<stats.len,i++)
		matrix_stats[i] = stats[i]

	if(owner)
		initialize_matrix(owner)
	. = ..()

/mob/matrix/player/proc/initialize_matrix(var/mob/owner)
	owner_mob = owner
	ckey = owner.ckey
	GLOB.matrix_mob_list += src
	if(!C.matrix_name)
		name = owner_mob.name
	else
		name = C.matrix_name

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
			H.adjustStunned(10)
			H.adjustWeakened(20)
	owner_mob.ckey = ckey
	shatter()

/mob/living/simple_animal/matrix/ice
	name = "\improper Intrusion Countermeasure"
	desc = "It's either your best friend or is about to kill you."

	var/area/matrix/matrix_node

/mob/matrix/ice/Initialize()
	var/turf/T = get_turf(src)
	var/area/A = T.loc
	if(istype(A, /area/matrix))
		matrix_node = A
		matrix_node.init_ice(src)
		for(var/i=1;i<4,i++)
			matrix_stats[i] = matrix_node.security_rating * 2
	. = ..()

/mob/living/simple_animal/matrix/ice/Destroy()
	matrix_node.ice_death(src)
	..()

//Determines number of response ICE

#define ALERT_INVESTIGATE 1 //Go see what's going on
#define ALERT_HOSTILE 2 //Shoot on sight
#define ALERT_EMERGENCY 3 //Extra security for the node

//Areas are essentially nodes for the matrix
/area/matrix
	var/security_rating = LOW_SEC
	var/matrix_alert

	var/ice_list
	var/dead_ice

	var/list/ice_classes
	var/next_ice_class

/area/matrix/Initialize()
	. = ..()
	ice_classes = list(/obj/item/device/cyberdeck/attack,/obj/item/device/cyberdeck/attack,/obj/item/device/cyberdeck/defense,/obj/item/device/cyberdeck/support)

/area/matrix/med
	security_rating = MED_SEC

/area/matrix/high
	security_rating = HIGH_SEC

/area/matrix/proc/init_ice(var/mob/living/simple_animal/matrix/ice/I)
	ice_list += I
	I.cyberdeck = new ice_classes[next_ice_class]()
	I.cyberdeck.forceMove(I) //byond complains about this otherwise
	next_ice_class++
	if(next_ice_class >= ice_classes.len)
		next_ice_class = 1

/area/matrix/proc/ice_death(var/mob/living/simple_animal/matrix/ice/I)
	ice_list -= I
	dead_ice++
	death_response(get_turf(I), determine_alert_response())

/area/matrix/proc/determine_alert_response()
	return (round(dead_ice*security_rating/2,1))

/area/matrix/proc/death_response(var/turf/T, var/response_level)
	var/list/aval_ice = ice_list
	if(aval_ice.len >= 2)
		matrix_lockdown()
	for(var/i=1;i<response_level,i++)
		var/mob/matrix/ice/I = pick(aval_ice)
		I.investigate(T)
		aval_ice -= I

/area/matrix/proc/matrix_lockdown()
	matrix_alert = ALERT_EMERGENCY

	for(var/obj/structure/matrix/datastore/D in datastores)
		D.lockdown()

	var/mob/matrix/ice/response_team
	switch(security_rating)
		if(MED_SEC)
			response_team = /mob/matrix/ice/grey
		if(HIGH_SEC)
			response_team = /mob/matrix/ice/black

	for(var/obj/ice_spawn in ice_spawns)
		new response_team(get_turf(ice_spawn))
	for(var/mob/matrix/ice/I in ice_list)

/datum/matrix_software
	var/stat_type = MTRX_PROC //Remember to change this per software
	var/disk_size = 10

/datum/matrix_software/proc/activate()
	return

/datum/matrix_software/processing/activate()
	GLOB.processing_software |= src

/datum/matrix_software/processing/proc/process()
	return
