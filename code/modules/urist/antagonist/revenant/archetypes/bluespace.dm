/* BLUESPACE REVENANT ARCHETYPE
//
// This is meant to be more of a sci-fi flavor.
//
// HUNGER: Physics-based; abnormal atmos, chems
//
// POWERS: Blink/Teleportation-centric; invisibility; physics manipulation
//
// SPOOPS: Afterimage - an effect that clones the image of a spessman (Revenant only on low power) and causes mischief
*/



/* SPATIAL INSTABILITY - Forced Blink w/o smoke. */
/datum/power/revenant/distortion/spatial_instability
	flavor_tags = list(
		BSR_FLAVOR_SPACE,
		BSR_FLAVOR_SCIFI,
		BSR_FLAVOR_BLUESPACE
	)
	name = "DISTORTION: Spatial Instability"


/datum/power/revenant/distortion/spatial_instability/Apply(var/atom/A, var/datum/bluespace_revenant/revenant)
	if(!istype(A))
		return

	if(!istype(revenant))
		// strictly necessary here
		return

	var/AposX = A.x

	if(isnull(AposX))
		to_world_log("BSR: Spatial Instability - AposX is null")
		return

	var/AposY = A.y

	if(isnull(AposY))
		to_world_log("BSR: Spatial Instability - AposY is null")
		return

	var/turf/T = null

	for(var/tries = 0, tries < 3, tries++)
		var/newPosX = clamp(AposX + rand(-2, 2), 0, world.maxx)
		var/newPosY = clamp(AposY + rand(-2, 2), 0, world.maxx)

		T = locate(newPosX, newPosY, A.z)

		if(!istype(T))
			continue

		if(T.density)
			T = null // avoid picking it if it's the last try
			continue

	if(!istype(T))
		return

	var/mob/M = revenant.mob_ref?.resolve()
	if(!istype(M))
		return

	playsound(T, 'sound/effects/plunger.ogg', 50, 1, 1)
	M.dizziness += rand(1, 3)
	to_chat(M, SPAN_WARNING("You feel dizzy as your body suddenly jostles through spacetime!"))
	if(prob(20))
		M.Weaken(3)
		M.Stun(3)
	M.buckled = null
	M.forceMove(T)

	return TRUE


/* AFTERIMAGE - Ghostly apparitions of the BSR who caused them. */
/*
/datum/power/revenant/distortion/afterimage
	flavor_tags = list(
		BSR_FLAVOR_GENERIC
	)
	name = "DISTORTION: Afterimage"


/datum/power/revenant/distortion/afterimage/Apply(var/atom/A, var/datum/bluespace_revenant/revenant)
	if(isnull(A) || !istype(A))
		return

	var/turf/T = get_turf(A)
	if(!istype(T))
		return

	// TODO
	// Shadow Wight-like effect that takes the appearance of the BSR

	return
*/

/* AREA PORTAL - Open teleport portals. Wizard fakeout. */
/mob/proc/bsrevenant_portal()
	set category = "Anomalous Powers"
	set name = "Create Portal"
	set desc = "Creates a portal to an area of your selection for 5 minutes."

	var/mob/living/L = src
	if(istype(L) && (L.stat != CONSCIOUS))
		return

	var/area/thearea
	thearea = input("Area to teleport to", "Teleport") as null|anything in stationlocs
	if(!thearea)
		return

	var/turf/start = get_turf(src)
	var/turf/end = src.try_teleport(thearea)

	if(!istype(end))
		to_chat(src, "Failed to locate a suitable teleport destination for an unknown reason. Sorry.")
		return

	playsound(get_turf(src), 'sound/effects/teleport.ogg', 50, 1)
	new /obj/effect/portal/wizard(start, end, 2 MINUTES)
	new /obj/effect/portal/wizard(end, start, 2 MINUTES)

	var/datum/bluespace_revenant/revenant = src?.mind?.bluespace_revenant
	if(istype(revenant))
		revenant.total_distortion += BSR_DISTORTION_GROWTH_OVER_MINUTES(5, BSR_DEFAULT_DISTORTION_PER_TICK, BSR_DEFAULT_DECISECONDS_PER_TICK)

	return 1


/*
Proc needs to be fixed, it fails to locate a dest
/datum/power/revenant/bs_power/areaportal
	flavor_tags = list(
		BSR_FLAVOR_GENERIC,
		BSR_FLAVOR_BLUESPACE,
		BSR_FLAVOR_SPACE,
		BSR_FLAVOR_SCIFI
	)
	name = "Bluespace Tunnelling"
	isVerb = TRUE
	verbpath = /mob/proc/bsrevenant_portal
	activate_message = SPAN_NOTICE("You and Euclidean space have an open relationship. With some effort, you can fold space, creating temporary portals between areas.")
	distortion_threshold = 18000 // 30 mins
*/


/* DIGICAMO - Mess up tracking. Ling fakeout. */
/mob/proc/bsrevenant_digitalcamo()
	set category = "Anomalous Powers"
	set name = "Toggle Digital Camouflage"
	set desc = "The AI can no longer track you, but you will look different if examined.  Increases Distortion generation while active."

	var/mob/living/carbon/human/C = src
	if(!istype(C))
		return

	// How much camo value the BSR is 'responsible' for, in case there's more than one source.
	var/stored_camo = C.digitalcamo

	var/datum/bluespace_revenant/revenant = src?.mind?.bluespace_revenant
	if(istype(revenant))
		if(isnull(revenant.trackers))
			revenant.trackers = list()

		stored_camo = (revenant.trackers["stored digital camo"] || stored_camo)


	if(C.digitalcamo)
		to_chat(C, SPAN_NOTICE("You return to normal."))
		C.digitalcamo -= stored_camo

		if(istype(revenant))
			revenant.trackers["stored digital camo"] = 0

	else
		to_chat(C, SPAN_NOTICE("You Distort your form to prevent AI-tracking."))
		C.digitalcamo = ( (isnull(C.digitalcamo) ? 0 : C.digitalcamo) + 1 )

		if(istype(revenant))
			revenant.trackers["stored digital camo"] = 1

	src.verbs -= /mob/proc/bsrevenant_digitalcamo
	spawn(5)	src.verbs += /mob/proc/bsrevenant_digitalcamo
	SSstatistics.add_field_details("bsrevenant_powers","CAM")
	return 1


/datum/bluespace_revenant/proc/ProcessDigitalCamo(var/ticks = 1)
	// If we have digicamo on, increase distortion

	if(isnull(src.trackers))
		src.trackers = list()

	// We'll grab this from a tracker, not a mob - so that if the mob has ling/item digicamo
	// we don't attribute that to a Revenant power
	var/digicamo_responsibility = src.trackers["stored digital camo"]

	if(digicamo_responsibility)
		// Doubles our baseline Distortion generation!
		src.total_distortion += (_distortion_per_tick * ticks)

	return


/datum/power/revenant/bs_power/digicamo
	flavor_tags = list(
		BSR_FLAVOR_GENERIC,
		BSR_FLAVOR_VAMPIRE, // the no mirrors/shadow thingy
		BSR_FLAVOR_BLUESPACE,
		BSR_FLAVOR_SCIFI
	)
	name = "Anomalous Digicamo"
	isVerb = TRUE
	verbpath = /mob/proc/bsrevenant_digitalcamo
	activate_message = ("<span class='notice'>Cameras seem to act erratically around you. If you allow reality to bend a bit harder, you could amplify this effect and disrupt their tracking systems...</span>")
	distortion_threshold = 18000 // 15 mins


/datum/power/revenant/bs_power/digicamo/Activate(var/datum/mind/M)
	. = ..(M)

	if(!.)
		return

	if(!M.bluespace_revenant)
		return FALSE

	if(isnull(M.bluespace_revenant.callbacks))
		M.bluespace_revenant.callbacks = list()

	if(!(/datum/bluespace_revenant/proc/ProcessRuneWards in M.bluespace_revenant.callbacks))
		M.bluespace_revenant.callbacks.Add(/datum/bluespace_revenant/proc/ProcessDigitalCamo)

	return



/* TECHDISCORD - Technology does not like us - sparks. */
/datum/power/revenant/distortion/techdiscord
	flavor_tags = list(
		BSR_FLAVOR_GENERIC,
		BSR_FLAVOR_SCIFI,
		BSR_FLAVOR_BLUESPACE
	)
	name = "DISTORTION: Machine Discord"


/datum/power/revenant/distortion/techdiscord/Apply(var/atom/A, var/datum/bluespace_revenant/revenant)
	// 0
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


/* TECHBANE - Technology *hates* us - EMP and sparks. */
/datum/power/revenant/distortion/techbane
	flavor_tags = list(
		BSR_FLAVOR_SCIFI,
		BSR_FLAVOR_DARK,
		BSR_FLAVOR_BLUESPACE
	)
	name = "DISTORTION: Techbane"


/datum/power/revenant/distortion/techbane/Apply(var/atom/A, var/datum/bluespace_revenant/revenant)
	//
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


/* FLICKER - Mess up nearby fluorescents. */
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

	var/ran = FALSE

	for(var/datum/light_source/LS in T.affecting_lights)
		var/obj/machinery/light/FL = LS.source_atom

		if(istype(FL))
			FL.flicker(3)
			ran = TRUE

	return ran



/* STATIC - will spawn a static overlay; purely visual */
/datum/power/revenant/distortion/noisefx
	flavor_tags = list(
		BSR_FLAVOR_SCIFI,
		BSR_FLAVOR_GENERIC,
		BSR_FLAVOR_BLUESPACE,
		BSR_FLAVOR_SPACE
	)
	name = "DISTORTION - Spatiotemporal Interference"


/datum/power/revenant/distortion/noisefx/Apply(var/atom/A, var/datum/bluespace_revenant/revenant)
	if(isnull(A) || !istype(A))
		return

	var/turf/T = get_turf(A)
	if(!istype(T))
		return

	var/randicon = rand(1, 9)
	var/duration = rand(30 SECONDS, 90 SECONDS)
	var/obj/effect/temporary/staticeffect = new (T, duration, 'icons/effects/static.dmi', "[randicon] light")

	if(istype(staticeffect))
		return TRUE

	return

