
/mob/living/Login()
	..()
	//Mind updates
	mind_initialize()	//updates the mind (or creates and initializes one if one doesn't exist)
	mind.active = 1		//indicates that the mind is currently synced with a client
	//If they're SSD, remove it so they can wake back up.
	update_antag_icons(mind)
	if(GLOB.bad_changing_color_ckeys["[client.ckey]"] == 1)
		client.updating_color = 0
		GLOB.bad_changing_color_ckeys["[client.ckey]"] = 0
	update_color()
	return .
