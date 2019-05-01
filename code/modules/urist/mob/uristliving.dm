//vg color-matrix code
GLOBAL_LIST_EMPTY(bad_changing_color_ckeys)

/mob/proc/get_screen_color()
	if(!client)
		return 0
	if(M_NOIR in mutations)
		return new /datum/array/matrix_expressionist()

/mob/dead/observer/get_screen_color()
	return new DEFAULT_COLOR_MATRIX()

/mob/living/simple_animal/get_screen_color()
	. = ..()
	if(.)
		return .
	return new DEFAULT_COLOR_MATRIX()

/mob/living/carbon/human/get_screen_color()
	. = ..()
	if(.)
		return .
	//var/datum/organ/internal/eyes/eyes = internal_organs_by_name["eyes"]
	//if(eyes && eyes.colormatrix.len && !(eyes.robotic))
	//	return eyes.colormatrix
	//else return
	return new DEFAULT_COLOR_MATRIX()

/mob/proc/update_color(var/time = 50,var/forceupdate = 0)
	if(!client || (client.updating_color && !forceupdate))
		return

	var/datum/array/colormatrix = get_screen_color()
	if(!colormatrix)
		return

	var/list/color_to_apply = colormatrix.get()
	var/list/difference = difflist(client.color,color_to_apply)

	if(difference || !(client.color) || !istype(difference) || !difference.len)
		client.updating_color = 1
		var/cached_ckey = client.ckey
		if(forceupdate)
			time = 0
		else
			time = 170
		client.color_transition(color_to_apply,time = time)
		spawn(time)
			if(client && client.mob != src)
				return
			if(client)
				client.color = color_to_apply
				client.updating_color = 0
				difference = difflist(client.color,get_screen_color())
				if((difference || !(client.color) || !istype(difference) || !difference.len) && !forceupdate) // panic panic panic
					src.update_color(forceupdate = 1)
			else
				GLOB.bad_changing_color_ckeys["[cached_ckey]"] = 1

/mob/proc/handle_urist_hooks()
	return

/mob/living/handle_urist_hooks()
	. = ..()
	update_color()
	return .

/mob/living/Life()
	. = ..()
	handle_urist_hooks()
	return .
