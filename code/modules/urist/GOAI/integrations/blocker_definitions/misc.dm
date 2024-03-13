# ifdef GOAI_SS13_SUPPORT

/obj/vehicle/train
	blocker_gen_enabled = TRUE

/obj/vehicle/train/GenerateBlocker()
	return GenerateGenericFullBlocker(src)

# endif
