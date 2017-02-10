//if things aren't commented, i'm sorry. if you want help porting this to whatever codebase you're using, just ask me. i don't bite. scrdest, if you're fixing anything i fucked up, i'll give you a hand.
//but to be frank, i assume i'm going to be the only person touching this stuff (love you scrdest) so that's why. - Glloyd (who else would it be?)

/obj/item/var/scommoney = null //only used for science now.

var/global/missiondiff = 1

var/global/sploded = 0

var/global/onmission = 0

var/global/scom_lowpop_scale = 0

var/list/scomspawn1 = list()
var/list/scomspawn2 = list()
var/list/scomspawn3 = list()

var/global/SCOMplayerC = 0 //ugly rename, but AFAIK playerC is a local var of different gamemodes. Honestly, this should be a helper var.


/datum/game_mode/scom //the joke is that 90% of this stuff is handled by other procs
	name = "scom"
	config_tag = "scom"
	required_players = 1 //lowpop mode ahoy //if you see this on master, I fucked up, should be 2 -scr
	votable = 1
	var/declared = 0
	var/scommapsloaded = 0
	var/aliencount = 0
	var/SCOMplayercount = 0 //count is player number at the moment, C is at roundstart
	auto_recall_shuttle = 1
	ert_disabled = 1

/datum/game_mode/scom/announce() //guys, are my comments informative yet?
	world << "<B>The current game mode is - S-COM!</B>"
	world << "<B>In response to the current galactic crisis, the major powers have banded together to form a group opposed to the alien menace. As a member of that elite force, it is your job to save the galaxy. No pressure.</B>"

/datum/game_mode/scom/pre_setup() //this is where we decide difficulty. Over 18, mob spawns are increased. Over 26, mob spawns are increased again. Once again, if Urist grows/doesn't die, I'll balance this better for larger amounts of players.
	world << "<span class='danger'> Setting up S-COM, please be patient. This may take a minute or two.</span>"

	for(var/mob/living/L in mob_list) //get rid of Ian and all the other mobs. we don't need them around.
		qdel(L)

	if(!scommapsloaded) //necessary incase an admin fucks something up.
		LoadScom()

	config.allow_random_events = 0 //nooooope

	for(var/mob/new_player/player in player_list)
		if((player.client)&&(player.ready))
			SCOMplayerC++
	//world << "<span class='danger'> [SCOMplayerC] players counted.</span>"

	update_dyndifficulty()
	return 1 //ever get that feeling you're talking to yourself?


/datum/game_mode/scom/proc/update_dyndifficulty()

	scom_lowpop_scale = 0 //whether to use a prob-based spawning

	if(config.SCOM_dynamic_difficulty)
		SCOMplayerC = SCOMplayercount
	if(SCOMplayerC >= SCOM_EASY)
		missiondiff = 1

		if(SCOMplayerC >= SCOM_NORM )
			missiondiff = 2

			if(SCOMplayerC >= SCOM_HARD ) //with numbers the way they are now, I feel like I'll have to make a fourth...
				missiondiff = 3

				if(SCOMplayerC >= SCOM_HRDR )
					missiondiff = 4 //k
	else
		missiondiff = 2
		scom_lowpop_scale = 1

/datum/game_mode/scom/post_setup()
	world << "<span class='danger'> Setting up science...</span>"
	populate_scomscience_recipes()
	world << "<span class='danger'> Spawning players...</span>"
	ScomTime()
	ScomRobotTime()

	spawn(600)
		command_announcement.Announce("Welcome to the S-COM project soldiers. Over the last two months, a series of events, now referred to as the Galactic Crisis, have taken place. What started as an isolated series of attacks in the Outer Rim has turned into the possible end of humanity. The time has come for you to drop your death commando armor, Syndicate assault squad hardsuit, Terran Republic marine gear or other and work with your most hated foes to fight a threat that will destroy us all! Ahead of you is a life of training, fighting supernatural and alien threats, and protecting the galaxy and all within it! You are the best of the best and we're counting on you to defend the galaxy from the recent alien invasion. \n \nYour first mission is to check out a Nanotrasen transit area in Nyx. We've gotten reports of unknown sightings, so hurry up and get out there before it's too late. Your squad leaders will direct you to the armory and coordinate your actions. Good luck, the fate of the galaxy rests on your shoulders.", "S-COM Mission Command")
		spawn(50)
			command_announcement.Announce("Shuttles will be launching in 3 minutes.", "S-COM Shuttle Control")
	spawn(2400)
		command_announcement.Announce("Launching shuttles in one minute.", "S-COM Shuttle Control")
		spawn(600)
			for(var/datum/shuttle/ferry/scom/s1/C in shuttle_controller.process_shuttles)
				C.launch()

/datum/game_mode/scom/process()
	SCOMplayercount = 0
	for(var/mob/living/carbon/human/H in player_list)
		if(H.client && H.stat != DEAD && isscom(H))
			SCOMplayercount += 1
	if(SCOMplayercount == 0 && declared == 0 && prob(5))
		sploded = 3
		declare_completion()

	if(sploded == 2 && declared == 0)
		declare_completion()
	else if(sploded == 1 && declared == 0)
		for(var/obj/effect/landmark/scom/bomb/B in world)
			B.incomprehensibleprocname()
			sploded = 0
			spawn(600) //we do this 3 times, all bomb delays should be lower or equal to this
				sploded = 1

	if(onmission == 1)
//		world << "<span class='warning'> onmission</span>"
		aliencount = 0
		for(var/mob/living/simple_animal/hostile/M in mob_list)
			if(M.health > 0 && M.faction != "neutral")
				aliencount += 1
//				world << "<span class='warning'> aliens: [aliencount]</span>"
		if (aliencount == 0 && declared == 0)
//			world << "<span class='warning'> count 0</span>"
			command_announcement.Announce("Good job soldiers. We'll be launching the shuttles in two minutes, make sure to grab as much alien technology as you can. Any soldiers left behind will be bluespaced back to the base.", "S-COM Mission Command")
			declared = 2
			if(config.SCOM_dynamic_difficulty)
				update_dyndifficulty()
			spawn(1200)
				for(var/datum/shuttle/ferry/scom/s1/C in shuttle_controller.process_shuttles)
					C.launch()
					spawn(300)
						declared = 0


datum/game_mode/scom/declare_completion() //failure states removed pending a rewrite
	if(sploded == 2)
		declared = 1
		world << "<FONT size = 3><B>Major S-COM victory!</B></FONT>"
		world << "<B>The alien presence in Nyx has been eradicated!</B>"
	if(sploded == 3)
		declared = 1
		world << "<FONT size = 3><B>Major Alien victory!</B></FONT>"
		world << "<B>The S-COM presence in Nyx has been eradicated!</B>"

	world << "<span class='notice'> Rebooting in one minute.</span>"
	..()

	sleep(600)
	if(!ticker.delay_end)
		world.Reboot()
	else
		world << "<span class='notice'> <B>An admin has delayed the round end</B></span>"



/obj/structure/scom/fuckitall
	name = "mothership central computer"
	icon = 'icons/urist/turf/scomturfs.dmi'
	icon_state = "9,8"
	var/fuckitall = 0
	anchored = 1
	density = 1

/obj/structure/scom/fuckitall/ex_act()
	return

/obj/structure/scom/fuckitall/attack_hand(mob/user as mob)
	var/want = input("Start the self destruct countdown? You will have 3 minutes to escape.", "Your Choice", "Cancel") in list ("Cancel", "Yes")
	switch(want)
		if("Cancel")
			return
		if("Yes")
			world << "<FONT size = 3><span class='danger'> Mothership self-destruct sequence activated. Three minutes until detonation.</span></FONT>"
			sploded = 1
			command_announcement.Announce("We're launching the shuttles in two minutes and fourty five seconds. I don't think we need to say it twice, get the fuck out of there.", "S-COM Mission Command")
			spawn(1650)
				for(var/datum/shuttle/ferry/scom/s1/C in shuttle_controller.process_shuttles)
					C.launch()
				spawn(250) //long enough to luanch both shuttles
					for(var/mob/living/M in mob_list)
						if(M.z != 2 && !M.stat)
							explosion(M.loc, 2, 4, 6, 6)
		//				M.apply_damage(rand(1000,2000), BRUTE) //KILL THEM ALL
		//				M << ("<span class='warning'> The explosion tears you apart!</span>")
		//				M.gib()
		//			sleep(2000)
					world << "<span class='danger'> The mothership has been destroyed!</span>"
					sleep(50)
					sploded = 2

/obj/effect/landmark/scom/bomb
	icon_state = "grabbed1"
	invisibility = 101
	var/bombdelay = 0

/obj/effect/landmark/scom/bomb/proc/incomprehensibleprocname()
	spawn(bombdelay)
		explosion(src.loc, 1, 2, 3, 4)

/client/proc/delaymissions()

	set name = "Delay SCOM Missions"
	set category = "Fun"
	set desc = "Delay the S-COM Missions for some fun."
	if(!check_rights(R_FUN))
		src <<"<span class='danger'> You do not have the required admin rights.</span>"
		return

	for(var/datum/shuttle/ferry/scom/s1/C in shuttle_controller.process_shuttles)
		if(!C.missiondelayed)
			C.missiondelayed = 1
			message_admins("[key_name(usr)] has delayed the mission timer.")
			log_admin("[key_name(src)] has delayed the mission timer.")
		else
			message_admins("[key_name(usr)] has undelayed the mission timer.")
			log_admin("[key_name(src)] has undelayed the mission timer.")
			command_announcement.Announce("Shuttles will be launched in one minute.", "S-COM Shuttle Command")
			spawn(600)
				C.launch()

/client/proc/toggle_dyndiff()

	set name = "Toggle Dynamic Difficulty"
	set category = "Fun"
	set desc = "Make SCOM use DynDifficulty again or disable it."
	if(!check_rights(R_FUN))
		src <<"<span class='danger'> You do not have the required admin rights.</span>"
		return

	if(config.SCOM_dynamic_difficulty == 1)
		config.SCOM_dynamic_difficulty = 0
		src <<"<span class='danger'> Dynamic Difficulty disabled.</span>"
	else
		config.SCOM_dynamic_difficulty = 1
		src <<"<span class='danger'> Dynamic Difficulty enabled.</span>"
