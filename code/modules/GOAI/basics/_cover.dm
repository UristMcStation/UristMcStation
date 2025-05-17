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


/datum/cover/proc/AttachTo(var/atom/coverable)
	if(!coverable)
		return FALSE

	coverable.cover_data = src
	return TRUE


/atom/proc/GenerateCover()
	// by default
	return null


/atom/proc/ShouldHaveCover()
	// by default
	return FALSE


/atom/proc/GetCoverData(var/generate_if_missing = FALSE, var/log_on_missing = FALSE)
	var/datum/cover/mycover = src.cover_data

	if(!mycover)
		if(src.cover_gen_enabled)
			if(generate_if_missing)
				spawn(0)
					mycover = src.GenerateCover()
					src.cover_data = mycover

			if(log_on_missing)
				to_world_log("Failed to get cover for [src] - no cover data!")

	return src.cover_data


/atom/proc/IsCover(var/transitive = FALSE, var/for_dir = null, var/default_for_null_dir = FALSE)
	if(src.density)
		return TRUE

	var/datum/cover/mycover = GetCoverData(TRUE)

	if(mycover?.CoversInDir(for_dir, default_for_null_dir))
		return TRUE

	if(transitive && src.HasCover(for_dir, default_for_null_dir))
		return TRUE

	return FALSE


/atom/proc/HasCover(var/for_dir = null, var/default_for_null_dir = FALSE)
	for(var/atom/local_obj in src.contents)
		if(local_obj.IsCover(FALSE, for_dir))
			return local_obj

	return null

