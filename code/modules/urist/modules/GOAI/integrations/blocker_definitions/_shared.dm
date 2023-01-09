/proc/GenerateGenericFullBlocker(var/owner = null)
	// owner is optional; can be used to look up vars on the creator

	var/atom/atom_owner = owner
	var/datum/directional_blocker/blocker = null

	if(atom_owner?.density)
		blocker = new(ALL_CARDINAL_DIRS, TRUE, TRUE)
	else
		atom_owner?.blocker_gen_enabled = FALSE

	return blocker

/proc/GenerateGenericDirBlocker(var/owner = null, var/invert_dir = FALSE)
	var/atom/atom_owner = owner
	var/datum/directional_blocker/blocker = null

	if(atom_owner?.density)
		var/dir_to_block = invert_dir ? dir2opposite(atom_owner.dir) : atom_owner.dir
		blocker = new(dir_to_block, FALSE, TRUE)
	else
		atom_owner?.blocker_gen_enabled = FALSE

	return blocker


/proc/GenerateDynamicFullBlocker(var/owner)
	var/atom/atom_owner = owner
	var/datum/directional_blocker/blocker = null

	if(atom_owner)
		blocker = new(ALL_CARDINAL_DIRS, TRUE, atom_owner.density)

	//Density might change later on, so we cannot cache blocker_gen_enabled. Generate a blocker and check for updates when needed

	return blocker

/proc/GenerateDynamicDirBlocker(var/owner, var/invert_dir = FALSE)
	var/atom/atom_owner = owner
	var/datum/directional_blocker/blocker = null

	if(atom_owner)
		var/dir_to_block = invert_dir ? dir2opposite(atom_owner.dir) : atom_owner
		blocker = new(dir_to_block, FALSE, atom_owner.density)

	return blocker

/proc/UpdateDynamicFullBlocker(var/owner)
	var/atom/atom_owner = owner
	if(!atom_owner)
		return null

	var/datum/directional_blocker/blocker = atom_owner.directional_blocker
	if(!blocker)
		return null

	if(blocker.is_active != atom_owner.density)
		blocker.is_active = atom_owner.density
		return TRUE
	else
		return FALSE

/proc/UpdateDynamicDirBlocker(var/owner, var/invert_dir = FALSE)
	var/atom/atom_owner = owner
	if(!atom_owner)
		return null

	var/datum/directional_blocker/blocker = atom_owner.directional_blocker

	if(!blocker)
		return null

	var/dir_to_block = invert_dir ? dir2opposite(atom_owner.dir) : atom_owner.dir

	if(blocker.is_active != atom_owner.density)
		blocker.is_active = atom_owner.density
		. = TRUE
	if(blocker.blocks != dir_to_block)
		blocker.blocks = dir_to_block
		. = TRUE
	if(!.)
		. = FALSE