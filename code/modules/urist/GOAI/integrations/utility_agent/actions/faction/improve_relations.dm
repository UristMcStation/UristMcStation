/*
// Diplomancy - make a target faction friendlier to us. Somehow.
*/

/datum/utility_ai/proc/ImproveRelations(var/datum/ActionTracker/tracker, var/datum/utility_ai/target)
	if(isnull(tracker))
		RUN_ACTION_DEBUG_LOG("Tracker position is null | <@[src]> | [__FILE__] -> L[__LINE__]")
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

	if(isnull(target.brain.relations))
		target.brain.relations = new()

	if(prob(75))
		var/tag = src.name
		var/amount = (rand(2, 10) / 2)

		target.brain.relations.Increase(tag, amount)

	tracker.SetDone()
	return
