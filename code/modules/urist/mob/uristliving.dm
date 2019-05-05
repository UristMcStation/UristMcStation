//vg color-matrix code
GLOBAL_LIST_EMPTY(bad_changing_color_ckeys)
GLOBAL_LIST_INIT(mutation_color_matrices, list("[M_NOIR]"=COLMX_EXPRESSIONIST))


/mob/proc/get_screen_color()
	if(!client)
		return null

	var/datum/array/colormx = null
	if(mutations)
		for(var/mut in GLOB.mutation_color_matrices)
			// For now, the mapping list is expected to be
			//     much shorter than the mutations list.
			// If it grows, might be worth to switch over to
			//     looping over mutations instead.
			if(text2num(mut) in mutations)
				var/definition = GLOB.mutation_color_matrices[mut]

				if(definition)
					colormx = new /datum/array(definition)
					if(colormx)
						// let's go with the first available matrix for now
						// feel free to mess with dot products in the future
						break
	// Fallback cascade
	colormx = (colormx || client.cached_colormatrix || DEFAULT_COLOR_MATRIX)
	return colormx


/mob/dead/observer/get_screen_color()
	return DEFAULT_COLOR_MATRIX


/mob/living/simple_animal/get_screen_color()
	. = ..()
	if(.)
		return .
	return DEFAULT_COLOR_MATRIX


/mob/living/carbon/human/get_screen_color()
	. = ..()
	if(.)
		return .

	var/datum/array/CM = .
	// LEFT IN TO REIMPLEMENT LATER:
	//var/datum/organ/internal/eyes/eyes = internal_organs_by_name["eyes"]
	//if(eyes && eyes.colormatrix && !(eyes.robotic))
	//	return eyes.colormatrix
	//else return
	return CM


/client/proc/_update_client_color_callback(var/list/color_to_apply)
	if(!src || !color_to_apply)
		return

	if(src && src.mob != src)
		if(src)
			var/list/difference = difflist(src.color,color_to_apply)
			src.color = color_to_apply
			src.updating_color = 0
			if((difference || !(src.color) || !istype(difference) || !difference.len)) // panic panic panic
				src.mob.update_color(forceupdate = 1)
		else
			GLOB.bad_changing_color_ckeys["[src.ckey]"] = 1


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
		if(forceupdate)
			time = 0
		else
			time = 170
		client.cached_colormatrix = colormatrix
		client.color_transition(colormatrix, time = time)
		addtimer(CALLBACK(client, /client/proc/_update_client_color_callback, color_to_apply), time, TIMER_UNIQUE)


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

