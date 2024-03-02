# ifdef GOAI_LIBRARY_FEATURES

/turf/ground
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"


/turf/ground/New()
	. = ..()
	name += " ([x], [y])"


/turf/wall
	density = 1
	opacity = 1
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
			//to_world_log("[src] hit dense object [object] @ [object.loc]")
			return TRUE

	//to_world_log("[src] is not blocked")
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
		//to_world_log("A -> B blocked; A=[A], B=[B]")
		return TRUE

	if(GoaiDirBlocked(B,rdir))
		//to_world_log("B -> A blocked; A=[A], B=[B]")
		return TRUE

	return FALSE


/turf/proc/GoaiObjectBlocked(var/check_objects_permissive = FALSE)
	// simplified version of the SS13 logic
	// TODO: add directional logic for flipped tables etc.

	for(var/obj/object in src.contents)
		if(!object.density)
			continue

		if(check_objects_permissive)
			# ifdef GOAI_SS13_SUPPORT

			var/obj/machinery/door/D = object
			if(D && istype(D))
				continue

			# endif

			# ifdef GOAI_LIBRARY_FEATURES

			var/obj/cover/door/D = object
			if(D && istype(D))
				continue

			var/obj/cover/autodoor/AD = object
			if(AD && istype(AD))
				continue

			var/obj/cover/table/T = object
			if(T && istype(T))
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


// NOTE: the f-prefix stands for 'functional' (i.e. not bound method)
/proc/fAdjacentTurfs(var/turf/start, var/check_blockage = TRUE, var/check_links = TRUE, var/check_objects = TRUE, var/check_objects_permissive = FALSE)
	if(!start)
		return

	var/list/adjacents = list()
	var/turf/start_turf = get_turf(start)

	for(var/turf/t in (trange(1, start) - start))
		if(check_blockage)
			if(!(t.IsBlocked(check_objects, check_objects_permissive)))
				if(!(check_links && GoaiLinkBlocked(start_turf, t)))
					adjacents += t
		else
			adjacents += t

	return adjacents


/proc/fCardinalTurfs(var/turf/start, var/check_blockage = TRUE, var/check_links = TRUE, var/check_objects = TRUE, var/check_objects_permissive = FALSE)
	if(!start)
		return

	var/list/adjacents = list()

	for(var/ad in fAdjacentTurfs(start, check_blockage, check_links, check_objects, check_objects_permissive))
		var/turf/T = ad
		if(T.x == start.x || T.y == start.y)
			adjacents += T

	return adjacents


/turf/proc/CardinalTurfsNoblocks()
	var/result = CardinalTurfs(FALSE, FALSE, FALSE)
	//to_world_log("CardinalTurfsNoblocks([src]) => [result] ([result?.len])")
	return result


/proc/fCardinalTurfsNoclip(var/turf/start)
	if(!start)
		return

	var/result = fCardinalTurfs(start, FALSE, FALSE, FALSE, TRUE)
	//to_world_log("CardinalTurfsNoblocks([src]) => [result] ([result?.len])")

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


/proc/fDistance(var/turf/start, var/T)
	if(!start)
		return

	var/turf/t = T
	if(t && get_dist(start, t) == 1)
		var/cost = SQR(start.x - t.x) + SQR(start.y - t.y)
		cost *= (start.pathweight + t.pathweight)/2
		return cost

	else
		return get_dist(start, T)


/proc/fDistanceUnified(var/atom/start, var/atom/T)
	// TODO!!!
	if(!start)
		return PLUS_INF

	var/cost = SQR(start.x - T.x) + SQR(start.y - T.y)

	var/turf/s = start
	var/turf/t = T

	if(t && istype(t) && s && istype(s))
		cost *= (s.pathweight + t.pathweight)/2

	return cost


/proc/fDistanceUnifiedFuzzed(var/atom/start, var/atom/T)
	var/eps = (rand() / 2)
	var/cost = fDistanceUnified(start, T) + eps
	return cost



/proc/fTestObstacleDist(var/atom/start, var/atom/T)
	if(!start)
		return PLUS_INF

	if(!T)
		return PLUS_INF

	var/cost = get_dist(start, T)

	var/turf/t = T

	if(t && istype(t))
		for(var/obj/O in t.contents)
			if(!(O?.density))
				continue

			# ifdef GOAI_SS13_SUPPORT

			var/obj/machinery/door/D = O
			if(D && istype(D))
				continue

			# endif

			// unhandled blocking junk gets a penalty
			cost += O.pathing_obstacle_penalty

	return cost


/proc/fTestObstacleDistFuzzed(var/atom/start, var/atom/T)
	var/eps = (rand() / 2)
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
