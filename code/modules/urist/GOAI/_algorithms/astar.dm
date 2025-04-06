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


/*
A Star pathfinding algorithm
Returns a list of tiles forming a path from A to B, taking dense objects as well as walls, and the orientation of
windows along the route into account.
Use:
your_list = AStar(start location, end location, adjacent turf proc, distance proc)
For the adjacent turf proc i wrote:
/turf/proc/AdjacentTurfs
And for the distance one i wrote:
/turf/proc/Distance
So an example use might be:

src.path_list = AStar(src.loc, target.loc, /proc/fAdjacentTurfs, /proc/fDistance)

Note: The path is returned starting at the END node, so i wrote reverselist to reverse it for ease of use.

src.path_list = reverselist(src.pathlist)

Then to start on the path, all you need to do it:
Step_to(src, src.path_list[1])
src.path_list -= src.path_list[1] or equivilent to remove that node from the list.

Optional extras to add on (in order):
MaxNodes: The maximum number of nodes the returned path can be (0 = infinite)
Maxnodedepth: The maximum number of nodes to search (default: 30, 0 = infinite)
Mintargetdist: Minimum distance to the target before path returns, could be used to get
near a target, but not right to it - for an AI mob with a gun, for example.
Minnodedist: Minimum number of nodes to return in the path, could be used to give a path a minimum
length to avoid portals or something i guess?? Not that they're counted right now but w/e.
*/

// Modified to provide ID argument - supplied to 'adjacent' proc, defaults to null
// Used for checking if route exists through a door which can be opened

// Also added 'exclude' turf to avoid travelling over; defaults to null

# ifdef GOAI_LIBRARY_FEATURES

// GOAI library copypasta, will be excluded at compile-time from SS13 code.

PathNode
	var/datum/position
	var/PathNode/previous_node

	var/best_estimated_cost
	var/estimated_cost
	var/known_cost
	var/cost
	var/nodes_traversed

	New(_position, _previous_node, _known_cost, _cost, _nodes_traversed)
		position = _position
		previous_node = _previous_node

		known_cost = _known_cost
		cost = _cost
		estimated_cost = cost + known_cost

		best_estimated_cost = estimated_cost
		nodes_traversed = _nodes_traversed


/proc/PathWeightCompare(PathNode/a, PathNode/b)
	var/a_cost = a?.estimated_cost
	var/b_cost = b?.estimated_cost

	var/a_null = isnull(a_cost)
	var/b_null = isnull(b_cost)

	if(a_null && b_null)
		return 0

	if(b_null)
		if(a_null)
			return 0

		return -a_cost

	if(a_null)
		return b_cost

	return a_cost - b_cost

# endif

/proc/GoaiAStar(var/start, var/end, var/adjacent, var/dist, var/max_nodes, var/max_node_depth = 30, var/min_target_dist = 0, var/min_node_dist, var/list/adj_args = null, var/exclude)
	/* AStar pathfinding algorithm. For SS13 purposes, this is essentially my (scrdest's) fork of the OG SS13 AStar for merge-compatibility.
	// Compability with the legacy SS13 AStar is NOT guaranteed nor is it a goal.
	//
	// - start: Atom; starting point of the search (auto-resolved to a turf)
	// - end: Atom; target of the search (auto-resolved to a turf)
	// - adjacent: PROC! Function-style proc generating turfs adjacent to currently inspected turf.
	// - dist: PROC! Function-style proc returning a distance metric between turfs.
	// - max_nodes: Optional<Int>; If >0, bounds the number of stored search nodes to the given value (Beam Search/SMA* flavor of AStar)
	// - max_node_depth: Optional<Int>; If >0, limits the search depth
	// - min_target_dist: Optional<Int>; Minimum distance value (as returned by the dist proc earlier) that counts as 'goal reached'. Default: 0.
	// - adj_args: Optional<assoc>; Args to pass to the adjacent arg's proc, if any.
	// - exclude: Optional<datum>; Ignored adjacents. Pretty useless tbh. Blame legacy code.
	*/
	var/PriorityQueue/open = new DEFAULT_PRIORITY_QUEUE_IMPL(/proc/PathWeightCompare)
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
