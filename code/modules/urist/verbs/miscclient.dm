/client/verb/Toggle_Heartbeat() //to toggle off heartbeat sounds, in case they get too annoying
	set name = "Hear/Silence Heartbeat"
	set category = "Preferences"
	set desc = "Toggles hearing heart beating sound effects"
	prefs.toggles ^= SOUND_HEARTBEAT
	prefs.save_preferences(src)
	if(prefs.toggles & SOUND_HEARTBEAT)
		src << "You will now hear heartbeat sounds."
	else
		src << "You will no longer hear heartbeat sounds."
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = 1)
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = 2)
	feedback_add_details("admin_verb","Thb") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!