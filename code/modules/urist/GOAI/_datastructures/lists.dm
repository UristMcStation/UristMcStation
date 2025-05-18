/*
 * Holds procs to help with list operations
 */


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
