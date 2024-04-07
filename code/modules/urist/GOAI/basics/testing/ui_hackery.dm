// Extending the default controls for easier development

# define MODE_PASSTHRU 0
# define MODE_JUMPMOB  1
# define MODE_SELECT   2


/client
	var/mode = MODE_JUMPMOB

	// Proc (functional, not method) to call on click
	// Signature: same as /client/Click() except with the source client as the first arg
	//            (so: source, object, location, control, params)
	var/current_click_callback = null

	// Storing arbitrary data for the scallbacks
	var/list/blackboard = null


/client/Click(object, location, control, params)
	..(location, control, params)

	if(src.mode & MODE_SELECT)
		if(current_click_callback)
			call(current_click_callback)(src, object, location, control, params)


/client/DblClick(object, location, control, params)
	..(location, control, params)

	if(src.mode & MODE_JUMPMOB)
		// Make double-clicking an atom jump the mob there
		var/atom/trg = object
		if(istype(trg) && src.mob)
			if(istype(trg, /obj/vectorbeam))
				// those are ephemeral, if you jump to them you'll crash
				return

			Move(trg, get_dir(src.mob, trg))


/proc/_StoreClick_CBhelper(var/storage_key, var/store_as_str_ref = FALSE, var/client/src_client, var/object, var/location, var/control, var/params)
	// Not a proper callback, but a helper function for building them.
	// Stores the clicked item in the source client's memory
	// This would stop the clicked item GC, so use store_as_str_ref=TRUE and locate() to weakref it if necessary
	// A 'true' callback can use this by specifying a storage key and forwarding all its usual interface args.
	if(isnull(storage_key))
		return

	if(isnull(src_client))
		return

	if(isnull(object))
		return

	if(isnull(src_client.blackboard))
		src_client.blackboard = list()

	var/stored_val = (store_as_str_ref ? ref(object) : object)
	src_client.blackboard[storage_key] = stored_val
	return stored_val


/proc/_GetTwoArgs_CBhelper(var/binary_operator_proc, var/list/additional_args = null, var/client/src_client, var/object, var/location, var/control, var/params)
	// Not a proper callback, but a helper function for building them.
	// Stores two clicked items; once we have two, calls another proc passing them as arguments.

	if(isnull(src_client))
		return

	if(isnull(src_client.blackboard))
		src_client.blackboard = list()

	var/first = src_client.blackboard["first_clicked"]

	if(isnull(first))
		_StoreClick_CBhelper("first_clicked", FALSE, src_client, object, location, control, params)
		return

	var/second = src_client.blackboard["second_clicked"]

	if(isnull(second))
		second = _StoreClick_CBhelper("second_clicked", FALSE, src_client, object, location, control, params)

		if(isnull(second))
			return

	var/list/cbargs = list()
	cbargs.Add(first)
	cbargs.Add(second)

	if(!isnull(additional_args))
		cbargs.Add(additional_args)

	call(binary_operator_proc)(arglist(cbargs))

	src_client.blackboard["first_clicked"] = null
	src_client.blackboard["second_clicked"] = null

	return


// PrintPair, debug callback for testing callbacks
/proc/_print_pair(var/left, var/right)
	GOAI_LOG_DEVEL_WORLD("LEFT: [left] & RIGHT: [right]")
	return


/proc/PrintPairCB(var/client/src_client, var/object, var/location, var/control, var/params)
	if(isnull(src_client))
		return

	if(isnull(src_client.blackboard))
		src_client.blackboard = list()

	_GetTwoArgs_CBhelper(/proc/_print_pair, null, src_client, object, location, control, params)
	return


/mob/verb/TogglePrintPair()
	var/client/mobclient = src.client
	if(isnull(mobclient))
		GOAI_LOG_DEVEL_WORLD("Client for [src] is null!")
		return

	mobclient.mode ^= MODE_SELECT
	var/select_enabled = (mobclient.mode & MODE_SELECT)
	mobclient.current_click_callback = select_enabled ? /proc/PrintPairCB : null

	// for simplicity, wipe the blackboard anytime the callback changes
	mobclient.blackboard = list()

	GOAI_LOG_DEVEL_WORLD("Client [mobclient] [select_enabled ? "now" : "no longer"] does PrintPair...")
	return


// Give an order by clicking on an atom and passing the desired worldstate
/proc/CreateGoapSolverOrderCB(var/client/src_client, var/object, var/location, var/control, var/params)
	if(isnull(src_client))
		to_chat(usr, "src_client is null! @ L[__LINE__] in [__FILE__]!")
		return

	if(isnull(src_client.blackboard))
		src_client.blackboard = list()

	var/list/jsondata = src_client.blackboard["TargetState"]

	if(isnull(jsondata))
		return

	var/datum/utility_ai/mob_commander/commander = src_client.blackboard["TargetCommander"]

	if(isnull(commander))
		to_chat(usr, "Commander for [src_client] is null! @ L[__LINE__] in [__FILE__]!")
		return

	var/datum/brain/commander_brain = commander.brain

	if(isnull(commander_brain))
		to_chat(usr, "Brain for [commander] is null! @ L[__LINE__] in [__FILE__]!")
		return

	// goal_state, target, considerations
	var/datum/order_smartobject/new_order = new(jsondata, object, null)

	var/list/smart_orders = commander_brain.GetMemoryValue("SmartOrders", null) || list()

	if(smart_orders.len)
		// Try to keep this in slot 1 to avoid runaway array size
		smart_orders[1] = new_order
	else
		smart_orders.Add(new_order)

	commander_brain.SetMemory("SmartOrders", smart_orders)
	to_chat(usr, "Added order [new_order] with goal [jsondata]! @ L[__LINE__] in [__FILE__]!")
	src_client.current_click_callback = null
	return


/mob/verb/CommanderGiveGOAPSolverOrder(datum/utility_ai/mob_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
	set category = "Commander Orders"

	var/client/mobclient = src.client
	if(isnull(mobclient))
		to_chat(usr, "Client for [src] is null!")
		return

	if(isnull(M))
		return

	mobclient.mode ^= MODE_SELECT
	var/select_enabled = (mobclient.mode & MODE_SELECT)
	mobclient.current_click_callback = select_enabled ? /proc/CreateGoapSolverOrderCB : null

	// for simplicity, wipe the blackboard anytime the callback changes
	mobclient.blackboard = list()

	if(select_enabled)
		var/raw_jsondata = input(mobclient, "Enter target state (as JSON):") as message
		var/jsondata = json_decode(raw_jsondata)

		if(isnull(jsondata))
			to_chat(usr, "JSON Failed to parse: [raw_jsondata]")
			return

		mobclient.blackboard["TargetCommander"] = M
		mobclient.blackboard["TargetState"] = jsondata

	GOAI_LOG_DEVEL_WORLD("Client [mobclient] [select_enabled ? "now" : "no longer"] does CommanderGiveGOAPSolverOrder...")
	return


// Give a move order by clicking on an atom
/proc/CreateMoveOrderCB(var/client/src_client, var/object, var/location, var/control, var/params)
	if(isnull(src_client))
		to_chat(usr, "src_client is null! @ L[__LINE__] in [__FILE__]!")
		return

	var/datum/utility_ai/mob_commander/commander = src_client.blackboard["TargetCommander"]

	if(isnull(commander))
		to_chat(usr, "Commander for [src_client] is null! @ L[__LINE__] in [__FILE__]!")
		return

	var/datum/brain/commander_brain = commander.brain

	if(isnull(commander_brain))
		to_chat(usr, "Brain for [commander] is null! @ L[__LINE__] in [__FILE__]!")
		return

	var/turf/position = get_turf(object)
	if(!position)
		to_chat(usr, "Target position ([object]) does not exist!")
		return

	var/datum/memory/created_mem = commander_brain.SetMemory("ai_target", position, PLUS_INF)
	commander_brain.SetMemory("ai_target_mindist", 1, PLUS_INF)

	var/atom/waypoint = created_mem?.val

	to_chat(usr, (waypoint ? "[commander] now tracking [waypoint]" : "[commander] not tracking waypoints"))
	return


/mob/verb/CommanderGiveMoveOrderClick(datum/utility_ai/mob_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
	set category = "Commander Orders"

	var/client/mobclient = src.client
	if(isnull(mobclient))
		to_chat(usr, "Client for [src] is null!")
		return

	if(isnull(M))
		return

	mobclient.mode ^= MODE_SELECT
	var/select_enabled = (mobclient.mode & MODE_SELECT)
	mobclient.current_click_callback = select_enabled ? /proc/CreateMoveOrderCB : null

	// for simplicity, wipe the blackboard anytime the callback changes
	mobclient.blackboard = list()

	if(select_enabled)
		mobclient.blackboard["TargetCommander"] = M

	GOAI_LOG_DEVEL_WORLD("Client [mobclient] [select_enabled ? "now" : "no longer"] does CommanderGiveMoveOrderClick...")
	return
