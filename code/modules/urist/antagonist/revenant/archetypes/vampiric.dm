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


/mob/proc/revenant_bloodconsume_bloodstr_burn()
	set category = "Anomalous Powers"
	set name = "Sacrifice Blood"
	set desc = "Sacrifice your own blood (10% per use) to suppress your Distortion."

	var/mob/living/L = src
	var/mob/living/carbon/human/H = L

	if(!istype(L))
		to_chat(src, "Your current mob type does not allow this power, sorry!")
		return

	if(L.stat == DEAD)
		return

	// We have to assume the defaults are in play for this since we cannot look up the actual BSR datum - and arguably we shouldn't.
	// 10 mins for 10% blood volume - I guess it's fair? Will balance later as we go vOv.
	var/suppression_per_bloodsip = BSR_DISTORTION_GROWTH_OVER_MINUTES(10, BSR_DEFAULT_DISTORTION_PER_TICK, BSR_DEFAULT_DECISECONDS_PER_TICK)

	var/bloodsip_size = 10
	var/removed = FALSE
	var/added_suppression = 0

	var/const/msg = "<span class='warning'>You burn away some of your blood, anchoring yourself to reality a bit better</span>"

	if(istype(H))
		var/available_amt = H.vessel.get_reagent_amount(/datum/reagent/blood)
		if(H.species && H.species.blood_volume)
			bloodsip_size = ((H.species.blood_volume * 0.05) || bloodsip_size)

		var/consume_amt = min(bloodsip_size, max(0, available_amt))

		removed = H.vessel.remove_reagent(/datum/reagent/blood, consume_amt)
		if(removed && bloodsip_size != 0)
			added_suppression = ((consume_amt / bloodsip_size) * suppression_per_bloodsip)
			to_chat(src, msg)

	else
		L.adjustBruteLoss(10)
		to_chat(src, msg)

	if(isbsrevenant(src))
		// We'll allow the proc to run for non-Revenants for funminnery purposes, it
		// will just not have any positive effects for the user (pure RP)
		if(src.mind && src.mind.bluespace_revenant)
			var/datum/bluespace_revenant/revenant_data = src.mind.bluespace_revenant

			if(istype(revenant_data))
				revenant_data.suppressed_distortion += added_suppression

	return


/mob/proc/revenant_bloodconsume_stomach()
	set category = "Anomalous Powers"
	set name = "Digest Blood"
	set desc = "Digest all -ingested- blood to suppress your Distortion (scales with amount)."

	var/mob/living/L = src
	var/mob/living/carbon/C = L

	if(!istype(L))
		to_chat(src, "Your current mob type does not allow this power, sorry! If this blocks you as an antag, ask an admin for help rerolling your Hunger.")
		return

	if(L.stat == DEAD)
		return

	if(!istype(C))
		// FALLBACK: use the bloodburn method for non-humanoids
		return src.revenant_bloodconsume_bloodstr_burn()

	// We have to assume the defaults are in play for this since we cannot look up the actual BSR datum - and arguably we shouldn't.
	// 3 mins per a half-pint glass of pure blood; ~1 hr per a whole human - but you'd need to *drink* it all, poison effects and all.
	var/suppression_per_bloodsip = BSR_DISTORTION_GROWTH_OVER_SECONDS(30, BSR_DEFAULT_DISTORTION_PER_TICK, BSR_DEFAULT_DECISECONDS_PER_TICK)
	var/bloodsip_size = 5

	var/removed = FALSE
	var/added_suppression = 0

	var/datum/reagents/ingested = C.get_ingested_reagents()
	var/available_amt = ingested.get_reagent_amount(/datum/reagent/blood)
	var/consume_amt = max(0, available_amt)

	if(consume_amt > 0)
		removed = ingested.remove_reagent(/datum/reagent/blood, consume_amt)
		if(removed && bloodsip_size != 0)
			added_suppression = ((consume_amt / bloodsip_size) * suppression_per_bloodsip)
			to_chat(src, "<span class='warning'>You digest all the blood in your stomach... somehow, and use it to anchor yourself to reality a bit better.</span>")

	else
		to_chat(src, "<span class='warning'>You currently don't have any blood in your stomach to digest.</span>")
		return removed

	if(isbsrevenant(src))
		// We'll allow the proc to run for non-Revenants for funminnery purposes, it
		// will just not have any positive effects for the user (pure RP)
		if(src.mind && src.mind.bluespace_revenant)
			var/datum/bluespace_revenant/revenant_data = src.mind.bluespace_revenant

			if(istype(revenant_data))
				revenant_data.suppressed_distortion += added_suppression

	return removed


/mob/proc/revenant_undeadify()
	set category = "Anomalous Powers"
	set name = "-Undeadify Yourself-"
	set desc = "Oops! You shouldn't be seeing this as a verb, please notify admins/coders!"

	src.urist_status_flags |= STATUS_UNDEAD
	return


/datum/power/revenant/bs_hunger/bloodthirsty
	flavor_tags = list(
		BSR_FLAVOR_VAMPIRE,
		BSR_FLAVOR_GENERIC
	)
	activate_message = "<span class='notice'>You've developed an unnatural thirst for humanoid blood. With an effort of will, you can digest any blood you drink to stabilize your Distortion gain.</span>"
	name = "Bloodthirsty"
	isVerb = TRUE
	verbpath = /mob/proc/revenant_bloodconsume_stomach


/datum/power/revenant/bs_power/undead
	flavor_tags = list(
		BSR_FLAVOR_VAMPIRE,
		BSR_FLAVOR_GENERIC
	)
	activate_message = "<span class='warning'>Something's very wrong... You seem to have lost all vital signs - but somehow it doesn't seem to be much of a problem to you!</span>"
	name = "Undead"
	isVerb = FALSE
	verbpath = /mob/proc/revenant_undeadify
