/datum/utility_ai
	var/name = "utility AI"
	var/life = TRUE
	var/paused = FALSE

	var/list/needs

	var/datum/brain/utility/brain
	var/list/actionslist
	var/list/actionlookup

	var/list/senses // array, primary DS for senses
	var/list/senses_index // assoc, used for quick lookups/access only

	// Private-ish, generally only debug procs should touch these
	var/ai_tick_delay = UTILITYAI_AI_TICK_DELAY
	var/senses_tick_delay = COMBATAI_SENSE_TICK_DELAY

	var/registry_index

	// Optional - for map editor. Set this to force initial action. Must be valid (in available actions).
	var/initial_action = null

	// Dynamically attached junk
	var/dict/attachments


/datum/utility_ai/proc/InitActionLookup()
	/* Largely redundant; initializes handlers, but
	// InitActions should generally use AddAction
	// with a handler arg to register them.
	// Mostly a relic of past design iterations.
	*/
	var/list/new_actionlookup = list()
	return new_actionlookup


/datum/utility_ai/proc/InitActionsList()
	var/list/new_actionslist = list()
	return new_actionslist


/datum/utility_ai/proc/InitNeeds()
	src.needs = list()
	return src.needs


/datum/utility_ai/proc/InitRelations()
	if(!(src.brain))
		return

	var/datum/relationships/relations = src.brain.relations
	if(isnull(relations) || !istype(relations))
		relations = new()

	src.brain.relations = relations
	return relations


/datum/utility_ai/proc/PreSetupHook()
	return


/datum/utility_ai/New(var/active = null)
	..()

	/*
	// Controls whether to call Life(), effectively activating the AI logic.
	//
	// You might want to have it disabled if you want to manage the AI 'lifecycle'
	// manually. For example, have the AI only activate when a player first moves
	// nearby.
	*/
	var/true_active = (isnull(active) ? TRUE : active)

	//var/spawn_time = world.time
	//src.last_update_time = spawn_time
	src.attachments = new()
	src.actionlookup = src.InitActionLookup()  // order matters!
	src.actionslist = src.InitActionsList()

	//src.PreSetupHook()

	src.brain = src.CreateBrain()
	src.InitNeeds()
	//src.InitStates()
	src.UpdateBrain()
	src.InitRelations()
	src.InitSenses()

	//src.PostSetupHook()

	if(true_active)
		src.Life()


/datum/utility_ai/proc/CleanDelete()
	src.life = FALSE

	var/datum/brain/mybrain = src.brain
	if(mybrain && istype(mybrain))
		mybrain.CleanDelete()

	deregister_ai(src.registry_index)
	return TRUE


# ifdef GOAI_SS13_SUPPORT
/datum/utility_ai/Destroy()
	src.CleanDelete()
	. = ..()
	return
# endif


/datum/utility_ai/proc/ShouldCleanup()
	// purely logical, doesn't DO the cleanup
	return FALSE


/datum/utility_ai/proc/CheckForCleanup()
	// purely application, runs ShouldCleanup() and handles state as needed
	// this is just an abstract method for overrides to plug into though
	return FALSE


/datum/utility_ai/proc/LifeTick()
	return TRUE


/datum/utility_ai/proc/Life()
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


/*
/datum/utility_ai/proc/SetState(var/key, var/val)
	if(!key)
		return

	states[key] = val

	if(brain)
		brain.SetState(key, val)

	return TRUE


/datum/utility_ai/proc/GetState(var/key, var/default = null)
	if(!key)
		return

	if(brain && (key in brain.states))
		return brain.GetState(key, default)

	if(key in states)
		return states[key]

	return default
*/

