
/proc/Raytrace(var/atom/From, var/atom/To, var/CheckBlock = null, var/list/ignore = null, var/raytype = null, var/dispersion = null, var/check_glancing_angles = TRUE)
	// Heavily based on: https://web.archive.org/web/20230119153820/https://playtechs.blogspot.com/2007/03/raytracing-on-grid.html
	//
	// Follows a straight line between two atoms, then walks every tile intersected by the line.
	// Checks each entered tile for collisions using a user-specified proc (CheckBlock)
	// Optionally ignores any entities specified in the ignore list - so that we don't shoot *ourselves*

	if(!(From && To))
		return FALSE

	if(From.z != To.z)
		// 2D only for now
		return FALSE

	var/startX = From.x
	var/endX = To.x

	var/startY = From.y
	var/endY = To.y

	var/dX = (endX - startX)
	var/dY = (endY - startY)

	var/curr_angle = arctan(dX, dY)

	if(!isnull(dispersion))
		var/angle_err = (rand() - 0.5) * dispersion
		curr_angle += angle_err
		curr_angle = CLOCKWISE_ANGLE(curr_angle)

		var/og_magnitude = sqrt(SQR(dX) + SQR(dY))

		dX = cos(curr_angle) * og_magnitude
		dY = sin(curr_angle) * og_magnitude

	var/dXabs = abs(dX)
	var/dYabs = abs(dY)

	var/currX = startX
	var/currY = startY

	//var/n = (dXabs + dYabs)

	var/stepX = ((endX > startX) ? 1 : -1)
	var/stepY = ((endY > startY) ? 1 : -1)

	var/error = (dXabs - dYabs)
	var/blocker = null

	var/absSlope = null // slope is cheaper than atan() and does the job

	if(dXabs > 0 && dYabs > 0)
		// guarding against undefined states; null absSlope here means a straight X or Y axis line
		absSlope = abs(dY / dX)

	dXabs *= 2
	dYabs *= 2

	var/maxX = world.maxx
	var/maxY = world.maxy

	while(currX > 1 && currX < maxX && currY > 1 && currY < maxY)
		sleep(-1)

		if(!isnull(CheckBlock))
			blocker = call(CheckBlock)(currX, currY, From.z, curr_angle, ignore, raytype, To)

		if(!isnull(blocker))
			RAYTRACE_DEBUG_LOG("Blocker [blocker] @ ([currX], [currY]) / [absSlope] == [curr_angle]")

			if(istype(blocker, /turf))
				// turfs cover the whole tile, no glancing off
				return blocker

			if(blocker == To)
				return blocker

			if(check_glancing_angles)
				/* We don't want hits that are visually 'off', where we rasterize a tile but the ray
				// does not actually intersect the target object - hence some extra checks.
				//
				// As a rough guideline, we want to hit a equilateral diamond shape
				// whose edges connect points +/- 0.5 tile on both axes, like so:
				//
				//     |----- TILE ----->
				//
				//  -  #########@########
				//  |  #      @/ \@     #
				//  T  #   /@/     \@\  #
				//  I  # @/          \@ #
				//  L  @<              >@
				//  E  # @\           @/#
				//  |  #   \@\     /@/  #
				//  |  #      @\ /@     #
				//  v  #########@########
				//
				// ...unless we know the collider takes up the whole tile (turfs do, usually, so might machinery)
				*/
				if(isnull(absSlope))
					// head-on hit, either from X- or Y-axis.
					return blocker

				if( abs((curr_angle % 90) - 45) < 5 && (abs(currX - startX) == abs(currY - startY)) )
					// at 45 degrees, ignore evil rasterizations that pass through one corner of a tile twice
					// otherwise, if offsets on X & Y are equal, valid 45-degree diagonal hit.
					return blocker

				if( abs((curr_angle % 90) - 15) < 5 )
					// good hits, approx. <20 degrees
					return blocker

				/* // old, slope-based calculation
				if(absSlope == 1 && (abs(currX - startX) == abs(currY - startY)))
					// at 45 degrees, ignore evil rasterizations that pass through one corner of a tile twice
					// otherwise, if offsets on X & Y are equal, valid 45-degree diagonal hit.
					return blocker

				if(absSlope <= 0.4)
					// good hits on the horizontal, approx. <20 degrees
					return blocker

				if(absSlope >= 5)
					// good hits on the vertical, approx. >80 degrees
					return blocker

				// (0.4; 5) range visually
				*/
			else
				return blocker

		if(error > 0)
			currX += stepX
			error -= dYabs

		else
			currY += stepY
			error += dXabs

	var/reachedX = (currX == endX)
	var/reachedY = (currY == endY)

	if(isnull(blocker))
		var/turf/endturf = locate(FLOOR(currX), FLOOR(currY), From.z)
		RAYTRACE_DEBUG_LOG("Returning final turf [endturf]")
		blocker = endturf

	return ((reachedX && reachedY) ? To : blocker)


/proc/basicBlockCheck(var/x, var/y, var/z, var/angle, var/list/ignored = null, var/raytype = null, var/atom/target = null)
	var/_raytype = isnull(raytype) ? DEFAULT_RAYTYPE : raytype

	if(!(_raytype & RAYFLAG_TURFBLOCK))
		// no point checking the rest
		return null

	var/has_ignored = !(isnull(ignored) && istype(ignored) && ignored.len)

	var/baseX = round(x, 1)
	var/baseY = round(y, 1)

	var/turf/blockturf = locate(baseX, baseY, z)

	if(blockturf && istype(blockturf))
		if(has_ignored && !(blockturf in ignored) && blockturf.density > 0)
			return blockturf

	return null


/proc/denseCheck(var/x, var/y, var/z, var/angle, var/list/ignored = null, var/raytype = null, var/atom/target = null)
	var/_raytype = isnull(raytype) ? DEFAULT_RAYTYPE : raytype

	if((_raytype == RAYTYPE_UNSTOPPABLE))
		// no point checking the rest
		return FALSE

	var/baseX = round(x, 1)
	var/baseY = round(y, 1)

	var/turf/blockturf = locate(baseX, baseY, z)

	var/has_ignored = (istype(ignored) && ignored.len)

	var/check_opaque = _raytype & RAYFLAG_OPAQUEBLOCK
	var/check_transparent = _raytype & RAYFLAG_TRANSPARENTBLOCK
	var/check_dense_objects = (check_opaque || check_transparent)

	if(istype(blockturf))
		if((_raytype & RAYFLAG_TURFBLOCK) && blockturf.density)
			// Optimization: only check membership if we NEED to potentially ignore it
			// Non-dense items are ignored regardless!
			if(has_ignored && !(blockturf in ignored))
				return blockturf

		for(var/atom/movable/A in blockturf)
			if(!isnull(target) && A == target)
				return A

			// Optimization: only check membership if we NEED to potentially ignore it
			// Non-dense items are ignored regardless!
			if(has_ignored && (A in ignored))
				continue

			if(A.density && check_dense_objects)
				if(A.opacity)
					if(!check_opaque)
						continue

				else if(!check_transparent)
					continue

				if(!(_raytype & RAYFLAG_RANDCOVERBLOCK) && (A.raycast_block_all != RAYCAST_BLOCK_ALL))
					// Skip partial covers if we don't care about that
					continue

				if(!(A.GetRaycastCoverage(angle)))
					// Atoms can have a random %chance to act as a blocker.
					continue

				return A

	return null


/proc/denseCheckLogged(var/x, var/y, var/z, var/angle, var/list/ignored = null, var/raytype = null, var/atom/target = null)
	var/_raytype = isnull(raytype) ? DEFAULT_RAYTYPE : raytype

	if((_raytype == RAYTYPE_UNSTOPPABLE))
		// no point checking the rest
		to_world_log("RAYTRACE: Ray is unstoppable, returning FALSE")
		return FALSE

	var/baseX = round(x, 1)
	var/baseY = round(y, 1)

	var/turf/blockturf = locate(baseX, baseY, z)

	var/has_ignored = (istype(ignored) && ignored.len)

	var/check_opaque = _raytype & RAYFLAG_OPAQUEBLOCK
	var/check_transparent = _raytype & RAYFLAG_TRANSPARENTBLOCK
	var/check_dense_objects = (check_opaque || check_transparent)

	if(istype(blockturf))
		if((_raytype & RAYFLAG_TURFBLOCK) && blockturf.density)
			// Optimization: only check membership if we NEED to potentially ignore it
			// Non-dense items are ignored regardless!
			if(has_ignored && !(blockturf in ignored))
				to_world_log("RAYTRACE: Returning dense turf blocker [blockturf]")
				return blockturf

		for(var/atom/movable/A in blockturf)
			if(!isnull(target) && A == target)
				to_world_log("RAYTRACE: Returning target blocker [A]")
				return A

			// Optimization: only check membership if we NEED to potentially ignore it
			// Non-dense items are ignored regardless!
			if(has_ignored && (A in ignored))
				to_world_log("RAYTRACE: Ignoring ignorelist item [A]")
				continue

			if(A.density && check_dense_objects)
				if(A.opacity)
					if(!check_opaque)
						to_world_log("RAYTRACE: Skipping opaque object [A] since check_opaque is [check_opaque]")
						continue

				else if(!check_transparent)
					to_world_log("RAYTRACE: Skipping opaque object [A] since check_transparent is [check_transparent]")
					continue

				if(!(_raytype & RAYFLAG_RANDCOVERBLOCK) && (A.raycast_block_all != RAYCAST_BLOCK_ALL))
					// Skip partial covers if we don't care about that
					to_world_log("RAYTRACE: Skipping partial cover object [A] since A.raycast_block_all is [A.raycast_block_all]")
					continue

				if(!(A.GetRaycastCoverage(angle)))
					// Atoms can have a random %chance to act as a blocker.
					to_world_log("RAYTRACE: Skipping partial cover object [A] since RNGesus decided it's not a cover today for angle [angle]")
					continue

				return A

			else
				to_world_log("RAYTRACE: Skipping non-dense object [A] since check_opaque is [check_opaque] and check_transparent is [check_transparent]")

	return null


/proc/TurfDensityRaytrace(var/atom/From, var/atom/To, var/list/ignored = null, var/raytype = null, var/dispersion = null, var/check_glancing_angles = TRUE)
	// Effectively a partial function on Raytrace, for convenience usage
	return Raytrace(From, To, /proc/basicBlockCheck, ignored, dispersion, check_glancing_angles)


/proc/AtomDensityRaytrace(var/atom/From, var/atom/To, var/list/ignored = null, var/raytype = null, var/dispersion = null, var/check_glancing_angles = TRUE)
	// Effectively a partial function on Raytrace, for convenience usage
	return Raytrace(From, To, /proc/denseCheck, ignored, raytype, dispersion, check_glancing_angles)


/proc/AtomDensityRaytraceLogged(var/atom/From, var/atom/To, var/list/ignored = null, var/raytype = null, var/dispersion = null, var/check_glancing_angles = TRUE)
	// Effectively a partial function on Raytrace, for convenience usage
	return Raytrace(From, To, /proc/denseCheckLogged, ignored, raytype, dispersion, check_glancing_angles)
