/obj/effect/overmap/ship/subship
	name = "Subship"
	random_start = FALSE
	auto_connect = FALSE
	var/docked = TRUE
	var/owner_type
	var/obj/effect/overmap/ship/owner
	var/datum/shuttle/autodock/shuttle

/obj/effect/overmap/ship/subship/Initialize()
	. = ..()
	if(docked)
		owner = locate(owner_type)
		if(owner)
			owner.connected[name] = src
			owner.contents += src
			return
		testing("Subship failed to find owner")

/obj/machinery/computer/helm/subship
	var/obj/effect/overmap/ship/subship/truelink
	var/subship

/obj/machinery/computer/helm/subship/Initialize()
	. = ..()
	if(linked)
		setup_truelink()
	else
		spawn(120)
			setup_truelink()

/obj/machinery/computer/helm/subship/proc/setup_truelink()
	var/sub = linked.connected[subship]
	if(sub)
		truelink = sub
		linked = sub
	else
		testing("Subship [subship] failed truelink")

/obj/machinery/computer/helm/subship/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(truelink.docked)
		var/undock = input("Ship currently docked. Would you like to begin undocking procedures?", "Undocking") as anything in list("Yes.", "No.")
		if(undock == "Yes.")
			truelink.docked = FALSE

	else
		..(user, ui_key, ui, force_open)
