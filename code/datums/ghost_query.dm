// This is a generic datum used to ask ghosts if they wish to be a specific role, such as a Promethean, an Apprentice, a Xeno, etc.
// Simply instantiate the correct subtype of this datum, call query(), and it will return a list of ghost candidates after a delay.
/datum/ghost_query
	var/list/candidates = list()
	var/finished = FALSE
	var/role_name = "a thing"
	var/question = "Would you like to play as a thing?"
	var/be_special_flag = 0
	var/list/check_bans = list()
	var/wait_time = 60 SECONDS 	// How long to wait until returning the list of candidates.
	var/cutoff_number = 0		// If above 0, when candidates list reaches this number, further potential candidates are rejected.

/datum/ghost_query/proc/query()
	// First, ask all the ghosts who want to be asked.
	for(var/mob/observer/ghost/D in GLOB.player_list)
		if(!D.MayRespawn())
			continue // They can't respawn for whatever reason.
		if(D.client)
			for(var/ban in check_bans)
				if(jobban_isbanned(D, ban))
					continue // They're banned from this role.
			ask_question(D.client)
	// Then wait awhile.
	while(!finished)
		sleep(1 SECOND)
		wait_time -= 1 SECOND
		if(wait_time <= 0)
			finished = TRUE

	// Prune the list after the wait, incase any candidates logged out.
	for(var/mob/observer/ghost/D in candidates)
		if(!D.client || !D.key)
			candidates.Remove(D)

	// Now we're done.
	finished = TRUE
	return candidates

/datum/ghost_query/proc/ask_question(var/client/C)
	spawn(0)
		if(!C)
			return
		var/response = alert(C, question, "[role_name] request", "Yes", "No")
		if(response == "Yes")
			response = alert(C, "Are you sure you want to play as a [role_name]?", "[role_name] request", "Yes", "No") // Protection from a misclick.
		if(!C || !src)
			return
		if(response == "Yes")
			if(finished || (cutoff_number && candidates.len >= cutoff_number) )
				to_chat(C, "<span class='warning'>Unfortunately, you were not fast enough, and there are no more available roles.  Sorry.</span>")
				return
			candidates.Add(C.mob)
			if(cutoff_number && candidates.len >= cutoff_number)
				finished = TRUE // Finish now if we're full.

//Blob

/datum/ghost_query/blob
	role_name = "Blob"
	question = "A rapidly expanding Blob has just appeared on the facility.  Would you like to play as it?"
	cutoff_number = 1
	wait_time = 10 SECONDS
