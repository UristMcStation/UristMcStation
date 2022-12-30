/* In this module:
===================

 - AI Mainloop (Life()/LifeTick())
 - Init for subsystems per AI (by extension - it's in Life())

*/


/datum/goai
	var/name = "GOAI"
	var/life = GOAI_AI_ENABLED

	var/list/needs
	var/list/states
	var/list/actionslist
	var/list/actionlookup
	var/list/inventory
	var/list/senses

	var/last_update_time
	var/list/last_need_update_times
	var/last_action_update_time

	var/planning_iter_cutoff = 30
	var/pathing_dist_cutoff = 60

	var/datum/brain/brain

	// Private-ish, generally only debug procs should touch these
	var/ai_tick_delay = COMBATAI_AI_TICK_DELAY
	var/registry_index

	// Optional - for map editor. Set this to force initial action. Must be valid (in available actions).
	var/initial_action = null


/datum/goai/New(var/active = null)
	..()

	/*
	// Controls whether to call Life(), effectively activating the AI logic.
	//
	// You might want to have it disabled if you want to manage the AI 'lifecycle'
	// manually. For example, have the AI only activate when a player first moves
	// nearby.
	*/
	var/true_active = (isnull(active) ? TRUE : active)

	var/spawn_time = world.time
	src.last_update_time = spawn_time
	src.actionlookup = src.InitActionLookup()  // order matters!
	src.actionslist = src.InitActionsList()

	src.PreSetupHook()

	src.brain = src.CreateBrain(actionslist)
	src.InitNeeds()
	src.InitStates()
	src.UpdateBrain()
	src.InitRelations()
	src.InitSenses()

	src.PostSetupHook()

	if(true_active)
		src.Life()


/datum/goai/Destroy()
	. = ..()

	if(!(isnull(src.registry_index)))
		GLOB?.global_goai_registry[src.registry_index] = null

	qdel(src.brain)
	return


/datum/goai/proc/LifeTick()
	return TRUE


/datum/goai/proc/RegisterAI()
	// Registry pattern, to facilitate querying all GOAI AIs in verbs

	GLOB?.global_goai_registry += src
	src.registry_index = GLOB?.global_goai_registry.len

	if(!(src.name))
		src.name = src.registry_index

	return GLOB?.global_goai_registry



/datum/goai/proc/Life()
	src.RegisterAI()
	// LifeTick WOULD be called here (in a loop) like so...:
	/*
		spawn(0)
			while(src.life)
				src.LifeTick()
	*/
	// ...except this would just spin its wheels here, and children
	//    will need to override this anyway to add additional systems
	return TRUE


/datum/goai/proc/SetState(var/key, var/val)
	if(!key)
		return

	states[key] = val

	if(brain)
		brain.SetState(key, val)

	return TRUE


/datum/goai/proc/GetState(var/key, var/default = null)
	if(!key)
		return

	if(brain && (key in brain.states))
		return brain.GetState(key, default)

	if(key in states)
		return states[key]

	return default
