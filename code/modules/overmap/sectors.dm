GLOBAL_LIST_EMPTY(known_overmap_sectors)
//===================================================================================
//Overmap object representing zlevel(s)
//===================================================================================
/obj/overmap/visitable
	name = "map object"
	scannable = TRUE

	var/list/map_z = list()

	var/list/initial_generic_waypoints //store landmark_tag of landmarks that should be added to the actual lists below on init.
	var/list/initial_restricted_waypoints //For use with non-automatic landmarks (automatic ones add themselves).

	var/list/generic_waypoints = list()    //waypoints that any shuttle can use
	var/list/restricted_waypoints = list() //waypoints for specific shuttles
	var/docking_codes

	var/start_x			//Coordinates for self placing
	var/start_y			//will use random values if unset

	var/sector_flags = OVERMAP_SECTOR_IN_SPACE

	var/hide_from_reports = FALSE

	var/randomize_location = TRUE

	/// null | num | list. If a num or a (num, num) list, the radius or random bounds for placing this sector near the main map's overmap icon.
	var/list/place_near_main

	var/blob_count = 0
	var/hidden = FALSE //hidden for the purposes of tooltips. currently only used for the pirate station to avoid cheese
	var/list/assigned_contracts = list() //what contracts do we assign on spawning. can be any /datum/contract

	// Gas mixture datum returned to exterior return_air. Set to assoc list of material to moles to initialize the gas datum.
	//This will be returned in case external turfs are associated with this overmap object
	var/datum/gas_mixture/exterior_atmosphere

/obj/overmap/visitable/Initialize()
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return

	setup_exterior_atmosphere() //Planets do their own thing, but set exterior atmos to a valid value here first. (empty is valid)

	find_z_levels()     // This populates map_z and assigns z levels to the ship.
	register_z_levels() // This makes external calls to update global z level information.

	if(!GLOB.using_map.overmap_z)
		build_overmap()

	if (randomize_location)
		var/map_low = OVERMAP_EDGE
		var/map_high = GLOB.using_map.overmap_size - OVERMAP_EDGE
		var/turf/home
		if (place_near_main)
			var/obj/overmap/visitable/main = map_sectors["1"]
			if (islist(place_near_main))
				place_near_main = Roundm(Frand(place_near_main[1], place_near_main[2]), 0.1)
			home = CircularRandomTurfAround(main, abs(place_near_main), map_low, map_low, map_high, map_high)
			log_debug("place_near_main moving [src] near [main] ([main.x],[main.y]) with radius [place_near_main], got ([home.x],[home.y])")
		else
			start_x = start_x || rand(map_low, map_high)
			start_y = start_y || rand(map_low, map_high)
			home = locate(start_x, start_y, GLOB.using_map.overmap_z)
		forceMove(home)

		for(var/obj/overmap/event/E in loc)
			qdel(E)

	if(HAS_FLAGS(sector_flags, OVERMAP_SECTOR_KNOWN))
		LAZYADD(GLOB.known_overmap_sectors, src)
		layer = ABOVE_LIGHTING_LAYER
		plane = EFFECTS_ABOVE_LIGHTING_PLANE
		for(var/obj/machinery/computer/ship/helm/H as anything in GLOB.overmap_helm_computers)
			H.add_known_sector(src)

	docking_codes = "[ascii2text(rand(65,90))][ascii2text(rand(65,90))][ascii2text(rand(65,90))][ascii2text(rand(65,90))]"

	testing("Located sector \"[name]\" at [start_x],[start_y], containing Z [english_list(map_z)]")

	LAZYADD(SSshuttle.sectors_to_initialize, src) //Queued for further init. Will populate the waypoint lists; waypoints not spawned yet will be added in as they spawn.
	SSshuttle.clear_init_queue()

	if(length(assigned_contracts) && GLOB.using_map.using_new_cargo)
		generate_away_contracts()


/obj/overmap/visitable/Destroy()
	LAZYREMOVE(GLOB.known_overmap_sectors, src)
	. = ..()

//This is called later in the init order by SSshuttle to populate sector objects. Importantly for subtypes, shuttles will be created by then.
/obj/overmap/visitable/proc/populate_sector_objects()

/obj/overmap/visitable/proc/get_areas()
	return get_filtered_areas(list(
		GLOBAL_PROC_REF(area_belongs_to_zlevels) = map_z
	))

/obj/overmap/visitable/MouseEntered(location, control, params)
	if(!hidden)
		openToolTip(user = usr, tip_src = src, params = params, title = name)
	..()

/obj/overmap/visitable/proc/find_z_levels()
	map_z = GetConnectedZlevels(z)

/obj/overmap/visitable/proc/register_z_levels()
	for(var/zlevel in map_z)
		map_sectors["[zlevel]"] = src

	GLOB.using_map.player_levels |= map_z
	if(!HAS_FLAGS(sector_flags, OVERMAP_SECTOR_IN_SPACE))
		GLOB.using_map.sealed_levels |= map_z
	if(HAS_FLAGS(sector_flags, OVERMAP_SECTOR_BASE))
		GLOB.using_map.station_levels |= map_z
		GLOB.using_map.contact_levels |= map_z
		GLOB.using_map.map_levels |= map_z

//Helper for init.
/obj/overmap/visitable/proc/check_ownership(obj/object)
	if((object.z in map_z) && !(get_area(object) in SSshuttle.shuttle_areas))
		return 1

/**
 * Flags the effect as `known` and runs relevant update procs. Intended for admin event usage.
 */
/obj/overmap/visitable/proc/make_known(notify = FALSE)
	if (!HAS_FLAGS(sector_flags, OVERMAP_SECTOR_KNOWN))
		sector_flags = OVERMAP_SECTOR_KNOWN
		update_known_connections(notify)

//If shuttle_name is false, will add to generic waypoints; otherwise will add to restricted. Does not do checks.
/obj/overmap/visitable/proc/add_landmark(obj/shuttle_landmark/landmark, shuttle_name)
	landmark.sector_set(src, shuttle_name)
	if(shuttle_name)
		LAZYADD(restricted_waypoints[shuttle_name], landmark)
	else
		generic_waypoints += landmark

/obj/overmap/visitable/proc/remove_landmark(obj/shuttle_landmark/landmark, shuttle_name)
	if(shuttle_name)
		var/list/shuttles = restricted_waypoints[shuttle_name]
		LAZYREMOVE(shuttles, landmark)
	else
		generic_waypoints -= landmark

/obj/overmap/visitable/proc/get_waypoints(shuttle_name)
	. = list()
	for(var/obj/overmap/visitable/contained in src)
		. += contained.get_waypoints(shuttle_name)
	for(var/thing in generic_waypoints)
		.[thing] = name
	if(shuttle_name in restricted_waypoints)
		for(var/thing in restricted_waypoints[shuttle_name])
			.[thing] = name

/obj/overmap/visitable/proc/generate_skybox()
	return

/obj/overmap/visitable/proc/generate_away_contracts()
	for(var/C in assigned_contracts)
		if(ispath(C, /datum/contract))
			var/datum/contract/contract = new C
			GLOB.using_map.contracts += contract

/obj/overmap/visitable/MouseEntered(location, control, params)
	openToolTip(user = usr, tip_src = src, params = params, title = name)
	..()

/obj/overmap/visitable/MouseDown()
	closeToolTip(usr) //No reason not to, really
	..()

/obj/overmap/visitable/MouseExited()
	closeToolTip(usr) //No reason not to, really
	..()

/obj/overmap/visitable/sector
	name = "generic sector"
	desc = "Sector with some stuff in it."
	icon_state = "sector"
	requires_contact = TRUE
	anchored = TRUE

	var/is_planet = FALSE //are we a planet for the purposes of solar occlusion

	//used by exoplanets and awaymap planetoids
	var/surface_color = null
	var/water_color = null
	var/image/skybox_image

/obj/overmap/visitable/sector/Initialize()
	. = ..()
	if(HAS_FLAGS(sector_flags, OVERMAP_SECTOR_KNOWN))
		for(var/obj/machinery/computer/ship/helm/H as anything in GLOB.overmap_helm_computers)
			update_known_connections(TRUE)


/obj/overmap/visitable/sector/update_known_connections(notify = FALSE)
	. = ..()

	for(var/obj/machinery/computer/ship/helm/H in SSmachines.machinery)
		H.add_known_sector(src, notify)


// Because of the way these are spawned, they will potentially have their invisibility adjusted by the turfs they are mapped on
// prior to being moved to the overmap. This blocks that. Use set_invisibility to adjust invisibility as needed instead.
/obj/overmap/visitable/sector/hide()

/obj/overmap/visitable/sector/proc/generate_planet_image()
	return

/proc/build_overmap()
	if(!GLOB.using_map.use_overmap)
		return 1

	testing("Building overmap...")
	INCREMENT_WORLD_Z_SIZE
	GLOB.using_map.overmap_z = world.maxz

	testing("Putting overmap on [GLOB.using_map.overmap_z]")
	var/area/overmap/A = new
	for (var/square in block(locate(1,1,GLOB.using_map.overmap_z), locate(GLOB.using_map.overmap_size,GLOB.using_map.overmap_size,GLOB.using_map.overmap_z)))
		var/turf/T = square
		if(T.x == 1 || T.y == 1 || T.x == GLOB.using_map.overmap_size || T.y == GLOB.using_map.overmap_size)
			T = T.ChangeTurf(/turf/unsimulated/map/edge)
		else
			T = T.ChangeTurf(/turf/unsimulated/map)
		ChangeArea(T, A)

	GLOB.using_map.sealed_levels |= GLOB.using_map.overmap_z

	testing("Overmap build complete.")
	return 1

/obj/overmap/visitable/proc/setup_exterior_atmosphere()
	//Skip setup if we've been set to a ref already
	if(istype(exterior_atmosphere))
		exterior_atmosphere.update_values() //Might as well update
		exterior_atmosphere.check_tile_graphic()
		return
	var/list/exterior_atmos_composition = exterior_atmosphere
	exterior_atmosphere = new
	if(islist(exterior_atmos_composition))
		for(var/gas in exterior_atmos_composition)
			exterior_atmosphere.adjust_gas(gas, exterior_atmos_composition[gas], FALSE)
		//revisit
		//exterior_atmosphere.temperature = exterior_atmos_temp
		exterior_atmosphere.update_values()
		exterior_atmosphere.check_tile_graphic()

/obj/overmap/visitable/proc/get_exterior_atmosphere()
	if(exterior_atmosphere && !istype(exterior_atmosphere))
		CRASH("Attempting to retrieve exterior atmosphere before it is set up!")
	//copy gas over and return, in practice external atmos is an infinite source
	var/datum/gas_mixture/gas = new
	gas.copy_from(exterior_atmosphere)
	return gas
