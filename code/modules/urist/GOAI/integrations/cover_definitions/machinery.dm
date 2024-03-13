# ifdef GOAI_SS13_SUPPORT

// MACHINERY

/obj/machinery
	cover_gen_enabled = TRUE


/obj/machinery/GenerateCover()
	return GenerateGenericFullCover(src)


/obj/machinery/atmospherics
	cover_gen_enabled = FALSE


/obj/machinery/camera
	cover_gen_enabled = FALSE

# endif
