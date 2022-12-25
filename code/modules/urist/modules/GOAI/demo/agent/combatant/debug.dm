/mob/goai/combatant/verb/SetAITickDelay(var/newdelta as num|null)
	set src in view()

	if(!newdelta)
		return


	var/new_delay = max(newdelta, MINIMUM_ALLOWED_DELAY)
	ai_tick_delay = new_delay

	usr << "Set AI Tick delay for [src] to [ai_tick_delay]."
	return


/mob/verb/SetAITickDelayGlobally(var/newdelta as num|null)
	if(!newdelta)
		return

	var/new_delay = max(newdelta, MINIMUM_ALLOWED_DELAY)

	for(var/mob/goai/combatant/combatagent in world)
		combatagent.ai_tick_delay = new_delay

	usr << "Set AI Tick delay to [new_delay] for all mobs."
	return
