
/proc/AttachUtilityCommanderTo(var/mob/M, var/datum/utility_ai/mob_commander/commander = null)
	//var/datum/utility_ai/mob_commander/new_commander = commander
	// Use combat_commander to get extra senses predefined
	var/datum/utility_ai/mob_commander/combat_commander/new_commander = commander

	if(isnull(commander))
		new_commander = new()

	# ifdef GOAI_SS13_SUPPORT
	new_commander.pawn_ref = weakref(M)
	# endif

	# ifdef GOAI_LIBRARY_FEATURES
	new_commander.pawn = M
	# endif

	var/dict/pawn_attachments = M.attachments

	if(isnull(pawn_attachments))
		pawn_attachments = new()
		M.attachments = pawn_attachments

	M.attachments[ATTACHMENT_CONTROLLER_BACKREF] = new_commander.registry_index
	M.attachments["commander_removeme"] = new_commander
	M.attachments["aibrain_removeme"] = new_commander.brain

	new_commander.name = "AI of [M?.real_name || M?.name] (#[rand(0, 100000)])"
	new_commander.brain.name = "Brain of [new_commander.name]"

	new_commander.AttachToBrain()

	# ifdef GOAI_SS13_SUPPORT
	# ifdef GOAI_DELETE_SS13_AI
	var/mob/living/L = M
	if(istype(L))
		QDEL_NULL(L.ai_holder)
	# endif
	# endif
