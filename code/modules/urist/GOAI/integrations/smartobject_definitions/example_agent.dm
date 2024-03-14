
# define EXAMPLEAGENT_ACTIONSET_PATH "goai_data/smartobject_definitions/example_agent.json"


/mob/living/simple_animal/aitester


/mob/living/simple_animal/aitester/GetUtilityActions(var/requester, var/list/args = null) // (Any, assoc) -> [ActionSet]

	var/list/my_action_sets = list()

	ASSERT(fexists(EXAMPLEAGENT_ACTIONSET_PATH))
	var/datum/action_set/myset = ActionSetFromJsonFile(EXAMPLEAGENT_ACTIONSET_PATH)

	myset.origin = src

	my_action_sets.Add(myset)
	return my_action_sets


/mob/living/simple_animal/aitester/HasUtilityActions(var/requester, var/list/args = null) // (Any, assoc) -> bool
	// TRUE only if the requesting AI is supposed to have control over this mob.
	return (requester == src)


# ifdef GOAI_SS13_SUPPORT

/* Generic, for all hostile simplemobs; will likely repleace with more specific variants later */

# define SIMPLEMOB_ACTIONSET_PATH "goai_data/smartobject_definitions/simplemob_agent.json"

/mob/living/simple_animal/hostile/GetUtilityActions(var/requester, var/list/args = null) // (Any, assoc) -> [ActionSet]

	var/list/my_action_sets = list()

	ASSERT(fexists(EXAMPLEAGENT_ACTIONSET_PATH))
	var/datum/action_set/myset = ActionSetFromJsonFile(SIMPLEMOB_ACTIONSET_PATH)

	myset.origin = src

	my_action_sets.Add(myset)
	return my_action_sets


/mob/living/simple_animal/hostile/HasUtilityActions(var/requester, var/list/args = null) // (Any, assoc) -> bool
	// TRUE only if the requesting AI is supposed to have control over this mob.
	return (requester == src)


/* Real human bean */

# define HUMAN_ACTIONSET_PATH "goai_data/smartobject_definitions/humanoid_agent.json"

/mob/living/carbon/human/GetUtilityActions(var/requester, var/list/args = null) // (Any, assoc) -> [ActionSet]

	var/list/my_action_sets = list()

	ASSERT(fexists(EXAMPLEAGENT_ACTIONSET_PATH))
	var/datum/action_set/myset = ActionSetFromJsonFile(HUMAN_ACTIONSET_PATH)

	myset.origin = src

	my_action_sets.Add(myset)
	return my_action_sets


/mob/living/carbon/human/HasUtilityActions(var/requester, var/list/args = null) // (Any, assoc) -> bool
	// TRUE only if the requesting AI is supposed to have control over this mob.
	return (requester == src)

# endif
