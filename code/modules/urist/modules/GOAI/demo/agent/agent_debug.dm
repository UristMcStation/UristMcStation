
/mob/goai/verb/RebootGoai()
	set category = "Debug GOAI Agents"
	set src in view(1)

	LobotomizeGoai()

	sleep(0)
	life = 1

	var/datum/brain/new_brain = CreateBrain()
	brain = new_brain

	return


/mob/goai/proc/pLobotomizeGoai(var/stop_life = TRUE)
	if(stop_life)
		life = 0

	if(brain)
		brain.life = 0
		brain.active_plan = null
		brain.selected_action = null

		if(brain.running_action_tracker)
			brain.running_action_tracker.SetFailed()

		if(brain.running_action_tracker)
			brain.running_action_tracker = null

		del(brain)

	return


/mob/goai/verb/LobotomizeGoai()
	set category = "Debug GOAI Agents"
	set src in view(1)

	src.pLobotomizeGoai(stop_life = TRUE)



/mob/goai/verb/PauseGoai()
	set category = "Debug GOAI Agents"
	set src in view(1)

	life = 0
	return


/mob/goai/verb/UnpauseGoai()
	set category = "Debug GOAI Agents"
	set src in view(1)

	life = 1
	Life() // reboot AI systems
	return


/mob/goai/verb/InspectAgentVars()
	set category = "Debug GOAI Agents"
	set src in view(1)

	usr << "#============================================#"
	usr << "|              GOAI AGENT: [src]              "
	usr << "#============================================#"
	usr << "|"

	for(var/V in src.vars)
		usr << "| - [V] = [src.vars[V]]"

	usr << "#============================================#"

	return


/mob/goai/verb/InspectAgentBrainVars()
	set category = "Debug GOAI Agents"
	set src in view(1)

	if(!(src.brain))
		usr << "[src] has no brain!"
		return

	usr << "#============================================#"
	usr << "|              GOAI BRAIN: [src]              "
	usr << "#============================================#"
	usr << "|"

	for(var/V in (src.brain.vars))
		usr << "| - [V] = [src.brain.vars[V]]"

	usr << "#============================================#"

	return



/mob/goai/verb/InspectAgentNeeds()
	set category = "Debug GOAI Agents"
	set src in view(1)

	usr << "#============================================#"
	usr << "|              GOAI AGENT: [src]              "
	usr << "#============================================#"
	usr << "|"

	for(var/N in src.needs)
		usr << "| - [N] = [src.needs[N]]"

	usr << "#============================================#"

	return



/mob/goai/verb/InspectAgentState()
	set category = "Debug GOAI Agents"
	set src in view(1)

	usr << "#============================================#"
	usr << "|              GOAI AGENT: [src]              "
	usr << "#============================================#"
	usr << "|"

	for(var/S in src.states)
		usr << "| - [S] = [src.states[S]]"

	usr << "#============================================#"

	return


/mob/goai/verb/InspectAgentActions()
	set category = "Debug GOAI Agents"
	set src in view(1)

	usr << "#============================================#"
	usr << "|              GOAI AGENT: [src]              "
	usr << "#============================================#"
	usr << "|"

	for(var/A in src.actionslist)
		usr << "| - [A] = [src.actionslist[A]?.charges]"

	usr << "#============================================#"

	return