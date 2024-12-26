/*
// This module allows Brains to be wired up to other Brains in a hierarchy.
// This allows Memories to be looked up recursively, either preferring the
// higher-level Brain's version or defaulting to it on a miss in the child.
//
// The metaphor used in naming is a hivemind, but this can just as easily be
// a squad, a faction, or an AI Blackboard shared with a separate AI module.
*/

/datum/brain
	/* Optional 'parent' brain ref.
	//
	// Can be used to simulate literal hiveminds, but also
	// various lower-granularity planners, e.g. squads or
	// organisations or a mob's 'strategic' planner that
	// informs the 'tactical'/'operational' planners' goals.
	//
	// IMPORTANT: this hierarchy should form a (Directed) Acyclic Graph!
	*/
	var/datum/brain/hivemind
