/* REALITY DISTORTION
//
// Revenants are severely anomalous; they act as a source of 'pseudo-radiation' that corrupts reality in a radius around them.
//
// In practical terms, we track an extra numeric variable representing how corrupted nearby atoms are.
// Above a threshold value, we randomly trigger effects that represent the Creeping Spoop.
//
// Design-wise, this is a localized effect to disincentivize hiding in a closet or hanging out and doing your job
// the whole shift, and on the flipside complicates Revenants' containment by Security/Science.
*/

/turf
	var/reality_distortion = 0


/datum/bluespace_revenant
	/* Partial definition for distortioney bits! See revenant_datum.dm for main defintion! */

	// Distortion increase *per tick_time*
	var/_distortion_per_tick = BSR_DEFAULT_DISTORTION_PER_TICK

	// Effective radius to spread Distortion to; 0 means 'current pos only' on any of the XYZ axes.
	var/distortion_radius_xy = 1 // 2D radius
	var/distortion_radius_z = 0 // across Z-levels

	// Effectively, power level accumulated. Unlocks powers. Increases over time.
	var/total_distortion = 0

	// Reduction in Distortion 'leaking out'. Indulging Hungers increases this.
	var/suppressed_distortion = 0


/datum/bluespace_revenant/proc/get_effective_distortion(var/total_distortion_override = null, var/suppressed_distortion_override = null)
	var/raw_true_total_distortion = (isnull(total_distortion_override) ? src.total_distortion : total_distortion_override)
	var/raw_true_suppressed_distortion = (isnull(suppressed_distortion_override) ? src.suppressed_distortion : suppressed_distortion_override)

	var/true_total_distortion = max(0, raw_true_total_distortion)
	var/true_suppressed_distortion = max(0, raw_true_suppressed_distortion)

	var/raw_effective_distortion = (true_total_distortion - true_suppressed_distortion)
	var/effective_distortion = max(0, raw_effective_distortion)

	return effective_distortion


/datum/bluespace_revenant/proc/HandleDistortionUpdates(var/ticks = 1)
	src.total_distortion += (src._distortion_per_tick * ticks)
	var/safe_distortion = max(src.total_distortion, 0)

	switch(safe_distortion)

		if(0 to BSR_THRESHOLD_RADIUS_THREETILES)
			distortion_radius_xy = 0

		if(BSR_THRESHOLD_RADIUS_THREETILES + 1 to BSR_THRESHOLD_RADIUS_FIVETILES)
			distortion_radius_xy = 1

		if(BSR_THRESHOLD_RADIUS_FIVETILES + 1 to BSR_THRESHOLD_RADIUS_SEVENTILES)
			distortion_radius_xy = 2

		else
			distortion_radius_xy = 3

	return


/datum/bluespace_revenant/proc/SpreadDistortion(var/ticks = 1)
	if(isnull(src.mob_ref))
		BSR_DEBUG_LOG("BSR: SpreadDistortion ERROR: mob_ref [src.mob_ref] is null!")
		return

	var/mob/M = src.mob_ref.resolve()
	if(!istype(M))
		BSR_DEBUG_LOG("BSR: SpreadDistortion ERROR: mob [M] is invalid!")
		src.mob_ref = null
		return

	var/turf/src_turf = get_turf(M)
	if(!istype(src_turf))
		BSR_DEBUG_LOG("BSR: SpreadDistortion ERROR: mob turf [src_turf] is invalid!")
		return

	var/safe_distortion_radius_xy = max(src.distortion_radius_xy || 0, 0)
	var/safe_distortion_radius_z = max(src.distortion_radius_z || 0, 0)

	var/start_x = max(1, src_turf.x - safe_distortion_radius_xy)
	var/end_x = min(world.maxx, src_turf.x + safe_distortion_radius_xy)

	var/start_y = max(1, src_turf.y - safe_distortion_radius_xy)
	var/end_y = min(world.maxy, src_turf.y + safe_distortion_radius_xy)

	var/start_z = max(1, src_turf.z - safe_distortion_radius_z)
	var/end_z = min(world.maxy, src_turf.z + safe_distortion_radius_z)

	var/curr_bsrev_effective_distortion = (src.get_effective_distortion() || 0)
	var/distortion_base_rate = (curr_bsrev_effective_distortion ** 0.5) / 100

	var/total_per_turf_distortion = distortion_base_rate * ticks

	var/turf/startTurf = locate(start_x, start_y, start_z)
	var/turf/endTurf = locate(end_x, end_y, end_z)

	spawn(0)
		// Fork off so we don't block stuff if this takes a while.

		for(var/turf/simulated/T in block(startTurf, endTurf))
			// Let's only do simulated turfs for now - potentially less work & won't mess up eventey bits
			if(!istype(T))
				BSR_DEBUG_LOG("BSR: Block item [T] is not a valid sim turf")
				continue

			var/manhattan_dist = (abs(T.x - src_turf.x) + abs(T.y - src_turf.y))
			if(manhattan_dist > safe_distortion_radius_xy)
				BSR_DEBUG_LOG("BSR: Block item [T] - outside of Manhattan Distance range")
				continue

			BSR_DEBUG_LOG("BSR: SpreadDistortion processing turf [T], adding [total_per_turf_distortion] Distortion")
			T.reality_distortion += total_per_turf_distortion
			src.HandleDistortionFX(T)

	return
