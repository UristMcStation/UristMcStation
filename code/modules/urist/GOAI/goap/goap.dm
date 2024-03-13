/*
X================================================================X
|                                                                |
|                  GOAL-ORIENTED ACTION PLANNING                 |
|                                                                |
X================================================================X

  This is an implementation of the GOAP AI algorithm for DM.

  GOAP is a search-based planning algorithm that promises AIs
  that are smart, organic, modular, easily extensible (i.e.
  adding new behaviors is a breeze) and still fairly 'cheap'.

  TL;DR, we know how to pathfind gud and fast since the 60s;
  if you zoom your brain out, planning a path is just a sequence
  of steps - and so is planning *actions*. So, we can yoink some
  good pathfinding algorithms (A*) and use them for AI planning.

  This *works*, and there's a good chance you played something
  that uses this AI architecture, especially around 2010 - notably,
  F.E.A.R., TES: IV & V (although Radiant AI is a fairly cut-down
  version) or Deus Ex: Human Revolution, just to name the AAA titles.

  This is a fairly ambitious implementation; unlike classic GOAP
  as originally described by Jeff Orkin, we're (ab-)using assoc
  lists and proc dynamic dispatch to be much more flexible.

  =*=   FLEXIBILITY   =*=

  Notably, by default our states can be described not just as
  booleans (True/False), but as numeric values (or even strings or
  lists, if your custom logic can handle that).

  This means that we can create plans that track resource (e.g. money,
  energy, health) usage  smartly without creating a billion boolean
  flags for each variant and to account for their depletion when
  scoring each plan.

  This also allows for goals that are more elaborate; e.g. 'be at
  position (15, 30) while having at least 20$ and full health'.

  That said, use this sparingly - the more complex the goal, the
  more expensive the plan will be to compute.

  =*=    EFFICIENCY    =*=

  This brings us to another trick: this implementation has been
  designed to be portable and easily paused/resumed/stopped and
  support hard limits on resource consumption.

  Thanks to DM's sleep(), this algorithm runs fairly seamlessly
  in the background even for heavy jobs.

  We don't want to choke the server with unsatisfiable jobs though;
  you can set a hard limit on the number of iterations before the
  planner gives up - in that case, we simply get a null back.

  You can also limit the max queue size, to prevent bigger jobs
  from eating up all the RAM. This may even speed up the search
  sometimes!

  =*=      SETUP      =*=

  An unfortunate side-effect of trying to support ALL use-cases
  is that it's hard to support any specific one out of the box.

  GOAI takes in a *lot* of parameters, and you will likely need
  to define a bunch of procs to tailor it to your use-cases.

  Worse yet, as DM doesn't, to my knowledge, support closures,
  it's hard to provide generic procs that would work on simple
  customized variants of my preferred graph structure.

  At minimum, you will need to define:
  (1) at least one Action Graph
  (2) a proc to fetch Preconditions for each Action in the Graph as an assoc list
  (3) a proc to fetch Effects for each Action in the Graph as an assoc list
  (4) a proc that compares two assoc lists, Current & Preconds and returns 1 if the Current state meets the requirements of the Action, 0 otherwise.
  (5) a proc that compares two assoc lists, Current & Goal and returns 1 if the Current state meets the requirements of the Goal, 0 otherwise.

  You can see a sample setup in the goap_testing.dm file.
*/


/proc/AddItem(var/oldval, var/newval)
	/* Returns a sum of old and new values.
	//
	// We only use this to avoid using builtins
	// (which don't always work with call(proc)).
	// This is the default merge strategy for GOAI.
	*/
	if(isnull(newval) || newval == 0)
		return oldval

	var/total = oldval + newval
	return total


/proc/UseNew(var/oldval, var/newval)
	/* Always returns the new value, if not-null.
	//
	// This can be used as an alternative merge
	// strategy for GOAI, to implement e.g.:
	//
	// - classic Astar pathfinding w/ absolute positions
	//   as the Action effects (as opposed to deltas - in
	//   that case, AddItem() would still be enough)
	//
	// - for boolean effects (for something closer to original
	//   GOAP, as default GOAI is really a STRIPS planner instead).
	*/
	if(isnull(newval))
		return oldval

	var/retval = newval
	return retval


/proc/update_counts(var/list/old_state, var/list/new_state, var/default = 0, var/proc/op = null)
	/* Merges counts in two assoc lists. Returns the result as a new assoc list.
	//
	// o old_state - start state
	// o new_state - new state (neighbor for neighbor measure, goal for goal measure)
	// o default - default value to read from old_state if the key is missing there.
	// o op - Optional, proc to use to update values.
	//        Takes 2 args: (new, old).
	//        Default: op(A, B) -> A + B
	//        A custom op can be used e.g. to implement normal pathfinding (with op(A, B) -> B).
	*/
	var/proc/update_op = isnull(op) ? /proc/AddItem : op
	var/list/result_state = old_state.Copy()

	for (var/key in new_state)
		if (key == GOAP_KEY_SRC)
			continue

		var/old_val = (key in result_state) ? result_state[key] : default
		var/add_val = new_state[key]
		var/result = call(update_op)(old_val, add_val)

		result_state[key] = result

	return result_state


/proc/default_dist(var/start, var/end, var/list/graph)
	/* This is the most basic heuristic - uniform cost.
	//
	// If used for just the neighbor measure, the Astar search
	//    degenerates to a greedy breadth-first search.
	//
	// If used for just the goal measure, the search degenerates
	//    to a simple Dijkstra's algorithm search (fine,
	//    but slower than a well-guided search)
	//
	// If used for both, this degenerates to a random-ish
	//    (depending on the queue implementation) breadth-first search!
	//    This will be REALLY slow, so it's NOT recommended.
	//
	// o start - start state (current pos for neighbor measure, neighbor for goal measure)
	// o end - end state (neighbor for neighbor measure, goal for goal measure)
	// o graph - assoc list representing the action graph (not actually used here, just for consistency)
	*/
	var/cost = 1
	return cost


/proc/tiebreaker_dist(var/start, var/end, var/list/graph)
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
	var/cost = 0
	cost -= ((roll(1, 4) - 1) / 4) // empirically, more uniform (i.e. less rolls) randomness seems to work better for some reason
	return cost


/proc/graph_neighbor_cost(var/curr_pos, var/neighbor_key, var/list/graph)
	/* This is a simple heuristic that looks up the neighbor cost from the action triple as-is.
	//
	// o curr_pos - current position, go figure; unused, only here for interface consistency
	// o neighbor_key - string representing the candidate action/position
	// o graph - assoc list representing the action graph; should have the neighbor_key as a key innit.
	*/
	var/cost = PLUS_INF
	var/datum/Triple/action_data = (neighbor_key in graph) ? graph[neighbor_key] : null
	if (action_data && action_data.left)
		cost = action_data.left

	return cost


/proc/evaluate_neighbor(var/list/graph, var/proc/check_preconds, var/neigh, var/current_pos, var/goal, var/list/blackboard = null, var/blackboard_default = 0, var/proc/blackboard_update_op = null, var/proc/neighbor_measure = null, var/proc/goal_measure = null, var/proc/get_effects)
	/* Evaluates a single Candidate action based on the current state.
	//
	// This involves three essential steps:
	// - Check preconditions: the action cannot be taken if its requirements are not met
	//
	// - Check effects: obviously, we only care about actions that help us get closer to the goal
	//
	// - Scoring: we need to (de-)prioritize expanding plans using this Candidate based on how good it is.
	//   This breaks down further into two scores that are then added together:
	//
	//   - (1) Neighbor Measure - the raw cost of taking the Candidate action in the current state
	//         In pathfinding terms, the 'distance' from current position to the next position.
	//
	//   - (2) Goal Measure - a rough estimate of how much closer taking the Candidate gets us to the
	//         search goal; the *LOWER* the better (since the action gets us *closer* to the goal).
	//
	// o graph - assoc list representing the Action graph
	// o check_preconds - proc that returns 1 if the start state meets preconditions for an available action
	// o neigh - key in the Graph assoc list representing the Candidate action.
	// o current_pos - current position in the plan, i.e. the 'start' var in the SearchIteration() call.
	// o goal  - assoc list of the goal state we're trying to reach (or exceed, depending on cmp)
	// o blackboard_default - optional; the default value to use for unset keys in the blackboard (only when necessary, e.g. comparing values). Default: 0.
	// o blackboard_update_op - optional proc; the function used to update the blackboard values to new states. Default: (A, B) => A + B.
	// o neighbor_measure - optional proc; abstract distance (Start => Candidate) heuristic. DEFAULT: taken from the Action triple
	// o goal_measure - optional proc; abstract distance (Candidate => Goal) heuristic; DEFAULT: fuzzed uniform cost
	// o get_effects - proc; should return an assoc list representing expected world state after the Action is executed.
	//
	*/
	var/proc/actual_neigh_measure = neighbor_measure ? neighbor_measure : /proc/graph_neighbor_cost
	var/proc/actual_goal_measure = goal_measure ? goal_measure : /proc/tiebreaker_dist
	var/list/actual_blackboard = blackboard ? blackboard : list()

	var/is_valid = call(check_preconds)(neigh, actual_blackboard)

	var/effects = actual_blackboard.Copy()
	var/list/curr_source = (GOAP_KEY_SRC in effects) ? effects[GOAP_KEY_SRC].Copy() : list()
	curr_source.Add(current_pos)

	effects[GOAP_KEY_SRC] = curr_source

	var/datum/Tuple/result = null
	if (!is_valid)
		result = new /datum/Tuple(PLUS_INF, effects)
		return result

	if (get_effects)
		var/list/new_effects = call(get_effects)(neigh)
		effects = update_counts(effects, new_effects, blackboard_default, blackboard_update_op)

	var/neigh_distance = call(actual_neigh_measure)(current_pos, neigh, graph)
	var/goal_distance = call(actual_goal_measure)(neigh, goal)

	var/heuristic = neigh_distance + goal_distance

	result = new /datum/Tuple(heuristic, effects)
	return result


/proc/rebuild_effects(var/list/graph, var/list/action_plan, var/proc/get_effects, var/blackboard_default = 0, var/proc/blackboard_update_op = null)
	/* Rebuilds the world-state after the given plan is applied.
	//
	// We need this proc so that we can check action preconds without carrying the blackboards on the stack
	// the whole time; most queued actions will never actually get evaluated, so it would chew up the RAM
	// for no discernible benefit. Of course, this does mean we chew up some CPU instead rebuilding these.
	//
	// o graph - assoc list representing the Action graph
	// o action_plan - plain old list of Actions in the current plan (in FIFO order from left to right)
	// o get_effects - *required* proc; should return an assoc list representing expected world state after the Action is executed.
	// o blackboard_default - optional; the default value to use for unset keys in the blackboard (only when necessary, e.g. comparing values). Default: 0.
	// o blackboard_update_op - optional proc; the function used to update the blackboard values to new states. Default: (A, B) => A + B.
	//
	*/
	var/list/rebuilt_blackboard = list()

	for (var/action in action_plan)
		//MAYBE_LOG("REBUILD ACT [action]")
		var/list/act_effects = list()

		if (islist(action))
			var/list/state = action
			var/is_state = 0

			for (var/stitm in state)
				MAYBE_LOG("STITM [stitm]")

				if (stitm in graph)
					var/list/statitm_fx = call(get_effects)(stitm)
					act_effects = update_counts(act_effects, statitm_fx, blackboard_default, blackboard_update_op)

				else
					is_state = 1

			if (is_state)
				act_effects = update_counts(act_effects, state, blackboard_default, blackboard_update_op)

		else
			act_effects = call(get_effects)(action)

		rebuilt_blackboard = update_counts(rebuilt_blackboard, act_effects, blackboard_default, blackboard_update_op)

	return rebuilt_blackboard



/proc/SearchIteration(var/list/graph, var/list/start, var/list/goal, var/proc/adjacent, var/proc/check_preconds, var/paths = null, var/PriorityQueue/queue = null, var/visited = null, var/proc/neighbor_measure, var/proc/goal_measure, var/proc/goal_check, var/proc/get_effects, var/cutoff_iter = null, var/max_queue_size = null, var/proc/pqueue_key_gen = null, var/list/blackboard = null, var/blackboard_default = 0, var/proc/blackboard_update_op = null, var/curr_cost = 0, var/curr_iter = 0)
	/* The main 'worker' logic of the search.
	//
	// Takes in a graph, the starting position/state, the target position/state and a pile of configuration options/procs,
	// then evaluates all possible Candidates (followup actions available for the current state), simulating their results,
	// and returns the best Candidate to look at in the next SearchIteration call.
	// That is, unless our current start state already DOES satisfy the goals - in that case, we simply return the path to the goal.
	//
	// Where's the search then? It's done via the first branch (i.e. goal not found).
	// While evaluating the Candidates we're doing some magic to the Queue and Paths lists
	// and forwarding them to the next SearchIteration call.
	//
	// This code implements a 'trampoline' pattern; in other words, it's pseudo-recursive. What would
	// normally be a recursive call to SearchIteration is moved to another associated function (here, it's
	// the 'Plan' proc) which pipes the outputs of one SearchIteration calls to the inputs of the next one.
	//
	// The cool thing about this is that this lets us pause the search between any two iterations safely.
	// We could even serialize the output of one call to JSON or whatever, then deserialize it a day later,
	// on a completely different computer and it would pick up right where it left off!
	//
	// It's not entirely *stateless*, but all state we need is explicitly passed around in parameters.
	// In particular, if anything weird ever happens in this code, if we capture the inputs of the problematic
	// runs, we can replay them in tests and in principle fully recreate the scenario where it misbehaved
	// to debug it (CAVEAT: unless your custom procs have their own weird stateful behavior, but that's on you!).
	//
	// o graph - assoc list representing the action graph
	// o start - assoc list of the currently-evaluated start state
	// o goal  - assoc list of the goal state we're trying to reach (or exceed, depending on cmp)
	// o adjacent - proc that generates Candidate actions available to us in the current Start state
	// o check_preconds - proc that returns 1 if the start state meets preconditions for an available action (returned from the 'adjacent' proc)
	// o paths - optional; assoc list of best neighbors for each action seen so far. Will default to a new list.
	// o queue - optional; PriorityQueue instance from previous iteration(s). Will default to a new instance.
	// o visited - optional; assoc list of visited nodes. If null, *WILL NOT SKIP VISITED NODES*!
	// o neighbor_measure - optional proc; abstract distance (Start => Candidate) heuristic
	// o goal_measure - optional proc; abstract distance (Candidate => Goal) heuristic
	// o goal_check - *required* proc; should return 1 when goal criteria are satisfied, 0 otherwise.
	// o get_effects - *required* proc; should return an assoc list representing expected world state after the Action is executed.
	// o cutoff_iter - optional; maximum iteration allowed for the search. If exceeded, search terminates w/o finding a valid path. If null - unlimited.
	// o max_queue_size - optional; maximum space allocated for the Priority Queue. Unlimited if null, otherwise trims the worst candidates from the list tail.
	// o pqueue_key_gen - optional proc; a hook to allow custom queue sort keys. Default - simply uses the iteration as the primary sort key.
	// o blackboard - optional assoc list; represents the total expected state of the world before the Start action/state is applied. Default - empty list.
	// o blackboard_default - optional; the default value to use for unset keys in the blackboard (only when necessary, e.g. comparing values). Default: 0.
	// o blackboard_update_op - optional proc; the function used to update the blackboard values to new states. Default: (A, B) => A + B.
	// o curr_cost - *PRIVATE* optional; the total cost of getting from search root to current start pos. You shouldn't need to mess with it.
	// o curr_iter - *PRIVATE* optional; the search iteration index. You shouldn't need to mess with it.
	//
	// Returns: 2-tuple, (continue_search, next_iteration_params (usually) | best_path (if found))
	//
	*/
	MAYBE_LOG("    ")
	MAYBE_LOG("CURR ITER: [curr_iter]")
	MAYBE_LOG("CURR POS: [start]")

	var/list/_paths = isnull(paths) ? list() : paths
	var/PriorityQueue/_pqueue = isnull(queue) ? new /PriorityQueue(/datum/Quadruple/proc/ActionCompare) : queue

	# ifdef DEBUG_LOGGING
	MAYBE_LOG("START BB is [blackboard]")
	for (var/bbitem in blackboard)
		MAYBE_LOG("START BB ITEM: [bbitem] @ [blackboard[bbitem]]")
	# endif

	var/list/_blackboard = isnull(blackboard) ? list() : blackboard.Copy()

	var/list/updated_state = update_counts(_blackboard, start, blackboard_default, blackboard_update_op)

	var/goal_check_result = call(goal_check)(updated_state, goal, null)
	if (goal_check_result > 0)
		MAYBE_LOG("GOAL CHECK SUCCEEDED.")

		var/raw_final_result = updated_state[GOAP_KEY_SRC]
		var/list/full_final_result = islist(start) ? list(raw_final_result, start) : raw_final_result + list(start)
		var/datum/Tuple/final_result = new /datum/Tuple(0, full_final_result)

		return final_result

	var/proc/neighbor_measurer = (neighbor_measure ? neighbor_measure : /proc/graph_neighbor_cost)
	var/proc/goal_measurer = (goal_measure ? goal_measure : /proc/tiebreaker_dist)

	if (visited)
		var/curr_visit_count = visited[start] ? visited[start] : 0
		visited[start] = curr_visit_count + 1

	var/list/neighbors = call(adjacent)(start)

	for (var/neigh in neighbors)
		if (visited && visited[neigh])
			continue

		var/datum/Tuple/evaluation = evaluate_neighbor(graph, check_preconds, neigh, start, goal, updated_state, blackboard_default, blackboard_update_op, neighbor_measurer, goal_measurer, get_effects)
		var/heuristic = evaluation.left
		var/effects = evaluation.right
		var/source = (GOAP_KEY_SRC in effects) ? effects[GOAP_KEY_SRC] : null

		var/datum/Triple/stored_data = _paths[neigh] ? _paths[neigh] : new /datum/Triple(PLUS_INF, null, null)
		var/stored_neigh_cost = stored_data.left

		var/total_cost = curr_cost + heuristic

		if (total_cost < stored_neigh_cost)
			_paths[neigh] = new /datum/Triple(total_cost, start, source)

		var/priority_key = (pqueue_key_gen ? call(pqueue_key_gen)(curr_iter, curr_cost, heuristic) : curr_iter)

		var/datum/Quadruple/cand_tuple = new /datum/Quadruple (priority_key, total_cost, neigh, source)

		if (total_cost < PLUS_INF && (!(cand_tuple in _pqueue)))
			_pqueue.Enqueue(cand_tuple)

			if (!isnull(max_queue_size))
				_pqueue.L.Cut(1, max_queue_size)

	if (_pqueue.L.len <= 0)
		to_world_log("Exhausted all candidates before a path was found!")
		return

	var/datum/Quadruple/next_cand_tuple = _pqueue.Dequeue()
	var/cand_cost = next_cand_tuple.second
	var/cand_pos = next_cand_tuple.third
	var/list/source_pos = next_cand_tuple.fourth

	MAYBE_LOG("CAND: [next_cand_tuple.third]")
	MAYBE_LOG("CAND SRCp: [source_pos]")

	# ifdef DEBUG_LOGGING
	/*for (var/srcpit in source_pos)
		MAYBE_LOG("SRCp item: [srcpit]")*/
	# endif

	var/list/action_stack = list(source_pos ? source_pos.Copy() : list())
	action_stack.Add(cand_pos)

	# ifdef DEBUG_LOGGING
	/*for (var/actpit in source_pos)
		MAYBE_LOG("ACTp item: [actpit]")*/
	# endif

	var/cand_blackboard = rebuild_effects(graph, action_stack, get_effects, blackboard_default, blackboard_update_op)
	cand_blackboard[GOAP_KEY_SRC] = source_pos

	# ifdef DEBUG_LOGGING
	for (var/blit in cand_blackboard)
		MAYBE_LOG("BLIT: [blit] = [cand_blackboard[blit]]")
	# endif

	var/list/new_params = list()

	new_params["graph"] = graph
	new_params["start"] = cand_pos
	new_params["goal"] = goal
	new_params["adjacent"] = adjacent
	new_params["check_preconds"] = check_preconds
	new_params["paths"] = paths
	new_params["visited"] = visited
	new_params["neighbor_measure"] = neighbor_measure
	new_params["goal_measure"] = goal_measure
	new_params["goal_check"] = goal_check
	new_params["get_effects"] = get_effects
	new_params["cutoff_iter"] = cutoff_iter
	new_params["max_queue_size"] = max_queue_size
	new_params["pqueue_key_gen"] = pqueue_key_gen
	new_params["blackboard"] = cand_blackboard
	new_params["blackboard_default"] = blackboard_default
	new_params["blackboard_update_op"] = blackboard_update_op
	new_params["curr_cost"] = cand_cost
	new_params["curr_iter"] = curr_iter + 1

	var/datum/Tuple/result = new /datum/Tuple (1, new_params)

	# ifdef DEBUG_LOGGING
	var/list/pathli = result.right
	MAYBE_LOG("Result tuple: ([result.left], [pathli] ([pathli.len]))")
	# endif

	return result


/proc/Plan(var/list/graph, var/list/start, var/list/goal, var/proc/adjacent, var/proc/check_preconds, var/proc/handle_backtrack = null, var/handle_backtrack_target = null, var/paths = null, var/visited = null, var/proc/neighbor_measure, var/proc/goal_measure, var/proc/goal_check, var/proc/get_effects, var/cutoff_iter, var/max_queue_size = null, var/proc/pqueue_key_gen, var/blackboard_default = 0, var/proc/blackboard_update_op = null)
	/* Main planning proc. Runs the full Astar search over a graph of Actions until either a path
	// satisfying the Goal criteria is found or the iteration cutoff has been exceeded (if set).
	//
	// Technically speaking, this proc doesn't *do* much. It's primarily a trampoline for one or more
	// SearchIteration() proc calls that handle the bulk of the work; this proc just manages their work
	// by forwarding parameters between iterations, deciding when to give up the search, and handling
	// the wrap-up of a successful pathfind.
	//
	// Somewhat surprisingly, this is a shockingly fast search (at least on relatively small action spaces)!
	// For larger spaces, you might want to break things down hierarchically - run one planner for the
	// 'strategy' level and then another for the 'tactical' level, whose action-space is constrained to
	// the RoE of the strategy - this way, two searches look at small spaces, rather than having one search
	// over a huge space.
	//
	// o graph - assoc list representing the Action graph
	// o start - assoc list of the currently-evaluated Start state
	// o goal  - assoc list of the Goal state we're trying to reach (or exceed, depending on cmp)
	// o adjacent - proc that generates Candidate actions available to us in the current Start state
	// o check_preconds - proc that returns 1 if the start state meets preconditions for an available action (returned from the 'adjacent' proc)
	// o handle_backtrack - optional proc; arbitrary callback to execute for each Action in the path during backtracking after a plan is found.
	// o handle_backtrack_target - optional object; the object to run the handle_backtrack proc on, e.g. a list to run list.Add() on.
	// o paths - optional; assoc list of best neighbors for each action seen so far. Will default to a new list.
	// o visited - optional; assoc list of visited nodes. If null, *WILL NOT SKIP VISITED NODES*!
	// o neighbor_measure - optional proc; abstract distance (Start => Candidate) heuristic
	// o goal_measure - optional proc; abstract distance (Candidate => Goal) heuristic
	// o goal_check - *required* proc; should return 1 when goal criteria are satisfied, 0 otherwise.
	// o get_effects - *required* proc; should return an assoc list representing expected world state after the Action is executed.
	// o cutoff_iter - optional; maximum iteration allowed for the search. If exceeded, search terminates w/o finding a valid path. If null - unlimited.
	// o max_queue_size - optional; maximum space allocated for the Priority Queue. Unlimited if null, otherwise trims the worst candidates from the list tail.
	// o pqueue_key_gen - optional proc; a hook to allow custom queue sort keys. Default - simply uses the iteration as the primary sort key.
	// o blackboard_default - optional; the default value to use for unset keys in the blackboard (only when necessary, e.g. comparing values). Default: 0.
	// o blackboard_update_op - optional proc; the function used to update the blackboard values to new states. Default: (A, B) => A + B.
	//
	// Returns: 2-tuple, (continue_search, best_path (if found)) if a path is found; null otherwise.
	*/
	var/curr_iter = 0
	var/continue_search = 1

	var/list/true_paths = isnull(paths) ? list() : paths
	var/list/next_params = list()
	var/datum/Tuple/result = null
	var/PriorityQueue/queue = new /PriorityQueue (/datum/Quadruple/proc/ActionCompare)

	next_params["graph"] = graph
	next_params["start"] = start
	next_params["goal"] = goal
	next_params["queue"] = queue
	next_params["adjacent"] = adjacent
	next_params["check_preconds"] = check_preconds
	next_params["paths"] = true_paths
	next_params["visited"] = visited
	next_params["neighbor_measure"] = neighbor_measure
	next_params["goal_measure"] = goal_measure
	next_params["goal_check"] = goal_check
	next_params["get_effects"] = get_effects
	next_params["cutoff_iter"] = cutoff_iter
	next_params["max_queue_size"] = max_queue_size
	next_params["pqueue_key_gen"] = pqueue_key_gen
	next_params["blackboard_default"] = blackboard_default
	next_params["blackboard_update_op"] = blackboard_update_op

	while(next_params && continue_search):
		sleep(-1) // this is a safe time to pause things and catch up with reality

		result = SearchIteration(arglist(next_params))
		continue_search = result ? result.left : 0
		var/list/new_params = result.right

		next_params = new_params

		if (continue_search > 0)

			if (!isnull(cutoff_iter)) // 0 is *technically* valid, so let's use ifnull...
				curr_iter = curr_iter + 1
				if (curr_iter >= cutoff_iter):
					MAYBE_LOG("Path not found within [cutoff_iter] iterations!")
					return


	MAYBE_LOG("Broken out of the Plan loop!")
	var/datum/Triple/best_opt = result ? result.right : null
	var/best_path = best_opt

	if (handle_backtrack):
		for (var/parent_elem in best_path)
			if (isnull(handle_backtrack_target))
				call(handle_backtrack)(parent_elem)
			else
				call(handle_backtrack_target, handle_backtrack)(parent_elem)

	return result

