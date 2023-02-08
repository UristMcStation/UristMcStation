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

	var/const/msg = "<span class='notice'>You burn away some of your blood, anchoring yourself to reality a bit better</span>"

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
			to_chat(src, SPAN_WARNING("You digest all the blood in your stomach... somehow, and use it to anchor yourself to reality a bit better."))

	else
		to_chat(src, SPAN_WARNING("You currently don't have any blood in your stomach to digest."))
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
		BSR_FLAVOR_DEMONIC,
		BSR_FLAVOR_OCCULT,
		BSR_FLAVOR_DEATH,
		BSR_FLAVOR_GENERIC
	)
	activate_message = ("<span class='notice'>You've developed an unnatural thirst for humanoid blood. With an effort of will, you can digest any blood you drink to stabilize your Distortion gain.</span>")
	name = "Bloodthirsty"
	isVerb = TRUE
	verbpath = /mob/proc/revenant_bloodconsume_stomach


/datum/power/revenant/bs_power/undead
	flavor_tags = list(
		BSR_FLAVOR_VAMPIRE,
		BSR_FLAVOR_DEMONIC,
		BSR_FLAVOR_PLAGUE,
		BSR_FLAVOR_DEATH,
		BSR_FLAVOR_GENERIC
	)
	activate_message = ("<span class='warning'>Something's very wrong... You seem to have lost all vital signs - but somehow it doesn't seem to be much of a problem to you!</span>")
	name = "Undead"
	isVerb = FALSE
	verbpath = /mob/proc/revenant_undeadify


/datum/power/revenant/distortion/bats
	flavor_tags = list(
		BSR_FLAVOR_VAMPIRE,
		BSR_FLAVOR_DARK
	)
	name = "DISTORTION - Bats!"


/datum/power/revenant/distortion/bats/Apply(var/atom/A, var/datum/bluespace_revenant/revenant)
	if(isnull(A) || !istype(A))
		return

	var/turf/T = get_turf(A)
	if(!istype(T))
		return

	var/obj/effect/gateway/hole = new(T)
	hole.density = 0

	QDEL_IN(hole, 30 SECONDS)

	spawn(rand(1, 10 SECONDS))
		var/mob/living/simple_animal/hostile/scarybat/bat = new (T)
		bat.visible_message(SPAN_WARNING("\A [bat] escapes from the portal!"))

	return TRUE


/mob/proc/bsrevenant_summon_bats()
	set category = "Anomalous Powers"
	set name = "Summon Bats"
	set desc = "Summon some Bats Outta Hell. They're friendly... to you, anyway."

	var/atom/A = get_turf(src)

	if(isnull(A) || !istype(A))
		return

	var/turf/T = get_turf(A)
	if(!istype(T))
		return

	src.visible_message(SPAN_WARNING("\The [src] reaches across spacetime, ripping the veil and leaving a portal behind!"))
	var/obj/effect/gateway/hole = new(T)
	hole.density = 0

	QDEL_IN(hole, 30 SECONDS)

	spawn(rand(1, 10 SECONDS))
		var/mob/living/simple_animal/hostile/scarybat/bat = new(T, src)
		bat.visible_message(SPAN_WARNING("\A [bat] escapes from the portal!"))

	var/datum/bluespace_revenant/revenant = src.mind?.bluespace_revenant
	if(istype(revenant))
		revenant.total_distortion += BSR_DISTORTION_GROWTH_OVER_MINUTES(10, BSR_DEFAULT_DISTORTION_PER_TICK, BSR_DEFAULT_DECISECONDS_PER_TICK)
		to_chat(src, SPAN_WARNING("You're feeling significantly less *real*..."))

	return TRUE


/datum/power/revenant/bs_power/bats
	flavor_tags = list(
		BSR_FLAVOR_VAMPIRE,
		BSR_FLAVOR_DARK
	)
	name = "Summon Bats"
	activate_message = ("<span class='notice'>You sense creatures of the night everywhere around you, just waiting for someone to reach out and invite them to this reality.</span>")
	isVerb = TRUE
	verbpath = /mob/proc/bsrevenant_summon_bats



/mob/proc/bsrevenant_turn_another()
	var/datum/bluespace_revenant/revenant = src.mind?.bluespace_revenant
	if(!istype(revenant))
		to_chat(src, SPAN_NOTICE("You must be a Bluespace Revenant to use this ability."))
		return

	var/obj/item/grab/G = null
	var/mob/living/carbon/srcC = src
	var/mob/living/carbon/human/H = null

	if(!istype(G) || !istype(H))
		G = src.get_active_hand()
		if(istype(G))
			H = G.affecting

	if(!istype(G) || !istype(H))
		G = src.get_inactive_hand()
		H = G.affecting
		if(istype(G))
			H = G.affecting

	if(!istype(H))
		to_chat(src, SPAN_NOTICE("You must be holding a humanoid mob to use this ability."))
		return

	playsound(src.loc, 'sound/weapons/bite.ogg', 50, 1, 1)
	src.visible_message(SPAN_DANGER("[src] is biting [H] on the neck!"))

	if(isbsrevenant(H))
		to_chat(src, SPAN_DANGER("You get staggered by a surging wave of unreality and jerk back as you try to bite \the [H]."))
		src.visible_message(SPAN_DANGER("[src] suddenly recoils from \the [H]'s neck!"))

		if(istype(srcC))
			srcC.flash_eyes()
			srcC.Stun(rand(1,3))

		H.flash_eyes()
		H.Stun(rand(1,3))

		revenant.total_distortion += BSR_DISTORTION_GROWTH_OVER_MINUTES(1, BSR_DEFAULT_DISTORTION_PER_TICK, BSR_DEFAULT_DECISECONDS_PER_TICK)
		to_chat(src, SPAN_WARNING("You're feeling slightly less *real*..."))
		return

	revenant.trackers = (revenant?.trackers || list())

	var/mob/living/carbon/human/last_transferred_stored = revenant.trackers["last_transferred_to"]
	if(last_transferred_stored != H)
		revenant.trackers["last_transferred_to"] = H
		revenant.trackers["last_transferred_amt"] = 0

	spawn(0)
		var/init_time = world.time
		while ((world.time - init_time) < 2 MINUTES)
			if(!(do_after(src, 5 SECONDS, H)))
				break

			var/curr_transferred = revenant.trackers["last_transferred_amt"]
			if(isnull(curr_transferred))
				break // something's off

			revenant = src.mind?.bluespace_revenant

			if(!istype(revenant))
				to_chat(src, SPAN_WARNING("Reality comes crashing back down on you and in the resulting surprise, you release your bite!"))
				src.visible_message(SPAN_WARNING("[src] suddenly tears \his mouth away from \the [H]"))
				break

			H.Stun(3)

			revenant.total_distortion += BSR_DISTORTION_GROWTH_OVER_SECONDS(30, BSR_DEFAULT_DISTORTION_PER_TICK, BSR_DEFAULT_DECISECONDS_PER_TICK)
			to_chat(src, SPAN_WARNING("You're feeling slightly less *real*..."))

			if(curr_transferred >= 100)
				revenant.trackers["last_transferred_to"] = null
				revenant.trackers["last_transferred_amt"] = 0
				break // we're done

			revenant.trackers["last_transferred_amt"] = curr_transferred + 10

		var/total_transferred = revenant.trackers["last_transferred_amt"]
		revenant = src.mind?.bluespace_revenant

		if(istype(revenant) && H && total_transferred >= 100)
			revenant.turn_into_child_revenant(H)
			var/datum/bluespace_revenant/babby = H.mind?.bluespace_revenant

			if(!istype(babby))
				return

			to_chat(src, SPAN_NOTICE("You have turned [H] into another Bluespace Revenant!"))

			// New BSRs inherit half of our total Distortion AND half of suppression...
			babby.total_distortion = (revenant.total_distortion / 2)
			babby.suppressed_distortion = (revenant.suppressed_distortion / 2)

			// ...*transferred* from parent, so this is an efficient way to reduce your total Distortion.
			revenant.total_distortion = (babby.total_distortion)
			revenant.suppressed_distortion = (babby.suppressed_distortion)

		else
			to_chat(src, SPAN_WARNING("You've been interrupted while trying to turn [H]. If you bite them again, you can resume the process."))
	return


/datum/power/revenant/bs_power/sire_revenant
	flavor_tags = list(
		BSR_FLAVOR_VAMPIRE,
		BSR_FLAVOR_BLOOD,
		BSR_FLAVOR_PLAGUE
	)
	name = "Sire Revenant"
	activate_message = ("<span class='notice'>Whatever it is you are, it's *infectious*. By biting the neck of another humanoid, you could transform half of your Distortion and transform them into one of your own kind.</span>")
	isVerb = TRUE
	verbpath = /mob/proc/bsrevenant_turn_another

