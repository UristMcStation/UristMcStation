# ifdef GOAI_SS13_SUPPORT

// MECHS

/obj/mecha
	blocker_gen_enabled = TRUE

/obj/mecha/GenerateBlocker()
	return GenerateGenericFullBlocker(src)

# endif
