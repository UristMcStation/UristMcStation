#define PERSONALITY_STEADY "Steady"
#define PERSONALITY_AGGRESSIVE "Aggressive"
#define PERSONALITY_COWARD "Coward"
#define PERSONALITY_AI "AI"
#define PERSONALITY_RECKLESS "Reckless"
#define PERSONALITY_ALIEN "Alien"

GLOBAL_LIST_INIT(global_ship_personalities, list(
	"Steady" = list(datum/ship_personality),
	"Aggressive" = list(/datum/ship_personality/aggressive),
	"Coward" = list(/datum/ship_personality/coward),
	"AI" = list(/datum/ship_personality/AI),
	"Reckless" = list(/datum/ship_personality/reckless),
	"Alien" = list(/datum/ship_personality/alien)
))

//SHIP NAME GENERATION
/datum/ship_name
	name = "Default Naming scheme"
	var/list/prefixes = list("IMV", "ICS", "ICV", "CS")
	var/list/ship_names = list("Kestrel", "Starhawk", "Voyager", "Enterprise", "Unstoppable", "Undefeatable", "Clear Skies", "Skyranger", "Big Sky", "Menace")

/mob/living/simple_animal/hostile/overmapship/proc/get_name_and_personality()
	switch(hiddenfaction)
		if("pirate")
			if(prob(50)
				personality = PERSONALITY_STEADY
			else
				personality = PERSONALITY_AGGRESSIVE
		if("alien")
			if(prob(50))
				personality = PERSONALITY_AGGRESSIVE
			else
				personality = PERSONALITY_RECKLESS
		if("nanotrasen")
			if(prob(75))
				personality = PERSONALITY_COWARD
			else
				personality = PERSONALITY_STEADY
		if("terran")
			personality = PERSONALITY_STEADY
		if("rebel")
			personality = PERSONALITY_RECKLESS



//SHIP AI PERSONALITIES

/datum/ship_personality //base type
	name = "Default"
	var/personality = PERSONALITY_STEADY
	var/aggressiveness = 1 //Aggressive AIs are more likely to attack.
	var/cowardice = 1 //Cowardly AIs will try to avoid combat, and dodge shots.
	var/reckless = 0 //Recklessness means the AI has zero regard for survival, and will attack at all costs.
	var/datum/ship_taunts/taunt_datum = datum/ship_taunts
	var/datum/ship_name/ship_names = datum/ship_name

/datum/ship_personality/aggressive
	personality = PERSONALITY_AGGRESSIVE
	aggressiveness = 2
	cowardice = 0
//	taunt_datum =
//	ship_names =

/datum/ship_personality/coward
	personality = PERSONALITY_COWARD
	aggressiveness = 1
	cowardice = 2

/datum/ship_personality/reckless
	personality = PERSONALITY_RECKLESS
	reckless = 1

/datum/ship_personality/AI //AIs have weird gibberish for taunts.
	personality = PERSONALITY_AI
	reckless = 1

/datum/ship_personality/alien //Aliens don't taunt.
	personality = PERSONALITY_ALIEN
	reckless = 1

//TAUNTS FOR AI PERSONALITIES

/datum/ship_taunts
	name = "Default Taunts"
	var/list/normal_taunts = list(
	"Power down your weapons and shields, and surrender.", "You can't hope to defeat me. You're outmatched.", "The more you fight, the less likely i'm to let the survivors live.",
	"We're both out here to make some money, I just intend to make it by destroying you.", "It's a dangerous world. And i'm the danger.", "Keep struggling. It's fun to watch you panic.") //What it says normally.

	var/list/on_damage = list(
	"Gah! Damn, you scratched my paint.", "Holy smokes, that one took out Deck Three! And I left my wallet on Deck Three...", "Is it just me, or do i smell burning toast?",
	"Main deflectors are holding, you'll have to try harder than that!", "Is that the best you've got?", "Grr, that was my favorite part of the ship!") //What it says when taking damage.

	var/list/on_retreat = list(
	"Alright alright, I overestimated you!", "Engines to flank speed, get us the hell out of here!", "It'll be easier on you if you let us live!",
	"Okay, okay! How much do you want to STOP SHOOTING AT US?!", "Holy crap, my insurance is going to kill me for this...", "Oscar Mike Foxtrot Golf, we're trying to get the fuck out of here!") //What it says while attempting to retreat.

	var/list/on_weapons_fire = list("All guns, fire!", "Take that!", "Let's see how you like this.", "I spent good money on these guns. Money well spent.", "Keep firing.") //What it says after firing one of it's weapons.

	var/list/on_component_destroyed = list("Gah! You'll pay for that!", "That won't stop us. Keep firing!", "You may have damaged my ship, but i'l kill you all!", "Do you know how ANGRY you're making me?"
	"This isn't over until I say it's over!", "Amusing. You might actually put up a decent  fight!")
	) //What it says when something critical has been destroyed.

	var/list/on_defeat = list("The Captain goes down with the ship.", "All hands, abandon ship, they beat us!", "Damn you all to hell!", "NOOOOOOO!",
	"The reactor is breach-ZZZZZZ!", "Our weapons are fused and hull damage is critical, all hands abandon ship!") //What it says when the ship is destroyed.

