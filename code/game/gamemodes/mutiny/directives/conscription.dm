datum/directive/conscription
	var/list/ids_to_reassign = list()

	proc/is_civilian(mob/M)
		return M.mind.assigned_role in civilian_positions - "Head of Personnel" && "Lawyer"

	proc/get_civilians()
		var/list/civilians[0]
		for(var/mob/M in player_list)
			if (M.is_ready() && is_civilian_positions(M))
				civilians.Add(M)
		return civilians

	proc/count_civilians_reassigned()
		var/civilians_reassigned = 0
		for(var/obj/item/weapon/card/id in ids_to_reassign)
			if (ids_to_reassign[id])
				civilians_reassigned++

		return civilians_reassigned

datum/directive/conscription/get_description()
	return {"
		<p>
			 [system_name()] has been struck by widespread rioting. [station_name()] is now conscripted awaiting deployment to rioting stations. The Head of Security is to assist the Head of Personnel in coordinating assets.

		</p>
	"}

datum/directive/conscription/meets_prerequisites()
	var/list/civilians = get_civilians()
	return civilians.len > 3

datum/directive/conscription/initialize()
	for(var/mob/living/carbon/human/R in get_civilians())
		ids_to_reassign[R.wear_id] = 0

	special_orders = list(
		"Reassign all civilian personnel, excluding the Head of Personnel, to security.",)

		datum/directive/conscription/directives_complete()
	return count_civilians_reassigned() == ids_to_reassign.len

	for(var/id in ids_to_reassign)
		if(!ids_to_reassign[id])
			text += "<li>Reassign [id] to Security Officer</li>"

	return text

/hook/reassign_employee/proc/civilian_reassignments(obj/item/weapon/card/id/id_card)
	var/datum/directive/conscription/D = get_directive("conscription")
	if(!D) return 1

	if(D.ids_to_reassign && D.ids_to_reassign.Find(id_card))
		D.ids_to_reassign[id_card] = id_card.assignment == "Security Officer" ? 1 : 0

	return 1

