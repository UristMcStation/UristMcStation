/mob/proc/jumpTo(location)
	forceMove(location)

/mob/observer/ghost/jumpTo()
	stop_following()
	..()

/client/proc/Jump(selected_area in area_repository.get_areas_by_z_level())
	set name = "Jump to Area"
	set desc = "Area to jump to"
	set category = "Admin"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	if(!config.allow_admin_jump)
		return alert("Admin jumping disabled")

	var/list/areas = area_repository.get_areas_by_z_level()
	var/area/A = areas[selected_area]
	mob.jumpTo(pick(get_area_turfs(A)))
	log_and_message_admins("jumped to [A]")

/client/proc/jumptoturf(turf/T)
	set name = "Jump to Turf"
	set category = "Admin"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	if(!config.allow_admin_jump)
		return alert("Admin jumping disabled")

	log_and_message_admins("jumped to [T.x],[T.y],[T.z] in [T.loc]")
	mob.jumpTo(T)

/client/proc/jumptomob(mob/M in SSmobs.mob_list)
	set popup_menu = FALSE
	set category = "Admin"
	set name = "Jump to Mob"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG|R_MENTOR))
		return

	if(config.allow_admin_jump)
		log_and_message_admins("jumped to [key_name(M)]")
		if(mob)
			var/turf/T = get_turf(M)
			if(T && isturf(T))
				mob.jumpTo(T)
			else
				to_chat(mob, "This mob is not located in the game world.")
	else
		alert("Admin jumping disabled")

/client/proc/jumptocoord(tx as num, ty as num, tz as num)
	set category = "Admin"
	set name = "Jump to Coordinate"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(!config.allow_admin_jump)
		alert("Admin jumping disabled")
		return
	if(!mob)
		return

	var/turf/T = locate(tx, ty, tz)
	if(!T)
		return
	mob.jumpTo(T)
	log_and_message_admins("jumped to coordinates [tx], [ty], [tz]")

/proc/sorted_client_keys()
	RETURN_TYPE(/list)
	return sortKey(GLOB.clients.Copy())

/client/proc/jumptokey(client/C in sorted_client_keys())
	set category = "Admin"
	set name = "Jump to Key"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG|R_MENTOR))
		return

	if(config.allow_admin_jump)
		if(!istype(C))
			to_chat(usr, "[C] is not a client, somehow.")
			return

		var/mob/M = C.mob
		log_and_message_admins("jumped to [key_name(M)]")
		mob.jumpTo(get_turf(M))
	else
		alert("Admin jumping disabled")

/client/proc/Getmob(mob/M in SSmobs.mob_list)
	set popup_menu = FALSE
	set category = "Admin"
	set name = "Get Mob"
	set desc = "Mob to teleport"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	if(config.allow_admin_jump)
		log_and_message_admins("teleported [key_name(M)] to self.")
		M.jumpTo(get_turf(mob))
	else
		alert("Admin jumping disabled")

/client/proc/Getkey()
	set category = "Admin"
	set name = "Get Key"
	set desc = "Key to teleport"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(config.allow_admin_jump)
		var/list/keys = list()
		for(var/mob/M in GLOB.player_list)
			keys += M.client
		var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in sortKey(keys)
		if(!selection)
			return
		var/mob/M = selection:mob

		if(!M)
			return
		log_and_message_admins("teleported [key_name(M)] to self.")
		if(M)
			M.jumpTo(get_turf(mob))
	else
		alert("Admin jumping disabled")
