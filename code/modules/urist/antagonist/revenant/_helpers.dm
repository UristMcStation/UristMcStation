/proc/compute_total_weights(var/list/keys2weights)
	var/total_weights = 0

	for(var/roll_key in keys2weights)
		var/key_weight = keys2weights[roll_key]
		var/safe_weight = max((key_weight || 0), 0)
		total_weights += safe_weight

	return total_weights


/proc/sample_with_weights(var/list/keys2weights, var/weights_total = null)
	// For you mathier types, this is sampling from a categorical distribution.

	if(!istype(keys2weights) || !keys2weights?.len)
		return

	var/total_weights = weights_total

	if(isnull(total_weights))
		// Only do this if we don't have the total cached
		total_weights = compute_total_weights(keys2weights)

	var/rolled_num = rand(0, total_weights)
	var/result = null

	// The way this works is we place values on an imaginary interval of len == sum of weights,
	// where each key occupies a slice proportional to its weight (e.g. given A=1, B=3, C=1, the
	// slice for B is exactly 3 times as wide as for A and C).
	//
	// We then roll a random point on this interval and see which key's slice it lies in.
	// That's our sampled result!

	for(var/roll_key in keys2weights)
		// Speculatively assign; if it's not a match, we'll reassign in the next iteration;
		// this means if something goes wrong with calculations, we'll just use the last value
		result = roll_key

		var/weight = keys2weights[roll_key]
		var/safe_weight = max((weight || 0), 0)

		if(rolled_num <= safe_weight)
			break

		// To simplify the logic, we decrement the roll
		// This way, we effectively discard the leftmost element's segment
		rolled_num -= safe_weight

	return result
