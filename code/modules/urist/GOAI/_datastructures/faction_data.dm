/*
// This is the actual data for a faction (a container for
// stuff like relationships, members and whatever else).
//
// The faction AI should NOT have stuff like this directly
// hardcoded anywhere - if it does, we cannot have factions
// that are NOT driven by AI (and we might need it for stuff
// like PC factions, where we want third-party AIs to access
// this data without having an AI loop for the PC faction itself.
*/

/datum/faction_data
	var/name = "unknown faction"

	// Relations list (outbound)
	var/datum/relationships/relations

	// Tags, for inbound relations
	// (at the most basic, the faction name can be the only tag)
	var/list/tags

	// Faction Registry index
	var/registry_index

	// Associated Actions
	var/list/actionset_files = null


/datum/faction_data/proc/RegisterFaction()
	// Registry pattern, to facilitate querying all Factions
	if(!(GOAI_LIBBED_GLOB_ATTR(global_faction_registry)))
		GOAI_LIBBED_GLOB_ATTR(global_faction_registry) = list()

	if(src.registry_index)
		GOAI_LIBBED_GLOB_ATTR(global_faction_registry)[src.registry_index] = src
		return GOAI_LIBBED_GLOB_ATTR(global_faction_registry)

	GOAI_LIBBED_GLOB_ATTR(global_faction_registry) += src
	src.registry_index = GOAI_LIBBED_GLOB_ATTR(global_faction_registry.len)

	if(!(src.name))
		src.name = src.registry_index

	return GOAI_LIBBED_GLOB_ATTR(global_faction_registry)


/datum/faction_data/proc/BuildRelations()
	var/datum/relationships/new_relations = new()

	if(!GOAI_LIBBED_GLOB_ATTR(relationships_db))
		InitRelationshipsDb()

	var/list/our_rels = (GOAI_LIBBED_GLOB_ATTR(relationships_db))?[src.name]

	if(our_rels)
		for(var/reltag in our_rels)
			var/relval = our_rels[reltag]

			if(isnull(relval))
				continue

			var/datum/relation_data/reldata = new(relval, RELATIONS_DEFAULT_RELATIONSHIP_WEIGHT)
			new_relations.Insert(reltag, reldata)

	return new_relations


/datum/faction_data/proc/BuildTags()
	var/list/mytags = list()
	return mytags


/datum/faction_data/New(var/newname, var/datum/relationships/init_relations = null, var/list/init_tags = null, var/list/actionsets = null, var/list/initial_assets = null)
	. = ..()

	SET_IF_NOT_NULL(newname, src.name)
	SET_IF_NOT_NULL(init_tags, src.tags)
	SET_IF_NOT_NULL(actionsets, src.actionset_files)

	if(istype(init_relations))
		src.relations = init_relations

	// Populate data structures (do not override existing)
	src.relations = DEFAULT_IF_NULL(src.relations, src.BuildRelations())
	src.tags = DEFAULT_IF_NULL(src.tags, src.BuildTags())

	// Sign up to the registry for queries once ready
	src.RegisterFaction()

	return

