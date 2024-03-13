# define DEMOGOAP_DEBUG_LOGGING 0

# ifdef DEMOGOAP_DEBUG_LOGGING
# define DEMOGOAP_DEBUG_LOG(X) world.log << X
# else
# define DEMOGOAP_DEBUG_LOG(X)
# endif

// Demo implementation
/datum/GOAP/demoGoap
	// I hate to do that in the state, but I will to POC it.
	var/list/blackboard_defaults = null
	var/bfs_to_dfs_switchpoint = 100


/datum/GOAP/demoGoap/update_op(var/old_val, var/new_val)
	//var/result = old_val + new_val
	//return result
	return new_val


/datum/GOAP/demoGoap/pqueue_key_gen(var/curr_iter, var/curr_cost, var/heuristic)
	// I've discovered a curious tradeoff in the algorithm:
	// Simple, short plans benefit from BFS (explore close branches first) as per classic GOAP papers
	// Complex plans actually perform better with DFS (expand existing branches)!
	//
	// The difference is like 30 (DFS) vs 200 (BFS) iterations to resolve a plan to open a door.
	//
	// However, DFS plans are lower quality, with completely pointless actions
	// (as the heuristic favors branch-diving through unneeded intermediate steps)
	//
	// So the compromise is a mix; heuristically, we'll switch between BFS and DFS based on iteration.
	// Idea being - simple plans should be short as-is, and if complex plans grow too long we should switch to DFS to finish them.

	// NOTE: The above is true when not using transposition table filtering. May not be true anymore.
	// As such, I upped the default switchpoint to iteration 100.
	return ((curr_iter < src.bfs_to_dfs_switchpoint) ? 1 : -1) * curr_iter


/datum/GOAP/demoGoap/compare_op(var/curr_val, var/targ_val)
	var/result = FALSE

	if(targ_val >= 0)
		result = curr_val >= targ_val

	else
		// 'negative' cases (req < 0)
		result = (curr_val < -targ_val)

	return result


/datum/GOAP/demoGoap/neighbor_dist(var/curr_pos, var/neighbor_key)
	/* This is a simple heuristic that looks up the neighbor cost from the action triple as-is.
	//
	// o curr_pos - current position, go figure; unused, only here for interface consistency
	// o neighbor_key - string representing the candidate action/position
	// o graph - assoc list representing the action graph; should have the neighbor_key as a key innit.
	*/
	var/cost = PLUS_INF
	var/datum/goai_action/action_data = graph[neighbor_key]
	if (action_data && !(isnull(action_data.cost)))
		cost = action_data.cost

	return cost


/datum/GOAP/demoGoap/goal_dist(var/start, var/end)
	/* This is a heuristic that fuzzes the default uniform value by a random small amount.
	// This is a variant of the default_dist so all the same caveats apply.
	//
	// This stops the search from getting stuck on one action in all iterations in some cases,
	// but at the cost of (1) losing determinism, & (2) sometimes creating sub-optimal paths
	// (in plain terms - overly-long but still *valid* plans).
	//
	// o start - start state (current pos for neighbor measure, neighbor for goal measure)
	// o end - end state (neighbor for neighbor measure, goal for goal measure)
	// o graph - assoc list representing the action graph (not actually used here, just for consistency)
	*/
	var/cost = 1
	cost += ((rand() - 0.5) * 4) // tiebreaker noise
	//cost -= ((roll(1, 4) - 1) / 4) // empirically, more uniform (i.e. less rolls) randomness seems to work better for some reason
	return cost


/datum/GOAP/demoGoap/check_preconds(var/current_pos, var/list/blackboard)
	//DEMOGOAP_DEBUG_LOG("Graph: [json_encode(graph)]")
	DEMOGOAP_DEBUG_LOG("Graph @ Pos: [graph[current_pos]]")

	var/datum/goai_action/actiondata = graph[current_pos]
	var/list/preconds = actiondata.preconditions
	var/match = 1

	for(var/req_key in preconds)
		var/req_val = preconds[req_key]

		var/blackboard_val = blackboard[req_key]
		if(isnull(blackboard_val))
			if(isnull(src.blackboard_defaults)) { src.blackboard_defaults = list() }
			blackboard_val = src.blackboard_defaults[req_key]

		/*             Funky preconditions algebra
		// Because spliting booleans into two states is painful.
		//
		// Normal requirements are fairly straightforward:
		// it is a simple minimum threshold; e.g. REQ=2 means
		// 'REQ must be >= 2', so +5 would be fine, but +1 is not.
		//
		// We interpret a non-positive requirement -REQ for FOO as
		// 'FOO must NOT meet the threshold of REQ if REQ were positive'.
		//
		//   e.g. for a simple boolean:
		// - Foo<Armed = +TRUE> requires the mob to be Armed (TRUE+ == 1+),
		// - Foo<Armed = -TRUE> requires the mob to NOT be Armed (since (+1) >= -(-1) && (-1) <= 0).
		// - Foo<Armed = FALSE> also requires the mob to NOT be Armed (since (+1) >= 0 && 0 <= 0)
		//
		//   or, to illustrate more generically:
		// - Foo<Bullets =  3> requires the mob to have 3+ bullets left
		// - Foo<Bullets =  0> requires the mob to have NO bullets left
		// - Foo<Bullets = -3> requires that the mob does NOT have 3+ bullets available (so 0-2 is fine)
		//
		// Note that this is just preconditions; for the states/needs themselves, negative and positive
		// values are treated the same in the underlying logic, nothing special *there* (e.g. -3 < 2).
		*/

		if (req_val == 0)
			if(isnull(blackboard_val))
				continue

			if(blackboard_val > req_val)
				DEMOGOAP_DEBUG_LOG("[current_pos] failed - [req_key] REQ zero FOUND [blackboard_val]")
				match = 0
				break

		else if (isnull(blackboard_val))
			// consider whether 0 & null should match
			if(req_val > 0)
				DEMOGOAP_DEBUG_LOG("[current_pos] failed - [req_key] REQ [req_val] FOUND null")
				match = 0
				break

		else if (req_val > 0 && blackboard_val < req_val)
			DEMOGOAP_DEBUG_LOG("[current_pos] failed - [req_key] REQ > [req_val] FOUND [blackboard_val]")
			match = 0
			break

		else if (req_val < 0 && blackboard_val >= -req_val)
			DEMOGOAP_DEBUG_LOG("[current_pos] failed - [req_key] REQ < [req_val] FOUND [blackboard_val]")
			match = 0
			break

	return match


/datum/GOAP/demoGoap/get_effects(var/action_key)
	var/datum/goai_action/actiondata = src.graph[action_key]
	var/list/effects = actiondata.effects
	return effects


/datum/GOAP/demoGoap/adjacent(var/current_pos)
	return src.graph
