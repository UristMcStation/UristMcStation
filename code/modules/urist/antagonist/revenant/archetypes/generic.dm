/*
// Just for organization - cross-cutting power stuff that didn't make sense anywhere particular
*/


/obj/effect/effect/smoke/mist
	name = "fog"
	opacity = 0
	alpha = 64
	time_to_live = 1000


/datum/effect/effect/system/smoke_spread/mist
	smoke_type = /obj/effect/effect/smoke/mist


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
	var/datum/effect/effect/system/smoke_spread/mist/funfog = new()
	funfog.set_up(5, 0, T)
	funfog.start()

	return TRUE



/datum/power/revenant/distortion/techdiscord
	flavor_tags = list(
		BSR_FLAVOR_GENERIC,
		BSR_FLAVOR_SCIFI,
		BSR_FLAVOR_BLUESPACE
	)
	name = "DISTORTION: Machine Discord"


/datum/power/revenant/distortion/techbane/Apply(var/atom/A, var/datum/bluespace_revenant/revenant)
	// Technology does not like us - sparks.
	if(isnull(A) || !istype(A))
		return

	var/turf/T = get_turf(A)
	if(!istype(T))
		return

	var/obj/machinery/angerymachine = locate() in T
	if(!istype(angerymachine))
		return FALSE

	var/datum/effect/effect/system/spark_spread/sparkFX = new()
	sparkFX.set_up(3, 0, T)
	sparkFX.start()

	return TRUE


/datum/power/revenant/distortion/techbane
	flavor_tags = list(
		BSR_FLAVOR_GENERIC,
		BSR_FLAVOR_SCIFI,
		BSR_FLAVOR_BLUESPACE
	)
	name = "DISTORTION: Techbane"


/datum/power/revenant/distortion/techbane/Apply(var/atom/A, var/datum/bluespace_revenant/revenant)
	// Technology *hates* us - EMP and sparks.
	if(isnull(A) || !istype(A))
		return

	var/turf/T = get_turf(A)
	if(!istype(T))
		return

	var/empIsSafe = TRUE

	var/mob/M = null
	if(istype(revenant))
		M = revenant?.mob_ref?.resolve()

	if(istype(M))
		empIsSafe = (get_dist(T, M) > 2)

	var/datum/effect/effect/system/spark_spread/sparkFX = new()
	sparkFX.set_up(3, 0, T)
	sparkFX.start()

	if(empIsSafe)
		// we do NOT want to EMP part-mechanical BSRs randomly, because that's no fun.
		empulse(T, 0, 1)

	return TRUE


/datum/power/revenant/distortion/lightflicker
	flavor_tags = list(
		BSR_FLAVOR_GENERIC,
		BSR_FLAVOR_SCIFI,
		BSR_FLAVOR_DARK,
		BSR_FLAVOR_DEMONIC,
		BSR_FLAVOR_BLUESPACE
	)
	name = "DISTORTION: Flicker Fluorescents"


/datum/power/revenant/distortion/lightflicker/Apply(var/atom/A, var/datum/bluespace_revenant/revenant)
	// Flicker lights
	if(isnull(A) || !istype(A))
		return

	var/turf/T = get_turf(A)
	if(!istype(T))
		return

	for(var/datum/light_source/LS in T.affecting_lights)
		var/obj/machinery/light/FL = LS.source_atom

		if(istype(FL))
			FL.flicker(3)

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
	activate_message = ("<span class='notice'>You can force your body into impossible motion, even when stunned - at the cost of significant reality slippage.</span>")
	name = "Unstun"
	isVerb = TRUE
	verbpath = /mob/proc/bsrevenant_unstun



//Recover from stuns.
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

	var/total_dist = (revenant.last_tick_distortion_total || 0)
	var/total_tiles = (revenant.last_tick_distortion_tiles || 0)

	var/odds = 0
	if(total_tiles)
		var/avg_dist = total_dist / total_tiles
		odds = round((revenant.roll_for_effects(avg_dist) || 0), 0.1)

	switch(odds)
		if(0 to 2)
			to_chat(src, SPAN_NOTICE("You sense local reality is fairly stable."))
		if(3 to 8)
			to_chat(src, SPAN_WARNING("You sense reality is starting to crack around here..."))
		else
			to_chat(src, SPAN_DANGER("You sense reality is severely disturbed here!"))
	return 1


/datum/power/revenant/bs_power/bsrevenant_insight
	flavor_tags = list() // everyone gets it for free
	activate_message = "<span class='notice'>You can sense the general level of reality distortion around you.</span>"
	name = "Distortion Insight"
	isVerb = TRUE
	verbpath = /mob/proc/bsrevenant_insight
