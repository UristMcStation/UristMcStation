/datum/game_mode/traitor/vampire
	name = "traitor+vampire"
	config_tag = "traitorpire"
	required_players = 3
	antag_tags = list(MODE_VAMPIRE, MODE_TRAITOR)
	end_on_antag_death = 0
	require_all_templates = 1
	latejoin_antag_tags = list(MODE_TRAITOR)
	round_autoantag = 1
	votable = 1