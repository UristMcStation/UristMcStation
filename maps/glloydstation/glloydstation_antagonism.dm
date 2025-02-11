/datum/antagonist/ert
	leader_welcome_text = "As leader of the Emergency Response Team, you answer only to NanoTrasen Central Command, and have authority to override the Captain where it is necessary to achieve your mission goals. It is recommended that you attempt to cooperate with the captain where possible, however."

/datum/antagonist/ert/equip(mob/living/carbon/human/player)

	if(!..())
		return 0

	var/singleton/hierarchy/outfit/ert_outfit = outfit_by_type((player.mind == leader) ? /singleton/hierarchy/outfit/job/glloydstation/ert/leader : /singleton/hierarchy/outfit/job/glloydstation/ert)
	ert_outfit.equip(player)

	return 1
