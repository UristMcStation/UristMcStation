/*
// AI Commander - an abstract AI agent that can represent a faction or an L4D-style Director.
// May act via physical GOAI Agents, 'dumb' AIs, spawners, any combination of these, or more!
//
// DESIGN NOTE: While this is a more abstract entity, it should be more akin to Agents than to
//   Brains - it should have a Brain as a component, alongside Senses and Actions like a physical being.
//   This is so that we could, in principle, 'transplant' the components into an Agent to act as an avatar of sorts
//   or go the other way and port an Agent into a Commander to model distributed executors, e.g. tentacles of a Kraken
*/


/datum/goai/goai_commander
	// Private-ish, generally only debug procs should touch these
	ai_tick_delay = COMMANDERAI_AI_TICK_DELAY


/datum/goai/goai_commander/Life()
	. = ..()

	// Perception updates
	spawn(0)
		while(life)
			src.SensesSystem()
			sleep(COMBATAI_SENSE_TICK_DELAY)

	// AI
	spawn(0)
		while(life)
			// Fix the tickrate to prevent runaway loops in case something messes with it.
			// Doing it here is nice, because it saves us from sanitizing it all over the place.
			src.ai_tick_delay = max((src?.ai_tick_delay || 0), 1)

			// Run the Life update function.
			src.LifeTick()

			// Wait until the next update tick.
			sleep(src.ai_tick_delay)
