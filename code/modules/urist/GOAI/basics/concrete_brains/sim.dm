/* Brain with decaying Motives, a'la The Sims */
/datum/brain/concrete/sim
	var/decay_per_dsecond = 0.1


/datum/brain/concrete/sim/New(var/list/actions, var/list/init_memories = null, var/init_action = null, var/datum/brain/with_hivemind = null, var/list/init_personality = null, var/newname = null)
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
