# ifdef GOAI_SS13_SUPPORT

// STRUCTURES

/obj/structure
	cover_gen_enabled = TRUE


/obj/structure/GenerateCover()
	return GenerateGenericFullCover(src)


/obj/structure/table/GenerateCover()
	var/datum/cover/cover_data = null
	cover_data = new(src.flipped, FALSE, src.dir)
	return cover_data


/obj/structure/table
	raycast_block_all = RAYCAST_BLOCK_CALLPROC
	raycast_cover_proc = /obj/structure/table/proc/GetTableRaytraceBlocking


/obj/structure/table/proc/GetTableRaytraceBlocking(var/hit_angle = null, var/raytype = null)
	if(!flipped)
		// Unflipped gets 30% coverage (covers legs a bit)
		return prob(30)

	var/hit_dir = angle2dir(hit_angle)
	var/hit_antidir = dir2opposite(hit_dir)

	// Flipped protects against head-on hits...
	if(src.dir == hit_dir)
		return prob(70)

	// ...but allows to fire from behind it safely
	else if (src.dir == hit_antidir)
		return FALSE

	// Perpendicular dir gets no coverage
	return FALSE

# endif
