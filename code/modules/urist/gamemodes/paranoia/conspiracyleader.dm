//This file contains only the basic mostly non-functional template for various conspiracies defined in conspiracies.dm

var/datum/antagonist/agent/agents

/datum/antagonist/agent
	id = "Agent"
	role_type = BE_AGENT
	role_text = "Conspiracy Leader"
	role_text_plural = "Conspiracy Agents"
	bantype = "agent"
	feedback_tag = "paranoia_objective"
	antag_indicator = null
	leader_welcome_text = "You are a leader of a shadowy cabal operating on the station. Lead your faction to supremacy!"
	welcome_text = "Down with the capitalists! Down with the Bourgeoise!"
	victory_text = "The heads of staff were relieved of their posts! The revolutionaries win!"
	loss_text = "The heads of staff managed to stop the revolution!"
	victory_feedback_tag = "win - heads killed"
	loss_feedback_tag = "loss - rev heads killed"
	flags = ANTAG_SUSPICIOUS | ANTAG_VOTABLE
	antaghud_indicator = "hudrevolutionary"

	hard_cap = 4
	hard_cap_round = 4
	initial_spawn_req = 1
	initial_spawn_target = 1

	//Inround revs.
	faction_role_text = "Conspiracy Agent"
	faction_descriptor = "Conspiracy"
	faction_verb = /mob/living/proc/convert_to_conspiracy
	faction_welcome = "Help the cause. Do not harm your fellow agents."
	faction_indicator = null
	faction_invisible = 1

/datum/antagonist/agent/New()
	..()
	agents = src

/mob/living/proc/convert_to_conspiracy(mob/M as mob in oview(src))
	set name = "Recruit as Agent"
	set category = "Abilities"

	if(!M.mind)
		return

	convert_to_faction(M.mind, agents)