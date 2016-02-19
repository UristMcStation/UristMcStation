//paranoia - essentially rev with more factions and the conflict being interfactional rather than rev vs heads

/datum/game_mode/paranoia
	name = "Paranoia"
	config_tag = "paranoia"
	round_description = "Secret cabals have recruited most of the crew to accomplish their goals!"
	extended_round_description = "Revolutionaries - Remove the heads of staff from power. Convert other crewmembers to your cause using the 'Convert Bourgeoise' verb. Protect your leaders."
	required_players = 4
	required_enemies = 3
	auto_recall_shuttle = 1
	uplink_welcome = "AntagCorp Uplink Console:"
	uplink_uses = 10
	end_on_antag_death = 0
	shuttle_delay = 3
	antag_tags = list("Buildaborg","Freemesons","MIG","Aliuminati")
	require_all_templates = 0