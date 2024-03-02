# ifdef GOAI_SS13_SUPPORT

// STRUCTURES

/obj/structure
	cover_gen_enabled = TRUE

/obj/structure/GenerateCover()
	return GenerateGenericFullCover(src)


/obj/structure/table/GenerateCover()
	var/datum/cover/cover_data = null

	if(src.flipped)
		cover_data = new(TRUE, FALSE, src.dir)

	else
		cover_data = new(FALSE, FALSE, null)

	return cover_data

# endif
