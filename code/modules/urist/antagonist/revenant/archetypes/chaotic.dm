/* CHAOTIC REVENANT ARCHETYPE
//
// This is a meta-archetype; its whole powerset will periodically reroll.
*/


/mob/proc/bsrevenant_reroll_all()
	if(!(isbsrevenant(src)))
		return

	var/wait_time = rand(10 MINUTES, 20 MINUTES)

	spawn(wait_time)
		if(!src || !(isbsrevenant(src)))
			return

		var/datum/bluespace_revenant/revenant = src?.mind?.bluespace_revenant
		if(istype(revenant))
			return

		var/list/new_flavors = revenant.select_flavors()
		new_flavors[new_flavors.len] = BSR_FLAVOR_CHAOTIC

		var/list/new_powers = revenant.select_powers(new_flavors)
		new_powers.Add(GLOB.revenant_powerinstances[/datum/power/revenant/bs_power/chaotic_reroll])

		src.remove_bsrevenant_powers()
		src.mind.bluespace_revenant.RebuildPhenomena(src, new_flavors, new_powers)
	return


/datum/power/revenant/bs_power/chaotic_reroll
	flavor_tags = list(
		BSR_FLAVOR_CHAOTIC,
	)
	activate_message = ("<span class='warning'>Even for a walking anomaly, you're a total mess. Your phenomena will periodically change randomly.</span>")
	name = "Ontological Instability"
	isVerb = FALSE
	distortion_threshold = 12000 // 10 mins


/datum/power/revenant/bs_power/chaotic_reroll/Activate(var/datum/mind/M)
	. = ..(M)

	if(!.)
		return

	if(!M.bluespace_revenant)
		return FALSE

	M.bluespace_revenant.AddCallback(/mob/proc/bsrevenant_reroll_all)
	return
