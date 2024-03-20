/*
// Bounding boxes
//
// These naturally tend to 'wrap' other contexts, and we cannot really use them on Consideration level.
// Therefore, these will (generally) be decorator CFs, CFs wrapping other CFs and their args.
// This will be indicated by a 'ctxdeco_' prefix rather than the usual 'ctxtecher_'
//
// This means you MUST pass a wrapped proc - otherwise there's nothing to provide the base data.
*/

CTXFETCHER_CALL_SIGNATURE(/proc/ctxdeco_bounding_box_turfs_around_objects)
	/*
	// Returns a context for each turf within an axis-aligned bounding box (bbox)
	// defined by items from the underlying proc's contexts.
	//
	// Useful for any 'crowd' logic, e.g. maximizing splash damage or sticking to friends,
	// or as something similar to /area but dynamic - a blob of space for AI to Do Stuff In.
	//
	// Be mindful of the risk of creating YUGE zones if the inputs are dispersed.
	// To guard against that, you can pass in "max_<x/y/z/area/volume>" limiters (in any combination).
	// If the bbox exceeds any of that limits, this proc will return an empty context instead.
	// NOTE: max_volume automagically defaults to 200 to keep things sane; you CAN increase it if you override it explicitly.
	*/
	if(isnull(context_args))
		// no wrapped proc - cannot work
		return

	var/wrapped_proc_raw = context_args["wrapped_proc"]
	if(isnull(wrapped_proc_raw))
		// no wrapped proc - cannot work
		to_world("/proc/ctxdeco_bounding_box_turfs - NO PROC")
		return

	var/wrapped_proc = STR_TO_PROC(wrapped_proc_raw)
	if(isnull(wrapped_proc))
		// no wrapped proc - cannot work
		to_world("/proc/ctxdeco_bounding_box_turfs - NO PROC")
		return

	var/list/wrapped_proc_args = context_args["wrapped_proc_args"] || list()

	var/list/wrapper_contexts = call(wrapped_proc)(parent, requester, wrapped_proc_args)
	if(!istype(wrapper_contexts))
		to_world("/proc/ctxdeco_bounding_box_turfs - NO CONTEXTS")
		return

	// where the wrapped proc dumps the thing we want to bbox around
	var/unwrap_target_key = context_args["unwrap_target_key"] || "output"

	// where (key-wise) the wrapper will output the bbox turfs
	var/output_key = context_args["output_context_key"] || "output"

	// additional space to add around each side
	// helps get more sensible results with heavily clustered targets
	var/padding = context_args["padding"] || 0

	// for convenience/optimization's sake, we don't include dense turfs in the output by default
	// if for whatever reason you do want walls, set allow_dense = 1 in the JSON.
	var/allow_dense = context_args["allow_dense"] || 0

	// limiters - if any is specified and exceeded, returns nothing
	// this is a safeguard against accidental ginormous queries if
	// the underlying proc's outputs are heavily spatially dispersed
	var/max_x_span = context_args["max_x_span"]
	var/max_y_span = context_args["max_y_span"]
	var/max_z_span = context_args["max_z_span"]
	var/max_area = context_args["max_area"]  // 2d area, to be clear
	var/max_volume = context_args["max_volume"] || 400

	var/minx = null
	var/maxx = null

	var/miny = null
	var/maxy = null

	var/minz = null
	var/maxz = null

	// Unpack the subresult and calculate the axis-aligned bbox
	for(var/list/input_context in wrapper_contexts)
		var/atom/unwrapped_input = input_context[unwrap_target_key]

		if(!istype(unwrapped_input))
			to_world("/proc/ctxdeco_bounding_box_turfs - bad input [unwrapped_input] for [unwrap_target_key]")
			continue

		if(isnull(minx) || unwrapped_input.x < minx)
			minx = unwrapped_input.x

		if(isnull(miny) || unwrapped_input.y < miny)
			miny = unwrapped_input.y

		if(isnull(minz) || unwrapped_input.z < minz)
			minz = unwrapped_input.z

		if(isnull(maxx) || unwrapped_input.x > maxx)
			maxx = unwrapped_input.x

		if(isnull(maxy) || unwrapped_input.y > maxy)
			maxy = unwrapped_input.y

		if(isnull(maxz) || unwrapped_input.z > maxz)
			maxz = unwrapped_input.z

	// Padding
	minx = max(1, (minx - padding))
	miny = max(1, (miny - padding))
	maxx = min(world.maxx, (maxx + padding))
	maxy = min(world.maxy, (maxy + padding))

	var/list/contexts = list()

	// Apply limiters
	var/xspan = (maxx - minx)
	if(!isnull(max_x_span) && xspan > max_x_span)
		return contexts

	var/yspan = (maxy - miny)
	if(!isnull(max_y_span) && yspan > max_y_span)
		return contexts

	var/zspan = (maxz - minz)
	if(!isnull(max_z_span) && zspan > max_z_span)
		return contexts

	var/area = (xspan * yspan)
	if(!isnull(max_area) && area > max_area)
		return contexts

	var/volume = area * zspan
	if(!isnull(max_volume) && volume > max_volume)
		return contexts

	// Not too big, check the block!
	var/turf/minturf = locate(minx, miny, minz)
	if(isnull(minturf))
		return contexts

	var/turf/maxturf = locate(maxx, maxy, maxz)
	if(isnull(maxturf))
		return contexts

	var/list/raw_block = block(minturf, maxturf)

	var/batchIdx = 0
	var/batchsize = context_args["batchsize"] || 50

	// Phew, time to package it up into contexts!
	for(var/turf/blockTurf in raw_block)
		if(++batchIdx > batchsize)
			// reset the index so we start a new batch
			batchIdx = 0

			// sleep() on huge queries for performance
			// Why not every single one? Because sleep()s ain't free.
			sleep(-1)

		if(blockTurf.density && !allow_dense)
			continue

		var/list/ctx = list()

		ctx[output_key] = blockTurf
		contexts[++(contexts.len)] = ctx

	return contexts

