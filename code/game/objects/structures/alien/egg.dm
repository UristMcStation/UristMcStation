#define MAX_PROGRESS 100

/obj/structure/alien/egg
	desc = "It looks like a weird egg."
	name = "egg"
	icon_state = "egg_growing"
	density = FALSE
	anchored = TRUE
	var/progress = 0

/obj/structure/alien/egg/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/alien/egg/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/alien/egg/CanUseTopic(mob/user)
	return isghost(user) ? STATUS_INTERACTIVE : STATUS_CLOSE

/obj/structure/alien/egg/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["spawn"])
		attack_ghost(usr)

/obj/structure/alien/egg/Process()
	progress++
	if(progress >= MAX_PROGRESS)
		for(var/mob/observer/ghost/O in GLOB.ghost_mobs)
			if(O.client && O.client.prefs && (MODE_XENOMORPH in O.client.prefs.be_special_role))
				to_chat(O, "<span class='notice'>An alien is ready to hatch! ([ghost_follow_link(src, O)]) (<a href='byond://?src=\ref[src];spawn=1'>spawn</a>)</span>")
		STOP_PROCESSING(SSobj, src)
		update_icon()

/obj/structure/alien/egg/on_update_icon()
	if(progress == -1)
		icon_state = "egg_hatched"
	else if(progress < MAX_PROGRESS)
		icon_state = "egg_growing"
	else
		icon_state = "egg"

/* //Uncomment if someone ever makes xenophage usable.
/obj/structure/alien/egg/attack_ghost(mob/observer/ghost/user)
	if(progress == -1) //Egg has been hatched.
		return

	if(progress < MAX_PROGRESS)
		to_chat(user, "\The [src] has not yet matured.")
		return

	if(!user.MayRespawn(1))
		return

	// Check for bans properly.
	if(jobban_isbanned(user, MODE_XENOMORPH))
		to_chat(user, "<span class='danger'>You are banned from playing a Xenophage.</span>")
		return

	var/confirm = alert(user, "Are you sure you want to join as a Xenophage larva?", "Become Larva", "No", "Yes")

	if(!src || confirm != "Yes")
		return

	if(!user || !user.ckey)
		return

	if(progress == -1) //Egg has been hatched.
		to_chat(user, "Too slow...")
		return

	flick("egg_opening",src)
	progress = -1 // No harvesting pls.
	sleep(5)

	if(!src || !user)
		visible_message("<span class='alium'>\The [src] writhes with internal motion, but nothing comes out.</span>")
		progress = MAX_PROGRESS // Someone else can have a go.
		return // What a pain.

	// Create the mob, transfer over key.
	var/mob/living/carbon/alien/larva/larva = new(get_turf(src))
	larva.ckey = user.ckey
	GLOB.xenomorphs.add_antagonist(larva.mind, 1)
	spawn(-1)
		if(user) qdel(user) // Remove the keyless ghost if it exists.

	visible_message("<span class='alium'>\The [src] splits open with a wet slithering noise, and \the [larva] writhes free!</span>")

	// Turn us into a hatched egg.
	name = "hatched alien egg"
	desc += " This one has hatched."
	update_icon()
*/
#undef MAX_PROGRESS
