# ifdef GOAI_LIBRARY_FEATURES
// Turns a direction into text
/proc/dir2text(direction)
	switch (direction)
		if (NORTH)     return "north"
		if (SOUTH)     return "south"
		if (EAST)      return "east"
		if (WEST)      return "west"
		if (NORTHEAST) return "northeast"
		if (SOUTHEAST) return "southeast"
		if (NORTHWEST) return "northwest"
		if (SOUTHWEST) return "southwest"
		if (UP)        return "up"
		if (DOWN)      return "down"
	return "unknown ([direction])"


//Mergesort: any value in a list
/proc/sortList(var/list/L)
	if(L.len < 2)
		return L
	var/middle = L.len / 2 + 1 // Copy is first,second-1
	return mergeLists(sortList(L.Copy(0,middle)), sortList(L.Copy(middle))) //second parameter null = to end of list


//Mergesort: uses sortList() but uses the var's name specifically. This should probably be using mergeAtom() instead
/proc/sortNames(var/list/L)
	var/list/Q = new()
	for(var/atom/x in L)
		Q[x.name] = x
	return sortList(Q)


/proc/mergeLists(var/list/L, var/list/R)
	var/Li=1
	var/Ri=1
	var/list/result = new()
	while(Li <= L.len && Ri <= R.len)
		if(sorttext(L[Li], R[Ri]) < 1)
			result += R[Ri++]
		else
			result += L[Li++]

	if(Li <= L.len)
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))


/proc/is_num_predicate(var/value, var/feedback_receiver)
	. = isnum(value)
	if(!. && feedback_receiver)
		to_chat(feedback_receiver, "<span class='warning'>Value must be a numeral.</span>")


/atom/movable/proc/forceMove(atom/destination)
	if(loc == destination)
		return 0
	var/is_origin_turf = isturf(loc)
	var/is_destination_turf = isturf(destination)
	// It is a new area if:
	//  Both the origin and destination are turfs with different areas.
	//  When either origin or destination is a turf and the other is not.
	var/is_new_area = (is_origin_turf ^ is_destination_turf) || (is_origin_turf && is_destination_turf && loc.loc != destination.loc)

	var/atom/origin = loc
	loc = destination

	if(origin)
		origin.Exited(src, destination)
		if(is_origin_turf)
			for(var/atom/movable/AM in origin)
				AM.Uncrossed(src)
			if(is_new_area && is_origin_turf)
				origin.loc.Exited(src, destination)

	if(destination)
		destination.Entered(src, origin)
		if(is_destination_turf) // If we're entering a turf, cross all movable atoms
			for(var/atom/movable/AM in loc)
				if(AM != src)
					AM.Crossed(src)
			if(is_new_area && is_destination_turf)
				destination.loc.Entered(src, origin)
	return 1


/proc/readglobal(which)
	switch(which)
		/*if("GLOB")
			return global.GLOB;
		if("_all_globals")
			return global._all_globals;
		if("config")
			return global.config;
		if("view_variables_dont_expand")
			return global.view_variables_dont_expand;
		if("view_variables_no_assoc")
			return global.view_variables_no_assoc;*/
		if("")
			return
	return


/proc/writeglobal(which, newval)
	switch(which)
		/*if("GLOB")
			global.GLOB=newval;
		if("_all_globals")
			global._all_globals=newval;
		if("config")
			global.config=newval;*/
		if("")
			return
	return


/var/list/_all_globals=list(
	/*"GLOB",
	"_all_globals",
	"config",
	"view_variables_dont_expand",
	"view_variables_no_assoc"*/
)

#endif
