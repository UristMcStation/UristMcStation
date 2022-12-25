
/mob/goai/sim/proc/GetMotive(var/motive_key)
	if(isnull(motive_key))
		return

	var/datum/brain/concrete/sim/simbrain = brain

	if(!simbrain)
		return

	return simbrain.GetMotive(motive_key)


/mob/goai/sim/proc/ChangeMotive(var/motive_key, var/value)
	if(isnull(motive_key))
		return

	var/datum/brain/concrete/sim/simbrain = brain

	if(!simbrain)
		return

	simbrain.ChangeMotive(motive_key, value)


/mob/goai/sim/proc/AddMotive(var/motive_key, var/amt)
	if(isnull(motive_key))
		return

	var/datum/brain/concrete/sim/simbrain = brain

	if(!simbrain)
		return

	simbrain.AddMotive(motive_key, amt)


/mob/goai/sim/proc/MotiveDecay(var/motive_key, var/custom_decay_rate = null)
	if(isnull(motive_key))
		return

	var/datum/brain/concrete/sim/simbrain = brain

	if(!simbrain)
		return

	simbrain.MotiveDecay(motive_key, custom_decay_rate)
	needs = brain.needs
