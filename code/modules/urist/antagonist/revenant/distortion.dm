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

	// Thresholds
	var/_threshold_threetile = BSR_THRESHOLD_RADIUS_THREETILES
	var/_threshold_fivetile = BSR_THRESHOLD_RADIUS_FIVETILES
	var/_threshold_seventile = BSR_THRESHOLD_RADIUS_SEVENTILES

	// Effective radius to spread Distortion to; 0 means 'current pos only' on any of the XYZ axes.
	var/distortion_radius_xy = 1 // 2D radius
	var/distortion_radius_z = 1 // across Z-levels

	// Effectively, power level accumulated. Unlocks powers. Increases over time.
	var/total_distortion = 0

	// Reduction in Distortion 'leaking out'. Indulging Hungers increases this.
	var/suppressed_distortion = 0

	// Helper - cache the last total Distortion added to turfs for mob verbs to inspect.
	var/last_tick_distortion_total = 0

	// Helper - cache the last number of turfs processed to calculate an average
	var/last_tick_distortion_tiles = 0


/datum/bluespace_revenant/proc/get_effective_distortion(total_distortion_override = null, suppressed_distortion_override = null)
	var/raw_true_total_distortion = (isnull(total_distortion_override) ? src.total_distortion : total_distortion_override)
	var/raw_true_suppressed_distortion = (isnull(suppressed_distortion_override) ? src.suppressed_distortion : suppressed_distortion_override)

	var/true_total_distortion = max(0, raw_true_total_distortion)
	var/true_suppressed_distortion = max(0, raw_true_suppressed_distortion)

	var/raw_effective_distortion = (true_total_distortion - true_suppressed_distortion)
	var/effective_distortion = max(0, raw_effective_distortion)

	return effective_distortion


/datum/bluespace_revenant/proc/HandleDistortionUpdates(ticks = 1)
	src.total_distortion += (src._distortion_per_tick * ticks)
	var/safe_distortion = max(src.total_distortion, 0)

	switch(safe_distortion)

		if(0 to BSR_THRESHOLD_RADIUS_THREETILES)
			distortion_radius_xy = 1

		if(BSR_THRESHOLD_RADIUS_THREETILES + 1 to BSR_THRESHOLD_RADIUS_FIVETILES)
			distortion_radius_xy = 2

		if(BSR_THRESHOLD_RADIUS_FIVETILES + 1 to BSR_THRESHOLD_RADIUS_SEVENTILES)
			distortion_radius_xy = 3

		else
			distortion_radius_xy = 4

	return


/datum/bluespace_revenant/proc/get_distortion_rate()
	var/curr_bsrev_effective_distortion = (src.get_effective_distortion() || 0)
	var/distortion_base_rate = (curr_bsrev_effective_distortion ** 0.5) / 100
	return distortion_base_rate


/datum/bluespace_revenant/proc/SpreadDistortion(ticks = 1)
	set waitfor = FALSE

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

	var/distortion_base_rate = src.get_distortion_rate()
	var/total_per_turf_distortion = distortion_base_rate * ticks

	var/turf/startTurf = locate(start_x, start_y, start_z)
	var/turf/endTurf = locate(end_x, end_y, end_z)

	// Caching stuff
	src.last_tick_distortion_tiles = 0
	src.last_tick_distortion_total = 0

	for(var/turf/simulated/T in block(startTurf, endTurf))
		// Don't block stuff if this takes a while.
		sleep(0)

		// Let's only do simulated turfs for now - potentially less work & won't mess up eventey bits
		if(!istype(T))
			BSR_DEBUG_LOG("BSR: Block item [T] is not a valid sim turf")
			continue

		if(!(isStationLevel(T.z) || src_turf.z == T.z))
			// To prevent weird transmission between z-levels that are NOT meant to be actually adjacent in Euclidean space
			// We'll still spread Distortion while we're actually ON these levels though.
			continue

		var/manhattan_dist = (abs(T.x - src_turf.x) + abs(T.y - src_turf.y))
		if(distortion_radius_z)
			manhattan_dist = manhattan_dist + abs(T.z - src_turf.z)

		if(manhattan_dist > safe_distortion_radius_xy)
			continue

		BSR_DEBUG_LOG("BSR: SpreadDistortion processing turf [T], adding [total_per_turf_distortion] Distortion")
		T.reality_distortion += total_per_turf_distortion
		src.HandleDistortionFX(T)

		src.last_tick_distortion_tiles++
		src.last_tick_distortion_total += T.reality_distortion

	return
