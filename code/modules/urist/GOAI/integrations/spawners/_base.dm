/obj/goai_spawner
	/* Object that runs a script at runtime
	//
	// Base class; you *probably* want to use one of the children.
	*/
	icon = 'icons/obj/unused.dmi'
	icon_state = "anom"
	alpha = 50

	var/active = TRUE
	var/script = null // proc(loc) => Any


/obj/goai_spawner/proc/Setup()
	/* A cleaner init hook, to make sure you don't override New() badly.
	// Variable initializations etc. welcome here, the core logic ISN'T!
	*/
	return


/obj/goai_spawner/proc/CallScript()
	/* Handles calling a proc to execute arbitrary logic.
	// Override if you need to provide extra args to the script.
	// Otherwise, the logic belongs to the script itself.
	*/
	if(!active)
		return

	call(script)(src.loc)


/obj/goai_spawner/New()
	. = ..()
	Setup()
	CallScript()


/obj/goai_spawner/oneshot
	// Runs a script and deletes itself


/obj/goai_spawner/oneshot/New()
	..()
	spawn(10)
		qdel(src)
