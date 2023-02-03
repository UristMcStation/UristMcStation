/datum/game_mode/bluespace_revenant
	antag_tags = list(MODE_BSREVENANT)

	name = "Bluespace Revenant"
	round_description = "Bluespace Revenants are slowly corrupting the station!"
	extended_round_description = "Some crewmembers had become warped by bizarre cosmic forces into \
		walking anomalies driven by strange hungers. If they do not indulge them, they will slowly \
		corrupt the very reality around themselves. They are desperate, and even if *they* are not \
		malicious, their corrupted auras very much *is*. Hunt, help, study them... and above all, \
		try to survive!"

	config_tag = "bsrevenant"
	required_players = 1 // revert to 2 after testing
	required_enemies = 1
	end_on_antag_death = FALSE
	antag_scaling_coeff = 7
