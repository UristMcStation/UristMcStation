//vg color-matrix code
/mob/proc/get_screen_colour()
	if(!client)
		return 0
	if(M_NOIR in mutations)
		return NOIRMATRIX

/mob/dead/observer/get_screen_colour()
	return default_colour_matrix

/mob/living/simple_animal/get_screen_colour()
	. = ..()
	if(.)
		return .
	else if(src.colourmatrix.len)
		return src.colourmatrix

/mob/living/carbon/human/get_screen_colour()
	. = ..()
	if(.)
		return .
	//var/datum/organ/internal/eyes/eyes = internal_organs_by_name["eyes"]
	//if(eyes && eyes.colourmatrix.len && !(eyes.robotic))
	//	return eyes.colourmatrix
	//else return
	return default_colour_matrix

/mob/proc/update_colour(var/time = 50,var/forceupdate = 0)
	if(!client || (client.updating_colour && !forceupdate))
		return
	var/list/colour_to_apply = get_screen_colour()
	var/list/difference = difflist(client.color,colour_to_apply)
	if(difference || !(client.color) || !istype(difference) || !difference.len)
		client.updating_colour = 1
		var/cached_ckey = client.ckey
		if(forceupdate)
			time = 0
		else if(colour_to_apply == NOIRMATRIX)
			time = 170
		client.colour_transition(colour_to_apply,time = time)
		spawn(time)
			if(client && client.mob != src)
				return
			if(client)
				client.color = colour_to_apply
				client.updating_colour = 0
				difference = difflist(client.color,get_screen_colour())
				if((difference || !(client.color) || !istype(difference) || !difference.len) && !forceupdate) // panic panic panic
					src.update_colour(forceupdate = 1)
			else
				bad_changing_colour_ckeys["[cached_ckey]"] = 1

/mob/proc/handle_urist_hooks()
	return

/mob/living/handle_urist_hooks()
	. = ..()
	update_colour()
	return .

/mob/living/Life()
	. = ..()
	handle_urist_hooks()
	return .
