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