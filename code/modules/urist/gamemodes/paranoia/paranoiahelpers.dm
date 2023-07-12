/proc/is_other_conspiracy(datum/mind/player,var/datum/antagonist/agent/conspiracy)
	var/paranoia_parent = /datum/antagonist/agent
	var/nonselfsum = 0 //how many other conspiracies the mind is a member of. Shouldn't come up, but better safe than sorry.
	var/own //belongs to the target faction
	for(var/antag_type in GLOB.all_antag_types_)
		var/datum/antagonist/antag = GLOB.all_antag_types_[antag_type]
		if(istype(antag,paranoia_parent))
			if(istype(antag, conspiracy))
				if(player in antag.current_antagonists)
					own = 1
				if(player in antag.pending_antagonists)
					own = 1
			else
				if(player in antag.current_antagonists)
					nonselfsum++
				if(player in antag.pending_antagonists)
					nonselfsum++
		else
			continue
	if(own)
		if(nonselfsum)
			return 0 //somehow belongs to the target and other conspiracies
		else
			return -1 //doesn't need converting
	return nonselfsum //number of conspiracy factions to strip

/proc/strip_all_other_conspiracies(datum/mind/player,var/datum/antagonist/agent/conspiracy)
	var/list/antaglist = GLOB.all_antag_types_
	var/paranoia_parent = /datum/antagonist/agent
	antaglist -= paranoia_parent //kinda hacky, but prevents weirdness
	for(var/antag_type in antaglist)
		var/datum/antagonist/antag = antaglist[antag_type]
		if(istype(antag,paranoia_parent))
			if(istype(antag, conspiracy))
				continue
			else
				if(player in antag.current_antagonists)
					antag.remove_antagonist(player)
		else
			continue

/mob/proc/get_mob_conspiracy(mob/M)

	var/datum/mind/player = M.mind
	if(!player)
		return

	var/list/antaglist = GLOB.all_antag_types_
	var/paranoia_parent = /datum/antagonist/agent
	var/conspiracy_number = 0 //test to prevent cases where someone belongs to more than one and it overwrites, which shouldn't happen
	var/mob_conspiracy
	antaglist -= paranoia_parent

	for(var/antag_type in antaglist)
		var/datum/antagonist/antag = antaglist[antag_type]
		if(istype(antag,paranoia_parent))
			if(player in antag.current_antagonists)
				conspiracy_number++
				mob_conspiracy = antag

	if(conspiracy_number == 0)
		return -1
	else if(conspiracy_number == 1)
		return mob_conspiracy
	return //this is an error state!
