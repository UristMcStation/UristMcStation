/turf
	// Used by AI.
	// Any AI that fails to path to this turf will bump the penalty a bit,
	// discouraging future AIs from trying to path here.
	// This is fuzzy and incremental, so a one-off failure should disqualify a turf forever.
	var/unreachable_penalty = 0

# ifdef GOAI_LIBRARY_FEATURES

/turf/ground
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"


/turf/ground/New()
	. = ..()
	name += " ([x], [y], [z])"


/turf/wall
	density = TRUE
	opacity = TRUE
	icon = 'icons/urist/turf/walls.dmi'
	icon_state = "stone0"

	var/is_pillar = FALSE
	var/is_corner = FALSE


/turf/wall/New()
	. = ..()
	name += " ([x], [y])"

	var/list/adjacents = src.CardinalTurfs(FALSE, FALSE, FALSE)
	var/dense_conn = 0
	var/dense_neighbors = 0

	for(var/turf/neigh in adjacents)
		if(neigh.IsBlocked(FALSE))
			dense_conn |= get_dir(neigh, src)
			dense_neighbors++

	switch(dense_neighbors)
		if(0)
			is_pillar = TRUE

		if(1)
			is_corner = TRUE

		if(2)
			var/list/dir_pairs = list(0, NORTH|SOUTH, EAST|WEST)
			// if NORTH|SOUTH or WEST|EAST, it's a line; otherwise, corner
			if(!(dense_conn in dir_pairs))
				is_corner = TRUE
				name += " <corner>"

	name += " <dense: [dense_conn], [is_corner]>"
	icon_state = "stone[dense_conn]"


/proc/trange(rad = 0, turf/centre = null) //alternative to range (ONLY processes turfs and thus less intensive)
	if(!centre)
		return

	var/turf/x1y1 = locate(((centre.x-rad)<1 ? 1 : centre.x-rad),((centre.y-rad)<1 ? 1 : centre.y-rad),centre.z)
	var/turf/x2y2 = locate(((centre.x+rad)>world.maxx ? world.maxx : centre.x+rad),((centre.y+rad)>world.maxy ? world.maxy : centre.y+rad),centre.z)
	return block(x1y1,x2y2)


/turf/proc/ObjectBlocked()
	// simplified version of the SS13 logic
	// TODO: add directional logic for flipped tables etc.

	for(var/obj/object in src.contents)
		if(!object.density)
			continue

		if(object.density)
			return TRUE

	return FALSE

/turf/proc/AdjacentTurfs(var/check_blockage = TRUE, var/check_links = TRUE, var/check_objects = TRUE)
	var/list/adjacents = list()
	var/turf/src_turf = get_turf(src)

	for(var/turf/t in (trange(1,src) - src))
		if(check_blockage)
			if(!(t.IsBlocked(check_objects)))
				if(!(check_links && GoaiLinkBlocked(src_turf, t)))
					adjacents += t
		else
			adjacents += t

	return adjacents


/turf/proc/CardinalTurfs(var/check_blockage = TRUE, var/check_links = TRUE, var/check_objects = TRUE)
	var/list/adjacents = list()

	for(var/ad in AdjacentTurfs(check_blockage, check_links, check_objects))
		var/turf/T = ad
		if(T.x == src.x || T.y == src.y)
			adjacents += T

	return adjacents


/turf/proc/Distance(var/T)
	var/turf/t = T
	if(t && get_dist(src,t) == 1)
		var/cost = (src.x - t.x) * (src.x - t.x) + (src.y - t.y) * (src.y - t.y)
		cost *= (pathweight+t.pathweight)/2
		return cost
	else
		return get_dist(src, T)


/world
	turf = /turf/ground


# endif


/proc/GoaiLinkBlocked(var/turf/A, var/turf/B)
	if(A == null || B == null) return TRUE
	var/adir = get_dir(A,B)
	var/rdir = get_dir(B,A)

	if((adir & (NORTH|SOUTH)) && (adir & (EAST|WEST)))	//	diagonal
		var/iStep = get_step(A,adir&(NORTH|SOUTH))
		if(!GoaiLinkBlocked(A,iStep) && !GoaiLinkBlocked(iStep,B)) return FALSE

		var/pStep = get_step(A,adir&(EAST|WEST))
		if(!GoaiLinkBlocked(A,pStep) && !GoaiLinkBlocked(pStep,B)) return FALSE
		return TRUE

	if(GoaiDirBlocked(A,adir))
		return TRUE

	if(GoaiDirBlocked(B,rdir))
		return TRUE

	return FALSE


/turf/proc/GoaiObjectBlocked(var/check_objects_permissive = FALSE)
	// simplified version of the SS13 logic
	// TODO: add directional logic for flipped tables etc.

	for(var/obj/object in src.contents)
		if(!object.density)
			continue

		# ifdef GOAI_SS13_SUPPORT
		/*
		// This warrants some explaining.
		// The railings are usually used to make stairs look nicer.
		// The railings are also an absolute blight upon multi-Z pathfinding.
		// I don't quite know WHY, but I currently do not have time to fix it at source.
		// I also don't want to enable object-permissive mode by default. So, it's a weird special case for now.
		var/obj/structure/railing/stupid_railing = object
		if(istype(stupid_railing))
			continue
		*/
		# endif

		if(check_objects_permissive)
			var/mob/M = object
			if(istype(M))
				continue

			# ifdef GOAI_SS13_SUPPORT

			var/obj/machinery/door/D = object
			if(istype(D))
				continue

			# endif

			# ifdef GOAI_LIBRARY_FEATURES

			var/obj/cover/door/D = object
			if(istype(D))
				continue

			var/obj/cover/autodoor/AD = object
			if(istype(AD))
				continue

			var/obj/cover/table/T = object
			if(istype(T))
				continue

			# endif

		if(object.density)
			return TRUE

	return FALSE


/proc/GoaiDirBlocked(var/atom/trg, var/in_dir = null, var/out_dir = null)
	for(var/atom/D in trg)
		var/datum/directional_blocker/dirblocker = D.GetBlockerData(TRUE, TRUE)

		if(isnull(dirblocker))
			continue

		if((!isnull(in_dir)) && dirblocker.BlocksEntry(in_dir))
			// Can we enter from this direction
			return TRUE

		if((!isnull(out_dir)) && dirblocker.BlocksExit(out_dir))
			// Can we exit in this direction
			return TRUE

		// If both in & out dirs are not null, this is a 'tunnel' query
		// (i.e. 'can you (not) pass through this tile in this manner)

	return FALSE


/turf/proc/IsBlocked(var/check_objects = FALSE, var/check_objects_permissive = FALSE)
	if(src.density)
		return TRUE

	if(check_objects && src.GoaiObjectBlocked(check_objects_permissive))
		return TRUE

	return FALSE


# ifdef GOAI_SS13_SUPPORT
# ifdef GOAI_MULTIZ_ASTAR
//Checks for directional blockages at the base of the stairs leading up, open space above, and that nothing is blocking the exit point. Returns 1 on fail
/proc/LinkBlockedAboveGoai(turf/lower, var/turf/simulated/open/upper, var/dir)
	if(!istype(upper))
		return 1

	for(var/obj/A in lower)
		if(!A.density)
			continue
		if(istype(A,/obj/structure/window) || istype(A,/obj/structure/railing))
			if(A.dir == dir)
				return 1
		else
			return 1

	var/turf/exit = get_step(upper, dir)

	if(exit.density)
		return 1

	if(GoaiLinkBlocked(upper, exit))
		return 1

	/*
	// old ss13 code, GoaiLinkBlocked() SHOULD be handling these

	for(var/obj/B in exit)
		if(!B.density)
			continue
		if(istype(B,/obj/structure/window) || istype(B,/obj/structure/railing))
			if(B.dir == GLOB.reverse_dir[dir])
				return 1
		else
			return 1
	*/

	return 0
# endif
# endif


// NOTE: the f-prefix stands for 'functional' (i.e. not bound method)
/proc/fAdjacentTurfs(var/turf/start, var/check_blockage = TRUE, var/check_links = TRUE, var/check_objects = TRUE, var/check_objects_permissive = FALSE, var/threeD = TRUE)
	if(!istype(start))
		return

	var/list/adjacents = list()
	var/turf/start_turf = get_turf(start)

	# ifdef GOAI_MULTIZ_ASTAR
	var/skipDirs = 0

	/* Handle pits/stairs going down */
	var/turf/simulated/open/pitTurf = start
	if(istype(pitTurf))
		# ifdef GOAI_LIBRARY_FEATURES
		var/turf/below = pitTurf.GetBelow()

		if(below)
			// we'll fall through so the adjacent turf (the potential start for the next iteration) is where we *land*
			adjacents.Add(below)
			// early out, there cannot be any more adjacents because our only option is to fall through or not look at this turf at all
			return adjacents
		# endif

		# ifdef GOAI_SS13_SUPPORT
		var/turf/below = pitTurf.below
		if(below)
			if(!(below.density || LinkBlockedAboveGoai(below, start_turf) || locate(/obj/structure/lattice) in start_turf))
				// we'll fall through so the adjacent turf (the potential start for the next iteration) is where we *land*
				adjacents.Add(below)
				// early out, there cannot be any more adjacents because our only option is to fall through or not look at this turf at all
				return adjacents
		# endif

	/* Handle stairs going up */
	var/obj/structure/stairs/Stair = locate(/obj/structure/stairs) in start_turf

	if(istype(Stair))
		# ifdef GOAI_LIBRARY_FEATURES
		var/turf/Upstairs = Stair.above

		if(Upstairs)
			adjacents.Add(Upstairs)
			// ONLY add the upstairs in this direction
			skipDirs |= Stair.dir
			//return adjacents
		# endif

		# ifdef GOAI_SS13_SUPPORT
		var/turf/Upstairs = GetAbove(Stair)
		if(Upstairs)
			// This is so dumb.
			// Some subtypes of stairs have atypical bounds_width/bounds_height.
			// BYOND's contents var stores all objects whose bounds overlap
			// So in those cases, we need to make sure we don't have the adjacent, 'true' stair.
			// If we do, then we need to treat these as a normal floor tile. Otherwise, go up a Z.
			var/turf/stairsibling_turf = get_step(start_turf, Stair.dir)
			var/obj/structure/stairs/stair_sibling = locate(/obj/structure/stairs) in stairsibling_turf

			if(stair_sibling != Stair && !LinkBlockedAboveGoai(start_turf, Upstairs, Stair.dir))
				// slightly funky - we need clearance one tile FURTHER than where the stair is
				adjacents.Add(get_step(Upstairs, Stair.dir))
				// ONLY add the upstairs in this direction
				skipDirs |= Stair.dir
		# endif

	/* Handle ladders */
	var/obj/structure/ladder/Lad = locate(/obj/structure/ladder) in start_turf

	if(istype(Lad))
		# ifdef GOAI_LIBRARY_FEATURES

		if(Lad.above)
			var/turf/Upstairs = get_turf(Lad.above)
			if(Upstairs)
				adjacents.Add(Upstairs)

		if(Lad.below)
			var/turf/Downstairs = get_turf(Lad.below)
			if(Downstairs)
				adjacents.Add(Downstairs)
		# endif

		# ifdef GOAI_SS13_SUPPORT
		if(Lad.target_up)
			var/turf/Upstairs = get_turf(Lad.target_up)
			if(Upstairs)
				adjacents.Add(Upstairs)

		if(Lad.target_down)
			var/turf/Downstairs = get_turf(Lad.target_down)
			if(Downstairs)
				adjacents.Add(Downstairs)
		# endif

	# endif

	/* Handle normal adjacents */
	for(var/turf/t in (trange(1, start_turf)))
		if(t == start_turf)
			continue

		var/deltaDir = get_dir(start_turf, t)

		if(skipDirs & deltaDir)
			// we already know this is blocked or the adjacent is on a different Z-level
			continue

		var/valid = FALSE

		if(check_blockage)
			if(!(t.IsBlocked(check_objects, check_objects_permissive)))
				if(!(check_links && GoaiLinkBlocked(start_turf, t)))
					valid = TRUE
		else
			valid = TRUE

		if(valid)
			adjacents += t

	return adjacents


/proc/fCardinalTurfs(var/turf/start, var/check_blockage = TRUE, var/check_links = TRUE, var/check_objects = TRUE, var/check_objects_permissive = FALSE, var/threeD = TRUE)
	if(!start)
		return

	var/list/adjacents = list()

	for(var/ad in fAdjacentTurfs(start, check_blockage, check_links, check_objects, check_objects_permissive, threeD))
		var/turf/T = ad
		if(T.x == start.x || T.y == start.y)
			adjacents += T

	return adjacents


/turf/proc/CardinalTurfsNoblocks()
	var/result = CardinalTurfs(FALSE, FALSE, FALSE)
	return result


/proc/fCardinalTurfsNoclip(var/turf/start)
	if(!start)
		return

	var/result = fCardinalTurfs(start, FALSE, FALSE, FALSE, TRUE)

	return result


/proc/fCardinalTurfsNoblocks(var/turf/start)
	if(!start)
		return

	var/result = fCardinalTurfs(start, TRUE, FALSE, TRUE, FALSE)

	return result


/proc/fCardinalTurfsNoblocksObjpermissive(var/turf/start)
	if(!start)
		return

	var/result = fCardinalTurfs(start, TRUE, FALSE, TRUE, TRUE)

	return result


/proc/fDistance(var/turf/start, var/atom/T)
	if(!start)
		return

	if(!istype(T))
		return

	var/chebyDist = ChebyshevDistance(start, T)
	var/turf/t = get_turf(T)

	if(istype(t))
		var/deltaX = abs(start.x - t.x)
		var/deltaY = abs(start.y - t.y)

		#ifdef GOAI_MULTIZ_ASTAR
		var/deltaZ = start.z - t.z
		#endif

		var/cost = deltaX + deltaY

		if(chebyDist == 1)
			if((deltaX > 0 && deltaY > 0))
				// Cheaper approximation of sqrt(2)
				// The move can either be cardinal (basecost 1) or diagonal (basecost sqrt(2))
				// Square roots are expensive, might as well precalculate.
				//
				// NOTE: This will ONLY be called in a diagonal context if the adjacency proc admits diagonals
				//       (which implicitly says the caller CAN move diagonally at all)
				//       Otherwise, for cardinal motion this will be broken into two moves with the expected cost of 2.
				cost = 1.414

			cost *= (start.pathweight + t.pathweight)/2

		#ifdef GOAI_MULTIZ_ASTAR
		// For now, assume moving up and down is penalized equally
		// In the future, down might be slightly preferred.
		cost += (abs(deltaZ) * ASTAR_ZMOVE_BASE_PENALTY)
		#endif

		return cost

	else
		return chebyDist


/proc/fTestObstacleDist(var/atom/start, var/atom/T)
	if(!istype(start))
		return PLUS_INF

	if(!istype(T))
		return PLUS_INF

	var/cost = fDistance(start, T)

	var/turf/t = T

	if(istype(t))
		cost += t.pathing_obstacle_penalty

		for(var/atom/movable/AM in t.contents)
			if(!(AM?.density))
				continue

			# ifdef GOAI_SS13_SUPPORT

			var/obj/machinery/door/D = AM
			if(istype(D))
				continue

			# endif

			// unhandled blocking junk gets a penalty
			cost += AM.pathing_obstacle_penalty

	return cost


/proc/fTestObstacleDistFuzzed(var/atom/start, var/atom/T)
	var/eps = ((rand() - 0.5) / 8)
	var/cost = fTestObstacleDist(start, T) + eps
	return cost


/turf/proc/ObstaclePenaltyDistance(var/T)
	var/turf/t = get_turf(T)
	var/base_dist = fDistance(src, t)
	var/block_penalty = 0

	if(t && GoaiLinkBlocked(src, t))
		block_penalty = 10

	var/total_dist = base_dist + block_penalty
	return total_dist


/proc/fObstaclePenaltyDistance(var/S, var/T)
	if(!S || !T)
		return

	var/turf/s = get_turf(S)
	var/turf/t = get_turf(T)

	if(!s || !t)
		return

	var/base_dist = fDistance(s, t)
	var/block_penalty = 0

	if(t && GoaiLinkBlocked(s, t))
		block_penalty = 10

	var/total_dist = base_dist + block_penalty
	return total_dist


/turf/proc/GetOpenness(var/range = 1)
	var/open_lines = 0

	for(var/turf/adj_open in oview(range, src))
		if(!adj_open.density)
			open_lines++

	return open_lines



/turf/IsCover(var/transitive = FALSE, var/for_dir = null, var/default_for_null_dir = FALSE)
	. = ..(transitive, for_dir, default_for_null_dir)

	if(.)
		return . // there's a dot here. BYOOOOOND!

	// Transitive means turfs *with* cover innit *are* cover too
	if(transitive && src.HasCover(FALSE, for_dir, default_for_null_dir))
		return TRUE

	return FALSE
