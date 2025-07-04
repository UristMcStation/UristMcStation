#define CREDIT_ROLL_SPEED 185
#define CREDIT_SPAWN_SPEED 20
#define CREDIT_ANIMATE_HEIGHT (14 * world.icon_size)
#define CREDIT_EASE_DURATION 22

GLOBAL_LIST(end_titles)

/client/var/list/credits

/client/proc/RollCredits()
	set waitfor = FALSE

	if(get_preference_value(/datum/client_preference/show_credits) != GLOB.PREF_YES)
		return

	if(!GLOB.end_titles)
		GLOB.end_titles = generate_titles()

	LAZYINITLIST(credits)

	if(mob)
		mob.overlay_fullscreen("fishbed",/obj/screen/fullscreen/fishbed)
		mob.overlay_fullscreen("fadeout",/obj/screen/fullscreen/fadeout)

		if(mob.get_preference_value(/datum/client_preference/play_lobby_music) == GLOB.PREF_YES)
			sound_to(mob, sound(null, channel = GLOB.lobby_sound_channel))
			if(isnull(GLOB.end_credits_song))
				var/title_song = pick('sound/music/THUNDERDOME.ogg', 'sound/music/europa/Chronox_-_03_-_In_Orbit.ogg', 'sound/music/europa/asfarasitgets.ogg')
				sound_to(mob, sound(title_song, wait = 0, volume = 40, channel = GLOB.lobby_sound_channel))
			else if(get_preference_value(/datum/client_preference/play_admin_midis) == GLOB.PREF_YES)
				sound_to(mob, sound(GLOB.end_credits_song, wait = 0, volume = 40, channel = GLOB.lobby_sound_channel))
	sleep(50)
	var/list/_credits = credits
	verbs += /client/proc/ClearCredits
	for(var/I in GLOB.end_titles)
		if(!credits)
			return
		var/obj/screen/credit/T = new(null, I, src)
		_credits += T
		T.rollem()
		sleep(CREDIT_SPAWN_SPEED)
	sleep(CREDIT_ROLL_SPEED - CREDIT_SPAWN_SPEED)

	ClearCredits()
	verbs -= /client/proc/ClearCredits

/client/proc/ClearCredits()
	set name = "Stop End Titles"
	set category = "OOC"
	verbs -= /client/proc/ClearCredits
	QDEL_NULL_LIST(credits)
	mob.clear_fullscreen("fishbed")
	mob.clear_fullscreen("fadeout")
	sound_to(mob, sound(null, channel = GLOB.lobby_sound_channel))

/obj/screen/credit
	icon_state = "blank"
	mouse_opacity = 0
	alpha = 0
	screen_loc = "1,1"
	plane = HUD_PLANE
	layer = HUD_ABOVE_ITEM_LAYER
	var/client/parent
	var/matrix/target

/obj/screen/credit/Initialize(mapload, credited, client/P)
	. = ..()
	parent = P
	maptext = {"<div style="font:'Small Fonts'">[credited]</div>"}
	maptext_height = world.icon_size * 2
	maptext_width = world.icon_size * 14

/obj/screen/credit/proc/rollem()
	var/matrix/M = matrix(transform)
	M.Translate(0, CREDIT_ANIMATE_HEIGHT)
	animate(src, transform = M, time = CREDIT_ROLL_SPEED)
	target = M
	animate(src, alpha = 255, time = CREDIT_EASE_DURATION, flags = ANIMATION_PARALLEL)
	spawn(CREDIT_ROLL_SPEED - CREDIT_EASE_DURATION)
		if(!QDELETED(src))
			animate(src, alpha = 0, transform = target, time = CREDIT_EASE_DURATION)
			sleep(CREDIT_EASE_DURATION)
			qdel(src)
	parent.screen += src

/obj/screen/credit/Destroy()
	if(parent)
		parent.screen -= src
		LAZYREMOVE(parent.credits, src)
		parent = null
	return ..()

/proc/generate_titles()
	RETURN_TYPE(/list)
	var/list/titles = list()
	var/list/cast = list()
	var/list/chunk = list()
	var/list/possible_titles = list()
	var/chunksize = 0
	if(!GLOB.end_credits_title)
		/* Establish a big-ass list of potential titles for the "episode". */
		possible_titles += "THE [pick("DOWNFALL OF ", "RISE OF ", "TROUBLE WITH ", "FINAL STAND OF ", "DARK SIDE OF ", "THE LACK OF ", "DESOLATION OF ", "DESTRUCTION OF ", "THE ISSUE WITH ", "CRISIS OF ")]\
							[pick("SPACEMEN", "HUMANITY", "DIGNITY", "SANITY", "THE CHIMPANZEES", "THE VENDOMAT PRICES", "CARGONIA", "BLUESPACE", "THE ARTIFICAL INTELLIGENCE UNIT", "THE MIME", "THE CLOWN (AGAIN)", "THE CHAPLAIN", "THE BALDIE", "IAN", "THE EXOPLANET",\
							"THE SUPERMATTER CRYSTAL", "MEDICAL", "ENGINEERING", "SECURITY", "RESEARCH", "THAT ONE LAST CREWMATE", "THE SERVICE DEPARTMENT", "COMMAND", "THE EXPLORERS", "THE AWAY TEAM", "THE BOTANIST", "THE CHEF", "BREATHABLE AIR", "THE KITCHEN", "THE BAR", "THE BARTENDER", "THE [uppertext(GLOB.using_map.station_name)]")]"
		possible_titles += "THE CREW GETS [pick("RACIST", "A SERIOUS HEADACHE", "PICKLED", "AN INCURABLE DISEASE", "WHACKED", "GIBBED", "MARRIED", "A HOME MAKEOVER", "A FILLER EPISODE", "PIZZA", "CURSED", "A VALUABLE HISTORY LESSON", "A STOWAWAY", "GET FRAMED", "A BREAK", "HIGH", "TO LIVE", "TO RELIVE THEIR CHILDHOOD", "EMBROILED IN CIVIL WAR", "A BAD HANGOVER", "SERIOUS ABOUT [pick("DRUG ABUSE", "CRIME", "PRODUCTIVITY", "ANCIENT AMERICAN CARTOONS", "SPACEBALL", "DECOMPRESSION PROCEDURES")]")]"
		possible_titles += "THE CREW LEARNS ABOUT [pick("LOVE", "DRUGS", "THE DANGERS OF MONEY LAUNDERING", "THE FASHION POLICE", "XENIC SENSITIVITY", "PIRATES, PIRATES, PIRATES!", "DISPOSAL CHUTES", "SUIT SENSORS", "GET RICH QUICK SCHEMES", "HEALTH INSURANCE", "INVESTMENT FRAUD", "KELOTANE ABUSE", "HYPERZINE SNORTING", "COMBINING WATER AND POTASSIUM", "RADIATION PROTECTION", "SACRED GEOMETRY", "STRING THEORY", "ABSTRACT MATHEMATICS",\
							"[pick("UNATHI", "SKRELLIAN", "DIONAN", "RESOMI", "VOX", "IPC")] MATING RITUALS", "ANCIENT CHINESE MEDICINE", "THE IMPORTANCE OF [pick("AIRLOCK SAFETY", "MAINTENANCE", "SUIT SENSORS", "FLOOR PILLS", "ELEVATORS", "HEIGHTS", "TORPEDOES", "GOOD RELATIONS", "A FULLY STOCKED BAR", "AWAY MISSIONS", "MANDATORY DRUG TESTING", "HIRING SECURITY", "GOOD FORENSICS", "TEST WIRES", "UNIONS", "NEURAL LACES", "ENGINEERS")]")]"
		possible_titles += "A VERY [pick("CORPORATE", "NANOTRASEN", "FLEET", "TERRAN", "LACTERAN", "HAPHAESTUS", "DAIS", "XENOLIFE", "EXPEDITIONARY", "DIONAN", "PHORON", "MARTIAN", "RESOMI")] [pick("CHRISTMAS", "EASTER", "HOLIDAY", uppertext(time2text(world.realtime, "Day")), "VACATION", "NEW YEARS", "BOXING DAY")]"
		possible_titles += "[pick("GUNS, GUNS EVERYWHERE", "THE LITTLEST ARMALIS", "WHAT HAPPENS WHEN YOU MIX MAINTENANCE DRONES AND COMMERCIAL-GRADE PACKING FOAM", "INTERNALLY COHERENT, HARDCORE CRAZY TO THE MEGA", "ATTACK! ATTACK! ATTACK!", "SEX BOMB", "THE LEGEND OF THE ALIEN ARTIFACT: PART [pick("I","II","III","IV","V","VI","VII","VIII","IX", "X", "C","M","L")]")]"
		possible_titles += "[pick("SPACE", "SEXY", "DRAGON", "WARLOCK", "LAUNDRY", "GUN", "ADVERTISING", "DOG", "CARBON MONOXIDE", "NINJA", "WIZARD", "SOCRATIC", "JUVENILE DELINQUENCY", "POLITICALLY MOTIVATED", "RADTACULAR SICKNASTY")] [pick("QUEST", "FORCE", "ADVENTURE")]"
		possible_titles += "[pick("THE DAY [uppertext(GLOB.using_map.station_short)] STOOD STILL", "HUNT FOR THE GREEN WEENIE", "ALIEN VS VENDOMAT", "SPACE TRACK")]"
		possible_titles += "THE CREW [pick("FALL OUT AN AIRLOCK", "LOOKS UP", "FUCKING DIES", "DESTROY THE [uppertext(GLOB.using_map.station_short)]", "DON'T DO ANYTHING", "BECOME COWBOYS", "GOES TO HELL", "GOES TO SPACE PRISON", "EATS PACKING PEANUTS", "FORGET HOW TO BE KIND",  "MOVE TO AN EXOPLANET", "CATCH A STOWAWAY", "FALL OUT A WINDOW", "SETTLE A LAWSUIT", "BUY A NEW SHIP", "FIND A DEAD GUY", "LOVES [pick("MEDBAY", "ALCOHOL", "YOU", "UNREGISTERED GUNS", "MONKEY CUBES", "MAKING A MESS", "ANNOYING COMMAND", "GETTING BRIGGED")]")]"
		titles += "<center><h1>EPISODE [rand(1,1000)]<br>[pick(possible_titles)]<h1></h1></h1></center>"
	else
		titles += "<center><h1>EPISODE [rand(1,1000)]<br>[GLOB.end_credits_title]<h1></h1></h1></center>"

	for(var/mob/living/carbon/human/H in GLOB.alive_mobs|GLOB.dead_mobs)
		if(findtext(H.real_name,"(mannequin)"))
			continue
		if(H.is_species(SPECIES_MONKEY) && findtext(H.real_name,"[lowertext(H.species.name)]")) //no monki
			continue
		if(isnull(H.last_ckey)) //don't mention these losers (prespawned corpses mostly)
			continue
		if(!length(cast) && !chunksize)
			chunk += "CAST:"
		var/job = ""
		if(GetAssignment(H) != "Unassigned")
			job = ", [uppertext(GetAssignment(H))]"
		var/used_name = H.real_name
		var/datum/computer_file/report/crew_record/R = get_crewmember_record(H.real_name)
		if(R && R.get_rank())
			var/datum/mil_rank/rank = GLOB.mil_branches.get_rank(R.get_branch(), R.get_rank())
			if(rank.name_short)
				used_name = "[rank.name_short] [used_name]"
		var/showckey = 0
		if(H.ckey && H.client)
			if(H.client.get_preference_value(/datum/client_preference/show_ckey_credits) == GLOB.PREF_SHOW)
				showckey = 1
		var/singleton/cultural_info/actor_culture = SSculture.get_culture(H.get_cultural_value(TAG_CULTURE))
		if(!actor_culture || !(H.species.spawn_flags & SPECIES_CAN_JOIN) || prob(10))
			actor_culture = SSculture.get_culture(CULTURE_HUMAN)
		if(!showckey)
			if(prob(90))
				chunk += "[actor_culture.get_random_name(H.pronouns)]\t \t \t \t[uppertext(used_name)][job]"
			else
				var/datum/pronouns/P = H.choose_from_pronouns()
				chunk += "[used_name]\t \t \t \t[uppertext(P.him)]SELF"
		else
			chunk += "[uppertext(actor_culture.get_random_name(H.pronouns))] a.k.a. '[uppertext(H.ckey)]'\t \t \t \t[uppertext(used_name)][job]"
		chunksize++
		if(chunksize > 2)
			cast += "<center>[jointext(chunk,"<br>")]</center>"
			chunk.Cut()
			chunksize = 0
	if(length(chunk))
		cast += "<center>[jointext(chunk,"<br>")]</center>"

	titles += cast

	var/list/corpses = list()
	var/list/monkies = list()
	for(var/mob/living/carbon/human/H in GLOB.dead_mobs)
		if(isnull(H.last_ckey)) //no prespawned corpses
			continue
		if(H.is_species(SPECIES_MONKEY) && findtext(H.real_name,"[lowertext(H.species.name)]"))
			monkies[H.species.name] += 1
		else if(H.real_name)
			corpses += H.real_name
	for(var/spec in monkies)
		var/singleton/species/S = GLOB.species_by_name[spec]
		corpses += "[monkies[spec]] [lowertext(monkies[spec] > 1 ? S.name_plural : S.name)]"
	if(length(corpses))
		titles += "<center>BASED ON REAL EVENTS<br>In memory of [english_list(corpses)].</center>"

	var/list/staff = list("PRODUCTION STAFF:")
	var/list/staffjobs = list("Coffee Fetcher", "Cameraman", "Angry Yeller", "Chair Operator", "Choreographer", "Historical Consultant", "Costume Designer", "Chief Editor", "Executive Assistant")
	var/list/goodboys = list()
	for(var/client/C)
		if(!C.holder || C.is_stealthed())
			continue

		if(C.holder.rights & (R_DEBUG|R_ADMIN))
			var/singleton/cultural_info/cult = SSculture.cultural_info_by_name[pick(SSculture.cultural_info_by_name)]
			staff += "[uppertext(pick(staffjobs))] - [cult.get_random_name(pick(MALE, FEMALE))] a.k.a. '[C.key]'"
		else if(C.holder.rights & R_MOD)
			goodboys += "[C.key]"

	titles += "<center>[jointext(staff,"<br>")]</center>"
	if(length(goodboys))
		titles += "<center>STAFF'S GOOD BOYS:<br>[english_list(goodboys)]</center><br>"

	var/disclaimer = "<br>Sponsored by [GLOB.using_map.company_name].<br>All rights reserved.<br>\
					 This motion picture is protected under the copyright laws of the Sol Central Government<br> and other nations throughout the galaxy.<br>\
					 Colony of First Publication: [pick("Mars", "Luna", "Earth", "Venus", "Phobos", "Ceres", "Tiamat", "Ceti Epsilon", "Eos", "Pluto", "Ouere",\
					 "Tadmor", "Brahe", "Pirx", "Iolaus", "Saffar", "Gaia")].<br>"
	disclaimer += pick("Use for parody prohibited. PROHIBITED.",
					   "All stunts were performed by underpaid interns. Do NOT try at home.",
					   "[GLOB.using_map.company_name] does not endorse behaviour depicted. Attempt at your own risk.",
					   "Any unauthorized exhibition, distribution, or copying of this film or any part thereof (including soundtrack)<br>\
						may result in an ERT being called to storm your home and take it back by force.",
						"The story, all names, characters, and incidents portrayed in this production are fictitious. No identification with actual<br>\
						persons (living or deceased), places, buildings, and products is intended or should be inferred.<br>\
						This film is based on a true story and all individuals depicted are based on real people, despite what we just said.",
						"No person or entity associated	with this film received payment or anything of value, or entered into any agreement, in connection<br>\
						with the depiction of tobacco products, despite the copious amounts	of smoking depicted within.<br>\
						(This disclaimer sponsored by Carcinoma - Carcinogens are our Business!(TM)).",
						"No animals were harmed in the making of this motion picture except for those listed previously as dead. Do not try this at home.")
	titles += "<hr>"
	titles += "<center><span style='font-size:6pt;'>[jointext(disclaimer, null)]</span></center>"

	return titles
