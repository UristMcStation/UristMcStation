/mob/living/bot/secbot/urist/eyebot
	name = "eyebot"
	desc = "A mostly peaceful eyebot"
	icon = 'icons/urist/events/fallout.dmi'
	idcheck = 0
	will_patrol = 1

/mob/living/simple_animal/hostile/retaliate/malf_drone/urist
	name = "bot"
	desc = "Bot."
	icon = 'icons/urist/events/fallout.dmi'

/mob/living/simple_animal/hostile/retaliate/malf_drone/urist/robot
	name = "Dauntless Bot"
	desc = "An automated combat drone armed with state of the art weaponry and shielding."
	speak = list("ALERT.","Who's ready to have their ass kicked?!","You better run, you commie-loving bastard!","There's nothing I like better than making some other poor bastard die for h�s country!","Unit deactivating. This troop is hitting the rack!","What is your major malfunction, maggot?")
	emote_see = list("beeps menacingly","whirrs threateningly","scans its immediate vicinity")
	health = 35
	maxHealth = 35
	speed = 3
	hostile_drone = 0
