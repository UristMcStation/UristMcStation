/* In this module:
===================

 - Mob definition

*/


/mob/goai/combatant
	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "ANTAG"

	// Private-ish, generally only debug procs should touch these
	var/ai_tick_delay = COMBATAI_AI_TICK_DELAY

	// Optional - for map editor. Set this to force initial action. Must be valid (in available actions).
	var/initial_action = null
