/*

AStar implementation shamelessly stolen from SS13 source.

This has diverged from the original SS13 AStar slightly,
so for time being this is going to be a semi-duplicate.

Not really relevant to the GOAP algorithm, which uses my own custom AStar
implementation; I just needed something better than the DM builtins for the
demo agent pathfinds and couldn't be bothered to reimplement the algorithm
just for *that*.

This implementation is more specialized towards atoms; the GOAP AStar is more
generic, working on datums and whatever else you massage into a tuple.

-- scrdest
*/


proc/GoaiAStar(var/start, var/end, var/proc/adjacent, var/proc/dist, var/max_nodes, var/max_node_depth = 30, var/min_target_dist = 0, var/proc/min_node_dist, var/list/adj_args = null, var/exclude)
	//ADJ ARGS HANDLING TODO
	var/PriorityQueue/open = new /PriorityQueue(/proc/PathWeightCompare)
	var/list/closed = list()
	var/list/path
	var/list/path_node_by_position = list()

	if(!start)
		return 0

	open.Enqueue(new /PathNode(start, null, 0, call(dist)(start, end), 0))

	while(!open.IsEmpty() && !path)
		var/PathNode/current = open.Dequeue()
		closed.Add(current.position)

		if(current.position == end || call(dist)(current.position, end) <= min_target_dist)
			path = new /list(current.nodes_traversed + 1)
			path[path.len] = current.position
			var/index = path.len - 1

			while(current.previous_node)
				current = current.previous_node
				path[index--] = current.position
			break

		if(min_node_dist && max_node_depth)
			if(call(min_node_dist)(current.position, end) + current.nodes_traversed >= max_node_depth)
				continue

		if(max_node_depth)
			if(current.nodes_traversed >= max_node_depth)
				continue

		var/list/true_adj_args = list()
		true_adj_args.Add(current.position)
		if(adj_args)
			true_adj_args += adj_args

		for(var/datum in call(adjacent)(arglist(true_adj_args)))
			if(datum == exclude)
				continue

			var/best_estimated_cost = current.estimated_cost + call(dist)(current.position, datum)

			//handle removal of sub-par positions
			if(datum in path_node_by_position)
				var/PathNode/target = path_node_by_position[datum]
				if(target.best_estimated_cost)
					if(best_estimated_cost + call(dist)(datum, end) < target.best_estimated_cost)
						open.Remove(target)
					else
						continue

			var/PathNode/next_node = new (datum, current, best_estimated_cost, call(dist)(datum, end), current.nodes_traversed + 1)
			path_node_by_position[datum] = next_node
			open.Enqueue(next_node)

			if(max_nodes && open.Length() > max_nodes)
				open.Remove(open.Length())

	return path
