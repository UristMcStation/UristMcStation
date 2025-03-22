#ifdef GOAI_LIBRARY_FEATURES

/mob/verb/EnableDebug()
	set category = "Debug"
	src.verbs.Add(/client/proc/debug_variables)
	to_chat(usr, "[src] now wields the ultimate powah!")
	return

#endif

#ifdef GOAI_SS13_SUPPORT

/client/proc/EnableGoaiDebugVerbs()
	set category = "Debug"

	if(!src.mob)
		return

	src.mob.GrantGoaiDebugVerbs()
	return


/client/proc/EnableGoaiOrderVerbs()
	set category = "Debug"

	if(!src.mob)
		return

	src.mob.GrantGoaiOrderVerbs()
	return

# endif
