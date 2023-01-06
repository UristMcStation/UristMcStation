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

	// Dynamically attached junk
	var/dict/attachments


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
	src.attachments = new()
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


/datum/goai/proc/CleanDelete()
	src.life = 0

	var/datum/brain/mybrain = src.brain
	if(mybrain && istype(mybrain))
		mybrain.CleanDelete()

	deregister_ai(src.registry_index)
	return TRUE


# ifdef GOAI_SS13_SUPPORT
/datum/goai/Destroy()
	src.CleanDelete()
	. = ..()
	return
# endif


/datum/goai/proc/ShouldCleanup()
	// purely logical, doesn't DO the cleanup
	return FALSE


/datum/goai/proc/CheckForCleanup()
	// purely application, runs ShouldCleanup() and handles state as needed
	// this is just an abstract method for overrides to plug into though
	return FALSE


/datum/goai/proc/LifeTick()
	return TRUE


/datum/goai/proc/Life()
	src.RegisterAI()
	// LifeTick WOULD be called here (in a loop) like so...:
	/*
		spawn(0)
			while(src.life)
				src.CheckForCleanup()
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
