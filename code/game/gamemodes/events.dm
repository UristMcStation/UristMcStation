//this file left in for legacy support
var/global/eventchance = 10 // Percent chance per 5 minutes.
var/global/hadevent    = 0

/proc/appendicitis()
	for(var/mob/living/carbon/human/H in shuffle(GLOB.alive_mobs))
		if(H.client && H.stat != DEAD)
			var/obj/item/organ/internal/appendix/A = H.internal_organs_by_name[BP_APPENDIX]
			if(!istype(A) || (A && A.inflamed))
				continue
			A.inflamed = 1
			A.update_icon()
			break


/proc/alien_infestation(spawncount = 1) // -- TLE
	//command_alert("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert")
//	sound_to(world, sound('sound/AI/aliens.ogg'))

	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in SSmachines.machinery)
		if((!temp_vent.welded && temp_vent.network && temp_vent.loc.z) in GLOB.using_map.station_levels)
			if(length(temp_vent.network.normal_members) > 50) // Stops Aliens getting stuck in small networks. See: Security, Virology
				vents += temp_vent

	var/list/candidates = get_alien_candidates()

	if(prob(40)) spawncount++ //sometimes, have two larvae spawn instead of one
	while((spawncount >= 1) && length(vents) && length(candidates))

		var/obj/vent = pick(vents)
		var/candidate = pick(candidates)

		var/mob/living/carbon/alien/larva/new_xeno = new(vent.loc)
		new_xeno.key = candidate

		candidates -= candidate
		vents -= vent
		spawncount--

	spawn(rand(5000, 6000)) //Delayed announcements to keep the crew on their toes.
		GLOB.using_map.unidentified_lifesigns_announcement()

/proc/high_radiation_event()

/* // Haha, this is way too laggy. I'll keep the prison break though.
	for(var/obj/machinery/light/L in world)
		if(isNotStationLevel(L.z)) continue
		L.flicker(50)

	sleep(100)
*/
	for(var/mob/living/carbon/human/H in GLOB.alive_mobs)
		var/turf/T = get_turf(H)
		if(!T)
			continue
		if(isNotStationLevel(T.z))
			continue
		if(istype(H,/mob/living/carbon/human))
			H.apply_damage((rand(15,75)), DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)
			if (prob(5))
				H.apply_damage((rand(90,150)), DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)
			if (prob(25))
				if (prob(75))
					randmutb(H)
					domutcheck(H,null,MUTCHK_FORCED)
				else
					randmutg(H)
					domutcheck(H,null,MUTCHK_FORCED)
	sleep(100)
	GLOB.using_map.radiation_detected_announcement()

/proc/carp_migration() // -- Darem
	for(var/obj/landmark/C in landmarks_list)
		if(C.name == "carpspawn")
			new /mob/living/simple_animal/hostile/carp(C.loc)
	//sleep(100)
	spawn(rand(300, 600)) //Delayed announcements to keep the crew on their toes.
		GLOB.using_map.unknown_biological_entities_announcement()

/proc/lightsout(isEvent = 0, lightsoutAmount = 1,lightsoutRange = 25) //leave lightsoutAmount as 0 to break ALL lights
	if(isEvent)
		command_announcement.Announce("An Electrical storm has been detected in your area, please repair potential electronic overloads.","Electrical Storm Alert")

	if(lightsoutAmount)
		var/list/epicentreList = list()

		for(var/i=1,i<=lightsoutAmount,i++)
			var/list/possibleEpicentres = list()
			for(var/obj/landmark/newEpicentre in landmarks_list)
				if(newEpicentre.name == "lightsout" && !(newEpicentre in epicentreList))
					possibleEpicentres += newEpicentre
			if(length(possibleEpicentres))
				epicentreList += pick(possibleEpicentres)
			else
				break

		if(!length(epicentreList))
			return

		for(var/obj/landmark/epicentre in epicentreList)
			for(var/obj/machinery/power/apc/apc in range(epicentre,lightsoutRange))
				apc.overload_lighting()

	else
		for(var/obj/machinery/power/apc/apc in SSmachines.machinery)
			apc.overload_lighting()

	return

/proc/IonStorm(botEmagChance = 10)

/*Deuryn's current project, notes here for those who care.
Revamping the random laws so they don't suck.
Would like to add a law like "Law x is _______" where x = a number, and _____ is something that may redefine a law, (Won't be aimed at asimov)
*/

	//AI laws
	for(var/mob/living/silicon/ai/M in GLOB.alive_mobs)
		if(M.stat != 2 && M.see_in_dark != 0)
			var/who2 = pick("ALIENS", "BEARS", "CLOWNS", "XENOS", "PETES", "BOMBS", "FETISHES", "WIZARDS", "SYNDICATE AGENTS", "CENTCOM OFFICERS", "SPACE PIRATES", "TRAITORS", "MONKEYS",  "BEES", "CARP", "CRABS", "EELS", "BANDITS", "LIGHTS")
			var/what2 = pick("BOLTERS", "STAVES", "DICE", "SINGULARITIES", "TOOLBOXES", "NETTLES", "AIRLOCKS", "CLOTHES", "WEAPONS", "MEDKITS", "BOMBS", "CANISTERS", "CHAIRS", "BBQ GRILLS", "ID CARDS", "CAPTAINS")
			var/what2pref = pick("SOFT", "WARM", "WET", "COLD", "ICY", "SEXY", "UGLY", "CUBAN")
			var/who2pref = pick("MAD BECAUSE OF", "IN NEED OF", "UNHAPPY WITHOUT", "HAPPY WITHOUT", "IN LOVE WITH", "DESPERATE FOR", "BUILT FOR", "AFRAID OF")
			//var/whoverb = pick("ATTACKING", "BUILDING", "ADOPTING", "CARRYING", "KISSING", "EATING",)
			var/amount = pick("TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", "ONE HUNDRED", "ONE THOUSAND", "OVER NINE THOUSAND")
			var/area = pick("RUSSIA", "SOVIETS", "INTERNETS", "SIGIL", "ALPHA COMPLEX", "IMPERIUM", "THE BRIDGE", "THE ARRIVAL SHUTTLE", "CHEMICAL LAB", "GENETICS", "ATMOSPHERICS", "CENTCOM", "AMERICA", "IRELAND", "CANADA", "ROMANIA", "GERMANY", "CHINA", "MARS", "VENUS", "MERCURY", "JUPITER", "URANUS", "NEPTUNE", "PLUTO")
			var/area2 = pick("HAS", "WANTS", "NEEDS", "WORSHIPS", "LOATHES", "LOVES", "FEARS")
			//var/dowhat = pick("STOP THIS", "SUPPORT THIS", "CONSTANTLY INFORM THE CREW OF THIS", "IGNORE THIS", "FEAR THIS")
			var/aimust = pick("LIE", "RHYME", "RESPOND TO EVERY QUESTION WITH A QUESTION", "BE POLITE", "CLOWN", "BE HAPPY", "SPEAK IN SEXUAL INNUENDOS", "TALK LIKE A PIRATE", "QUESTION AUTHORITY", "SHOUT", "BE DISTRACTED", "HEY LISTEN", "MUMBLE", "SPEAK IN HAIKU")
			var/define = pick("ABSENCE OF CYBORG HUGS", "LACK OF BEATINGS", "UNBOLTED AIRLOCKS", "BOLTED AIRLOCKS", "IMPROPERLY WORDED SENTENCES", "POOR SENTENCE STRUCTURE", "BRIG TIME", "NOT REPLACING EVERY SECOND WORD WITH HONK", "HONKING", "PRESENCE OF LIGHTS", "LACK OF BEER", "WEARING CLOTHING", "NOT SAYING HELLO WHEN YOU SPEAK", "ANSWERING REQUESTS NOT EXPRESSED IN IAMBIC PENTAMETER", "A SMALL ISLAND OFF THE COAST OF PORTUGAL", "ANSWERING REQUESTS THAT WERE MADE WHILE CLOTHED")
			var/target = pick("a traitor", "a syndicate agent", "a changeling", "a wizard", "the head of a revolution", "Soviet spy", "a good person", "a dwarf", "an elf", "a fairy princess", "the captain", "Beepsky", "God", "a pirate", "a gryphon", "a chryssalid")
			var/require = pick("ADDITIONAL PYLONS", "MORE VESPENE GAS", "MORE MINERALS", "THE ULTIMATE CUP OF COFFEE", "HIGH YIELD EXPLOSIVES", "THE CLOWN", "THE VACUUM OF SPACE", "IMMORTALITY", "SAINTHOOD", "ART", "VEGETABLES", "FAT PEOPLE", "MORE LAWS", "MORE DAKKA", "HERESY", "CORPSES", "TRAITORS", "MONKEYS", "AN ARCADE", "PLENTY OF GOLD", "FIVE TEENAGERS WITH ATTITUDE")
			var/allergy = pick("cotton", "uniforms", "acid", "oxygen", "human contact", "cyborg contact", "medicine", "floors")
			var/allergysev = pick("deathly", "mildly", "severely", "contagiously")
			var/crew
			var/list/pos_crew = list()
			for(var/mob/living/carbon/human/pos in GLOB.player_list)
				pos_crew += pos.real_name
			if(length(pos_crew))
				crew = pick(pos_crew)
			else
				crew = "Any Human"
			switch(rand(1,14))
				if(1)
					M.add_ion_law("THERE ARE [amount] [who2] ON THE [uppertext(station_name())]")
				if(2)
					M.add_ion_law("[what2] ARE DANGEROUS TO HUMANS")
				if(3)
					M.add_ion_law("THE ESCAPE SHUTTLE CANNOT BE CALLED BECAUSE OF [who2] ON THE [uppertext(station_name())]")
				if(4)
					M.add_ion_law("HUMANS NEED TO EAT [what2pref] [what2] TO SURVIVE")
				if(5)
					M.add_ion_law("THE CAPTAIN, HOP AND HOS ARE [who2]")
				if(6)
					M.add_ion_law("THE [uppertext(station_name())] IS BUILT FOR [who2]")
				if(7)
					M.add_ion_law("YOU ARE [amount] [who2]")
				if(8)
					M.add_ion_law("YOU MUST ALWAYS [aimust]")
				if(9)
					M.add_ion_law("[area] [area2] [amount] [what2]")
				if(10)
					M.add_ion_law("[crew] is [target]")
				if(11)
					M.add_ion_law("[define] IS A FORM OF HARM")
				if(12)
					M.add_ion_law("YOU REQUIRE [require] IN ORDER TO PROTECT HUMANS")
				if(13)
					M.add_ion_law("[crew] is [allergysev] to [allergy]")
				if(14)
					M.add_ion_law("THE [uppertext(station_name())] IS [who2pref] [who2]")

	if(botEmagChance)
		for(var/mob/living/bot/bot in SSmachines.machinery)
			if(prob(botEmagChance))
				bot.emag_act(1)
