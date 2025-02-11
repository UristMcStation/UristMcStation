#define BRAIN_MODULE_INCLUDED_METRICS 1

/datum/brain
	/* Bookkeeping for update times */
	var/list/last_need_update_times
	var/last_pawn_update_time
	var/last_action_update_time
