/proc/AttachCombatCommanderTo(var/mob/M, var/datum/goai/mob_commander/commander = null)
	var/datum/goai/mob_commander/combat_commander/new_commander = commander
	if(isnull(commander))
		new_commander = new()

	new_commander.pawn_ref = weakref(M)
	var/dict/pawn_attachments = M.attachments

	if(isnull(pawn_attachments))
		pawn_attachments = new()
		M.attachments = pawn_attachments

	M.attachments[ATTACHMENT_CONTROLLER_BACKREF] = new_commander.registry_index

	new_commander.name = "AI of [M?.real_name || M?.name] (#[rand(0, 100000)])"
	new_commander.brain.name = "Brain of [new_commander.name]"

	//var/MOB_TYPE_HUMAN/H = M
	//var/MOB_TYPE_HOSTILE/SAH = M
