//vg color-matrix code
GLOBAL_LIST_EMPTY(bad_changing_color_ckeys)
GLOBAL_LIST_AS(mutation_color_matrices, list("[M_NOIR]"=COLMX_EXPRESSIONIST))


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
	return client.holder ? client.cached_colormatrix : DEFAULT_COLOR_MATRIX //Simple aghost support


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


/client/proc/_update_client_color_callback(list/color_to_apply)
	if(!src || !color_to_apply)
		return

	if(src && src.mob != src)
		if(src)
			var/list/difference = difflist(cached_colormatrix.get(), color_to_apply)
			src.color = color_to_apply
			src.updating_color = 0
			if((!istype(difference) || length(difference) > 0)) // panic panic panic
				src.mob.update_color(forceupdate = 1)
		else
			GLOB.bad_changing_color_ckeys["[src.ckey]"] = 1


/mob/proc/update_color(time = 50,var/forceupdate = 0)
	if(!client || (client.updating_color && !forceupdate))
		return

	var/datum/array/colormatrix = get_screen_color()

	var/list/color_to_apply = colormatrix?.get()
	if(!client.cached_colormatrix)
		client.cached_colormatrix = DEFAULT_COLOR_MATRIX

	var/list/difference = null
	if(client.cached_colormatrix && color_to_apply)
		difference = difflist(client.cached_colormatrix.get(), color_to_apply)

	if(isnull(client.cached_colormatrix) || (istype(difference) && length(difference) > 0))
		client.updating_color = 1
		if(forceupdate)
			time = 0
		else
			time = 170
		client.cached_colormatrix = colormatrix
		client.color_transition(colormatrix, time = time)
		addtimer(new Callback(client, /client/proc/_update_client_color_callback, color_to_apply), time, TIMER_UNIQUE)
