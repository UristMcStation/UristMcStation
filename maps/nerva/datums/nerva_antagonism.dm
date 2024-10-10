/datum/antagonist/ert
	leader_welcome_text = "As leader of the Emergency Response Team, you are the apex of kinetic solutions, and are there with the intention of restoring normal operation to the vessel or the safe evacuation of crew and passengers. You should, to this effect, aid the Captain or ranking officer aboard in their endeavours to achieve this."

/datum/antagonist/ert/equip(mob/living/carbon/human/player)

	if(!..())
		return 0

	var/singleton/hierarchy/outfit/ert_outfit = outfit_by_type((player.mind == leader) ? /singleton/hierarchy/outfit/job/nerva/ert/leader : /singleton/hierarchy/outfit/job/nerva/ert)
	ert_outfit.equip(player)

	return 1
