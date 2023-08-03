//this is the franework for a refactor of the event system

/datum/game_mode/event
	name = "event"
	config_tag = "event"
	round_description = "Admins are holding a special event, read the custom event info for more details!"
	required_players = 0
	votable = 0

/datum/game_mode/event/pre_setup()
	report_progress("Setting up the event, please be patient. This may take a minute or two.")

//	for(var/mob/living/L in mob_list) //get rid of Ian and all the other mobs. we don't need them around.
//		qdel(L)

//	LoadEventMap()

	config.allow_random_events = 0 //nooooope

	return 1 //ever get that feeling you're talking to yourself?


///datum/game_mode/event/post_setup()
//	report_progress("Spawning players...")
//	EventTime()

//datum/game_mode/event/process()
