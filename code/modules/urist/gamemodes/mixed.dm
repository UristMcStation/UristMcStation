/datum/game_mode/mixed
	name = "mixed"
	config_tag = "mixed"
	var/list/datum/game_mode/modes[2] // 2 game modes in 1

	required_players = 1 //15
	required_players_secret = 1

	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800 //upper bound on time before intercept arrives (in tenths of seconds)

/datum/game_mode/mixed/announce()
	world << "<B>The current game mode is - Mixed!</B>"
	world << "<B>More than one hostile force is operating on the station! Do not let them succeed!</B>"

/datum/game_mode/mixed/pre_setup()
	var/list/datum/game_mode/possible = typesof(/datum/game_mode) - list(/datum/game_mode, /datum/game_mode/mixed, /datum/game_mode/meteor, /datum/game_mode/calamity, /datum/game_mode/traitor/changeling, /datum/game_mode/traitor/vampire, /datum/game_mode/traitor, /datum/game_mode/nuclear, /datum/game_mode/heist, /datum/game_mode/mutiny, /datum/game_mode/ninja, /datum/game_mode/revolution, /datum/game_mode/revolution/rp_revolution)
	possible = shuffle(possible)
	for(var/i = 1, i < 2, i++)
		var/datum/game_mode/M = pick(possible)
		modes[i] = M
		possible = shuffle(possible)
	for(var/datum/game_mode/M in modes)
		world << M //debug
		world << M.required_players //debug
		M.pre_setup()
	return 1

/datum/game_mode/mixed/post_setup()
	for(var/datum/game_mode/M in modes)
		M.post_setup()
		world.log << M //debug code, delete after testing