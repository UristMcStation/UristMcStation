/datum/cover
	/* Holds component data about cover-ness
	// e.g. simple is-cover, direction of cover, etc.
	*/
	var/is_active = TRUE
	var/cover_dir = null
	var/cover_all = TRUE


/datum/cover/New(var/active, var/all_dirs = null, var/only_dirs = null)
	is_active = (isnull(active) ? is_active : active)
	cover_dir = (isnull(all_dirs) ? cover_dir : all_dirs)
	cover_all = (isnull(only_dirs) ? cover_all : only_dirs)


/datum/cover/proc/CoversInDir(var/dir, var/default = FALSE)
	if(!is_active)
		return FALSE

	if(cover_all)
		return TRUE

	if(dir && cover_dir && (cover_dir & dir))
		return TRUE

	return FALSE