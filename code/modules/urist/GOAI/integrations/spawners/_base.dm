/obj/spawner
	/* Object that runs a script at runtime
	//
	// Base class; you *probably* want to use one of the children.
	*/
	icon = 'icons/obj/objects.dmi'
	icon_state = "anom"
	alpha = 50

	var/active = TRUE
	var/script = null // proc(loc) => Any


/obj/spawner/proc/Setup()
	/* A cleaner init hook, to make sure you don't override New() badly.
	// Variable initializations etc. welcome here, the core logic ISN'T!
	*/
	return


/obj/spawner/proc/CallScript()
	/* Handles calling a proc to execute arbitrary logic.
	// Override if you need to provide extra args to the script.
	// Otherwise, the logic belongs to the script itself.
	*/
	if(!active)
		return

	call(script)(src.loc)


/obj/spawner/New()
	Setup()
	CallScript()


/obj/spawner/oneshot
	// Runs a script and deletes itself


/obj/spawner/oneshot/New()
	..()
	qdel(src)
