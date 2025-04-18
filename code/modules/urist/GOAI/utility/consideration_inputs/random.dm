/*
//
*/


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_urand)
	// A Consideration input that returns an activation that is uniform random between 0% and 100%
	return rand() * 100



CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_fuzz_uniform)
	// A Consideration input that randomly *gently* throttles the activation.
	// This is meant for randomizing AI decisions slightly without reducing activation too much.
	// This variant uses a rescaled uniform random sample as a simple subtraction.
	// E.g. with the scale param of 4, the minimum activation is 75%, at 8 it's 87.5%, the maximum being 100%.
	var/scale = consideration_args?["scale"] || 4

	var/sampled = (rand() / scale)

	// Just subtract the rescaled value
	var/output = (1 - sampled)
	return clamp(output, 0, 1)


// Additive smoothing variant; created that first before realizing it might be too complicated for this, but let's keep it.

CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_fuzz_additive)
	// A Consideration input that randomly *gently* throttles the activation.
	// This is meant for randomizing AI decisions slightly without reducing activation too much.
	// This variant uses additive smoothing.
	// E.g. with the scale param of 4, the minimum activation is 80%, at 8 it's 88%, the maximum being 100%.
	var/scale = consideration_args?["scale"] || 4

	var/sampled = (rand() / scale)

	// Additive smoothing, just using a random value
	var/output = 1 / (1 + sampled)
	return clamp(output, 0, 1)

