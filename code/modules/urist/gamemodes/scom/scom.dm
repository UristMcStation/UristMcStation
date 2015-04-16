//if things aren't commented, i'm sorry. if you want help porting this to whatever codebase you're using, just ask me. i don't bite. scrdest, if you're fixing anything i fucked up, i'll give you a hand.
//but to be frank, i assume i'm going to be the only person touching this stuff (love you scrdest) so that's why. - Glloyd (who else would it be?)

/obj/item/var/scommoney = null //only used for science now.

var/global/missiondiff = 1

var/global/sploded = 0

var/list/scomspawn1 = list()
var/list/scomspawn2 = list()
var/list/scomspawn3 = list()

/datum/game_mode/scom //the joke is that 90% of this stuff is handled by other procs
	name = "scom"
	config_tag = "scom"
	required_players = 0
	required_players_secret = 18
	votable = 0
	var/declared = 0
	var/scommapsloaded = 0

/datum/game_mode/announce() //guys, are my comments informative yet?
	world << "<B>The current game mode is - S-COM!</B>"
	world << "<B>In response to the current galactic crisis, the major powers have banded together to form a group opposed to the alien menace. As a member of that elite force, it is your job to save the galaxy. No pressure.</B>"

/datum/game_mode/scom/pre_setup() //this is where we decide difficulty. Over 18, mob spawns are increased. Over 26, mob spawns are increased again. Once again, if Urist grows/doesn't die, I'll balance this better for larger amounts of players.
	for(var/mob/living/L in mob_list) //get rid of Ian and all the other mobs. we don't need them around.
		del(L)

	if(!scommapsloaded) //necessary incase an admin fucks something up.
		LoadScom()

	config.allow_random_events = 0 //nooooope

	var/playerC = 0
	for(var/mob/new_player/player in player_list)
		if((player.client)&&(player.ready))
			playerC++

	if(playerC >= 10)

		if(playerC >= 18)
			missiondiff = 2

			if(playerC >= 26) //with numbers the way they are now, I feel like I'll have to make a fourth...
				missiondiff = 3

				if(playerC >= 32)
					missiondiff = 4 //k
		else
			missiondiff = 1
	return 1 //ever get that feeling you're talking to yourself?

/datum/game_mode/scom/post_setup()
	populate_scomscience_recipes()

	ScomTime()

/datum/game_mode/scom/process()
	if(sploded == 1 && !declared)
		declare_completion()

datum/game_mode/scom/declare_completion() //failure states removed pending a rewrite
	if(sploded == 1)
		declared = 1
		world << "<FONT size = 3><B>S-COM has won!</B></FONT>"
		world << "<B>The alien presence in Nyx has been eradicated!</B>"

//		world << "\blue Rebooting in 30s"
		..()

//		sleep(300)
//		world.Reboot()

