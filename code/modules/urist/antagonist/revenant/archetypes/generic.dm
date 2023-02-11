/*
// Just for organization - cross-cutting power stuff that didn't make sense anywhere particular
*/


/obj/effect/effect/smoke/chill_mist
	name = "fog"
	opacity = 0
	alpha = 64
	time_to_live = 1000


/obj/effect/effect/smoke/chill_mist/affect(var/mob/living/carbon/M)
	// This DELIBERATELY ignores normal smoke protection checks and has no clothes checks;
	// it's supposed to be an unnaturally cold fog
	if(!istype(M))
		return 0

	// This is always cold enough to be uncomfortable for any species that
	// has a preference; otherwise 1 Celsius, because barely above freezing.
	var/mist_temp = ((M?.species?.cold_discomfort_level || 275) - 1)

	M.bodytemperature = mist_temp

	..()
	return 1



/datum/effect/effect/system/smoke_spread/chill_mist
	smoke_type = /obj/effect/effect/smoke/chill_mist


/datum/power/revenant/distortion/fogweaver
	flavor_tags = list(
		BSR_FLAVOR_OCCULT,
		BSR_FLAVOR_CULTIST,
		BSR_FLAVOR_DEMONIC,
		BSR_FLAVOR_VAMPIRE,
		BSR_FLAVOR_GENERIC
	)
	name = "DISTORTION: Fogweaver"


/datum/power/revenant/distortion/fogweaver/Apply(var/atom/A, var/datum/bluespace_revenant/revenant)
	if(isnull(A) || !istype(A))
		return

	var/turf/T = get_turf(A)
	if(!istype(T))
		return

	// There's a reason behind this varname and it's horrible. --scr
	var/datum/effect/effect/system/smoke_spread/chill_mist/funfog = new()
	funfog.set_up(5, 0, T)
	funfog.start()

	return TRUE


//Recover from stuns.
/mob/proc/bsrevenant_unstun()
	set category = "Anomalous Powers"
	set name = "Unnatural Recovery"
	set desc = "Removes all stuns"

	var/mob/living/carbon/human/C = src
	if(!istype(C))
		return

	if(C.stat == DEAD)
		to_chat(src, SPAN_NOTICE("A bit too late for that now, don't you think?"))
		return

	// Ling pasta :^)
	C.set_stat(CONSCIOUS)
	C.SetParalysis(0)
	C.SetStunned(0)
	C.SetWeakened(0)
	C.lying = 0
	C.UpdateLyingBuckledAndVerbStatus()

	src.verbs -= /mob/proc/bsrevenant_unstun
	spawn(5)	src.verbs += /mob/proc/bsrevenant_unstun

	var/datum/bluespace_revenant/revenant = src?.mind?.bluespace_revenant
	if(revenant)
		revenant.total_distortion += BSR_DISTORTION_GROWTH_OVER_MINUTES(5, BSR_DEFAULT_DISTORTION_PER_TICK, BSR_DEFAULT_DECISECONDS_PER_TICK)
		to_chat(src, SPAN_NOTICE("You feel the grip of reality on you loosen..."))

	SSstatistics.add_field_details("bsrevenant_powers","UNS")
	return 1


/datum/power/revenant/bs_power/unstun
	flavor_tags = list(
		BSR_FLAVOR_GENERIC
	)
	activate_message = ("<span class='notice'>Even when stunned, you can force your body to move normally - at the cost of significant reality slippage.</span>")
	name = "Unstun"
	isVerb = TRUE
	verbpath = /mob/proc/bsrevenant_unstun
	distortion_threshold = 18000 // 15 mins



/mob/proc/bsrevenant_insight()
	set category = "Anomalous Powers"
	set name = "Insight"
	set desc = "Gives you a sense of local reality distortion levels."

	var/mob/living/carbon/C = src

	if(!istype(C))
		return

	if(C.stat == DEAD)
		return

	var/datum/bluespace_revenant/revenant = src?.mind?.bluespace_revenant
	if(!istype(revenant))
		return

	var/effective_rate = revenant.get_distortion_rate()
	switch(effective_rate)
		if(0 to 0.5)
			to_chat(src, SPAN_NOTICE("INSIGHT: You feel reasonably real."))
		if(0.5 to 1)
			to_chat(src, SPAN_WARNING("INSIGHT: You are warping reality slowly..."))
		if(1 to 2)
			to_chat(src, SPAN_WARNING("INSIGHT: You are starting to become seriously anomalous!"))
		else
			to_chat(src, SPAN_DANGER("INSIGHT: You are *severely* anomalous!"))

	var/total_dist = (revenant.last_tick_distortion_total || 0)
	var/total_tiles = (revenant.last_tick_distortion_tiles || 0)

	var/odds = 0
	if(total_tiles)
		var/avg_dist = total_dist / total_tiles
		odds = ((revenant.roll_for_effects(avg_dist) || 0) * total_tiles)

	switch(odds)
		if(0 to 5)
			to_chat(src, SPAN_NOTICE("INSIGHT: You sense local reality is fairly stable."))
		if(5 to 20)
			to_chat(src, SPAN_WARNING("INSIGHT: You sense reality is starting to crack around here..."))
		else
			to_chat(src, SPAN_DANGER("INSIGHT: You sense reality is severely disturbed here!"))
	return 1


/datum/power/revenant/bs_power/bsrevenant_insight
	flavor_tags = list() // everyone gets it for free
	activate_message = "<span class='notice'>You can sense the general level of reality distortion around you.</span>"
	name = "Distortion Insight"
	isVerb = TRUE
	verbpath = /mob/proc/bsrevenant_insight
	distortion_threshold = 0 // always free
