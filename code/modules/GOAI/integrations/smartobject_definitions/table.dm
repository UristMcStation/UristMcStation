
# ifdef GOAI_LIBRARY_FEATURES

# define TABLE_ACTIONSET_PATH "integrations/smartobject_definitions/table.json"

/obj/cover/table/GetUtilityActions(var/requester, var/list/args = null) // (Any, assoc) -> [ActionSet]

	var/list/my_action_sets = list()

	ASSERT(fexists(TABLE_ACTIONSET_PATH))
	var/datum/action_set/myset = ActionSetFromJsonFile(TABLE_ACTIONSET_PATH)

	myset.origin = src

	my_action_sets.Add(myset)
	return my_action_sets


/obj/cover/table/HasUtilityActions(var/requester, var/list/args = null) // (Any, assoc) -> bool
	var/atom/requester_atom = requester

	if(isnull(requester_atom))
		return FALSE

	if(get_dist(requester_atom, src) > 1)
		return FALSE

	return TRUE

# endif
