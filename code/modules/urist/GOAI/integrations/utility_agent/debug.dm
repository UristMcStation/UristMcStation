/mob/verb/PosessWithUtilityCommander()
	set category = "Debug Utility AI"

	set src in view()

	AttachUtilityCommanderTo(src, null)


/mob/verb/SetGlobalUtilityAiRate(var/rate as num)
	set category = "Debug Utility AI"

	if(rate <= 0)
		return

	for(var/datum/utility_ai/ai in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
		ai.ai_tick_delay = max(1, rate)

	to_chat(usr, "Set global Utility AI tickrate to [rate]")
	return


/mob/verb/TogglePauseAi(var/datum/utility_ai/ai_target as anything in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
	set category = "Debug Utility AI"

	if(isnull(ai_target))
		return

	ai_target.paused = !(ai_target.paused)

	to_chat(usr, "Set [ai_target] PAUSED to [ai_target.paused ? "TRUE" : "FALSE"]")
	return
