/*
// This is a Brain-specific AStar implementation.
// Think of it as a fork of the one in algorithms.dm.
//
// Why? We need to reference the owner in distance procs for more fine-grained control over pathfinding.
*/

/datum/utility_ai
	var/intrisic_distance_cost_proc = null

# define INTRISIC_COST_QUERY(start, end) (isnull(src.intrisic_distance_cost_proc) ? 0 : call(src, src.intrisic_distance_cost_proc)(start, end))



/datum/utility_ai/proc/AiAStar(var/start, var/end, var/adjacent, var/dist, var/max_nodes, var/max_node_depth = 0, var/min_target_dist = 0, var/min_node_dist, var/list/adj_args = null, var/list/exclude = null)
	/* AStar pathfinding algorithm.
	// For SS13 purposes, this is essentially my (scrdest's) fork of the OG SS13 AStar for merge-compatibility WITH OOP STUFF ON TOP.
	// This is meant to provide access to instance vars and, if you must, override stuff in subclasses (ugh)
	//
	// - start: Atom; starting point of the search (auto-resolved to a turf)
	// - end: Atom; target of the search (auto-resolved to a turf)
	// - adjacent: PROC! Function-style proc generating turfs adjacent to currently inspected turf.
	// - dist: PROC! Function-style proc returning a distance metric between turfs.
	// - max_nodes: Optional[Int]; If >0, bounds the number of stored search nodes to the given value (Beam Search/SMA* flavor of AStar)
	// - max_node_depth: Optional[Int]; If >0, limits the search depth
	// - min_target_dist: Optional[Int]; Minimum distance value (as returned by the dist proc earlier) that counts as 'goal reached'. Default: 0.
	// - adj_args: Optional[assoc]; Args to pass to the adjacent arg's proc, if any.
	// - exclude: Optional[datum]; Ignored adjacents. Pretty useless tbh. Blame legacy code.
	*/
	var/PriorityQueue/open = new DEFAULT_PRIORITY_QUEUE_IMPL(/proc/PathWeightCompare)
	var/list/closed = list()
	var/list/path
	var/list/path_node_by_position = list()

	if(!start)
		return

	var/initial_dist = call(dist)(start, end)
	initial_dist += INTRISIC_COST_QUERY(start, end)

	if(!isnull(min_target_dist) && (initial_dist <= min_target_dist))
		// We are within min-dist - we're happy enough where we started.
		// It is literally impossible to get a lower-cost path if no edges are negative.
		return list()

	open.Enqueue(new /PathNode(start, null, 0, initial_dist, 0))

	while(!open.IsEmpty())

		if(path)
			return path

		var/PathNode/current = open.Dequeue()
		closed.Add(current.position)

		var/current_to_end_dist = call(dist)(current.position, end)
		current_to_end_dist += INTRISIC_COST_QUERY(current.position, end)

		if(current.position == end || (current_to_end_dist <= min_target_dist))
			path = new /list(current.nodes_traversed + 1)
			path[path.len] = current.position
			var/index = path.len - 1

			while(current.previous_node)
				current = current.previous_node
				path[index--] = current.position

			return path

		if(min_node_dist && max_node_depth)
			var/current_to_end_min_dist = call(min_node_dist)(current.position, end)
			//current_to_end_min_dist += INTRISIC_COST_QUERY(current.position, end)

			if(current_to_end_min_dist + current.nodes_traversed >= max_node_depth)
				continue

		if(max_node_depth)
			if(current.nodes_traversed >= max_node_depth)
				continue

		var/list/true_adj_args = list()
		true_adj_args.Add(current.position)
		if(adj_args)
			true_adj_args += adj_args

		for(var/neighb in call(adjacent)(arglist(true_adj_args)))
			if(!isnull(exclude) && (neighb in exclude))
				continue

			var/new_dist_cost = call(dist)(current.position, neighb)
			var/best_estimated_cost = current.estimated_cost + new_dist_cost

			var/next_dist = call(dist)(neighb, end)
			next_dist += INTRISIC_COST_QUERY(neighb, end)

			//handle removal of sub-par positions
			if(neighb in path_node_by_position)
				var/PathNode/target = path_node_by_position[neighb]
				if(target.best_estimated_cost)
					if(best_estimated_cost + next_dist < target.best_estimated_cost)
						open.Remove(target)
					else
						continue

			var/PathNode/next_node = new (neighb, current, best_estimated_cost, next_dist, current.nodes_traversed + 1)
			path_node_by_position[neighb] = next_node
			open.Enqueue(next_node)

			while(max_nodes && open.Length() > max_nodes)
				open.Remove(open.Length())

	return
