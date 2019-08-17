/datum/npc_speech_trigger
	var/name
	var/trigger_phrase
	var/response_phrase
	var/angryresponse_phrase
	var/trigger_word
	var/response_chance = 100
	var/list/responses
	var/list/angryresponses

/datum/npc_speech_trigger/proc/get_response_phrase()
	return response_phrase

/datum/npc_speech_trigger/proc/get_angryresponse_phrase()
	return angryresponse_phrase

///datum/npc_speech_trigger/smuggler_response
//	trigger_word  = list("guns")
//	response_phrase = "Anyone want to buy some guns that fell off the back of a truck?"

/datum/npc_speech_trigger/colonist
	response_phrase = 1
	angryresponse_phrase = 1

/datum/npc_speech_trigger/colonist/get_response_phrase()
	return pick(responses)

/datum/npc_speech_trigger/colonist/get_angryresponse_phrase()
	return pick(angryresponses)

/datum/npc_speech_trigger/colonist/colonist_nt
	name = "NanoTrasen"
	trigger_word  = "NanoTrasen"

/datum/npc_speech_trigger/colonist/colonist_nt/New()
	..()
	responses = list(\
		"NanoTrasen is only doing what's best.",\
		"I'm proud to work for NanoTrasen!",\
		"NanoTrasen provides for us, the Terran Confederacy only provides chaos.",\
		"My [pick("uncle","aunt","sister","brother")] was a NanoTrasen [pick("marine","fighter pilot","crewman in the navy")] during the Galactic Crisis. Our entire family supports them.",\
		"NanoTrasen is what's keeping humanity together out here.",\
		"A strong NanoTrasen presence is what's needed to keep the outer colonies safe.",\
		"Rumours about striking miners are greatly exaggerated, we all know that NanoTrasen has our best interests at heart.",\
		"NanoTrasen is keeping us safe from here; without the NanoTrasen Navy, piracy would be much worse.")

	angryresponses = list(\
		"I wish NanoTrasen would just fuck off.",\
		"Taxes are rising and NanoTrasen builds a new warship. Coincidence?",\
		"Wages are stagnant but NanoTrasen's corporate profits are skyrocketing since the Galactic Crisis. It's about time some of that came our way",\
		"I used to think NanoTrasen had our best interests in mind, now...",\
		"We need to demilitarise and unite to colonise space, not build more NanoTrasen warships, the Galactic Crisis is over.",\
		"Fucking corporate pigs are only out for themselves... And NanoTrasen's profit margins of course.",\
		"Those rebelling miners have the right idea. There can be no equality or justice under corporate rule.",\
		"Did you hear that NanoTrasen destroyed another outpost full of striking miners? NanoTrasen's board of directors is scared, and they should be.")

/datum/npc_speech_trigger/colonist/colonist_tc
	name = "Terran Confederacy"
	trigger_word  = "Terran Confederacy"

/datum/npc_speech_trigger/colonist/colonist_tc/New()
	..()
	responses = list(\
		"The Terran Confederacy is only doing what's best.",\
		"I'm proud to be a citizen of the Terran Confederacy!",\
		"The Terran Confederacy provides for us, unlike the corporations.",\
		"My [pick("uncle","aunt","sister","brother")] is a Terran [pick("marine","fighter pilot","crewman in the navy")]. Our entire family supports them.",\
		"The Terran Confederacy is what's keeping humanity together out here.",\
		"A strong Terran presence is what's needed to keep the outer colonies safe.",\
		"A strong navy is what's needed to keep the outer colonies in line.")

	angryresponses = list(\
		"I wish the Terran Confederacy would just fuck off.",\
		"Taxes are rising and the Terran Confederacy builds a new warship. Coincidence?",\
		"More and more lizards are showing up here, taking our jobs. I'm starting to think the United Human Alliance has the right idea.",\
		"I used to think the Terran Confederacy had our best interests in mind, now with the civil war, I just don't know...",\
		"The Galactic Crisis is over, but we're still at war. The politicians on Mars need to get their heads out of their asses.",\
		"Fucking Martian bureaucracy. Nothing ever gets done on time around here.")

/datum/npc_speech_trigger/colonist/colonist_tc_uha
	name = "United Human Alliance"
	trigger_word  = "United Human Alliance"

/datum/npc_speech_trigger/colonist/colonist_tc_uha/New()
	..()
	responses = list(\
		"The United Human Alliance are just terrorists.",\
		"The insurrection wants to burn everything we've built here.",\
		"I hope the United Human Alliance stays away from here, we lost too much already during the Galactic Crisis.",\
		"I've heard the outer colonies are fighting to secede. There's an insurrection brewing.",\
		"First the Galactic Crisis and now a civil war. Will it ever end?")

	angryresponses = list(\
		"We should be left to govern ourselves.",\
		"If you ask me, the United Human Alliance has the right idea about those lizard fucks",\
		"No aliens. Only man.",\
		"There's an insurrection brewing, maybe it's about time the Confederacy falls apart.",\
		"I'm not saying the United Human Alliance is justified, but some of their leaders have the right idea about where humanity should be going.")

/datum/npc_speech_trigger/colonist/colonist_lizards
	name = "Unathi"
	trigger_word  = "Unathi"

/datum/npc_speech_trigger/colonist/colonist_lizards/New()
	..()
	responses = list(\
		"The Unathi may have saved our asses during the Galactic Crisis, but I still don't trust them.",\
		"Sometimes I think that the United Human Alliance has the right idea about Unathi, but they do go a little too far for my tastes.",\
		"I don't necessarily dislike Unathi, I have some Unathi friends.",\
		"I'm no lizard lover, but we do owe them a debt.",\
		"I've got no issues with Unathi, I just don't get all this hate towards them.")

	angryresponses = list(\
		"Fucking lizard scum.",\
		"If you ask me, the United Human Alliance has the right idea about those lizard fucks",\
		"No aliens. Only man.",\
		"We would have stopped the Galactic Crisis without those lizard fucks.",\
		"If the administration had their wits about them, they would keep Unathi from taking our jobs.")

/datum/npc_speech_trigger/colonist/colonist_galacticcrisis
	name = "Galactic Crisis"
	trigger_word  = "Galactic Crisis"

/datum/npc_speech_trigger/colonist/colonist_galacticcrisis/New()
	..()
	responses = list(\
		"The Galactic Crisis may be over, but some days it just doesn't feel like it. Things have gotten so much worse lately...",\
		"I lost my [pick("uncle","aunt","sister","brother","mother","father")] during the Galatic Crisis. It feels like everyone lost something.",\
		"My [pick("uncle","aunt","sister","brother","mother","father")] was an ANFOR [pick("marine","fighter pilot","crewman")] during the Galactic Crisis, we're all proud of their sacrifice.",\
		"They say the Galactic Crisis is over, but there's still xeno ships floating around. Will we ever be at peace?",\
		"It's hardly been a decade since the Galactic Crisis came to an end, but it feels like just yesterday we were living with the fear of death every day.",\
		"Everything wrong with the world today has to do with the Galactic Crisis. The Civil War, the refugee crisis, the miner's uprisings... Nothing feels right anymore.")

/datum/npc_speech_trigger/colonist/colonist_pirate
	name = "pirates"
	trigger_word  = "pirates"

/datum/npc_speech_trigger/colonist/colonist_pirate/New()
	..()
	responses = list(\
		"Piracy has gotten so much worse since the end of the Galactic Crisis.",\
		"Just last week pirates hit another supply convoy. They still haven't been caught.",\
		"I was on a ship recently that was attacked by pirates. We managed to get away, but only barely.",\
		"They say the Galactic Crisis is over, but now piracy is rampant in the outer systems. Will we ever be at peace?",\
		"They took down a couple pirate ships yesterday, but it's hardly a dent in their numbers.")

/datum/npc_speech_trigger/colonist/colonist_lactera
	name = "Lactera"
	trigger_word  = "Lactera"

/datum/npc_speech_trigger/colonist/colonist_lactera/New()
	..()
	responses = list(\
		"Even though the Galactic Crisis is supposedly over, we're still getting attacked by Lactera. It feels like we'll never be at peace.",\
		"Just last week Lactera raiders hit another supply convoy. They still haven't been caught.",\
		"I was on a ship recently that was attacked by Lactera raiders. We managed to get away, but only barely.",\
		"At least they're not operating as an organized force anymore, those rogue Lactera still make life dangerous in the outer systems",\
		"They took down another Lactera ship yesterday, but it feels like it's hardly a dent in their numbers.",\
		"I have a cousin that fought against the Lactera during the Galactic Crisis as part of ANFOR. He would always tell stories about their ruthless efficiency.",\
		"Lactera raiders are bad, but at least the other alien species that attacked us during the Galactic Crisis don't seem to be a threat anymore. Have you heard about the Faithless? Apparently they were far more terrifying than the Lactera.",\
		"Have you ever seen a Lactera up close? Apparently they look a lot like Unathi.")
