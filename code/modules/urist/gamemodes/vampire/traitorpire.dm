/datum/game_mode/traitor/vampire
	name = "traitor+vampire"
	config_tag = "traitorpire"
	traitors_possible = 3 //hard limit on traitors if scaling is turned off
	restricted_jobs = list("AI", "Cyborg")
	required_players = 3
	required_enemies = 2
	antag_tags = list(MODE_VAMPIRE, MODE_TRAITOR)