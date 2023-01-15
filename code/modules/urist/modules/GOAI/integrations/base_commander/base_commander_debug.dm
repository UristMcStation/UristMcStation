
/mob/verb/RebootGoaiCommandersAll()
	set category = "Debug GOAI Commanders"

	for(var/datum/goai/commander in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
		commander.LobotomizeGoai()

		sleep(0)
		commander.life = 1

		var/datum/brain/new_brain = commander.CreateBrain()
		commander.brain = new_brain

	return


/mob/verb/RebootGoaiCommander(datum/goai/mob_commander/combat_commander/commander in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
	set category = "Debug GOAI Commanders"

	commander.LobotomizeGoai()

	sleep(0)
	commander.life = 1

	var/datum/brain/new_brain = commander.CreateBrain()
	commander.brain = new_brain

	return


/mob/verb/DeleteGoaiCommander(datum/goai/mob_commander/combat_commander/commander in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
	set category = "Debug GOAI Commanders"
	deregister_ai(commander?.registry_index)
	return


/datum/goai/proc/LobotomizeGoai()
	set category = "Debug GOAI Commanders"

	life = 0

	if(src.brain)
		src.brain.life = 0
		src.brain.active_plan = null
		src.brain.selected_action = null

		if(src.brain.running_action_tracker)
			src.brain.running_action_tracker.SetFailed()

		if(src.brain.running_action_tracker)
			src.brain.running_action_tracker = null

		del(src.brain)

	return


/mob/verb/PauseGoaiCommandersAll()
	set category = "Debug GOAI Commanders"

	for(var/datum/goai/commander in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
		commander.life = 0

	return


/mob/verb/PauseGoaiCommander(datum/goai/mob_commander/combat_commander/commander in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
	set category = "Debug GOAI Commanders"
	commander.life = 0
	return



/mob/verb/UnpauseGoaiCommandersAll()
	set category = "Debug GOAI Commanders"

	for(var/datum/goai/commander in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
		commander.life = 1
		commander.Life() // reboot AI systems

	return



/mob/verb/UnpauseGoaiCommander(datum/goai/mob_commander/combat_commander/commander in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
	set category = "Debug GOAI Commanders"

	commander.life = 1
	commander.Life() // reboot AI systems

	return


/mob/verb/ListGoaiCommanders()
	set category = "Debug GOAI Commanders"

	to_chat(usr, "===== GOAI COMMANDERS ====")

	for(var/datum/goai/commander in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
		to_chat(usr, "- [commander.registry_index]: [commander.name] <[commander]>")

	return
