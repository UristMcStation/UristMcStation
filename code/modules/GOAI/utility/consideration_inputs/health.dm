/*
// Consideration procs that deal with assessing the health of our AI controller.
*/


# ifdef GOAI_SS13_SUPPORT


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_mobhealth_abs)
	// Returns the mob's absolute health. Duh.
	// Note that because we yeeted normalization to the Scoring logic, this will Just Work
	// for any mob, regardless of their default Health pool, as long as we set the Consideration params right.
	// This is more suitable for queries like 'this enemy deals 50 dmg, should I run?' than 'is my health low?'.
	// If you want a variant that will do the latter and not break on varedits, use `health/maxHealth` input instead.

	var/datum/utility_ai/mob_commander/requester_ai = requester

	if(isnull(requester_ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("Requester is not an AI (from [requester || "null"] raw val) @ L[__LINE__] in [__FILE__]")
		return null

	var/mob/pawn = requester_ai?.GetPawn()

	if(isnull(pawn))
		return null

	return pawn.health_current


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_mobhealth_rel)
	// Returns the mob's health as a fraction of their maxHealth.
	// This is suitable for queries like 'is my health low?'.

	var/datum/utility_ai/mob_commander/requester_ai = requester

	if(isnull(requester_ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("Requester is not an AI (from [requester || "null"] raw val) @ L[__LINE__] in [__FILE__]")
		return null

	var/mob/pawn = requester_ai?.GetPawn()

	if(isnull(pawn))
		return null

	if(!(pawn?.health_max))
		return PLUS_INF

	// TODO: this is a kind of lazy port to new SS13 health; need to macro this to switch lib/ss13 impls
	return (pawn.health_current / pawn.health_max)

#endif
