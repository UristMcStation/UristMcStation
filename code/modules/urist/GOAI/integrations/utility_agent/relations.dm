/*
// RELATIONSHIP SYSTEM INTEGRATION
//
// This is an AI-side API to query the Relationships system in the AI Brain.
// Functions as an abstraction layer above the raw Brain vars & procs.
//
*/


/datum/utility_ai/proc/SetRelationshipTag(var/tag, var/value = null, var/weight = null) // -> datum/relationships
	/* This is little more than a wrapper over the Relationships datum's Insert,
	// with lazy initialization if SOMEHOW it wasn't initialized properly.
	*/
	if(!tag)
		return

	if(!(src.brain))
		return

	var/datum/relationships/my_relations = src.brain.relations
	var/should_init_rels = FALSE

	if(isnull(my_relations) || !istype(my_relations))
		my_relations = new()
		should_init_rels = TRUE

	var/datum/relation_data/rel = new(value, weight)
	my_relations.Insert(tag, rel)

	if(should_init_rels)
		// we deferred setting the relationships var so that we can set up the new rel first
		src.brain.relations = my_relations

	return my_relations


/datum/utility_ai/proc/DropRelationshipTag(var/tag) // -> datum/relationships
	/* This is little more than a wrapper over the Relationships datum's Insert,
	// with lazy initialization if SOMEHOW it wasn't initialized properly.
	*/
	if(!tag)
		return

	if(!(src.brain))
		return

	var/datum/relationships/my_relations = src.brain.relations
	var/should_init_rels = FALSE

	if(isnull(my_relations) || !istype(my_relations))
		my_relations = new()
		should_init_rels = TRUE

	my_relations.Drop(tag)

	if(should_init_rels)
		// we deferred setting the relationships var so that we can set up the new rel first
		src.brain.relations = my_relations

	return my_relations


/datum/utility_ai/proc/GetRelationshipTagsFor(var/atom/trg) // -> list
	/* Build a basic set of tags to query for for a given target.
	//
	// In principle, this could be an empty list, but it's nicer
	// to have these ready. If they're not used much, these tags
	// can be migrated to be added at the subclass hook.
	*/
	if(isnull(trg))
		return

	var/list/trg_tags = list()

	var/mob/living/L = trg

	if(istype(L))
		// Faction:
		var/mainfaction = L.faction
		if(mainfaction)
			trg_tags.Add(mainfaction)

	# ifdef GOAI_SS13_SUPPORT

	var/mob/living/carbon/human/H = trg
	var/mob/living/simple_animal/SAH = trg

	if(istype(H))
		// Name, for 1-to-1 relations tracking
		// Use real_name? Prolly not, because we want masks etc. to work.
		// We could add a special tag if name != real_name
		trg_tags.Add(H.name)

	else if(istype(SAH))
		// Name, for 1-to-1 relations tracking
		trg_tags.Add(SAH.name)

		// Hidden Faction:
		var/datum/factions/hiddenfaction = SAH.hiddenfaction
		if(hiddenfaction && istype(hiddenfaction))
			trg_tags.Add(hiddenfaction.factionid)

	# endif

	// subclass hook
	var/list/subclass_tags = HookGetRelationshipTagsFor(trg)
	if(subclass_tags && istype(subclass_tags))
		trg_tags += subclass_tags

	return trg_tags


/datum/utility_ai/proc/HookGetRelationshipTagsFor(var/atom/trg) // -> list | null
	// Hook for subclasses to add extra tags in as needed.
	return


/datum/utility_ai/proc/CheckRelationsTo(var/atom/trg, var/datum/relationships/relationships_override = null) // -> /dict
	if(isnull(trg))
		return

	var/datum/relationships/my_relations = relationships_override
	if(isnull(my_relations) || !istype(my_relations))
		my_relations = brain?.relations

	if(isnull(my_relations))
		return

	var/list/trg_tags = src.GetRelationshipTagsFor(trg)
	if(isnull(trg_tags) || !istype(trg_tags))
		return 0

	var/friendliness_score = my_relations.GetRelationshipByTags(trg_tags)

	return friendliness_score


/datum/utility_ai/proc/IsNeutral(var/atom/trg, var/datum/relationships/relationships_override = null) // -> bool
	if(isnull(trg))
		return FALSE

	var/threshold = RELATIONS_DEFAULT_HOSTILITY_THRESHOLD
	if(src.brain)
		threshold = src.brain.hostility_threshold

	var/friendliness_score = src.CheckRelationsTo(trg, relationships_override)
	// negative - hostile, potentially one-sided
	var/is_neutral = (isnull(friendliness_score) || (friendliness_score > threshold))
	return is_neutral


/datum/utility_ai/proc/IsEnemy(var/atom/trg, var/datum/relationships/relationships_override = null) // -> bool
	if(isnull(trg))
		return FALSE

	var/is_hostile = !(src.IsNeutral(trg, relationships_override))
	return is_hostile


/datum/utility_ai/proc/IsFriend(var/atom/trg, var/datum/relationships/relationships_override = null) // -> bool
	if(isnull(trg))
		return FALSE

	var/threshold = RELATIONS_DEFAULT_ALLIANCE_THRESHOLD
	if(src.brain)
		threshold = src.brain.ally_threshold

	var/friendliness_score = src.CheckRelationsTo(trg, relationships_override)
	var/is_friend_shaped = (isnull(friendliness_score) || (friendliness_score > threshold))

	return is_friend_shaped
