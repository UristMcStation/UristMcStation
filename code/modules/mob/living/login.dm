
/mob/living/Login()
	..()
	//Mind updates
	mind_initialize()	//updates the mind (or creates and initializes one if one doesn't exist)
	mind.active = 1		//indicates that the mind is currently synced with a client
	//If they're SSD, remove it so they can wake back up.
	update_antag_icons(mind)
	if(bad_changing_colour_ckeys["[client.ckey]"] == 1)
		client.updating_colour = 0
		bad_changing_colour_ckeys["[client.ckey]"] = 0
	update_colour()
	return .
