#define BRAIN_MODULE_INCLUDED_PERSONALITY 1

/datum/brain
	/* Personality container.
	//
	// A simple key-value map; keys are aspects of personality, vals are arbitrary (but probably numeric).
	// This is designed to not overload Memories with handling fixed traits while also being simpler to use.
	//
	// This is a KVMap to provide 'interop' between brains in different mobs after transplanting brains.
	// If a mob's body doesn't use some aspect of personality, it can just ignore it. If it's missing, it
	// can provide a fallback value.
	//
	// This is in contrast to a struct-ey/OOP approach of declaring traits as attributes of a datum subclass;
	// while it's likely a fair bit faster, we lose the brain's 'portability', and the allocations should be
	// fairly light anyway. If access is slow, consider caching the value in the mob variables.
	*/
	var/list/personality

	// Optionally, filepath to generate a personality from a template
	var/personality_template_filepath = null


/datum/brain/proc/GetPersonalityTrait(var/trait_key, var/default = null)
	if(isnull(personality))
		return default

	if(!(trait_key in personality))
		return default

	var/val = personality[trait_key]
	if(isnull(val))
		return default

	return val
