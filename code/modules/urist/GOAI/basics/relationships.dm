/*
// =============================================================
// =                                                           =
// =                  Relationship subsystem                   =
// =                                                           =
// =============================================================
//
// Virtually all intelligent Agents will need some notion of friend/foe,
// even for those that are entirely peaceful - at minimum, they likely
// need to respond to aggression from *players*.
//
// Then, of course, we have the hostile mobs - but even those typically
// shouldn't attack certain other entities, e.g. squadmates/fellow faction.
//
// =============================================================
// =                       -FACTION IDs-                       =
// =                  (and why not use them)                   =
// =============================================================
// The simplest solution of course is a simple ID check, A.faction == B.faction,
// or some kind of set intersection thereof to support multiple faction memberships.
//
// This is very coarse-grained, though:
// A) We only get a binary friend/foe, with nothing in between or beyond
// B) We categorize friends/foes into crude, large 'buckets' like factions.
//
// For a particular example of the limitations of this, imagine a squad of
// enemies sharing a faction, Alice, Bob, Charlie and Dan.
// For whatever reason, Alice shoots Bob.
//
// (1) If this was a one-off, we'd like Bob to assume it was an accident.
// (2) However, if Alice keeps shooting at Bob, he should eventually turn
//     hostile against her and (3) her specifically and not Charlie or Dan.
// (4) Let's assume Charlie and Dan should NOT turn hostile
//     against Alice (5) or Bob.
//
// If we do nothing, we satisfy (1) but cannot do (2).
// If we kick Alice out of the faction, we'll break (4).
// If we kick _Bob_ out, we'd satisfy (2) but break (5).
//
// The only solution would be to pile another system on top to handle
// exceptional cases like this. Not very elegant at all.
//
// =============================================================
// =                   TAGGED AFFINITIES                       =
// =============================================================
//
// Instead, we're taking a different approach here.
// We'll actually store a numeric value for the relationship score.
// We'll keep a list of all entities we want to track relations to.
//
// Q: But wait, won't it be absurdly large?
// A: No, because we'll go abstract.
//
// Instead of tracking *physical* entities, we'll track a bunch of
// *TAGS* - simple strings or object hashes (insofar as DM does it).
// Most relations will be decided by a single or a few abstract tags,
// e.g. faction membership.
//
// This means we can represent multiple dimensions per relation, (
// like the multi-factionId solution), but we can also:
// A) Be finer-grained with bucketing - we can even drop down to
//    personal relations between agents without exhausting memory
//    for possible factions
// B) Be finer-grained with relationship value - instead of a binary
//    switch, we can gradually raise/decay relations.
// C) Make it easy to add/remove factions and relations (no compilation
//    needed, at least in principle!)
//
// A secondary trick we'll use here is storing not just values, but also
// their *weights* - this means we can have priority relationships (e.g.
// personal > faction all things being equal).
//
// =============================================================
// =                          API                              =
// =============================================================
//
// Broadly speaking, you'll want:
// - Insert(k, v) => to upsert values (absolute value)
// - Increase(k, dv) => to upsert values (relative value)
// - GetRelationshipByTags(list<str>) => to retrieve values.
//
// Accessing stuff by attribute is technically possible, but
// not recommended - you might wind up reinventing the wheel.
*/

/datum/relation_data
	var/value = 0
	var/weight = 1


/datum/relation_data/New(var/val = null, var/wgt = null)
	value = (isnull(val) ? value : val)
	weight = (isnull(wgt) ? weight : wgt)


/datum/relationships
	// Relationship modifiers, indexed by string tag
	// Values are relation_datas
	var/dict/data
	var/total_weights = 0 // this is cached here to avoid doing an extra O(n) loop for updates


/datum/relationships/proc/Insert(var/tag, var/datum/relation_data/relation)
	if(!(tag && relation))
		return src

	var/weight = relation.weight
	data.Set(tag, relation)
	total_weights += weight

	return src


/datum/relationships/proc/Drop(var/tag)
	if(!(tag))
		return FALSE

	var/datum/relation_data/rel = src.data.Get(tag)
	if(!rel)
		return FALSE

	var/curr_weight = rel.weight
	total_weights -= curr_weight

	data.Set(tag, null)
	qdel(rel)
	return src


/datum/relationships/proc/Increase(var/tag, var/amt, var/wgt_if_new = 1)
	if(!(tag && amt))
		return src

	var/datum/relation_data/upd_relation = data.Get(tag, null)

	if(isnull(upd_relation))
		upd_relation = new(0 + amt, wgt_if_new)
		Insert(tag, upd_relation)

	else
		var/curr_val = upd_relation.value || 0
		upd_relation.value = curr_val + amt

	return src


/datum/relationships/New(var/dict/init_data)
	data = data || new()

	if(init_data && init_data.data)
		for(var/key in init_data.data)
			if(!key) continue
			var/val = init_data.data[key]
			Insert(key, val)


/datum/relationships/proc/GetDataByTag(var/tag)
	if(!tag || !data)
		return null

	var/datum/relation_data/relation = data.Get(tag, null)
	return relation


/datum/relationships/proc/GetModifierByTag(var/tag)
	var/datum/relation_data/relation = GetDataByTag(tag)
	return relation?.value


/datum/relationships/proc/GetRelationshipByTags(var/list/tags)
	if(!(data && tags))
		return

	var/total_val = 0

	for(var/tag in tags)
		if(!tag)
			continue

		var/datum/relation_data/relation = GetDataByTag(tag)
		if(!relation)
			continue

		var/rel_val = relation.value
		if(isnull(rel_val))
			continue

		var/rel_wgt = relation.weight
		if(!rel_wgt)
			continue

		var/factor = (rel_wgt / total_weights)
		var/weighted_val = factor * rel_val
		total_val += weighted_val


	return total_val
