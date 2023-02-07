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

		src.remove_bsrevenant_powers()
		src.mind.bluespace_revenant.RebuildPhenomena(src)
	return


/datum/power/revenant/bs_power/chaotic_reroll
	flavor_tags = list(
		BSR_FLAVOR_CHAOTIC,
	)
	activate_message = "<span class='warning'>Even for a walking anomaly, you're a total mess. Your phenomena will periodically change randomly.</span>"
	name = "Ontological Instability"
	isVerb = FALSE
	verbpath = /mob/proc/bsrevenant_reroll_all
