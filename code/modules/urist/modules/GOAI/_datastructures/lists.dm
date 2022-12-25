/*
 * Holds procs to help with list operations
 */



/proc/upsert(var/list/oldassoc, var/list/newassoc)
	if(!newassoc)
		return oldassoc
	else if(!oldassoc)
		return newassoc

	var/list/merged = list()

	for(var/Key in oldassoc)
		// upsert to current oldassoc
		var/oldVal = oldassoc[Key]
		var/newVal = newassoc[Key]

		if(oldVal && newVal)
			// merge effects
			merged[Key] = oldVal + newVal
			world.log << "[Key]: updating from [oldVal] to [merged[Key]]."

		else if(newVal)
			// insert key
			merged[Key] = newVal
		// if only oldVal, we got it covered already

	for(var/effkey in newassoc)
		if(effkey in oldassoc)
			continue //already handled by the upsert
		merged[effkey] = newassoc[effkey]

	return merged

/*
/proc/pop(list/listfrom)
	if (listfrom && listfrom.len)
		var/picked = listfrom[listfrom.len]
		listfrom.len--
		return picked
	return null
*/

/proc/lpop(list/listfrom)
	if (listfrom && listfrom.len)
		var/picked = listfrom[1]
		listfrom.Cut(0, 2)
		return picked
	return null


/proc/all_in(var/list/haystack, var/list/needles)
	if(!(needles && haystack))
		return 0
	for(var/item in needles)
		if(!(item in haystack))
			return 0
	return 1


/proc/any_in(var/list/haystack, var/list/needles)
	if(haystack)
		if(!needles)
			return 0
		for(var/n in needles)
			if(n in haystack)
				return 1
	return null


/proc/right_disjoint(var/list/haystack, var/list/needles)
	if(!haystack)
		return needles ? needles.Copy() : list()

	var/list/disjoint = list()

	for(var/i in needles)
		if(!(i in haystack))
			disjoint += i
	return disjoint


/proc/right_disjoint_assoc(var/list/assoc_haystack, var/list/assoc_needles)
	if(!assoc_haystack)
		return assoc_needles ? assoc_needles.Copy() : list()

	var/list/disjoint = list()

	for(var/i in assoc_needles)
		if(!(i in assoc_haystack))
			disjoint[i] = assoc_needles[i]
	return disjoint

