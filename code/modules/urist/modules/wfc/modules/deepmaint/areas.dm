// Index of deepmaint z-levels, for faster queries
GLOBAL_LIST_EMPTY(wfc_deepmaint_zlevels_by_instance)


// don't use this directly, it's meant as an abstract base
// we need the subtypes to distinguish between layers
/area/map_template/deepmaint_wfc
	name = "\improper Deep Maintenance"
	sound_env = TUNNEL_ENCLOSED
	//turf_initializer = /singleton/turf_initializer/maintenance
	// ambience = list('sound/ambience/occ_scaryambie.ogg')
	forced_ambience = list('sound/ambience/maintambience.ogg')
	requires_power = FALSE


/area/map_template/deepmaint_wfc/proc/RegisterDeepmaintZlevel(delay = 10)
	set waitfor = FALSE
	sleep(delay)

	// Register a new Deepmaint z-level if necessary
	// TODO: this will currently overwrite on duplicates; might want to use sub-lists as values instead
	GLOB.wfc_deepmaint_zlevels_by_instance[src] = src.z
	return


/area/map_template/deepmaint_wfc/New(atom/loc)
	. = ..(loc)

	RegisterDeepmaintZlevel()
	return


// These represent the (linked) variants
// The assignment is mostly arbitrary
/area/map_template/deepmaint_wfc/alpha
/area/map_template/deepmaint_wfc/beta
/area/map_template/deepmaint_wfc/gamma
/area/map_template/deepmaint_wfc/delta
