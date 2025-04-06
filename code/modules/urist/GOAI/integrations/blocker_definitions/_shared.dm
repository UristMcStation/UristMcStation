/proc/GenerateGenericFullBlocker(var/owner = null)
	// owner is optional; can be used to look up vars on the creator

	var/atom/atom_owner = owner
	var/datum/directional_blocker/blocker = null

	if(atom_owner)
		if(atom_owner.density)
			blocker = new(ALL_CARDINAL_DIRS, TRUE, TRUE)

		else
			// Caching to speed up queries
			atom_owner.cover_gen_enabled = FALSE

	return blocker
