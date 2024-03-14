/mob/verb/PosessWithGoaiUtilityCommander()
	set category = "Debug Utility AI"

	set src in view()

	AttachUtilityCommanderTo(src, null)


/mob/verb/DeleteGoaiUtilityAi(var/datum/utility_ai/ai_target as anything in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
	set category = "Debug Utility AI"

	if(isnull(ai_target))
		return

	// If we delete the AI, we cannot really get these anymore for logging, so we need to precalculate this now.
	// Once we build the string, the embedded variables are already baked in so we don't need to worry about it.
	var/retained_ref = "[ai_target] (ID: [ai_target.registry_index])"

	if(isnull(ai_target.registry_index))
		qdel(ai_target)
	else
		deregister_ai(ai_target.registry_index)

	to_chat(usr, "DELETED AI: [retained_ref]")
	return


/mob/verb/SetGlobalGoaiUtilityAiRate(var/rate as num)
	set category = "Debug Utility AI"

	if(rate <= 0)
		return

	for(var/datum/utility_ai/ai in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
		ai.ai_tick_delay = max(1, rate)
		ai.waketime = (world.time + ai.ai_tick_delay)

	to_chat(usr, "Set global Utility AI tickrate to [rate]")
	return


/mob/verb/TogglePauseSpecificGoai(var/datum/utility_ai/ai_target as anything in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
	set category = "Debug Utility AI"

	if(isnull(ai_target))
		return

	ai_target.paused = !(ai_target.paused)

	to_chat(usr, "Set [ai_target] PAUSED to [ai_target.paused ? "TRUE" : "FALSE"]")
	return


/mob/verb/TogglePauseAllGoais()
	set category = "Debug Utility AI"

	for(var/datum/utility_ai/ai_target in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
		if(isnull(ai_target))
			continue

		ai_target.paused = !(ai_target.paused)

		to_chat(usr, "Set [ai_target] PAUSED to [ai_target.paused ? "TRUE" : "FALSE"]")

	return
