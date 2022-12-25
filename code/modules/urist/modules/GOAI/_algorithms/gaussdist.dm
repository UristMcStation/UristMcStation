/distribution


/distribution/proc/sample()
	return


/distribution/uniform
	//var/scale = 100000


/*/distribution/uniform/New(var/new_scale = null)
	scale = (isnull(new_scale) ? scale : new_scale)


/distribution/uniform/generate(var/custom_scale = null)
	used_scale = (isnull(custom_scale) ? scale : custom_scale)

	var/result =
*/

/distribution/uniform/sample()
	return rand()


/distribution/gauss



/distribution/gauss/proc/_marsaglia_sample(var/mean = 0, var/stddev = 1)
	/* Marsaglia polar method sampling */
	var/spare = null
	var/distribution/uniform/uni_dist = new()

	if(isnull(spare))
		var/s = 0
		var/u = null
		var/v = null

		while (s == 0 || s >= 1)
			u = (uni_dist.sample() * 2) -1
			v = (uni_dist.sample() * 2) -1
			s = u * u + v * v

		s = (-2 * log(s) / s) ** (0.5)
		//spare = v * s
		return mean + stddev * u * s

	return mean + stddev * spare


/distribution/gauss/proc/_boxmuller_sample()
	/* Box-Muller Transform sampling */
	var/distribution/uniform/uni_dist = new()

	var/uniA = uni_dist.sample()
	var/uniB = uni_dist.sample()

	var/polar_dist = (-2 * log(uniA)) ** (0.5)
	var/polar_angle = (2 * PI * uniB)


	var/result = polar_dist * sin(polar_angle)
	/* NOTE:
	   With cos(), we could generate an extra sample out of this,
	   but that would mean an extra tuple-handling step.
	*/
	return result


/distribution/gauss/sample()
	return _marsaglia_sample()
