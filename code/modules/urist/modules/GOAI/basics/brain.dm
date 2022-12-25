// # define ADD_ACTION_DEBUG_LOGGING 0

# ifdef ADD_ACTION_DEBUG_LOGGING
# define ADD_ACTION_DEBUG_LOG(X) world.log << X
# define ADD_ACTION_DEBUG_LOG_TOSTR(X) world.log << #X + ": [X]"
# else
# define ADD_ACTION_DEBUG_LOG(X)
# define ADD_ACTION_DEBUG_LOG_TOSTR(X)
# endif

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
	var/dict/personality


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

	/* Dict containing sensory data indexed by sense key.
	*/
	var/dict/perceptions

	/* Faction-esque data; relation modifiers by tag.
	*/
	var/datum/relationships

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


/datum/brain/New(var/list/actions = null, var/list/init_memories = null, var/init_action = null, var/datum/brain/with_hivemind = null, var/dict/init_personality = null, var/newname = null, var/dict/init_relationships = null)
	..()

	name = (newname ? newname : name)

	memories = new /dict(init_memories)
	hivemind = with_hivemind
	personality = (isnull(init_personality) ? personality : init_personality)
	last_need_update_times = list()
	perceptions = new()
	relationships = new(init_relationships)
	pending_instant_actions = list()

	if(actions)
		actionslist = actions.Copy()

	if(init_action && init_action in actionslist)
		running_action_tracker = DoAction(init_action)

	InitNeeds()
	InitStates()

	return


/datum/brain/proc/InitNeeds()
	needs = list()
	return needs


/datum/brain/proc/InitStates()
	states = list()
	return states


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

	for(var/action_key in actionslist)
		// Filter out actions w/o charges and non-action items.
		var/datum/goai_action/action = actionslist[action_key]

		if(!action)
			continue

		if(action.charges < 1)
			continue

		available_actions[action_key] = action

	actionslist = available_actions
	return available_actions


/datum/brain/proc/AddAction(var/name, var/list/preconds, var/list/effects, var/cost = null, var/charges = PLUS_INF, var/instant = FALSE, clone = FALSE, var/list/action_args = null)
	/*
	//
	// - clone (bool): If TRUE (default), the list is a clone of the actionslist (slower, but safer).
	//                 If FALSE, a reference to the list is returned (faster, but harder to predict)
	*/
	ADD_ACTION_DEBUG_LOG("Adding action [name] with [cost] cost, [charges] charges")
	var/list/available_actions = (clone ? actionslist.Copy() : actionslist) || list()
	var/datum/goai_action/newaction = new(preconds, effects, cost, name, charges, instant, action_args)
	available_actions[name] = newaction

	return newaction


/datum/brain/proc/GetState(var/key, var/default = null)
	if(isnull(states))
		return default

	var/found = (key in states)
	var/result = (found ? states[key] : default)
	return result


/datum/brain/proc/SetState(var/key, var/val)
	if(isnull(states))
		states = new()

	states[key] = val
	return TRUE


/datum/brain/proc/GetNeed(var/key, var/default = null)
	if(isnull(needs))
		return default

	var/found = (key in needs)
	var/result = (found ? needs[key] : default)
	return result


/datum/brain/proc/SetNeed(var/key, var/val)
	if(isnull(needs))
		needs = new()

	needs[key] = val
	return TRUE


/datum/brain/proc/HasMemory(var/mem_key)
	var/found = (mem_key in memories.data)
	//world.log << "Memory for key [mem_key] [found ? "TRUE" : "FALSE"]"
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
				//world.log << "Retrieved default Memory for removed [mem_key]"
				return default

			// if root has no memory, but the *parent* does - return parent's
			return hivemind_mem

		var/relevant_age = by_age ? retrieved_mem.GetAge() : retrieved_mem.GetFreshness()

		if(relevant_age < retrieved_mem.ttl)
			//world.log << "Retrieved Memory: [mem_key]"
			// We already checked for parent preference - no need to redo that.
			return retrieved_mem

		memories[mem_key] = null

	//world.log << "Retrieved default Memory for missing [mem_key]"
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
		//world.log << "Inserting Memory for [mem_key] with [mem_val]"
		retrieved_mem = new(mem_val, mem_ttl)
		memories.Set(mem_key, retrieved_mem)

	else
		//world.log << "Updating Memory for [mem_key] with [mem_val]"
		retrieved_mem.Update(mem_val)

	return retrieved_mem


/datum/brain/proc/DropMemory(var/mem_key)
	memories.Set(mem_key, null)
	return


/datum/brain/proc/GetPersonalityTrait(var/trait_key, var/default = null)
	if(isnull(personality?.data))
		return default

	return personality.Get(trait_key, default)


/* Concrete implementation of the Brain logic using GOAP planners */
/datum/brain/concrete


/datum/brain/concrete/CreatePlan(var/list/status, var/list/goal, var/list/actions = null)
	is_planning = 1
	var/list/path = null

	var/list/params = list()
	// You don't have to pass args like this; this is just to make things a bit more readable.
	params["start"] = status
	params["goal"] = goal
	/* For functional API variant:
	params["graph"] = available_actions
	params["adjacent"] = /proc/get_actions_agent
	params["check_preconds"] = /proc/check_preconds_agent
	params["goal_check"] = /proc/goal_checker_agent
	params["get_effects"] = /proc/get_effects_agent
	*/
	params["cutoff_iter"] = planning_iter_cutoff

	// For the classy API variant:
	/* Dynamically update actions; this isn't strictly necessary for a simple AI,
	// but it lets us do things like Smart Object updating our actionspace by
	// serving 'their' actions (similar to how BYOND Verbs can broadcast themselves
	// to other nearby objects with set src in whatever).
	*/
	planner.graph = GetAvailableActions()

	for(var/goalkey in goal)
		world.log << "[src] CreatePlan goal: [goalkey] => [goal[goalkey]]"

	/*for(var/graphkey in planner.graph)
		world.log << "[src] CreatePlan Planner graph: [graphkey] => [planner.graph[graphkey]]"*/

	var/datum/Tuple/result = planner.Plan(arglist(params))

	if(result)
		path = result.right
		last_plan_successful = TRUE

	else
		last_plan_successful = FALSE

	is_planning = 0
	return path


/datum/brain/concrete/Life()
	while(life)
		LifeTick()
		sleep(AI_TICK_DELAY)
	return


/datum/brain/concrete/proc/OnBeginLifeTick()
	return


/datum/brain/concrete/LifeTick()
	OnBeginLifeTick()

	if(running_action_tracker) // processing action
		var/running_is_active = running_action_tracker.IsRunning()
		world << "ACTIVE ACTION: [running_action_tracker.tracked_action] @ [running_is_active] | <@[src]>"

		if(running_action_tracker.IsStopped())
			running_action_tracker = null
			pending_instant_actions = list()

	else if(selected_action) // ready to go
		world << "SELECTED ACTION: [selected_action] | <@[src]>"
		running_action_tracker = DoAction(selected_action)
		selected_action = null

	else if(active_plan && active_plan.len)
		//step done, move on to the next
		world << "ACTIVE PLAN: [active_plan] ([active_plan.len]) | <@[src]>"

		while(active_plan.len && isnull(selected_action))
			// do instants in one tick
			selected_action = lpop(active_plan)

			if(!(selected_action in actionslist))
				continue

			var/datum/goai_action/goai_act = actionslist[selected_action]

			if(!goai_act)
				//world.log << "[src]: FAILED TO RETRIEVE ACTION [goai_act] from [Act]"
				continue

			if(goai_act.instant)
				world << "Instant ACTION: [selected_action] | <@[src]>"
				DoInstantAction(selected_action)
				selected_action = null

			else
				world << "Regular ACTION: [selected_action] | <@[src]>"

	else //no plan & need to make one
		var/list/curr_state = states.Copy()
		var/list/goal_state = list()

		for (var/need_key in needs)
			var/need_val = needs[need_key]
			curr_state[need_key] = need_val

			if (need_val < NEED_THRESHOLD)
				goal_state[need_key] = NEED_SAFELEVEL

		if (goal_state && goal_state.len && (!is_planning))
			//world.log << "Creating plan!"
			var/list/curr_available_actions = GetAvailableActions()

			spawn(0)
				var/list/raw_active_plan = CreatePlan(curr_state, goal_state, curr_available_actions)

				if(raw_active_plan)
					//world.log << "Created plan [raw_active_plan]"
					var/first_clean_pos = 0

					for (var/planstep in raw_active_plan)
						first_clean_pos++
						if(planstep in curr_available_actions)
							break

					raw_active_plan.Cut(0, first_clean_pos)
					active_plan = raw_active_plan
					last_plan_successful = TRUE

				else
					world.log << "Failed to create a plan | <@[src]>"


		else //satisfied, can be lazy
			Idle()

	return


/datum/brain/verb/DoAction(Act as anything in actionslist)
	//world.log << "DoAction act: [Act]"

	if(!(Act in actionslist))
		return null

	var/datum/goai_action/goai_act = actionslist[Act]

	if(!goai_act)
		//world.log << "[src]: FAILED TO RETRIEVE ACTION [goai_act] from [Act]"
		return null

	//world.log << "[src]: RETRIEVED ACTION [goai_act] from [Act]"
	var/datum/ActionTracker/new_actiontracker = new /datum/ActionTracker(goai_act)

	if(!new_actiontracker)
		world.log << "[src]: Failed to create a tracker for [goai_act]!"
		return null

	//world.log << "New Tracker: [new_actiontracker] [new_actiontracker.tracked_action] @ [new_actiontracker.creation_time]"
	running_action_tracker = new_actiontracker

	return new_actiontracker


/datum/brain/verb/DoInstantAction(Act as anything in actionslist)
	//world.log << "DoInstantAction act: [Act]"

	if(!(Act in actionslist))
		return null

	var/datum/goai_action/goai_act = actionslist[Act]

	if(!goai_act)
		//world.log << "[src]: FAILED TO RETRIEVE ACTION [goai_act] from [Act]"
		return null

	//world.log << "[src]: RETRIEVED ACTION [goai_act] from [Act]"
	var/datum/ActionTracker/new_actiontracker = new /datum/ActionTracker(goai_act)

	if(!new_actiontracker)
		world.log << "[src]: Failed to create a tracker for [goai_act]!"
		return null

	//world.log << "New Tracker: [new_actiontracker] [new_actiontracker.tracked_action] @ [new_actiontracker.creation_time]"

	pending_instant_actions.Add(new_actiontracker)

	return new_actiontracker


/datum/brain/concrete/proc/Idle()
	return


/datum/brain/concrete/AbortPlan()
	// Cancel current tracker, if any is running
	running_action_tracker?.SetFailed()
	running_action_tracker = null

	// Cancel all instant and regular Actions
	pending_instant_actions = list()
	active_plan = null

	// Mark the plan as failed
	last_plan_successful = FALSE

	return TRUE



/* Brain with decaying Motives, a'la The Sims */
/datum/brain/concrete/sim
	var/decay_per_dsecond = 0.1


/datum/brain/concrete/sim/New(var/list/actions, var/list/init_memories = null, var/init_action = null, var/datum/brain/with_hivemind = null, var/dict/init_personality = null, var/newname = null)
	..(actions, init_memories, init_action, with_hivemind, init_personality, newname)

	needs = list()
	needs[MOTIVE_SLEEP] = NEED_THRESHOLD
	needs[MOTIVE_FOOD] = NEED_THRESHOLD
	needs[MOTIVE_FUN] = NEED_THRESHOLD

	var/spawn_time = world.time
	last_mob_update_time = spawn_time
	last_action_update_time = spawn_time

	actionslist = actions

	var/datum/GOAP/demoGoap/new_planner = new /datum/GOAP/demoGoap(actionslist)
	planner = new_planner

	//Life()


/datum/brain/concrete/sim/proc/DecayNeeds()
	for (var/need_key in needs)
		MotiveDecay(need_key, null) // TODO: change this null to an assoc list lookup

	last_mob_update_time = world.time


/datum/brain/concrete/sim/OnBeginLifeTick()
	DecayNeeds()


/datum/brain/concrete/proc/GetMotive(var/motive_key)
	if(isnull(motive_key))
		return

	if(!(motive_key in needs))
		return

	var/curr_value = needs[motive_key]
	return curr_value


/datum/brain/concrete/proc/ChangeMotive(var/motive_key, var/value)
	if(isnull(motive_key))
		return

	var/fixed_value = min(NEED_MAXIMUM, max(NEED_MINIMUM, (value)))
	needs[motive_key] = fixed_value
	last_need_update_times[motive_key] = world.time
	world.log << "Curr [motive_key] = [needs[motive_key]] <@[src]>"


/datum/brain/concrete/proc/AddMotive(var/motive_key, var/amt)
	if(isnull(motive_key))
		return

	var/curr_val = needs[motive_key]
	ChangeMotive(motive_key, curr_val + amt)


/datum/brain/concrete/sim/proc/MotiveDecay(var/motive_key, var/custom_decay_rate = null)
	var/now = world.time
	var/decay_rate = (isnull(custom_decay_rate) ? decay_per_dsecond : custom_decay_rate)

	if(!(motive_key in last_need_update_times))
		last_need_update_times[motive_key] = now

	var/last_update_time = last_need_update_times[motive_key]
	var/deltaT = (world.time - last_update_time)
	var/curr_value = needs[motive_key]
	var/cand_tiredness = curr_value - deltaT * decay_rate

	ChangeMotive(motive_key, cand_tiredness)
