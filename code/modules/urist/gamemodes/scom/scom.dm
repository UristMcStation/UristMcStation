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

/datum/game_mode/scom/announce() //guys, are my comments informative yet?
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

	if(playerC >= 15)

		if(playerC >= 22)
			missiondiff = 2

			if(playerC >= 30) //with numbers the way they are now, I feel like I'll have to make a fourth...
				missiondiff = 3

				if(playerC >= 38)
					missiondiff = 4 //k
		else
			missiondiff = 1
	return 1 //ever get that feeling you're talking to yourself?

/datum/game_mode/scom/post_setup()
	populate_scomscience_recipes()

	ScomTime()
	ScomRobotTime()

	spawn(600)
		command_announcement.Announce("Welcome to the S-COM project soldiers. Over the last two months, a series of events, now referred to as the Galactic Crisis, have taken place. What started as an isolated series of attacks in the Outer Rim has turned into the possible end of humanity. The time has come for you to drop your death commando armor, Syndicate assault squad hardsuit, Terran Republic marine gear or other and work with your most hated foes to fight a threat that will destroy us all! Ahead of you is a life of training, fighting supernatural and alien threats, and protecting the galaxy and all within it! You are the best of the best and we're counting on you to defend the galaxy from the recent alien invasion.<BR><BR> Your first mission is to check out a Nanotrasen transit area in Nyx. We've gotten reports of unknown sightings, so hurry up and get out there before it's too late. Your squad leaders will direct you to the armory and coordinate your actions. Good luck, the fate of the galaxy rests on your shoulders. <b>Shuttles will be launching in 3 minutes. </b>", "S-COM Mission Command")
	spawn(2400)
		for(var/datum/shuttle/ferry/scom/s1/C in shuttle_controller.process_shuttles)
			C.launch()

/datum/game_mode/scom/process()
	if(sploded == 2 && !declared)
		declare_completion()
	else if(sploded == 1)
		for(var/obj/effect/landmark/scom/bomb/B in world)
			B.incomprehensibleprocname()
			sploded = 0
			spawn(600) //we do this 3 times, all bomb delays should be lower or equal to this
				sploded = 0

datum/game_mode/scom/declare_completion() //failure states removed pending a rewrite
	if(sploded == 2)
		declared = 1
		world << "<FONT size = 3><B>Major S-COM victory!</B></FONT>"
		world << "<B>The alien presence in Nyx has been eradicated!</B>"

		world << "\blue Rebooting in one minute."
		..()

		sleep(600)
		if(!ticker.delay_end)
			world.Reboot()
		else
			world << "\blue <B>An admin has delayed the round end</B>"

/obj/structure/scom/fuckitall
	name = "mothership central computer"
	icon = 'icons/urist/turf/scomturfs.dmi'
	icon_state = "9,8"
	var/fuckitall = 0

/obj/structure/scom/fuckitall/attack_hand(mob/user as mob)
	var/want = input("Start the self destruct countdown? You will have 3 minutes to escape.", "Your Choice", "Cancel") in list ("Cancel", "Yes")
	switch(want)
		if("Cancel")
			return
		if("Yes")
			world << "<FONT size = 3>\red \b Mothership self-destruct sequence activated. Three minutes until detonation.</FONT>"
			sploded = 1
			command_announcement.Announce("We're launching the shuttles in two minutes and fourty five seconds. I don't think we need to say it twice, get the fuck out of there.", "S-COM Mission Command")
			spawn(1650)
				for(var/datum/shuttle/ferry/scom/s1/C in shuttle_controller.process_shuttles)
					C.launch()
			spawn(1850) //long enough to luanch both shuttles
			for(var/mob/living/M in mob_list)
				if(M.z != 2)
					explosion(M.loc, 2, 4, 6, 6)
//				M.apply_damage(rand(1000,2000), BRUTE) //KILL THEM ALL
//				M << ("\red The explosion tears you apart!")
//				M.gib()
//			sleep(2000)
			world << "\red \b The mothership has been destroyed!"
			sleep(50)
			sploded = 2

/obj/effect/landmark/scom/bomb
	invisibility = 101
	var/bombdelay = 0

/obj/effect/landmark/scom/bomb/proc/incomprehensibleprocname()
	spawn(bombdelay)
		explosion(src.loc, 1, 2, 3, 4)