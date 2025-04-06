/mob/proc/PosessWithGoaiUtilityCommander()
	set category = "Debug Utility AI"

	set src in view()

	AttachUtilityCommanderTo(src, null)


/mob/proc/DeleteGoaiUtilityAi(var/datum/utility_ai/ai_target as anything in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
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


/mob/proc/SetGlobalGoaiUtilityAiRate(var/rate as num)
	set category = "Debug Utility AI"

	if(rate <= 0)
		return

	for(var/datum/utility_ai/ai in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
		ai.base_ai_tick_delay = max(1, rate)
		ai.ai_tick_delay = ai.base_ai_tick_delay
		ai.waketime = (world.time + ai.ai_tick_delay)

	to_chat(usr, "Set global Utility AI tickrate to [rate]")
	return


/mob/proc/TogglePauseSpecificGoai(var/datum/utility_ai/ai_target as anything in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
	set category = "Debug Utility AI"

	if(isnull(ai_target))
		return

	ai_target.paused = !(ai_target.paused)

	to_chat(usr, "Set [ai_target] PAUSED to [ai_target.paused ? "TRUE" : "FALSE"]")
	return


/mob/proc/TogglePauseAllGoais()
	set category = "Debug Utility AI"

	for(var/datum/utility_ai/ai_target in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
		if(isnull(ai_target))
			continue

		ai_target.paused = !(ai_target.paused)

		to_chat(usr, "Set [ai_target] PAUSED to [ai_target.paused ? "TRUE" : "FALSE"]")

	return


/proc/ReloadAi(var/datum/utility_ai/commander in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
	set category = "Debug Utility AI"

	if(!istype(commander))
		return

	// force a cache refresh
	// WARNING: will affect ALL AIs using the same file!
	FILEDATA_CACHE_INVALIDATE(1)
	commander.GetAvailableActions(TRUE)

	to_chat(usr, "AI <[commander]> reloaded!")
	return


/mob/proc/RemoveGoaiDebugVerbs()
	set name = "Remove GOAI Debug Verbs"
	set category = "Debug"

	usr.verbs -= /mob/proc/PosessWithGoaiUtilityCommander
	usr.verbs -= /mob/proc/DeleteGoaiUtilityAi
	usr.verbs -= /mob/proc/SetGlobalGoaiUtilityAiRate
	usr.verbs -= /mob/proc/TogglePauseSpecificGoai
	usr.verbs -= /mob/proc/TogglePauseAllGoais
	usr.verbs -= /proc/ReloadAi
	usr.verbs -= /proc/invalidate_file_cache
	usr.verbs -= /mob/proc/RemoveGoaiDebugVerbs

	return


#ifdef GOAI_LIBRARY_FEATURES
/mob/verb/GrantGoaiDebugVerbs()
#endif
#ifdef GOAI_SS13_SUPPORT
/mob/proc/GrantGoaiDebugVerbs()
#endif
	set name = "Grant GOAI Debug Verbs"
	set category = "Debug"

	usr.verbs |= /mob/proc/PosessWithGoaiUtilityCommander
	usr.verbs |= /mob/proc/DeleteGoaiUtilityAi
	usr.verbs |= /mob/proc/SetGlobalGoaiUtilityAiRate
	usr.verbs |= /mob/proc/TogglePauseSpecificGoai
	usr.verbs |= /mob/proc/TogglePauseAllGoais
	usr.verbs |= /proc/ReloadAi
	usr.verbs |= /proc/invalidate_file_cache
	usr.verbs |= /mob/proc/RemoveGoaiDebugVerbs

	return
