/*
// A lot of power and flexibility of GOAI APIs lies in using a sprinkle of the ECS architecture,
// where instead of storing values in a class itself, we store them in a global table of some kind
// and attach only a small ID in the class proper to serve as a key for looking up that table.
//
// This module extends BYOND's native classes with a single shared attribute that serves as that ID
// as well as a unified API for setting that.
//
// This allows all global tables to reuse this ID as their key.
//
// The ID should be a string, because BYOND hashmaps be BYONDing.
*/

/datum
	var/global_id = null


/datum/proc/InitializeGlobalId(var/list/args = null)
	/* Subclass hook in case the ID has to be dynamically generated */

	if(src.global_id)
		// Do not rewrite the ID if initialized
		return src.global_id

	// By default, generate an ID from a ref macro - guaranteed to be unique up to a reallocation.
	var/default_id = "\ref[src]"
	src.global_id = default_id
	return default_id


// Shorthand for a very common code pattern where the Global ID is lazily initialized.
// The OR operator is short-circuiting, so the initialization will only be done once, when needed,
// because the initialization proc is expected to set the new ID on the object as part of its contract.
#define GET_GLOBAL_ID_LAZY(TargetDatum) (isnull(TargetDatum.global_id) ? TargetDatum.InitializeGlobalId() : TargetDatum.global_id)
