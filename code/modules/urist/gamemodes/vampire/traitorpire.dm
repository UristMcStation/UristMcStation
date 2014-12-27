/datum/game_mode/traitor/vampire
	name = "traitor+vampire"
	config_tag = "traitorpire"
	traitors_possible = 3 //hard limit on traitors if scaling is turned off
	restricted_jobs = list("AI", "Cyborg")
	required_players = 3
	required_players_secret = 10
	required_enemies = 2
	recommended_enemies = 3

/datum/game_mode/traitor/vampire/announce()
	world << "<B>The current game mode is - Traitor+Vampire!</B>"
	world << "<B>There is a Vampire from Space Transylvania on the station on the station along with some syndicate operatives out for their own gain! Do not let the vampire and the traitors succeed!</B>"


/datum/game_mode/traitor/vampire/pre_setup()
	if(config.protect_roles_from_antagonist)
		restricted_jobs += protected_jobs

	var/list/datum/mind/possible_vampires = get_players_for_role(BE_VAMPIRE)

	for(var/datum/mind/player in possible_vampires)
		for(var/job in restricted_jobs)//Removing robots from the list
			if(player.assigned_role == job)
				possible_vampires -= player

	if(possible_vampires.len>0)
		var/datum/mind/vampire = pick(possible_vampires)
		vampires += vampire
		modePlayer += vampires
		return ..()
	else
		return 0

/datum/game_mode/traitor/vampire/post_setup()
	for(var/datum/mind/vampire in vampires)
		grant_vampire_powers(vampire.current)
		vampire.special_role = "Vampire"
		if(!config.objectives_disabled)
			forge_vampire_objectives(vampire)
		greet_vampire(vampire)
	..()
	return