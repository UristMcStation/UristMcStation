/*
// Subversive factions don't fit in the normal relationship model;
// rather than maintaining relationships with the leadership of the target,
// they instead build grassroots support with its (broad-church) population
// and eventually replace that leadership.
//
// We'll model this by a 'Sympathy' variable separate from the Relationship score, for each faction of interest.
// We'll put this in the faction Personality, to represent it influencing our decisions.
//
// This can represent activities of cults, revolutionaries, conspiracies, alien infestations,
// criminal influence, mostly benevolent lobbying, or any other unofficial influence network.
*/

// We'll leave some buffer over 100% to represent deeply rooted influence; 100% is already ready to coup-level power.
#define DEFAULT_SYMPATHY_MIN 0
#define DEFAULT_SYMPATHY_MAX 150

#define DEFAULT_SYMPATHY_INCREASE_GAIN 5
#define DEFAULT_SYMPATHY_SUPPRESS_LOSS 25

/* The general interface is:
// - tracker - ActionTracker (bc always)
// - target - who to apply the effect to (defaults to us if it makes sense in context)
// - tag - what's the affinity tag to use; generally intended to be an action hardarg
// - amt - how much to shift opinion; generally meant to be optional with a consted default
*/

/*
// Infiltrate target with sympathizers of our agenda
// Can be repurposed for discrediting enemies with appropriate tag and negative amt.
*/
/datum/utility_ai/proc/IncreaseSympathy(var/datum/ActionTracker/tracker, var/datum/utility_ai/target, var/tag = null, var/amt = null)
	if(isnull(tracker))
		RUN_ACTION_DEBUG_LOG("Tracker is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(isnull(target))
		RUN_ACTION_DEBUG_LOG("target is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(tracker.IsStopped())
		return

	if(isnull(target.brain))
		RUN_ACTION_DEBUG_LOG("Target brain is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	if(isnull(target.brain.personality))
		target.brain.personality = list()

	if(prob(75))
		// Defaulting tag to faction name; tag is the base identifier for what target is growing fond of
		// Multiple factions could share this if they collaborate; e.g. multiple competing cult sects all
		// increasing the target's zeal towards their shared belief, even if they disagree on the details.
		var/_tag = isnull(tag) ? "[src.name]" : tag

		// Personality trait key to use.
		var/sympathy_key = "Sympathy for [_tag]"

		// Retrieve current sympathy, or 0.
		var/curr_val = target.brain.personality[sympathy_key]
		if(isnull(curr_val))
			curr_val = DEFAULT_SYMPATHY_MIN

		// Defaulting amount in case not set
		var/amount = (isnull(amt) ? DEFAULT_SYMPATHY_INCREASE_GAIN : amt)

		// Might want to clamp this to min/max later.
		var/new_amount = clamp((curr_val + amount), DEFAULT_SYMPATHY_MIN, DEFAULT_SYMPATHY_MAX)

		// Set the new value
		target.brain.personality[sympathy_key] = new_amount

	tracker.SetDone()
	return


/* Counterintel, eliminate sympathizers of other agendas in ourselves */
/datum/utility_ai/proc/PurgeSympathy(var/datum/ActionTracker/tracker, var/tag = null, var/amt = null, var/datum/utility_ai/target = null)
	if(isnull(tracker))
		RUN_ACTION_DEBUG_LOG("Tracker is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(isnull(tag))
		RUN_ACTION_DEBUG_LOG("tag is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	if(tracker.IsStopped())
		return

	if(isnull(target))
		target = src

	if(isnull(target.brain))
		RUN_ACTION_DEBUG_LOG("Source brain is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	if(isnull(target.brain.personality))
		target.brain.personality = list()

	if(prob(75))
		// Defaulting tag to faction name; tag is the base identifier for what target is growing fond of
		// Multiple factions could share this if they collaborate; e.g. multiple competing cult sects all
		// increasing the target's zeal towards their shared belief, even if they disagree on the details.
		var/_tag = tag

		// Personality trait key to use.
		var/sympathy_key = "Sympathy for [_tag]"

		// Retrieve current sympathy, or 0.
		var/curr_val = target.brain.personality[sympathy_key]
		if(isnull(curr_val))
			curr_val = DEFAULT_SYMPATHY_MIN

		// Defaulting amount in case not set
		var/amount = (isnull(amt) ? DEFAULT_SYMPATHY_SUPPRESS_LOSS : amt)

		// Might want to clamp this to min/max later.
		var/new_amount = (curr_val - amount)

		// Set the new value
		target.brain.personality[sympathy_key] = new_amount

	tracker.SetDone()
	return
