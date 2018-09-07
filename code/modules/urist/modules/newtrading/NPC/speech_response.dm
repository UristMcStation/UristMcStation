/datum/npc_speech_trigger
	var/trigger_phrase
	var/response_phrase
	var/angryresponse_phrase
	var/list/trigger_words = list()
	var/response_chance = 100
	var/list/responses = list()
	var/list/angryresponses = list()

/datum/npc_speech_trigger/proc/get_response_phrase()
	return pick(responses)

/datum/npc_speech_trigger/proc/get_angryresponse_phrase()
	return pick(angryresponses)

/datum/npc_speech_trigger/smuggler_response
	trigger_words  = list("guns")
	response_phrase = "Anyone want to buy some guns that fell off the back of a truck?"

/datum/npc_speech_trigger/colonist_nt
	trigger_words  = list("Nanotrasen", "NT")
	response_phrase = 1

/datum/npc_speech_trigger/colonist_nt/New()

	responses = list(\
		"Nanotrasen is only doing what's best.",\
		"I'm proud to work for Nanotrasen!",\
		"Nanotrasen provides for us, the Terran Confederacy provides only chaos.",\
		"My [pick("uncle","aunt","sister","brother")] was a Nanotrasen [pick("marine","fighter pilot","crewman in the navy")]. Our entire family supports them.",\
		"Nanotrasen is what's keeping humanity together out here.",\
		"A strong Nanotrasen presence is what's needed to keep the outer colonies safe.")

	angryresponses = list(\
		"I wish Nanotrasen would just fuck off.",\
		"Taxes are rising and Nanotrasen builds a new warship. Coincidence?",\
		"Wages are stagnant but Nanotrasen's corporate profits are skyrocketing since the Galactic Crisis. It's about time some of that came our way",\
		"I used to think Nanotrasen had our best interests in mind, now...",\
		"We need to demilitarise and unite to colonise space, not build more Nanotrasen warships, the Galactic Crisis is over.",\
		"Fucking corporate pigs are only out for themselves... And Nanotrasen's profit margins of course.")

/datum/npc_speech_trigger/colonist_tc
	trigger_words  = list("Terran Confederacy", "TC")
	response_phrase = 1

/datum/npc_speech_trigger/colonist_tc/New()
	responses = list(\
		"The Terran Confederacy is only doing what's best.",\
		"I'm proud to be a citizen of the Terran Confederacy!",\
		"The Terran Confederacy provides for us, unlike the corporations.",\
		"My [pick("uncle","aunt","sister","brother")] was a Terran [pick("marine","fighter pilot","crewman in the navy")]. Our entire family supports them.",\
		"The Terran Confederacy is what's keeping humanity together out here.",\
		"A strong Terran presence is what's needed to keep the outer colonies safe.")

	angryresponses = list(\
		"I wish the Terran Confederacy would just fuck off.",\
		"Taxes are rising and the Terran Confederacy builds a new warship. Coincidence?",\
		"More and more lizards are showing up here, taking our jobs. I'm starting to think the United Human Alliance has the right idea.",\
		"I used to think the Terran Confederacy had our best interests in mind, now with the civil war, I just don't know...",\
		"The Galactic Crisis is over, but we're still at war. The politicians on Mars need to get their heads out of their asses.",\
		"Fucking Martian bureaucracy. Nothing ever gets done on time around here.")

/datum/npc_speech_trigger/colonist_tc_uha
	trigger_words  = list("United Human Alliance", "UHA")
	response_phrase = 1

/datum/npc_speech_trigger/colonist_tc_uha/New()
	responses = list(\
		"The United Human Alliance are just terrorists.",\
		"The insurrection wants to burn everything we've built here.",\
		"I hope the United Human Alliance stays away from here, we lost too much already during the Galactic Crisis.",\
		"I've heard the outer colonies are fighting to secede. There's an insurrection brewing.",\
		"First the Galactic Crisis and now a civil war. Will it ever end?")

	angryresponses = list(\
		"We should be left to govern ourselves.",\
		"If you ask me, the United Human Alliance has the right idea about those lizard fucks",\
		"No aliens. Only men.",\
		"There's an insurrection brewing, maybe it's about time the Confederacy falls apart.",\
		"I'm not saying the United Human Alliance is justified, but some of their leaders have the right idea about where humanity should be going.")

/datum/npc_speech_trigger/colonist_lizards
	trigger_words  = list("Unathi", "lizards")
	response_phrase = 1

/datum/npc_speech_trigger/colonist_lizards/New()
	responses = list(\
		"The Unathi may have saved our asses during the Galactic Crisis, but I still don't trust them.",\
		"Sometimes I think that the United Human Alliance has the right idea about Unathi, but they do go a little too far for my tastes.",\
		"I don't necessarily dislike Unathi, I have some Unathi friends.",\
		"I'm no lizard lover, but we do owe them a debt.",\
		"I've got no issues with Unathi, I just don't get all this hate towards them.")

	angryresponses = list(\
		"Fucking lizard scum.",\
		"If you ask me, the United Human Alliance has the right idea about those lizard fucks",\
		"No aliens. Only men.",\
		"We would have stopped the Galactic Crisis without those lizard fucks.",\
		"If the administration had their wits about them, they would keep Unathi from taking our jobs.")

/datum/npc_speech_trigger/colonist_galacticcrisis
	trigger_words  = list("Galactic Crisis")
	response_phrase = 1

/datum/npc_speech_trigger/colonist_galacticcrisis/New()
	responses = list(\
		"The Galactic Crisis may be over, but some days it just doesn't feel like it. Things have gotten so much worse lately...",\
		"I lost my [pick("uncle","aunt","sister","brother","mother","father")] during the Galatic Crisis. It feels like everyone lost something.",\
		"My [pick("uncle","aunt","sister","brother","mother","father")] was an ANFOR [pick("marine","fighter pilot","crewman")] during the Galactic Crisis, we're all proud of their sacrifice.",\
		"They say the Galactic Crisis is over, but there's still xeno ships floating around. Will we ever be at peace?",\
		"It's hardly been a decade since the Galactic Crisis came to an end, but it feels like just yesterday we were living with the fear of death every day.")

/datum/npc_speech_trigger/colonist_pirate
	trigger_words  = list("pirate", "piracy")
	response_phrase = 1

/datum/npc_speech_trigger/colonist_pirate/New()
	responses = list(\
		"Piracy has gotten so much worse since the end of the Galactic Crisis.",\
		"Just last week pirates hit another supply convoy. They still haven't been caught.",\
		"I was on a ship recently that was attacked by pirates. We managed to get away, but only barely.",\
		"They say the Galactic Crisis is over, but now piracy is rampant in the outer systems. Will we ever be at peace?",\
		"They took down a couple pirate ships yesterday, but it's hardly a dent in their numbers.")
