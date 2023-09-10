/turf/deepmaint/plating
	name = "floor"
	parent_type = DEEPMAINT_TURF_BASE

	icon = DEEPMAINT_FLOOR_ICON
	icon_state = DEEPMAINT_FLOOR_ICONSTATE

	wfc_overwritable = TRUE

	// Probability of a teleporter to another variant
	var/wfc_teleproba_deepmaint = 0

	// Probability of a teleporter back to station
	var/wfc_teleproba_station = 0

	// Switches to enable spawning additional tile objects
	var/wfc_spawn_door = FALSE
	var/wfc_spawn_lights = FALSE


/turf/deepmaint/plating/New(var/atom/loc)
	..(loc)

	if(isnull(associated_wfc_overwritables))
		associated_wfc_overwritables = list()

	if(!isnull(src.wfc_teleproba_deepmaint) && prob(src.wfc_teleproba_deepmaint))
		var/obj/wfc_step_trigger/deepmaint_teleport/tele = new(src)
		associated_wfc_overwritables.Add(tele)

	if(!isnull(src.wfc_teleproba_station) && prob(src.wfc_teleproba_station))
		var/obj/wfc_step_trigger/deepmaint_exit/exit = new(src)
		associated_wfc_overwritables.Add(exit)

	if(src.wfc_spawn_door)
		DEEPMAINT_DOOR_TYPEVAR(DD) = new(loc)
		src.associated_wfc_overwritables.Add(DD)

	if(src.wfc_spawn_lights)
		var/light = new DEEPMAINT_LIGHT(src)
		associated_wfc_overwritables.Add(light)


/turf/deepmaint/plating/lights
	wfc_spawn_lights = TRUE


/turf/deepmaint/plating/ztele
	wfc_teleproba_deepmaint = 10


/turf/deepmaint/plating/door
	wfc_spawn_door = TRUE
	wfc_teleproba_deepmaint = 60
	wfc_teleproba_station = 10



/turf/deepmaint/wall
	name = "wall"
	parent_type = DEEPMAINT_TURF_BASE
	icon = DEEPMAINT_WALL_ICON
	icon_state = DEEPMAINT_WALL_ICONSTATE_BASE

	wfc_overwritable = TRUE

	density = TRUE
	opacity = DEEPMAINT_WALL_OPACITY


/turf/deepmaint/wall/proc/UpdateConnectionIcons()
	set waitfor = FALSE

	sleep(rand(5, 25))

	var/list/adjacents = src.CardinalTurfs(FALSE, FALSE, FALSE)
	var/dense_conn = 0

	for(var/turf/neigh in adjacents)
		if(neigh.density)
			dense_conn |= get_dir(src, neigh)

	src.icon_state = DEEPMAINT_WALL_ICONSTATE_DYNAMIC(dense_conn)


/turf/deepmaint/wall/New()
	. = ..()

	src.UpdateConnectionIcons()


/turf/deepmaint/wall/border
	// Special wall variant; does not regenerate w/ WFC.
	// Meant for the world edge.
	wfc_overwritable = FALSE


/turf/deepmaint/wall/probably
	// % chance of disappearing
	var/improbability = 10


/turf/deepmaint/wall/probably/New(var/atom/loc, var/improbability_override = null)
	var/wall_improba = (isnull(improbability_override) ? src.improbability : improbability_override)

	if(prob(wall_improba))
		spawn(0)
			WFC_CHANGE_TURF(src, /turf/deepmaint/plating)

	else
		. = ..(loc)
