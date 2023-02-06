/* VAMPIRE REVENANT ARCHETYPE
//
// Emulation of old Vamp in the Revenant system.
//
// HUNGER: rather than getting powers from a blood counter, we convert blood into Distortion Suppression.
//
// POWERS: similar to old Vamp set, though not necessarily the same.
//
// SPOOPS: Hammer it up. Ghost interactions, spawning bats, light manipulation.
*/


/mob/proc/revenant_bloodconsume()
	// We have to assume the defaults are in play for this since we cannot look up the actual BSR datum - and arguably we shouldn't.
	// 10 mins for 10% blood volume - I guess it's fair? Will balance later as we go vOv.
	var/const/suppression_per_bloodsip = BSR_SUPPRESSION_IN_MINUTES(10, BSR_DEFAULT_DISTORTION_PER_TICK, BSR_DEFAULT_DECISECONDS_PER_TICK)

	var/mob/living/L = src
	var/bloodsip_size = 10
	var/removed = FALSE
	var/added_suppression = 0

	if(!istype(L))
		to_chat(src, "Your current mob type does not allow this power, sorry!")
		return

	if(L.stat == DEAD)
		return

	var/mob/living/carbon/human/H = L

	if(istype(H))
		var/available_amt = H.vessel.get_reagent_amount(/datum/reagent/blood)
		if(H.species && H.species.blood_volume)
			bloodsip_size = ((H.species.blood_volume * 0.05) || bloodsip_size)

		var/consume_amt = min(bloodsip_size, max(0, available_amt))

		removed = H.vessel.remove_reagent(/datum/reagent/blood, consume_amt)
		if(removed && bloodsip_size != 0)
			added_suppression = ((consume_amt / bloodsip_size) * suppression_per_bloodsip)

	else
		L.adjustBruteLoss(10)

	to_chat(src, "<span class='warning'>You burn away some of your blood, anchoring yourself to reality a bit better</span>")

	if(isbsrevenant(src))
		// We'll allow the proc to run for non-Revenants for funminnery purposes, it
		// will just not have any positive effects for the user (pure RP)
		if(src.mind && src.mind.bluespace_revenant)
			var/datum/bluespace_revenant/revenant_data = src.mind.bluespace_revenant

			if(istype(revenant_data))
				revenant_data.suppressed_distortion += added_suppression

	return


/mob/proc/revenant_undeadify()
	src.urist_status_flags |= STATUS_UNDEAD
	return


/datum/power/revenant/bs_hunger/bloodthirsty
	flavor_tags = list(
		BSR_FLAVOR_VAMPIRE,
		BSR_FLAVOR_GENERIC
	)
	name = "Bloodthirsty"
	isVerb = TRUE
	verbpath = /mob/proc/revenant_bloodconsume


/datum/power/revenant/bs_power/undead
	flavor_tags = list(
		BSR_FLAVOR_VAMPIRE,
		BSR_FLAVOR_GENERIC
	)
	name = "Undead"
	isVerb = FALSE
	verbpath = /mob/proc/revenant_undeadify
