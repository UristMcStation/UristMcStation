/*
// When I was starting this project, I never expected to wind up implementing half
// the stats toolbox, but I guess here we are now. If you want to make a sandwich
// from scratch, you must first invent the universe, I suppose.
*/

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

# define LAZY_REBUILD_SAMPLER (global.GaussSampler = (global.GaussSampler || new /distribution/gauss()))
# define rand_gauss(mean, stddev) (LAZY_REBUILD_SAMPLER && global.GaussSampler?.sample(mean, stddev))
# define rand_gauss_standard(mean) rand_gauss(mean, 1)

// infinite gamma sampling-loop breaker tripwire value
# define GAMMADIST_MAX_TRIES 1000

/distribution/gamma
	/* Gamma distribution sampler, after Marsaglia and Tsang [2000]
	// "A Simple Method for Generating Gamma Variables"
	*/

	// i.e. Alpha parameter
	var/shape

	// fixed because M&T [2000] don't use it vOv
	// just for completeness/future sake...
	var/scale = 1


/distribution/gamma/sample(var/shape_override = null)
	// This is a nearly direct lift of the cited method, just with some extra vars for readability and applicable DM functions.

	var/alpha = (isnull(shape_override) ? src.shape : shape_override)

	// Black magic nonsense:
	var/d = alpha - (1 / 3)
	var/c = 1 / ((9 * d) ** 0.5)
	// note that these can be cached for each alpha, but I'm lazy rn

	var/success_val = null
	var/tries = 0

	while(isnull(success_val) && tries++ < GAMMADIST_MAX_TRIES)
		var/x
		var/v = -1

		while(v <= 0)
			// This generally shouldn't run more than once, but it's a necessary safeguard
			x = rand_gauss_standard(0)
			v = 1 + c * x

		var/u = rand()
		var/v_cubed = v ** 3 // v should be unused from now on, but I want to keep it for debugging
		var/x_sq = x ** 2

		// Cursed heuristic magic numbers ahoy!
		if(u < ( 1 - 0.0331 * (x_sq**2) ) )
			success_val = (d*v_cubed)
			continue

		if( log(u) < (0.5 * x_sq) + d * ( 1 - v_cubed + log(v_cubed) ) )
			success_val = (d*v_cubed)
			continue

	return success_val


var/global/distribution/gamma/GammaSampler

# define LAZY_REBUILD_SAMPLER_GAMMA (global.GammaSampler = (global.GammaSampler || new /distribution/gamma()))
# define rand_gamma(alpha) (LAZY_REBUILD_SAMPLER_GAMMA && global.GammaSampler?.sample(alpha))


/distribution/beta
	/* Beta distribution.
	// Because I'm a crazy person who wants to be able to do Bayesian ML in *DM*.
	//
	// Intuitively, alpha/beta correspond to observed successes/failures for some process.
	// The samples can be used to generate inputs to prob() for sound decision-making purposes.
	*/
	var/alpha = 1
	var/beta = 1


/distribution/beta/sample(var/alpha_override = null, var/beta_override = null)
	// simple trick: Beta(x, y) = (Gamma(x) / (Gamma(x) + Gamma(y)))
	var/true_alpha = (isnull(alpha_override) ? src.alpha : alpha_override)
	var/true_beta = (isnull(beta_override) ? src.beta : beta_override)

	var/x = rand_gamma(true_alpha)
	var/y = rand_gamma(true_beta)

	var/betavariate = x / (x + y)
	return betavariate



var/global/distribution/beta/BetaSampler

# define LAZY_REBUILD_SAMPLER_BETA (global.BetaSampler = (global.BetaSampler || new /distribution/beta()))
# define rand_beta(a, b) (LAZY_REBUILD_SAMPLER_BETA && global.BetaSampler?.sample(a, b))
