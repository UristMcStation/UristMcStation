/datum/antagonist/bluespace_revenant/update_antag_mob(var/datum/mind/player)
	..()
	player.current.make_bsrevenant() // (in revenant_add_remove.dm)


/datum/antagonist/bluespace_revenant/add_antagonist(var/datum/mind/player)
	. = ..()
	if(.)
		player.current.make_bsrevenant()


/mob/proc/make_bsrevenant(var/flavor_override = null, var/list/powerset_override = null, var/list/flavorset_override = null, var/list/hungers_override = null, var/force_rebuild = FALSE)
	// This is a bit funky - flavor_override is meant for badmin convenience at the cost of flexibility,
	// flavorset_override is programmatic - more flexible, less ergonomic for human users.
	if(!(src.mind))
		return

	if(force_rebuild || !(src.mind.bluespace_revenant))
		var/list/preset_flavors = flavorset_override // assoc list!

		if(flavor_override)
			if(isnull(preset_flavors))
				preset_flavors = list()

			preset_flavors[flavor_override] = 1000

		var/datum/bluespace_revenant/revenant = new(src, preset_flavors, powerset_override, hungers_override)
		mind.bluespace_revenant = revenant
		revenant.start_ticker()


	for(var/datum/power/revenant/P in mind.bluespace_revenant.unlocked_powers)
		if(P.isVerb)
			if(!(P in src.verbs))
				src.verbs += P.verbpath

	return TRUE


//removes our Revenant verbs
/mob/proc/remove_bsrevenant_powers()
	if(!(isbsrevenant(src)))
		return

	var/datum/bluespace_revenant/revenant = src?.mind?.bluespace_revenant
	if(!istype(revenant))
		return

	revenant.stop_ticker()

	for(var/datum/power/revenant/P in revenant.unlocked_powers)
		P.Deactivate(src.mind)


/datum/antagonist/bluespace_revenant/remove_antagonist(var/datum/mind/player)
	if(player)
		var/mob/Current = player.current
		if(istype(Current))
			Current.remove_bsrevenant_powers()

		player.bluespace_revenant = null

	..()


/datum/bluespace_revenant/proc/turn_into_child_revenant(var/mob/M, var/as_antag = TRUE)
	// Turns the target mob into a Bluespace Revenant of the same type as the source.
	// Meant for use for 'infectious' Revenants a'la old Vamp.
	// The 'as_antag' param controls whether the babby Revenant is added as an antagonist;
	//   this is not really mandatory, but obviously non-antag BSRs should not be violent.
	if(!M)
		return

	// force-rebuild in case somehow one BSR can turn another
	var/revenantified = M.make_bsrevenant(null, src.power_set, src.flavors, src.hungers, TRUE)

	if(as_antag && M.mind && revenantified)
		// This will call M.make_bsrevenant again, but it's set up to just reuse
		//  the original setup if it's already been done, so it's all good.
		GLOB.bluespace_revenants.add_antagonist(M.mind)

	return revenantified
