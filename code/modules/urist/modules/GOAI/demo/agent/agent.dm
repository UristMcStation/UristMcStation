# define STEP_SIZE 1
# define STEP_COUNT 1


/mob/goai
	var/life = GOAI_AI_ENABLED
	icon = 'icons/mob/human_races/species/human/body.dmi'
	icon_state = "bay_preview"
	var/list/needs
	var/list/states
	var/list/actionslist
	var/list/actionlookup
	var/list/inventory
	var/list/senses

	var/datum/ActivePathTracker/active_path

	var/is_repathing = 0
	var/is_moving = 0

	var/list/last_need_update_times
	var/last_mob_update_time
	var/last_action_update_time

	var/planning_iter_cutoff = 30
	var/pathing_dist_cutoff = 60

	var/datum/brain/brain


/mob/goai/verb/Posess()
	set src in view()

	if(!(usr && usr.client))
		return

	if(usr.loc == src)
		usr.loc = src.loc
		return

	usr.loc = src

	return


/mob/goai/proc/InitActionLookup()
	/* Largely redundant; initializes handlers, but
	// InitActions should generally use AddAction
	// with a handler arg to register them.
	// Mostly a relic of past design iterations.
	*/
	var/list/new_actionlookup = list()
	return new_actionlookup


/mob/goai/proc/InitActionsList()
	var/list/new_actionslist = list()
	return new_actionslist


/mob/goai/proc/AddAction(var/name, var/list/preconds, var/list/effects, var/handler, var/cost = null, var/charges = PLUS_INF, var/instant = FALSE, var/list/action_args = null)
	if(charges < 1)
		return

	var/datum/goai_action/newaction = new(preconds, effects, cost, name, charges, instant, action_args)

	actionslist = (isnull(actionslist) ? list() : actionslist)
	actionslist[name] = newaction

	if(handler)
		actionlookup = (isnull(actionlookup) ? list() : actionlookup)
		actionlookup[name] = handler

	if(brain)
		brain.AddAction(name, preconds, effects, cost, charges, instant, action_args)

	return newaction


/mob/goai/proc/GeneratePersonality()
	var/dict/new_personality = new()
	return new_personality


/mob/goai/proc/CreateBrain(var/list/custom_actionslist = null, var/list/init_memories = null, var/list/init_action = null, var/datum/brain/with_hivemind = null, var/dict/custom_personality = null)
	var/list/new_actionslist = (custom_actionslist ? custom_actionslist : actionslist)
	var/dict/new_personality = (isnull(custom_personality) ? GeneratePersonality() : custom_personality)
	var/datum/brain/concrete/new_brain = new(new_actionslist, init_memories, init_action, with_hivemind, new_personality)
	new_brain.states = states ? states.Copy() : new_brain.states
	return new_brain


/mob/goai/New(var/active = null)
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
	src.last_mob_update_time = spawn_time
	src.actionlookup = src.InitActionLookup()  // order matters!
	src.actionslist = src.InitActionsList()

	src.Equip()
	src.brain = src.CreateBrain(actionslist)
	src.InitNeeds()
	src.InitStates()
	src.UpdateBrain()
	src.InitSenses()

	if(true_active)
		src.Life()


/mob/goai/proc/InitSenses()
	senses = list()
	return senses


/mob/goai/proc/InitNeeds()
	needs = list()
	return needs


/mob/goai/proc/InitStates()
	states = list()
	return states


/mob/goai/proc/Equip()
	return TRUE


/mob/goai/proc/UpdateBrain()
	if(!brain)
		return

	brain.needs = needs.Copy()
	brain.states = states.Copy()

	return TRUE


/mob/goai/Life()
	return TRUE


/mob/goai/proc/SetState(var/key, var/val)
	if(!key)
		return

	states[key] = val

	if(brain)
		brain.SetState(key, val)

	return TRUE


/mob/goai/proc/GetState(var/key, var/default = null)
	if(!key)
		world.log << "[src]: [key] is null!"
		return

	if(brain && (key in brain.states))
		return brain.GetState(key, default)

	if(key in states)
		return states[key]

	return default


/mob/goai/verb/Say(words as text)
	world << "([name]) says: '[words]'"

