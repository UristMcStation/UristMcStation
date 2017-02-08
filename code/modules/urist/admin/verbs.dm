/client/proc/warpallplayers()

	set name = "Warp All Players"
	set category = "Fun"
	set desc = "Warp all players to you."
	if(!check_rights(R_FUN))
		src <<"<span class='danger'> You do not have the required admin rights.</span>"
		return

	for(var/mob/living/M in player_list)
		M.loc = get_turf(usr)
		message_admins("[key_name(usr)] has warped all players to their location.")
		log_admin("[key_name(src)] has warped all players to their location.")

//Urist mass-callproc, call it by regular callproc. SUPER risky.
/client/proc/mass_callproc(var/atom/A, var/procpath, var/strict_typing = 1)
	set category = "Debug"
	set name = "ProcCall All"
	set background = 1


	if(!check_rights(R_DEBUG)) return
	if(config.debugparanoid && !check_rights(R_ADMIN)) return

	var/list/subargs = list()
	if(args.len >= 4)
		for(var/i = 4, i < args.len, i++)
			subargs += args[i]

	var/affecting_type = A.type
	for(var/atom/target in world.contents) //this will be really friggin slow, what did you expect
		if((strict_typing && (target.type == affecting_type)) || (!strict_typing && (istype(target, affecting_type))))
			if(hascall(target, procpath))
				log_admin("[key_name(src)] called [procpath]() on all [strict_typing ? "objects with type [target.type]" : "subtypes of [target.type]"] with [subargs.len ? "the arguments [list2params(subargs)]" : "no arguments"].")
				call(target, procpath)(arglist(subargs))