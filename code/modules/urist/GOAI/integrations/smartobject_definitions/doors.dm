
# ifdef GOAI_LIBRARY_FEATURES

# define DOOR_ACTIONSET_PATH "goai_data/smartobject_definitions/door.json"
# define AUTODOOR_ACTIONSET_PATH "goai_data/smartobject_definitions/autodoor.json"

/obj/cover/door/GetUtilityActions(var/requester, var/list/args = null) // (Any, assoc) -> [ActionSet]

	var/list/my_action_sets = list()

	ASSERT(fexists(DOOR_ACTIONSET_PATH))
	var/datum/action_set/myset = ActionSetFromJsonFile(DOOR_ACTIONSET_PATH)

	myset.origin = src

	my_action_sets.Add(myset)
	return my_action_sets


/obj/cover/door/HasUtilityActions(var/requester, var/list/args = null) // (Any, assoc) -> bool
	var/atom/requester_atom = requester

	if(isnull(requester_atom))
		return FALSE

	if(get_dist(requester_atom, src) > 1)
		return FALSE

	return TRUE


/obj/cover/autodoor/GetUtilityActions(var/requester, var/list/args = null) // (Any, assoc) -> [ActionSet]
	var/list/my_action_sets = list()

	ASSERT(fexists(AUTODOOR_ACTIONSET_PATH))
	var/datum/action_set/myset = ActionSetFromJsonFile(AUTODOOR_ACTIONSET_PATH)

	myset.origin = src

	my_action_sets.Add(myset)
	return my_action_sets


/obj/cover/autodoor/HasUtilityActions(var/requester, var/list/args = null) // (Any, assoc) -> bool
	var/atom/requester_atom = requester

	if(isnull(requester_atom))
		return FALSE

	if(get_dist(requester_atom, src) > 1)
		return FALSE

	return TRUE


# endif
