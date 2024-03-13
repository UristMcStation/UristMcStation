
# ifdef GOAI_LIBRARY_FEATURES

# define GUN_ACTIONSET_PATH "goai_data/smartobject_definitions/gun.json"

/obj/item/gun/GetUtilityActions(var/requester, var/list/args = null) // (Any, assoc) -> [ActionSet]
	var/list/my_action_sets = list()

	ASSERT(fexists(GUN_ACTIONSET_PATH))
	var/datum/action_set/myset = ActionSetFromJsonFile(GUN_ACTIONSET_PATH)

	myset.origin = src

	my_action_sets.Add(myset)
	return my_action_sets


/obj/item/gun/HasUtilityActions(var/requester, var/list/args = null) // (Any, assoc) -> [ActionSet]
	return TRUE

# endif


# ifdef GOAI_SS13_SUPPORT

# define GUN_ACTIONSET_PATH "goai_data/smartobject_definitions/gun.json"

/obj/item/gun/GetUtilityActions(var/requester, var/list/args = null) // (Any, assoc) -> [ActionSet]
	var/list/my_action_sets = list()

	ASSERT(fexists(GUN_ACTIONSET_PATH))
	var/datum/action_set/myset = ActionSetFromJsonFile(GUN_ACTIONSET_PATH)

	myset.origin = src

	my_action_sets.Add(myset)
	return my_action_sets


/obj/item/gun/HasUtilityActions(var/requester, var/list/args = null) // (Any, assoc) -> [ActionSet]
	return TRUE

# endif