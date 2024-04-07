/* This is the minimal Brain datum interface.
//
// Think of this as a template for writing an actual Brain class.
// If you're looking for an implementation, look for `/datum/brain/concrete`
// in: ./concrete_brains/_concrete.dm
*/


/datum/brain
	var/name = "brain"
	var/life = 1
	var/list/needs
	var/list/states
	var/list/actionslist
	var/list/active_plan

	/* Used to monitor if the brain has gotten 'stuck', unable to create a new plan.
	// This can be observed downstream (even in other objects) by a handler.
	// Successfully creating a plan resets this to TRUE.
	*/
	var/last_plan_successful = TRUE


	/* Memory container; key-value map.
	//
	// Memories are effectively GOAI's Blackboard System:
	// the forum for different AI subsystems (e.g. actions,
	// senses, etc.) to query and post relevant information to.
	//
	// Memories can be _volatile_ - i.e. expire after a set Time-To-Live (TTL).
	//
	// Memories' keys are strings and the values are Memory instances.
	// A Memory is a TTL wrapper around an arbitrary-typed value.
	// The stored value can be accessed using the `.val` attribute.
	*/
	var/dict/memories


	/* Personality container.
	//
	// A simple key-value map; keys are aspects of personality, vals are arbitrary (but probably numeric).
	// This is designed to not overload Memories with handling fixed traits while also being simpler to use.
	//
	// This is a KVMap to provide 'interop' between brains in different mobs after transplanting brains.
	// If a mob's body doesn't use some aspect of personality, it can just ignore it. If it's missing, it
	// can provide a fallback value.
	//
	// This is in contrast to a struct-ey/OOP approach of declaring traits as attributes of a datum subclass;
	// while it's likely a fair bit faster, we lose the brain's 'portability', and the allocations should be
	// fairly light anyway. If access is slow, consider caching the value in the mob variables.
	*/
	var/list/personality

	// Optionally, filepath to generate a personality from a template
	var/personality_template_filepath = null


	/* Optional 'parent' brain ref.
	//
	// Can be used to simulate literal hiveminds, but also
	// various lower-granularity planners, e.g. squads or
	// organisations or a mob's 'strategic' planner that
	// informs the 'tactical'/'operational' planners' goals.
	//
	// IMPORTANT: this hierarchy should form a (Directed) Acyclic Graph!
	*/
	var/datum/brain/hivemind

	/* Dict containing sensory data indexed by sense key. */
	var/dict/perceptions

	/* Faction-esque data; relation modifiers by tag. */
	var/datum/relationships/relations

	// For relations: if less than this, we are hostile to the target, if more - neutral (or allied)
	var/hostility_threshold = -5

	// For relations: if higher than this, we treat the target as an ally
	var/ally_threshold = 50

	/* Bookkeeping for action execution */
	var/is_planning = 0
	var/list/pending_instant_actions = null
	var/selected_action = null
	var/datum/ActionTracker/running_action_tracker = null

	/* Bookkeeping for update times */
	var/list/last_need_update_times
	var/last_mob_update_time
	var/last_action_update_time

	/* GOAP parameters */
	var/planning_iter_cutoff = 30
	var/datum/GOAP/planner

	/* Dynamically attached junk */
	var/dict/attachments

	/* Cleanup stuff */
	var/registry_index // our index in the Big Brain List

	// If positive, number of ticks before we deregister & delete ourselves.
	var/cleanup_detached_threshold = DEFAULT_ORPHAN_CLEANUP_THRESHOLD

	// Tracker for the cleanup
	var/_ticks_since_detached = 0


/datum/brain/New(var/list/actions = null, var/list/init_memories = null, var/init_action = null, var/datum/brain/with_hivemind = null, var/list/init_personality = null, var/newname = null, var/dict/init_relationships = null)
	..()

	src.name = (newname ? newname : name)

	src.memories = new /dict(init_memories)
	src.hivemind = with_hivemind

	src.last_need_update_times = list()
	src.perceptions = new()
	src.relations = new(init_relationships)
	PUT_EMPTY_LIST_IN(src.pending_instant_actions)
	src.attachments = new()
	src.RegisterBrain()

	if(init_personality)
		src.personality = init_personality

	else if(isnull(src.personality) && !isnull(src.personality_template_filepath))
		src.personality = PersonalityTemplateFromJson(src.personality_template_filepath)

	if(actions)
		src.actionslist = actions.Copy()

	if(init_action && (init_action in actionslist))
		src.running_action_tracker = DoAction(init_action)

	src.InitNeeds()
	src.InitStates()

	return


/datum/brain/proc/CleanDelete()
	src.life = FALSE
	qdel(src)
	return TRUE


/datum/brain/proc/InitNeeds()
	src.needs = list()
	return needs


/datum/brain/proc/InitStates()
	src.states = list()
	return states


/* Stubs. Should implement properly in the subclasses! */
/datum/brain/proc/ShouldCleanup()
	return FALSE


/datum/brain/proc/CheckForCleanup()
	return FALSE


/datum/brain/proc/Life()
	/* Something like the commented-out block below *SHOULD* be here as it's a base class
	// but since this runs an infinite ticker loop, I didn't want to waste CPU cycles running
	// procs that just do a 'return' forever. May get restored later at some point if having
	// a solid ABC outweighs the risks.

	while(life)
		LifeTick()
		sleep(AI_TICK_DELAY)
	*/
	return


/datum/brain/proc/LifeTick()
	return


/datum/brain/proc/CreatePlan(var/list/status, var/list/goal, var/list/actions = null)
	return


/datum/brain/proc/AbortPlan()
	return


/datum/brain/proc/GetAvailableActions()
	/* Abstraction layer over Action updates.
	// We need this to let nearby Smart Objects etc. yield
	// Actions to the planner.
	*/

	var/list/available_actions = list()

	for(var/action_key in src.actionslist)
		// Filter out actions w/o charges and non-action items.
		var/datum/goai_action/action = src.actionslist[action_key]

		if(!action)
			continue

		if(action.charges < 1)
			continue

		if(!(action.IsValid()))
			continue

		var/new_cost = action.ReviewPriority()
		if(!(isnull(new_cost)))
			action.cost = new_cost

		available_actions[action_key] = action

	src.actionslist = available_actions
	return available_actions


/datum/brain/proc/AddAction(var/name, var/list/preconds, var/list/effects, var/cost = null, var/charges = PLUS_INF, var/instant = FALSE, clone = FALSE, var/list/action_args = null, var/list/act_validators = null, var/cost_checker = null)
	/*
	//
	// - clone (bool): If TRUE (default), the list is a clone of the actionslist (slower, but safer).
	//                 If FALSE, a reference to the list is returned (faster, but harder to predict)
	*/
	ADD_ACTION_DEBUG_LOG("Adding action [name] with [cost] cost, [charges] charges")
	var/list/available_actions = (clone ? src.actionslist.Copy() : src.actionslist) || list()

	var/datum/goai_action/Action = null
	if(name in available_actions)
		Action = available_actions[name]

	if(isnull(Action) || (!istype(Action)))
		Action = new(preconds, effects, cost, name, charges, instant, action_args, act_validators, cost_checker)

	else
		// If an Action with the same key exists, we can update the existing object rather than reallocating!
		SET_IF_NOT_NULL(cost, Action.cost)
		SET_IF_NOT_NULL(preconds, Action.preconditions)
		SET_IF_NOT_NULL(effects, Action.effects)
		SET_IF_NOT_NULL(charges, Action.charges)
		SET_IF_NOT_NULL(instant, Action.instant)
		SET_IF_NOT_NULL(action_args, Action.arguments)
		SET_IF_NOT_NULL(act_validators, Action.validators)
		SET_IF_NOT_NULL(cost_checker, Action.cost_updater)


	available_actions[name] = Action

	return Action


/datum/brain/proc/IsActionValid(var/action_key)
	/* Brain-side Action validation.
	//
	// An Action is considered invalid if it doesn't make sense to run it.
	// For instance, if the target of the Action has been deleted, we might
	// as well not even start it.
	//
	// Preconditions violation at run-time DOES NOT *ALWAYS* make the Action
	// invalid - Preconds are primarily constraints for _planning_ and can be
	// fudged sometimes to generate specific behaviours.
	//
	// For that matter, INVALID =/= FAILED!
	// INVALID *roughly* maps to 'failed before we even started' or 'not in a runnable state'
	// Failed Actions have started, but for whatever reason we're cancelling them before completion.
	*/

	if(!action_key)
		// Nonexistence is futile.
		VALIDATE_ACTION_DEBUG_LOG("[src] VALIDATION - KEYLESS [action_key]")
		return FALSE

	if(!(action_key in src.actionslist))
		// 'Phantom' actions not allowed!
		VALIDATE_ACTION_DEBUG_LOG("[src] VALIDATION - PHANTOM [action_key]")
		return FALSE

	var/datum/goai_action/checked_action = src.actionslist[action_key]

	if(!checked_action)
		// Nonexistence is futile.
		VALIDATE_ACTION_DEBUG_LOG("[src] VALIDATION - NONEXISTENCE [action_key]/[checked_action]")
		return FALSE

	// Ask the Action to do its own checks:
	var/actionside_valid = checked_action.IsValid()

	if(!actionside_valid)
		// Trust the Action's opinion.
		VALIDATE_ACTION_DEBUG_LOG("[src] VALIDATION - ACTIONSIDE [action_key]/[checked_action]")
		return FALSE

	return TRUE


/datum/brain/proc/GetState(var/key, var/default = null)
	if(isnull(src.states))
		return default

	var/found = (key in src.states)
	var/result = (found ? src.states[key] : default)
	return result


/datum/brain/proc/SetState(var/key, var/val)
	if(isnull(src.states))
		src.states = new()

	src.states[key] = val
	return TRUE


/datum/brain/proc/GetNeed(var/key, var/default = null)
	if(isnull(src.needs))
		return default

	var/found = (key in src.needs)
	var/result = (found ? src.needs[key] : default)
	return result


/datum/brain/proc/SetNeed(var/key, var/val)
	if(isnull(needs))
		src.needs = new()

	src.needs[key] = val
	return TRUE


/datum/brain/proc/HasMemory(var/mem_key)
	var/found = (mem_key in memories.data)
	return found


/datum/brain/proc/GetMemory(var/mem_key, var/default = null, var/by_age = FALSE, var/check_hivemind = FALSE, var/recursive = FALSE, var/prefer_hivemind = FALSE)
	var/datum/memory/retrieved_mem = null
	var/datum/memory/hivemind_mem = null

	if(check_hivemind && hivemind && hivemind.memories && hivemind.HasMemory(mem_key))
		// The last two args are (..., recursive, recursive) ON PURPOSE!
		// IFF recursive is TRUE, the parent mind should check for grandparents and so on.
		// Root can have check_hivemind = TRUE and recursive = FALSE to only recurse 1-lvl deep.
		hivemind_mem = hivemind.GetMemory(mem_key, null, by_age, recursive, recursive)

		if(istype(hivemind_mem) && prefer_hivemind)
			// If prefer_hivemind is TRUE, we don't need to bother with mob memories
			// once we have found a hivemind memory.
			return hivemind_mem

	if(HasMemory(mem_key))
		retrieved_mem = memories.Get(mem_key, null)

		if(isnull(retrieved_mem))

			if(isnull(hivemind_mem))
				return default

			// if root has no memory, but the *parent* does - return parent's
			return hivemind_mem

		var/relevant_age = by_age ? retrieved_mem.GetAge() : retrieved_mem.GetFreshness()

		if(relevant_age < retrieved_mem.ttl)
			// We already checked for parent preference - no need to redo that.
			return retrieved_mem

		memories[mem_key] = null

	return (isnull(hivemind_mem) ? default : hivemind_mem)


/datum/brain/proc/GetMemoryValue(var/mem_key, var/default = null, var/by_age = FALSE, var/check_hivemind = FALSE, var/recursive = FALSE, var/prefer_hivemind = FALSE)
	// Like GetMemory, but resolves the Memory object to the stored value.
	// This is a bit lossy, but 99% of the time that's all you care about.
	var/datum/memory/retrieved_mem = GetMemory(mem_key, null, by_age, check_hivemind, recursive, prefer_hivemind)
	var/memory_value = retrieved_mem?.val
	return (isnull(memory_value) ? default : memory_value)


/datum/brain/proc/SetMemory(var/mem_key, var/mem_val, var/mem_ttl)
	var/datum/memory/retrieved_mem = memories.Get(mem_key)

	if(isnull(retrieved_mem))
		retrieved_mem = new(mem_val, mem_ttl)
		memories.Set(mem_key, retrieved_mem)

	else
		retrieved_mem.Update(mem_val, mem_ttl)

	return retrieved_mem


/datum/brain/proc/DropMemory(var/mem_key)
	memories.Set(mem_key, null)
	return


/datum/brain/proc/GetPersonalityTrait(var/trait_key, var/default = null)
	if(isnull(personality))
		return default

	if(!(trait_key in personality))
		return default

	var/val = personality[trait_key]
	if(isnull(val))
		return default

	return val


/datum/brain/proc/GetAiController()
	FetchAiControllerForObjIntoVar(src, var/datum/commander)
	return commander
