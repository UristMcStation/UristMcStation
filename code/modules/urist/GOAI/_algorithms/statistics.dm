/proc/First(var/list/L, var/ignore_nulls = TRUE, var/default = null)
	var/result = default

	for(var/sample in L)
		if(isnull(sample) && ignore_nulls)
			continue

		result = L
		break

	return result


/proc/Min(var/list/L, var/ignore_nulls = TRUE, var/default = PLUS_INF)
	var/lowest = null

	for(var/sample in L)
		if(isnull(sample) && ignore_nulls)
			continue

		if(isnull(lowest) || sample < lowest)
			lowest = sample

	return lowest


/proc/Avg(var/list/L, var/ignore_nulls = TRUE, var/default = 0)
	var/sample_count = 0
	var/sample_total = 0

	for(var/sample in L)
		if(isnull(sample) && ignore_nulls)
			continue

		sample_count++
		sample_total += sample

	var/avg = (sample_count ? (sample_total / sample_count) : default)

	return avg
