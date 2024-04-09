#ifdef ENABLE_FOV_CODE

/mob/proc/update_vision_cone()
	set waitfor = FALSE
	return

/mob/proc/BuildFovHud()
	return

/mob/living/carbon/human/BuildFovHud()
	var/list/hud_elements = list()

	src.fov = new /obj/screen()
	src.fov.icon = 'icons/urist/fov/hide.dmi'
	src.fov.icon_state = "combat"
	src.fov.name = "fov"
	src.fov.screen_loc = "LEFT+50%,BOTTOM+50%"
	src.fov.mouse_opacity = 0
	src.fov.plane = VISION_CONE_PLANE
	hud_elements |= src.fov

	src.fov_mask = new /obj/screen()
	src.fov_mask.icon = 'icons/urist/fov/hide.dmi'
	src.fov_mask.icon_state = "combat_mask"
	src.fov_mask.name = "fov_mask"
	src.fov_mask.screen_loc = "LEFT+50%,BOTTOM+50%"
	src.fov_mask.mouse_opacity = 0
	src.fov_mask.plane = HIDDEN_SHIT_PLANE
	hud_elements |= src.fov_mask

	src.client.screen += hud_elements
	return TRUE


/mob/living/carbon/human/update_vision_cone()
	set waitfor = FALSE

	if((src.force_fov == FALSE) || !(config.enable_fov_cones || src.force_fov))
		src.hide_cone(change_usefov = FALSE)
		return

	if(!client)
		return

	check_fov()
	fov.dir = dir
	fov_mask.dir = dir
	/*
	// Nebulacode retained for reference if we get this pref:
	if(!client.prefs) // Needed to get the selected icon size
		return
	var/matrix/scaling_matrix = new()
	scaling_matrix.Scale(client.prefs.icon_size/32, client.prefs.icon_size/32)
	fov.transform = scaling_matrix
	fov_mask.transform = scaling_matrix
	*/

/mob/living/carbon/human/reload_fullscreen()
	if(src.force_fov || config.enable_fov_cones || src.fov || src.fov_mask)
		// the latter two checks are there so we can remove the FoV stuff on disable
		update_vision_cone()
	return ..()

/mob/living/carbon/human/proc/SetFov(var/show)
	if(!show)
		src.hide_cone()
	else
		src.show_cone()

/mob/living/carbon/human/proc/check_fov()
	if(!src.client)
		return

	if((src.force_fov == FALSE) || !(config.enable_fov_cones || src.force_fov))
		src.hide_cone()
		return

	if(isnull(src.fov) || isnull(src.fov_mask))
		src.BuildFovHud()

	if(resting || lying || (client && client.eye != client.mob))
		src.fov.alpha = 0
		src.fov_mask.alpha = 0
		return

	else if(src.usefov)
		src.show_cone()

	else
		src.hide_cone()

//Making these generic procs so you can call them anywhere.
/mob/living/carbon/human/proc/show_cone(var/change_usefov = TRUE)
	if(src.fov)
		src.fov.alpha = 255

	if(src.fov_mask)
		src.fov_mask.alpha = 255

	if(change_usefov)
		src.usefov = TRUE

/mob/living/carbon/human/proc/hide_cone(var/change_usefov = TRUE)
	if(src.fov)
		src.fov.alpha = 0

	if(src.fov_mask)
		src.fov_mask.alpha = 0

	if(change_usefov)
		src.usefov = FALSE

#endif
