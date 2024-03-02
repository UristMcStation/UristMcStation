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

		else if(newVal)
			// insert key
			merged[Key] = newVal
		// if only oldVal, we got it covered already

	for(var/effkey in newassoc)
		if(effkey in oldassoc)
			continue //already handled by the upsert
		merged[effkey] = newassoc[effkey]

	return merged


# ifdef GOAI_LIBRARY_FEATURES

 // Shamelessly ripped from SS13 code:

// Return the index using dichotomic search
/proc/FindElementIndex(var/A, list/L, cmp)
	var/i = 1
	var/j = L.len
	var/mid

	while(i < j)
		mid = round((i+j)/2)

		if(call(cmp)(L[mid],A) < 0)
			i = mid + 1
		else
			j = mid

	if(i == 1 || i ==  L.len) // Edge cases
		return (call(cmp)(L[i],A) > 0) ? i : i+1
	else
		return i


/proc/pop(list/listfrom)
	if (listfrom && listfrom.len)
		var/picked = listfrom[listfrom.len]
		listfrom.len--
		return picked
	return null

# endif


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


/proc/reverse_list_clone(var/list/srclist)
	if(isnull(srclist) || !islist(srclist))
		return null

	var/src_len = srclist.len

	if(src_len <= 1)
		return srclist.Copy()

	var/reversed[src_len]
	var/helper_len = src_len + 1
	var/temp_len = 1

	while(temp_len <= src_len)
		reversed[temp_len] = srclist[helper_len - temp_len]
		temp_len++

	return reversed
