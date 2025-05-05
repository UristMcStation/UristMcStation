
/turf/proc/CombatantAdjacents(var/mob/owner)
	var/turf/s = get_turf(src)
	if(!s)
		return

	var/list/base_adjs = s.CardinalTurfsNoblocks()
	var/list/out_adjs = list()

	var/cut_link = null
	//var/cut_link = owner?.brain?.GetMemoryValue("BadStartTile", null)

	for(var/adj in base_adjs)
		if(cut_link && src == cut_link)
			continue

		out_adjs.Add(adj)

	return out_adjs

/proc/fCombatantAdjacents(var/S, var/mob/owner)
	if(!S)
		return

	var/turf/s = get_turf(S)
	if(!s)
		return

	var/list/base_adjs = s.CardinalTurfsNoblocks()
	var/list/out_adjs = list()

	var/cut_link = null
	//var/cut_link = owner?.brain?.GetMemoryValue("BadStartTile", null)

	for(var/adj in base_adjs)
		if(cut_link && S == cut_link)
			continue

		out_adjs.Add(adj)

	return out_adjs


/proc/mCombatantAdjacents(var/mob/owner)
	if(!owner)
		return

	var/turf/s = get_turf(owner)
	if(!s)
		return

	var/list/out_adjs = call(s, TYPE_PROC_REF(/turf, CombatantAdjacents))(owner)

	return out_adjs

