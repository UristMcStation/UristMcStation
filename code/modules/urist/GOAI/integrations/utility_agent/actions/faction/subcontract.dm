/*
// Currency can be exchanged for goods and services. And one of those services is shooting people in the face.
//
// Factions may be unable or unwilling to do their dirty work themselves, for whatever reason.
// In the grim darkness of the distant future, there is no shortage of people willing to relieve
// them of this burden for a fistful of credits.
//
// Hiring on an individual basis should be handled by treating the merc as a normal faction pawn,
// perhaps with slightly unusual relationships and/or personality traits.
//
// Instead, Actions here represent one Faction hiring *another Faction*.
//
// This goes both ways - it can be a corporation using a gang to do its black ops, but equally
// a powerful mob boss could hire a corporate PMC to guard some valuable asset, etc.
*/

/datum/utility_ai/proc/SubcontractForMission(var/datum/ActionTracker/tracker, var/datum/utility_ai/target, var/list/mission_args)
	// tracker - usual ActionTracker shenanigans
	// contractee - an AI (usually a Faction AI) to give the job to
	// mission_args - assoc list of the args to pass to the actual jobs (e.g. targets, amounts, etc.)
	return
