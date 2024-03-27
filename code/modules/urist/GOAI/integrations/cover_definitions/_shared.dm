
/proc/GenerateGenericFullCover(var/owner = null)
	// owner is optional; can be used to look up vars on the creator

	var/atom/atom_owner = owner
	var/datum/cover/cover_data = null

	if(atom_owner)
		if(atom_owner.density)
			cover_data = new(TRUE, TRUE)

		else
			// Caching to speed up queries
			atom_owner.cover_gen_enabled = FALSE

	return cover_data
