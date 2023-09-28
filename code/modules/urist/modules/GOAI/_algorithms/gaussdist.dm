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
	var/mean = 0
	var/stddev = 1

	// for Marsaglia only
	var/spare = null


/distribution/gauss/New(var/new_mean = 0, var/new_stddev = 1, var/overwrite_singleton = TRUE)
	src.mean = (isnull(new_mean) ? src.mean : new_mean)
	src.stddev = (isnull(new_stddev) ? src.stddev : new_stddev)

	if(overwrite_singleton || isnull(GaussSampler))
		// Singleton; note that you should ALWAYS pass in the
		// args to sample() to be sure the right ones are used
		// when using the global singleton!
		GaussSampler = src



/distribution/gauss/proc/_marsaglia_sample(var/mean = null, var/stddev = null)
	/* Marsaglia polar method sampling */
	var/_mean = (isnull(mean) ? src.mean : mean)
	var/_std = (isnull(stddev) ? src.stddev : stddev)

	var/spare = src.spare
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
		spare = v * s
		return _mean + _std * u * s

	// implicit 'else'
	src.spare = null
	return _mean + _std * spare


/distribution/gauss/proc/_boxmuller_sample(var/mean = null, var/stddev = null)
	/* Box-Muller Transform sampling */
	var/_mean = (isnull(mean) ? src.mean : mean)
	var/_std = (isnull(stddev) ? src.stddev : stddev)

	var/distribution/uniform/uni_dist = new()

	var/uniA = uni_dist.sample()
	var/uniB = uni_dist.sample()

	var/polar_dist = _std * ((-2 * log(uniA)) ** (0.5))
	var/polar_angle = (2 * MATH_PI * uniB)


	var/result = (polar_dist * sin(polar_angle) * _mean)
	/* NOTE:
	   With cos(), we could generate an extra sample out of this,
	   but that would mean an extra tuple-handling step.
	*/
	return result


/distribution/gauss/sample(var/mean = null, var/stddev = null)
	var/sampled = _marsaglia_sample(mean, stddev)
	return sampled


var/global/distribution/gauss/GaussSampler

# define LAZY_REBUILD_SAMPLER (GaussSampler || new /distribution/gauss())
# define rand_gauss(mean, stddev) (LAZY_REBUILD_SAMPLER)?.sample(mean, stddev)
