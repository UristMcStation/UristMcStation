/*
// This is a Brain-specific AStar implementation.
// Think of it as a fork of the one in algorithms.dm.
//
// Why? We need to reference the owner in distance procs for more fine-grained control over pathfinding.
*/

/datum/utility_ai
	var/intrisic_distance_cost_proc = null

# define INTRISIC_COST_QUERY(start, end) (isnull(src.intrisic_distance_cost_proc) ? 0 : call(src, src.intrisic_distance_cost_proc)(start, end))


/datum/utility_ai/proc/AiAStar(var/start, var/end, var/proc/adjacent, var/proc/dist, var/max_nodes, var/max_node_depth = 30, var/min_target_dist = 0, var/proc/min_node_dist, var/list/adj_args = null, var/exclude)
	var/PriorityQueue/open = new /PriorityQueue(/proc/PathWeightCompare)
	var/list/closed = list()
	var/list/path
	var/list/path_node_by_position = list()

	if(!start)
		return 0

	var/initial_dist = call(dist)(start, end)
	initial_dist += INTRISIC_COST_QUERY(start, end)

	open.Enqueue(new /PathNode(start, null, 0, initial_dist, 0))

	while(!open.IsEmpty() && !path)
		var/PathNode/current = open.Dequeue()
		closed.Add(current.position)

		var/current_to_end_dist = call(dist)(current.position, end)
		current_to_end_dist += INTRISIC_COST_QUERY(current.position, end)

		if(current.position == end || current_to_end_dist <= min_target_dist)
			path = new /list(current.nodes_traversed + 1)
			path[path.len] = current.position
			var/index = path.len - 1

			while(current.previous_node)
				current = current.previous_node
				path[index--] = current.position
			break

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
			if(neighb == exclude)
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

			if(max_nodes && open.Length() > max_nodes)
				open.Remove(open.Length())

	return path
