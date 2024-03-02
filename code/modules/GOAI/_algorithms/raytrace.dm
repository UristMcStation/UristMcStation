# ifdef RAYTRACE_DEBUG_LOGGING
# define RAYTRACE_DEBUG_LOG(X) to_world_log(X)
# else
# define RAYTRACE_DEBUG_LOG(X)
# endif

/proc/Raytrace(var/atom/From, var/atom/To, var/CheckBlock = null, var/list/ignore = null)
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

	var/dXabs = abs(dX)
	var/dYabs = abs(dY)

	var/currX = startX
	var/currY = startY

	var/n = (dXabs + dYabs)

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

	while(n --> 0)
		RAYTRACE_DEBUG_LOG("([currX], [currY]) @ [n], [error]")
		sleep(-1)

		if(!isnull(CheckBlock))
			blocker = call(CheckBlock)(currX, currY, From.z, ignore)

		if(blocker)
			RAYTRACE_DEBUG_LOG("Blocker [blocker] @ ([currX], [currY]) / [absSlope] == [arctan(absSlope)]")
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
				break

			if(istype(blocker, /turf))
				// turfs cover the whole tile, no glancing off
				break

			if(absSlope == 1 && (abs(currX - startX) == abs(currY - startY)))
				// at 45 degrees, ignore evil rasterizations that pass through one corner of a tile twice
				// otherwise, if offsets on X & Y are equal, valid 45-degree diagonal hit.
				break

			if(absSlope <= 0.4)
				// good hits on the horizontal, approx. <20 degrees
				break

			if(absSlope >= 5)
				// good hits on the vertical, approx. >80 degrees
				break

			// (0.4; 5) range visually

		RAYTRACE_DEBUG_LOG("VisitX [currX], VisitY [currY]")

		if(error > 0)
			currX += stepX
			error -= dYabs

		else
			currY += stepY
			error += dXabs

	var/reachedX = (currX == endX)
	var/reachedY = (currY == endY)

	return ((reachedX && reachedY) ? To : blocker)


/proc/basicBlockCheck(var/x, var/y, var/z, var/list/ignored = null)
	var/turf/blockturf = locate(x, y, z)
	var/has_ignored = !(isnull(ignored) && istype(ignored) && ignored.len)

	if(blockturf && istype(blockturf))
		if(has_ignored && !(blockturf in ignored) && blockturf.density > 0)
			return blockturf

	return FALSE


/proc/denseCheck(var/x, var/y, var/z, var/list/ignored = null)
	var/turf/blockturf = locate(x, y, z)
	var/has_ignored = !(isnull(ignored) && istype(ignored) && ignored.len)

	if(blockturf && istype(blockturf))
		if(blockturf.density > 0)
			// Optimization: only check membership if we NEED to potentially ignore it
			// Non-dense items are ignored regardless!
			if(has_ignored && !(blockturf in ignored))
				return blockturf

		for(var/atom/movable/A in blockturf)
			if(A?.density > 0)
				// Optimization: only check membership if we NEED to potentially ignore it
				// Non-dense items are ignored regardless!
				if(has_ignored && (A in ignored))
					continue

				return A

	return FALSE


/proc/TurfDensityRaytrace(var/atom/From, var/atom/To, var/list/ignored = null)
	// Effectively a partial function on Raytrace, for convenience usage
	return Raytrace(From, To, /proc/basicBlockCheck, ignored)


/proc/AtomDensityRaytrace(var/atom/From, var/atom/To, var/list/ignored = null)
	// Effectively a partial function on Raytrace, for convenience usage
	return Raytrace(From, To, /proc/denseCheck, ignored)
