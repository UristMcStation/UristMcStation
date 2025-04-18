/datum/map/nerva/ship_jump()
	for(var/obj/overmap/visitable/ship/combat/nerva/nerva)
		new /obj/ftl (get_turf(nerva))
		qdel(nerva)
		animate(nerva, time = 0.5 SECONDS)
		animate(alpha = 0, time = 0.5 SECONDS)

/datum/map/nerva/setup_economy()
	..()
	if (!nanotrasen_account)
		nanotrasen_account = create_account("Nanotrasen Company Expense Card", "Nanotrasen Representative", rand(11000,44000), ACCOUNT_TYPE_DEPARTMENT)

/datum/map/nerva/do_interlude_teleport(atom/movable/target, atom/destination, duration = 30 SECONDS, precision, type) // copypasta from torch proc to do the same
	var/turf/T = pick_area_turf(/area/bluespace_interlude/platform, list(/proc/not_turf_contains_dense_objects, /proc/IsTurfAtmosSafe))

	if (!T)
		do_teleport(target, destination)
		return

	if (isliving(target))
		to_chat(target, FONT_LARGE(SPAN_WARNING("Your vision goes blurry and nausea strikes your stomach. Where are you...?")))
		do_teleport(target, T, precision, type)
		addtimer(new Callback(GLOBAL_PROC, /proc/do_teleport, target, destination), duration)
