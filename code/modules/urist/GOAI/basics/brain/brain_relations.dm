#define BRAIN_MODULE_INCLUDED_RELATIONS 1


/datum/brain
	/* Faction-esque data; relation modifiers by tag. */
	var/datum/relationships/relations

	// For relations: if less than this, we are hostile to the target, if more - neutral (or allied)
	var/hostility_threshold = RELATIONS_DEFAULT_HOSTILITY_THRESHOLD

	// For relations: if higher than this, we treat the target as an ally
	var/ally_threshold = RELATIONS_DEFAULT_ALLIANCE_THRESHOLD
