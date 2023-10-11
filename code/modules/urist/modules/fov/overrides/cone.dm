#ifdef ENABLE_FOV_CODE

/atom/proc/InCone(atom/center = usr, dir = NORTH)
	if(isnull(center) || isnull(dir))
		return FALSE

	if(get_dist(center, src) == 0 || src == center) return FALSE
	var/d = get_dir(center, src)

	if(!d || d == dir)
		return TRUE

	if(dir & (dir-1))
		return (d & ~dir) ? FALSE : TRUE

	if(!(d & dir))
		return FALSE

	var/dx = abs(x - center.x)
	var/dy = abs(y - center.y)

	if(dx == dy)
		return TRUE

	if(dy > dx)
		return (dir & (NORTH|SOUTH)) ? TRUE : FALSE

	return (dir & (EAST|WEST)) ? TRUE : FALSE

/mob/dead/InCone(mob/center = usr, dir = NORTH)
	return

/mob/living/InCone(mob/center = usr, dir = NORTH)
	. = ..()

	for(var/obj/item/grab/G in center)
		if(src == G.affecting)
			return FALSE
		else
			return .

/proc/mobs_in_cone(atom/center = usr, dir = NORTH, radius)
	. = list()
	for(var/mob/living/candidate_mob in oview(center, radius))
		if(candidate_mob.InCone(center, dir))
			. += candidate_mob

/proc/items_in_cone(atom/center = usr, dir = NORTH, radius)
	. = list()
	for(var/obj/item/candidate_item in oview(center, radius))
		if(candidate_item.InCone(center, dir))
			. += candidate_item

/proc/cone(atom/center = usr, dir = NORTH, list/list_to_filter = null)
	var/true_conelist = (isnull(list_to_filter) ? oview(center) : list_to_filter)
	for(var/atom/O in true_conelist)
		if(!O.InCone(center, dir))
			true_conelist -= O
	return true_conelist

/mob/living/carbon/human/update_vision_cone()
	set waitfor = FALSE

	if((src.force_fov == FALSE) || !(config.enable_fov_cones || src.force_fov))
		var/delay_cleanup = 10
		for(var/image/HI in src.client.hidden_atoms)
			sleep(0)
			HI.override = 0
			spawn(delay_cleanup)
				qdel(HI)
			delay_cleanup += 10

		src.hide_cone(change_usefov = FALSE)
		return

	if(!src.client) //Same as in module. Hate to look for this twice, but it's needed, short of mashing everything together.
		return

	. = ..()

	if(isnull(src.fov))
		src.BuildFovHud()

	if(src.usefov)
		src.show_cone(change_usefov = FALSE)

	var/delay = 10
	var/image/I = null

	if(isnull(src.client.hidden_atoms))
		src.client.hidden_atoms = list()

	if(isnull(src.client.hidden_mobs))
		src.client.hidden_mobs = list()

	for(I in src.client.hidden_atoms)
		sleep(0)
		I.override = 0
		spawn(delay)
			qdel(I)
		delay += 10

	src.client.hidden_atoms.Cut()
	src.client.hidden_mobs.Cut()
	src.fov.dir = src.dir

	if(fov.alpha != 0)

		for(var/mob/living/M as anything in mobs_in_cone(src, global.flip_dir[dir], 10))
			sleep(0)
			I = image("split", M)
			I.mouse_opacity = 0
			I.override = 1
			src.client.images += I
			src.client.hidden_atoms += I
			src.client.hidden_mobs += M
			if(LAZYISIN(M.grabbed_by, src))//If we're pulling them we don't want them to be invisible.
				I.override = 0

			M.in_vision_cones[src.client] = 1

		for(var/obj/item/O in items_in_cone(src, global.flip_dir[dir], 10))
			sleep(0)
			I = image("split", O)
			I.mouse_opacity = 0
			I.override = 1
			src.client.images += I
			src.client.hidden_atoms += I

#endif
