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



/datum/power/revenant/distortion/spatial_instability
	flavor_tags = list(
		BSR_FLAVOR_SPACE,
		BSR_FLAVOR_SCIFI,
		BSR_FLAVOR_BLUESPACE,
		BSR_FLAVOR_GENERIC
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

	var/newPosX = clamp(AposX + rand(-2, 2), 0, world.maxx)
	var/newPosY = clamp(AposY + rand(-2, 2), 0, world.maxx)

	var/turf/T = locate(newPosX, newPosY, A.z)
	if(!istype(T))
		return

	var/mob/M = revenant.mob_ref?.resolve()
	if(!istype(M))
		return

	M.dizziness += rand(1, 3)
	to_chat(M, "<span class='warning'>You feel dizzy as your body suddenly jostles through spacetime!</span>")
	M.buckled = null
	M.forceMove(T)

	return


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

